import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/entrance_exam/entrance_exam_hub_screen.dart';
import 'package:unified_math_tutor/screens/entrance_exam/entrance_exam_practice_session_screen.dart';
import 'package:unified_math_tutor/screens/entrance_exam/entrance_exam_review_screen.dart';
import 'package:unified_math_tutor/screens/entrance_exam/entrance_exam_skill_list_screen.dart';
import 'package:unified_math_tutor/services/entrance_exam_pack_catalog_service.dart';
import 'package:unified_math_tutor/services/entrance_exam_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';

/// Sprint 3 (Entrance Exam Foundation) isolated screen-content tests — no
/// go_router, mirroring discovery_card_detail_widget_test.dart's style.
/// Navigation-through-the-real-router coverage lives in
/// entrance_exam_navigation_test.dart.
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await EntranceExamPackCatalogService.instance.all();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await LearnerProfilesService.instance.init();
    await EntranceExamProgressService.instance.init();
  });

  Widget wrap(Widget child) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );
  }

  group('EntranceExamHubScreen', () {
    testWidgets('renders the pack, its disclaimer, and all 5 mode tiles',
        (tester) async {
      await tester.pumpWidget(wrap(const EntranceExamHubScreen()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(
        find.text('Independent School Year 7 Mathematics — Foundation Pack'),
        findsOneWidget,
      );
      expect(
          find.byKey(const Key('entranceExamDisclaimerText')), findsOneWidget);
      expect(
          find.text(l10n.entranceExamModePracticeBySkillTitle), findsOneWidget);
      expect(
          find.text(l10n.entranceExamModeReviewMethodsTitle), findsOneWidget);
      expect(find.text(l10n.entranceExamModeUntimedPaperTitle), findsOneWidget);
      expect(find.text(l10n.entranceExamModeTimedMockTitle), findsOneWidget);
      expect(find.text(l10n.entranceExamModeScholarshipChallengeTitle),
          findsOneWidget);
    });

    testWidgets(
        'the 3 full-paper modes show the locked badge; the 2 content-backed modes do not',
        (tester) async {
      await tester.pumpWidget(wrap(const EntranceExamHubScreen()));
      await tester.pumpAndSettle();

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      // Exactly 3 "Coming soon" badges: Untimed Paper, Timed Mock,
      // Scholarship Challenge — Practice by Skill and Review Methods are
      // both content-backed (12 questions authored) and must not show it.
      expect(find.text(l10n.entranceExamModeLockedBadge), findsNWidgets(3));
    });
  });

  group('EntranceExamSkillListScreen', () {
    testWidgets('lists all 6 skills with their authored question counts',
        (tester) async {
      await tester.pumpWidget(wrap(const EntranceExamSkillListScreen()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text(l10n.entranceExamSkillNumberFluency), findsOneWidget);
      expect(
        find.text(l10n.entranceExamSkillFractionsAndPercentages),
        findsOneWidget,
      );
      expect(
          find.text(l10n.entranceExamSkillRatioAndProportion), findsOneWidget);
      expect(
          find.text(l10n.entranceExamSkillAlgebraicReasoning), findsOneWidget);
      expect(find.text(l10n.entranceExamSkillShapeAndSpace), findsOneWidget);
      expect(find.text(l10n.entranceExamSkillDataAndLogic), findsOneWidget);
      // Each of the 6 skills has exactly 2 authored questions.
      expect(find.text(l10n.entranceExamSkillQuestionCountLabel(2)),
          findsNWidgets(6));
    });
  });

  group('EntranceExamPracticeSessionScreen', () {
    testWidgets(
        'Think -> Reveal -> method-mark buttons -> next question -> completion',
        (tester) async {
      await tester.pumpWidget(wrap(
        const EntranceExamPracticeSessionScreen(skillId: 'numberFluency'),
      ));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      // Question 1 of 2: Think state first, no worked method yet.
      expect(find.text(l10n.entranceExamQuestionOf(1, 2)), findsOneWidget);
      expect(
          find.byKey(const Key('entranceExamQuestionPrompt')), findsOneWidget);
      expect(find.byKey(const Key('entranceExamWorkedMethod')), findsNothing);
      expect(find.text(l10n.entranceExamMethodMarkCorrect), findsNothing);

      await tester.tap(find.text(l10n.entranceExamRevealMethodButton));
      await tester.pumpAndSettle();

      // All 5 method-mark outcome buttons appear after reveal.
      expect(find.byKey(const Key('entranceExamWorkedMethod')), findsOneWidget);
      for (final key in [
        'entranceExamMark_correct',
        'entranceExamMark_methodWithSlip',
        'entranceExamMark_partialReasoning',
        'entranceExamMark_unsupported',
        'entranceExamMark_blank',
      ]) {
        expect(find.byKey(Key(key)), findsOneWidget);
      }

      await tester.tap(find.byKey(const Key('entranceExamMark_correct')));
      await tester.pumpAndSettle();

      // Question 2 of 2: back to Think state (reveal resets per question).
      expect(find.text(l10n.entranceExamQuestionOf(2, 2)), findsOneWidget);
      expect(find.byKey(const Key('entranceExamWorkedMethod')), findsNothing);

      await tester.tap(find.text(l10n.entranceExamRevealMethodButton));
      await tester.pumpAndSettle();
      await tester
          .tap(find.byKey(const Key('entranceExamMark_methodWithSlip')));
      await tester.pumpAndSettle();

      // Completion view with an estimated marks summary.
      expect(tester.takeException(), isNull);
      expect(find.text(l10n.entranceExamSessionCompleteTitle), findsOneWidget);
      expect(find.byKey(const Key('entranceExamEstimatedMarksText')),
          findsOneWidget);
    });

    testWidgets('an empty-skill session completes immediately, no blank screen',
        (tester) async {
      await tester.pumpWidget(wrap(
        const EntranceExamPracticeSessionScreen(skillId: 'not-a-real-skill'),
      ));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text(l10n.entranceExamSessionCompleteTitle), findsOneWidget);
    });
  });

  group('EntranceExamReviewScreen', () {
    testWidgets(
        'lists every authored question and reveals worked methods with no marking UI',
        (tester) async {
      // A tall custom viewport so all 12 review cards are actually built
      // (the ListView's Viewport only mounts Elements within its cache
      // extent, regardless of the fixed-children vs builder delegate —
      // the default 800x600 test surface only fits ~4 of these cards).
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      tester.view.physicalSize = const Size(800, 6000);
      tester.view.devicePixelRatio = 1;

      await tester.pumpWidget(wrap(const EntranceExamReviewScreen()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      // 12 authored questions -> 12 reveal buttons, one per question.
      expect(find.text(l10n.entranceExamRevealMethodButton), findsNWidgets(12));
      expect(find.text(l10n.entranceExamMethodMarkCorrect), findsNothing,
          reason: 'Review Methods is pure review — no self-marking UI.');

      await tester.tap(find.text(l10n.entranceExamRevealMethodButton).first);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byKey(const Key('entranceExamReviewWorkedMethod')),
          findsOneWidget);
      // The one revealed tile's button is gone; 11 unrevealed remain.
      expect(find.text(l10n.entranceExamRevealMethodButton), findsNWidgets(11));
    });
  });
}
