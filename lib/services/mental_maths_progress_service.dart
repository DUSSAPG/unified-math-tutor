import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/mental_maths_challenge.dart';
import 'learner_profiles_service.dart';

/// Learner-profile-namespaced adaptive difficulty for Mental Maths. A simple
/// rolling window (last 10 attempts) per category, with plain threshold
/// rules — deliberately not a new heavyweight adaptive engine, matching the
/// RC1 scope. Also tracks a small "recently shown" set per category so
/// [MentalMathsChallengeSelector] can skip repeats for this learner.
class MentalMathsProgressService {
  MentalMathsProgressService._();
  static final instance = MentalMathsProgressService._();

  static const _windowSize = 10;
  static const _recentSize = 10;

  late SharedPreferences _prefs;

  /// Bumped on every write so UI can rebuild via a ValueListenableBuilder if
  /// needed; not required for correctness.
  final ValueNotifier<int> updateSerial = ValueNotifier(0);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String _learnerKey() => LearnerProfilesService.instance.activeLearnerId.value ?? 'default';
  String _historyKey(MentalMathsCategory category) =>
      'mental_maths_history_${_learnerKey()}_${category.index}';
  String _tierKey(MentalMathsCategory category) =>
      'mental_maths_tier_${_learnerKey()}_${category.index}';
  String _recentKey(MentalMathsCategory category) =>
      'mental_maths_recent_${_learnerKey()}_${category.index}';

  List<bool> _history(MentalMathsCategory category) {
    final raw = _prefs.getStringList(_historyKey(category)) ?? const [];
    return raw.map((value) => value == '1').toList();
  }

  MentalMathsTier tierFor(MentalMathsCategory category) {
    final stored = _prefs.getString(_tierKey(category));
    if (stored == null) return MentalMathsTier.foundation;
    return MentalMathsTier.fromId(stored);
  }

  List<String> recentlyShown(MentalMathsCategory category) {
    return _prefs.getStringList(_recentKey(category)) ?? const [];
  }

  Future<void> recordShown(MentalMathsCategory category, String id) async {
    final recent = [...recentlyShown(category), id];
    if (recent.length > _recentSize) {
      recent.removeAt(0);
    }
    await _prefs.setStringList(_recentKey(category), recent);
    updateSerial.value++;
  }

  Future<void> recordAttempt(MentalMathsCategory category, {required bool correct}) async {
    final history = [..._history(category), correct];
    if (history.length > _windowSize) {
      history.removeAt(0);
    }
    await _prefs.setStringList(
      _historyKey(category),
      history.map((value) => value ? '1' : '0').toList(),
    );

    if (history.length >= _windowSize) {
      final rate = history.where((value) => value).length / history.length;
      final current = tierFor(category);
      if (rate >= 0.8) {
        final next = _tierUp(current);
        if (next != current) await _setTier(category, next);
      } else if (rate <= 0.4) {
        final next = _tierDown(current);
        if (next != current) await _setTier(category, next);
      }
    }
    updateSerial.value++;
  }

  Future<void> _setTier(MentalMathsCategory category, MentalMathsTier tier) async {
    await _prefs.setString(_tierKey(category), tier.name);
  }

  static MentalMathsTier _tierUp(MentalMathsTier tier) => switch (tier) {
        MentalMathsTier.foundation => MentalMathsTier.intermediate,
        MentalMathsTier.intermediate => MentalMathsTier.advanced,
        MentalMathsTier.advanced => MentalMathsTier.advanced,
      };

  static MentalMathsTier _tierDown(MentalMathsTier tier) => switch (tier) {
        MentalMathsTier.foundation => MentalMathsTier.foundation,
        MentalMathsTier.intermediate => MentalMathsTier.foundation,
        MentalMathsTier.advanced => MentalMathsTier.intermediate,
      };
}
