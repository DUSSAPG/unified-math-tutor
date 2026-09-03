import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/screens/practice/practice_screen.dart';

import 'support/topic_hub_practice_crash_test_utils.dart';

/// P0 crash regression — see
/// topic_hub_practice_navigator_key_regression_test.dart for the full root
/// cause writeup. Pixel 6a portrait variant of the exact reported sequence.
void main() {
  setUpAll(preloadCrashRegressionCatalogs);
  setUp(initCrashRegressionServices);

  testWidgets(
      'KS5 Topic Drill -> Hub -> Quick Drill does not crash at Pixel 6a '
      'portrait', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await openHubFreshOnStatisticsProbability(tester);
    final topicDrill = activityCard('topicDrill');
    await tester.ensureVisible(topicDrill);
    await tester.tap(topicDrill);
    await tester.pumpAndSettle();
    expect(find.byType(PracticeScreen), findsOneWidget);
    expect(tester.takeException(), isNull);

    await openHubFreshOnStatisticsProbability(tester);
    final quickStart = activityCard('quickStart');
    await tester.ensureVisible(quickStart);
    await tester.tap(quickStart);
    await tester.pumpAndSettle();
    expect(find.byType(PracticeScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
