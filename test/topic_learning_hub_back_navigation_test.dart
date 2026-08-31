import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/services/curriculum_service.dart';

import 'support/topic_learning_hub_test_utils.dart';

/// D3 — one real capability-resolve widget load per file (see
/// support/topic_learning_hub_test_utils.dart's doc comment for why).
void main() {
  testWidgets('the Back button returns to Topics, a clear route back',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    await CurriculumService.instance.select('ks2');

    await tester.pumpWidget(
      wrapHubWithRouter('fractions', withTopicsFallback: true),
    );
    await pumpUntilLoaded(tester);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('topics-fallback'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
