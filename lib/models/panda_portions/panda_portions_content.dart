/// Panda Portions V1 — the lesson-content model.
///
/// Everything a Panda Portions round needs to be taught and checked lives
/// here as plain, testable data: the authored lesson sequence, each lesson's
/// prompts and messages (as [PortionMessage] ids — the learner-facing words
/// are resolved through the app's localisations in
/// `panda_portions_copy.dart`), the visual partitions of the apple, and the
/// expected answers.
///
/// Scope (deliberately narrow): this is an applied-learning lesson about
/// fair sharing — equal parts of one whole, halves and quarters. It makes no
/// curriculum-coverage, Topic Hub, mastery or assessment claim, and it holds
/// no learner data; all progression is session-only (see
/// `panda_portions_session.dart`).
library;

import 'dart:math' as math;

/// The authored lessons, in teaching order.
enum PortionLessonId { equalParts, halves, quarters }

/// Where a learner chose to start from the Panda Portions menu. A path only
/// chooses the *first* lesson; it never locks or unlocks anything.
enum PortionPath { guided, practiseHalves, practiseQuarters }

/// How "Keep practising this" builds a fresh round for the same lesson.
enum PortionVariationStrategy {
  /// Alternate the example (2 parts / 4 parts), swap which plate holds the
  /// fair share, and vary the uneven split.
  alternateExamplePairs,

  /// Keep the lesson's part count; rotate the cuts, swap which plate holds
  /// the equal parts, and vary the uneven decoy split.
  rotateAndSwapPlates,
}

/// Every learner-facing message a lesson can show. Resolved to words by
/// `PandaPortionsCopy`; keeping ids here keeps the content contract testable
/// without a widget tree.
enum PortionMessage {
  lessonEqualPartsTitle,
  lessonEqualPartsPurpose,
  lessonHalvesTitle,
  lessonHalvesPurpose,
  lessonQuartersTitle,
  lessonQuartersPurpose,
  promptEqualParts,
  promptHalves,
  promptQuarters,
  teachEqualParts,
  successEqualParts,
  successFedPart,
  successAte,
  remainingLeft,
  misconceptionUnequal,
  incorrectSelection,
  hintEqualParts,
  hintHalves,
  hintQuarters,
  retryEqualParts,
  retryHalves,
  retryQuarters,
  suggestTryHalves,
  suggestTryQuarters,
  suggestNewChallenge,
}

/// A simple fraction, kept in lowest terms. Displayed as `n/d` (the same
/// symbol in every locale).
class PortionFraction {
  PortionFraction(int numerator, int denominator)
      : assert(denominator > 0),
        assert(numerator >= 0 && numerator <= denominator),
        numerator = numerator ~/ _gcd(numerator, denominator),
        denominator = denominator ~/ _gcd(numerator, denominator);

  final int numerator;
  final int denominator;

  static int _gcd(int a, int b) =>
      b == 0 ? (a == 0 ? 1 : a.abs()) : _gcd(b, a % b);

  @override
  String toString() => '$numerator/$denominator';

  @override
  bool operator ==(Object other) =>
      other is PortionFraction &&
      other.numerator == numerator &&
      other.denominator == denominator;

  @override
  int get hashCode => Object.hash(numerator, denominator);
}

/// How one whole apple is cut, as each part's share of the whole (summing
/// to 1). Parts are drawn as sectors of a top-down apple slice, so equal
/// shares really are equal areas on screen.
class ApplePartition {
  ApplePartition(List<double> shares) : shares = List.unmodifiable(shares) {
    if (shares.length < 2) {
      throw ArgumentError('A partition needs at least two parts.');
    }
    final total = shares.fold<double>(0, (a, b) => a + b);
    if ((total - 1).abs() > 1e-9 || shares.any((s) => s <= 0)) {
      throw ArgumentError('Shares must be positive and sum to 1: $shares');
    }
  }

  /// One whole cut into [parts] equal parts.
  factory ApplePartition.equal(int parts) =>
      ApplePartition(List.filled(parts, 1 / parts));

  final List<double> shares;

  int get partCount => shares.length;

  /// True only when every part is the same size — the defining property of
  /// halves and quarters.
  bool get isEqual => shares.every((s) => (s - 1 / partCount).abs() < 1e-9);

  /// The fraction one part represents, or null when the parts are unequal
  /// (an unequal part is not "one half" or "one quarter").
  PortionFraction? get unitFraction =>
      isEqual ? PortionFraction(1, partCount) : null;
}

/// One authored lesson.
class PortionLesson {
  const PortionLesson({
    required this.id,
    required this.title,
    required this.purpose,
    required this.prompt,
    required this.recommendedAfter,
    required this.nextLessonId,
    required this.variationStrategy,
    required this.partsPerApple,
    required this.successMessages,
    required this.hint,
    required this.misconceptionMessages,
    required this.retryLabel,
    required this.successSuggestion,
    required this.unevenDecoys,
  });

  final PortionLessonId id;
  final PortionMessage title;

  /// Learner-facing purpose ("what you'll do").
  final PortionMessage purpose;
  final PortionMessage prompt;

  /// A *recommendation* only: the lesson it helps to try first. Never a
  /// lock — every lesson is always directly selectable.
  final PortionLessonId? recommendedAfter;

  /// The next lesson in the authored sequence (Equal Parts → Halves →
  /// Quarters), or null at the end.
  final PortionLessonId? nextLessonId;

  final PortionVariationStrategy variationStrategy;

  /// Equal parts one apple is cut into for this lesson; null for Equal Parts
  /// (whose examples alternate between 2 and 4).
  final int? partsPerApple;

  final List<PortionMessage> successMessages;
  final PortionMessage hint;
  final List<PortionMessage> misconceptionMessages;

  /// Label for "try another" after an incorrect attempt.
  final PortionMessage retryLabel;

  /// Optional suggestion after a success (e.g. "You could try quarters
  /// next."). A suggestion, never a promotion.
  final PortionMessage? successSuggestion;

  /// Uneven ways to cut one apple, used as the "not fair" comparison plate.
  final List<ApplePartition> unevenDecoys;
}

/// The authored Panda Portions content.
class PandaPortionsContent {
  PandaPortionsContent._();

  /// Successful rounds in one lesson (this session) after which the gentle
  /// "Ready for a new challenge?" suggestion may appear. A suggestion only.
  static const int newChallengeSuggestionAfter = 2;

  static final List<ApplePartition> _uneven2 = [
    ApplePartition([0.68, 0.32]),
    ApplePartition([0.3, 0.7]),
    ApplePartition([0.62, 0.38]),
  ];

  static final List<ApplePartition> _uneven4 = [
    ApplePartition([0.38, 0.27, 0.2, 0.15]),
    ApplePartition([0.4, 0.15, 0.3, 0.15]),
    ApplePartition([0.2, 0.35, 0.15, 0.3]),
  ];

  static final Map<PortionLessonId, PortionLesson> lessons = {
    PortionLessonId.equalParts: PortionLesson(
      id: PortionLessonId.equalParts,
      title: PortionMessage.lessonEqualPartsTitle,
      purpose: PortionMessage.lessonEqualPartsPurpose,
      prompt: PortionMessage.promptEqualParts,
      recommendedAfter: null,
      nextLessonId: PortionLessonId.halves,
      variationStrategy: PortionVariationStrategy.alternateExamplePairs,
      partsPerApple: null,
      successMessages: const [
        PortionMessage.successEqualParts,
        PortionMessage.teachEqualParts,
      ],
      hint: PortionMessage.hintEqualParts,
      misconceptionMessages: const [PortionMessage.misconceptionUnequal],
      retryLabel: PortionMessage.retryEqualParts,
      successSuggestion: PortionMessage.suggestTryHalves,
      unevenDecoys: [..._uneven2, ..._uneven4],
    ),
    PortionLessonId.halves: PortionLesson(
      id: PortionLessonId.halves,
      title: PortionMessage.lessonHalvesTitle,
      purpose: PortionMessage.lessonHalvesPurpose,
      prompt: PortionMessage.promptHalves,
      recommendedAfter: PortionLessonId.equalParts,
      nextLessonId: PortionLessonId.quarters,
      variationStrategy: PortionVariationStrategy.rotateAndSwapPlates,
      partsPerApple: 2,
      successMessages: const [
        PortionMessage.successFedPart,
        PortionMessage.successAte,
        PortionMessage.remainingLeft,
      ],
      hint: PortionMessage.hintHalves,
      misconceptionMessages: const [
        PortionMessage.misconceptionUnequal,
        PortionMessage.incorrectSelection,
      ],
      retryLabel: PortionMessage.retryHalves,
      successSuggestion: PortionMessage.suggestTryQuarters,
      unevenDecoys: _uneven2,
    ),
    PortionLessonId.quarters: PortionLesson(
      id: PortionLessonId.quarters,
      title: PortionMessage.lessonQuartersTitle,
      purpose: PortionMessage.lessonQuartersPurpose,
      prompt: PortionMessage.promptQuarters,
      recommendedAfter: PortionLessonId.halves,
      nextLessonId: null,
      variationStrategy: PortionVariationStrategy.rotateAndSwapPlates,
      partsPerApple: 4,
      successMessages: const [
        PortionMessage.successFedPart,
        PortionMessage.successAte,
        PortionMessage.remainingLeft,
      ],
      hint: PortionMessage.hintQuarters,
      misconceptionMessages: const [
        PortionMessage.misconceptionUnequal,
        PortionMessage.incorrectSelection,
      ],
      retryLabel: PortionMessage.retryQuarters,
      successSuggestion: null,
      unevenDecoys: _uneven4,
    ),
  };

  /// The authored order, followed by "Next lesson".
  static const List<PortionLessonId> sequence = [
    PortionLessonId.equalParts,
    PortionLessonId.halves,
    PortionLessonId.quarters,
  ];

  static PortionLesson lesson(PortionLessonId id) => lessons[id]!;

  /// The first lesson for a menu choice.
  static PortionLessonId startOf(PortionPath path) => switch (path) {
        PortionPath.guided => PortionLessonId.equalParts,
        PortionPath.practiseHalves => PortionLessonId.halves,
        PortionPath.practiseQuarters => PortionLessonId.quarters,
      };
}

/// Which side a plate is on.
enum PlateSide { left, right }

/// One plate in a round: an apple cut by [partition], drawn rotated by
/// [rotationTurns] (fractions of a full turn).
class PortionPlate {
  const PortionPlate({
    required this.side,
    required this.partition,
    required this.rotationTurns,
  });

  final PlateSide side;
  final ApplePartition partition;
  final double rotationTurns;

  /// 'A' (left) or 'B' (right) — used in labels and piece ids.
  String get letter => side == PlateSide.left ? 'A' : 'B';

  String pieceId(int index) => '$letter$index';
}

/// One deterministic round of a lesson: two plates, one cut into equal
/// parts and one cut unevenly, plus the expected answer.
class PortionRound {
  PortionRound._({
    required this.lesson,
    required this.variation,
    required this.left,
    required this.right,
  });

  /// Builds variation [variation] of [lesson]. Same inputs, same round.
  factory PortionRound.build(PortionLesson lesson, int variation) {
    final v = variation.abs();
    late final int parts;
    late final bool equalOnLeft;
    late final ApplePartition decoy;
    double rotation = 0;

    switch (lesson.variationStrategy) {
      case PortionVariationStrategy.alternateExamplePairs:
        parts = v.isEven ? 2 : 4;
        equalOnLeft = (v ~/ 2).isEven;
        final pool = lesson.unevenDecoys
            .where((d) => d.partCount == parts)
            .toList(growable: false);
        decoy = pool[(v ~/ 2) % pool.length];
      case PortionVariationStrategy.rotateAndSwapPlates:
        parts = lesson.partsPerApple!;
        equalOnLeft = v.isEven;
        decoy = lesson.unevenDecoys[v % lesson.unevenDecoys.length];
        // A different cut angle every round (a multiple of 15 degrees).
        rotation = ((v * 5) % 24) / 24;
    }

    final equal = PortionPlate(
      side: equalOnLeft ? PlateSide.left : PlateSide.right,
      partition: ApplePartition.equal(parts),
      rotationTurns: rotation,
    );
    final uneven = PortionPlate(
      side: equalOnLeft ? PlateSide.right : PlateSide.left,
      partition: decoy,
      rotationTurns: (rotation + 0.125) % 1,
    );
    return PortionRound._(
      lesson: lesson,
      variation: variation,
      left: equalOnLeft ? equal : uneven,
      right: equalOnLeft ? uneven : equal,
    );
  }

  final PortionLesson lesson;
  final int variation;
  final PortionPlate left;
  final PortionPlate right;

  List<PortionPlate> get plates => [left, right];

  PortionPlate get equalPlate => left.partition.isEqual ? left : right;
  PortionPlate get unevenPlate => left.partition.isEqual ? right : left;

  /// Equal parts in the fair share for this round (2 or 4).
  int get partCount => equalPlate.partition.partCount;

  /// The fraction Panda should be fed (Halves/Quarters lessons).
  PortionFraction get expectedFed => PortionFraction(1, partCount);

  /// What is left of the apple once one equal part has been fed.
  PortionFraction get remainingAfterCorrect =>
      PortionFraction(partCount - 1, partCount);

  /// Whether this lesson is answered by choosing a plate (Equal Parts) or by
  /// feeding Panda one piece (Halves, Quarters).
  bool get choosesPlate => lesson.id == PortionLessonId.equalParts;

  PortionPlate plateOfPiece(String pieceId) =>
      pieceId.startsWith('A') ? left : right;

  int indexOfPiece(String pieceId) => int.parse(pieceId.substring(1));

  /// Deterministic check: feeding a piece is correct only when it is one
  /// part of the plate cut into equal parts.
  bool isCorrectPiece(String pieceId) =>
      !choosesPlate && plateOfPiece(pieceId).partition.isEqual;

  /// Deterministic check for Equal Parts: the fair plate is correct.
  bool isCorrectPlate(PlateSide side) =>
      choosesPlate && (side == PlateSide.left ? left : right).partition.isEqual;

  /// A short signature, used to prove rounds really vary.
  String get signature => '${left.partition.shares}|${right.partition.shares}|'
      '${left.rotationTurns.toStringAsFixed(3)}';
}

/// Helpers for drawing a partition as sectors.
class PortionGeometry {
  PortionGeometry._();

  /// Start angle (radians, 0 = 12 o'clock, clockwise) of each part.
  static List<double> startAngles(ApplePartition p, double rotationTurns) {
    final out = <double>[];
    var acc = rotationTurns;
    for (final s in p.shares) {
      out.add(acc * 2 * math.pi);
      acc += s;
    }
    return out;
  }
}
