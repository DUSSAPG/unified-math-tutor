import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/services/topic_capability_resolver.dart';

import 'support/topic_hub_truth_test_utils.dart';

/// Release-readiness a11y — one real Hub load per file (see
/// support/topic_learning_hub_test_utils.dart for why).
void main() {
  testWidgets(
      'Pixel 6a portrait, dark, 2.0x text: chips stay >=48dp, inside the '
      'screen and labelled; Back stays labelled; status renders',
      (tester) async {
    final handle = tester.ensureSemantics();
    const size = Size(412, 915);
    useLogicalViewport(tester, size);
    await selectStage('KS2');
    await tester.pumpWidget(wrapTruthHub('number_place_value',
        brightness: Brightness.dark, textScale: 2.0));
    await pumpHubLoaded(tester);

    await expectChipAndBackA11y(tester, selected: 'KS2', viewport: size);
    expect(stageStatus(TopicStageStatus.contentGap), findsOneWidget);
    expect(tester.takeException(), isNull);
    handle.dispose();
  });
}
