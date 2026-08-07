/// Local (non-network) learning-event types for Feed the Hungry Panda.
/// Mirrors the app's established convention of no generic event bus —
/// events are still typed and structured, just consumed directly by
/// [FeedTheHungryPandaProgressService] rather than a network pipeline.
enum FeedPandaEventType {
  activityStarted,
  fruitSelected,
  correctFruitAccepted,
  dropReturned,
  targetReached,
  remainingAnswerCorrect,
  remainingAnswerRetry,
  roundCompleted,
  roundRestarted,
}

/// One captured learning-evidence record. Every field beyond [type] and
/// [timestamp] is nullable/defaulted because not every event type carries
/// every field (e.g. [FeedPandaEventType.fruitSelected] has no
/// [remainingAnswerAttempts] yet).
class FeedPandaEvent {
  const FeedPandaEvent({
    required this.type,
    required this.timestamp,
    this.seed,
    this.targetAmount,
    this.acceptedCount,
    this.attempts,
    this.usedDrag,
    this.remainingAnswerAttempts,
    this.completionStatus,
  });

  final FeedPandaEventType type;
  final DateTime timestamp;

  /// The round's generator seed, for correlating events to a specific
  /// reproducible challenge.
  final int? seed;

  /// The round's target fruit count.
  final int? targetAmount;

  /// How many fruit had been accepted at the time of this event.
  final int? acceptedCount;

  /// Attempt count relevant to this event (e.g. how many drop/accept
  /// attempts have happened this round).
  final int? attempts;

  /// Whether the action behind this event was performed via drag (`true`)
  /// or tap-to-select-then-tap-Panda (`false`) — captured per the brief's
  /// "whether drag or tap mode was used" learning-evidence requirement.
  final bool? usedDrag;

  /// How many attempts have been made at the "how many are left?"
  /// question so far, inclusive of the attempt this event represents.
  final int? remainingAnswerAttempts;

  /// Whether the round finished successfully, for
  /// [FeedPandaEventType.roundCompleted]/[FeedPandaEventType.roundRestarted].
  final bool? completionStatus;
}
