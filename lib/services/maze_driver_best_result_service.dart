import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'learner_profiles_service.dart';

class MazeDriverBestResult {
  const MazeDriverBestResult({
    required this.moves,
    required this.elapsedMs,
  });

  final int moves;
  final int elapsedMs;

  Map<String, dynamic> toJson() => {
        'moves': moves,
        'elapsedMs': elapsedMs,
      };

  factory MazeDriverBestResult.fromJson(Map<String, dynamic> json) =>
      MazeDriverBestResult(
        moves: json['moves'] as int,
        elapsedMs: json['elapsedMs'] as int,
      );

  bool isBetterThan(MazeDriverBestResult? other) {
    if (other == null) return true;
    if (moves != other.moves) return moves < other.moves;
    return elapsedMs < other.elapsedMs;
  }
}

class MazeDriverBestResultService {
  MazeDriverBestResultService._();
  static final instance = MazeDriverBestResultService._();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String _learnerKey() =>
      LearnerProfilesService.instance.activeLearnerId.value ?? 'default';

  String _key(String levelId) => 'maze_driver_best_${_learnerKey()}_$levelId';

  MazeDriverBestResult? bestFor(String levelId) {
    final raw = _prefs.getString(_key(levelId));
    if (raw == null || raw.isEmpty) return null;
    try {
      return MazeDriverBestResult.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  Future<bool> record(String levelId, MazeDriverBestResult result) async {
    final current = bestFor(levelId);
    if (!result.isBetterThan(current)) return false;
    await _prefs.setString(_key(levelId), jsonEncode(result.toJson()));
    return true;
  }
}
