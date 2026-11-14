import 'package:flutter_test/flutter_test.dart';

import 'support/topic_hub_truth_test_utils.dart';

/// Topic Hub Coverage Truth Repair V1 — one real Hub load per file (see
/// support/topic_learning_hub_test_utils.dart for why).
void main() {
  testWidgets(
      'KS2 Geometry & Measures: Cube Nets and 3D Shape Properties only; the '
      'shape-properties card opens the face/edge/vertex puzzle subset',
      (tester) async {
    await selectStage('KS2');
    await tester.pumpWidget(wrapTruthHub('geometry_measures'));
    await pumpHubLoaded(tester);

    expectGapWithSupportingLearning();
    expect(hubCard('supportingActivity', 'cubeNets'), findsOneWidget);
    expect(hubCard('supportingActivity', 'shapePropertiesPuzzles'),
        findsOneWidget);
    for (final lab in const [
      'flightPathLab',
      'footballPrecision',
      'mazeDriver',
      'aircraftLandingLab',
    ]) {
      expect(hubCard('interactiveLab', lab), findsNothing, reason: lab);
    }
    expect(hubCard('formulaLibrary'), findsNothing);
    expect(hubCard('recallCards'), findsNothing);
    expectNoProhibitedHubText();

    await tester
        .ensureVisible(hubCard('supportingActivity', 'shapePropertiesPuzzles'));
    await tester.tap(hubCard('supportingActivity', 'shapePropertiesPuzzles'));
    await tester.pumpAndSettle();
    expect(
      find.text('$stubPrefix/math-studio/spatial-intelligence/'
          'spatial-puzzles?set=shape-properties'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
