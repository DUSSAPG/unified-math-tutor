import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/exact_fraction.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';
import 'package:unified_math_tutor/widgets/number_sense/unit_fraction_number_line.dart';

void main() {
  const interactionKey = ValueKey('unitFractionNumberLine.interaction');
  const semanticsKey = ValueKey('unitFractionNumberLine.semantics');
  final theme = AppTheme.light();

  Widget wrap(Widget child) => MaterialApp(
        theme: theme,
        home: Scaffold(body: Center(child: SizedBox(width: 300, child: child))),
      );

  double localXForFraction(WidgetTester tester, double fraction) {
    final box = tester.renderObject<RenderBox>(find.byKey(interactionKey));
    return 20 + (box.size.width - 40) * fraction;
  }

  testWidgets('renders endpoints, exact ticks and the selected exact point',
      (tester) async {
    await tester.pumpWidget(
      wrap(UnitFractionNumberLine(
        denominator: 4,
        selected: ExactFraction(1, 2),
        onChanged: (_) {},
      )),
    );

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    for (var index = 0; index <= 4; index++) {
      expect(
        find.byKey(ValueKey('unitFractionNumberLine.tick-$index')),
        findsOneWidget,
      );
    }
    final origin = tester.getTopLeft(find.byKey(interactionKey));
    expect(
      tester
              .getCenter(
                find.byKey(const ValueKey('unitFractionNumberLine.selected')),
              )
              .dx -
          origin.dx,
      150,
    );

    final paint = tester.widget<CustomPaint>(
      find.descendant(
        of: find.byKey(interactionKey),
        matching: find.byType(CustomPaint),
      ),
    );
    expect(paint.painter, isNotNull);
    expect(tester.getSize(find.byKey(interactionKey)).height, 88);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tap requests the nearest exact tick', (tester) async {
    ExactFraction? requested;
    await tester.pumpWidget(
      wrap(UnitFractionNumberLine(
        denominator: 8,
        selected: ExactFraction(0, 1),
        onChanged: (value) => requested = value,
      )),
    );

    await tester.tapAt(
      tester.getTopLeft(find.byKey(interactionKey)) +
          Offset(localXForFraction(tester, 0.38), 44),
    );
    expect(requested, ExactFraction(3, 8));
  });

  testWidgets('horizontal drag requests exact tick values', (tester) async {
    final requested = <ExactFraction>[];
    await tester.pumpWidget(
      wrap(UnitFractionNumberLine(
        denominator: 6,
        selected: ExactFraction(0, 1),
        onChanged: requested.add,
      )),
    );

    final start = tester.getTopLeft(find.byKey(interactionKey)) +
        Offset(localXForFraction(tester, 0.1), 44);
    final end = tester.getTopLeft(find.byKey(interactionKey)) +
        Offset(localXForFraction(tester, 0.8), 44);
    await tester.dragFrom(start, end - start);
    expect(requested, isNotEmpty);
    expect(requested.last, ExactFraction(5, 6));
  });

  testWidgets('midpoint ties snap upward', (tester) async {
    ExactFraction? requested;
    await tester.pumpWidget(
      wrap(UnitFractionNumberLine(
        denominator: 4,
        selected: ExactFraction(0, 1),
        onChanged: (value) => requested = value,
      )),
    );

    await tester.tapAt(
      tester.getTopLeft(find.byKey(interactionKey)) +
          Offset(localXForFraction(tester, 0.375), 44),
    );
    expect(requested, ExactFraction(1, 2));
  });

  testWidgets('pointer positions clamp to zero and one', (tester) async {
    final requested = <ExactFraction>[];
    await tester.pumpWidget(
      wrap(UnitFractionNumberLine(
        denominator: 4,
        selected: ExactFraction(1, 2),
        onChanged: requested.add,
      )),
    );

    final topLeft = tester.getTopLeft(find.byKey(interactionKey));
    await tester.tapAt(topLeft + const Offset(0, 44));
    expect(requested.last, ExactFraction(0, 1));

    await tester.tapAt(topLeft + const Offset(299, 44));
    expect(requested.last, ExactFraction(1, 1));
  });

  testWidgets('semantics expose selected value and boundary actions',
      (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      wrap(UnitFractionNumberLine(
        denominator: 8,
        selected: ExactFraction(0, 1),
        onChanged: (_) {},
      )),
    );

    var semantics = tester.getSemantics(find.byKey(semanticsKey));
    expect(semantics.label, 'Unit fraction number line');
    expect(semantics.value, '0 eighths');
    expect(semantics.getSemanticsData().hasAction(SemanticsAction.increase),
        isTrue);
    expect(semantics.getSemanticsData().hasAction(SemanticsAction.decrease),
        isFalse);

    await tester.pumpWidget(
      wrap(UnitFractionNumberLine(
        denominator: 8,
        selected: ExactFraction(1, 1),
        onChanged: (_) {},
      )),
    );
    semantics = tester.getSemantics(find.byKey(semanticsKey));
    expect(semantics.value, '8 eighths');
    expect(semantics.getSemanticsData().hasAction(SemanticsAction.increase),
        isFalse);
    expect(semantics.getSemanticsData().hasAction(SemanticsAction.decrease),
        isTrue);
    handle.dispose();
  });

  testWidgets('screen reader actions step by exact adjacent ticks',
      (tester) async {
    final handle = tester.ensureSemantics();
    final requested = <ExactFraction>[];
    await tester.pumpWidget(
      wrap(UnitFractionNumberLine(
        denominator: 6,
        selected: ExactFraction(1, 2),
        onChanged: requested.add,
      )),
    );

    final id = tester.getSemantics(find.byKey(semanticsKey)).id;
    // ignore: deprecated_member_use
    tester.binding.pipelineOwner.semanticsOwner!
        .performAction(id, SemanticsAction.increase);
    expect(requested, [ExactFraction(2, 3)]);
    handle.dispose();
  });

  test('rejects invalid policy and unrepresentable selected fractions', () {
    expect(
      () => UnitFractionNumberLine(
        denominator: 5,
        selected: ExactFraction(1, 2),
        onChanged: (_) {},
      ),
      throwsArgumentError,
    );
    expect(
      () => UnitFractionNumberLine(
        denominator: 4,
        selected: ExactFraction(1, 3),
        onChanged: (_) {},
      ),
      throwsArgumentError,
    );
  });
}
