import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/services/curriculum_service.dart';

import 'support/topic_learning_hub_test_utils.dart';

/// D3 — one real capability-resolve widget load per file (see
/// support/topic_learning_hub_test_utils.dart's doc comment for why).
void main() {
  testWidgets(
      'changing stage refreshes availability truthfully — Fractions has '
      'real content at KS2 but not KS3, and the Hub reflects that '
      'immediately on stage change, in both directions', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await CurriculumService.instance.select('ks2');

    await tester.pumpWidget(wrapHubWithRouter('fractions'));
    await pumpUntilLoaded(tester);
    expect(activityCard('topicDrill'), findsOneWidget);

    await tester.tap(find.byKey(const Key('topicHubStage-KS3')));
    await tester.pump(); // let the reload spinner actually mount first
    await pumpUntilLoaded(tester);

    expect(activityCard('topicDrill'), findsNothing);
    expect(activityCard('quickStart'), findsOneWidget,
        reason: 'Quick Start stays available — it is stage-wide, not '
            'topic-filtered');

    await tester.tap(find.byKey(const Key('topicHubStage-KS2')));
    await tester.pump();
    await pumpUntilLoaded(tester);

    expect(activityCard('topicDrill'), findsOneWidget,
        reason: 'switching back to a real stage must restore the card');
    expect(tester.takeException(), isNull);
  });
}
