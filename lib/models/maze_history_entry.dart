import 'maze_driver_level.dart';

/// One past procedurally-generated maze, recorded for novelty governance
/// (reject exact/near-duplicate future mazes) and persisted by
/// `MazeDriverHistoryService`. Mirrors the fields `MazeGeneratorService`
/// needs to compare a new candidate against.
class MazeHistoryEntry {
  const MazeHistoryEntry({
    required this.seed,
    required this.fingerprint,
    required this.routeDirections,
    required this.routePathLength,
    required this.width,
    required this.height,
    required this.difficulty,
    required this.start,
    required this.destination,
    required this.completedAtMs,
  });

  final int seed;
  final String fingerprint;
  final String routeDirections;
  final int routePathLength;
  final int width;
  final int height;
  final MazeDriverDifficulty difficulty;
  final MazePoint start;
  final MazePoint destination;
  final int completedAtMs;

  Map<String, dynamic> toJson() => {
        'seed': seed,
        'fingerprint': fingerprint,
        'routeDirections': routeDirections,
        'routePathLength': routePathLength,
        'width': width,
        'height': height,
        'difficulty': difficulty.id,
        'start': start.toJson(),
        'destination': destination.toJson(),
        'completedAtMs': completedAtMs,
      };

  factory MazeHistoryEntry.fromJson(Map<String, dynamic> json) =>
      MazeHistoryEntry(
        seed: json['seed'] as int,
        fingerprint: json['fingerprint'] as String,
        routeDirections: json['routeDirections'] as String,
        routePathLength: json['routePathLength'] as int,
        width: json['width'] as int,
        height: json['height'] as int,
        difficulty: MazeDriverDifficulty.fromId(json['difficulty'] as String),
        start: MazePoint.fromJson(json['start'] as Map<String, dynamic>),
        destination:
            MazePoint.fromJson(json['destination'] as Map<String, dynamic>),
        completedAtMs: json['completedAtMs'] as int,
      );
}
