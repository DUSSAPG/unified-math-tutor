import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/services/curriculum_service.dart';

import 'support/topic_learning_hub_test_utils.dart';

/// D3 — one real capability-resolve widget load per file (see
/// support/topic_learning_hub_test_utils.dart's doc comment for why).
void main() {
  testWidgets(
      'renders without overflow at compact Pixel 6a landscape (915x412), '
      'with all real content still reachable', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await CurriculumService.instance.select('ks4');

    tester.view.physicalSize = const Size(2400, 1080);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(wrapHubWithRouter('geometry_measures'));
    await pumpUntil(
      tester,
      () => activityCard('topicDrill').evaluate().isNotEmpty,
    );

    await tester.ensureVisible(activityCard('topicDrill'));
    expect(activityCard('topicDrill'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
