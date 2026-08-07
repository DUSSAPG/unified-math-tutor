import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/entrance_exam_pack.dart';
import 'learner_profiles_service.dart';

/// Learner-profile-namespaced storage for self-assessed method-mark
/// outcomes (see [MethodMarkOutcome]'s class doc — this is a self-marking
/// record, never an automatically-graded one). Mirrors
/// [RecallCardsProgressService]'s profile-scoped SharedPreferences keying
/// convention via [LearnerProfilesService].
class EntranceExamProgressService {
  EntranceExamProgressService._();
  static final instance = EntranceExamProgressService._();

  late SharedPreferences _prefs;

  /// Bumped on every write so UI can rebuild via a ValueListenableBuilder,
  /// mirroring [RecallCardsProgressService.updateSerial].
  final ValueNotifier<int> updateSerial = ValueNotifier(0);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String _learnerKey() =>
      LearnerProfilesService.instance.activeLearnerId.value ?? 'default';

  String _outcomeKey(String questionId) =>
      'entrance_exam_outcome_${_learnerKey()}_$questionId';

  MethodMarkOutcome? outcomeFor(String questionId) {
    final raw = _prefs.getString(_outcomeKey(questionId));
    if (raw == null) return null;
    try {
      return MethodMarkOutcome.fromId(raw);
    } on FormatException {
      // A stale/unrecognised value (e.g. from a downgraded app version)
      // is treated as "no outcome recorded" rather than crashing the
      // review flow.
      return null;
    }
  }

  Future<void> recordOutcome(
      String questionId, MethodMarkOutcome outcome) async {
    await _prefs.setString(_outcomeKey(questionId), outcome.name);
    updateSerial.value++;
  }

  /// Estimated mark total across [questions] from whatever outcomes have
  /// been recorded so far for the active learner — unattempted questions
  /// contribute 0, matching [MethodMarkOutcome.blank]'s fraction.
  double estimatedMarks(Iterable<({String id, int marks})> questions) {
    var total = 0.0;
    for (final q in questions) {
      final outcome = outcomeFor(q.id);
      if (outcome != null) {
        total += q.marks * outcome.marksFraction;
      }
    }
    return total;
  }
}
