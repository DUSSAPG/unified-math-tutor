import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/services/topic_capability_resolver.dart';

import 'support/topic_hub_truth_test_utils.dart';

/// Topic Hub Coverage Truth Repair V1 — one real Hub load per file (see
/// support/topic_learning_hub_test_utils.dart for why).
void main() {
  testWidgets(
      'KS5 Ratio & Proportion: "No planned learning activity for this stage", no supporting '
      'learning and no Football Studio / Applied Maths Studio card',
      (tester) async {
    await selectStage('KS5');
    await tester.pumpWidget(wrapTruthHub('ratio_proportion'));
    await pumpHubLoaded(tester);

    expect(stageStatus(TopicStageStatus.noPlannedActivity), findsOneWidget);
    expect(find.text(l10nEn.topicHubStatusNoPlannedTitle), findsOneWidget);
    expect(
        find.text(l10nEn.topicHubStatusNoPlannedBody('KS5')), findsOneWidget);
    expect(find.text(l10nEn.topicHubStatusNoQuestionsTitle), findsNothing);
    expect(find.text(l10nEn.topicHubSectionSupporting.toUpperCase()),
        findsNothing);
    expect(find.textContaining('yet'), findsNothing);
    expect(anyHubCard, findsNothing,
        reason: 'no card of any kind — no fallback card');
    expect(find.byKey(const ValueKey('topicHubRatioFoundationsCard')),
        findsNothing);
    expectNoProhibitedHubText();
    expect(tester.takeException(), isNull);
  });
}
