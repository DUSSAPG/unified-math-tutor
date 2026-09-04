import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/screens/practice/practice_screen.dart';
import 'package:unified_math_tutor/screens/topics/topic_learning_hub_screen.dart';
import 'package:unified_math_tutor/screens/topics/topics_screen.dart';

import 'support/topic_hub_practice_crash_test_utils.dart';

/// P0 crash regression — additional scenario audited while investigating a
/// report that the crash persisted on a physical Pixel after the push()
/// -> go() fix (cfec7bc). Distinct from
/// topic_hub_practice_navigator_key_regression_test.dart's original
/// scenario: here the Practice branch's own Navigator is built FIRST, via
/// a normal bottom-nav visit (exactly like a real learner who has already
/// used Practice directly before ever trying Topic Drill through the
/// Hub), *before* the Hub's go('/practice', ...) call ever runs — so the
/// branch's `GlobalKey<NavigatorState>` is already live and mounted
/// (StatefulShellRoute.indexedStack keeps every visited branch mounted)
/// when the Hub navigates to it, rather than being created fresh.
///
/// This did not reproduce the reported crash — go() handles an
/// already-mounted branch cleanly, both when reached directly (this file)
/// and when reached fresh (the original regression file). Kept as
/// permanent coverage of a real, distinct code path the original
/// regression test does not exercise, not as proof the physical-device
/// report is explained — see the sprint report for what remains open.
void main() {
  setUpAll(preloadCrashRegressionCatalogs);
  setUp(initCrashRegressionServices);

  testWidgets(
      'Practice branch already visited via the bottom nav before the Hub '
      'launches Topic Drill into it — no duplicate Navigator key',
      (tester) async {
    await pumpRealRoute(tester, '/home');

    // A normal Practice tab visit — builds _practiceNavKey's Navigator
    // for real, inside the shell, before the Hub ever touches it.
    appRouter.go('/practice');
    await tester.pumpAndSettle();
    expect(find.byType(PracticeScreen), findsOneWidget);
    expect(tester.takeException(), isNull);

    await pumpRealRoute(tester, '/topics');
    expect(find.byType(TopicsScreen), findsOneWidget);

    await tapNoSettle(tester, 'Statistics & Probability');
    await pumpUntilLoaded(tester);
    expect(find.byType(TopicLearningHubScreen), findsOneWidget);
    expect(tester.takeException(), isNull);

    final topicDrillCard = activityCard('topicDrill');
    await tester.ensureVisible(topicDrillCard);
    await tester.tap(topicDrillCard);
    await tester.pumpAndSettle();

    expect(find.byType(PracticeScreen), findsOneWidget);
    expect(tester.takeException(), isNull,
        reason: 'launching Topic Drill into an already-mounted Practice '
            'branch must not crash');
  });
}
