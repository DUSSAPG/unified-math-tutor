import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/screens/practice/practice_screen.dart';

import 'support/topic_hub_practice_crash_test_utils.dart';

/// P0 crash regression — see
/// topic_hub_practice_navigator_key_regression_test.dart for the full root
/// cause writeup. This file covers the explicit requirement "Repeated
/// Topic -> Hub -> Practice -> Back -> Quick Drill transitions must not
/// crash" by alternating Topic Drill and Quick Start launches five times
/// in a row.
void main() {
  setUpAll(preloadCrashRegressionCatalogs);
  setUp(initCrashRegressionServices);

  testWidgets(
      'repeated Topic -> Hub -> Practice -> back -> Quick Drill transitions '
      'do not crash, alternating Topic Drill and Quick Start five times',
      (tester) async {
    Future<void> viaTopicDrill() async {
      await openHubFreshOnStatisticsProbability(tester);
      final card = activityCard('topicDrill');
      await tester.ensureVisible(card);
      await tester.tap(card);
      await tester.pumpAndSettle();
      expect(find.byType(PracticeScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    }

    Future<void> viaQuickStart() async {
      await openHubFreshOnStatisticsProbability(tester);
      final card = activityCard('quickStart');
      await tester.ensureVisible(card);
      await tester.tap(card);
      await tester.pumpAndSettle();
      expect(find.byType(PracticeScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    }

    await viaTopicDrill();
    await viaQuickStart();
    await viaTopicDrill();
    await viaQuickStart();
    await viaTopicDrill();
  });
}
