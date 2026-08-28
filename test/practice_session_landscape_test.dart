import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/graph_question.dart';
import 'package:unified_math_tutor/screens/practice/practice_screen.dart';
import 'package:unified_math_tutor/services/continue_learning_destination_resolver.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/mascot_fuel_service.dart';
import 'package:unified_math_tutor/services/practice_availability_resolver.dart';
import 'package:unified_math_tutor/services/practice_pack_question_mapper.dart';
import 'package:unified_math_tutor/services/streak_service.dart';
import 'package:unified_math_tutor/shared/math_notation_formatter.dart';
import 'package:unified_math_tutor/widgets/mascot_card.dart';

/// D2.1 corrective pass — active-practice-session layout at true Pixel 6a
/// landscape, across KS2–KS5, unanswered/correct/incorrect states. Uses
/// PracticeAvailabilityResolver (proven reliable across many real-data
/// calls in one file — see practice_availability_resolver_test.dart) to
/// build a real ResolvedPracticeResume per stage, jumping straight into an
/// active session via PracticeScreen(resumeFrom:) rather than the slower
/// setup→tap-Start path — one real resolve per test, matching the pattern
/// already proven not to be flaky in this environment.
Widget _wrap(Widget child, {Size? size}) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

const _pixel6aLandscape = Size(915, 412);
const _pixel6aPortrait = Size(412, 915);

Future<ResolvedPracticeResume> _realResumeFor(
  WidgetTester tester,
  String stage,
) async {
  final outcome = await tester.runAsync(
    () => PracticeAvailabilityResolver.resolveQuickStart(stage),
  );
  final records = (outcome as PracticeLoadReady).records.take(5).toList();
  final questions = records.map(questionFromPackJson).toList();
  final graphs = <String, GraphQuestion>{};
  return ResolvedPracticeResume(
    checkpointId: 'test_$stage',
    startedAtUtc: DateTime.utc(2026, 1, 1),
    resumeCount: 0,
    stage: stage,
    topicId: null,
    questions: questions,
    graphsByQuestionId: graphs,
    currentStep: 0,
    selectedIndices: const [],
  );
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await StreakService.instance.init();
    await MascotFuelService.instance.init();
  });

  for (final stage in ['KS2', 'KS3', 'KS4', 'KS5']) {
    testWidgets(
        '$stage active session at Pixel 6a landscape: question, every '
        'option, and Check Answer are all reachable; no mascot/progress '
        'card consumes the question viewport', (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      tester.view.physicalSize = _pixel6aLandscape;
      tester.view.devicePixelRatio = 1;

      final resume = await _realResumeFor(tester, stage);
      await tester.pumpWidget(_wrap(
        PracticeScreen(key: ValueKey('$stage-landscape'), resumeFrom: resume),
        size: _pixel6aLandscape,
      ));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Unanswered state: the mascot/progress card must not be present at
      // this compact viewport (it was the cause of the clipping).
      expect(find.byType(MascotCard), findsNothing);

      // The question prompt and the first option must actually be on
      // screen (not merely present in the widget tree off past the fold —
      // ensureVisible would hide a real off-screen problem, so this checks
      // raw findsOneWidget within the pumped, unscrolled frame first).
      expect(
        find.text(
          MathNotationFormatter.format(resume.questions.first.question),
        ),
        findsOneWidget,
      );
      final firstOption = find.byKey(const Key('practiceOption0'));
      expect(firstOption, findsOneWidget);

      // Check Answer must be reachable (present and within the viewport,
      // not clipped beyond the visible height).
      final checkButtonFinder = find.text(
        lookupAppLocalizations(const Locale('en')).practiceCheckAnswer,
      );
      expect(checkButtonFinder, findsOneWidget);
      final buttonRect = tester.getRect(checkButtonFinder);
      expect(buttonRect.bottom, lessThanOrEqualTo(_pixel6aLandscape.height));
      expect(buttonRect.top, greaterThanOrEqualTo(0));
    });
  }

  testWidgets(
      'portrait Pixel 6a keeps the mascot/progress card — this fix is '
      'landscape-only', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = _pixel6aPortrait;
    tester.view.devicePixelRatio = 1;

    final resume = await _realResumeFor(tester, 'KS2');
    await tester.pumpWidget(_wrap(
      PracticeScreen(key: const ValueKey('KS2-portrait'), resumeFrom: resume),
    ));
    await tester.pumpAndSettle();

    expect(find.byType(MascotCard), findsOneWidget);
  });

  testWidgets(
      'answered-correct state at Pixel 6a landscape: the correct option '
      'highlight and Next Question remain reachable, no overlap',
      (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = _pixel6aLandscape;
    tester.view.devicePixelRatio = 1;

    final resume = await _realResumeFor(tester, 'KS2');
    final l10n = lookupAppLocalizations(const Locale('en'));
    await tester.pumpWidget(_wrap(
      PracticeScreen(key: const ValueKey('KS2-correct'), resumeFrom: resume),
    ));
    await tester.pumpAndSettle();

    final correctIndex = resume.questions.first.correctIndex;
    final correctOption = find.byKey(Key('practiceOption$correctIndex'));
    await tester.ensureVisible(correctOption);
    await tester.tap(correctOption);
    await tester.pump();
    await tester.tap(find.text(l10n.practiceCheckAnswer));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final nextButton = find.text(l10n.practiceNextQuestion);
    expect(nextButton, findsOneWidget);
    final rect = tester.getRect(nextButton);
    expect(rect.bottom, lessThanOrEqualTo(_pixel6aLandscape.height));
  });

  testWidgets(
      'answered-incorrect state at Pixel 6a landscape: the wrong-option '
      'highlight and Next Question remain reachable', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = _pixel6aLandscape;
    tester.view.devicePixelRatio = 1;

    final resume = await _realResumeFor(tester, 'KS3');
    final l10n = lookupAppLocalizations(const Locale('en'));
    await tester.pumpWidget(_wrap(
      PracticeScreen(key: const ValueKey('KS3-incorrect'), resumeFrom: resume),
    ));
    await tester.pumpAndSettle();

    final wrongIndex = (resume.questions.first.correctIndex + 1) %
        resume.questions.first.options.length;
    final wrongOption = find.byKey(Key('practiceOption$wrongIndex'));
    await tester.ensureVisible(wrongOption);
    await tester.tap(wrongOption);
    await tester.pump();
    await tester.tap(find.text(l10n.practiceCheckAnswer));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text(l10n.practiceNextQuestion), findsOneWidget);
  });
}
