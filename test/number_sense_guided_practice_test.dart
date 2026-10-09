import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/number_sense_example.dart';
import 'package:unified_math_tutor/models/number_sense_guided_practice.dart';
import 'package:unified_math_tutor/screens/visual_maths/number_sense_lab_screen.dart';
import 'package:unified_math_tutor/services/interactive_labs_progress_service.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';

void main() {
  group('NumberSenseGuidedPractice', () {
    const placeBank = [
      NumberSenseExampleId.placeThreeEighths,
      NumberSenseExampleId.placeOneHalf,
      NumberSenseExampleId.placeTwoThirds,
    ];
    const equivalentBank = [
      NumberSenseExampleId.equivalenceHalf,
      NumberSenseExampleId.equivalenceHalfFourths,
      NumberSenseExampleId.equivalenceHalfSixths,
      NumberSenseExampleId.equivalenceHalfEighths,
    ];
    const compareBank = [
      NumberSenseExampleId.compareTwoEighthsAndFiveEighths,
      NumberSenseExampleId.compareThreeQuartersAndThreeEighths,
      NumberSenseExampleId.compareThreeSixthsAndOneHalf,
      NumberSenseExampleId.compareFiveEighthsAndOneHalf,
      NumberSenseExampleId.compareTwoThirdsAndThreeQuarters,
    ];
    const hundredthsBank = [
      NumberSenseExampleId.findOneHundredth,
      NumberSenseExampleId.findThreeHundredths,
      NumberSenseExampleId.findSixHundredths,
    ];

    test('banks are explicit, ordered and resolvable', () {
      expect(
          NumberSenseGuidedPractice.bank[NumberSenseGuidedSkill.placeFraction],
          placeBank);
      expect(
          NumberSenseGuidedPractice.bank[NumberSenseGuidedSkill.makeEquivalent],
          equivalentBank);
      expect(
          NumberSenseGuidedPractice
              .bank[NumberSenseGuidedSkill.compareFractions],
          compareBank);
      expect(
          NumberSenseGuidedPractice
              .bank[NumberSenseGuidedSkill.findOneHundredth],
          hundredthsBank);
      for (final ids in NumberSenseGuidedPractice.bank.values) {
        for (final id in ids) {
          expect(NumberSenseExample.of(id).id, id);
        }
      }
    });

    test('next skill follows the teaching order, wraps, starts first example',
        () {
      final practice = NumberSenseGuidedPractice();
      expect(practice.skill, NumberSenseGuidedSkill.placeFraction);
      expect(practice.current, placeBank.first);
      expect(practice.anotherExample(), placeBank[1]);
      expect(practice.nextSkill(), equivalentBank.first);
      expect(practice.nextSkill(), compareBank.first);
      expect(practice.nextSkill(), hundredthsBank.first);
      expect(practice.skill, NumberSenseGuidedSkill.findOneHundredth);
      expect(practice.nextSkill(), placeBank.first);
      expect(practice.skill, NumberSenseGuidedSkill.placeFraction);
    });

    test('another example cycles within each bank, wraps, never switches skill',
        () {
      final practice = NumberSenseGuidedPractice();
      for (final entry in {
        NumberSenseGuidedSkill.placeFraction: placeBank,
        NumberSenseGuidedSkill.makeEquivalent: equivalentBank,
        NumberSenseGuidedSkill.compareFractions: compareBank,
        NumberSenseGuidedSkill.findOneHundredth: hundredthsBank,
      }.entries) {
        expect(practice.selectSkill(entry.key), entry.value.first);
        for (var i = 1; i <= entry.value.length; i++) {
          expect(
              practice.anotherExample(), entry.value[i % entry.value.length]);
          expect(practice.skill, entry.key);
        }
        expect(practice.current, entry.value.first);
      }
    });

    test('practise restarts the exact current example', () {
      final practice = NumberSenseGuidedPractice()..anotherExample();
      expect(practice.practise(), placeBank[1]);
      expect(practice.practise(), placeBank[1]);
      practice.selectSkill(NumberSenseGuidedSkill.findOneHundredth);
      practice.anotherExample();
      expect(practice.practise(), hundredthsBank[1]);
    });

    test('comparison focus maps to the deterministic examples', () {
      final practice = NumberSenseGuidedPractice();
      practice.selectSkill(NumberSenseGuidedSkill.compareFractions);
      for (final entry in {
        NumberSenseComparisonFocus.sameDenominator: compareBank[0],
        NumberSenseComparisonFocus.sameNumerator: compareBank[1],
        NumberSenseComparisonFocus.equivalentFractions: compareBank[2],
        NumberSenseComparisonFocus.compareToHalf: compareBank[3],
        NumberSenseComparisonFocus.mixed: compareBank[0],
      }.entries) {
        expect(practice.selectComparisonFocus(entry.key), entry.value);
      }
    });

    test('a focused comparison stays on its example; mixed cycles', () {
      final practice = NumberSenseGuidedPractice();
      practice.selectSkill(NumberSenseGuidedSkill.compareFractions);
      practice.selectComparisonFocus(NumberSenseComparisonFocus.sameNumerator);
      for (var i = 0; i < 3; i++) {
        expect(practice.anotherExample(), compareBank[1]);
        expect(practice.practise(), compareBank[1]);
        expect(practice.skill, NumberSenseGuidedSkill.compareFractions);
      }
      practice.selectComparisonFocus(NumberSenseComparisonFocus.mixed);
      expect([
        for (var i = 0; i < 6; i++) practice.anotherExample()
      ], [
        ...compareBank.sublist(1),
        compareBank.first,
        compareBank[1],
      ]);
    });
  });
  group('Guided practice navigation', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await InteractiveLabsProgressService.instance.init();
    });

    Future<void> pumpDefault(
      WidgetTester tester, {
      Size size = const Size(390, 844),
      double textScale = 1,
      ThemeData? theme,
    }) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          theme: theme ?? AppTheme.light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(textScale),
            ),
            child: child!,
          ),
          home: const NumberSenseLabScreen(),
        ),
      );
      await tester.pumpAndSettle();
    }

    // Most tests start one skill after the default Place a fraction entry.
    Future<void> pumpScreen(WidgetTester tester) async {
      await pumpDefault(tester);
      final next = find.byKey(const ValueKey('numberSense.nextSkill'));
      await tester.ensureVisible(next);
      await tester.tap(next);
      await tester.pumpAndSettle();
    }

    Future<void> tap(WidgetTester tester, String key) async {
      final finder = find.byKey(ValueKey(key));
      await tester.ensureVisible(finder);
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }

    Finder progress(String text) => find.text(text);

    testWidgets('progress label, next skill order and wrap-around',
        (tester) async {
      await pumpDefault(tester);
      expect(progress('Skill 1 of 4: Place a fraction'), findsOneWidget);
      expect(find.text('Target: 3/8'), findsOneWidget);

      await tap(tester, 'numberSense.nextSkill');
      expect(progress('Skill 2 of 4: Make an equivalent fraction'),
          findsOneWidget);

      await tap(tester, 'numberSense.nextSkill');
      expect(progress('Skill 3 of 4: Compare fractions'), findsOneWidget);
      expect(find.text('2/8  ?  5/8'), findsOneWidget);

      await tap(tester, 'numberSense.nextSkill');
      expect(progress('Skill 4 of 4: Find one hundredth'), findsOneWidget);

      await tap(tester, 'numberSense.nextSkill');
      expect(progress('Skill 1 of 4: Place a fraction'), findsOneWidget);
      expect(find.text('Target: 3/8'), findsOneWidget);
    });

    testWidgets('choosing a skill loads it and closes the sheet',
        (tester) async {
      await pumpScreen(tester);
      await tap(tester, 'numberSense.chooseSkill');
      expect(
          find.byKey(const ValueKey('numberSense.skillSheet')), findsOneWidget);
      for (final key in [
        'numberSense.skill.placeFraction',
        'numberSense.skill.makeEquivalent',
        'numberSense.skill.compareFractions',
        'numberSense.skill.findOneHundredth',
      ]) {
        expect(find.byKey(ValueKey(key)), findsOneWidget);
        expect(tester.getSize(find.byKey(ValueKey(key))).height,
            greaterThanOrEqualTo(48));
      }

      await tap(tester, 'numberSense.skill.findOneHundredth');
      expect(
          find.byKey(const ValueKey('numberSense.skillSheet')), findsNothing);
      expect(progress('Skill 4 of 4: Find one hundredth'), findsOneWidget);
    });

    testWidgets('comparison sub-skills are an optional second step',
        (tester) async {
      await pumpScreen(tester);
      await tap(tester, 'numberSense.chooseSkill');
      await tap(tester, 'numberSense.skill.compareFractions');

      expect(progress('Skill 3 of 4: Compare fractions'), findsOneWidget);
      expect(find.text('Choose a comparison type'), findsOneWidget);
      for (final label in [
        'Same denominator',
        'Same numerator',
        'Equivalent fractions',
        'Compare to one half',
        'Mixed practice',
      ]) {
        expect(find.text(label), findsOneWidget);
      }

      await tap(tester, 'numberSense.focus.compareToHalf');
      expect(
          find.byKey(const ValueKey('numberSense.skillSheet')), findsNothing);
      expect(find.text('5/8  ?  1/2'), findsOneWidget);

      await tap(tester, 'numberSense.practiseThis');
      expect(find.text('5/8  ?  1/2'), findsOneWidget);

      await tap(tester, 'numberSense.chooseSkill');
      await tap(tester, 'numberSense.skill.compareFractions');
      await tap(tester, 'numberSense.focus.sameNumerator');
      expect(find.text('3/4  ?  3/8'), findsOneWidget);
    });

    testWidgets(
        'another example cycles mixed comparisons; practise this restarts',
        (tester) async {
      await pumpScreen(tester);
      await tap(tester, 'numberSense.nextSkill');
      expect(find.text('2/8  ?  5/8'), findsOneWidget);
      await tap(tester, 'numberSense.practiseThis');
      expect(find.text('2/8  ?  5/8'), findsOneWidget);
      for (final question in [
        '3/4  ?  3/8',
        '3/6  ?  1/2',
        '5/8  ?  1/2',
        '2/3  ?  3/4',
        '2/8  ?  5/8',
      ]) {
        await tap(tester, 'numberSense.anotherExample');
        expect(find.text(question), findsOneWidget);
      }
    });

    testWidgets('changing path clears feedback and completion', (tester) async {
      await pumpScreen(tester);
      await tap(tester, 'numberSense.nextSkill');
      await tap(tester, 'numberSense.answer.lessThan');
      expect(find.text('Correct: 2/8 < 5/8.'), findsOneWidget);
      expect(find.text('You found it.'), findsOneWidget);

      await tap(tester, 'numberSense.practiseThis');
      expect(find.text('You found it.'), findsNothing);
      expect(find.byKey(const ValueKey('numberSense.comparisonFeedback')),
          findsNothing);

      await tap(tester, 'numberSense.answer.equal');
      expect(find.textContaining('Not quite.'), findsOneWidget);

      await tap(tester, 'numberSense.nextSkill');
      expect(find.textContaining('Not quite.'), findsNothing);
      expect(find.text('You found it.'), findsNothing);

      await tap(tester, 'numberSense.chooseSkill');
      await tap(tester, 'numberSense.skill.placeFraction');
      expect(find.text('You found it.'), findsNothing);
      expect(find.text('Target: 3/8'), findsOneWidget);
    });

    testWidgets('practice navigation is Guided-only', (tester) async {
      await pumpScreen(tester);
      await tap(tester, 'numberSense.modeFreeExplore');
      expect(find.byKey(const ValueKey('numberSense.practicePanel')),
          findsNothing);
      expect(find.byKey(const ValueKey('numberSense.skillProgress')),
          findsNothing);
      expect(find.text('Practise this'), findsNothing);
      expect(find.text('Next skill'), findsNothing);
      expect(find.text('Choose a skill'), findsNothing);
      expect(find.text('Another example'), findsNothing);

      await tap(tester, 'numberSense.modeGuided');
      expect(find.byKey(const ValueKey('numberSense.practicePanel')),
          findsOneWidget);
    });

    testWidgets('controls are 48 dp and labelled for screen readers',
        (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpScreen(tester);
      for (final key in [
        'numberSense.practiseThis',
        'numberSense.anotherExample',
        'numberSense.nextSkill',
        'numberSense.chooseSkill',
      ]) {
        final size = tester.getSize(find.byKey(ValueKey(key)));
        expect(size.height, greaterThanOrEqualTo(48));
        expect(size.width, greaterThanOrEqualTo(48));
      }
      expect(find.bySemanticsLabel('Practise this'), findsOneWidget);
      expect(find.bySemanticsLabel('Another example'), findsOneWidget);
      expect(
        find.bySemanticsLabel('Skill 2 of 4: Make an equivalent fraction'),
        findsOneWidget,
      );
      semantics.dispose();
    });

    testWidgets('another example walks each bank, wraps and keeps the skill',
        (tester) async {
      await pumpDefault(tester);
      for (final step in [
        ['Target: 1/2', 'Skill 1 of 4: Place a fraction'],
        ['Target: 2/3', 'Skill 1 of 4: Place a fraction'],
        ['Target: 3/8', 'Skill 1 of 4: Place a fraction'],
      ]) {
        await tap(tester, 'numberSense.anotherExample');
        expect(find.text(step[0]), findsOneWidget);
        expect(find.text(step[1]), findsOneWidget);
      }

      await tap(tester, 'numberSense.chooseSkill');
      await tap(tester, 'numberSense.skill.findOneHundredth');
      expect(find.text('Target: 1/100'), findsOneWidget);
      for (final target in ['3/100', '6/100', '1/100']) {
        await tap(tester, 'numberSense.anotherExample');
        expect(find.text('Target: $target'), findsOneWidget);
        expect(find.text('Skill 4 of 4: Find one hundredth'), findsOneWidget);
      }
    });

    testWidgets('hundredths bank targets are exact and complete on selection',
        (tester) async {
      await pumpDefault(tester);
      await tap(tester, 'numberSense.chooseSkill');
      await tap(tester, 'numberSense.skill.findOneHundredth');
      await tap(tester, 'numberSense.anotherExample');
      expect(find.text('3/100 = 0.03'), findsOneWidget);
      expect(find.text('Find 3 hundredths'), findsOneWidget);
      await tap(tester, 'hundredthsPrecisionLine.tick.5');
      expect(find.textContaining('You selected 0.05'), findsOneWidget);
      expect(find.textContaining('0.03'), findsWidgets);
      await tap(tester, 'hundredthsPrecisionLine.tick.3');
      expect(find.text('You found it.'), findsOneWidget);
    });

    testWidgets('equivalent bank shows each partition target', (tester) async {
      await pumpDefault(tester);
      await tap(tester, 'numberSense.chooseSkill');
      await tap(tester, 'numberSense.skill.makeEquivalent');
      expect(find.text('Show one half using equal parts.'), findsOneWidget);
      for (final parts in [4, 6, 8]) {
        await tap(tester, 'numberSense.anotherExample');
        expect(find.text('Show one half using $parts equal parts.'),
            findsOneWidget);
        expect(find.text('Target: 1/2'), findsOneWidget);
      }
    });

    testWidgets('changing example clears stale feedback and success',
        (tester) async {
      await pumpDefault(tester);
      await tap(tester, 'numberSense.nextSkill');
      await tap(tester, 'numberSense.nextSkill');
      await tap(tester, 'numberSense.anotherExample');
      await tap(tester, 'numberSense.answer.lessThan');
      expect(find.textContaining('Not quite.'), findsOneWidget);
      await tap(tester, 'numberSense.practiseThis');
      expect(find.textContaining('Not quite.'), findsNothing);
      await tap(tester, 'numberSense.answer.greaterThan');
      expect(find.text('You found it.'), findsOneWidget);
      await tap(tester, 'numberSense.anotherExample');
      expect(find.text('You found it.'), findsNothing);
      expect(find.byKey(const ValueKey('numberSense.comparisonFeedback')),
          findsNothing);
    });
    for (final size in [const Size(390, 844), const Size(915, 412)]) {
      for (final scale in [1.0, 2.0]) {
        for (final theme in [AppTheme.light(), AppTheme.dark()]) {
          testWidgets(
              'fits at ${size.width}x${size.height}, ${scale}x text, '
              '${theme.brightness.name}', (tester) async {
            await pumpDefault(
              tester,
              size: size,
              textScale: scale,
              theme: theme,
            );
            expect(tester.takeException(), isNull);
            expect(find.byKey(const ValueKey('numberSense.anotherExample')),
                findsOneWidget);
            expect(tester.takeException(), isNull);
            await tap(tester, 'numberSense.nextSkill');
            await tap(tester, 'numberSense.chooseSkill');
            expect(tester.takeException(), isNull);
            await tap(tester, 'numberSense.skill.compareFractions');
            expect(tester.takeException(), isNull);
            await tap(tester, 'numberSense.skillSheetClose');
            expect(find.byKey(const ValueKey('numberSense.skillSheet')),
                findsNothing);
            expect(tester.takeException(), isNull);
          });
        }
      }
    }
  });
}
