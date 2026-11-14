import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/services/topic_capability_resolver.dart';

import 'support/topic_hub_truth_test_utils.dart';

/// Topic Hub Coverage Truth Repair V1 — one real Hub load per file (see
/// support/topic_learning_hub_test_utils.dart for why).
void main() {
  testWidgets(
      'KS5 Geometry & Measures: genuine content gap — "No topic-specific '
      'questions available yet", nothing else, no generic companion card',
      (tester) async {
    await selectStage('KS5');
    await tester.pumpWidget(wrapTruthHub('geometry_measures'));
    await pumpHubLoaded(tester);

    expect(stageStatus(TopicStageStatus.contentGap), findsOneWidget);
    expect(find.text(l10nEn.topicHubStatusNoQuestionsTitle), findsOneWidget);
    expect(find.text(l10nEn.topicHubStatusNoQuestionsBody), findsOneWidget);
    expect(find.text(l10nEn.topicHubSectionSupporting.toUpperCase()),
        findsNothing);
    expect(find.text(l10nEn.topicHubStatusNoPlannedTitle), findsNothing);
    expect(anyHubCard, findsNothing,
        reason: 'no card of any kind — no fallback card');
    expect(find.byKey(const ValueKey('topicHubRatioFoundationsCard')),
        findsNothing);
    expectNoProhibitedHubText();
    expect(tester.takeException(), isNull);
  });
}
