import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/services/curriculum_service.dart';

import 'support/topic_learning_hub_test_utils.dart';

/// Real Hub load (scoped test router), confirming the widget-level wiring
/// matches topic_hub_ratio_foundations_gate_function_test.dart's exhaustive
/// unit coverage: the card is absent for ratio_proportion at KS2, KS4, and
/// KS5, appearing only when the Hub's own stage picker is on KS3.
void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await CurriculumService.instance.select('ks2');
  });

  Finder ratioCard() =>
      find.byKey(const ValueKey('topicHubRatioFoundationsCard'));

  testWidgets(
      'ratio_proportion Hub: the card is absent at KS2/KS4/KS5 and only '
      'appears once KS3 is selected', (tester) async {
    await tester.pumpWidget(wrapHubWithRouter('ratio_proportion'));
    await pumpUntilLoaded(tester);
    expect(ratioCard(), findsNothing, reason: 'KS2 (default stage)');

    await tester.tap(find.byKey(const Key('topicHubStage-KS4')));
    await tester.pump();
    await pumpUntilLoaded(tester);
    expect(ratioCard(), findsNothing, reason: 'KS4');

    await tester.tap(find.byKey(const Key('topicHubStage-KS5')));
    await tester.pump();
    await pumpUntilLoaded(tester);
    expect(ratioCard(), findsNothing, reason: 'KS5');

    await tester.tap(find.byKey(const Key('topicHubStage-KS3')));
    await tester.pump();
    await pumpUntilLoaded(tester);
    expect(ratioCard(), findsOneWidget, reason: 'KS3');

    expect(tester.takeException(), isNull);
  });
}
