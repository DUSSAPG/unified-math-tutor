import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/screens/practice/practice_screen.dart';
import 'package:unified_math_tutor/screens/topics/topics_screen.dart';

import 'support/topic_hub_practice_crash_test_utils.dart';

/// P0 crash regression — see
/// topic_hub_practice_navigator_key_regression_test.dart for the full root
/// cause writeup. This file covers "Returning from that state must leave
/// navigation usable": system Back from Practice (reached via the Hub's
/// go()-based navigation) must not throw, and a fresh Topics entry must
/// still work afterwards.
void main() {
  setUpAll(preloadCrashRegressionCatalogs);
  setUp(initCrashRegressionServices);

  testWidgets(
      'system Back from Practice reached via the Hub does not crash '
      '(navigation stays usable afterwards)', (tester) async {
    await openHubFreshOnStatisticsProbability(tester);
    final topicDrill = activityCard('topicDrill');
    await tester.ensureVisible(topicDrill);
    await tester.tap(topicDrill);
    await tester.pumpAndSettle();
    expect(find.byType(PracticeScreen), findsOneWidget);

    final navigator = Navigator.of(tester.element(find.byType(PracticeScreen)));
    await navigator.maybePop();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // Navigation must stay usable afterwards — a fresh Topics entry still
    // works.
    await pumpRealRoute(tester, '/topics');
    expect(find.byType(TopicsScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
