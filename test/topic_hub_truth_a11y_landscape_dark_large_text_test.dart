import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/topic_hub_truth_test_utils.dart';

/// Release-readiness a11y — one real Hub load per file (see
/// support/topic_learning_hub_test_utils.dart for why).
void main() {
  testWidgets(
      'compact landscape (915x412), dark, 2.0x text: chips >=48dp and '
      'labelled, Back labelled, no overflow', (tester) async {
    final handle = tester.ensureSemantics();
    const size = Size(915, 412);
    useLogicalViewport(tester, size);
    await selectStage('KS3');
    await tester.pumpWidget(wrapTruthHub('statistics_probability',
        brightness: Brightness.dark, textScale: 2.0));
    await pumpHubLoaded(tester);

    await expectChipAndBackA11y(tester, selected: 'KS3', viewport: size);
    expect(tester.takeException(), isNull);
    handle.dispose();
  });
}
