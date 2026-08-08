import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/entrance_exam_pack.dart';
import 'learner_profiles_service.dart';

/// Learner-profile-namespaced storage for self-assessed method-mark
/// outcomes (see [MethodMarkOutcome]'s class doc — this is a self-marking
/// record, never an automatically-graded one). Mirrors
/// [RecallCardsProgressService]'s profile-scoped SharedPreferences keying
/// convention via [LearnerProfilesService].
///
/// [init] is called from `AppBootstrap` like every sibling progress
/// service, so `_prefs` is normally ready before any screen can reach
/// this service. The synchronous getters below defend against the case
/// where they're read before that resolves anyway (e.g. bootstrap still
/// in flight): `_prefs` is nullable rather than `late`, so a premature
/// read returns the "nothing recorded yet" default instead of throwing
/// a `LateInitializationError`, and quietly kicks off loading itself if
/// nothing has requested it yet. [SharedPreferences.getInstance] is
/// already idempotent and safely callable concurrently at the plugin
/// level (it caches its own in-flight/completed load and retries fresh
/// after a failure), so `init()` here just calls straight through to it
/// rather than adding a second, redundant caching layer — the same
/// convention `market_store.dart` already uses elsewhere in this
/// codebase.
class EntranceExamProgressService {
  EntranceExamProgressService._();
  static final instance = EntranceExamProgressService._();

  SharedPreferences? _prefs;

  /// Bumped on every write so UI can rebuild via a ValueListenableBuilder,
  /// mirroring [RecallCardsProgressService.updateSerial].
  final ValueNotifier<int> updateSerial = ValueNotifier(0);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Starts loading in the background if nothing has requested it yet.
  /// Only called from the synchronous getters below, as a defence
  /// against being read before bootstrap's own awaited [init] call has
  /// resolved. Errors are swallowed here specifically — a write method's
  /// own `await init()` (or a later getter's own retry) surfaces the
  /// same failure properly; this fire-and-forget kick must not produce
  /// an unhandled-Future-error warning.
  void _ensureLoading() {
    if (_prefs == null) init().catchError((Object _) {});
  }

  String _learnerKey() =>
      LearnerProfilesService.instance.activeLearnerId.value ?? 'default';

  String _outcomeKey(String questionId) =>
      'entrance_exam_outcome_${_learnerKey()}_$questionId';

  MethodMarkOutcome? outcomeFor(String questionId) {
    _ensureLoading();
    final raw = _prefs?.getString(_outcomeKey(questionId));
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
    if (_prefs == null) await init();
    await _prefs!.setString(_outcomeKey(questionId), outcome.name);
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
