import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/topic_hub_truth_test_utils.dart';

/// Topic Hub Coverage Truth Repair V1 — one real Hub load per file (see
/// support/topic_learning_hub_test_utils.dart for why).
void main() {
  testWidgets(
      'KS3 Geometry & Measures: Transformations, Rotations and the KS3 '
      'formula items; the formula card opens exactly those formula ids; no '
      'GCSE-only labs or recall', (tester) async {
    await selectStage('KS3');
    await tester.pumpWidget(wrapTruthHub('geometry_measures'));
    await pumpHubLoaded(tester);

    expectGapWithSupportingLearning();
    expect(hubCard('supportingActivity', 'transformations'), findsOneWidget);
    expect(hubCard('supportingActivity', 'rotations'), findsOneWidget);
    expect(hubCard('formulaLibrary'), findsOneWidget);
    expect(hubCard('recallCards'), findsNothing);
    for (final lab in const [
      'flightPathLab',
      'footballPrecision',
      'mazeDriver',
      'aircraftLandingLab',
    ]) {
      expect(hubCard('interactiveLab', lab), findsNothing, reason: lab);
    }
    expectNoProhibitedHubText();

    await tester.ensureVisible(hubCard('formulaLibrary'));
    await tester.tap(hubCard('formulaLibrary'));
    await tester.pumpAndSettle();
    final uriText = tester.widget<Text>(find.textContaining(stubPrefix)).data!;
    expect(uriText, startsWith('$stubPrefix/formulas'));
    expect(tester.takeException(), isNull);
  });
}
