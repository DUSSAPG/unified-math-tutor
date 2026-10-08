import 'dart:io';
import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/number_sense_example.dart';
import 'package:unified_math_tutor/models/number_sense_guided_practice.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/interactive_labs_progress_service.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';
import 'package:unified_math_tutor/widgets/number_sense/number_sense_lab_workspace.dart';
import 'package:unified_math_tutor/screens/visual_maths/number_sense_lab_screen.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await InteractiveLabsProgressService.instance.init();
  });

  Widget app({
    double textScale = 1,
    bool systemReduceMotion = false,
    ThemeData? theme,
  }) =>
      MaterialApp(
        theme: theme ?? AppTheme.light(),
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

  Future<void> pumpDefault(WidgetTester tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
  }

  Future<void> tapAndPump(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  // Most tests exercise the equivalence example, which is one skill after the
  // default Place a fraction entry.
  Future<void> pumpScreen(WidgetTester tester) async {
    await pumpDefault(tester);
    await tapAndPump(
        tester, find.byKey(const ValueKey('numberSense.nextSkill')));
  }

  NumberSenseExampleId currentExample(WidgetTester tester) {
    final key = find
        .byWidgetPredicate(
          (widget) =>
              widget.key is ValueKey<String> &&
              (widget.key! as ValueKey<String>)
                  .value
                  .startsWith('numberSense.example.'),
        )
        .evaluate()
        .first
        .widget
        .key! as ValueKey<String>;
    return NumberSenseExampleId.values.byName(key.value.split('.').last);
  }

  Future<void> goToExample(
    WidgetTester tester,
    NumberSenseExampleId id,
  ) async {
    final skill = NumberSenseGuidedPractice.skillOf(id);
    await tapAndPump(
        tester, find.byKey(const ValueKey('numberSense.chooseSkill')));
    await tapAndPump(
        tester, find.byKey(ValueKey('numberSense.skill.${skill.name}')));
    if (skill == NumberSenseGuidedSkill.compareFractions) {
      await tapAndPump(
        tester,
        find.byKey(const ValueKey('numberSense.focus.mixed')),
      );
      final order = NumberSenseExample.all
          .map((example) => example.id)
          .where((e) => NumberSenseGuidedPractice.skillOf(e) == skill)
          .toList();
      for (var i = 0; i < order.indexOf(id); i++) {
        await tapAndPump(
          tester,
          find.byKey(const ValueKey('numberSense.practiseThis')),
        );
      }
    }
    await tester.pumpAndSettle();
  }

  // Steps through every guided example in NumberSenseExample.all order.
  Future<void> nextExample(WidgetTester tester) async {
    final all = NumberSenseExample.all.map((example) => example.id).toList();
    final next = all[(all.indexOf(currentExample(tester)) + 1) % all.length];
    await goToExample(tester, next);
  }

  Future<void> showComparison(
    WidgetTester tester, {
    int comparisonIndex = 0,
  }) =>
      goToExample(tester, NumberSenseExample.all[2 + comparisonIndex].id);

  Future<void> showHundredthsActivity(WidgetTester tester) =>
      goToExample(tester, NumberSenseExampleId.findOneHundredth);
  testWidgets('starts Guided on Place a fraction as skill 1', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpDefault(tester);

    expect(find.text('Number Sense Lab'), findsOneWidget);
    expect(find.text('Skill 1 of 4: Place a fraction'), findsOneWidget);
    expect(find.text('Place a fraction'), findsOneWidget);
    expect(find.text('Target: 3/8'), findsOneWidget);
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
    expect(find.text('2/8  ?  5/8'), findsOneWidget);
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

  testWidgets('comparison shows both bars and labelled marker controls',
      (tester) async {
    await pumpScreen(tester);
    await showComparison(tester);

    expect(
      find.byKey(const ValueKey('numberSense.comparisonFraction.left')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('numberSense.comparisonFraction.right')),
      findsOneWidget,
    );
    final leftBar = find.byKey(
      const ValueKey('numberSense.comparisonBar.left'),
    );
    final rightBar = find.byKey(
      const ValueKey('numberSense.comparisonBar.right'),
    );
    expect(tester.getSize(leftBar).width, tester.getSize(rightBar).width);
    expect(
      find.byKey(
        const ValueKey('numberSense.comparisonBar.left.part-1'),
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(
        const ValueKey('numberSense.comparisonBar.right.part-4'),
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(
        const ValueKey('numberSense.comparisonNumberLine.semantics'),
      ),
      findsOneWidget,
    );
    expect(
      tester
          .getTopLeft(
            find.byKey(
              const ValueKey('numberSense.comparisonMarker.left'),
            ),
          )
          .dx,
      lessThan(
        tester
            .getTopLeft(
              find.byKey(
                const ValueKey('numberSense.comparisonMarker.right'),
              ),
            )
            .dx,
      ),
    );
    for (final side in ['left', 'right']) {
      expect(
        tester
            .getSize(
              find.byKey(ValueKey('numberSense.comparisonMarker.$side')),
            )
            .height,
        greaterThanOrEqualTo(48),
      );
    }
    expect(find.byType(NumberSenseLabWorkspace), findsNothing);
    for (final denominator in [2, 3, 4, 6, 8]) {
      expect(
        find.byKey(
          ValueKey('numberSenseWorkspace.denominator-$denominator'),
        ),
        findsNothing,
      );
    }
    expect(
      find.byKey(
        const ValueKey('numberSense.comparisonMarker.left.point'),
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(
        const ValueKey('numberSense.comparisonMarker.right.point'),
      ),
      findsOneWidget,
    );
    expect(
      tester
          .getCenter(
            find.byKey(
              const ValueKey('numberSense.comparisonMarker.left.point'),
            ),
          )
          .dx,
      lessThan(
        tester
            .getCenter(
              find.byKey(
                const ValueKey('numberSense.comparisonMarker.right.point'),
              ),
            )
            .dx,
      ),
    );
    expect(find.byKey(const ValueKey('numberSense.comparisonFeedback')),
        findsNothing);
  });

  testWidgets('tapping either marker shows its exact decimal explanation',
      (tester) async {
    await pumpScreen(tester);
    await showComparison(tester, comparisonIndex: 4);

    await tapAndPump(
      tester,
      find.byKey(
        const ValueKey('numberSense.comparisonMarker.left'),
      ),
    );
    expect(
      find.text('2/3 = 0.666… — 2 of 3 equal parts'),
      findsOneWidget,
    );

    await tapAndPump(
      tester,
      find.byKey(
        const ValueKey('numberSense.comparisonMarker.right'),
      ),
    );
    expect(
      find.text('3/4 = 0.75 — 3 of 4 equal parts'),
      findsOneWidget,
    );
  });

  testWidgets('each mathematical answer control visibly selects itself',
      (tester) async {
    await pumpScreen(tester);
    await showComparison(tester);

    for (final answer in NumberSenseComparison.values) {
      final choice = find.byKey(
        ValueKey('numberSense.answer.${answer.name}'),
      );
      await tapAndPump(tester, choice);
      expect(
        find.descendant(of: choice, matching: find.byIcon(Icons.check)),
        findsOneWidget,
      );
      for (final other in NumberSenseComparison.values.where(
        (candidate) => candidate != answer,
      )) {
        expect(
          find.descendant(
            of: find.byKey(ValueKey('numberSense.answer.${other.name}')),
            matching: find.byIcon(Icons.check),
          ),
          findsNothing,
        );
      }
    }
  });

  testWidgets('comparison explains both incorrect and correct answers',
      (tester) async {
    await pumpScreen(tester);
    await showComparison(tester, comparisonIndex: 4);

    await tapAndPump(
      tester,
      find.byKey(
        ValueKey('numberSense.answer.${NumberSenseComparison.equal.name}'),
      ),
    );

    expect(find.text('Not quite. 2/3 is less than 3/4.'), findsOneWidget);
    expect(
      find.text('2 × 4 = 8; 3 × 3 = 9; since 8 < 9, 2/3 < 3/4.'),
      findsOneWidget,
    );
    expect(find.text('You found it.'), findsNothing);
    expect(
      tester
          .getSemantics(
            find.byKey(const ValueKey('numberSense.comparisonFeedback')),
          )
          .getSemanticsData()
          .flagsCollection
          .isLiveRegion,
      isTrue,
    );

    await tapAndPump(
      tester,
      find.byKey(
        ValueKey(
          'numberSense.answer.${NumberSenseComparison.lessThan.name}',
        ),
      ),
    );

    expect(find.text('Correct: 2/3 < 3/4.'), findsOneWidget);
    expect(
      find.text('2 × 4 = 8; 3 × 3 = 9; since 8 < 9, 2/3 < 3/4.'),
      findsOneWidget,
    );
    expect(find.text('You found it.'), findsOneWidget);
    expect(
      tester
          .widget<OutlinedButton>(
            find.byKey(
              ValueKey(
                'numberSense.answer.${NumberSenseComparison.lessThan.name}',
              ),
            ),
          )
          .style!
          .side!
          .resolve({})?.width,
      2,
    );
    expect(
      find.descendant(
        of: find.byKey(
          ValueKey(
            'numberSense.answer.${NumberSenseComparison.lessThan.name}',
          ),
        ),
        matching: find.byIcon(Icons.check),
      ),
      findsOneWidget,
    );
  });

  testWidgets('all five comparison examples show exact strategy explanations',
      (tester) async {
    const examples = [
      (
        '2/8  ?  5/8',
        NumberSenseComparison.lessThan,
        'Correct: 2/8 < 5/8.',
        'Both fractions are in eighths. 5 eighths is more than 2 eighths, '
            'so 2/8 < 5/8.',
      ),
      (
        '3/4  ?  3/8',
        NumberSenseComparison.greaterThan,
        'Correct: 3/4 > 3/8.',
        'Both fractions show 3 parts. Fourths are larger pieces than eighths, '
            'so 3/4 > 3/8.',
      ),
      (
        '3/6  ?  1/2',
        NumberSenseComparison.equal,
        'Correct: 3/6 = 1/2.',
        '3/6 is the same value as 1/2. Both are at the same point on the '
            'number line.',
      ),
      (
        '5/8  ?  1/2',
        NumberSenseComparison.greaterThan,
        'Correct: 5/8 > 1/2.',
        'One half is 4/8. Since 5/8 is one eighth more than 4/8, '
            '5/8 > 1/2.',
      ),
      (
        '2/3  ?  3/4',
        NumberSenseComparison.lessThan,
        'Correct: 2/3 < 3/4.',
        '2 × 4 = 8; 3 × 3 = 9; since 8 < 9, 2/3 < 3/4.',
      ),
    ];
    await pumpScreen(tester);
    await nextExample(tester);
    await nextExample(tester);
    for (var index = 0; index < examples.length; index++) {
      final (question, answer, result, explanation) = examples[index];
      expect(find.text(question), findsOneWidget);
      await tapAndPump(
        tester,
        find.byKey(ValueKey('numberSense.answer.${answer.name}')),
      );
      expect(find.text(result), findsOneWidget);
      expect(find.text(explanation), findsOneWidget);
      if (index < examples.length - 1) await nextExample(tester);
    }
  });

  testWidgets('scope and equal-parts controls explain the starter model',
      (tester) async {
    await pumpScreen(tester);

    expect(
      find.text(
        'This starter whole-part model supports 2, 3, 4, 6 or 8 equal parts only. '
        'Hundredths are supported on the precision line; other unsupported '
        'denominators need a precision or zoomed line.',
      ),
      findsOneWidget,
    );
    expect(find.text('Equal parts'), findsOneWidget);
    for (final denominator in [2, 3, 4, 6, 8]) {
      expect(
        find.byKey(
          ValueKey('numberSenseWorkspace.denominator-$denominator'),
        ),
        findsOneWidget,
      );
    }
  });

  testWidgets('no standalone term or symbol help remnants are rendered',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    void expectNoRemnants() {
      for (final label in ['Numerator', 'Denominator', 'Equivalent']) {
        expect(find.text(label), findsNothing);
      }
      // Symbols may only appear inside the labelled answer buttons.
      for (final symbol in ['<', '=', '>']) {
        expect(
          find.descendant(
            of: find.byType(Scaffold),
            matching: find.text(symbol),
          ),
          findsNWidgets(
            find
                .descendant(
                  of: find.byWidgetPredicate(
                    (widget) =>
                        widget.key is ValueKey<String> &&
                        (widget.key! as ValueKey<String>)
                            .value
                            .startsWith('numberSense.answer.'),
                  ),
                  matching: find.text(symbol),
                )
                .evaluate()
                .length,
          ),
        );
      }
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget.key is ValueKey<String> &&
              (widget.key! as ValueKey<String>)
                  .value
                  .startsWith('numberSense.help.'),
        ),
        findsNothing,
      );
    }

    for (final size in [const Size(390, 844), const Size(915, 412)]) {
      tester.view.physicalSize = size;
      await pumpScreen(tester);
      expectNoRemnants();

      await showComparison(tester);
      expectNoRemnants();
      for (final answer in NumberSenseComparison.values) {
        final button =
            find.byKey(ValueKey('numberSense.answer.${answer.name}'));
        expect(button, findsOneWidget);
      }
      expect(find.text('Less than'), findsOneWidget);
      expect(find.text('Equal to'), findsOneWidget);
      expect(find.text('Greater than'), findsOneWidget);
      await tapAndPump(
        tester,
        find.byKey(const ValueKey('numberSense.answer.lessThan')),
      );
      expectNoRemnants();

      await tapAndPump(
        tester,
        find.byKey(const ValueKey('numberSense.modeFreeExplore')),
      );
      expectNoRemnants();
      await tester.pumpWidget(const SizedBox.shrink());
    }
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

  testWidgets('Guided has one repeat action, Practise this, and no Try another',
      (tester) async {
    await pumpDefault(tester);
    final tryAnother = find.byKey(const ValueKey('numberSense.practiseThis'));
    expect(find.text('Try another example'), findsNothing);
    expect(find.text('Practise this'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('numberSense.tryAnotherExample')),
      findsNothing,
    );
    // Top-level skills restart in place and never move to another skill.
    await tapAndPump(tester, tryAnother);
    expect(find.text('Skill 1 of 4: Place a fraction'), findsOneWidget);
    expect(find.text('Target: 3/8'), findsOneWidget);

    // A chosen comparison focus is retained.
    await goToExample(
      tester,
      NumberSenseExampleId.compareThreeQuartersAndThreeEighths,
    );
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('numberSense.chooseSkill')),
    );
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('numberSense.skill.compareFractions')),
    );
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('numberSense.focus.sameNumerator')),
    );
    for (var i = 0; i < 3; i++) {
      await tapAndPump(tester, tryAnother);
      expect(find.text('3/4  ?  3/8'), findsOneWidget);
      expect(
        find.text('Skill 3 of 4: Compare fractions'),
        findsOneWidget,
      );
    }

    await showHundredthsActivity(tester);
    await tapAndPump(tester, tryAnother);
    expect(find.text('Skill 4 of 4: Find one hundredth'), findsOneWidget);
    expect(find.text('Target: 1/100'), findsOneWidget);
  });
  testWidgets('Guided hundredths activity shows exact target and feedback',
      (tester) async {
    await pumpScreen(tester);
    await showHundredthsActivity(tester);

    expect(find.text('Find one hundredth'), findsOneWidget);
    expect(find.text('Target: 1/100'), findsOneWidget);
    expect(find.text('1/100 = 0.01'), findsOneWidget);
    expect(find.text('0 = 0.00'), findsOneWidget);
    expect(find.text('0/100'), findsNothing);
    for (var hundredths = 0; hundredths <= 10; hundredths++) {
      final tick = find.byKey(
        ValueKey('hundredthsPrecisionLine.tick.$hundredths'),
      );
      expect(
        tick,
        findsOneWidget,
      );
      expect(tester.getSize(tick).width, greaterThanOrEqualTo(48));
      expect(tester.getSize(tick).height, greaterThanOrEqualTo(48));
    }

    await tapAndPump(
      tester,
      find.byKey(const ValueKey('hundredthsPrecisionLine.tick.4')),
    );
    expect(find.text('4/100 = 0.04'), findsOneWidget);
    expect(
      find.text(
        'You selected 0.04. One hundredth is the next tick after 0.00: '
        'choose 0.01.',
      ),
      findsOneWidget,
    );
    expect(find.text('You found it.'), findsNothing);

    await tapAndPump(
      tester,
      find.byKey(const ValueKey('hundredthsPrecisionLine.tick.1')),
    );
    expect(find.text('1/100 = 0.01'), findsNWidgets(2));
    expect(
        find.text('1/100 means 0.01: 1 of 100 equal parts.'), findsOneWidget);
    expect(find.text('You found it.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Guided hundredths explains selecting zero immediately',
      (tester) async {
    await pumpScreen(tester);
    await showHundredthsActivity(tester);
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('hundredthsPrecisionLine.tick.0')),
    );

    expect(find.text('0 = 0.00'), findsOneWidget);
    expect(find.text('0/100'), findsNothing);
    expect(
      find.text(
        '0.00 is zero. One hundredth is the first tick to the right: 0.01.',
      ),
      findsOneWidget,
    );
    expect(find.text('You found it.'), findsNothing);
  });

  testWidgets('Free Explore precision line taps, drags and clears exactly',
      (tester) async {
    await pumpScreen(tester);
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('numberSense.modeFreeExplore')),
    );
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('numberSense.explore.precisionLine')),
    );

    expect(find.text('Precision line'), findsOneWidget);
    expect(find.text('0 = 0.00'), findsOneWidget);
    expect(find.text('0/100'), findsNothing);
    expect(find.text('Zero is at the start of the line.'), findsOneWidget);
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('hundredthsPrecisionLine.tick.7')),
    );
    expect(find.text('7/100 = 0.07'), findsOneWidget);
    expect(
        find.text('7/100 means 0.07: 7 of 100 equal parts.'), findsOneWidget);

    final track = find.byKey(
      const ValueKey('hundredthsPrecisionLine.track'),
    );
    await tester.ensureVisible(track);
    final topLeft = tester.getTopLeft(track);
    final targetX = 28 + (tester.getSize(track).width - 56) * 0.4;
    await tester.dragFrom(
        topLeft + const Offset(28, 28), Offset(targetX - 28, 0));
    await tester.pumpAndSettle();
    expect(find.text('4/100 = 0.04'), findsOneWidget);

    await tapAndPump(
      tester,
      find.byKey(const ValueKey('numberSense.clearExplore')),
    );
    expect(find.text('0 = 0.00'), findsOneWidget);
    expect(find.text('0/100'), findsNothing);
    expect(find.text('Zero is at the start of the line.'), findsOneWidget);
    expect(find.text('4/100 = 0.04'), findsNothing);
    expect(find.text('Find one hundredth'), findsNothing);
    expect(find.text('Target: 1/100'), findsNothing);
    expect(find.text('You found it.'), findsNothing);
    expect(
      find.byKey(const ValueKey('numberSense.tryAnotherExample')),
      findsNothing,
    );
  });

  testWidgets('Free Explore retains the selected precision model on Clear',
      (tester) async {
    await pumpScreen(tester);
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('numberSense.modeFreeExplore')),
    );
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('numberSense.explore.precisionLine')),
    );
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('hundredthsPrecisionLine.tick.10')),
    );
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('numberSense.clearExplore')),
    );

    expect(
      tester
          .widget<ChoiceChip>(
            find.byKey(const ValueKey('numberSense.explore.precisionLine')),
          )
          .selected,
      isTrue,
    );
    expect(find.text('0 = 0.00'), findsOneWidget);
    expect(find.text('0/100'), findsNothing);
    expect(find.text('Zero is at the start of the line.'), findsOneWidget);
  });

  testWidgets('entering Free Explore from the hundredths activity keeps value',
      (tester) async {
    await pumpScreen(tester);
    await showHundredthsActivity(tester);
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('hundredthsPrecisionLine.tick.7')),
    );
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('numberSense.modeFreeExplore')),
    );

    expect(find.text('7/100 = 0.07'), findsOneWidget);
    expect(find.text('Find one hundredth'), findsNothing);
    expect(find.text('Target: 1/100'), findsNothing);
    expect(find.text('You found it.'), findsNothing);
    expect(
      find.text('You selected 0.07. One hundredth is the next tick after 0.00: '
          'choose 0.01.'),
      findsNothing,
    );
  });

  testWidgets('placement and equivalence give exact immediate feedback',
      (tester) async {
    await pumpScreen(tester);
    await nextExample(tester);
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('fractionPartitionBar.segment-1')),
    );
    expect(find.text('2/8'), findsOneWidget);
    expect(
      find.text('Not quite. You chose 2/8. Move one tick right to reach 3/8.'),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('numberSense.guidedPlacementFeedback')),
        findsOneWidget);

    await tapAndPump(
      tester,
      find.byKey(const ValueKey('fractionPartitionBar.segment-2')),
    );
    expect(find.text('3/8'), findsOneWidget);
    expect(find.text('You found it.'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('numberSense.guidedPlacementFeedback')),
      findsNothing,
    );

    await tapAndPump(tester, find.byKey(const ValueKey('numberSense.reset')));
    expect(
      find.byKey(const ValueKey('numberSense.guidedPlacementFeedback')),
      findsNothing,
    );
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('fractionPartitionBar.segment-1')),
    );
    expect(
      find.byKey(const ValueKey('numberSense.guidedPlacementFeedback')),
      findsOneWidget,
    );
    await nextExample(tester);
    expect(
      find.byKey(const ValueKey('numberSense.guidedPlacementFeedback')),
      findsNothing,
    );

    for (var step = 0; step < 6; step++) {
      await nextExample(tester);
    }
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('numberSenseWorkspace.denominator-6')),
    );
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('fractionPartitionBar.segment-5')),
    );
    expect(find.text('6/6'), findsOneWidget);
    expect(
      find.text('6/6 is one whole, not 1/2. Shade half of the equal parts.'),
      findsOneWidget,
    );
    expect(find.text('You found it.'), findsNothing);

    await tapAndPump(
      tester,
      find.byKey(const ValueKey('fractionPartitionBar.segment-2')),
    );
    expect(find.text('3/6'), findsOneWidget);
    expect(find.text('You found it.'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('numberSense.guidedPlacementFeedback')),
      findsNothing,
    );
  });

  testWidgets('number-line and denominator changes also trigger feedback',
      (tester) async {
    await pumpScreen(tester);
    await nextExample(tester);

    final line = find.byKey(
      const ValueKey('unitFractionNumberLine.interaction'),
    );
    await tester.ensureVisible(line);
    final lineBox = tester.renderObject<RenderBox>(line);
    const inset = 20.0;
    final xForQuarter = inset + (lineBox.size.width - inset * 2) * 0.25;
    await tester.tapAt(
      tester.getTopLeft(line) + Offset(xForQuarter, 44),
    );
    await tester.pumpAndSettle();
    expect(find.text('2/8'), findsOneWidget);
    expect(
      find.text('Not quite. You chose 2/8. Move one tick right to reach 3/8.'),
      findsOneWidget,
    );

    await tapAndPump(
      tester,
      find.byKey(const ValueKey('numberSenseWorkspace.denominator-4')),
    );
    expect(find.text('1/4'), findsOneWidget);
    expect(
      find.text(
        'Not quite. You chose 1/4. The target is 3/8. '
        'Choose equal parts that can show the target fraction.',
      ),
      findsOneWidget,
    );

    final dragLine = find.byKey(
      const ValueKey('unitFractionNumberLine.interaction'),
    );
    await tester.ensureVisible(dragLine);
    final dragBox = tester.renderObject<RenderBox>(dragLine);
    final dragStart = tester.getTopLeft(dragLine) +
        Offset(inset + (dragBox.size.width - inset * 2) * 0.25, 44);
    final dragEnd = tester.getTopLeft(dragLine) +
        Offset(inset + (dragBox.size.width - inset * 2) * 0.75, 44);
    await tester.dragFrom(dragStart, dragEnd - dragStart);
    await tester.pumpAndSettle();
    expect(find.text('3/4'), findsOneWidget);
    expect(
      find.text(
        'Not quite. You chose 3/4. The target is 3/8. '
        'Choose equal parts that can show the target fraction.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('wrong Guided whole-part feedback is live in light and dark',
      (tester) async {
    final semantics = tester.ensureSemantics();
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final sizes = [const Size(390, 844), const Size(915, 412)];
    for (final theme in [AppTheme.light(), AppTheme.dark()]) {
      for (final size in sizes) {
        tester.view.physicalSize = size;
        for (final scale in [1.0, 2.0]) {
          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pumpWidget(app(theme: theme, textScale: scale));
          await tester.pumpAndSettle();
          await tapAndPump(
            tester,
            find.byKey(const ValueKey('fractionPartitionBar.segment-1')),
          );
          expect(
            find.text(
              'Not quite. You chose 2/8. Move one tick right to reach 3/8.',
            ),
            findsOneWidget,
          );
          final feedback = tester.getSemantics(
            find.byKey(const ValueKey('numberSense.guidedPlacementFeedback')),
          );
          expect(
              feedback.getSemanticsData().flagsCollection.isLiveRegion, isTrue);
          expect(tester.takeException(), isNull);
        }
      }
    }
    semantics.dispose();
  });

  testWidgets('precision completion keeps the shared success treatment',
      (tester) async {
    for (final theme in [AppTheme.light(), AppTheme.dark()]) {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(app(theme: theme));
      await tester.pumpAndSettle();
      await showHundredthsActivity(tester);
      await tapAndPump(
        tester,
        find.byKey(const ValueKey('hundredthsPrecisionLine.tick.1')),
      );

      final completion = tester.getSemantics(
        find.byKey(const ValueKey('numberSense.guidedCompletion')),
      );
      expect(completion.getSemanticsData().label, 'You found it.');
      expect(
        completion.getSemanticsData().hasAction(SemanticsAction.tap),
        isFalse,
      );
      final icon = tester.widget<Icon>(
        find.byKey(const ValueKey('numberSense.guidedCompletion.icon')),
      );
      final text = tester.widget<Text>(
        find.byKey(const ValueKey('numberSense.guidedCompletion.text')),
      );
      expect(icon.icon, Icons.check_circle);
      expect(icon.color, text.style!.color);
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
    expect(
        find.text(
            'Choose a model, then tap equal parts or tap/drag a point to explore fractions.'),
        findsOneWidget);
    expect(find.text('Target: 1/2'), findsNothing);
    expect(find.text('You found it.'), findsNothing);
    expect(find.byKey(const ValueKey('numberSense.tryAnotherExample')),
        findsNothing);
    expect(find.byKey(const ValueKey('numberSense.guidedCompletion')),
        findsNothing);
    expect(
        find.byKey(const ValueKey('numberSense.clearExplore')), findsOneWidget);

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

  testWidgets('Free Explore edits bar and number line, re-snaps and clears',
      (tester) async {
    await pumpScreen(tester);
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('fractionPartitionBar.segment-0')),
    );
    expect(find.text('1/2'), findsOneWidget);
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('numberSense.modeFreeExplore')),
    );

    expect(find.text('1/2'), findsOneWidget);
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('numberSenseWorkspace.denominator-4')),
    );
    expect(find.text('2/4'), findsOneWidget);

    final line = find.byKey(
      const ValueKey('unitFractionNumberLine.interaction'),
    );
    await tester.ensureVisible(line);
    final box = tester.renderObject<RenderBox>(line);
    const inset = 20.0;
    final xForThreeQuarters = inset + (box.size.width - inset * 2) * 0.75;
    await tester.tapAt(tester.getTopLeft(line) + Offset(xForThreeQuarters, 44));
    await tester.pumpAndSettle();
    expect(find.text('3/4'), findsOneWidget);

    final dragStart = tester.getTopLeft(line) + Offset(xForThreeQuarters, 44);
    final dragEnd = tester.getTopLeft(line) +
        Offset(
          inset + (box.size.width - inset * 2) * 0.25,
          44,
        );
    await tester.dragFrom(dragStart, dragEnd - dragStart);
    await tester.pumpAndSettle();
    expect(find.text('1/4'), findsOneWidget);

    await tapAndPump(
      tester,
      find.byKey(const ValueKey('numberSenseWorkspace.denominator-8')),
    );
    expect(find.text('2/8'), findsOneWidget);
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('fractionPartitionBar.segment-3')),
    );
    expect(find.text('4/8'), findsOneWidget);

    await tapAndPump(
      tester,
      find.byKey(const ValueKey('numberSense.clearExplore')),
    );
    expect(
      tester
          .widget<Text>(
            find.byKey(const ValueKey('numberSenseWorkspace.fraction')),
          )
          .data,
      '0',
    );
    expect(find.text('0/8'), findsNothing);
    expect(find.text('2/8'), findsNothing);
    expect(find.byKey(const ValueKey('numberSenseWorkspace.denominator-8')),
        findsOneWidget);
    expect(
        find.text(
            'Choose a model, then tap equal parts or tap/drag a point to explore fractions.'),
        findsOneWidget);
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
    final completionData = completion.getSemanticsData();
    expect(
      completionData.flagsCollection.isLiveRegion,
      isTrue,
    );
    expect(completionData.label, 'You found it.');
    expect(completionData.hasAction(SemanticsAction.tap), isFalse);
    expect(
      find.byKey(const ValueKey('numberSense.guidedCompletion.icon')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('numberSense.guidedCompletion.text')),
      findsOneWidget,
    );
    final completionIcon = tester.widget<Icon>(
      find.byKey(const ValueKey('numberSense.guidedCompletion.icon')),
    );
    final completionText = tester.widget<Text>(
      find.byKey(const ValueKey('numberSense.guidedCompletion.text')),
    );
    expect(completionIcon.icon, Icons.check_circle);
    expect(completionIcon.color, completionText.style!.color);
    expect(
      _contrastRatio(
        completionText.style!.color!,
        Color.alphaBlend(
          AppTheme.light()
              .extension<AppSemanticColors>()!
              .success
              .withValues(alpha: 0.1),
          AppTheme.light().extension<AppSemanticColors>()!.background,
        ),
      ),
      greaterThanOrEqualTo(4.5),
    );
    semantics.dispose();
  });

  testWidgets('guided success treatment is readable in dark theme',
      (tester) async {
    await tester.pumpWidget(app(theme: AppTheme.dark()));
    await tester.pumpAndSettle();
    await tapAndPump(
        tester, find.byKey(const ValueKey('numberSense.nextSkill')));
    await tapAndPump(
      tester,
      find.byKey(const ValueKey('fractionPartitionBar.segment-0')),
    );

    final colors = AppTheme.dark().extension<AppSemanticColors>()!;
    final icon = tester.widget<Icon>(
      find.byKey(const ValueKey('numberSense.guidedCompletion.icon')),
    );
    final text = tester.widget<Text>(
      find.byKey(const ValueKey('numberSense.guidedCompletion.text')),
    );
    expect(icon.color, colors.success);
    expect(text.style!.color, colors.success);
    expect(
      _contrastRatio(
        text.style!.color!,
        Color.alphaBlend(
          colors.success.withValues(alpha: 0.1),
          colors.background,
        ),
      ),
      greaterThanOrEqualTo(4.5),
    );
    final semantics = tester.getSemantics(
      find.byKey(const ValueKey('numberSense.guidedCompletion')),
    );
    expect(
        semantics.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
  });

  testWidgets('mode and action controls use localized accessible labels',
      (tester) async {
    await pumpScreen(tester);
    for (final key in [
      'numberSense.modeGuided',
      'numberSense.modeFreeExplore',
      'numberSense.reset',
      'numberSense.practiseThis',
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
        final next = find.byKey(const ValueKey('numberSense.nextSkill'));
        expect(find.text('Place a fraction'), findsOneWidget);
        await tester.ensureVisible(next);
        expect(next, findsOneWidget);
        await tester.tap(next);
        await tester.pumpAndSettle();
        expect(find.text('Make an equivalent fraction'), findsOneWidget);
        await tester.ensureVisible(next);
        await tester.tap(next);
        await tester.pumpAndSettle();
        expect(find.text('Compare fractions'), findsOneWidget);
        expect(
          find.byKey(const ValueKey('numberSense.comparisonFraction.left')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('numberSense.comparisonFraction.right')),
          findsOneWidget,
        );
        expect(find.byType(NumberSenseLabWorkspace), findsNothing);
        final lessThan = find.byKey(
          ValueKey(
            'numberSense.answer.${NumberSenseComparison.lessThan.name}',
          ),
        );
        await tester.ensureVisible(lessThan);
        await tester.tap(lessThan);
        await tester.pumpAndSettle();
        expect(find.text('Correct: 2/8 < 5/8.'), findsOneWidget);
        expect(tester.takeException(), isNull);
        for (var step = 0; step < 5; step++) {
          await tester.ensureVisible(next);
          await tester.tap(next);
          await tester.pumpAndSettle();
        }
        expect(find.text('Find one hundredth'), findsOneWidget);
        expect(find.text('Target: 1/100'), findsOneWidget);
        await tester.ensureVisible(
          find.byKey(const ValueKey('hundredthsPrecisionLine.tick.1')),
        );
        await tester.tap(
          find.byKey(const ValueKey('hundredthsPrecisionLine.tick.1')),
        );
        await tester.pumpAndSettle();
        expect(find.text('You found it.'), findsOneWidget);
        expect(tester.takeException(), isNull);

        await tester.ensureVisible(
          find.byKey(const ValueKey('numberSense.modeFreeExplore')),
        );
        await tester.tap(
          find.byKey(const ValueKey('numberSense.modeFreeExplore')),
        );
        await tester.pumpAndSettle();
        await tester.ensureVisible(
          find.byKey(const ValueKey('numberSense.explore.precisionLine')),
        );
        await tester.tap(
          find.byKey(const ValueKey('numberSense.explore.precisionLine')),
        );
        await tester.pumpAndSettle();
        expect(find.text('You found it.'), findsNothing);
        expect(find.text('Find one hundredth'), findsNothing);
        expect(tester.takeException(), isNull);
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

double _contrastRatio(Color foreground, Color background) {
  final foregroundLuminance = foreground.computeLuminance();
  final backgroundLuminance = background.computeLuminance();
  final lighter = foregroundLuminance > backgroundLuminance
      ? foregroundLuminance
      : backgroundLuminance;
  final darker = foregroundLuminance > backgroundLuminance
      ? backgroundLuminance
      : foregroundLuminance;
  return (lighter + 0.05) / (darker + 0.05);
}
