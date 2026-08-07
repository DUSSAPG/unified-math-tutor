import 'dart:collection';

enum MazeDriverDifficulty {
  guided('guided', 'Guided'),
  explorer('explorer', 'Explorer'),
  precision('precision', 'Precision');

  const MazeDriverDifficulty(this.id, this.label);

  final String id;
  final String label;

  static MazeDriverDifficulty fromId(String id) {
    return MazeDriverDifficulty.values.firstWhere(
      (difficulty) => difficulty.id == id,
      orElse: () => MazeDriverDifficulty.guided,
    );
  }
}

class MazePoint {
  const MazePoint(this.x, this.y);

  final int x;
  final int y;

  MazePoint operator +(MazePoint other) => MazePoint(x + other.x, y + other.y);

  Map<String, dynamic> toJson() => {'x': x, 'y': y};

  factory MazePoint.fromJson(Map<String, dynamic> json) =>
      MazePoint(json['x'] as int, json['y'] as int);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MazePoint && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);
}

class MazeDriverLevel {
  const MazeDriverLevel({
    required this.levelId,
    required this.width,
    required this.height,
    required this.start,
    required this.destination,
    required this.walls,
    required this.moveTarget,
    required this.timeTargetSeconds,
    required this.missionLabel,
    required this.difficulty,
  });

  final String levelId;
  final int width;
  final int height;
  final MazePoint start;
  final MazePoint destination;
  final Set<MazePoint> walls;
  final int moveTarget;
  final int timeTargetSeconds;
  final String missionLabel;
  final MazeDriverDifficulty difficulty;

  factory MazeDriverLevel.fromJson(Map<String, dynamic> json) =>
      MazeDriverLevel(
        levelId: json['levelId'] as String,
        width: json['width'] as int,
        height: json['height'] as int,
        start: MazePoint.fromJson(json['start'] as Map<String, dynamic>),
        destination:
            MazePoint.fromJson(json['destination'] as Map<String, dynamic>),
        walls: {
          for (final wall in json['walls'] as List<dynamic>)
            MazePoint.fromJson(wall as Map<String, dynamic>),
        },
        moveTarget: json['moveTarget'] as int,
        timeTargetSeconds: json['timeTargetSeconds'] as int,
        missionLabel: json['missionLabel'] as String,
        difficulty: MazeDriverDifficulty.fromId(json['difficulty'] as String),
      );

  bool canEnter(MazePoint point) {
    if (point.x < 0 || point.y < 0 || point.x >= width || point.y >= height) {
      return false;
    }
    return !walls.contains(point);
  }

  List<MazePoint>? shortestPath() {
    if (!canEnter(start) || !canEnter(destination)) return null;
    const directions = [
      MazePoint(0, -1),
      MazePoint(1, 0),
      MazePoint(0, 1),
      MazePoint(-1, 0),
    ];
    final queue = Queue<MazePoint>()..add(start);
    final previous = <MazePoint, MazePoint?>{start: null};
    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      if (current == destination) break;
      for (final direction in directions) {
        final next = current + direction;
        if (!canEnter(next) || previous.containsKey(next)) continue;
        previous[next] = current;
        queue.add(next);
      }
    }
    if (!previous.containsKey(destination)) return null;
    final path = <MazePoint>[];
    MazePoint? cursor = destination;
    while (cursor != null) {
      path.add(cursor);
      cursor = previous[cursor];
    }
    return path.reversed.toList(growable: false);
  }

  void validate() {
    if (levelId.trim().isEmpty) throw FormatException('Missing levelId.');
    if (width < 5 || height < 5 || width > 11 || height > 11) {
      throw FormatException('Maze $levelId has unsafe dimensions.');
    }
    if (!canEnter(start) || !canEnter(destination)) {
      throw FormatException('Maze $levelId has blocked start/destination.');
    }
    if (start == destination) {
      throw FormatException('Maze $levelId start equals destination.');
    }
    for (final wall in walls) {
      if (wall.x < 0 || wall.y < 0 || wall.x >= width || wall.y >= height) {
        throw FormatException('Maze $levelId has out-of-bounds wall.');
      }
    }
    if (shortestPath() == null) {
      throw FormatException('Maze $levelId is not solvable.');
    }
    if (moveTarget < 1 || timeTargetSeconds < 1) {
      throw FormatException('Maze $levelId has invalid targets.');
    }
  }
}
