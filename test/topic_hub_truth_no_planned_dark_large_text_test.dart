import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/services/topic_capability_resolver.dart';

import 'support/topic_hub_truth_test_utils.dart';

/// Release-readiness copy — one real Hub load per file (see
/// support/topic_learning_hub_test_utils.dart for why).
void main() {
  testWidgets(
      'KS2 Trigonometry, dark, 2.0x text, compact landscape: product-scope '
      'copy "No planned learning activity for this stage", announced as '
      'one header, no curriculum claim, no card', (tester) async {
    final handle = tester.ensureSemantics();
    const size = Size(915, 412);
    useLogicalViewport(tester, size);
    await selectStage('KS2');
    await tester.pumpWidget(wrapTruthHub('trigonometry',
        brightness: Brightness.dark, textScale: 2.0));
    await pumpHubLoaded(tester);

    final status = stageStatus(TopicStageStatus.noPlannedActivity);
    expect(status, findsOneWidget);
    expect(
      tester.getSemantics(status),
      isSemantics(
        isHeader: true,
        label: '${l10nEn.topicHubStatusNoPlannedTitle}. '
            '${l10nEn.topicHubStatusNoPlannedBody('KS2')}',
      ),
    );
    expect(find.text('No planned learning activity for this stage'),
        findsOneWidget);
    expect(
        find.text('This app does not include learning activities for this '
            'topic at KS2.'),
        findsOneWidget);
    for (final claim in const [
      'Not part of this stage',
      'not taught',
      'programme of study',
      'curriculum',
    ]) {
      expect(find.textContaining(claim), findsNothing, reason: claim);
    }
    expect(anyHubCard, findsNothing);
    await tester.ensureVisible(status);
    await tester.pump();
    expect(tester.getRect(status).right, lessThanOrEqualTo(size.width + 0.5));
    expect(tester.takeException(), isNull);
    handle.dispose();
  });
}
