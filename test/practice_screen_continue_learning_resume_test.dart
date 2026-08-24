import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/continue_learning_checkpoint.dart';
import 'package:unified_math_tutor/models/continue_learning_summary.dart';
import 'package:unified_math_tutor/models/practice_session_restoration_payload.dart';
import 'package:unified_math_tutor/screens/practice/practice_screen.dart';
import 'package:unified_math_tutor/services/continue_learning_destination_resolver.dart';
import 'package:unified_math_tutor/services/continue_learning_service.dart';
import 'package:unified_math_tutor/services/jsonl_pack_loader.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_account_scope_token_store.dart';
import 'package:unified_math_tutor/services/local_account_service.dart';
import 'package:unified_math_tutor/services/mascot_fuel_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/pack_registry_service.dart';
import 'package:unified_math_tutor/services/session_history_service.dart';
import 'package:unified_math_tutor/services/streak_service.dart';

/// Governed-resume proof-flow tests — see `practice_screen_continue_learning
/// _test.dart` for why this is a separate file (one real Quick Start
/// session start per file/process) and for the shared narrative covering
/// checkpoint creation itself.
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

Future<void> _tapFirstOption(WidgetTester tester) async {
  final option = find.byKey(const Key('practiceOption0'));
  await tester.ensureVisible(option);
  await tester.tap(option);
}

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
      'resumes into the same activity, same question set, same step, '
      'deterministic answer order, and continues updating from there',
      (tester) async {
    await _startQuickStartSession(tester, l10n);

    // Answer Q1 with option index 0.
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

    final savedCheckpoint = ContinueLearningService.instance.currentCheckpoint!;
    final savedPayload = PracticeSessionRestorationPayload.tryDecode(
        savedCheckpoint.restorationPayload)!;

    // Simulate process restart: fresh service state, same
    // SharedPreferences-backed storage.
    ContinueLearningService.instance.resetForTests();
    await _initServices();
    expect(ContinueLearningService.instance.status,
        ContinueLearningEvidenceStatus.checkpointAvailable);
    final reloadedCheckpoint =
        ContinueLearningService.instance.currentCheckpoint!;
    expect(reloadedCheckpoint.checkpointId, savedCheckpoint.checkpointId);

    final resolved = await tester.runAsync(
      () => ContinueLearningDestinationResolver.resolvePracticeSession(
        reloadedCheckpoint,
      ),
    );
    expect(resolved, isNotNull);
    expect(resolved!.questions.map((q) => q.id).toList(),
        savedPayload.questionIds);
    expect(resolved.currentStep, 1);
    expect(resolved.selectedIndices, savedPayload.selectedIndices);

    // Reopen through the governed resolver output — never a raw route.
    await tester.pumpWidget(
      _wrap(PracticeScreen(
          key: ValueKey(resolved.checkpointId), resumeFrom: resolved)),
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.practiceQuestionOf(2, 10)), findsOneWidget,
        reason: 'must resume at the next unanswered question, not restart');
    // _restoreFromResolvedResume saves the resumeCount bump unawaited (it's
    // called from the synchronous initState) — wait for that real
    // SharedPreferences write to land before asserting on it.
    await _pumpUntil(
      tester,
      () =>
          ContinueLearningService.instance.currentCheckpoint?.resumeCount == 1,
    );
    expect(ContinueLearningService.instance.currentCheckpoint!.resumeCount, 1,
        reason: 'resuming must increment resumeCount');

    // Continue answering — progress must keep updating, not duplicate the
    // first recorded answer.
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
      () => find.text(l10n.practiceQuestionOf(3, 10)).evaluate().isNotEmpty,
    );

    final updated = ContinueLearningService.instance.currentCheckpoint!;
    final updatedPayload = PracticeSessionRestorationPayload.tryDecode(
        updated.restorationPayload)!;
    expect(updated.currentStep, 2);
    expect(updatedPayload.selectedIndices, hasLength(2));
    expect(updatedPayload.questionIds, savedPayload.questionIds,
        reason: 'the question set itself must never change on resume');
  });

  testWidgets(
      'completing the final question removes the checkpoint and records '
      'the full session in history exactly once', (tester) async {
    final ids = await tester.runAsync(() async {
      final pack = await PackRegistryService.instance.forStage('KS2');
      final records = await JsonlPackLoader.instance.load(pack);
      return records
          .map((r) => r['id'] as String?)
          .whereType<String>()
          .take(3)
          .toList();
    });
    expect(ids, hasLength(3));

    // Construct a checkpoint already on the last question of a short
    // 3-question session, with the first 2 already answered — this
    // exercises real completion behaviour without needing to grind through
    // many rounds of UI interaction for an otherwise-identical mechanism
    // already covered by this file's other test.
    final checkpoint = ContinueLearningCheckpoint(
      schemaVersion: ContinueLearningCheckpoint.currentSchemaVersion,
      checkpointId: 'clc_completion_test',
      learnerScopeId: ContinueLearningService.instance.currentLearnerScopeId,
      activityType: ContinueLearningActivityType.practiceSession,
      contentVersion: 'ks2',
      curriculumLevel: 'KS2',
      topicId: null,
      currentStep: 2,
      totalSteps: 3,
      startedAtUtc: DateTime.now().toUtc(),
      updatedAtUtc: DateTime.now().toUtc(),
      resumeCount: 0,
      restorationPayload: const PracticeSessionRestorationPayload(
        questionIds: [],
        selectedIndices: [0, 0],
      ).toJson(),
    );
    await ContinueLearningService.instance.saveCheckpoint(
      checkpoint.copyWith(
        restorationPayload: PracticeSessionRestorationPayload(
          questionIds: ids!,
          selectedIndices: const [0, 0],
        ).toJson(),
      ),
    );

    final resolved = await tester.runAsync(
      () => ContinueLearningDestinationResolver.resolvePracticeSession(
        ContinueLearningService.instance.currentCheckpoint!,
      ),
    );
    expect(resolved, isNotNull);
    expect(resolved!.currentStep, 2);

    final historyBefore = await SessionHistoryService.instance.load();
    expect(historyBefore, isEmpty);

    await tester.pumpWidget(_wrap(PracticeScreen(
        key: ValueKey(resolved.checkpointId), resumeFrom: resolved)));
    await tester.pumpAndSettle();
    expect(find.text(l10n.practiceQuestionOf(3, 3)), findsOneWidget);

    await _tapFirstOption(tester);
    await tester.pump();
    await tester.tap(find.text(l10n.practiceCheckAnswer));
    await _pumpUntil(
      tester,
      () => find.text(l10n.practiceFinishSession).evaluate().isNotEmpty,
    );
    // Last question: the button now reads "Finish Session".
    await tester.tap(find.text(l10n.practiceFinishSession));
    await _pumpUntil(
      tester,
      () =>
          ContinueLearningService.instance.status ==
          ContinueLearningEvidenceStatus.noCheckpoint,
    );

    expect(ContinueLearningService.instance.status,
        ContinueLearningEvidenceStatus.noCheckpoint);
    final historyAfter = await SessionHistoryService.instance.load();
    expect(historyAfter, hasLength(1));
    expect(historyAfter.first.questions, hasLength(3),
        reason: 'the completed session record must include the '
            'pre-restart answers, not only the post-resume ones');
  });

  testWidgets(
      'a checkpoint whose content no longer exists resolves to '
      'unavailable rather than resuming into different content',
      (tester) async {
    final checkpoint = ContinueLearningCheckpoint(
      schemaVersion: ContinueLearningCheckpoint.currentSchemaVersion,
      checkpointId: 'clc_missing_content',
      learnerScopeId: ContinueLearningService.instance.currentLearnerScopeId,
      activityType: ContinueLearningActivityType.practiceSession,
      contentVersion: 'ks2',
      curriculumLevel: 'KS2',
      topicId: null,
      currentStep: 0,
      totalSteps: 1,
      startedAtUtc: DateTime.now().toUtc(),
      updatedAtUtc: DateTime.now().toUtc(),
      resumeCount: 0,
      restorationPayload: const PracticeSessionRestorationPayload(
        questionIds: ['content-that-was-removed'],
        selectedIndices: [],
      ).toJson(),
    );
    await ContinueLearningService.instance.saveCheckpoint(checkpoint);

    final resolved = await tester.runAsync(
      () => ContinueLearningDestinationResolver.resolvePracticeSession(
        ContinueLearningService.instance.currentCheckpoint!,
      ),
    );
    expect(resolved, isNull);
  });
}
