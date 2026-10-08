import 'exact_fraction.dart';

/// The simplest exact strategy available for comparing two fractions.
enum NumberSenseComparisonStrategy {
  equivalentFractions,
  sameDenominator,
  sameNumerator,
  benchmarkHalf,
  crossMultiplication,
}

/// Selects a comparison explanation using exact integer fraction properties.
///
/// Strategy priority is intentional: equal values, shared denominator, shared
/// numerator, half benchmark, then exact cross-multiplication.
class NumberSenseComparisonExplanation {
  const NumberSenseComparisonExplanation._(this.strategy);

  final NumberSenseComparisonStrategy strategy;

  static NumberSenseComparisonExplanation select(
    ExactFraction left,
    ExactFraction right, {
    required int leftNumerator,
    required int leftDenominator,
    required int rightNumerator,
    required int rightDenominator,
  }) {
    if (ExactFraction(leftNumerator, leftDenominator) != left ||
        ExactFraction(rightNumerator, rightDenominator) != right) {
      throw ArgumentError(
        'Displayed fractions must match their exact values.',
      );
    }

    if (left.compareTo(right) == 0) {
      return const NumberSenseComparisonExplanation._(
        NumberSenseComparisonStrategy.equivalentFractions,
      );
    }
    if (leftDenominator == rightDenominator) {
      return const NumberSenseComparisonExplanation._(
        NumberSenseComparisonStrategy.sameDenominator,
      );
    }
    if (leftNumerator == rightNumerator) {
      return const NumberSenseComparisonExplanation._(
        NumberSenseComparisonStrategy.sameNumerator,
      );
    }
    if (_differsByOneTickFromHalf(left, rightNumerator, rightDenominator) ||
        _differsByOneTickFromHalf(right, leftNumerator, leftDenominator)) {
      return const NumberSenseComparisonExplanation._(
        NumberSenseComparisonStrategy.benchmarkHalf,
      );
    }
    return const NumberSenseComparisonExplanation._(
      NumberSenseComparisonStrategy.crossMultiplication,
    );
  }

  static bool _differsByOneTickFromHalf(
    ExactFraction half,
    int otherNumerator,
    int otherDenominator,
  ) =>
      half.numerator == 1 &&
      half.denominator == 2 &&
      otherDenominator.isEven &&
      (otherNumerator - otherDenominator ~/ 2).abs() == 1;
}
