import 'dart:convert';
import 'dart:math' as math;

import 'package:crypto/crypto.dart';

import '../models/maze_driver_level.dart';
import '../models/maze_history_entry.dart';

/// One deterministically-generated, validated maze candidate: a real
/// [MazeDriverLevel] (so it flows through the existing loader/painter/BFS
/// solver unchanged) plus the identifiers novelty governance needs.
class MazeGenerationResult {
  const MazeGenerationResult({
    required this.level,
    required this.seed,
    required this.fingerprint,
    required this.routeDirections,
    required this.routePathLength,
  });

  final MazeDriverLevel level;
  final int seed;
  final String fingerprint;
  final String routeDirections;
  final int routePathLength;

  MazeHistoryEntry toHistoryEntry(int completedAtMs) => MazeHistoryEntry(
        seed: seed,
        fingerprint: fingerprint,
        routeDirections: routeDirections,
        routePathLength: routePathLength,
        width: level.width,
        height: level.height,
        difficulty: level.difficulty,
        start: level.start,
        destination: level.destination,
        completedAtMs: completedAtMs,
      );
}

/// Deterministic seeded maze generator: the same seed and difficulty always
/// produce the exact same maze (build a perfect maze via a randomized
/// backtracker seeded by `math.Random(seed)`, never an unseeded `Random()`),
/// with a novelty policy that rejects candidates that repeat or nearly
/// repeat recent history. Every candidate is re-validated with
/// [MazeDriverLevel.validate]/[MazeDriverLevel.shortestPath] rather than
/// trusted blindly, since a perfect maze is solvable by construction but
/// this still guards against a logic error in the carve step.
class MazeGeneratorService {
  MazeGeneratorService._();
  static final instance = MazeGeneratorService._();

  static const attemptBudget = 20;

  /// Builds and validates the exact maze for [seed]/[difficulty] with no
  /// novelty filtering — used to reproduce an identical maze on demand
  /// (e.g. "Try Again").
  MazeGenerationResult buildFromSeed(
      int seed, MazeDriverDifficulty difficulty) {
    final level = _carve(seed, difficulty);
    level.validate();
    final path = level.shortestPath();
    if (path == null) {
      throw StateError('Generated maze $seed is not solvable.');
    }
    return MazeGenerationResult(
      level: level,
      seed: seed,
      fingerprint: _fingerprint(level),
      routeDirections: _directionsFor(path),
      routePathLength: path.length - 1,
    );
  }

  /// Finds the first accepted candidate starting from [startSeed], deriving
  /// a new deterministic seed for each retry, up to [attemptBudget]
  /// attempts. Returns null if none is accepted within the budget — callers
  /// should fall back to a curated level in that case.
  MazeGenerationResult? findAccepted({
    required int startSeed,
    required MazeDriverDifficulty difficulty,
    required List<MazeHistoryEntry> history,
  }) {
    var seed = startSeed;
    for (var attempt = 0; attempt < attemptBudget; attempt++) {
      final candidate = buildFromSeed(seed, difficulty);
      if (_isAccepted(candidate, history)) return candidate;
      seed = _deriveNextSeed(seed, attempt);
    }
    return null;
  }

  bool _isAccepted(
    MazeGenerationResult candidate,
    List<MazeHistoryEntry> history,
  ) {
    for (final entry in history) {
      if (entry.seed == candidate.seed) return false;
      if (entry.fingerprint == candidate.fingerprint) return false;
      if (entry.start == candidate.level.start &&
          entry.destination == candidate.level.destination) {
        return false;
      }
      if (_tooSimilar(entry, candidate)) return false;
    }
    return true;
  }

  bool _tooSimilar(MazeHistoryEntry entry, MazeGenerationResult candidate) {
    if ((entry.routePathLength - candidate.routePathLength).abs() > 1) {
      return false;
    }
    return _directionSimilarity(
          entry.routeDirections,
          candidate.routeDirections,
        ) >=
        0.8;
  }

  static double _directionSimilarity(String a, String b) {
    final maxLen = math.max(a.length, b.length);
    if (maxLen == 0) return 1.0;
    return 1.0 - (_levenshtein(a, b) / maxLen);
  }

  static int _levenshtein(String a, String b) {
    final rows = a.length + 1;
    final cols = b.length + 1;
    var previous = List<int>.generate(cols, (j) => j);
    for (var i = 1; i < rows; i++) {
      final current = List<int>.filled(cols, 0);
      current[0] = i;
      for (var j = 1; j < cols; j++) {
        final cost = a[i - 1] == b[j - 1] ? 0 : 1;
        current[j] = [
          current[j - 1] + 1,
          previous[j] + 1,
          previous[j - 1] + cost,
        ].reduce(math.min);
      }
      previous = current;
    }
    return previous[cols - 1];
  }

  static int _deriveNextSeed(int seed, int attempt) {
    // Deterministic, not cryptographic: a fixed function of (seed, attempt)
    // so retries are reproducible, scrambled through Random for a decent
    // spread rather than a trivially incrementing sequence.
    final mixed = (seed * 2654435761) + attempt + 1;
    return math.Random(mixed & 0x7FFFFFFF).nextInt(0x7FFFFFFF);
  }

  static const _roomTiersByDifficulty = {
    MazeDriverDifficulty.guided: [2, 3],
    MazeDriverDifficulty.explorer: [3, 4],
    MazeDriverDifficulty.precision: [4, 5],
  };

  static const _moveBufferByDifficulty = {
    MazeDriverDifficulty.guided: 2,
    MazeDriverDifficulty.explorer: 2,
    MazeDriverDifficulty.precision: 1,
  };

  MazeDriverLevel _carve(int seed, MazeDriverDifficulty difficulty) {
    final random = math.Random(seed);
    final tiers = _roomTiersByDifficulty[difficulty]!;
    final roomsW = tiers[random.nextInt(tiers.length)];
    final roomsH = tiers[random.nextInt(tiers.length)];

    final visitedRooms = <_RoomPoint>{};
    final carved = <MazePoint>{};
    final startRoom = _RoomPoint(0, 0);
    visitedRooms.add(startRoom);
    carved.add(_roomCell(startRoom));

    final stack = <_RoomPoint>[startRoom];
    while (stack.isNotEmpty) {
      final current = stack.last;
      final unvisitedNeighbors = <_RoomPoint>[
        for (final delta in _roomDirections)
          _RoomPoint(current.x + delta.x, current.y + delta.y)
      ]
          .where((room) =>
              room.x >= 0 &&
              room.y >= 0 &&
              room.x < roomsW &&
              room.y < roomsH &&
              !visitedRooms.contains(room))
          .toList();

      if (unvisitedNeighbors.isEmpty) {
        stack.removeLast();
        continue;
      }
      final next =
          unvisitedNeighbors[random.nextInt(unvisitedNeighbors.length)];
      visitedRooms.add(next);
      carved.add(_roomCell(next));
      carved.add(MazePoint(current.x + next.x + 1, current.y + next.y + 1));
      stack.add(next);
    }

    final width = 2 * roomsW + 1;
    final height = 2 * roomsH + 1;
    final walls = <MazePoint>{
      for (var y = 0; y < height; y++)
        for (var x = 0; x < width; x++)
          if (!carved.contains(MazePoint(x, y))) MazePoint(x, y),
    };

    final start = _roomCell(_RoomPoint(0, 0));
    final destination = _roomCell(_RoomPoint(roomsW - 1, roomsH - 1));
    final level = MazeDriverLevel(
      levelId: 'procedural-$seed',
      width: width,
      height: height,
      start: start,
      destination: destination,
      walls: walls,
      moveTarget: 1,
      timeTargetSeconds: 30,
      missionLabel: 'Deliver the science equipment to the lab.',
      difficulty: difficulty,
    );
    final path = level.shortestPath();
    final buffer = _moveBufferByDifficulty[difficulty]!;
    final moveTarget = (path == null ? 1 : path.length - 1) + buffer;
    return MazeDriverLevel(
      levelId: level.levelId,
      width: level.width,
      height: level.height,
      start: level.start,
      destination: level.destination,
      walls: level.walls,
      moveTarget: moveTarget,
      timeTargetSeconds: math.max(30, (moveTarget * 2.8).round()),
      missionLabel: level.missionLabel,
      difficulty: level.difficulty,
    );
  }

  static MazePoint _roomCell(_RoomPoint room) =>
      MazePoint(2 * room.x + 1, 2 * room.y + 1);

  static String _fingerprint(MazeDriverLevel level) {
    final sortedWalls = level.walls.toList()
      ..sort((a, b) => a.x != b.x ? a.x.compareTo(b.x) : a.y.compareTo(b.y));
    final canonical = jsonEncode({
      'width': level.width,
      'height': level.height,
      'start': level.start.toJson(),
      'destination': level.destination.toJson(),
      'walls': [for (final wall in sortedWalls) wall.toJson()],
    });
    return sha256.convert(utf8.encode(canonical)).toString();
  }

  static String _directionsFor(List<MazePoint> path) {
    final buffer = StringBuffer();
    for (var i = 1; i < path.length; i++) {
      final dx = path[i].x - path[i - 1].x;
      final dy = path[i].y - path[i - 1].y;
      if (dy == -1) {
        buffer.write('U');
      } else if (dy == 1) {
        buffer.write('D');
      } else if (dx == -1) {
        buffer.write('L');
      } else {
        buffer.write('R');
      }
    }
    return buffer.toString();
  }
}

class _RoomPoint {
  const _RoomPoint(this.x, this.y);
  final int x;
  final int y;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _RoomPoint && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);
}

const _roomDirections = [
  _RoomPoint(0, -1),
  _RoomPoint(1, 0),
  _RoomPoint(0, 1),
  _RoomPoint(-1, 0),
];
