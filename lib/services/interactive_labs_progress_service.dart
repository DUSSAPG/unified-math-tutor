import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/interactive_lab_id.dart';
import '../models/lab_guidance_level.dart';
import 'learner_profiles_service.dart';

/// Learner-profile-namespaced local progress for Interactive Labs. Mirrors
/// [MentalMathsProgressService]/[RecallCardsProgressService]'s exact
/// pattern: profile-scoped SharedPreferences keys, plain counters rather
/// than a heavyweight adaptive engine, deliberately not a new architecture.
///
/// Labs have unlimited retries and no pass/fail scoring, so this only
/// tracks completion/attempt counts (evidence a learner engaged with a
/// concept) and cross-feature link use (Recall Cards / Discovery Cards /
/// Practice), not a mastery scheduler like Recall Cards' — that would be a
/// different kind of feature.
class InteractiveLabsProgressService {
  InteractiveLabsProgressService._();
  static final instance = InteractiveLabsProgressService._();

  late SharedPreferences _prefs;

  final ValueNotifier<int> updateSerial = ValueNotifier(0);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String _learnerKey() =>
      LearnerProfilesService.instance.activeLearnerId.value ?? 'default';
  String _attemptsKey(InteractiveLabId lab) =>
      'labs_attempts_${_learnerKey()}_${lab.name}';
  String _completedKey(InteractiveLabId lab) =>
      'labs_completed_${_learnerKey()}_${lab.name}';
  String _linkedRecallKey(InteractiveLabId lab) =>
      'labs_linked_recall_${_learnerKey()}_${lab.name}';
  String _linkedDiscoveryKey(InteractiveLabId lab) =>
      'labs_linked_discovery_${_learnerKey()}_${lab.name}';
  String _linkedPracticeKey(InteractiveLabId lab) =>
      'labs_linked_practice_${_learnerKey()}_${lab.name}';
  String get _guidanceLevelKey => 'labs_guidance_level_${_learnerKey()}';
  String _firstUseSeenKey(InteractiveLabId lab) =>
      'labs_first_use_seen_${_learnerKey()}_${lab.name}';
  String _dragCueSeenKey(InteractiveLabId lab) =>
      'labs_drag_cue_seen_${_learnerKey()}_${lab.name}';
  String _explanationSeenKey(InteractiveLabId lab) =>
      'labs_explanation_seen_${_learnerKey()}_${lab.name}';
  String get _narrationMutedKey => 'labs_narration_muted_${_learnerKey()}';
  String get _narrationTextOnlyKey =>
      'labs_narration_text_only_${_learnerKey()}';
  String get _narrationSpeedKey => 'labs_narration_speed_${_learnerKey()}';

  int attemptsFor(InteractiveLabId lab) =>
      _prefs.getInt(_attemptsKey(lab)) ?? 0;
  int completedFor(InteractiveLabId lab) =>
      _prefs.getInt(_completedKey(lab)) ?? 0;
  int linkedRecallUseCountFor(InteractiveLabId lab) =>
      _prefs.getInt(_linkedRecallKey(lab)) ?? 0;
  int linkedDiscoveryUseCountFor(InteractiveLabId lab) =>
      _prefs.getInt(_linkedDiscoveryKey(lab)) ?? 0;
  int linkedPracticeUseCountFor(InteractiveLabId lab) =>
      _prefs.getInt(_linkedPracticeKey(lab)) ?? 0;

  /// One "attempt" is one Test/Check action on the active challenge,
  /// regardless of whether it succeeded — evidence of experimentation, not
  /// a score.
  Future<void> recordAttempt(InteractiveLabId lab) async {
    await _prefs.setInt(_attemptsKey(lab), attemptsFor(lab) + 1);
    updateSerial.value++;
  }

  /// One "completion" is reaching the target/solved state for a challenge.
  /// Unlimited retries mean this can fire many times across a session.
  Future<void> recordCompletion(InteractiveLabId lab) async {
    await _prefs.setInt(_completedKey(lab), completedFor(lab) + 1);
    updateSerial.value++;
  }

  Future<void> recordLinkedRecallUse(InteractiveLabId lab) async {
    await _prefs.setInt(
        _linkedRecallKey(lab), linkedRecallUseCountFor(lab) + 1);
    updateSerial.value++;
  }

  Future<void> recordLinkedDiscoveryUse(InteractiveLabId lab) async {
    await _prefs.setInt(
        _linkedDiscoveryKey(lab), linkedDiscoveryUseCountFor(lab) + 1);
    updateSerial.value++;
  }

  Future<void> recordLinkedPracticeUse(InteractiveLabId lab) async {
    await _prefs.setInt(
        _linkedPracticeKey(lab), linkedPracticeUseCountFor(lab) + 1);
    updateSerial.value++;
  }

  /// The active learner/profile's preferred presentation band. Never
  /// inferred from age or other personal data — chosen explicitly and
  /// persisted per profile, defaulting to [LabGuidanceLevel.defaultLevel].
  LabGuidanceLevel guidanceLevel() {
    final stored = _prefs.getString(_guidanceLevelKey);
    if (stored == null) return LabGuidanceLevel.defaultLevel;
    try {
      return LabGuidanceLevel.fromId(stored);
    } on FormatException {
      return LabGuidanceLevel.defaultLevel;
    }
  }

  Future<void> setGuidanceLevel(LabGuidanceLevel level) async {
    await _prefs.setString(_guidanceLevelKey, level.id);
    updateSerial.value++;
  }

  /// Whether the first-use guided walkthrough has already been shown and
  /// dismissed for this lab, for this profile.
  bool hasSeenFirstUse(InteractiveLabId lab) =>
      _prefs.getBool(_firstUseSeenKey(lab)) ?? false;

  Future<void> markFirstUseSeen(InteractiveLabId lab) async {
    await _prefs.setBool(_firstUseSeenKey(lab), true);
    updateSerial.value++;
  }

  /// Whether the ambient "drag to interact" cue (e.g. Flight Path Lab's
  /// pulsing aircraft hint) has already been dismissed by a successful
  /// direct-manipulation interaction, for this profile and this lab.
  bool hasSeenDragCue(InteractiveLabId lab) =>
      _prefs.getBool(_dragCueSeenKey(lab)) ?? false;

  Future<void> markDragCueSeen(InteractiveLabId lab) async {
    await _prefs.setBool(_dragCueSeenKey(lab), true);
    updateSerial.value++;
  }

  /// Whether the collapsible "How it works" explanation (e.g. Football
  /// Precision's pitch primer, Maze Driver's route primer) has already been
  /// viewed or skipped by this profile for this lab — used to default the
  /// explanation to collapsed on return visits instead of always expanding.
  bool hasSeenExplanation(InteractiveLabId lab) =>
      _prefs.getBool(_explanationSeenKey(lab)) ?? false;

  Future<void> markExplanationSeen(InteractiveLabId lab) async {
    await _prefs.setBool(_explanationSeenKey(lab), true);
    updateSerial.value++;
  }

  /// Captain Math Guided Narration preferences — profile-isolated like
  /// [guidanceLevel], never shared/leaked across learner profiles. Audio is
  /// on by default (each cue/narration line is still optional and never
  /// required to complete an activity); speed defaults to normal (1.0).
  bool narrationMuted() => _prefs.getBool(_narrationMutedKey) ?? false;

  Future<void> setNarrationMuted(bool value) async {
    await _prefs.setBool(_narrationMutedKey, value);
    updateSerial.value++;
  }

  bool narrationTextOnly() => _prefs.getBool(_narrationTextOnlyKey) ?? false;

  Future<void> setNarrationTextOnly(bool value) async {
    await _prefs.setBool(_narrationTextOnlyKey, value);
    updateSerial.value++;
  }

  double narrationSpeed() => _prefs.getDouble(_narrationSpeedKey) ?? 1.0;

  Future<void> setNarrationSpeed(double value) async {
    await _prefs.setDouble(_narrationSpeedKey, value);
    updateSerial.value++;
  }
}
