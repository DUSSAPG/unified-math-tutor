import 'package:flutter_test/flutter_test.dart';

import 'support/topic_hub_truth_test_utils.dart';

/// Topic Hub Coverage Truth Repair V1 — one real Hub load per file (see
/// support/topic_learning_hub_test_utils.dart for why).
void main() {
  testWidgets(
      'KS3 Statistics & Probability: Data Detective and the formula card '
      'only — no Football Precision, no recall', (tester) async {
    await selectStage('KS3');
    await tester.pumpWidget(wrapTruthHub('statistics_probability'));
    await pumpHubLoaded(tester);

    expectGapWithSupportingLearning();
    expect(hubCard('interactiveLab', 'dataDetective'), findsOneWidget);
    expect(find.text(l10nEn.topicHubScopeDataDetective), findsOneWidget);
    expect(hubCard('formulaLibrary'), findsOneWidget);
    expect(find.textContaining('3 relevant formulas'), findsOneWidget);
    expect(hubCard('interactiveLab', 'footballPrecision'), findsNothing);
    expect(hubCard('recallCards'), findsNothing);
    expectNoProhibitedHubText();
    expect(tester.takeException(), isNull);
  });
}
