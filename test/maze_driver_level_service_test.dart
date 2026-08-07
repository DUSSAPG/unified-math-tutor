import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/services/maze_driver_level_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads five valid deterministic Maze Driver level assets', () async {
    final levels = await MazeDriverLevelService.instance.loadLevels();

    expect(levels, hasLength(5));
    expect(levels.map((level) => level.levelId).toSet(), hasLength(5));
    for (final level in levels) {
      expect(level.shortestPath(), isNotNull);
      expect(level.moveTarget, greaterThan(0));
      expect(level.timeTargetSeconds, greaterThan(0));
      expect(level.missionLabel, isNotEmpty);
    }
  });

  test('level collision grid blocks walls and allows start/destination',
      () async {
    final level = (await MazeDriverLevelService.instance.loadLevels()).first;

    expect(level.canEnter(level.start), isTrue);
    expect(level.canEnter(level.destination), isTrue);
    expect(level.canEnter(level.walls.first), isFalse);
  });

  test('level targets are reachable within authored route expectations',
      () async {
    final levels = await MazeDriverLevelService.instance.loadLevels();

    for (final level in levels) {
      final path = level.shortestPath()!;
      expect(path.length - 1, lessThanOrEqualTo(level.moveTarget));
      expect(level.timeTargetSeconds, greaterThanOrEqualTo(30));
    }
  });
}
