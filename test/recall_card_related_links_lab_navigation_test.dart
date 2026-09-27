import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/screens/labs/flight_path_lab_screen.dart';
import 'package:unified_math_tutor/screens/recall/recall_card_detail_screen.dart';
import 'package:unified_math_tutor/services/discovery_card_catalog_service.dart';
import 'package:unified_math_tutor/services/interactive_labs_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/recall_card_catalog_service.dart';
import 'package:unified_math_tutor/services/recall_cards_progress_service.dart';

import 'support/topic_hub_practice_crash_test_utils.dart';

/// The P0 repair, end to end: a Recall Card's related Interactive Lab chip
/// opens the real, shipped lab it names — `flight-lab` is the legacy catalog
/// id this card was authored with, resolved by [RecallCardLabLinkResolver]
/// to the real `flightPathLab`. Real router, real catalogues, real manifest.
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
    await InteractiveLabsProgressService.instance.init();
  });

  testWidgets(
      'the flight-lab chip opens the real Flight Path Lab, never "coming soon"',
      (tester) async {
    setTestViewportSize(tester, pixel6aPortrait);
    await pumpRealRoute(
        tester, '/math-studio/recall-cards/card/speed-distance-time-formula');
    expect(find.byType(RecallCardDetailScreen), findsOneWidget);
    await tester.tap(find.text('Reveal the answer'));
    await tester.pumpAndSettle();

    expect(find.text('Lab coming soon'), findsNothing);
    final chip = find.widgetWithText(ActionChip, 'flight-lab');
    await tester.ensureVisible(chip);
    await tester.pumpAndSettle();
    await tester.tap(chip);
    await tester.pumpAndSettle();

    expect(find.byType(FlightPathLabScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
