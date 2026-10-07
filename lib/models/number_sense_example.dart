import 'exact_fraction.dart';

/// Stable identifiers for the Number Sense guided examples. These are
/// data keys, not learner-facing text: any copy is looked up elsewhere by
/// these identifiers.
enum NumberSenseExampleId {
  equivalenceHalf,
  placeThreeEighths,
  compareTwoEighthsAndFiveEighths,
  compareThreeQuartersAndThreeEighths,
  compareThreeSixthsAndOneHalf,
  compareFiveEighthsAndOneHalf,
  compareTwoThirdsAndThreeQuarters,
  findOneHundredth,
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
    this.primaryDisplayNumerator,
    this.primaryDisplayDenominator,
    this.secondaryDisplayNumerator,
    this.secondaryDisplayDenominator,
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
  final int? primaryDisplayNumerator;
  final int? primaryDisplayDenominator;
  final int? secondaryDisplayNumerator;
  final int? secondaryDisplayDenominator;
  final List<int> revealDenominators;
  final NumberSenseComparison? expectedComparison;

  int get shownPrimaryNumerator => primaryDisplayNumerator ?? primary.numerator;
  int get shownPrimaryDenominator =>
      primaryDisplayDenominator ?? primary.denominator;
  int get shownSecondaryNumerator =>
      secondaryDisplayNumerator ?? secondary!.numerator;
  int get shownSecondaryDenominator =>
      secondaryDisplayDenominator ?? secondary!.denominator;

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

  /// Comparison: 2/8 is less than 5/8.
  static final NumberSenseExample compareTwoEighthsAndFiveEighths =
      NumberSenseExample(
    id: NumberSenseExampleId.compareTwoEighthsAndFiveEighths,
    startDenominator: 8,
    startShadedParts: 2,
    primary: ExactFraction(2, 8),
    secondary: ExactFraction(5, 8),
    primaryDisplayNumerator: 2,
    primaryDisplayDenominator: 8,
    secondaryDisplayNumerator: 5,
    secondaryDisplayDenominator: 8,
    expectedComparison: NumberSenseComparison.lessThan,
  );

  /// Comparison: 3/4 is greater than 3/8.
  static final NumberSenseExample compareThreeQuartersAndThreeEighths =
      NumberSenseExample(
    id: NumberSenseExampleId.compareThreeQuartersAndThreeEighths,
    startDenominator: 4,
    startShadedParts: 3,
    primary: ExactFraction(3, 4),
    secondary: ExactFraction(3, 8),
    primaryDisplayNumerator: 3,
    primaryDisplayDenominator: 4,
    secondaryDisplayNumerator: 3,
    secondaryDisplayDenominator: 8,
    expectedComparison: NumberSenseComparison.greaterThan,
  );

  /// Comparison: 3/6 is equal to 1/2.
  static final NumberSenseExample compareThreeSixthsAndOneHalf =
      NumberSenseExample(
    id: NumberSenseExampleId.compareThreeSixthsAndOneHalf,
    startDenominator: 6,
    startShadedParts: 3,
    primary: ExactFraction(3, 6),
    secondary: ExactFraction(1, 2),
    primaryDisplayNumerator: 3,
    primaryDisplayDenominator: 6,
    secondaryDisplayNumerator: 1,
    secondaryDisplayDenominator: 2,
    expectedComparison: NumberSenseComparison.equal,
  );

  /// Comparison: 5/8 is greater than 1/2.
  static final NumberSenseExample compareFiveEighthsAndOneHalf =
      NumberSenseExample(
    id: NumberSenseExampleId.compareFiveEighthsAndOneHalf,
    startDenominator: 8,
    startShadedParts: 5,
    primary: ExactFraction(5, 8),
    secondary: ExactFraction(1, 2),
    primaryDisplayNumerator: 5,
    primaryDisplayDenominator: 8,
    secondaryDisplayNumerator: 1,
    secondaryDisplayDenominator: 2,
    expectedComparison: NumberSenseComparison.greaterThan,
  );

  /// Comparison: 2/3 is less than 3/4. Starts showing 2 of 3.
  static final NumberSenseExample compareTwoThirdsAndThreeQuarters =
      NumberSenseExample(
    id: NumberSenseExampleId.compareTwoThirdsAndThreeQuarters,
    startDenominator: 3,
    startShadedParts: 2,
    primary: ExactFraction(2, 3),
    secondary: ExactFraction(3, 4),
    primaryDisplayNumerator: 2,
    primaryDisplayDenominator: 3,
    secondaryDisplayNumerator: 3,
    secondaryDisplayDenominator: 4,
    expectedComparison: NumberSenseComparison.lessThan,
  );

  /// Precision placement: find one hundredth on the zoomed 0.00–0.10 line.
  static final NumberSenseExample findOneHundredth = NumberSenseExample(
    id: NumberSenseExampleId.findOneHundredth,
    startDenominator: 2,
    startShadedParts: 0,
    primary: ExactFraction(1, 100),
  );

  /// Every guided example, in the fixed cycling order.
  static final List<NumberSenseExample> all = [
    equivalenceHalf,
    placeThreeEighths,
    compareTwoEighthsAndFiveEighths,
    compareThreeQuartersAndThreeEighths,
    compareThreeSixthsAndOneHalf,
    compareFiveEighthsAndOneHalf,
    compareTwoThirdsAndThreeQuarters,
    findOneHundredth,
  ];

  /// The example with the given [id].
  static NumberSenseExample of(NumberSenseExampleId id) =>
      all.firstWhere((example) => example.id == id);
}
