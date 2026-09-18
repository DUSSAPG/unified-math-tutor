import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/screens/topics/ratio_foundations_screen.dart';
import 'package:unified_math_tutor/services/curriculum_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/mascot_fuel_service.dart';
import 'package:unified_math_tutor/services/mental_maths_progress_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/recall_cards_progress_service.dart';
import 'package:unified_math_tutor/services/streak_service.dart';

import 'support/topic_hub_practice_crash_test_utils.dart';

/// Real appRouter, one real Hub load: KS3 Ratio & Proportion is the ONLY
/// place the "Ratio scaling foundations" card is reachable from, existing
/// Topic Drill/Quick Start cards remain present alongside it (not
/// replaced), and tapping it genuinely navigates to RatioFoundationsScreen.
void main() {
  setUpAll(preloadCrashRegressionCatalogs);
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await StreakService.instance.init();
    await MascotFuelService.instance.init();
    await MentalMathsProgressService.instance.init();
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await RecallCardsProgressService.instance.init();
    await CurriculumService.instance.select('ks3');
  });

  testWidgets(
      'KS3 Ratio & Proportion Hub shows the Ratio scaling foundations card '
      'alongside the existing Topic Drill/Quick Start cards, and tapping '
      'it opens RatioFoundationsScreen', (tester) async {
    await pumpRealRoute(tester, '/topics');
    await tapNoSettle(tester, 'Ratio & Proportion');
    await pumpUntilLoaded(tester);

    expect(activityCard('topicDrill'), findsOneWidget,
        reason: 'existing Topic Drill card must remain present, unchanged');
    expect(activityCard('quickStart'), findsOneWidget,
        reason: 'existing Quick Start card must remain present, unchanged');
    final ratioCard =
        find.byKey(const ValueKey('topicHubRatioFoundationsCard'));
    expect(ratioCard, findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(ratioCard);
    await tester.tap(ratioCard);
    await tester.pumpAndSettle();

    expect(find.byType(RatioFoundationsScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
