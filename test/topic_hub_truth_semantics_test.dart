import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/services/topic_capability_resolver.dart';

import 'support/topic_hub_truth_test_utils.dart';

/// Topic Hub Coverage Truth Repair V1 — one real Hub load per file (see
/// support/topic_learning_hub_test_utils.dart for why).
void main() {
  testWidgets(
      'accessibility: the stage status is one header node and each '
      'supporting card is a labelled button with its scope as the hint; '
      'new cards meet the 48dp tap-target minimum', (tester) async {
    final handle = tester.ensureSemantics();
    await selectStage('KS3');
    await tester.pumpWidget(wrapTruthHub('geometry_measures'));
    await pumpHubLoaded(tester);

    expect(
      tester.getSemantics(stageStatus(TopicStageStatus.contentGap)),
      isSemantics(
        isHeader: true,
        label: '${l10nEn.topicHubStatusNoQuestionsTitle}. '
            '${l10nEn.topicHubStatusNoQuestionsBody}',
      ),
    );
    expect(
      find.bySemanticsLabel(l10nEn.topicHubSupportTransformationsTitle),
      findsOneWidget,
    );
    expect(
      tester.getSemantics(
          find.bySemanticsLabel(l10nEn.topicHubSupportTransformationsTitle)),
      isSemantics(
        label: l10nEn.topicHubSupportTransformationsTitle,
        hint: l10nEn.topicHubScopeTransformations,
        isButton: true,
        hasTapAction: true,
      ),
    );

    // Coverage Truth Repair cards meet the 48dp Android minimum.
    for (final card in [
      hubCard('supportingActivity', 'transformations'),
      hubCard('supportingActivity', 'rotations'),
      hubCard('formulaLibrary'),
    ]) {
      final size = tester.getSize(card);
      expect(size.height, greaterThanOrEqualTo(48), reason: '$card');
      expect(size.width, greaterThanOrEqualTo(48), reason: '$card');
    }
    // Release-readiness: the stage chips now have a 48dp hit area and the
    // Back button an explicit label, so both tree-wide guidelines hold.
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    final shapes = find.bySemanticsLabel(l10nEn.topicHubSupportRotationsTitle);
    expect(shapes, findsOneWidget);
    expect(tester.takeException(), isNull);
    handle.dispose();
  });
}
