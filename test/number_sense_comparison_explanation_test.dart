import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/exact_fraction.dart';
import 'package:unified_math_tutor/models/number_sense_comparison_explanation.dart';

void main() {
  group('comparison explanation strategy priority', () {
    test('equivalent values use the same-point explanation', () {
      expect(
        _strategyFor(3, 6, 1, 2),
        NumberSenseComparisonStrategy.equivalentFractions,
      );
    });

    test('same denominator uses the equal-parts strategy', () {
      expect(
        _strategyFor(2, 8, 5, 8),
        NumberSenseComparisonStrategy.sameDenominator,
      );
    });

    test('same numerator uses the piece-size strategy', () {
      expect(
        _strategyFor(3, 4, 3, 8),
        NumberSenseComparisonStrategy.sameNumerator,
      );
    });

    test('one tick from a half uses the benchmark strategy', () {
      expect(
        _strategyFor(5, 8, 1, 2),
        NumberSenseComparisonStrategy.benchmarkHalf,
      );
      expect(
        _strategyFor(1, 2, 3, 8),
        NumberSenseComparisonStrategy.benchmarkHalf,
      );
    });

    test('unlike fractions fall back to exact cross-multiplication', () {
      final left = ExactFraction(2, 3);
      final right = ExactFraction(3, 4);
      expect(
        NumberSenseComparisonExplanation.select(
          left,
          right,
          leftNumerator: 2,
          leftDenominator: 3,
          rightNumerator: 3,
          rightDenominator: 4,
        ).strategy,
        NumberSenseComparisonStrategy.crossMultiplication,
      );
      expect(left.numerator * right.denominator, 8);
      expect(right.numerator * left.denominator, 9);
      expect(left.compareTo(right), lessThan(0));
    });
  });
}

NumberSenseComparisonStrategy _strategyFor(
  int leftNumerator,
  int leftDenominator,
  int rightNumerator,
  int rightDenominator,
) =>
    NumberSenseComparisonExplanation.select(
      ExactFraction(leftNumerator, leftDenominator),
      ExactFraction(rightNumerator, rightDenominator),
      leftNumerator: leftNumerator,
      leftDenominator: leftDenominator,
      rightNumerator: rightNumerator,
      rightDenominator: rightDenominator,
    ).strategy;
