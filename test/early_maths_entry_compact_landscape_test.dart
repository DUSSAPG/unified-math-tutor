import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/early_maths_lane.dart';
import 'package:unified_math_tutor/screens/labs/feed_panda/feed_the_hungry_panda_screen.dart';

import 'support/early_maths_entry_test_utils.dart';

/// Early Maths entry point at Pixel 6a compact landscape (915x412): the three
/// starting points sit side by side, every reachable card can be scrolled to
/// and tapped, and nothing overflows.
void main() {
  setUpAll(preloadCrashRegressionCatalogs);
  setUp(initEarlyMathsEntryServices);

  testWidgets('both lanes reachable and Panda launchable at 915x412',
      (tester) async {
    setTestViewportSize(tester, pixel6aLandscape);
    await pumpRealRoute(tester, earlyMathsHubRoute);
    expectHubPresent();

    // Side by side: all three tiles share a top edge on a wide viewport.
    final tops = [
      for (final lane in EarlyMathsLane.values)
        tester.getTopLeft(laneTile(lane)).dy,
    ];
    expect(tops.toSet(), hasLength(1),
        reason: 'The three starting points should sit in one row at 915 wide.');

    // First visit: gentle default, Panda only.
    expect(selectedLane(tester), isNull);
    expect(activityCardKeys(), {pandaCardKey});

    await chooseLane(tester, EarlyMathsLane.ks1MathsFoundations);
    expect(activityCardKeys(), {abacusCardKey, parentCardKey});
    expect(find.text('Preview'), findsNothing);
    expect(find.byKey(pandaCardKey), findsNothing);
    expectOnlyKnownCards(tester);
    expectNoPlannedOrOlderLearnerContent();

    await chooseLane(tester, EarlyMathsLane.earlyMathsPlay);
    expect(activityCardKeys(), {pandaCardKey, parentCardKey});
    expect(find.byKey(abacusCardKey), findsNothing);
    expectOnlyKnownCards(tester);
    expectNoPlannedOrOlderLearnerContent();

    // Panda is below the fold on a 412-high viewport and must still be
    // reachable by scrolling, then launchable.
    await tapCard(tester, pandaCardKey);
    expect(find.byType(FeedTheHungryPandaScreen), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expectHubPresent();

    expect(tester.takeException(), isNull);
  });
}
