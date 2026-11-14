import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/services/topic_capability_resolver.dart';

import 'support/topic_hub_truth_test_utils.dart';

/// Topic Hub Coverage Truth Repair V1 — one real Hub load per file (see
/// support/topic_learning_hub_test_utils.dart for why).
void main() {
  testWidgets(
      'compact landscape (Pixel 6a 915x412): KS3 Statistics status and '
      'supporting cards are reachable without overflow', (tester) async {
    const size = Size(915, 412);
    useLogicalViewport(tester, size);
    await selectStage('KS3');
    await tester.pumpWidget(wrapTruthHub('statistics_probability'));
    await pumpHubLoaded(tester);

    expectGapWithSupportingLearning();
    for (final card in [
      stageStatus(TopicStageStatus.contentGap),
      hubCard('formulaLibrary'),
      hubCard('interactiveLab', 'dataDetective'),
    ]) {
      await tester.ensureVisible(card);
      await tester.pump();
      final rect = tester.getRect(card);
      expect(rect.left, greaterThanOrEqualTo(-0.5), reason: '$card');
      expect(rect.right, lessThanOrEqualTo(size.width + 0.5), reason: '$card');
      expect(rect.bottom, lessThanOrEqualTo(size.height + 0.5),
          reason: '$card');
    }
    expect(tester.takeException(), isNull);
  });
}
