import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/topic_hub_truth_test_utils.dart';

/// Release-readiness a11y — one real Hub load per file (see
/// support/topic_learning_hub_test_utils.dart for why).
void main() {
  testWidgets(
      'Pixel 6a portrait, light: 48dp stage chips, "Back to Topics" label, '
      'tree-wide Android tap-target + labelled-target guidelines pass, and '
      'the transparent hit area outside the pill selects the stage',
      (tester) async {
    final handle = tester.ensureSemantics();
    const size = Size(412, 915);
    useLogicalViewport(tester, size);
    await selectStage('KS3');
    await tester.pumpWidget(wrapTruthHub('geometry_measures'));
    await pumpHubLoaded(tester);

    await expectChipAndBackA11y(tester, selected: 'KS3', viewport: size);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

    // Tap inside the 48dp hit area but outside the visual pill (just
    // below the top edge of the hit box): the chip must still respond.
    final ks4 = tester.getRect(stageChip('KS4'));
    await tester.tapAt(Offset(ks4.center.dx, ks4.top + 2));
    await pumpHubLoaded(tester);
    expect(
      tester.getSemantics(stageChip('KS4')),
      isSemantics(
        label: 'KS4',
        isButton: true,
        hasTapAction: true,
        hasSelectedState: true,
        isSelected: true,
      ),
    );
    expect(tester.takeException(), isNull);
    handle.dispose();
  });
}
