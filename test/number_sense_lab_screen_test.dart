import 'dart:io';
import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/number_sense_example.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';
import 'package:unified_math_tutor/widgets/number_sense/number_sense_lab_workspace.dart';
import 'package:unified_math_tutor/screens/visual_maths/number_sense_lab_screen.dart';

void main() {
  Widget app({
    double textScale = 1,
    bool systemReduceMotion = false,
  }) =>
      MaterialApp(
        theme: AppTheme.light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScale),
            disableAnimations: systemReduceMotion,
          ),
          child: child!,
        ),
        home: const NumberSenseLabScreen(),
      );

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
  }

  Future<void> tapAndPump(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> nextExample(WidgetTester tester) async {
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('numberSense.tryAnotherExample')),
    );
  }

  testWidgets('starts Guided on the first committed example', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpScreen(tester);

    expect(find.text('Number Sense Lab'), findsOneWidget);
    expect(find.text('Make an equivalent fraction'), findsOneWidget);
    expect(find.text('Show one half using equal parts.'), findsOneWidget);
    expect(find.text('Target: 1/2'), findsOneWidget);
    expect(find.text('0/2'), findsOneWidget);
    expect(
      tester
          .getSemantics(
            find.byKey(const ValueKey('numberSense.modeGuided')),
          )
          .getSemanticsData()
          .flagsCollection
          .isSelected,
      Tristate.isTrue,
    );
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets('equivalence completes through the exact primary target',
      (tester) async {
    await pumpScreen(tester);
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('fractionPartitionBar.segment-0')),
    );

    expect(find.text('1/2'), findsOneWidget);
    expect(find.text('You found it.'), findsOneWidget);
  });

  testWidgets('guided completion works via an alternate valid workspace route',
      (tester) async {
    await pumpScreen(tester);
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('numberSenseWorkspace.denominator-4')),
    );
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('fractionPartitionBar.segment-1')),
    );

    expect(find.text('2/4'), findsOneWidget);
    expect(find.text('You found it.'), findsOneWidget);
  });

  testWidgets('placement completes at 3/8 through the fraction bar',
      (tester) async {
    await pumpScreen(tester);
    await nextExample(tester);
    expect(
        find.text('Place three eighths on the number line.'), findsOneWidget);

    await tapAndPump(
      tester,
      find.byKey(const ValueKey('fractionPartitionBar.segment-2')),
    );

    expect(find.text('3/8'), findsOneWidget);
    expect(find.text('You found it.'), findsOneWidget);
  });

  testWidgets('comparison completes only after the exact comparison choice',
      (tester) async {
    await pumpScreen(tester);
    await nextExample(tester);
    await nextExample(tester);
    expect(
      find.text('Choose how these fractions compare.'),
      findsOneWidget,
    );
    expect(find.text('2/3  ?  3/4'), findsOneWidget);
    expect(find.text('You found it.'), findsNothing);

    await tapAndPump(
      tester,
      find.byKey(
        ValueKey(
          'numberSense.answer.${NumberSenseComparison.lessThan.name}',
        ),
      ),
    );

    expect(find.text('You found it.'), findsOneWidget);
  });

  testWidgets('Reset restores the active guided example start', (tester) async {
    await pumpScreen(tester);
    await nextExample(tester);
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('fractionPartitionBar.segment-2')),
    );
    expect(find.text('3/8'), findsOneWidget);

    await tapAndPump(tester, find.byKey(const ValueKey('numberSense.reset')));

    expect(find.text('0/8'), findsOneWidget);
    expect(find.text('Place a fraction'), findsOneWidget);
    expect(find.text('You found it.'), findsNothing);
  });

  testWidgets('Try another cycles the three examples and wraps in Guided',
      (tester) async {
    await pumpScreen(tester);
    for (final title in [
      'Place a fraction',
      'Compare fractions',
      'Make an equivalent fraction',
    ]) {
      await nextExample(tester);
      expect(find.text(title), findsOneWidget);
      expect(find.text('Guided'), findsOneWidget);
    }
  });

  testWidgets('Free explore retains value and Guided restarts active example',
      (tester) async {
    await pumpScreen(tester);
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('numberSenseWorkspace.denominator-4')),
    );
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('fractionPartitionBar.segment-1')),
    );
    expect(find.text('2/4'), findsOneWidget);

    await tapAndPump(
      tester,
      find.byKey(const ValueKey('numberSense.modeFreeExplore')),
    );
    expect(find.text('2/4'), findsOneWidget);
    expect(find.text('Reset'), findsNothing);

    await tapAndPump(
      tester,
      find.byKey(const ValueKey('numberSense.modeGuided')),
    );
    expect(find.text('Make an equivalent fraction'), findsOneWidget);
    expect(find.text('0/2'), findsOneWidget);
  });

  testWidgets('returning from Free explore preserves non-first active example',
      (tester) async {
    await pumpScreen(tester);
    await nextExample(tester);
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('fractionPartitionBar.segment-2')),
    );
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('numberSense.modeFreeExplore')),
    );
    expect(find.text('3/8'), findsOneWidget);

    await tapAndPump(
      tester,
      find.byKey(const ValueKey('numberSense.modeGuided')),
    );
    expect(find.text('Place a fraction'), findsOneWidget);
    expect(find.text('0/8'), findsOneWidget);
  });

  testWidgets('Try another from Free explore advances and enters Guided',
      (tester) async {
    await pumpScreen(tester);
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('numberSense.modeFreeExplore')),
    );
    await nextExample(tester);

    expect(find.text('Place a fraction'), findsOneWidget);
    expect(find.text('Guided'), findsOneWidget);
    expect(find.text('0/8'), findsOneWidget);
  });

  testWidgets('uses preference and system Reduce Motion settings',
      (tester) async {
    final reduceMotion = LocalPreferencesService.instance.reduceMotion;
    final previous = reduceMotion.value;
    addTearDown(() => reduceMotion.value = previous);

    reduceMotion.value = true;
    await tester.pumpWidget(app());
    expect(
      tester
          .widget<NumberSenseLabWorkspace>(
            find.byType(NumberSenseLabWorkspace),
          )
          .reduceMotion,
      isTrue,
    );

    reduceMotion.value = false;
    await tester.pumpWidget(app(systemReduceMotion: true));
    expect(
      tester
          .widget<NumberSenseLabWorkspace>(
            find.byType(NumberSenseLabWorkspace),
          )
          .reduceMotion,
      isTrue,
    );
  });

  testWidgets('example and completion changes have live-region semantics',
      (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpScreen(tester);
    var exampleSemantics = tester.getSemantics(
      find.byKey(const ValueKey('numberSense.example.equivalenceHalf')),
    );
    expect(
      exampleSemantics.getSemanticsData().flagsCollection.isLiveRegion,
      isTrue,
    );

    await nextExample(tester);
    exampleSemantics = tester.getSemantics(
      find.byKey(const ValueKey('numberSense.example.placeThreeEighths')),
    );
    expect(
      exampleSemantics.getSemanticsData().flagsCollection.isLiveRegion,
      isTrue,
    );

    await tapAndPump(
      tester,
      find.byKey(const ValueKey('fractionPartitionBar.segment-2')),
    );
    final completion = tester.getSemantics(
      find.byKey(const ValueKey('numberSense.guidedCompletion')),
    );
    expect(
      completion.getSemanticsData().flagsCollection.isLiveRegion,
      isTrue,
    );
    semantics.dispose();
  });

  testWidgets('mode and action controls use localized accessible labels',
      (tester) async {
    await pumpScreen(tester);
    for (final key in [
      'numberSense.modeGuided',
      'numberSense.modeFreeExplore',
      'numberSense.reset',
      'numberSense.tryAnotherExample',
    ]) {
      expect(tester.getSemantics(find.byKey(ValueKey(key))).label, isNotEmpty);
      expect(tester.getSize(find.byKey(ValueKey(key))).height,
          greaterThanOrEqualTo(48));
    }
  });

  for (final size in [
    const Size(390, 844),
    const Size(915, 412),
  ]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets(
          'has no overflow and controls remain reachable at '
          '${size.width}x${size.height}, ${scale}x text', (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = size;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(app(textScale: scale));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        final next = find.byKey(
          const ValueKey('numberSense.tryAnotherExample'),
        );
        await tester.ensureVisible(next);
        expect(next, findsOneWidget);
        await tester.tap(next);
        await tester.pumpAndSettle();
        expect(find.text('Place a fraction'), findsOneWidget);
      });
    }
  }

  test('learner-facing screen copy comes from localization accessors', () {
    final source = File('lib/screens/visual_maths/number_sense_lab_screen.dart')
        .readAsStringSync();
    expect(RegExp(r"""Text\(\s*['"]\w""").hasMatch(source), isFalse);
    expect(source, contains('AppLocalizations.of(context)'));
    expect(source, contains('l10n.numberSense'));
  });
}
