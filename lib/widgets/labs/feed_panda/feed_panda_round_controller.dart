import 'package:flutter/foundation.dart';

import '../../../models/feed_panda_challenge.dart';
import '../../../models/feed_panda_event.dart';
import '../../../models/panda_visual_state.dart';

/// Where a round currently is. Presentation widgets branch on this rather
/// than re-deriving it from raw counts, so the state machine lives in one
/// place.
enum FeedPandaPhase {
  /// Instruction shown, no fruit accepted yet.
  instruction,

  /// Feeding is active; more fruit can still be accepted.
  feeding,

  /// The target was just reached; input is locked for a brief,
  /// Reduce-Motion-aware transition before the follow-up question appears.
  chewTransition,

  /// "How many apples are left?" is being asked.
  askRemaining,

  /// The round is complete.
  roundComplete,
}

/// The round-state controller for Feed the Hungry Panda. Pure Dart,
/// `ChangeNotifier`-based (Flutter's built-in observable — no new
/// state-management package) — fully testable without pumping a widget
/// tree. Owns: which fruit have been accepted, the current phase, Panda's
/// derived visual state, and emits [FeedPandaEvent]s via [onEvent] for the
/// progress/analytics seam. Never constructs its own [FeedPandaChallenge]
/// with an unseeded `Random()` — challenge generation is entirely
/// delegated to [FeedPandaChallenge.forSeed].
class FeedPandaRoundController extends ChangeNotifier {
  FeedPandaRoundController({
    required int initialSeed,
    this.onEvent,
    this.reduceMotion = false,
    @visibleForTesting this.chewTransitionDelay,
  }) : _seed = initialSeed {
    _loadChallenge(initial: true);
  }

  /// Called for every learning-evidence event this round produces. Kept as
  /// a plain callback (not a Stream/generic event bus — there is no such
  /// seam anywhere else in the app) so [FeedTheHungryPandaProgressService]
  /// can be wired in by the owning screen without this controller knowing
  /// persistence exists.
  final void Function(FeedPandaEvent event)? onEvent;

  /// Whether the owning screen has Reduce Motion active. Affects only the
  /// chew-transition delay (removing the "brief pause" feel, not the
  /// state machine itself) — the actual animation-vs-static-state choice
  /// is a presentation-widget concern, not this controller's.
  bool reduceMotion;

  /// Test-only override for the chew-transition delay, so widget/unit
  /// tests don't need to wait out the real duration.
  @visibleForTesting
  final Duration? chewTransitionDelay;

  int _seed;
  int get seed => _seed;

  late FeedPandaChallenge _challenge;
  FeedPandaChallenge get challenge => _challenge;

  final Set<String> _acceptedFruitIds = <String>{};
  Set<String> get acceptedFruitIds => Set.unmodifiable(_acceptedFruitIds);
  int get acceptedCount => _acceptedFruitIds.length;

  String? _selectedFruitId;
  String? get selectedFruitId => _selectedFruitId;

  FeedPandaPhase _phase = FeedPandaPhase.instruction;
  FeedPandaPhase get phase => _phase;

  int _dropAttempts = 0;
  int get dropAttempts => _dropAttempts;

  int _remainingAnswerAttempts = 0;
  int get remainingAnswerAttempts => _remainingAnswerAttempts;

  /// A one-shot, self-clearing nudge shown after an overfeed attempt. Not
  /// a countdown or a punitive state — just a brief acknowledgement that
  /// clears on its own or on the next interaction.
  bool _gentleReminderActive = false;
  bool get gentleReminderActive => _gentleReminderActive;

  /// Whether the target count has been reached for this round.
  bool get targetReached => acceptedCount >= _challenge.targetCount;

  /// Fruit can currently be accepted: not locked, still feeding, the id
  /// belongs to this round, hasn't already been accepted, and the target
  /// hasn't already been reached.
  bool canAccept(String fruitId) {
    return _phase == FeedPandaPhase.feeding &&
        _challenge.fruitIds.contains(fruitId) &&
        !_acceptedFruitIds.contains(fruitId) &&
        acceptedCount < _challenge.targetCount;
  }

  /// True while input must be ignored — the brief chew transition.
  bool get inputLocked => _phase == FeedPandaPhase.chewTransition;

  PandaVisualState get pandaState {
    if (_gentleReminderActive) return PandaVisualState.gentleReminder;
    return switch (_phase) {
      FeedPandaPhase.instruction => PandaVisualState.waiting,
      FeedPandaPhase.feeding => PandaVisualState.ready,
      FeedPandaPhase.chewTransition => PandaVisualState.chewing,
      FeedPandaPhase.askRemaining => PandaVisualState.ready,
      FeedPandaPhase.roundComplete => PandaVisualState.happy,
    };
  }

  void _emit(FeedPandaEventType type,
      {bool? usedDrag, bool? completionStatus}) {
    onEvent?.call(FeedPandaEvent(
      type: type,
      timestamp: DateTime.now(),
      seed: _seed,
      targetAmount: _challenge.targetCount,
      acceptedCount: acceptedCount,
      attempts: _dropAttempts,
      usedDrag: usedDrag,
      remainingAnswerAttempts:
          type == FeedPandaEventType.remainingAnswerCorrect ||
                  type == FeedPandaEventType.remainingAnswerRetry
              ? _remainingAnswerAttempts
              : null,
      completionStatus: completionStatus,
    ));
  }

  void _loadChallenge({bool initial = false}) {
    _challenge = FeedPandaChallenge.forSeed(_seed);
    _acceptedFruitIds.clear();
    _selectedFruitId = null;
    _phase = FeedPandaPhase.instruction;
    _dropAttempts = 0;
    _remainingAnswerAttempts = 0;
    _gentleReminderActive = false;
    _emit(FeedPandaEventType.activityStarted);
    if (!initial) notifyListeners();
  }

  /// Moves from the instruction phase into active feeding. Idempotent —
  /// safe to call more than once (e.g. after "Replay instruction").
  void beginFeeding() {
    if (_phase != FeedPandaPhase.instruction) return;
    _phase = FeedPandaPhase.feeding;
    notifyListeners();
  }

  /// Tap-to-select path: marks [fruitId] as selected so a subsequent tap
  /// on Panda accepts it — the equivalent-path alternative to dragging.
  void selectFruit(String fruitId) {
    if (inputLocked) return;
    if (!_challenge.fruitIds.contains(fruitId)) return;
    if (_acceptedFruitIds.contains(fruitId)) return;
    _gentleReminderActive = false;
    _selectedFruitId = _selectedFruitId == fruitId ? null : fruitId;
    if (_selectedFruitId != null) {
      _emit(FeedPandaEventType.fruitSelected);
    }
    notifyListeners();
  }

  /// Accepts [fruitId] into Panda — reached either by a successful drag
  /// drop onto Panda, or a tap on Panda while [fruitId] is selected.
  /// [usedDrag] records which input mode produced this acceptance, for the
  /// learning-evidence log.
  void acceptFruit(String fruitId, {required bool usedDrag}) {
    _dropAttempts++;
    if (!canAccept(fruitId)) {
      if (targetReached) _showGentleReminder();
      return;
    }
    _acceptedFruitIds.add(fruitId);
    _selectedFruitId = null;
    _gentleReminderActive = false;
    _emit(FeedPandaEventType.correctFruitAccepted, usedDrag: usedDrag);
    if (targetReached) {
      _beginChewTransition();
    } else {
      notifyListeners();
    }
  }

  /// A drag ended outside Panda's target area — the fruit already returns
  /// to its source position visually (the drag widget's own snap-back);
  /// this just records the attempt and clears any stale selection.
  void rejectDrop() {
    _dropAttempts++;
    _emit(FeedPandaEventType.dropReturned);
    notifyListeners();
  }

  /// Attempted a drop/tap-accept after the target was already reached.
  /// Called by the presentation layer when it detects that case directly
  /// (e.g. a drag onto Panda that [canAccept] would reject) so the gentle
  /// reminder shows even without going through [acceptFruit].
  void notifyOverfeedAttempt() {
    _dropAttempts++;
    _showGentleReminder();
  }

  void _showGentleReminder() {
    _gentleReminderActive = true;
    notifyListeners();
  }

  /// Clears the gentle reminder — call after the brief on-screen
  /// acknowledgement window closes. Presentation-driven (not a countdown
  /// the controller runs itself) so tests can assert the reminder appears
  /// without waiting on a timer, and the widget controls its own pacing.
  void clearGentleReminder() {
    if (!_gentleReminderActive) return;
    _gentleReminderActive = false;
    notifyListeners();
  }

  void _beginChewTransition() {
    _phase = FeedPandaPhase.chewTransition;
    _emit(FeedPandaEventType.targetReached);
    notifyListeners();
    final delay = chewTransitionDelay ??
        (reduceMotion
            ? const Duration(milliseconds: 50)
            : const Duration(milliseconds: 700));
    Future.delayed(delay, () {
      if (_phase != FeedPandaPhase.chewTransition) return;
      _phase = FeedPandaPhase.askRemaining;
      notifyListeners();
    });
  }

  /// Submits [value] as the answer to "how many apples are left?". Wrong
  /// answers stay in [FeedPandaPhase.askRemaining] for a gentle retry —
  /// there is no penalty and no attempt limit.
  void answerRemaining(int value) {
    if (_phase != FeedPandaPhase.askRemaining) return;
    _remainingAnswerAttempts++;
    if (value == _challenge.correctRemainingAnswer) {
      _phase = FeedPandaPhase.roundComplete;
      _emit(FeedPandaEventType.remainingAnswerCorrect);
      _emit(FeedPandaEventType.roundCompleted, completionStatus: true);
    } else {
      _emit(FeedPandaEventType.remainingAnswerRetry);
    }
    notifyListeners();
  }

  /// Rebuilds the exact same challenge from the current seed — used by
  /// "Replay instruction" style restarts where the round itself should
  /// stay identical.
  void restartSameChallenge() {
    _emit(FeedPandaEventType.roundRestarted, completionStatus: false);
    _loadChallenge();
  }

  /// Advances to a new, deterministic next seed and loads that challenge —
  /// used by "New Round".
  void newRound() {
    _seed = nextSeed(_seed);
    _loadChallenge();
  }

  /// The deterministic seed sequence "New Round" advances through. A pure
  /// function so tests (and any future "jump ahead" tooling) can predict
  /// it without constructing a controller.
  static int nextSeed(int seed) => seed + 1;
}
