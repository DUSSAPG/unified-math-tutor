import 'package:flutter/foundation.dart';

import 'panda_portions_content.dart';

/// Where the current round stands.
enum PortionRoundStatus { playing, incorrect, success }

/// What the most recent attempt was, for feedback.
enum PortionAttemptResult { correct, incorrect, ignored }

/// Panda Portions V1 — the session-only, learner-controlled progression.
///
/// The learner always decides what happens next. This class never advances
/// to another lesson on its own: only [nextLesson] and [chooseLesson] change
/// the lesson, and both are explicit learner actions. Nothing here is
/// persisted — no mastery, year-group placement, score or completion record
/// is written anywhere. Closing the screen discards the session.
class PandaPortionsSession extends ChangeNotifier {
  PandaPortionsSession({
    required PortionLessonId lesson,
    this.path = PortionPath.guided,
    int variation = 0,
  })  : _lesson = PandaPortionsContent.lesson(lesson),
        _variation = variation {
    _round = PortionRound.build(_lesson, _variation);
  }

  /// How the learner entered (only used to label the Guided Path).
  PortionPath path;

  PortionLesson _lesson;
  int _variation;
  late PortionRound _round;

  PortionRoundStatus _status = PortionRoundStatus.playing;
  String? _selectedPieceId;
  String? _fedPieceId;
  PlateSide? _chosenPlate;
  String? _rejectedPieceId;
  bool _hintVisible = false;
  int _successesInLesson = 0;

  PortionLesson get lesson => _lesson;
  PortionRound get round => _round;
  int get variation => _variation;
  PortionRoundStatus get status => _status;
  String? get selectedPieceId => _selectedPieceId;
  String? get fedPieceId => _fedPieceId;
  PlateSide? get chosenPlate => _chosenPlate;
  String? get rejectedPieceId => _rejectedPieceId;
  bool get hintVisible => _hintVisible;

  /// Successful rounds in the current lesson during this session only.
  int get successesInLesson => _successesInLesson;

  /// 1-based position in the authored sequence.
  int get sequenceStep => PandaPortionsContent.sequence.indexOf(_lesson.id) + 1;
  int get sequenceLength => PandaPortionsContent.sequence.length;

  bool get hasNextLesson => _lesson.nextLessonId != null;

  /// Feeding is open only while the round is in play or being retried.
  bool get acceptsInput => _status != PortionRoundStatus.success;

  /// The fraction of the apple left on the fair plate.
  PortionFraction get remaining => _fedPieceId == null
      ? PortionFraction(1, 1)
      : _round.remainingAfterCorrect;

  /// An optional suggestion after a success — never a promotion. "Ready for
  /// a new challenge?" only after repeated successes in this lesson.
  PortionMessage? get suggestion {
    if (_status != PortionRoundStatus.success) return null;
    if (hasNextLesson &&
        _successesInLesson >=
            PandaPortionsContent.newChallengeSuggestionAfter) {
      return PortionMessage.suggestNewChallenge;
    }
    return _lesson.successSuggestion;
  }

  // ---- Input -------------------------------------------------------------

  /// Tap-to-select a piece (tap again to deselect).
  void selectPiece(String pieceId) {
    if (!acceptsInput || _round.choosesPlate) return;
    _selectedPieceId = _selectedPieceId == pieceId ? null : pieceId;
    notifyListeners();
  }

  /// Feeds whatever piece is selected (tap Panda / bowl, or keyboard).
  PortionAttemptResult feedSelected() {
    final id = _selectedPieceId;
    if (id == null) return PortionAttemptResult.ignored;
    return feed(id);
  }

  /// Feeds [pieceId] to Panda (drag-drop or tap path). Deterministic: one
  /// part of the equally-cut apple is correct; anything else is not.
  PortionAttemptResult feed(String pieceId) {
    if (!acceptsInput || _round.choosesPlate) {
      return PortionAttemptResult.ignored;
    }
    _selectedPieceId = null;
    if (_round.isCorrectPiece(pieceId)) {
      _fedPieceId = pieceId;
      _rejectedPieceId = null;
      _status = PortionRoundStatus.success;
      _successesInLesson++;
      _hintVisible = false;
      notifyListeners();
      return PortionAttemptResult.correct;
    }
    // The piece goes back on its plate; the learner can simply try again.
    _rejectedPieceId = pieceId;
    _status = PortionRoundStatus.incorrect;
    notifyListeners();
    return PortionAttemptResult.incorrect;
  }

  /// Equal Parts lesson: choose the plate that shows a fair share.
  PortionAttemptResult choosePlate(PlateSide side) {
    if (!acceptsInput || !_round.choosesPlate) {
      return PortionAttemptResult.ignored;
    }
    _chosenPlate = side;
    if (_round.isCorrectPlate(side)) {
      _status = PortionRoundStatus.success;
      _successesInLesson++;
      _hintVisible = false;
      notifyListeners();
      return PortionAttemptResult.correct;
    }
    _status = PortionRoundStatus.incorrect;
    notifyListeners();
    return PortionAttemptResult.incorrect;
  }

  void showHint() {
    _hintVisible = true;
    notifyListeners();
  }

  void hideHint() {
    _hintVisible = false;
    notifyListeners();
  }

  // ---- Learner-chosen navigation ----------------------------------------

  /// "Reset apple": restart only the current round, same lesson, same
  /// variation.
  void reset() {
    _clearRound();
    notifyListeners();
  }

  /// "Keep practising this" / "Try another half": a new, varied round of the
  /// SAME lesson. Never advances.
  void keepPractising() {
    _variation++;
    _round = PortionRound.build(_lesson, _variation);
    _clearRound();
    notifyListeners();
  }

  /// "Next lesson": the authored sequence, only when the learner asks.
  void nextLesson() {
    final next = _lesson.nextLessonId;
    if (next == null) return;
    chooseLesson(next, path: path);
  }

  /// Direct access to any lesson — nothing is locked.
  void chooseLesson(PortionLessonId id, {PortionPath? path}) {
    if (path != null) this.path = path;
    _lesson = PandaPortionsContent.lesson(id);
    _variation = 0;
    _successesInLesson = 0;
    _round = PortionRound.build(_lesson, _variation);
    _clearRound();
    notifyListeners();
  }

  void _clearRound() {
    _status = PortionRoundStatus.playing;
    _selectedPieceId = null;
    _fedPieceId = null;
    _chosenPlate = null;
    _rejectedPieceId = null;
    _hintVisible = false;
  }
}
