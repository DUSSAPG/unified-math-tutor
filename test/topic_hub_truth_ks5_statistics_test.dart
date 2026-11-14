import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/services/topic_capability_resolver.dart';

import 'support/topic_hub_truth_test_utils.dart';

/// Topic Hub Coverage Truth Repair V1 — one real Hub load per file (see
/// support/topic_learning_hub_test_utils.dart for why).
void main() {
  testWidgets(
      'KS5 Statistics & Probability: MCQ cards remain, but no Football '
      'Precision, Data Detective, GCSE-only Recall Cards or formulas',
      (tester) async {
    await selectStage('KS5');
    await tester.pumpWidget(wrapTruthHub('statistics_probability'));
    await pumpHubLoaded(tester);

    expect(hubCard('topicDrill'), findsOneWidget);
    expect(hubCard('quickStart'), findsOneWidget);
    expect(hubCard('interactiveLab', 'footballPrecision'), findsNothing);
    expect(hubCard('interactiveLab', 'dataDetective'), findsNothing);
    expect(hubCard('recallCards'), findsNothing);
    expect(hubCard('formulaLibrary'), findsNothing);
    expect(find.text(l10nEn.topicHubSectionLearn.toUpperCase()), findsNothing);
    expect(
        find.text(l10nEn.topicHubSectionExplore.toUpperCase()), findsNothing);
    expect(find.textContaining('Football'), findsNothing);
    expect(stageStatus(TopicStageStatus.contentGap), findsNothing);
    expectNoProhibitedHubText();
    expect(tester.takeException(), isNull);
  });
}
