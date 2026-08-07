import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'onboarding_profile_service.dart';

class LearnerProfile {
  const LearnerProfile({required this.id, required this.name});

  final String id;
  final String name;

  LearnerProfile copyWith({String? name}) =>
      LearnerProfile(id: id, name: name ?? this.name);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  factory LearnerProfile.fromJson(Map<String, dynamic> json) =>
      LearnerProfile(id: json['id'] as String, name: json['name'] as String);
}

/// Multiple-learner support for Parent/Teacher accounts. Whichever learner is
/// active mirrors into [OnboardingProfileService.childName] so existing
/// consumers (e.g. the Journey card, the Home greeting) never need to know
/// this service exists.
class LearnerProfilesService {
  LearnerProfilesService._();
  static final instance = LearnerProfilesService._();

  static const _profilesKey = 'learner_profiles';
  static const _activeLearnerIdKey = 'active_learner_id';

  late SharedPreferences _prefs;
  final ValueNotifier<List<LearnerProfile>> profiles = ValueNotifier(const []);
  final ValueNotifier<String?> activeLearnerId = ValueNotifier(null);

  // Combined with a timestamp to keep ids unique even when two learners are
  // added within the same clock tick (DateTime resolution varies by platform).
  int _idSequence = 0;

  LearnerProfile? get activeLearner {
    final id = activeLearnerId.value;
    if (id == null) return null;
    for (final profile in profiles.value) {
      if (profile.id == id) return profile;
    }
    return null;
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs.getString(_profilesKey);
    var loaded = <LearnerProfile>[];
    if (raw != null && raw.isNotEmpty) {
      final decoded = jsonDecode(raw) as List<dynamic>;
      loaded = decoded
          .map((e) => LearnerProfile.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    profiles.value = loaded;
    activeLearnerId.value = _prefs.getString(_activeLearnerIdKey);

    // Migrate a legacy single childName into the learner list if this
    // device onboarded before multi-learner support existed.
    if (loaded.isEmpty) {
      final legacyName = OnboardingProfileService.instance.childName.value;
      if (legacyName != null && legacyName.trim().isNotEmpty) {
        await addLearner(legacyName.trim());
      }
    } else {
      await _syncActiveLearnerName();
    }
  }

  Future<String> addLearner(String name) async {
    final trimmed = name.trim();
    final id = '${DateTime.now().microsecondsSinceEpoch}_${_idSequence++}';
    final profile = LearnerProfile(id: id, name: trimmed);
    profiles.value = [...profiles.value, profile];
    await _persistProfiles();
    if (activeLearnerId.value == null) {
      await setActiveLearner(id);
    }
    return id;
  }

  Future<void> renameLearner(String id, String name) async {
    final trimmed = name.trim();
    profiles.value = [
      for (final profile in profiles.value)
        if (profile.id == id) profile.copyWith(name: trimmed) else profile,
    ];
    await _persistProfiles();
    if (activeLearnerId.value == id) {
      await _syncActiveLearnerName();
    }
  }

  Future<void> removeLearner(String id) async {
    profiles.value = [
      for (final profile in profiles.value)
        if (profile.id != id) profile,
    ];
    await _persistProfiles();
    if (activeLearnerId.value == id) {
      final fallback =
          profiles.value.isNotEmpty ? profiles.value.first.id : null;
      if (fallback != null) {
        await setActiveLearner(fallback);
      } else {
        activeLearnerId.value = null;
        await _prefs.remove(_activeLearnerIdKey);
        await OnboardingProfileService.instance.clearChildName();
      }
    }
  }

  Future<void> setActiveLearner(String id) async {
    activeLearnerId.value = id;
    await _prefs.setString(_activeLearnerIdKey, id);
    await _syncActiveLearnerName();
  }

  Future<void> _syncActiveLearnerName() async {
    final active = activeLearner;
    if (active != null) {
      await OnboardingProfileService.instance.setChildName(active.name);
    }
  }

  Future<void> _persistProfiles() async {
    final encoded = jsonEncode(profiles.value.map((p) => p.toJson()).toList());
    await _prefs.setString(_profilesKey, encoded);
  }
}
