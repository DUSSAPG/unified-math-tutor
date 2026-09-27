import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/screens/recall/recall_card_detail_screen.dart';
import 'package:unified_math_tutor/screens/topics/topic_learning_hub_screen.dart';
import 'package:unified_math_tutor/screens/topics/topics_screen.dart';
import 'package:unified_math_tutor/services/curriculum_service.dart';
import 'package:unified_math_tutor/services/discovery_card_catalog_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/recall_card_catalog_service.dart';
import 'package:unified_math_tutor/services/recall_cards_progress_service.dart';

import 'support/topic_hub_practice_crash_test_utils.dart';

/// The P0 repair, end to end: a Recall Card's related Practice chip opens the
/// exact topic it names, via the real Topic Hub — available at the
/// learner's stage or honestly unavailable at that exact topic, never the
/// generic Topics list and never a substituted topic. Every navigation below
/// is a plain go() (matching how the chip itself navigates), so several
/// scenarios can share one real-router load safely.
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await DiscoveryCardCatalogService.instance.all();
    await RecallCardCatalogService.instance.all();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await RecallCardsProgressService.instance.init();
  });

  Future<void> openCardAndTapPractice(
      WidgetTester tester, String cardId, String topicId) async {
    await pumpRealRoute(tester, '/math-studio/recall-cards/card/$cardId');
    expect(find.byType(RecallCardDetailScreen), findsOneWidget);
    await tester.tap(find.text('Reveal the answer'));
    await tester.pumpAndSettle();
    final chip = find.widgetWithText(ActionChip, topicId);
    await tester.ensureVisible(chip);
    await tester.pumpAndSettle();
    await tester.tap(chip);
    // The Hub shows an indeterminate CircularProgressIndicator while its
    // capability rows resolve — pumpAndSettle never detects that as
    // settled (see topic_hub_practice_crash_test_utils.dart's own note),
    // so pump once and wait it out with pumpUntilLoaded instead.
    await tester.pump();
    await pumpUntilLoaded(tester);
    // Once the spinner is gone the remaining page-entry transition is
    // bounded, not indeterminate — settle it so the previous screen's
    // widgets (still present mid-transition) are gone before asserting.
    await tester.pumpAndSettle();
  }

  testWidgets(
      'the practice chip opens the exact named topic, honest either way',
      (tester) async {
    setTestViewportSize(tester, pixel6aPortrait);

    // --- KS3: ratio_proportion is genuinely available -----------------------
    await CurriculumService.instance.select('ks3');
    await openCardAndTapPractice(
        tester, 'speed-distance-time-formula', 'ratio_proportion');
    expect(find.byType(TopicLearningHubScreen), findsOneWidget);
    expect(find.byType(TopicsScreen), findsNothing,
        reason: 'must land on the Hub, not the generic Topics list');
    expect(find.textContaining('Real questions are available'), findsWidgets,
        reason: 'ratio_proportion has real content at KS3');

    // --- Same stage, a card naming two different topics: "decimals" --------
    // num-fraction-to-decimal names both fractions and decimals; at KS3
    // neither is available, so the exact topic tapped must show its own
    // honest state, not a shared/substituted one.
    await openCardAndTapPractice(tester, 'num-fraction-to-decimal', 'decimals');
    expect(find.byType(TopicLearningHubScreen), findsOneWidget);
    expect(find.text('Decimals'), findsWidgets,
        reason: 'the Hub header must name the exact topic tapped');
    expect(
      find.textContaining('No activities are available for this topic at KS3'),
      findsWidgets,
    );

    // --- ...and "fractions" from the very same card -------------------------
    await openCardAndTapPractice(
        tester, 'num-fraction-to-decimal', 'fractions');
    expect(find.text('Fractions'), findsWidgets,
        reason: 'a different chip on the same card must open a different '
            "topic's Hub, not the previous one");
    expect(
      find.textContaining('No activities are available for this topic at KS3'),
      findsWidgets,
      reason: 'fractions has no real content at KS3 either — same card, '
          'different topic, same honest pattern for THAT topic',
    );

    // --- Switch stage: fractions becomes genuinely available at KS2 --------
    await CurriculumService.instance.select('ks2');
    await openCardAndTapPractice(
        tester, 'num-fraction-to-decimal', 'fractions');
    expect(find.textContaining('Real questions are available'), findsWidgets,
        reason: 'fractions has real content at KS2');

    expect(tester.takeException(), isNull);
  });
}
