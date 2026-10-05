import '../core/question_id_rule.dart';
import 'exact_fraction.dart';
import 'number_sense_example.dart';

/// A verified transfer item for Number Sense Lab: mathematical data only.
///
/// Items are local to Number Sense Lab. They are not Topic Drill content, not
/// global question-pack rows, and claim no curriculum coverage. Every ID is
/// checked by the project's canonical [isValidQuestionId].
///
/// Exactly three item types exist. Each derives its expected answer from
/// [ExactFraction] rather than storing a typed-in result, and rejects any
/// construction that cannot be represented exactly.
sealed class NumberSenseTransferItem {
  NumberSenseTransferItem._(this.id) {
    if (!isValidQuestionId(id)) {
      throw ArgumentError.value(id, 'id', 'is not a valid question id');
    }
  }

  /// The stable question identifier, validated by [isValidQuestionId].
  final String id;
}

/// Which of two presented fractions is equivalent to a source fraction, with
/// the answer written over [answerDenominator].
///
/// [expectedNumerator] is derived: the numerator that makes the source's
/// value over [answerDenominator]. Distractors are numerators over the same
/// denominator, each exactly non-equivalent to the source.
final class EquivalenceTransferItem extends NumberSenseTransferItem {
  EquivalenceTransferItem._({
    required String id,
    required this.source,
    required this.answerDenominator,
    required this.expectedNumerator,
    required List<int> distractorNumerators,
  })  : expected = ExactFraction(expectedNumerator, answerDenominator),
        distractorNumerators = List.unmodifiable(distractorNumerators),
        super._(id);

  /// Derives the expected numerator from [source] and [answerDenominator].
  ///
  /// Throws [ArgumentError] when:
  /// - [id] is not a valid question id;
  /// - [answerDenominator] or the source's denominator is outside the V1
  ///   policy;
  /// - the source cannot be written over [answerDenominator] with a whole
  ///   numerator (for example 1/3 over fourths);
  /// - a distractor is equivalent to the source.
  factory EquivalenceTransferItem.derive({
    required String id,
    required ExactFraction source,
    required int answerDenominator,
    required List<int> distractorNumerators,
  }) {
    _requireV1Denominator(answerDenominator, 'answerDenominator');
    _requireV1Denominator(source.denominator, 'source.denominator');
    final scaled = source.numerator * answerDenominator;
    if (scaled % source.denominator != 0) {
      throw ArgumentError(
          '$source cannot be written over $answerDenominator equal parts: '
          'its numerator would not be a whole number.');
    }
    for (final numerator in distractorNumerators) {
      if (ExactFraction(numerator, answerDenominator) == source) {
        throw ArgumentError.value(numerator, 'distractorNumerators',
            'is equivalent to the source, so it is not a distractor');
      }
    }
    return EquivalenceTransferItem._(
      id: id,
      source: source,
      answerDenominator: answerDenominator,
      expectedNumerator: scaled ~/ source.denominator,
      distractorNumerators: distractorNumerators,
    );
  }

  final ExactFraction source;
  final int answerDenominator;
  final int expectedNumerator;

  /// The expected answer, canonical. Always equal to [source].
  final ExactFraction expected;

  /// Numerators over [answerDenominator] that are not equivalent to [source].
  final List<int> distractorNumerators;
}

/// Place [target] on a partition of [partitionDenominator] equal parts.
///
/// The target is stored as an exact [ExactFraction]. The partition numerator
/// is derived: the number of parts that the target covers on that partition.
final class PlacementTransferItem extends NumberSenseTransferItem {
  PlacementTransferItem._({
    required String id,
    required this.target,
    required this.partitionDenominator,
    required this.partitionNumerator,
  }) : super._(id);

  /// Derives the partition numerator for [target] on [partitionDenominator].
  ///
  /// Throws [ArgumentError] when [id] is invalid, a denominator is outside
  /// the V1 policy, or [target] cannot be represented exactly on the
  /// partition (its reduced denominator must divide [partitionDenominator]).
  factory PlacementTransferItem.derive({
    required String id,
    required ExactFraction target,
    required int partitionDenominator,
  }) {
    _requireV1Denominator(partitionDenominator, 'partitionDenominator');
    _requireV1Denominator(target.denominator, 'target.denominator');
    if (partitionDenominator % target.denominator != 0) {
      throw ArgumentError(
          '$target cannot be placed on $partitionDenominator equal parts.');
    }
    return PlacementTransferItem._(
      id: id,
      target: target,
      partitionDenominator: partitionDenominator,
      partitionNumerator:
          target.numerator * (partitionDenominator ~/ target.denominator),
    );
  }

  final ExactFraction target;
  final int partitionDenominator;

  /// The target's numerator over [partitionDenominator].
  final int partitionNumerator;
}

/// Compare [left] with [right]. The expected result is derived from
/// [ExactFraction.compareTo], through [compareExactFractions].
final class ComparisonTransferItem extends NumberSenseTransferItem {
  ComparisonTransferItem._({
    required String id,
    required this.left,
    required this.right,
  })  : expected = compareExactFractions(left, right),
        super._(id);

  /// Throws [ArgumentError] when [id] is invalid or a denominator is outside
  /// the V1 policy.
  factory ComparisonTransferItem.derive({
    required String id,
    required ExactFraction left,
    required ExactFraction right,
  }) {
    _requireV1Denominator(left.denominator, 'left.denominator');
    _requireV1Denominator(right.denominator, 'right.denominator');
    return ComparisonTransferItem._(id: id, left: left, right: right);
  }

  final ExactFraction left;
  final ExactFraction right;

  /// The exact result of `left` compared with `right`.
  final NumberSenseComparison expected;
}

void _requireV1Denominator(int denominator, String name) {
  if (!numberSenseV1Denominators.contains(denominator)) {
    throw ArgumentError.value(
        denominator, name, 'must be a Number Sense V1 denominator');
  }
}

/// The ten Number Sense transfer items: four equivalence, three placement and
/// three comparison. Unmodifiable, and identical on every access.
final List<NumberSenseTransferItem> numberSenseTransferItems =
    _uniqueIdsOrThrow(List.unmodifiable([
  EquivalenceTransferItem.derive(
    id: 'nsl-v1-eq-01',
    source: ExactFraction(1, 2),
    answerDenominator: 6,
    distractorNumerators: [2, 4],
  ),
  EquivalenceTransferItem.derive(
    id: 'nsl-v1-eq-02',
    source: ExactFraction(2, 3),
    answerDenominator: 6,
    distractorNumerators: [3, 5],
  ),
  EquivalenceTransferItem.derive(
    id: 'nsl-v1-eq-03',
    source: ExactFraction(3, 4),
    answerDenominator: 8,
    distractorNumerators: [5, 7],
  ),
  EquivalenceTransferItem.derive(
    id: 'nsl-v1-eq-04',
    source: ExactFraction(1, 4),
    answerDenominator: 8,
    distractorNumerators: [1, 3],
  ),
  PlacementTransferItem.derive(
    id: 'nsl-v1-pl-01',
    target: ExactFraction(3, 8),
    partitionDenominator: 8,
  ),
  PlacementTransferItem.derive(
    id: 'nsl-v1-pl-02',
    target: ExactFraction(5, 6),
    partitionDenominator: 6,
  ),
  PlacementTransferItem.derive(
    id: 'nsl-v1-pl-03',
    target: ExactFraction(1, 4),
    partitionDenominator: 8,
  ),
  ComparisonTransferItem.derive(
    id: 'nsl-v1-cmp-01',
    left: ExactFraction(2, 3),
    right: ExactFraction(3, 4),
  ),
  ComparisonTransferItem.derive(
    id: 'nsl-v1-cmp-02',
    left: ExactFraction(5, 8),
    right: ExactFraction(1, 2),
  ),
  ComparisonTransferItem.derive(
    id: 'nsl-v1-cmp-03',
    left: ExactFraction(3, 6),
    right: ExactFraction(1, 2),
  ),
]));

/// Returns [items] unchanged, or throws [StateError] if any ID repeats.
List<NumberSenseTransferItem> _uniqueIdsOrThrow(
    List<NumberSenseTransferItem> items) {
  final seen = <String>{};
  for (final item in items) {
    if (!seen.add(item.id)) {
      throw StateError('Duplicate Number Sense transfer id "${item.id}".');
    }
  }
  return items;
}
