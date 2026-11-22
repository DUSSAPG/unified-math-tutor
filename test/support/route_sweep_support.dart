import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

/// Shared route catalogue and service setup for the real-router overflow
/// sweeps (`polish_audit_overflow_sweep_test.dart` at 1.0x and
/// `system_text_scaling_sweep_test.dart` at Android system 1.3x/1.6x). This
/// file has no `main()`, so `flutter test` never runs it on its own.

const polishAuditRoutes = <String, String>{
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

/// Registers the catalogue preloads and per-test service resets every route
/// in [polishAuditRoutes] needs. Call once at the top of `main()`.
void registerRouteSweepSetUp() {
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
}
