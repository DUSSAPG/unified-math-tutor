import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';
import 'package:unified_math_tutor/widgets/number_sense/fraction_partition_bar.dart';

void main() {
  final theme = AppTheme.light();

  Widget wrap(Widget child) => MaterialApp(
        theme: theme,
        home: Scaffold(body: Center(child: SizedBox(width: 280, child: child))),
      );

  testWidgets('renders the requested initial shading', (tester) async {
    await tester.pumpWidget(
      wrap(FractionPartitionBar(
        denominator: 4,
        shadedParts: 2,
        onChanged: (_) {},
      )),
    );

    final colors = [
      for (var i = 0; i < 4; i++)
        tester
            .widget<DecoratedBox>(
              find.descendant(
                of: find.byKey(ValueKey('fractionPartitionBar.segment-$i')),
                matching: find.byType(DecoratedBox),
              ),
            )
            .decoration as BoxDecoration,
    ];
    final appColors = theme.extension<AppSemanticColors>()!;
    expect(colors[0].color, appColors.accent);
    expect(colors[1].color, appColors.accent);
    expect(colors[2].color, appColors.cardSurface);
    expect(colors[3].color, appColors.cardSurface);
  });

  testWidgets('tapping a segment requests its one-based shaded count',
      (tester) async {
    int? requested;
    await tester.pumpWidget(
      wrap(FractionPartitionBar(
        denominator: 4,
        shadedParts: 1,
        onChanged: (value) => requested = value,
      )),
    );

    await tester
        .tap(find.byKey(const ValueKey('fractionPartitionBar.segment-2')));
    expect(requested, 3);
  });

  testWidgets('tapping the final shaded segment removes that part',
      (tester) async {
    int? requested;
    await tester.pumpWidget(
      wrap(FractionPartitionBar(
        denominator: 4,
        shadedParts: 2,
        onChanged: (value) => requested = value,
      )),
    );

    await tester
        .tap(find.byKey(const ValueKey('fractionPartitionBar.segment-1')));
    expect(requested, 1);
  });

  testWidgets('zero and full bar taps request valid boundary counts',
      (tester) async {
    int? requested;
    await tester.pumpWidget(
      wrap(FractionPartitionBar(
        denominator: 2,
        shadedParts: 0,
        onChanged: (value) => requested = value,
      )),
    );
    await tester
        .tap(find.byKey(const ValueKey('fractionPartitionBar.segment-0')));
    expect(requested, 1);

    await tester.pumpWidget(
      wrap(FractionPartitionBar(
        denominator: 2,
        shadedParts: 2,
        onChanged: (value) => requested = value,
      )),
    );
    await tester
        .tap(find.byKey(const ValueKey('fractionPartitionBar.segment-1')));
    expect(requested, 1);
  });

  testWidgets('semantics report exact state and only available actions',
      (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      wrap(FractionPartitionBar(
        denominator: 4,
        shadedParts: 0,
        onChanged: (_) {},
      )),
    );

    var semantics = tester.getSemantics(
      find.byKey(const ValueKey('fractionPartitionBar.semantics')),
    );
    expect(semantics.label, 'Fraction bar');
    expect(semantics.value, '0 of 4 parts shaded');
    expect(semantics.getSemanticsData().hasAction(SemanticsAction.increase),
        isTrue);
    expect(semantics.getSemanticsData().hasAction(SemanticsAction.decrease),
        isFalse);

    await tester.pumpWidget(
      wrap(FractionPartitionBar(
        denominator: 4,
        shadedParts: 4,
        onChanged: (_) {},
      )),
    );
    semantics = tester.getSemantics(
      find.byKey(const ValueKey('fractionPartitionBar.semantics')),
    );
    expect(semantics.value, '4 of 4 parts shaded');
    expect(semantics.getSemanticsData().hasAction(SemanticsAction.increase),
        isFalse);
    expect(semantics.getSemanticsData().hasAction(SemanticsAction.decrease),
        isTrue);
    handle.dispose();
  });

  testWidgets('screen reader actions request one part when available',
      (tester) async {
    final handle = tester.ensureSemantics();
    final requested = <int>[];
    await tester.pumpWidget(
      wrap(FractionPartitionBar(
        denominator: 4,
        shadedParts: 2,
        onChanged: requested.add,
      )),
    );

    final id = tester
        .getSemantics(
            find.byKey(const ValueKey('fractionPartitionBar.semantics')))
        .id;
    // ignore: deprecated_member_use
    tester.binding.pipelineOwner.semanticsOwner!
        .performAction(id, SemanticsAction.increase);
    // ignore: deprecated_member_use
    tester.binding.pipelineOwner.semanticsOwner!
        .performAction(id, SemanticsAction.decrease);
    expect(requested, [3, 1]);
    handle.dispose();
  });

  test('rejects non-policy denominators and shading outside its bounds', () {
    expect(
      () => FractionPartitionBar(
          denominator: 5, shadedParts: 0, onChanged: (_) {}),
      throwsArgumentError,
    );
    expect(
      () => FractionPartitionBar(
          denominator: 4, shadedParts: -1, onChanged: (_) {}),
      throwsArgumentError,
    );
    expect(
      () => FractionPartitionBar(
          denominator: 4, shadedParts: 5, onChanged: (_) {}),
      throwsArgumentError,
    );
  });
}
