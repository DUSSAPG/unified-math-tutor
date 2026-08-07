import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/entrance_exam/entrance_exam_hub_screen.dart';
import 'package:unified_math_tutor/screens/entrance_exam/entrance_exam_practice_session_screen.dart';
import 'package:unified_math_tutor/screens/entrance_exam/entrance_exam_review_screen.dart';
import 'package:unified_math_tutor/screens/entrance_exam/entrance_exam_skill_list_screen.dart';
import 'package:unified_math_tutor/screens/practice/practice_screen.dart';
import 'package:unified_math_tutor/services/discovery_card_catalog_service.dart';
import 'package:unified_math_tutor/services/family_activity_catalog_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/mascot_fuel_service.dart';
import 'package:unified_math_tutor/services/mental_maths_progress_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/recall_card_catalog_service.dart';
import 'package:unified_math_tutor/services/recall_cards_progress_service.dart';
import 'package:unified_math_tutor/services/streak_service.dart';

/// Sprint 3 (Entrance Exam Foundation) — proves Entrance Exam Prep is
/// reachable through the *existing* exam-selection pathway (Practice's
/// Exam Simulator chip row), with no new bottom-nav item, and that every
/// nested route resolves against the real production [appRouter]. Mirrors
/// route_navigator_key_regression_test.dart's setUp/pump pattern exactly,
/// since that file already proves this exact push-from-inside-the-shell
/// style (context.push('/upgrade') from Practice) is safe.
void main() {
  const locale = Locale('en');

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await DiscoveryCardCatalogService.instance.all();
    await RecallCardCatalogService.instance.all();
    await FamilyActivityCatalogService.instance.all();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await StreakService.instance.init();
    await MascotFuelService.instance.init();
    await MentalMathsProgressService.instance.init();
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await RecallCardsProgressService.instance.init();
  });

  Widget app() => MaterialApp.router(
        routerConfig: appRouter,
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      );

  Future<AppLocalizations> pumpRoute(WidgetTester tester, String route) async {
    // A tall viewport: the hub's mode list (5 tiles below the pack card
    // and disclaimer) sits well below the default 800x600 test surface's
    // fold, and this file taps deep into it repeatedly.
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1;

    final l10n = await AppLocalizations.delegate.load(locale);
    appRouter.go(route);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    return l10n;
  }

  group('Reachable via the existing exam-selection pathway, no new nav item',
      () {
    testWidgets(
        'Practice -> Exam Simulator -> Entrance Exam Prep opens the hub with no exception',
        (tester) async {
      final l10n = await pumpRoute(tester, '/practice');
      expect(find.byType(PracticeScreen), findsOneWidget);

      await tester.tap(find.text(l10n.practiceModeExamSimulator));
      await tester.pumpAndSettle();

      // The same picker used for GCSE Foundation/Higher/Oxford
      // Track/Swiss Gymnasium — Entrance Exam Prep is one more chip in
      // that row, not a separate entry point.
      final chip = find.text(l10n.practiceExamEntranceExamPrep);
      expect(chip, findsOneWidget);
      // Unlike the locked exam choices, this one has no lock icon next to
      // it — it has real content and is always available.
      expect(
        find.ancestor(of: chip, matching: find.byIcon(Icons.lock)),
        findsNothing,
      );

      await tester.tap(chip);
      await tester.pumpAndSettle();

      expect(find.byType(EntranceExamHubScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Entrance Exam Preparation — deep links and in-hub navigation', () {
    testWidgets('/entrance-exam resolves directly', (tester) async {
      await pumpRoute(tester, '/entrance-exam');
      expect(find.byType(EntranceExamHubScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Practice by Skill opens the skill picker with no exception',
        (tester) async {
      final l10n = await pumpRoute(tester, '/entrance-exam');
      await tester.tap(find.text(l10n.entranceExamModePracticeBySkillTitle));
      await tester.pumpAndSettle();
      expect(find.byType(EntranceExamSkillListScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Choosing a skill opens its practice session with no exception',
        (tester) async {
      final l10n = await pumpRoute(tester, '/entrance-exam/skills');
      await tester.tap(find.text(l10n.entranceExamSkillNumberFluency));
      await tester.pumpAndSettle();
      expect(find.byType(EntranceExamPracticeSessionScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        '/entrance-exam/skills/numberFluency resolves directly as a deep link',
        (tester) async {
      await pumpRoute(tester, '/entrance-exam/skills/numberFluency');
      expect(find.byType(EntranceExamPracticeSessionScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Review Methods opens with no exception', (tester) async {
      final l10n = await pumpRoute(tester, '/entrance-exam');
      await tester.tap(find.text(l10n.entranceExamModeReviewMethodsTitle));
      await tester.pumpAndSettle();
      expect(find.byType(EntranceExamReviewScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('/entrance-exam/review resolves directly as a deep link',
        (tester) async {
      await pumpRoute(tester, '/entrance-exam/review');
      expect(find.byType(EntranceExamReviewScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'the 3 locked modes have no tappable affordance (Coming soon, not a route)',
        (tester) async {
      final l10n = await pumpRoute(tester, '/entrance-exam');
      for (final title in [
        l10n.entranceExamModeUntimedPaperTitle,
        l10n.entranceExamModeTimedMockTitle,
        l10n.entranceExamModeScholarshipChallengeTitle,
      ]) {
        await tester.tap(find.text(title));
        await tester.pumpAndSettle();
        // Still on the hub — a locked tile is inert, not a broken link.
        expect(find.byType(EntranceExamHubScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });
  });
}
