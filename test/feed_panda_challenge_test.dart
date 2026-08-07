import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/feed_panda_challenge.dart';

/// Early Maths Playground / Feed the Hungry Panda — deterministic
/// generator coverage. Mirrors maze_generator_service_test.dart's
/// determinism-assertion style: same seed -> identical output, every
/// field checked, not just a summary hash.
void main() {
  group('FeedPandaChallenge.forSeed determinism', () {
    test(
        'the same seed always produces the same target, fruit order, and '
        'answer ordering', () {
      final a = FeedPandaChallenge.forSeed(42);
      final b = FeedPandaChallenge.forSeed(42);
      expect(a.targetCount, b.targetCount);
      expect(a.fruitIds, b.fruitIds);
      expect(a.remainingAnswerChoices, b.remainingAnswerChoices);
      expect(a.correctRemainingAnswer, b.correctRemainingAnswer);
    });

    test('is deterministic across many repeated calls for one seed', () {
      final first = FeedPandaChallenge.forSeed(7);
      for (var i = 0; i < 10; i++) {
        final repeat = FeedPandaChallenge.forSeed(7);
        expect(repeat.targetCount, first.targetCount);
        expect(repeat.fruitIds, first.fruitIds);
        expect(repeat.remainingAnswerChoices, first.remainingAnswerChoices);
      }
    });
  });

  group('Round 1 content rules', () {
    test('target is always between 1 and 3 inclusive, across many seeds', () {
      for (var seed = 0; seed < 500; seed++) {
        final challenge = FeedPandaChallenge.forSeed(seed);
        expect(challenge.targetCount, inInclusiveRange(1, 3),
            reason: 'seed $seed produced target ${challenge.targetCount}');
      }
    });

    test('exactly five source apples, always unique ids, across many seeds',
        () {
      for (var seed = 0; seed < 500; seed++) {
        final challenge = FeedPandaChallenge.forSeed(seed);
        expect(challenge.fruitIds, hasLength(5));
        expect(challenge.fruitIds.toSet(), hasLength(5),
            reason: 'seed $seed produced duplicate fruit ids');
      }
    });

    test('fruit ids are always the same 5 stable apple ids, just reordered',
        () {
      const expectedIds = {
        'apple-0',
        'apple-1',
        'apple-2',
        'apple-3',
        'apple-4'
      };
      for (var seed = 0; seed < 100; seed++) {
        final challenge = FeedPandaChallenge.forSeed(seed);
        expect(challenge.fruitIds.toSet(), expectedIds);
      }
    });

    test('correctRemainingAnswer is always 5 - targetCount', () {
      for (var seed = 0; seed < 200; seed++) {
        final challenge = FeedPandaChallenge.forSeed(seed);
        expect(challenge.correctRemainingAnswer, 5 - challenge.targetCount);
      }
    });

    test(
        'remainingAnswerChoices always contains the correct answer exactly once',
        () {
      for (var seed = 0; seed < 200; seed++) {
        final challenge = FeedPandaChallenge.forSeed(seed);
        final occurrences = challenge.remainingAnswerChoices
            .where((v) => v == challenge.correctRemainingAnswer)
            .length;
        expect(occurrences, 1,
            reason: 'seed $seed: choices ${challenge.remainingAnswerChoices} '
                'should contain ${challenge.correctRemainingAnswer} exactly once');
      }
    });

    test('remainingAnswerChoices has no duplicate values', () {
      for (var seed = 0; seed < 200; seed++) {
        final challenge = FeedPandaChallenge.forSeed(seed);
        expect(challenge.remainingAnswerChoices.toSet().length,
            challenge.remainingAnswerChoices.length,
            reason: 'seed $seed produced duplicate answer choices');
      }
    });

    test('every choice is a plausible in-range value (0 to 5 inclusive)', () {
      for (var seed = 0; seed < 200; seed++) {
        final challenge = FeedPandaChallenge.forSeed(seed);
        for (final choice in challenge.remainingAnswerChoices) {
          expect(choice, inInclusiveRange(0, 5));
        }
      }
    });
  });

  group('Governed seed variation', () {
    test('different seeds produce suitable variation in target and order', () {
      final targets = <int>{};
      final firstFruitOrders = <List<String>>{};
      for (var seed = 0; seed < 30; seed++) {
        final challenge = FeedPandaChallenge.forSeed(seed);
        targets.add(challenge.targetCount);
        firstFruitOrders.add(challenge.fruitIds);
      }
      // Not guaranteed unique in general (per the maze generator's own
      // documented caveat), but 30 seeds should exercise all 3 possible
      // targets and more than one fruit ordering.
      expect(targets.length, greaterThan(1));
      expect(targets, containsAll(<int>{1, 2, 3}));
      expect(firstFruitOrders.length, greaterThan(1));
    });

    test('consecutive governed seeds (as New Round advances through) differ',
        () {
      final seedOne = FeedPandaChallenge.forSeed(1);
      final seedTwo = FeedPandaChallenge.forSeed(2);
      // At least one of target/order should differ for adjacent seeds in
      // this deterministic sequence — a hash-style "not identical" check
      // rather than asserting any single field must differ.
      final identical = seedOne.targetCount == seedTwo.targetCount &&
          seedOne.fruitIds.toString() == seedTwo.fruitIds.toString() &&
          seedOne.remainingAnswerChoices.toString() ==
              seedTwo.remainingAnswerChoices.toString();
      expect(identical, isFalse);
    });
  });
}
