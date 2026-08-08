import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'learner_profiles_service.dart';

/// The four Aircraft Landing Lab activity ids, used as [SharedPreferences]
/// key suffixes and route segments alike.
class AircraftLandingActivityId {
  static const findTheTime = 'find-the-time';
  static const followTheDescentLine = 'follow-the-descent-line';
  static const landOnTheGlidePath = 'land-on-the-glide-path';
  static const vectorApproach = 'vector-approach';

  static const all = [
    findTheTime,
    followTheDescentLine,
    landOnTheGlidePath,
    vectorApproach,
  ];
}

/// Per-activity progress for the Aircraft Landing Lab — a companion to
/// [InteractiveLabsProgressService], structurally identical to
/// `SpatialCubeLabProgressService` (needed for the same reason: this lab
/// has four distinct activities inside it that each need their own
/// completion/best-attempt/hints state, which the generic
/// per-`InteractiveLabId` service doesn't model). Everything generic
/// across labs (attempts/completions at the lab level, first-use
/// walkthrough, guidance level, narration prefs) still goes through
/// `InteractiveLabsProgressService.instance` as usual.
///
/// Same conventions as every sibling progress service: profile-scoped
/// `SharedPreferences` keys, plain counters, no adaptive engine.
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
class AircraftLandingLabProgressService {
  AircraftLandingLabProgressService._();
  static final instance = AircraftLandingLabProgressService._();

  SharedPreferences? _prefs;

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
  String _completedKey(String activityId) =>
      'aircraft_landing_completed_${_learnerKey()}_$activityId';
  String _bestAttemptsKey(String activityId) =>
      'aircraft_landing_best_attempts_${_learnerKey()}_$activityId';
  String _hintsUsedKey(String activityId) =>
      'aircraft_landing_hints_used_${_learnerKey()}_$activityId';
  String _howItWorksSeenKey(String activityId) =>
      'aircraft_landing_how_it_works_seen_${_learnerKey()}_$activityId';
  String get _lastActivityKey =>
      'aircraft_landing_last_activity_${_learnerKey()}';

  bool isCompleted(String activityId) {
    _ensureLoading();
    return _prefs?.getBool(_completedKey(activityId)) ?? false;
  }

  Future<void> markCompleted(String activityId) async {
    if (_prefs == null) await init();
    await _prefs!.setBool(_completedKey(activityId), true);
    updateSerial.value++;
  }

  /// The fewest attempts a learner has ever needed to reach a safe landing
  /// on this activity, or `null` if never yet succeeded (or loading has
  /// not finished yet). Lower is better, so a new value only overwrites
  /// the stored best when it's smaller.
  int? bestAttemptCount(String activityId) {
    _ensureLoading();
    return _prefs?.getInt(_bestAttemptsKey(activityId));
  }

  Future<void> recordAttemptCount(String activityId, int attemptsTaken) async {
    if (_prefs == null) await init();
    final current = bestAttemptCount(activityId);
    if (current == null || attemptsTaken < current) {
      await _prefs!.setInt(_bestAttemptsKey(activityId), attemptsTaken);
      updateSerial.value++;
    }
  }

  int hintsUsed(String activityId) {
    _ensureLoading();
    return _prefs?.getInt(_hintsUsedKey(activityId)) ?? 0;
  }

  Future<void> recordHintUsed(String activityId) async {
    if (_prefs == null) await init();
    await _prefs!.setInt(_hintsUsedKey(activityId), hintsUsed(activityId) + 1);
    updateSerial.value++;
  }

  bool hasSeenHowItWorks(String activityId) {
    _ensureLoading();
    return _prefs?.getBool(_howItWorksSeenKey(activityId)) ?? false;
  }

  Future<void> markHowItWorksSeen(String activityId) async {
    if (_prefs == null) await init();
    await _prefs!.setBool(_howItWorksSeenKey(activityId), true);
    updateSerial.value++;
  }

  /// The most recently opened activity id, so the hub can offer "resume
  /// where you left off." Null until the learner has opened one (or
  /// until loading has finished, whichever is later).
  String? lastActivityId() {
    _ensureLoading();
    return _prefs?.getString(_lastActivityKey);
  }

  Future<void> setLastActivityId(String activityId) async {
    if (_prefs == null) await init();
    await _prefs!.setString(_lastActivityKey, activityId);
    updateSerial.value++;
  }
}
