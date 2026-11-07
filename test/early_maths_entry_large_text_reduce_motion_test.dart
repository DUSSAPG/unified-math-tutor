import 'package:flutter/widgets.dart' show MediaQuery;
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/early_maths_lane.dart';
import 'package:unified_math_tutor/screens/labs/early_maths_playground_hub_screen.dart';
import 'package:unified_math_tutor/screens/labs/feed_panda/feed_the_hungry_panda_screen.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';

import 'support/early_maths_entry_test_utils.dart';

/// Early Maths entry point with Reduce Motion on and the largest system text
/// scale, in portrait and in Pixel 6a compact landscape. The screen has no
/// animation of its own, so Reduce Motion must simply change nothing; large
/// text must wrap and scroll rather than overflow or hide a card.
void main() {
  setUpAll(preloadCrashRegressionCatalogs);
  setUp(() async {
    await initEarlyMathsEntryServices();
    await LocalPreferencesService.instance.setReduceMotion(true);
  });
  tearDown(() async {
    await LocalPreferencesService.instance.setReduceMotion(false);
  });

  testWidgets(
      'no overflow and every reachable card still tappable at 2.0x text with '
      'Reduce Motion, portrait then landscape', (tester) async {
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    tester.platformDispatcher.textScaleFactorTestValue = 2.0;

    for (final size in [pixel6aPortrait, pixel6aLandscape]) {
      setTestViewportSize(tester, size);
      await pumpRealRoute(tester, earlyMathsHubRoute);
      expectHubPresent();
      expect(
        MediaQuery.textScalerOf(
          tester.element(find.byType(EarlyMathsPlaygroundHubScreen)),
        ).scale(10),
        20,
        reason: "The 2.0x text scale must actually be in effect.",
      );

      for (final lane in EarlyMathsLane.values) {
        await chooseLane(tester, lane);
        expect(selectedLane(tester), lane, reason: 'at $size');
        expectOnlyKnownCards(tester);
        expectNoPlannedOrOlderLearnerContent();
        expect(tester.takeException(), isNull,
            reason: 'Layout overflow at $size, lane $lane, 2.0x text.');
      }

      // Every card of the last-visited real lane can be scrolled to.
      await chooseLane(tester, EarlyMathsLane.earlyMathsPlay);
      for (final key in activityCardKeys()) {
        await tester.ensureVisible(find.byKey(key));
        await tester.pumpAndSettle();
        expect(find.byKey(key).hitTestable(), findsOneWidget,
            reason: 'Card $key not tappable at $size, 2.0x text.');
      }
    }

    // Still launches at 2.0x.
    await tapCard(tester, pandaCardKey);
    expect(find.byType(FeedTheHungryPandaScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
