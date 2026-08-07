import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/maze_history_entry.dart';
import 'learner_profiles_service.dart';

/// Learner-profile-namespaced local history of recently completed
/// procedural Maze Driver mazes, used by [MazeGeneratorService]'s novelty
/// policy to avoid repeating or near-repeating recent layouts. Mirrors
/// [MazeDriverBestResultService]'s exact persistence idiom (profile-scoped
/// SharedPreferences key, JSON-encoded value) — a separate service rather
/// than folded into that one, since a single best-result-per-curated-level
/// slot is the wrong shape for a bounded list of procedural attempts
/// keyed by seed/fingerprint/route instead of a stable levelId.
class MazeDriverHistoryService {
  MazeDriverHistoryService._();
  static final instance = MazeDriverHistoryService._();

  /// Oldest entries beyond this count are trimmed on insert, bounding
  /// storage growth while still giving the novelty policy a meaningful
  /// recent window to compare against.
  static const historyWindowSize = 20;

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String _learnerKey() =>
      LearnerProfilesService.instance.activeLearnerId.value ?? 'default';

  String get _key => 'maze_driver_history_${_learnerKey()}';

  List<MazeHistoryEntry> recent() {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return [
        for (final item in decoded)
          MazeHistoryEntry.fromJson(item as Map<String, dynamic>),
      ];
    } catch (_) {
      return const [];
    }
  }

  Future<void> record(MazeHistoryEntry entry) async {
    final updated = [...recent(), entry];
    final trimmed = updated.length > historyWindowSize
        ? updated.sublist(updated.length - historyWindowSize)
        : updated;
    await _prefs.setString(
      _key,
      jsonEncode([for (final item in trimmed) item.toJson()]),
    );
  }
}
