import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/interactive_lab_id.dart';
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
import 'package:unified_math_tutor/services/tutor_credit_service.dart';

/// Production Polish Audit — every static (or single-sample-id) route in
/// `router.dart`, swept across the audit's 4 named device categories
/// (Mobile/Pixel 6a, Tablet, Web/Desktop, Landscape), asserting zero
/// exceptions — which, per Flutter's own contract, is exactly how a
/// RenderFlex overflow surfaces in a widget test (it throws during layout,
/// it does not just paint the yellow/black stripes and continue). This is
/// the single broadest overflow check in the suite; targeted regressions
/// for specific previously-found risks stay in their own files
/// (`rc1_responsive_hardening_test.dart`, `family_maths_layout_test.dart`,
/// `theme_representative_screens_test.dart`) rather than being folded in
/// here, so each can be run independently.
void main() {
  const mobilePixel6a = Size(412, 915);
  const tablet = Size(768, 1024);
  const webDesktop = Size(1280, 800);
  const landscape = Size(844, 390);

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await DiscoveryCardCatalogService.instance.all();
    await RecallCardCatalogService.instance.all();
    await FamilyActivityCatalogService.instance.all();
    SharedPreferences.setMockInitialValues({});
    await TutorCreditService.instance.init();
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
    await InteractiveLabsProgressService.instance
        .markFirstUseSeen(InteractiveLabId.footballPrecision);
    await InteractiveLabsProgressService.instance
        .markFirstUseSeen(InteractiveLabId.mazeDriver);
    await InteractiveLabsProgressService.instance
        .markFirstUseSeen(InteractiveLabId.flightPathLab);
    // Family Studio routes are PIN-gated; grace access is the same
    // established test bypass family_studio_hub_test.dart already uses.
    await OnboardingProfileService.instance.setUserType('parent');
    LocalPreferencesService.instance.grantFamilyStudioGraceAccess();
  });

  // Bounded pump sequence rather than pumpAndSettle() — several screens run
  // repeating Timers (e.g. Maze Driver's status clock) that never let
  // pumpAndSettle's "no more frames scheduled" condition converge. Matches
  // the same fix already applied in theme_representative_screens_test.dart.
  Future<void> pumpRoute(WidgetTester tester, String route, Size size) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;

    appRouter.go(route);
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: appRouter,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
    await tester.pump();
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }
  }

  // Every content route in router.dart, minus: `/splash` (transient),
  // `/` (a bare redirect to `/home`), and
  // `/math-studio/recall-cards/session` (requires a live `extra` selection
  // passed in-app, not a directly go()-able destination — already covered by
  // recall_cards_hub_screen's own widget tests). Parameterised routes use one
  // real, catalog-verified sample id each.
  const routes = <String, String>{
    // Onboarding & auth
    'Onboarding — user type': '/onboarding',
    'Onboarding — accessibility': '/onboarding/accessibility',
    'Onboarding — stage': '/onboarding/stage',
    'Onboarding — goal': '/onboarding/goal',
    'Onboarding — profile': '/onboarding/profile',
    'Onboarding — family role detail': '/onboarding/family/role-detail',
    'Onboarding — family learner context': '/onboarding/family/learner-context',
    'Onboarding — family goal': '/onboarding/family/goal',
    'Onboarding — family preferences': '/onboarding/family/preferences',
    'Sign in': '/auth/sign-in',
    'Create account': '/auth/create',
    'Forgot password': '/auth/forgot-password',

    // Home shell
    'Home': '/home',
    'Topics': '/topics',
    'Practice': '/practice',
    'Journey': '/journey',
    'Formula Library': '/formulas',
    'Profile': '/profile',
    'Profile — settings': '/profile/settings',
    'Profile — appearance': '/profile/appearance',
    'Profile — accessibility': '/profile/accessibility',
    'Profile — subscription': '/profile/subscription',
    'Profile — curriculum': '/profile/curriculum',
    'Profile — privacy': '/profile/privacy',
    'Profile — terms': '/profile/terms',
    'Tutor': '/tutor',
    'Help': '/help',
    'Help — parent/teacher tools': '/help/parent-teacher-tools',
    'Help — parent cheat sheet': '/help/parent-teacher-tools/cheat-sheet',
    'Help — Family Maths welcome': '/help/parent-teacher-tools/family-maths',
    'Help — Family Maths library':
        '/help/parent-teacher-tools/family-maths/library',
    'Help — Family Maths activity detail':
        '/help/parent-teacher-tools/family-maths/activity/build-twenty',

    // Root-navigator content routes
    'Exam Packs': '/packs',
    'Explore': '/explore',
    'Math Studio hub': '/math-studio',
    'Build Confidence': '/math-studio/build-confidence',
    'Mental Maths hub': '/math-studio/mental-maths',
    'Mental Maths category': '/math-studio/mental-maths/numberBonds',
    'Visual Maths hub': '/math-studio/visual-maths',
    'Visual Maths — number line': '/math-studio/visual-maths/number-line',
    'Visual Maths — fraction bars': '/math-studio/visual-maths/fraction-bars',
    'Visual Maths — abacus': '/math-studio/visual-maths/abacus',
    'Visual Maths — place value': '/math-studio/visual-maths/place-value',
    'Math Magic': '/math-studio/math-magic',
    'Spatial Intelligence': '/math-studio/spatial-intelligence',
    'Discovery Library': '/math-studio/discovery',
    'Discovery — card detail':
        '/math-studio/discovery/cooking-fraction-conversion',
    'Recall Cards hub': '/math-studio/recall-cards',
    'Recall Cards — browse': '/math-studio/recall-cards/browse',
    'Recall Cards — bookmarks': '/math-studio/recall-cards/bookmarks',
    'Recall Cards — card detail':
        '/math-studio/recall-cards/card/algebra-solve-linear-equation',
    'Interactive Labs hub': '/math-studio/interactive-labs',
    'Lab — Fraction Builder': '/math-studio/interactive-labs/fraction-builder',
    'Lab — Algebra Balance': '/math-studio/interactive-labs/algebra-balance',
    'Lab — Number Line Explorer':
        '/math-studio/interactive-labs/number-line-explorer',
    'Lab — Flight Path Lab': '/math-studio/interactive-labs/flight-path-lab',
    'Lab — Football Precision':
        '/math-studio/interactive-labs/football-precision',
    'Lab — Maze Driver': '/math-studio/interactive-labs/maze-driver',
    'Lab — Data Detective': '/math-studio/interactive-labs/data-detective',
    'Mental Math vault': '/mental-math',
    'Mental Math — trick detail': '/mental-math/multiply_by_11',
    'Daily Teaser': '/daily-teaser',
    'Tricks': '/tricks',
    'Upgrade': '/upgrade',
    'Release Notes': '/release-notes',

    // Family Studio (PIN-gated; grace access granted in setUp above)
    'Family Studio hub': '/family-studio',
    'Family Studio — today': '/family-studio/today',
    'Family Studio — homework companion': '/family-studio/homework-companion',
    'Family Studio — what your child is learning': '/family-studio/learning',
    'Family Studio — conversation starters':
        '/family-studio/conversation-starters',
    'Family Studio — progress snapshot': '/family-studio/progress',
    'Family Studio — tutor tools': '/family-studio/tutor-tools',
  };

  const deviceCategories = <String, Size>{
    'Mobile (Pixel 6a)': mobilePixel6a,
    'Tablet': tablet,
    'Web/Desktop': webDesktop,
    'Landscape': landscape,
  };

  for (final device in deviceCategories.entries) {
    group('${device.key} — no overflow/exception', () {
      for (final route in routes.entries) {
        testWidgets(route.key, (tester) async {
          await pumpRoute(tester, route.value, device.value);
          expect(tester.takeException(), isNull,
              reason: '${route.key} (${route.value}) at ${device.key} '
                  '(${device.value.width}x${device.value.height})');
        });
      }
    });
  }
}
