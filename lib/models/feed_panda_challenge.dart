import 'dart:math' as math;

/// One round's fixed content: a target amount, a stable set of source
/// fruit ids in a display order, and the multiple-choice options for the
/// "how many are left?" follow-up. Pure data — no widget/controller
/// concerns live here.
///
/// Round 1 content (per the brief): apples only, exactly 5 available,
/// target always 1-3.
class FeedPandaChallenge {
  const FeedPandaChallenge({
    required this.seed,
    required this.targetCount,
    required this.fruitIds,
    required this.remainingAnswerChoices,
    required this.correctRemainingAnswer,
  });

  /// The seed this challenge was generated from — kept on the challenge
  /// itself so a round can be reproduced or advanced without the caller
  /// tracking it separately.
  final int seed;

  /// How many apples Panda should be fed this round. Always 1-3 in Round 1.
  final int targetCount;

  /// Exactly 5 stable, unique fruit ids, in the order they should be laid
  /// out in the source matrix. Ids are stable across the round (an
  /// accepted fruit keeps its id until a new round is generated) so drag
  /// state, semantics, and event logging can all key off the same value.
  final List<String> fruitIds;

  /// Multiple-choice options offered for "how many apples are left?" —
  /// always includes [correctRemainingAnswer] plus plausible distractors,
  /// in a seed-determined (not alphabetically/numerically sorted) order.
  final List<int> remainingAnswerChoices;

  /// The correct answer to "how many apples are left?" — always
  /// `fruitIds.length - targetCount`.
  final int correctRemainingAnswer;

  static const _fruitCount = 5;
  static const _minTarget = 1;
  static const _maxTarget = 3;
  static const _answerChoiceCount = 4;

  /// Deterministically builds the round for [seed]: the same seed always
  /// produces the same [targetCount], the same [fruitIds] order, and the
  /// same [remainingAnswerChoices] order. `math.Random(seed)` is called
  /// exactly once, here — never inside a widget or the round controller —
  /// mirroring `MazeGeneratorService.buildFromSeed`'s convention.
  factory FeedPandaChallenge.forSeed(int seed) {
    final random = math.Random(seed);

    final targetCount =
        _minTarget + random.nextInt(_maxTarget - _minTarget + 1);

    final fruitIds = List<String>.generate(_fruitCount, (i) => 'apple-$i')
      ..shuffle(random);

    final correctRemainingAnswer = _fruitCount - targetCount;
    final distractorPool = [
      for (var value = 0; value <= _fruitCount; value++)
        if (value != correctRemainingAnswer) value,
    ]..shuffle(random);
    final choices = [
      correctRemainingAnswer,
      ...distractorPool.take(_answerChoiceCount - 1),
    ]..shuffle(random);

    return FeedPandaChallenge(
      seed: seed,
      targetCount: targetCount,
      fruitIds: List.unmodifiable(fruitIds),
      remainingAnswerChoices: List.unmodifiable(choices),
      correctRemainingAnswer: correctRemainingAnswer,
    );
  }
}
