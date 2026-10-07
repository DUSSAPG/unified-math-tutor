import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/exact_fraction.dart';
import 'package:unified_math_tutor/models/number_sense_example.dart';
import 'package:unified_math_tutor/models/number_sense_state.dart';

void main() {
  group('guided example targets', () {
    test('equivalence: the target is exactly 1/2, shown as 2/4 and 3/6', () {
      final example = NumberSenseExample.equivalenceHalf;
      expect(example.primary, ExactFraction(1, 2));
      expect(example.revealDenominators, [4, 6]);
      expect(ExactFraction(2, 4), example.primary);
      expect(ExactFraction(3, 6), example.primary);
      expect(example.secondary, isNull);
    });

    test('placement: the target is exactly 3/8, between 1/4 and 1/2', () {
      final example = NumberSenseExample.placeThreeEighths;
      expect(example.primary, ExactFraction(3, 8));
      expect(example.targetDenominator, 8);
      expect(example.lowerAnchor, ExactFraction(1, 4));
      expect(example.upperAnchor, ExactFraction(1, 2));
      expect(example.lowerAnchor!.compareTo(example.primary), lessThan(0));
      expect(example.primary.compareTo(example.upperAnchor!), lessThan(0));
    });

    test('comparison: 2/3 is less than 3/4, and the expected result says so',
        () {
      final example = NumberSenseExample.compareTwoThirdsAndThreeQuarters;
      expect(example.primary, ExactFraction(2, 3));
      expect(example.secondary, ExactFraction(3, 4));
      expect(example.expectedComparison, NumberSenseComparison.lessThan);
      expect(
        compareExactFractions(example.primary, example.secondary!),
        example.expectedComparison,
      );
    });

    test('all seven guided examples have stable, distinct ids in order', () {
      expect(NumberSenseExample.all.map((e) => e.id).toList(), [
        NumberSenseExampleId.equivalenceHalf,
        NumberSenseExampleId.placeThreeEighths,
        NumberSenseExampleId.compareTwoEighthsAndFiveEighths,
        NumberSenseExampleId.compareThreeQuartersAndThreeEighths,
        NumberSenseExampleId.compareThreeSixthsAndOneHalf,
        NumberSenseExampleId.compareFiveEighthsAndOneHalf,
        NumberSenseExampleId.compareTwoThirdsAndThreeQuarters,
      ]);
    });

    test('five comparison examples have the requested exact values and order',
        () {
      final comparisons = NumberSenseExample.all
          .where((example) => example.expectedComparison != null)
          .toList();
      expect(comparisons, hasLength(5));
      expect(
        comparisons
            .map(
              (example) => [
                example.shownPrimaryNumerator,
                example.shownPrimaryDenominator,
                example.shownSecondaryNumerator,
                example.shownSecondaryDenominator,
                example.expectedComparison,
              ],
            )
            .toList(),
        [
          [2, 8, 5, 8, NumberSenseComparison.lessThan],
          [3, 4, 3, 8, NumberSenseComparison.greaterThan],
          [3, 6, 1, 2, NumberSenseComparison.equal],
          [5, 8, 1, 2, NumberSenseComparison.greaterThan],
          [2, 3, 3, 4, NumberSenseComparison.lessThan],
        ],
      );
      for (final example in comparisons) {
        expect(
          compareExactFractions(example.primary, example.secondary!),
          example.expectedComparison,
        );
      }
    });

    test('each starting partition is valid and its shading is in range', () {
      for (final example in NumberSenseExample.all) {
        expect(numberSenseV1Denominators.contains(example.startDenominator),
            isTrue,
            reason: '${example.id}');
        expect(example.startShadedParts,
            inInclusiveRange(0, example.startDenominator),
            reason: '${example.id}');
      }
    });

    test('the comparison example starts showing 2 of 3, which is 2/3', () {
      final example = NumberSenseExample.compareTwoThirdsAndThreeQuarters;
      final start = NumberSenseState.guided(example.id);
      expect(start.value, example.primary);
    });
  });

  group('partition retention', () {
    test('2 of 4 keeps denominator 4 while its value equals 1/2', () {
      final halved = NumberSenseState.guided().setShadedParts(1); // 1 of 2
      final fourths = halved.selectDenominator(4);
      expect(fourths.denominator, 4);
      expect(fourths.shadedParts, 2);
      expect(fourths.value, ExactFraction(1, 2));
      expect(fourths.value.denominator, 2, reason: 'canonical form is 1/2');
    });

    test('the same value keeps its partition after a further change', () {
      final state = NumberSenseState.freeExplore(denominator: 6)
          .setShadedParts(3); // 3 of 6, value 1/2
      expect(state.denominator, 6);
      expect(state.value, ExactFraction(1, 2));
    });
  });

  group('shading, increment, decrement and boundary flags', () {
    test('a fresh equivalence state is at 0 of 2 with boundary flags set', () {
      final state = NumberSenseState.guided();
      expect(state.shadedParts, 0);
      expect(state.denominator, 2);
      expect(state.canIncrement, isTrue);
      expect(state.canDecrement, isFalse);
    });

    test('incrementing moves up one part until the maximum', () {
      var state = NumberSenseState.guided();
      state = state.increment();
      expect(state.shadedParts, 1);
      expect(state.canIncrement, isTrue);
      state = state.increment();
      expect(state.shadedParts, 2);
      expect(state.canIncrement, isFalse);
      expect(state.canDecrement, isTrue);
    });

    test('incrementing at the maximum throws rather than silently ignoring',
        () {
      final full = NumberSenseState.guided().setShadedParts(2);
      expect(full.canIncrement, isFalse);
      expect(() => full.increment(), throwsStateError);
    });

    test('decrementing at zero throws rather than silently ignoring', () {
      final empty = NumberSenseState.guided();
      expect(empty.canDecrement, isFalse);
      expect(() => empty.decrement(), throwsStateError);
    });

    test('decrementing moves down one part', () {
      final state = NumberSenseState.guided().setShadedParts(2).decrement();
      expect(state.shadedParts, 1);
    });

    test('setShadedParts accepts 0 through the denominator inclusive', () {
      final state = NumberSenseState.freeExplore(denominator: 8);
      expect(state.setShadedParts(0).shadedParts, 0);
      expect(state.setShadedParts(8).shadedParts, 8);
    });

    test('setShadedParts outside 0..denominator throws ArgumentError', () {
      final state = NumberSenseState.freeExplore(denominator: 4);
      expect(() => state.setShadedParts(-1), throwsArgumentError);
      expect(() => state.setShadedParts(5), throwsArgumentError);
    });
  });

  group('denominator selection', () {
    test('only V1 denominators can be selected', () {
      final state = NumberSenseState.guided();
      for (final bad in [0, 1, 5, 7, 9, 10, -2]) {
        expect(() => state.selectDenominator(bad), throwsArgumentError,
            reason: 'denominator $bad');
      }
      for (final good in [2, 3, 4, 6, 8]) {
        expect(state.selectDenominator(good).denominator, good);
      }
    });

    test('2/3 moved to fourths becomes 3/4 (the midpoint snaps upward)', () {
      final twoThirds = NumberSenseState.guided(
              NumberSenseExampleId.compareTwoThirdsAndThreeQuarters)
          .selectDenominator(4);
      expect(twoThirds.value, ExactFraction(3, 4));
      expect(twoThirds.shadedParts, 3);
      expect(twoThirds.denominator, 4);
    });

    test('2/3 moved to halves becomes 1/2', () {
      final state = NumberSenseState.guided(
              NumberSenseExampleId.compareTwoThirdsAndThreeQuarters)
          .selectDenominator(2);
      expect(state.value, ExactFraction(1, 2));
      expect(state.shadedParts, 1);
    });

    test('1/2 moved to eighths becomes 4 of 8', () {
      final state =
          NumberSenseState.guided().setShadedParts(1).selectDenominator(8);
      expect(state.shadedParts, 4);
      expect(state.value, ExactFraction(1, 2));
    });

    test('zero stays zero on every denominator', () {
      for (final d in [2, 3, 4, 6, 8]) {
        final state = NumberSenseState.guided().selectDenominator(d);
        expect(state.shadedParts, 0, reason: 'denominator $d');
        expect(state.value, ExactFraction(0, 1));
      }
    });

    test('a full bar stays full on every denominator', () {
      final full =
          NumberSenseState.freeExplore(denominator: 3).setShadedParts(3);
      for (final d in [2, 4, 6, 8]) {
        expect(full.selectDenominator(d).value, ExactFraction(1, 1),
            reason: 'denominator $d');
      }
    });
  });

  group('mode switching', () {
    test('switching to Free Explore keeps the partition and shading', () {
      final guided =
          NumberSenseState.guided(NumberSenseExampleId.placeThreeEighths)
              .setShadedParts(3);
      final free = guided.switchMode(NumberSenseMode.freeExplore);
      expect(free.mode, NumberSenseMode.freeExplore);
      expect(free.denominator, 8);
      expect(free.shadedParts, 3);
      expect(free.activeExample, isNull);
    });

    test('switching to Guided starts the active example at its start', () {
      final free =
          NumberSenseState.freeExplore(denominator: 6).setShadedParts(4);
      final guided = free.switchMode(NumberSenseMode.guided);
      expect(guided.mode, NumberSenseMode.guided);
      expect(guided.activeExample, NumberSenseExampleId.equivalenceHalf);
      expect(guided.denominator, 2);
      expect(guided.shadedParts, 0);
    });

    test('switching to the mode already active changes nothing', () {
      final state = NumberSenseState.guided();
      expect(
          identical(state.switchMode(NumberSenseMode.guided), state), isTrue);
    });
  });

  group('resets', () {
    test('Guided reset returns the example to its starting state', () {
      final start =
          NumberSenseState.guided(NumberSenseExampleId.placeThreeEighths);
      final moved = start.increment().increment().increment();
      expect(moved.shadedParts, 3);
      final reset = moved.resetGuided();
      expect(reset.shadedParts, start.shadedParts);
      expect(reset.denominator, start.denominator);
      expect(reset.activeExample, NumberSenseExampleId.placeThreeEighths);
    });

    test('Guided reset is invalid in Free Explore', () {
      final free = NumberSenseState.freeExplore();
      expect(() => free.resetGuided(), throwsStateError);
    });

    test('Free Explore reset clears to zero and keeps the partition', () {
      final free =
          NumberSenseState.freeExplore(denominator: 6).setShadedParts(4);
      final reset = free.resetFreeExplore();
      expect(reset.shadedParts, 0);
      expect(reset.denominator, 6);
      expect(reset.mode, NumberSenseMode.freeExplore);
    });

    test('Free Explore reset is invalid in Guided mode', () {
      expect(
          () => NumberSenseState.guided().resetFreeExplore(), throwsStateError);
    });
  });

  group('example cycling', () {
    test('cycling visits every example in order and then wraps', () {
      var state = NumberSenseState.guided();
      expect(state.activeExample, NumberSenseExampleId.equivalenceHalf);
      for (final example in NumberSenseExample.all.skip(1)) {
        state = state.cycleExample();
        expect(state.activeExample, example.id);
      }
      state = state.cycleExample();
      expect(state.activeExample, NumberSenseExampleId.equivalenceHalf);
    });

    test('each cycled example starts at its own starting state', () {
      final place = NumberSenseState.guided().cycleExample();
      expect(place.denominator, 8);
      expect(place.shadedParts, 0);
      final compare = place.cycleExample();
      expect(compare.denominator, 8);
      expect(compare.shadedParts, 2);
    });

    test('cycling from Free Explore enters Guided at the first example', () {
      final state = NumberSenseState.freeExplore().cycleExample();
      expect(state.mode, NumberSenseMode.guided);
      expect(state.activeExample, NumberSenseExampleId.equivalenceHalf);
    });
  });

  group('completion by exact state, not by route', () {
    test('equivalence completes at 1/2 via 1 of 2', () {
      expect(
          NumberSenseState.guided().setShadedParts(1).isGuidedComplete, isTrue);
    });

    test('equivalence completes at 1/2 via 2 of 4 after reaching fourths', () {
      final state = NumberSenseState.guided()
          .selectDenominator(4)
          .increment()
          .increment();
      expect(state.value, ExactFraction(1, 2));
      expect(state.isGuidedComplete, isTrue);
    });

    test('equivalence completes at 1/2 via 3 of 6', () {
      final state =
          NumberSenseState.guided().selectDenominator(6).setShadedParts(3);
      expect(state.isGuidedComplete, isTrue);
    });

    test('equivalence completes at 1/2 via 4 of 8', () {
      final state =
          NumberSenseState.guided().selectDenominator(8).setShadedParts(4);
      expect(state.isGuidedComplete, isTrue);
    });

    test('equivalence is not complete at 1/4 or 0', () {
      expect(NumberSenseState.guided().isGuidedComplete, isFalse);
      expect(
          NumberSenseState.guided()
              .selectDenominator(4)
              .increment()
              .isGuidedComplete,
          isFalse);
    });

    test('placement completes at 3/8 by tapping three parts', () {
      final state =
          NumberSenseState.guided(NumberSenseExampleId.placeThreeEighths)
              .increment()
              .increment()
              .increment();
      expect(state.isGuidedComplete, isTrue);
    });

    test('placement completes at 3/8 by setting the count directly', () {
      final state =
          NumberSenseState.guided(NumberSenseExampleId.placeThreeEighths)
              .setShadedParts(3);
      expect(state.isGuidedComplete, isTrue);
    });

    test('placement is not complete at the nearby 1/2 or at 3/8 of 4', () {
      final half =
          NumberSenseState.guided(NumberSenseExampleId.placeThreeEighths)
              .setShadedParts(4);
      expect(half.isGuidedComplete, isFalse);
      final onQuarters =
          NumberSenseState.guided(NumberSenseExampleId.placeThreeEighths)
              .setShadedParts(3)
              .selectDenominator(4);
      expect(onQuarters.value, ExactFraction(1, 2));
      expect(onQuarters.isGuidedComplete, isFalse);
    });

    test('comparison completes only with the exact correct answer', () {
      final base = NumberSenseState.guided(
          NumberSenseExampleId.compareTwoThirdsAndThreeQuarters);
      expect(
          base
              .answerComparison(NumberSenseComparison.lessThan)
              .isGuidedComplete,
          isTrue);
      expect(
          base
              .answerComparison(NumberSenseComparison.greaterThan)
              .isGuidedComplete,
          isFalse);
      expect(
          base.answerComparison(NumberSenseComparison.equal).isGuidedComplete,
          isFalse);
      expect(base.isGuidedComplete, isFalse);
    });

    test('a comparison answer is only accepted for a comparison example', () {
      expect(
          () => NumberSenseState.guided()
              .answerComparison(NumberSenseComparison.lessThan),
          throwsStateError);
    });

    test('Free Explore is never guided-complete, even on the target value', () {
      final free =
          NumberSenseState.freeExplore(denominator: 2).setShadedParts(1);
      expect(free.value, ExactFraction(1, 2));
      expect(free.isGuidedComplete, isFalse);
    });
  });

  group('immutability', () {
    test('transitions return new states and leave the original unchanged', () {
      final original = NumberSenseState.guided();
      final before = original.toString();
      final shaded = original.increment();
      final denominated = original.selectDenominator(4);
      final switched = original.switchMode(NumberSenseMode.freeExplore);
      expect(identical(shaded, original), isFalse);
      expect(identical(denominated, original), isFalse);
      expect(identical(switched, original), isFalse);
      expect(original.toString(), before);
      expect(original.shadedParts, 0);
      expect(original.denominator, 2);
    });

    test('a guided example is not changed by the state built from it', () {
      final example = NumberSenseExample.placeThreeEighths;
      NumberSenseState.guided(NumberSenseExampleId.placeThreeEighths)
          .setShadedParts(8);
      expect(example.primary, ExactFraction(3, 8));
      expect(example.startShadedParts, 0);
    });
  });

  group('no floating-point state', () {
    test('partition and value fields are integers', () {
      final state =
          NumberSenseState.guided().selectDenominator(4).setShadedParts(3);
      expect(state.denominator, isA<int>());
      expect(state.shadedParts, isA<int>());
      expect(state.value.numerator, isA<int>());
      expect(state.value.denominator, isA<int>());
    });

    test('the state description contains no decimal point', () {
      for (final d in [2, 3, 4, 6, 8]) {
        for (var n = 0; n <= d; n++) {
          final state =
              NumberSenseState.freeExplore(denominator: d).setShadedParts(n);
          expect(state.toString().contains('.'), isFalse, reason: '$n of $d');
        }
      }
    });
  });
}
