import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/screens/topics/topic_learning_hub_screen.dart';

import 'support/topic_hub_practice_crash_test_utils.dart';

/// P0 content-integrity repair, part D: removes the misleading
/// "N real questions in the $stage pool" reason text from the Hub's
/// Topic Drill/Quick Start cards — a pool-wide count on a topic-specific
/// card is exactly the impression that let the reported defect go
/// unnoticed. One real Hub capability-resolve load per file, matching the
/// established discipline.
void main() {
  setUpAll(preloadCrashRegressionCatalogs);
  setUp(initCrashRegressionServices);

  testWidgets(
      'KS5 Statistics & Probability Hub: no aggregate question-pool count '
      'anywhere on the Topic Drill or Quick Start cards', (tester) async {
    await openHubFreshOnStatisticsProbability(tester);
    expect(find.byType(TopicLearningHubScreen), findsOneWidget);

    expect(find.textContaining(RegExp(r'\d+ real question')), findsNothing);
    expect(find.textContaining(RegExp(r'\d+.*question.*pool')), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
