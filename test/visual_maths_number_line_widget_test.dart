import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/widgets/visual_maths/number_line_widget.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
  });

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('exposes a Semantics slider with the current value',
      (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      wrap(
        NumberLineWidget(
          min: 0,
          max: 10,
          step: 1,
          value: 7,
          semanticLabel: 'test number line',
          onChanged: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    final semantics = tester.getSemantics(find.byType(NumberLineWidget));
    expect(semantics.label, 'test number line');
    expect(semantics.value, '7');
    expect(tester.takeException(), isNull);
    handle.dispose();
  });

  testWidgets('increase/decrease semantics actions step the value',
      (tester) async {
    final handle = tester.ensureSemantics();
    num? lastValue;
    await tester.pumpWidget(
      wrap(
        NumberLineWidget(
          min: 0,
          max: 10,
          step: 1,
          value: 7,
          semanticLabel: 'test number line',
          onChanged: (value) => lastValue = value,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final id = tester.getSemantics(find.byType(NumberLineWidget)).id;
    // ignore: deprecated_member_use
    tester.binding.pipelineOwner.semanticsOwner!
        .performAction(id, SemanticsAction.increase);
    await tester.pumpAndSettle();
    expect(lastValue, 8);
    handle.dispose();
  });

  testWidgets('dragging horizontally reports a new value via onChanged',
      (tester) async {
    num? lastValue;
    await tester.pumpWidget(
      wrap(
        SizedBox(
          width: 300,
          child: NumberLineWidget(
            min: 0,
            max: 10,
            step: 1,
            value: 0,
            semanticLabel: 'test number line',
            onChanged: (value) => lastValue = value,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tapAt(tester.getCenter(find.byType(NumberLineWidget)));
    await tester.pumpAndSettle();

    expect(lastValue, isNotNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('suppresses the hop animation when Reduce Motion is enabled',
      (tester) async {
    await LocalPreferencesService.instance.setReduceMotion(true);
    num value = 2;

    await tester.pumpWidget(
      wrap(
        StatefulBuilder(
          builder: (context, setState) => NumberLineWidget(
            min: 0,
            max: 10,
            step: 1,
            value: value,
            semanticLabel: 'test number line',
            onChanged: (next) => setState(() => value = next),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tapAt(tester.getCenter(find.byType(NumberLineWidget)));
    await tester.pump();

    expect(tester.hasRunningAnimations, isFalse);
    expect(tester.takeException(), isNull);
  });
}
