import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/feed_panda_event.dart';
import 'learner_profiles_service.dart';

/// Local (non-network) progress/learning-evidence storage for Feed the
/// Hungry Panda. Same conventions as every sibling progress service
/// (`SpatialCubeLabProgressService`, `RecallCardsProgressService`):
/// profile-scoped `SharedPreferences` keys via [LearnerProfilesService],
/// plain counters, a [ValueNotifier] bumped on every write, no adaptive
/// engine, no network calls.
///
/// This is the progress-event seam the round controller's `onEvent`
/// callback feeds into — the controller has no persistence knowledge of
/// its own; the owning screen wires `FeedPandaRoundController(onEvent:
/// FeedTheHungryPandaProgressService.instance.recordEvent)`.
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
class FeedTheHungryPandaProgressService {
  FeedTheHungryPandaProgressService._();
  static final instance = FeedTheHungryPandaProgressService._();

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

  String get _roundsCompletedKey =>
      'feed_panda_rounds_completed_${_learnerKey()}';
  String get _lastSeedKey => 'feed_panda_last_seed_${_learnerKey()}';
  String _eventCountKey(FeedPandaEventType type) =>
      'feed_panda_event_count_${_learnerKey()}_${type.name}';
  String get _lastTargetAmountKey => 'feed_panda_last_target_${_learnerKey()}';
  String get _lastAcceptedCountKey =>
      'feed_panda_last_accepted_${_learnerKey()}';
  String get _lastAttemptsKey => 'feed_panda_last_attempts_${_learnerKey()}';
  String get _lastRemainingAnswerAttemptsKey =>
      'feed_panda_last_remaining_attempts_${_learnerKey()}';

  /// How many rounds this learner has completed (correct remaining-answer
  /// reached).
  int roundsCompleted() {
    _ensureLoading();
    return _prefs?.getInt(_roundsCompletedKey) ?? 0;
  }

  /// The generator seed the learner last played, so a future "resume"
  /// affordance could reopen the same round. Null until a round has run
  /// (or until loading finishes, whichever is later).
  int? lastSeed() {
    _ensureLoading();
    return _prefs?.getInt(_lastSeedKey);
  }

  Future<void> setLastSeed(int seed) async {
    if (_prefs == null) await init();
    await _prefs!.setInt(_lastSeedKey, seed);
    updateSerial.value++;
  }

  /// How many times an event of [type] has been recorded, across all
  /// rounds, for this learner.
  int eventCount(FeedPandaEventType type) {
    _ensureLoading();
    return _prefs?.getInt(_eventCountKey(type)) ?? 0;
  }

  int? lastTargetAmount() {
    _ensureLoading();
    return _prefs?.getInt(_lastTargetAmountKey);
  }

  int? lastAcceptedCount() {
    _ensureLoading();
    return _prefs?.getInt(_lastAcceptedCountKey);
  }

  int? lastAttempts() {
    _ensureLoading();
    return _prefs?.getInt(_lastAttemptsKey);
  }

  int? lastRemainingAnswerAttempts() {
    _ensureLoading();
    return _prefs?.getInt(_lastRemainingAnswerAttemptsKey);
  }

  /// Records one [FeedPandaEvent]: always bumps that event type's count,
  /// and for [FeedPandaEventType.roundCompleted] also snapshots the
  /// learning-evidence fields the brief asks for (target amount, accepted
  /// count, attempts, remaining-answer attempts) and increments the
  /// completed-rounds counter.
  Future<void> recordEvent(FeedPandaEvent event) async {
    if (_prefs == null) await init();
    final prefs = _prefs!;
    await prefs.setInt(_eventCountKey(event.type), eventCount(event.type) + 1);
    if (event.seed != null) {
      await prefs.setInt(_lastSeedKey, event.seed!);
    }

    if (event.type == FeedPandaEventType.roundCompleted &&
        event.completionStatus == true) {
      await prefs.setInt(_roundsCompletedKey, roundsCompleted() + 1);
      if (event.targetAmount != null) {
        await prefs.setInt(_lastTargetAmountKey, event.targetAmount!);
      }
      if (event.acceptedCount != null) {
        await prefs.setInt(_lastAcceptedCountKey, event.acceptedCount!);
      }
      if (event.attempts != null) {
        await prefs.setInt(_lastAttemptsKey, event.attempts!);
      }
      if (event.remainingAnswerAttempts != null) {
        await prefs.setInt(
            _lastRemainingAnswerAttemptsKey, event.remainingAnswerAttempts!);
      }
    }

    updateSerial.value++;
  }
}
