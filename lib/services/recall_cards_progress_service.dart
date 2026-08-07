import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/recall_card.dart';
import '../models/recall_card_state.dart';
import 'learner_profiles_service.dart';

/// Learner-profile-namespaced spaced-review tracking for Recall Cards.
///
/// Extends [MentalMathsProgressService]'s exact pattern rather than
/// introducing a new scheduler: same profile-scoped SharedPreferences keying
/// via [LearnerProfilesService], the same simple-threshold-rules philosophy
/// (a small SM-2-style ease factor, not a heavyweight adaptive engine), and
/// the same "recently shown" anti-repetition list. See
/// [RecallCardSelector] for the pure deterministic selection logic that
/// consumes this service's state.
class RecallCardsProgressService {
  RecallCardsProgressService._();
  static final instance = RecallCardsProgressService._();

  static const _recentSize = 20;
  static const _defaultEaseFactor = 2.5;
  static const _minEaseFactor = 1.3;
  static const _maxEaseFactor = 3.0;

  /// A card is promoted from "learning" to "mastered" once its interval
  /// reaches this many days. Simple RC1 threshold, not a curve fit.
  static const _masteryIntervalDays = 21;

  late SharedPreferences _prefs;

  /// Bumped on every write so UI can rebuild via a ValueListenableBuilder,
  /// mirroring [MentalMathsProgressService.updateSerial].
  final ValueNotifier<int> updateSerial = ValueNotifier(0);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String _learnerKey() =>
      LearnerProfilesService.instance.activeLearnerId.value ?? 'default';
  String _stageKey(String cardId) => 'recall_stage_${_learnerKey()}_$cardId';
  String _easeKey(String cardId) => 'recall_ease_${_learnerKey()}_$cardId';
  String _reviewCountKey(String cardId) =>
      'recall_reviewcount_${_learnerKey()}_$cardId';
  String _lastReviewedKey(String cardId) =>
      'recall_lastreviewed_${_learnerKey()}_$cardId';
  String _nextReviewKey(String cardId) =>
      'recall_nextreview_${_learnerKey()}_$cardId';
  String _misconceptionKey(String cardId) =>
      'recall_misconception_${_learnerKey()}_$cardId';
  String _revealBeforeAnswerKey(String cardId) =>
      'recall_revealbeforeanswer_${_learnerKey()}_$cardId';
  String _linkedPracticeKey(String cardId) =>
      'recall_linkedpractice_${_learnerKey()}_$cardId';
  String _linkedLabKey(String cardId) =>
      'recall_linkedlab_${_learnerKey()}_$cardId';
  String get _bookmarksKey => 'recall_bookmarks_${_learnerKey()}';
  String get _recentKey => 'recall_recent_${_learnerKey()}';

  // ── Raw per-card fields ──────────────────────────────────────────────────

  String _stageId(String cardId) =>
      _prefs.getString(_stageKey(cardId)) ?? 'new';

  double easeFactorFor(String cardId) =>
      double.tryParse(_prefs.getString(_easeKey(cardId)) ?? '') ??
      _defaultEaseFactor;

  int reviewCountFor(String cardId) =>
      _prefs.getInt(_reviewCountKey(cardId)) ?? 0;

  DateTime? lastReviewedFor(String cardId) {
    final raw = _prefs.getString(_lastReviewedKey(cardId));
    return raw == null ? null : DateTime.tryParse(raw);
  }

  DateTime? nextReviewFor(String cardId) {
    final raw = _prefs.getString(_nextReviewKey(cardId));
    return raw == null ? null : DateTime.tryParse(raw);
  }

  bool misconceptionFlagFor(String cardId) =>
      _prefs.getBool(_misconceptionKey(cardId)) ?? false;

  int revealBeforeAnswerCountFor(String cardId) =>
      _prefs.getInt(_revealBeforeAnswerKey(cardId)) ?? 0;

  int linkedPracticeUseCountFor(String cardId) =>
      _prefs.getInt(_linkedPracticeKey(cardId)) ?? 0;

  int linkedInteractiveLabUseCountFor(String cardId) =>
      _prefs.getInt(_linkedLabKey(cardId)) ?? 0;

  /// Effective scheduler state: "new" and "mastered"/"learning" reflect the
  /// underlying stage, but any scheduled card whose [nextReviewFor] has
  /// elapsed is surfaced as [RecallCardState.reviewDue] regardless of stage —
  /// this is the one derived/computed state, matching the product's
  /// new/learning/review_due/mastered contract exactly.
  RecallCardState stateFor(String cardId, {DateTime? now}) {
    final stage = _stageId(cardId);
    if (stage == 'new') return RecallCardState.newCard;
    final due = nextReviewFor(cardId);
    if (due != null && !due.isAfter(now ?? DateTime.now())) {
      return RecallCardState.reviewDue;
    }
    return RecallCardState.fromId(stage);
  }

  // ── Bookmarks ────────────────────────────────────────────────────────────

  Set<String> bookmarkedIds() =>
      (_prefs.getStringList(_bookmarksKey) ?? const []).toSet();

  bool isBookmarked(String cardId) => bookmarkedIds().contains(cardId);

  Future<void> setBookmarked(String cardId, bool bookmarked) async {
    final ids = bookmarkedIds();
    if (bookmarked) {
      ids.add(cardId);
    } else {
      ids.remove(cardId);
    }
    await _prefs.setStringList(_bookmarksKey, ids.toList());
    updateSerial.value++;
  }

  // ── Anti-repetition ("recently shown") ──────────────────────────────────

  List<String> recentlyShown() => _prefs.getStringList(_recentKey) ?? const [];

  Future<void> recordShown(String cardId) async {
    final recent = <String>[...?_prefs.getStringList(_recentKey), cardId];
    if (recent.length > _recentSize) {
      recent.removeAt(0);
    }
    await _prefs.setStringList(_recentKey, recent);
    updateSerial.value++;
  }

  /// "Ask Me Tomorrow": defers this card without recording a
  /// remembered/not-yet result. Adds it to the recently-shown anti-repetition
  /// list (so Quick Review/Review Due deprioritise it today) and, if it
  /// already has a due date, pushes that date to at least tomorrow.
  Future<void> askMeTomorrow(String cardId) async {
    await recordShown(cardId);
    final due = nextReviewFor(cardId);
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    if (due == null || !due.isAfter(DateTime.now())) {
      await _prefs.setString(
          _nextReviewKey(cardId), tomorrow.toIso8601String());
    }
    updateSerial.value++;
  }

  // ── Recording an attempt ─────────────────────────────────────────────────

  /// Records one review attempt. `remembered` is the learner's own
  /// self-assessment (Recall Cards never auto-grades free text); `revealed`
  /// is true when the learner tapped Reveal before self-assessing, which is
  /// tracked but does not change the schedule. `card` supplies `cardType` so
  /// a misconception card's flag can be set/cleared, and
  /// `spacedReviewEligible` so ineligible cards never enter the rotation.
  Future<void> recordAttempt(
    RecallCard card, {
    required bool remembered,
    required bool revealedBeforeAnswer,
  }) async {
    final cardId = card.id;
    final now = DateTime.now();
    final prevLastReviewed = lastReviewedFor(cardId);
    final prevNextReview = nextReviewFor(cardId);
    final prevIntervalDays =
        (prevLastReviewed != null && prevNextReview != null)
            ? prevNextReview.difference(prevLastReviewed).inDays.clamp(1, 3650)
            : 1;
    final stage = _stageId(cardId);
    var ease = easeFactorFor(cardId);
    final reviewCount = reviewCountFor(cardId);

    String nextStage;
    int intervalDays;
    if (remembered) {
      ease = (ease + 0.1).clamp(_minEaseFactor, _maxEaseFactor);
      if (stage == 'new') {
        nextStage = 'learning';
        intervalDays = 1;
      } else {
        intervalDays = (prevIntervalDays * ease).round().clamp(1, 3650);
        nextStage =
            intervalDays >= _masteryIntervalDays ? 'mastered' : 'learning';
      }
      if (card.cardType.name == 'misconception') {
        await _prefs.setBool(_misconceptionKey(cardId), false);
      }
    } else {
      ease = (ease - 0.2).clamp(_minEaseFactor, _maxEaseFactor);
      nextStage = 'learning';
      intervalDays = 1;
      if (card.cardType.name == 'misconception') {
        await _prefs.setBool(_misconceptionKey(cardId), true);
      }
    }

    await _prefs.setString(_stageKey(cardId), nextStage);
    await _prefs.setString(_easeKey(cardId), ease.toStringAsFixed(2));
    await _prefs.setInt(_reviewCountKey(cardId), reviewCount + 1);
    await _prefs.setString(_lastReviewedKey(cardId), now.toIso8601String());
    await _prefs.setString(
      _nextReviewKey(cardId),
      now.add(Duration(days: intervalDays)).toIso8601String(),
    );
    if (revealedBeforeAnswer) {
      await _prefs.setInt(_revealBeforeAnswerKey(cardId),
          revealBeforeAnswerCountFor(cardId) + 1);
    }
    await recordShown(cardId);
    updateSerial.value++;
  }

  Future<void> recordLinkedPracticeUse(String cardId) async {
    await _prefs.setInt(
        _linkedPracticeKey(cardId), linkedPracticeUseCountFor(cardId) + 1);
    updateSerial.value++;
  }

  Future<void> recordLinkedInteractiveLabUse(String cardId) async {
    await _prefs.setInt(
        _linkedLabKey(cardId), linkedInteractiveLabUseCountFor(cardId) + 1);
    updateSerial.value++;
  }
}
