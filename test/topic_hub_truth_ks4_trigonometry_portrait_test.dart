import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/topic_hub_truth_test_utils.dart';

/// Topic Hub Coverage Truth Repair V1 — one real Hub load per file (see
/// support/topic_learning_hub_test_utils.dart for why).
void main() {
  testWidgets(
      'KS4 Trigonometry (Pixel 6a portrait): Aircraft Landing Lab and the '
      'three GCSE trig formulas under the content-gap status, no overflow',
      (tester) async {
    useLogicalViewport(tester, const Size(412, 915));
    await selectStage('KS4');
    await tester.pumpWidget(wrapTruthHub('trigonometry'));
    await pumpHubLoaded(tester);

    expectGapWithSupportingLearning();
    expect(hubCard('interactiveLab', 'aircraftLandingLab'), findsOneWidget);
    expect(find.text(l10nEn.topicHubScopeAircraftLanding), findsOneWidget);
    expect(hubCard('formulaLibrary'), findsOneWidget);
    expect(find.textContaining('3 relevant formulas'), findsOneWidget);
    expect(hubCard('recallCards'), findsNothing);
    expectNoProhibitedHubText();
    await tester.ensureVisible(hubCard('interactiveLab', 'aircraftLandingLab'));
    expect(tester.takeException(), isNull);
  });
}
