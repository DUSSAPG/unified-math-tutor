import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/family_maths/family_activity_detail_screen.dart';
import 'package:unified_math_tutor/screens/family_maths/family_maths_library_screen.dart';
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

/// Same 8-required-viewport contract used across this app's other RC1/RC2
/// layout suites (see the Football Maths Lab spec) — a subset of
/// math_studio_navigation_widget_test.dart's fuller 11-viewport list.
const _viewports = [
  Size(320, 568),
  Size(360, 640),
  Size(390, 844),
  Size(412, 915),
  Size(600, 960),
  Size(768, 1024),
  Size(844, 390),
  Size(1280, 800),
];

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
    await LocalPreferencesService.instance.setParentToolsEnabled(true);
    await LocalPreferencesService.instance.setParentPin('1234');
    LocalPreferencesService.instance.unlockParentTools('1234');
  });

  Future<AppLocalizations> pumpRoute(
    WidgetTester tester,
    String route, {
    double textScale = 1.0,
  }) async {
    final l10n = await AppLocalizations.delegate.load(locale);
    appRouter.go(route);
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: appRouter,
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return l10n;
  }

  testWidgets(
      'Family Maths Library (17 activities, unfiltered) renders without overflow at every required device size',
      (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final viewport in _viewports) {
      tester.view.physicalSize = viewport;
      tester.view.devicePixelRatio = 1;

      await pumpRoute(
          tester, '/help/parent-teacher-tools/family-maths/library');

      expect(find.byType(FamilyMathsLibraryScreen), findsOneWidget,
          reason: 'Library failed to load at $viewport');
      expect(tester.takeException(), isNull,
          reason: 'Overflow or render error at $viewport');
    }
  });

  testWidgets(
      'Family Maths Library and an activity detail screen render without overflow at 1.3x/1.6x/2.0x text scale',
      (tester) async {
    for (final scale in [1.3, 1.6, 2.0]) {
      await pumpRoute(
        tester,
        '/help/parent-teacher-tools/family-maths/library',
        textScale: scale,
      );
      expect(tester.takeException(), isNull,
          reason: 'Library overflow at ${scale}x text scale');

      await pumpRoute(
        tester,
        '/help/parent-teacher-tools/family-maths/activity/build-twenty',
        textScale: scale,
      );
      expect(find.byType(FamilyActivityDetailScreen), findsOneWidget);
      expect(tester.takeException(), isNull,
          reason: 'Detail screen overflow at ${scale}x text scale');
    }
  });

  testWidgets(
      'Family Maths detail screen renders without error when Reduce Motion is on',
      (tester) async {
    await LocalPreferencesService.instance.setReduceMotion(true);

    await pumpRoute(
        tester, '/help/parent-teacher-tools/family-maths/activity/cube-views');

    expect(find.byType(FamilyActivityDetailScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'category filter chips never expose an unauthored (empty) category',
      (tester) async {
    final l10n = await pumpRoute(
        tester, '/help/parent-teacher-tools/family-maths/library');

    // decimals/percentages/algebra/mentalMaths have zero authored activities
    // in the Phase 2 catalog — they must never appear as a filter chip,
    // which would lead a parent into a misleading empty screen.
    for (final unauthoredLabel in [
      l10n.familyMathsCategoryDecimals,
      l10n.familyMathsCategoryPercentages,
      l10n.familyMathsCategoryAlgebra,
      l10n.mathStudioMentalMathsTitle,
    ]) {
      expect(
        find.descendant(
          of: find.byKey(const Key('familyMathsCategoryChipRow')),
          matching: find.text(unauthoredLabel),
        ),
        findsNothing,
        reason: '"$unauthoredLabel" has no authored activity yet',
      );
    }

    // A representative sample of categories that DO have authored
    // activities must appear as chips. The chip row is a horizontal
    // ListView — off-screen chips aren't mounted until scrolled into view
    // (same gotcha already documented for the Discovery/Mental Maths hub
    // lists), so each must be scrolled to before it can be found.
    final chipScrollable = find.descendant(
      of: find.byKey(const Key('familyMathsCategoryChipRow')),
      matching: find.byType(Scrollable),
    );
    for (final authoredLabel in [
      l10n.familyMathsCategoryNumberSense,
      l10n.familyMathsCategoryFractions,
      l10n.familyMathsCategoryGeometry,
      l10n.familyMathsCategorySpatialReasoning,
    ]) {
      final finder = find.descendant(
        of: find.byKey(const Key('familyMathsCategoryChipRow')),
        matching: find.text(authoredLabel),
      );
      await tester.scrollUntilVisible(finder, 200, scrollable: chipScrollable);
      expect(finder, findsOneWidget,
          reason: '"$authoredLabel" should have a chip — it has an activity');
    }
  });
}
