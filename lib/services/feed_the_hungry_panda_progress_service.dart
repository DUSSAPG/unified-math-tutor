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
class FeedTheHungryPandaProgressService {
  FeedTheHungryPandaProgressService._();
  static final instance = FeedTheHungryPandaProgressService._();

  late SharedPreferences _prefs;

  final ValueNotifier<int> updateSerial = ValueNotifier(0);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
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
  int roundsCompleted() => _prefs.getInt(_roundsCompletedKey) ?? 0;

  /// The generator seed the learner last played, so a future "resume"
  /// affordance could reopen the same round. Null until a round has run.
  int? lastSeed() => _prefs.getInt(_lastSeedKey);

  Future<void> setLastSeed(int seed) async {
    await _prefs.setInt(_lastSeedKey, seed);
    updateSerial.value++;
  }

  /// How many times an event of [type] has been recorded, across all
  /// rounds, for this learner.
  int eventCount(FeedPandaEventType type) =>
      _prefs.getInt(_eventCountKey(type)) ?? 0;

  int? lastTargetAmount() => _prefs.getInt(_lastTargetAmountKey);
  int? lastAcceptedCount() => _prefs.getInt(_lastAcceptedCountKey);
  int? lastAttempts() => _prefs.getInt(_lastAttemptsKey);
  int? lastRemainingAnswerAttempts() =>
      _prefs.getInt(_lastRemainingAnswerAttemptsKey);

  /// Records one [FeedPandaEvent]: always bumps that event type's count,
  /// and for [FeedPandaEventType.roundCompleted] also snapshots the
  /// learning-evidence fields the brief asks for (target amount, accepted
  /// count, attempts, remaining-answer attempts) and increments the
  /// completed-rounds counter.
  Future<void> recordEvent(FeedPandaEvent event) async {
    await _prefs.setInt(_eventCountKey(event.type), eventCount(event.type) + 1);
    if (event.seed != null) {
      await _prefs.setInt(_lastSeedKey, event.seed!);
    }

    if (event.type == FeedPandaEventType.roundCompleted &&
        event.completionStatus == true) {
      await _prefs.setInt(_roundsCompletedKey, roundsCompleted() + 1);
      if (event.targetAmount != null) {
        await _prefs.setInt(_lastTargetAmountKey, event.targetAmount!);
      }
      if (event.acceptedCount != null) {
        await _prefs.setInt(_lastAcceptedCountKey, event.acceptedCount!);
      }
      if (event.attempts != null) {
        await _prefs.setInt(_lastAttemptsKey, event.attempts!);
      }
      if (event.remainingAnswerAttempts != null) {
        await _prefs.setInt(
            _lastRemainingAnswerAttemptsKey, event.remainingAnswerAttempts!);
      }
    }

    updateSerial.value++;
  }
}
