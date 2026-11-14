import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/services/topic_capability_resolver.dart';

import 'support/topic_hub_truth_test_utils.dart';

/// Topic Hub Coverage Truth Repair V1 — one real Hub load per file (see
/// support/topic_learning_hub_test_utils.dart for why).
void main() {
  testWidgets(
      'large text (2.0x) on Pixel 6a portrait: status and every supporting '
      'card render without overflow and stay horizontally on screen',
      (tester) async {
    const size = Size(412, 915);
    useLogicalViewport(tester, size);
    await selectStage('KS2');
    await tester.pumpWidget(wrapTruthHub('number_place_value', textScale: 2.0));
    await pumpHubLoaded(tester);

    expectGapWithSupportingLearning();
    for (final card in [
      stageStatus(TopicStageStatus.contentGap),
      hubCard('interactiveLab', 'numberLineExplorer'),
      hubCard('supportingActivity', 'interactiveAbacus'),
    ]) {
      await tester.ensureVisible(card);
      await tester.pump();
      final rect = tester.getRect(card);
      expect(rect.left, greaterThanOrEqualTo(-0.5), reason: '$card');
      expect(rect.right, lessThanOrEqualTo(size.width + 0.5), reason: '$card');
    }
    expect(tester.takeException(), isNull);
  });
}
