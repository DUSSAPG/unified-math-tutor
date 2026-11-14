import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/services/topic_capability_resolver.dart';

import 'package:unified_math_tutor/shared/theme/app_theme.dart';

import 'support/contrast_test_utils.dart';
import 'support/topic_hub_truth_test_utils.dart';

/// Topic Hub Coverage Truth Repair V1 — one real Hub load per file (see
/// support/topic_learning_hub_test_utils.dart for why).
void main() {
  testWidgets(
      'dark mode: status panel, disclaimer and supporting cards render with '
      'readable contrast against the dark card surface', (tester) async {
    await selectStage('KS2');
    await tester.pumpWidget(
        wrapTruthHub('geometry_measures', brightness: Brightness.dark));
    await pumpHubLoaded(tester);

    expectGapWithSupportingLearning();
    final context = tester.element(stageStatus(TopicStageStatus.contentGap));
    final colors = context.appColors;
    expect(Theme.of(context).brightness, Brightness.dark);
    expectContrast('status title', colors.primaryText, colors.cardSurface);
    expectContrast('status body', colors.secondaryText, colors.cardSurface);
    expectContrast('disclaimer', colors.secondaryText, colors.background);
    final title =
        tester.widget<Text>(find.text(l10nEn.topicHubStatusNoQuestionsTitle));
    expect(title.style!.color, colors.primaryText);
    expect(tester.takeException(), isNull);
  });
}
