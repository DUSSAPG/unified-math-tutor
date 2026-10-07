import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/exact_fraction.dart';
import 'package:unified_math_tutor/models/number_sense_example.dart';
import 'package:unified_math_tutor/models/number_sense_state.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';
import 'package:unified_math_tutor/widgets/number_sense/fraction_partition_bar.dart';
import 'package:unified_math_tutor/widgets/number_sense/number_sense_lab_workspace.dart';
import 'package:unified_math_tutor/widgets/number_sense/unit_fraction_number_line.dart';

void main() {
  Widget appFor(
    NumberSenseState state,
    ValueChanged<NumberSenseState> onChanged,
  ) =>
      MaterialApp(
        theme: AppTheme.light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: NumberSenseLabWorkspace(
                state: state,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      );

  Future<void> pumpControlled(
    WidgetTester tester, {
    required NumberSenseState initialState,
    required ValueChanged<NumberSenseState> onLatest,
  }) async {
    var state = initialState;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: StatefulBuilder(
                builder: (context, setState) => NumberSenseLabWorkspace(
                  state: state,
                  onChanged: (next) {
                    state = next;
                    onLatest(next);
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('displays the fraction in its selected partition',
      (tester) async {
    final state =
        NumberSenseState.freeExplore(denominator: 4).setShadedParts(2);
    await tester.pumpWidget(appFor(state, (_) {}));

    expect(
      find.byKey(const ValueKey('numberSenseWorkspace.fraction')),
      findsOneWidget,
    );
    expect(find.text('2/4'), findsOneWidget);
    expect(
      tester
          .getSemantics(
            find.byKey(const ValueKey('unitFractionNumberLine.semantics')),
          )
          .value,
      '2 fourths',
    );
  });

  testWidgets('Free Explore zero displays as zero for each supported partition',
      (tester) async {
    for (final denominator in [2, 3, 4, 6, 8]) {
      await tester.pumpWidget(
        appFor(NumberSenseState.freeExplore(denominator: denominator), (_) {}),
      );

      expect(
        tester
            .widget<Text>(
              find.byKey(
                const ValueKey('numberSenseWorkspace.fraction'),
              ),
            )
            .data,
        '0',
        reason: 'denominator $denominator',
      );
      expect(
        find.text('0/$denominator'),
        findsNothing,
        reason: 'denominator $denominator',
      );
      expect(
        find.byKey(
          ValueKey('numberSenseWorkspace.denominator-$denominator'),
        ),
        findsOneWidget,
        reason: 'denominator $denominator remains available',
      );
      expect(
        find.byKey(
          ValueKey('fractionPartitionBar.segment-${denominator - 1}'),
        ),
        findsOneWidget,
        reason: 'the $denominator-part bar remains partitioned',
      );
    }
  });

  testWidgets('Free Explore keeps the fraction label after selecting a part',
      (tester) async {
    await pumpControlled(
      tester,
      initialState: NumberSenseState.freeExplore(denominator: 8),
      onLatest: (_) {},
    );

    await tester.tap(
      find.byKey(const ValueKey('fractionPartitionBar.segment-0')),
    );
    await tester.pump();
    expect(find.text('1/8'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('fractionPartitionBar.segment-4')),
    );
    await tester.pump();
    expect(find.text('5/8'), findsOneWidget);
  });

  testWidgets('bar changes update the parent state and both manipulatives',
      (tester) async {
    NumberSenseState? latest;
    await pumpControlled(
      tester,
      initialState:
          NumberSenseState.freeExplore(denominator: 4).setShadedParts(2),
      onLatest: (next) => latest = next,
    );

    await tester.tap(
      find.byKey(const ValueKey('fractionPartitionBar.segment-2')),
    );
    await tester.pump();

    expect(latest!.denominator, 4);
    expect(latest!.shadedParts, 3);
    expect(find.text('3/4'), findsOneWidget);
    expect(
      tester
          .getSemantics(
            find.byKey(const ValueKey('unitFractionNumberLine.semantics')),
          )
          .value,
      '3 fourths',
    );
    final colors = [
      for (var index = 0; index < 4; index++)
        tester
            .widget<DecoratedBox>(
              find.descendant(
                of: find.byKey(ValueKey('fractionPartitionBar.segment-$index')),
                matching: find.byType(DecoratedBox),
              ),
            )
            .decoration as BoxDecoration,
    ];
    final appColors = AppTheme.light().extension<AppSemanticColors>()!;
    expect(colors[2].color, appColors.accent);
    expect(colors[3].color, appColors.cardSurface);
  });

  testWidgets('number-line changes update state and synchronize the bar',
      (tester) async {
    NumberSenseState? latest;
    await pumpControlled(
      tester,
      initialState: NumberSenseState.freeExplore(denominator: 4),
      onLatest: (next) => latest = next,
    );

    final line = find.byKey(
      const ValueKey('unitFractionNumberLine.interaction'),
    );
    final box = tester.renderObject<RenderBox>(line);
    await tester.tapAt(
      tester.getTopLeft(line) + Offset(20 + (box.size.width - 40) * 0.75, 44),
    );
    await tester.pump();

    expect(latest!.value, ExactFraction(3, 4));
    expect(latest!.shadedParts, 3);
    expect(find.text('3/4'), findsOneWidget);
    expect(
      tester
          .getSemantics(
            find.byKey(const ValueKey('unitFractionNumberLine.semantics')),
          )
          .value,
      '3 fourths',
    );
    final colors = [
      for (var index = 0; index < 4; index++)
        tester
            .widget<DecoratedBox>(
              find.descendant(
                of: find.byKey(ValueKey('fractionPartitionBar.segment-$index')),
                matching: find.byType(DecoratedBox),
              ),
            )
            .decoration as BoxDecoration,
    ];
    final appColors = AppTheme.light().extension<AppSemanticColors>()!;
    expect(colors[2].color, appColors.accent);
    expect(colors[3].color, appColors.cardSurface);
  });

  testWidgets('denominator choice uses the state exact re-snap transition',
      (tester) async {
    NumberSenseState? latest;
    await pumpControlled(
      tester,
      initialState: NumberSenseState.guided(
        NumberSenseExampleId.compareTwoThirdsAndThreeQuarters,
      ),
      onLatest: (next) => latest = next,
    );

    await tester.tap(
      find.byKey(const ValueKey('numberSenseWorkspace.denominator-4')),
    );
    await tester.pump();

    expect(latest!.denominator, 4);
    expect(latest!.shadedParts, 3);
    expect(latest!.value, ExactFraction(3, 4));
    expect(find.text('3/4'), findsOneWidget);
    expect(
      tester
          .getSemantics(
            find.byKey(const ValueKey('unitFractionNumberLine.semantics')),
          )
          .value,
      '3 fourths',
    );
  });

  testWidgets('offers only V1 denominators and exposes selected choice',
      (tester) async {
    final state = NumberSenseState.freeExplore(denominator: 6);
    await tester.pumpWidget(appFor(state, (_) {}));

    for (final denominator in [2, 3, 4, 6, 8]) {
      expect(
        find.byKey(ValueKey('numberSenseWorkspace.denominator-$denominator')),
        findsOneWidget,
      );
      expect(
        tester
                .getSemantics(
                  find.byKey(ValueKey(
                      'numberSenseWorkspace.denominator-$denominator')),
                )
                .getSemanticsData()
                .flagsCollection
                .isSelected ==
            Tristate.isTrue,
        denominator == 6,
      );
    }
    expect(find.byType(ChoiceChip), findsNWidgets(5));
  });

  for (final size in [const Size(320, 700), const Size(915, 412)]) {
    testWidgets('fits and remains usable at ${size.width}x${size.height}',
        (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        appFor(NumberSenseState.freeExplore(denominator: 8), (_) {}),
      );

      expect(find.byType(FractionPartitionBar), findsOneWidget);
      expect(find.byType(UnitFractionNumberLine), findsOneWidget);
      expect(find.byType(ChoiceChip), findsNWidgets(5));
      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(NumberSenseLabWorkspace)).width,
        lessThanOrEqualTo(size.width),
      );
    });
  }
}
