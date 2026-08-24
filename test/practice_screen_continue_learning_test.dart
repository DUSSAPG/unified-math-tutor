import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/continue_learning_checkpoint.dart';
import 'package:unified_math_tutor/models/continue_learning_summary.dart';
import 'package:unified_math_tutor/models/practice_session_restoration_payload.dart';
import 'package:unified_math_tutor/screens/practice/practice_screen.dart';
import 'package:unified_math_tutor/services/continue_learning_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_account_scope_token_store.dart';
import 'package:unified_math_tutor/services/local_account_service.dart';
import 'package:unified_math_tutor/services/mascot_fuel_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/streak_service.dart';

/// Proof-flow tests for the [PracticeScreen] Continue Learning integration.
///
/// Split into two files (see `practice_screen_continue_learning_resume_test
/// .dart` for the resume/completion/missing-content scenarios) deliberately
/// scoped to one real Quick Start session start each: each session start
/// loads and parses a genuine ~10,000-line bundled JSONL pack, and stacking
/// several of those inside one `flutter test` process proved unreliable
/// under this machine's load during development — one real session start
/// per file/process matches what's proven to run reliably.
Widget _wrap(Widget child) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

Future<void> _initServices() async {
  await OnboardingProfileService.instance.init();
  await LearnerProfilesService.instance.init();
  await LocalAccountService.instance.init();
  await StreakService.instance.init();
  await MascotFuelService.instance.init();
  await ContinueLearningService.instance.init();
}

/// Pumps repeatedly, escaping into the real async zone between pumps via
/// [WidgetTester.runAsync], until [condition] is true or [maxIterations] is
/// reached. A plain `pumpAndSettle()` cannot reliably observe the real
/// asset-load Future `_startSession()`/`_loadSession()` kick off (loading
/// and parsing a genuine ~10,000-line bundled JSONL pack) resolving in this
/// test environment — escaping into the real zone via `runAsync` between
/// pumps is the documented fix for a widget test that needs to wait on
/// real, non-trivial async I/O rather than only microtasks/animation
/// frames.
Future<void> _pumpUntil(
  WidgetTester tester,
  bool Function() condition, {
  int maxIterations = 600,
}) async {
  await tester.pump();
  for (var i = 0; i < maxIterations && !condition(); i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();
  }
}

/// Taps answer option index 0 in the current question, via its stable key
/// (`practiceOption0` — see `_SessionView`'s option-tile `GestureDetector`)
/// rather than an ordinal `find.byType(GestureDetector)` index, which is
/// fragile: the session view's top bar has its own GestureDetector (the
/// "Exit" affordance) ahead of the option tiles in the widget tree.
Future<void> _tapFirstOption(WidgetTester tester) async {
  final option = find.byKey(const Key('practiceOption0'));
  await tester.ensureVisible(option);
  await tester.tap(option);
}

/// Selects Quick Start and taps Start — both live below the fold at the
/// default test viewport size, so each needs ensureVisible before tapping —
/// then waits for the real pack load to complete (see [_pumpUntil]).
Future<void> _startQuickStartSession(
    WidgetTester tester, AppLocalizations l10n) async {
  await tester.pumpWidget(_wrap(const PracticeScreen()));
  await tester.pumpAndSettle();
  final mode = find.text(l10n.practiceModeQuickStart);
  await tester.ensureVisible(mode);
  await tester.tap(mode);
  await tester.pumpAndSettle();
  final start = find.text(l10n.practiceStartButton);
  await tester.ensureVisible(start);
  await tester.tap(start);
  await _pumpUntil(
    tester,
    () => find.text(l10n.practiceCheckAnswer).evaluate().isNotEmpty,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final l10n = lookupAppLocalizations(const Locale('en'));

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await _initServices();
  });

  tearDown(() {
    ContinueLearningService.instance.resetForTests();
    LocalAccountScopeTokenStore.instance.resetForTests();
  });

  testWidgets(
      'full narrative: no checkpoint before progress, one saved after the '
      'first answer with real recoverable identifiers, and it survives '
      'leaving the session normally (Exit) — one real session start covers '
      'all three to keep this file\'s real-asset-loading cost down',
      (tester) async {
    await _startQuickStartSession(tester, l10n);

    // 1. Nothing meaningful has happened yet — no checkpoint.
    expect(find.text(l10n.practiceCheckAnswer), findsOneWidget,
        reason: 'session should have started');
    expect(ContinueLearningService.instance.status,
        ContinueLearningEvidenceStatus.noCheckpoint);

    // 2. Answer and advance past question 1 — a checkpoint appears with
    // real, recoverable identifiers.
    await _tapFirstOption(tester);
    await tester.pump();
    await tester.tap(find.text(l10n.practiceCheckAnswer));
    await _pumpUntil(
      tester,
      () => find.text(l10n.practiceNextQuestion).evaluate().isNotEmpty,
    );
    await tester.tap(find.text(l10n.practiceNextQuestion));
    await _pumpUntil(
      tester,
      () => find.text(l10n.practiceCheckAnswer).evaluate().isNotEmpty,
    );

    expect(ContinueLearningService.instance.status,
        ContinueLearningEvidenceStatus.checkpointAvailable);
    final checkpoint = ContinueLearningService.instance.currentCheckpoint!;
    expect(
        checkpoint.activityType, ContinueLearningActivityType.practiceSession);
    expect(checkpoint.currentStep, 1);
    expect(checkpoint.totalSteps, 10);
    expect(checkpoint.curriculumLevel, 'KS2');
    expect(checkpoint.resumeCount, 0);

    final payload = PracticeSessionRestorationPayload.tryDecode(
        checkpoint.restorationPayload);
    expect(payload, isNotNull);
    expect(payload!.questionIds, hasLength(10));
    expect(payload.selectedIndices, hasLength(1));
    expect(find.text(l10n.practiceQuestionOf(2, 10)), findsOneWidget);

    // 3. Leaving via the existing Exit affordance/dialog (not a new one
    // added for this task) retains the checkpoint — leaving normally is
    // not abandonment.
    await tester.tap(find.text(l10n.practiceExit));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, l10n.practiceExit));
    await _pumpUntil(
      tester,
      () => find.text(l10n.practiceStartButton).evaluate().isNotEmpty,
    );

    expect(ContinueLearningService.instance.status,
        ContinueLearningEvidenceStatus.checkpointAvailable,
        reason: 'leaving normally is not abandonment');
  });
}
