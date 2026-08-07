import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/maze_driver_level.dart';

class MazeDriverLevelService {
  MazeDriverLevelService._();
  static final instance = MazeDriverLevelService._();

  static const levelAssetPaths = [
    'assets/ldtk/maze_driver_delivery_01.json',
    'assets/ldtk/maze_driver_delivery_02.json',
    'assets/ldtk/maze_driver_delivery_03.json',
    'assets/ldtk/maze_driver_delivery_04.json',
    'assets/ldtk/maze_driver_delivery_05.json',
  ];

  Future<List<MazeDriverLevel>> loadLevels() async {
    final levels = <MazeDriverLevel>[];
    for (final path in levelAssetPaths) {
      final decoded =
          jsonDecode(await rootBundle.loadString(path)) as Map<String, dynamic>;
      final level = MazeDriverLevel.fromJson(decoded)..validate();
      levels.add(level);
    }
    final ids = levels.map((level) => level.levelId).toSet();
    if (ids.length != levels.length) {
      throw const FormatException('Maze Driver level IDs must be unique.');
    }
    return levels;
  }
}
