import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/topics/topic_learning_hub_screen.dart';
import 'package:unified_math_tutor/screens/topics/topics_screen.dart';
import 'package:unified_math_tutor/services/curriculum_service.dart';
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

import 'topic_learning_hub_test_utils.dart' show pumpUntilLoaded;

export 'topic_learning_hub_test_utils.dart' show activityCard, pumpUntilLoaded;

/// Shared helpers for the P0 navigator-key crash regression suite (real
/// KS5 Topic Drill -> Hub -> Quick Drill -> crash). Each scenario lives in
/// its own top-level test file rather than stacked in one — stacking
/// several real-router, real-asset-loading `testWidgets` in one file/
/// process reproducibly caused a card lookup to intermittently find
/// nothing on a LATER test's very first Hub visit (even though the same
/// lookup is reliable in isolation), matching the same "one real load per
/// file" constraint already established by
/// practice_screen_continue_learning_test.dart and
/// topic_learning_hub_test_utils.dart's own split Hub tests. This file
/// itself is never picked up by `flutter test` (no `main()`).
const testLocale = Locale('en');

Future<void> initCrashRegressionServices() async {
  SharedPreferences.setMockInitialValues({});
  await LocalPreferencesService.instance.init();
  await StreakService.instance.init();
  await MascotFuelService.instance.init();
  await MentalMathsProgressService.instance.init();
  await OnboardingProfileService.instance.init();
  await LearnerProfilesService.instance.init();
  await RecallCardsProgressService.instance.init();
  await CurriculumService.instance.select('ks5');
}

Future<void> preloadCrashRegressionCatalogs() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await DiscoveryCardCatalogService.instance.all();
  await RecallCardCatalogService.instance.all();
  await FamilyActivityCatalogService.instance.all();
}

Widget appWithRealRouter() => MaterialApp.router(
      routerConfig: appRouter,
      locale: testLocale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );

Future<void> pumpRealRoute(WidgetTester tester, String route) async {
  appRouter.go(route);
  await tester.pumpWidget(appWithRealRouter());
  await tester.pumpAndSettle();
}

/// Pixel 6a compact landscape — matches compact_landscape_nav_test.dart's
/// own `_pixel6aLandscape` constant/pattern.
const pixel6aLandscape = Size(915, 412);
const pixel6aPortrait = Size(412, 915);

void setTestViewportSize(WidgetTester tester, Size size) {
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
}

/// Tap without pumpAndSettle — the Hub shows a CircularProgressIndicator
/// while its capability rows resolve (real asset I/O), and an
/// indeterminate spinner never lets pumpAndSettle detect "settled".
/// pumpUntilLoaded (runAsync-driven) is used to wait it out instead.
Future<void> tapNoSettle(WidgetTester tester, String text) async {
  final finder = find.text(text);
  await tester.ensureVisible(finder);
  await tester.pump();
  await tester.tap(finder);
  await tester.pump();
}

/// Fresh Topics -> tap the real KS5 topic (Statistics & Probability — the
/// one non-premium topic with genuinely real Topic Drill content at KS5,
/// see topic_capability_resolver_test.dart's audited matrix) -> the Hub,
/// loaded. Re-entering via Topics each time (rather than trying to "go
/// back" to a previous Hub instance) matches the established, already-
/// proven precedent for a go()-reached shell destination — see
/// route_navigator_key_regression_test.dart's "repeated Explore
/// navigation" test and its comment on why: go() replaces the location, so
/// the screen that launched it is no longer on the stack to return to.
Future<void> openHubFreshOnStatisticsProbability(WidgetTester tester) async {
  await pumpRealRoute(tester, '/topics');
  expect(find.byType(TopicsScreen), findsOneWidget);
  await tapNoSettle(tester, 'Statistics & Probability');
  await pumpUntilLoaded(tester);
  expect(find.byType(TopicLearningHubScreen), findsOneWidget);
}
