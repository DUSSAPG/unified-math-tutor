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
    test('next skill follows the teaching order and wraps', () {
      final practice = NumberSenseGuidedPractice(
        NumberSenseExampleId.placeThreeEighths,
      );
      expect(practice.skillNumber, 1);
      expect(practice.nextSkill(), NumberSenseExampleId.equivalenceHalf);
      expect(
        practice.nextSkill(),
        NumberSenseExampleId.compareTwoEighthsAndFiveEighths,
      );
      expect(practice.nextSkill(), NumberSenseExampleId.findOneHundredth);
      expect(practice.skillNumber, 4);
      expect(practice.nextSkill(), NumberSenseExampleId.placeThreeEighths);
      expect(practice.skill, NumberSenseGuidedSkill.placeFraction);
    });

    test('defaults to Place a fraction as skill 1 of 4', () {
      final practice = NumberSenseGuidedPractice();
      expect(practice.skill, NumberSenseGuidedSkill.placeFraction);
      expect(practice.skillNumber, 1);
      expect(
        practice.practise(NumberSenseExampleId.placeThreeEighths),
        NumberSenseExampleId.placeThreeEighths,
      );
    });

    test('a chosen comparison focus survives repeated practice', () {
      final practice = NumberSenseGuidedPractice();
      practice.selectComparisonFocus(NumberSenseComparisonFocus.sameNumerator);
      for (var i = 0; i < 3; i++) {
        expect(
          practice.practise(
            NumberSenseExampleId.compareThreeQuartersAndThreeEighths,
          ),
          NumberSenseExampleId.compareThreeQuartersAndThreeEighths,
        );
        expect(
          practice.comparisonFocus,
          NumberSenseComparisonFocus.sameNumerator,
        );
      }
    });

    test('direct choice loads the first example of each skill', () {
      final practice = NumberSenseGuidedPractice();
      expect(
        practice.selectSkill(NumberSenseGuidedSkill.findOneHundredth),
        NumberSenseExampleId.findOneHundredth,
      );
      expect(
        practice.selectSkill(NumberSenseGuidedSkill.placeFraction),
        NumberSenseExampleId.placeThreeEighths,
      );
    });

    test('comparison focus maps to the deterministic examples', () {
      final practice = NumberSenseGuidedPractice();
      const expected = {
        NumberSenseComparisonFocus.sameDenominator:
            NumberSenseExampleId.compareTwoEighthsAndFiveEighths,
        NumberSenseComparisonFocus.sameNumerator:
            NumberSenseExampleId.compareThreeQuartersAndThreeEighths,
        NumberSenseComparisonFocus.equivalentFractions:
            NumberSenseExampleId.compareThreeSixthsAndOneHalf,
        NumberSenseComparisonFocus.compareToHalf:
            NumberSenseExampleId.compareFiveEighthsAndOneHalf,
        NumberSenseComparisonFocus.mixed:
            NumberSenseExampleId.compareTwoEighthsAndFiveEighths,
      };
      for (final entry in expected.entries) {
        expect(practice.selectComparisonFocus(entry.key), entry.value);
        expect(practice.skill, NumberSenseGuidedSkill.compareFractions);
      }
    });

    test('practise cycles mixed comparisons and restarts a focused one', () {
      final practice = NumberSenseGuidedPractice();
      var current = practice.selectSkill(
        NumberSenseGuidedSkill.compareFractions,
      );
      final seen = <NumberSenseExampleId>[current];
      for (var i = 0; i < 5; i++) {
        current = practice.practise(current);
        seen.add(current);
      }
      expect(seen, [
        NumberSenseExampleId.compareTwoEighthsAndFiveEighths,
        NumberSenseExampleId.compareThreeQuartersAndThreeEighths,
        NumberSenseExampleId.compareThreeSixthsAndOneHalf,
        NumberSenseExampleId.compareFiveEighthsAndOneHalf,
        NumberSenseExampleId.compareTwoThirdsAndThreeQuarters,
        NumberSenseExampleId.compareTwoEighthsAndFiveEighths,
      ]);

      current = practice.selectComparisonFocus(
        NumberSenseComparisonFocus.compareToHalf,
      );
      expect(
        practice.practise(current),
        NumberSenseExampleId.compareFiveEighthsAndOneHalf,
      );
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

    testWidgets('practise this cycles mixed comparisons deterministically',
        (tester) async {
      await pumpScreen(tester);
      await tap(tester, 'numberSense.nextSkill');
      for (final question in [
        '3/4  ?  3/8',
        '3/6  ?  1/2',
        '5/8  ?  1/2',
        '2/3  ?  3/4',
        '2/8  ?  5/8',
      ]) {
        await tap(tester, 'numberSense.practiseThis');
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
        'numberSense.nextSkill',
        'numberSense.chooseSkill',
      ]) {
        final size = tester.getSize(find.byKey(ValueKey(key)));
        expect(size.height, greaterThanOrEqualTo(48));
        expect(size.width, greaterThanOrEqualTo(48));
      }
      expect(find.bySemanticsLabel('Practise this'), findsOneWidget);
      expect(
        find.bySemanticsLabel('Skill 2 of 4: Make an equivalent fraction'),
        findsOneWidget,
      );
      semantics.dispose();
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
