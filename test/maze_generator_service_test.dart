import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/maze_driver_level.dart';
import 'package:unified_math_tutor/models/maze_history_entry.dart';
import 'package:unified_math_tutor/services/maze_generator_service.dart';

void main() {
  final generator = MazeGeneratorService.instance;

  group('buildFromSeed', () {
    test('produces a valid, solvable maze for a known seed', () {
      final result = generator.buildFromSeed(1, MazeDriverDifficulty.guided);

      expect(() => result.level.validate(), returnsNormally);
      expect(result.level.shortestPath(), isNotNull);
      expect(result.level.start, isNot(result.level.destination));
      expect(result.routePathLength, greaterThan(0));
      expect(result.level.moveTarget,
          greaterThanOrEqualTo(result.routePathLength));
    });

    test('is deterministic: the same seed always produces the same maze', () {
      final a = generator.buildFromSeed(42, MazeDriverDifficulty.explorer);
      final b = generator.buildFromSeed(42, MazeDriverDifficulty.explorer);

      expect(a.fingerprint, b.fingerprint);
      expect(a.routeDirections, b.routeDirections);
      expect(a.level.width, b.level.width);
      expect(a.level.height, b.level.height);
      expect(a.level.walls, b.level.walls);
      expect(a.level.start, b.level.start);
      expect(a.level.destination, b.level.destination);
    });

    test(
        'different seeds produce different fingerprints (not guaranteed '
        'unique in general, but true for these known seeds)', () {
      final a = generator.buildFromSeed(1, MazeDriverDifficulty.precision);
      final b = generator.buildFromSeed(2, MazeDriverDifficulty.precision);

      expect(a.fingerprint, isNot(b.fingerprint));
    });

    test(
        'dimensions stay within the model\'s validated bounds for every '
        'difficulty tier', () {
      for (final difficulty in MazeDriverDifficulty.values) {
        for (var seed = 0; seed < 20; seed++) {
          final result = generator.buildFromSeed(seed, difficulty);
          expect(result.level.width, inInclusiveRange(5, 11));
          expect(result.level.height, inInclusiveRange(5, 11));
        }
      }
    });
  });

  group('findAccepted novelty policy', () {
    test('rejects an exact fingerprint duplicate and finds a different maze',
        () {
      final original = generator.buildFromSeed(7, MazeDriverDifficulty.guided);
      final history = [original.toHistoryEntry(0)];

      final accepted = generator.findAccepted(
        startSeed: 7,
        difficulty: MazeDriverDifficulty.guided,
        history: history,
      );

      expect(accepted, isNotNull);
      expect(accepted!.fingerprint, isNot(original.fingerprint));
      expect(accepted.seed, isNot(7));
    });

    test('rejects a reused seed even if the fingerprint happens to differ', () {
      final history = [
        MazeHistoryEntry(
          seed: 7,
          fingerprint: 'not-the-real-fingerprint',
          routeDirections: 'RRRR',
          routePathLength: 4,
          width: 7,
          height: 7,
          difficulty: MazeDriverDifficulty.guided,
          start: const MazePoint(1, 1),
          destination: const MazePoint(5, 5),
          completedAtMs: 0,
        ),
      ];

      final accepted = generator.findAccepted(
        startSeed: 7,
        difficulty: MazeDriverDifficulty.guided,
        history: history,
      );

      expect(accepted, isNotNull);
      expect(accepted!.seed, isNot(7));
    });

    test(
        'rejects a near-identical route signature (same length band, high '
        'direction-string similarity)', () {
      final original = generator.buildFromSeed(11, MazeDriverDifficulty.guided);
      final history = [
        MazeHistoryEntry(
          seed: 999999,
          fingerprint: 'unrelated-fingerprint',
          routeDirections: original.routeDirections,
          routePathLength: original.routePathLength,
          width: original.level.width,
          height: original.level.height,
          difficulty: original.level.difficulty,
          start: const MazePoint(0, 0),
          destination: const MazePoint(1, 1),
          completedAtMs: 0,
        ),
      ];

      final accepted = generator.findAccepted(
        startSeed: 11,
        difficulty: MazeDriverDifficulty.guided,
        history: history,
      );

      expect(accepted, isNotNull);
      expect(accepted!.routeDirections, isNot(original.routeDirections));
    });

    test('rejects a repeated start/destination pairing within history', () {
      final original = generator.buildFromSeed(3, MazeDriverDifficulty.guided);
      final history = [
        MazeHistoryEntry(
          seed: 424242,
          fingerprint: 'unrelated-fingerprint',
          routeDirections: 'X',
          routePathLength: 100,
          width: original.level.width,
          height: original.level.height,
          difficulty: original.level.difficulty,
          start: original.level.start,
          destination: original.level.destination,
          completedAtMs: 0,
        ),
      ];

      final accepted = generator.findAccepted(
        startSeed: 3,
        difficulty: MazeDriverDifficulty.guided,
        history: history,
      );

      expect(accepted, isNotNull);
      expect(
        accepted!.level.start == original.level.start &&
            accepted.level.destination == original.level.destination,
        isFalse,
      );
    });

    test(
        'falls back to null when every candidate within the attempt budget '
        'is rejected', () {
      // Build the exact sequence of candidates findAccepted would try for
      // this seed/difficulty, and pre-populate history with all of their
      // fingerprints so every attempt is rejected.
      final history = <MazeHistoryEntry>[];
      var seed = 5;
      for (var attempt = 0;
          attempt < MazeGeneratorService.attemptBudget;
          attempt++) {
        final candidate =
            generator.buildFromSeed(seed, MazeDriverDifficulty.guided);
        history.add(candidate.toHistoryEntry(0));
        seed = _deriveNextSeedForTest(seed, attempt);
      }

      final accepted = generator.findAccepted(
        startSeed: 5,
        difficulty: MazeDriverDifficulty.guided,
        history: history,
      );

      expect(accepted, isNull,
          reason:
              'Every candidate in the exact retry sequence was pre-rejected '
              'via an exact fingerprint match, so none should be accepted');
    });

    test(
        'an empty history accepts the very first candidate (the starting '
        'seed itself)', () {
      final accepted = generator.findAccepted(
        startSeed: 123,
        difficulty: MazeDriverDifficulty.explorer,
        history: const [],
      );

      expect(accepted, isNotNull);
      expect(accepted!.seed, 123);
    });
  });

  group('Next Maze / Try Again semantics', () {
    test(
        'Next Maze (findAccepted against the current maze\'s own history '
        'entry) never returns the identical maze', () {
      final current = generator.buildFromSeed(55, MazeDriverDifficulty.guided);
      final next = generator.findAccepted(
        startSeed: 55,
        difficulty: MazeDriverDifficulty.guided,
        history: [current.toHistoryEntry(0)],
      );

      expect(next, isNotNull);
      expect(next!.seed, isNot(current.seed));
      expect(next.fingerprint, isNot(current.fingerprint));
    });

    test(
        'Try Again (buildFromSeed with the stored seed) reproduces the '
        'exact same maze deterministically', () {
      final first = generator.buildFromSeed(88, MazeDriverDifficulty.precision);
      final tryAgain =
          generator.buildFromSeed(88, MazeDriverDifficulty.precision);

      expect(tryAgain.fingerprint, first.fingerprint);
      expect(tryAgain.level.walls, first.level.walls);
    });
  });
}

/// Mirrors MazeGeneratorService's private seed-derivation formula so the
/// fallback-to-null test can pre-compute the exact retry sequence without
/// exposing that private method.
int _deriveNextSeedForTest(int seed, int attempt) {
  final mixed = (seed * 2654435761) + attempt + 1;
  return math.Random(mixed & 0x7FFFFFFF).nextInt(0x7FFFFFFF);
}
