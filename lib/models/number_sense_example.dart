import 'exact_fraction.dart';

/// Stable identifiers for the three Number Sense guided examples. These are
/// data keys, not learner-facing text: any copy is looked up elsewhere by
/// these identifiers.
enum NumberSenseExampleId {
  equivalenceHalf,
  placeThreeEighths,
  compareTwoThirdsAndThreeQuarters,
}

/// The outcome of comparing two exact fractions.
enum NumberSenseComparison { lessThan, equal, greaterThan }

/// Compares [a] with [b] exactly, using [ExactFraction]'s integer ordering.
NumberSenseComparison compareExactFractions(ExactFraction a, ExactFraction b) {
  final order = a.compareTo(b);
  if (order < 0) return NumberSenseComparison.lessThan;
  if (order > 0) return NumberSenseComparison.greaterThan;
  return NumberSenseComparison.equal;
}

/// A guided example: exact mathematical data only, with no copy.
///
/// - [startDenominator] and [startShadedParts] give the starting partition.
///   They can be rendered without canonicalising, so 2 of 4 stays "two
///   fourths" even though its value is 1/2.
/// - [primary] is the fraction the example is about.
/// - [secondary] is the second fraction in a comparison.
/// - [targetDenominator] is the partition to place on, where one applies.
/// - [lowerAnchor] and [upperAnchor] are the two fixed points a placement
///   lies between.
/// - [revealDenominators] lists the partitions shown as equivalents of
///   [primary].
/// - [expectedComparison] is the exact result of `primary` compared with
///   `secondary`, where a comparison applies.
class NumberSenseExample {
  const NumberSenseExample({
    required this.id,
    required this.startDenominator,
    required this.startShadedParts,
    required this.primary,
    this.secondary,
    this.targetDenominator,
    this.lowerAnchor,
    this.upperAnchor,
    this.revealDenominators = const [],
    this.expectedComparison,
  });

  final NumberSenseExampleId id;
  final int startDenominator;
  final int startShadedParts;
  final ExactFraction primary;
  final ExactFraction? secondary;
  final int? targetDenominator;
  final ExactFraction? lowerAnchor;
  final ExactFraction? upperAnchor;
  final List<int> revealDenominators;
  final NumberSenseComparison? expectedComparison;

  /// Equivalence: make 1/2, and reveal it as 2/4 and 3/6.
  static final NumberSenseExample equivalenceHalf = NumberSenseExample(
    id: NumberSenseExampleId.equivalenceHalf,
    startDenominator: 2,
    startShadedParts: 0,
    primary: ExactFraction(1, 2),
    revealDenominators: const [4, 6],
  );

  /// Placement: place 3/8 on the eighths partition, between 1/4 and 1/2.
  static final NumberSenseExample placeThreeEighths = NumberSenseExample(
    id: NumberSenseExampleId.placeThreeEighths,
    startDenominator: 8,
    startShadedParts: 0,
    primary: ExactFraction(3, 8),
    targetDenominator: 8,
    lowerAnchor: ExactFraction(1, 4),
    upperAnchor: ExactFraction(1, 2),
  );

  /// Comparison: 2/3 is less than 3/4. Starts showing 2 of 3.
  static final NumberSenseExample compareTwoThirdsAndThreeQuarters =
      NumberSenseExample(
    id: NumberSenseExampleId.compareTwoThirdsAndThreeQuarters,
    startDenominator: 3,
    startShadedParts: 2,
    primary: ExactFraction(2, 3),
    secondary: ExactFraction(3, 4),
    expectedComparison: NumberSenseComparison.lessThan,
  );

  /// Every guided example, in the fixed cycling order.
  static final List<NumberSenseExample> all = [
    equivalenceHalf,
    placeThreeEighths,
    compareTwoThirdsAndThreeQuarters,
  ];

  /// The example with the given [id].
  static NumberSenseExample of(NumberSenseExampleId id) =>
      all.firstWhere((example) => example.id == id);
}
