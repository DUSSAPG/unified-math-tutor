import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/explore/explore_math_intelligence_screen.dart';
import 'package:unified_math_tutor/screens/formulas/formula_library_screen.dart';
import 'package:unified_math_tutor/screens/journey/journey_screen.dart';
import 'package:unified_math_tutor/screens/math_studio/math_studio_hub_screen.dart';
import 'package:unified_math_tutor/screens/onboarding/accessibility_step_screen.dart';
import 'package:unified_math_tutor/screens/packs/exam_packs_screen.dart';
import 'package:unified_math_tutor/screens/practice/practice_screen.dart';
import 'package:unified_math_tutor/screens/settings/accessibility_screen.dart';
import 'package:unified_math_tutor/screens/topics/topics_screen.dart';
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

/// Regression coverage for the release-blocking defect: "A GlobalKey was
/// used multiple times inside one widget's child list" (parent widget:
/// HeroControllerScope), reported when opening destinations from Explore
/// Math Intelligence.
///
/// Root cause (see the ownership-model comment above the navigator keys in
/// lib/app/router.dart): calling context.push(path) — instead of
/// context.go(path) — for a path owned by a StatefulShellBranch (Home,
/// Topics, Practice, Journey, Formula Library, Profile, Tutor, Help), from a
/// screen that lives outside the shell (Explore is one such screen, pushed
/// above the bottom-nav shell), forces go_router to build a second instance
/// of the whole shell subtree, reusing an already-mounted branch
/// `GlobalKey<NavigatorState>` a second time. Reproduced directly against
/// `appRouter` during triage (before this test existed): push('/formulas')
/// and push('/journey') from an outside-shell location both threw this
/// exact assertion; go() from the same place did not; branch-to-branch push
/// while already inside the shell did not either. This suite locks in the
/// fixed behaviour (Explore's shell-tab cards already use go()) and
/// exercises the wider Phase 5 smoke matrix (deep-link restoration, repeat
/// navigation, PIN-gated Family Maths, non-shell push destinations).
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
    final l10n = await AppLocalizations.delegate.load(locale);
    appRouter.go(route);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    return l10n;
  }

  // Explore is a scrolling list of cards — later cards (Formula Library,
  // Math Studio, ...) sit below the default test viewport and can't be
  // tapped without first scrolling them into view.
  Future<void> tapText(WidgetTester tester, String text) async {
    final finder = find.text(text);
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  group('Explore -> shell-branch destinations (the reported crash path)', () {
    testWidgets('Personalised Practice opens Practice with no exception',
        (tester) async {
      final l10n = await pumpRoute(tester, '/explore');
      await tapText(tester, l10n.explorePersonalisedPracticeTitle);
      expect(find.byType(PracticeScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Topic Learning opens Topics with no exception',
        (tester) async {
      final l10n = await pumpRoute(tester, '/explore');
      await tapText(tester, l10n.exploreTopicLearningTitle);
      expect(find.byType(TopicsScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('My Maths Journey opens Journey with no exception',
        (tester) async {
      final l10n = await pumpRoute(tester, '/explore');
      await tapText(tester, l10n.exploreMathsJourneyTitle);
      expect(find.byType(JourneyScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Learning Analytics also opens Journey with no exception',
        (tester) async {
      final l10n = await pumpRoute(tester, '/explore');
      await tapText(tester, l10n.learningAnalyticsTitle);
      expect(find.byType(JourneyScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'Formula Library opens with no exception (the exact route named in the report)',
        (tester) async {
      final l10n = await pumpRoute(tester, '/explore');
      await tapText(tester, l10n.homeFormulaLibraryTitle);
      expect(find.byType(FormulaLibraryScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Explore -> non-shell destinations (unaffected, may keep push())', () {
    testWidgets('Timed Challenges opens Mental Maths with no exception',
        (tester) async {
      final l10n = await pumpRoute(tester, '/explore');
      await tapText(tester, l10n.exploreTimedChallengesTitle);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Exam Simulator opens Exam Packs with no exception',
        (tester) async {
      final l10n = await pumpRoute(tester, '/explore');
      await tapText(tester, l10n.exploreExamSimulatorTitle);
      expect(find.byType(ExamPacksScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Math Studio opens with no exception', (tester) async {
      final l10n = await pumpRoute(tester, '/explore');
      await tapText(tester, l10n.mathStudioNavCardTitle);
      expect(find.byType(MathStudioHubScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets(
      'repeated Explore navigation: Formula Library, back to Explore, Journey, back, Formula Library again',
      (tester) async {
    final l10n = await pumpRoute(tester, '/explore');
    expect(find.byType(ExploreMathIntelligenceScreen), findsOneWidget);

    await tapText(tester, l10n.homeFormulaLibraryTitle);
    expect(find.byType(FormulaLibraryScreen), findsOneWidget);
    expect(tester.takeException(), isNull);

    // go() replaced the location — Explore is no longer on the stack to pop
    // back to (this is the correct trade-off of the fix: a shell-tab
    // destination is now a location switch, not a stacked modal). Re-enter
    // Explore fresh, matching how a user would tap back into it from the
    // shell's own navigation.
    await pumpRoute(tester, '/explore');
    await tapText(tester, l10n.exploreMathsJourneyTitle);
    expect(find.byType(JourneyScreen), findsOneWidget);
    expect(tester.takeException(), isNull);

    await pumpRoute(tester, '/explore');
    await tapText(tester, l10n.homeFormulaLibraryTitle);
    expect(find.byType(FormulaLibraryScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  group(
      'Direct deep-link / browser-refresh restoration (fresh boot, no prior navigation)',
      () {
    testWidgets('/formulas resolves directly', (tester) async {
      await pumpRoute(tester, '/formulas');
      expect(find.byType(FormulaLibraryScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('/onboarding/accessibility resolves directly', (tester) async {
      await pumpRoute(tester, '/onboarding/accessibility');
      expect(find.byType(AccessibilityStepScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('/profile/accessibility resolves directly', (tester) async {
      await pumpRoute(tester, '/profile/accessibility');
      expect(find.byType(AccessibilityScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        '/help/parent-teacher-tools/family-maths resolves directly (PIN gate shown, no crash)',
        (tester) async {
      final l10n =
          await pumpRoute(tester, '/help/parent-teacher-tools/family-maths');
      expect(find.text(l10n.parentToolsPinPrompt), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        '/math-studio/discovery/cooking-fraction-conversion resolves directly',
        (tester) async {
      await pumpRoute(
          tester, '/math-studio/discovery/cooking-fraction-conversion');
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets(
      'branch-to-branch push while already inside the shell stays safe (Topics -> push Practice)',
      (tester) async {
    // Documents the other half of the invariant: push() is only dangerous
    // from OUTSIDE the shell. From inside it (both branches already
    // mounted), push() between branches is fine and does not need go().
    await pumpRoute(tester, '/topics');
    appRouter.push('/practice');
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
