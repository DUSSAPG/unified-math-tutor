import 'package:flutter_test/flutter_test.dart';

import 'support/topic_hub_truth_test_utils.dart';

/// Topic Hub Coverage Truth Repair V1 — one real Hub load per file (see
/// support/topic_learning_hub_test_utils.dart for why).
void main() {
  testWidgets(
      'KS5 Trigonometry: MCQ cards remain, no Aircraft Landing Lab and no '
      'GCSE trig formulas', (tester) async {
    await selectStage('KS5');
    await tester.pumpWidget(wrapTruthHub('trigonometry'));
    await pumpHubLoaded(tester);

    expect(hubCard('topicDrill'), findsOneWidget);
    expect(hubCard('interactiveLab', 'aircraftLandingLab'), findsNothing);
    expect(hubCard('formulaLibrary'), findsNothing);
    expectNoProhibitedHubText();
    expect(tester.takeException(), isNull);
  });
}
