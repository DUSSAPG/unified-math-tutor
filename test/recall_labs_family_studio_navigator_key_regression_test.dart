import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/interactive_lab_id.dart';
import 'package:unified_math_tutor/screens/formulas/formula_library_screen.dart';
import 'package:unified_math_tutor/screens/topics/topics_screen.dart';
import 'package:unified_math_tutor/services/discovery_card_catalog_service.dart';
import 'package:unified_math_tutor/services/family_activity_catalog_service.dart';
import 'package:unified_math_tutor/services/interactive_labs_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/mascot_fuel_service.dart';
import 'package:unified_math_tutor/services/mental_maths_progress_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/recall_card_catalog_service.dart';
import 'package:unified_math_tutor/services/recall_cards_progress_service.dart';
import 'package:unified_math_tutor/services/streak_service.dart';

/// Regression coverage for the reported defect: a Flutter Navigator
/// key-reservation assertion ("!keyReservation.contains(key)") triggered by
/// Recall Card navigation. Root cause (same defect class as
/// route_navigator_key_regression_test.dart, a different set of call
/// sites): Recall Cards, Interactive Labs, and Family Studio all live
/// outside the bottom-nav shell (root-navigator routes under /math-studio
/// and /family-studio) — their "Related Practice" links and a few Family
/// Studio shortcuts were calling `context.push('/topics')` /
/// `context.push('/formulas')`, both shell-branch-owned root paths. A
/// push() there duplicates that branch's `GlobalKey<NavigatorState>` while
/// the shell's own still-mounted instance is using it. Fixed by switching
/// those exact call sites to `context.go()` (or, for the Homework
/// Companion's data-driven destinations, the new
/// `pushOrGoIfShellBranch` helper in lib/app/safe_navigation.dart).
///
/// Verified this suite actually catches the regression (not just a
/// vacuously-passing test) by reverting the recall_card_body.dart fix and
/// re-running: the single-tap "opens Topics with no exception" test does
/// NOT reproduce it — a widget test's very first `pumpWidget` never visits
/// a shell route first, so the shell branch isn't mounted yet and the
/// first push() has nothing to collide with. The "rapid repeat" test does
/// fail with the bug reverted (a `find.text('Reveal the answer')` finder
/// fails on the second cycle, because the first cycle's bad push() left
/// the router/shell in a broken state) — that's the test that actually
/// guards this regression; the others guard the fixed behaviour generally.
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
    await InteractiveLabsProgressService.instance.init();
    for (final id in InteractiveLabId.values) {
      await InteractiveLabsProgressService.instance.markFirstUseSeen(id);
    }
    // Family Studio routes are PIN-gated; grace access is the same
    // established test bypass family_studio_hub_test.dart already uses.
    await OnboardingProfileService.instance.setUserType('parent');
    LocalPreferencesService.instance.grantFamilyStudioGraceAccess();
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

  Future<void> pumpRoute(WidgetTester tester, String route) async {
    appRouter.go(route);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    final finder = find.text(text);
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  group('Recall Card detail -> Related Practice (the reported crash path)', () {
    testWidgets('opens Topics with no exception', (tester) async {
      await tester.runAsync(() async {
        await pumpRoute(tester,
            '/math-studio/recall-cards/card/speed-distance-time-formula');
        await tester.tap(find.text('Reveal the answer'));
        await tester.pumpAndSettle();

        await tapText(tester, 'ratio_proportion');
        expect(find.byType(TopicsScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    testWidgets(
        'rapid repeat: open card, reveal, related practice, back, open '
        'another card, repeat — no duplicate-route/GlobalKey exception',
        (tester) async {
      await tester.runAsync(() async {
        await pumpRoute(tester,
            '/math-studio/recall-cards/card/speed-distance-time-formula');
        await tester.tap(find.text('Reveal the answer'));
        await tester.pumpAndSettle();
        await tapText(tester, 'ratio_proportion');
        expect(tester.takeException(), isNull);

        await pumpRoute(
            tester, '/math-studio/recall-cards/card/num-order-of-operations');
        await tester.tap(find.text('Reveal the answer'));
        await tester.pumpAndSettle();
        await tapText(tester, 'number_place_value');
        expect(tester.takeException(), isNull);

        await pumpRoute(tester,
            '/math-studio/recall-cards/card/speed-distance-time-formula');
        await tester.tap(find.text('Reveal the answer'));
        await tester.pumpAndSettle();
        await tapText(tester, 'ratio_proportion');
        expect(tester.takeException(), isNull);
      });
    });
  });

  group('Interactive Lab -> Related Practice (same defect class)', () {
    testWidgets('Algebra Balance -> Related Practice opens Topics',
        (tester) async {
      await tester.runAsync(() async {
        await pumpRoute(
            tester, '/math-studio/interactive-labs/algebra-balance');
        await tapText(tester, 'algebra');
        expect(find.byType(TopicsScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });
  });

  group('Family Studio shortcuts (same defect class)', () {
    testWidgets(
        '"Explain This Method" opens Formula Library with go(), '
        'no exception', (tester) async {
      await tester.runAsync(() async {
        final l10n = await AppLocalizations.delegate.load(locale);
        await pumpRoute(tester, '/family-studio');
        await tapText(tester, l10n.familyStudioSectionExplainTitle);
        expect(find.byType(FormulaLibraryScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });
  });

  testWidgets(
      'switching Light/Dark/System theme before and during the Recall Card '
      'flow does not itself trigger a navigation exception', (tester) async {
    await tester.runAsync(() async {
      await LocalPreferencesService.instance.setThemeMode(ThemeMode.light);
      await pumpRoute(
          tester, '/math-studio/recall-cards/card/speed-distance-time-formula');
      expect(tester.takeException(), isNull);

      await LocalPreferencesService.instance.setThemeMode(ThemeMode.dark);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('Reveal the answer'));
      await tester.pumpAndSettle();

      await LocalPreferencesService.instance.setThemeMode(ThemeMode.system);
      await tester.pumpAndSettle();
      await tapText(tester, 'ratio_proportion');
      expect(find.byType(TopicsScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
