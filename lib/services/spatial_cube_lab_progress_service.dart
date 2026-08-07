import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'learner_profiles_service.dart';

/// The four Spatial Cube Lab activity ids, used as [SharedPreferences] key
/// suffixes and route segments alike.
class SpatialCubeActivityId {
  static const whichFaceOpposite = 'which-face-opposite';
  static const rotateToMatch = 'rotate-to-match';
  static const hiddenFace = 'hidden-face';
  static const cubeNetExplorer = 'cube-net-explorer';

  static const all = [
    whichFaceOpposite,
    rotateToMatch,
    hiddenFace,
    cubeNetExplorer,
  ];
}

/// Per-activity progress for the Spatial Cube Lab — a companion to
/// [InteractiveLabsProgressService], needed because that service tracks
/// state per [InteractiveLabId] (one lab), while this lab has four distinct
/// activities inside it that each need their own completion/best-attempt/
/// hints state. Everything generic across labs (attempts/completions at
/// the lab level, first-use walkthrough, guidance level, narration prefs)
/// still goes through `InteractiveLabsProgressService.instance` as usual —
/// this service only adds what that one doesn't model.
///
/// Same conventions as every sibling progress service: profile-scoped
/// `SharedPreferences` keys, plain counters, no adaptive engine.
class SpatialCubeLabProgressService {
  SpatialCubeLabProgressService._();
  static final instance = SpatialCubeLabProgressService._();

  late SharedPreferences _prefs;

  final ValueNotifier<int> updateSerial = ValueNotifier(0);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String _learnerKey() =>
      LearnerProfilesService.instance.activeLearnerId.value ?? 'default';
  String _completedKey(String activityId) =>
      'spatial_cube_completed_${_learnerKey()}_$activityId';
  String _bestAttemptsKey(String activityId) =>
      'spatial_cube_best_attempts_${_learnerKey()}_$activityId';
  String _hintsUsedKey(String activityId) =>
      'spatial_cube_hints_used_${_learnerKey()}_$activityId';
  String _howItWorksSeenKey(String activityId) =>
      'spatial_cube_how_it_works_seen_${_learnerKey()}_$activityId';
  String get _lastActivityKey => 'spatial_cube_last_activity_${_learnerKey()}';

  bool isCompleted(String activityId) =>
      _prefs.getBool(_completedKey(activityId)) ?? false;

  Future<void> markCompleted(String activityId) async {
    await _prefs.setBool(_completedKey(activityId), true);
    updateSerial.value++;
  }

  /// The fewest attempts a learner has ever needed to reach a correct
  /// result on this activity, or `null` if never yet succeeded. Lower is
  /// better, so a new value only overwrites the stored best when it's
  /// smaller.
  int? bestAttemptCount(String activityId) =>
      _prefs.getInt(_bestAttemptsKey(activityId));

  Future<void> recordAttemptCount(String activityId, int attemptsTaken) async {
    final current = bestAttemptCount(activityId);
    if (current == null || attemptsTaken < current) {
      await _prefs.setInt(_bestAttemptsKey(activityId), attemptsTaken);
      updateSerial.value++;
    }
  }

  int hintsUsed(String activityId) =>
      _prefs.getInt(_hintsUsedKey(activityId)) ?? 0;

  Future<void> recordHintUsed(String activityId) async {
    await _prefs.setInt(_hintsUsedKey(activityId), hintsUsed(activityId) + 1);
    updateSerial.value++;
  }

  bool hasSeenHowItWorks(String activityId) =>
      _prefs.getBool(_howItWorksSeenKey(activityId)) ?? false;

  Future<void> markHowItWorksSeen(String activityId) async {
    await _prefs.setBool(_howItWorksSeenKey(activityId), true);
    updateSerial.value++;
  }

  /// The most recently opened activity id, so the hub can offer "resume
  /// where you left off." Null until the learner has opened one.
  String? lastActivityId() => _prefs.getString(_lastActivityKey);

  Future<void> setLastActivityId(String activityId) async {
    await _prefs.setString(_lastActivityKey, activityId);
    updateSerial.value++;
  }
}
