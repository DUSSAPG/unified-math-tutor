import 'package:flutter_test/flutter_test.dart';

import 'support/topic_hub_truth_test_utils.dart';

/// Release-readiness a11y — one real Hub load per file (see
/// support/topic_learning_hub_test_utils.dart for why).
void main() {
  testWidgets(
      'Back control: announced as "Back to Topics" with an explicit label, '
      'and activating it returns to Topics', (tester) async {
    final handle = tester.ensureSemantics();
    await selectStage('KS2');
    await tester.pumpWidget(wrapTruthHub('number_place_value'));
    await pumpHubLoaded(tester);

    expect(find.bySemanticsLabel(l10nEn.topicHubBackToTopics), findsOneWidget);
    expect(
      tester.getSemantics(hubBackButton),
      isSemantics(
        label: l10nEn.topicHubBackToTopics,
        isButton: true,
        hasTapAction: true,
      ),
    );
    await tester.tap(hubBackButton);
    await tester.pumpAndSettle();
    expect(find.text('$stubPrefix/topics'), findsOneWidget);
    expect(tester.takeException(), isNull);
    handle.dispose();
  });
}
