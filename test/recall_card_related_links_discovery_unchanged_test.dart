import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/screens/discovery/discovery_card_detail_screen.dart';
import 'package:unified_math_tutor/screens/recall/recall_card_detail_screen.dart';
import 'package:unified_math_tutor/services/discovery_card_catalog_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/recall_card_catalog_service.dart';
import 'package:unified_math_tutor/services/recall_cards_progress_service.dart';

import 'support/topic_hub_practice_crash_test_utils.dart';

/// This repair only touches the Interactive Lab and Practice chips —
/// Discovery navigation was already real and must stay exactly as it was.
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

  testWidgets('the discovery chip still opens the real Discovery card',
      (tester) async {
    setTestViewportSize(tester, pixel6aPortrait);
    await pumpRealRoute(
        tester, '/math-studio/recall-cards/card/speed-distance-time-formula');
    expect(find.byType(RecallCardDetailScreen), findsOneWidget);
    await tester.tap(find.text('Reveal the answer'));
    await tester.pumpAndSettle();

    final chip =
        find.widgetWithText(ActionChip, 'aviation-speed-distance-time');
    await tester.ensureVisible(chip);
    await tester.pumpAndSettle();
    await tester.tap(chip);
    await tester.pumpAndSettle();

    expect(find.byType(DiscoveryCardDetailScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
