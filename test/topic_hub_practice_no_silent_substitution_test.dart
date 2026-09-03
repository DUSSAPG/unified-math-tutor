import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/screens/practice/practice_screen.dart';

import 'support/topic_hub_practice_crash_test_utils.dart';

/// P0 crash regression — see
/// topic_hub_practice_navigator_key_regression_test.dart for the full root
/// cause writeup. This file covers "Do not regress the existing Topic
/// Drill truthfulness rules": the go()-based fix still hands Practice the
/// real topic id and the real stage the learner chose in the Hub — never
/// a silent substitution to some other topic/stage.
void main() {
  setUpAll(preloadCrashRegressionCatalogs);
  setUp(initCrashRegressionServices);

  testWidgets(
      'Topic Drill route still launches Practice with the right topic/stage '
      'preselected (no silent substitution)', (tester) async {
    await openHubFreshOnStatisticsProbability(tester);
    final topicDrill = activityCard('topicDrill');
    await tester.ensureVisible(topicDrill);
    await tester.tap(topicDrill);
    await tester.pumpAndSettle();

    expect(find.byType(PracticeScreen), findsOneWidget);
    final screen = tester.widget<PracticeScreen>(find.byType(PracticeScreen));
    expect(screen.selectedTopicId, 'statistics_probability');
    expect(screen.initialStage, 'KS5');
    expect(tester.takeException(), isNull);
  });
}
