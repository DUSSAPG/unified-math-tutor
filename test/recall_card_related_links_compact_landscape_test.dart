import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/screens/labs/data_detective_screen.dart';
import 'package:unified_math_tutor/services/curriculum_service.dart';
import 'package:unified_math_tutor/services/discovery_card_catalog_service.dart';
import 'package:unified_math_tutor/services/interactive_labs_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/recall_card_catalog_service.dart';
import 'package:unified_math_tutor/services/recall_cards_progress_service.dart';

import 'support/topic_hub_practice_crash_test_utils.dart';

/// The real-navigation Recall Card chips at Pixel 6a compact landscape
/// (915x412) and in portrait — every chip stays reachable and nothing
/// overflows now that the lab/discovery/practice chips are all real
/// `ActionChip`s in the same `Wrap`, rather than one of them being an inert
/// `Chip` with different sizing.
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
    await CurriculumService.instance.select('ks4');
  });

  testWidgets(
      'no overflow and every chip reachable in portrait, then compact '
      'landscape, and the lab chip still launches the real lab',
      (tester) async {
    // Navigated to once; the two sizes below simulate a rotation of the same
    // open card rather than two separate visits (go()-ing to the identical
    // current location a second time reuses the page instead of rebuilding
    // it, which would misreport this test's own reveal state, not a defect
    // in the app).
    setTestViewportSize(tester, pixel6aPortrait);
    await pumpRealRoute(
        tester, '/math-studio/recall-cards/card/stats-mean-formula');
    await tester.tap(find.text('Reveal the answer'));
    await tester.pumpAndSettle();

    for (final size in [pixel6aPortrait, pixel6aLandscape]) {
      setTestViewportSize(tester, size);
      await tester.pumpAndSettle();

      for (final label in [
        'cricket-batting-average', // discovery
        'statistics_probability', // practice
        'data-lab', // lab
      ]) {
        final finder = find.widgetWithText(ActionChip, label);
        await tester.ensureVisible(finder);
        await tester.pumpAndSettle();
        expect(finder, findsOneWidget, reason: 'at $size');
        final rect = tester.getRect(finder);
        expect(rect.left, greaterThanOrEqualTo(-0.5), reason: 'at $size');
        expect(rect.right, lessThanOrEqualTo(size.width + 0.5),
            reason: 'at $size');
      }
      expect(find.text('Lab coming soon'), findsNothing, reason: 'at $size');
      expect(tester.takeException(), isNull, reason: 'at $size');
    }

    // The lab chip is genuinely live at this compact size too.
    await tester.tap(find.widgetWithText(ActionChip, 'data-lab'));
    await tester.pumpAndSettle();
    expect(find.byType(DataDetectiveScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
