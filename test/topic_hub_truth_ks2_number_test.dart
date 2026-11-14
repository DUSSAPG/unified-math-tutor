import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/services/topic_capability_resolver.dart';

import 'support/topic_hub_truth_test_utils.dart';

/// Topic Hub Coverage Truth Repair V1 — one real Hub load per file (see
/// support/topic_learning_hub_test_utils.dart for why).
void main() {
  testWidgets(
      'KS2 Number & Place Value: content-gap status, then Number Line '
      'Explorer and Interactive Abacus as supporting learning — no MCQ card, '
      'no Feed the Hungry Panda; Abacus opens the Visual Maths abacus',
      (tester) async {
    await selectStage('KS2');
    await tester.pumpWidget(wrapTruthHub('number_place_value'));
    await pumpHubLoaded(tester);

    expectGapWithSupportingLearning();
    expect(hubCard('interactiveLab', 'numberLineExplorer'), findsOneWidget);
    expect(hubCard('supportingActivity', 'interactiveAbacus'), findsOneWidget);
    expect(find.text(l10nEn.topicHubSupportAbacusTitle), findsOneWidget);
    expect(find.text(l10nEn.topicHubScopeAbacus), findsOneWidget);
    expect(find.text(l10nEn.topicHubScopeNumberLineExplorer), findsOneWidget);
    expect(hubCard('formulaLibrary'), findsNothing);
    expect(hubCard('recallCards'), findsNothing);
    expectNoProhibitedHubText();

    // Status always precedes supporting learning.
    expect(
      tester.getTopLeft(stageStatus(TopicStageStatus.contentGap)).dy,
      lessThan(tester
          .getTopLeft(hubCard('interactiveLab', 'numberLineExplorer'))
          .dy),
    );

    await tester
        .ensureVisible(hubCard('supportingActivity', 'interactiveAbacus'));
    await tester.tap(hubCard('supportingActivity', 'interactiveAbacus'));
    await tester.pumpAndSettle();
    expect(find.text('$stubPrefix/math-studio/visual-maths/abacus'),
        findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
