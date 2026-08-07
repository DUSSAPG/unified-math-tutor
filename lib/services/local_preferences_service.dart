import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalPreferencesService {
  LocalPreferencesService._();
  static final instance = LocalPreferencesService._();

  static const _parentEnabledKey = 'parent_tools_enabled';
  static const _parentPinHashKey = 'parent_tools_pin_hash';
  static const _parentPinReminderLastShownKey =
      'parent_pin_reminder_last_shown_at';
  static const _rewardsEnabledKey = 'rewards_enabled';
  static const _reduceMotionKey = 'reduce_motion';
  static const _textScaleKey = 'text_scale';
  static const _quietStudyModeKey = 'quiet_study_mode';
  static const _soundEnabledKey = 'sound_enabled';
  static const _themeModeKey = 'theme_mode';

  late SharedPreferences _prefs;
  bool _parentAccessGranted = false;

  /// Session-scoped only — deliberately never persisted to
  /// [SharedPreferences], so a fresh app process always starts with this
  /// `false`. Lets a parent who just completed the dedicated Family/Tutor
  /// onboarding enter Family Studio once without a PIN prompt; every other
  /// entry point (Home, Profile, Settings) still goes through the same
  /// [ParentGate] check this flag augments. See [grantFamilyStudioGraceAccess]
  /// for the full expiry contract.
  bool _familyStudioGraceAccess = false;
  final ValueNotifier<bool> parentToolsEnabled = ValueNotifier(false);
  final ValueNotifier<bool> rewardsEnabled = ValueNotifier(false);
  final ValueNotifier<bool> reduceMotion = ValueNotifier(false);
  final ValueNotifier<double> textScale = ValueNotifier(1.0);

  /// Inspired by Nyepi, a Balinese tradition of reflection, stillness and
  /// focus — a low-distraction mode. Gates Captain Math's visual prominence
  /// and all optional audio cues; never gates required information.
  final ValueNotifier<bool> quietStudyMode = ValueNotifier(false);

  /// Global switch for optional short audio cues (see AudioCueService).
  /// Defaults on; every cue is decorative, never required.
  final ValueNotifier<bool> soundEnabled = ValueNotifier(true);

  /// Defaults to following the OS setting — the app has only ever shipped
  /// Dark before this, so there is no prior "always dark" product rule to
  /// preserve for new users.
  final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.system);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    parentToolsEnabled.value = _prefs.getBool(_parentEnabledKey) ?? false;
    rewardsEnabled.value = _prefs.getBool(_rewardsEnabledKey) ?? false;
    reduceMotion.value = _prefs.getBool(_reduceMotionKey) ?? false;
    textScale.value = _prefs.getDouble(_textScaleKey) ?? 1.0;
    quietStudyMode.value = _prefs.getBool(_quietStudyModeKey) ?? false;
    soundEnabled.value = _prefs.getBool(_soundEnabledKey) ?? true;
    themeMode.value = _themeModeFromString(_prefs.getString(_themeModeKey)) ??
        ThemeMode.system;
  }

  ThemeMode? _themeModeFromString(String? value) => switch (value) {
        'dark' => ThemeMode.dark,
        'light' => ThemeMode.light,
        'system' => ThemeMode.system,
        _ => null,
      };

  Future<void> setThemeMode(ThemeMode value) async {
    await _prefs.setString(_themeModeKey, value.name);
    themeMode.value = value;
  }

  Future<void> setTextScale(double value) async {
    await _prefs.setDouble(_textScaleKey, value);
    textScale.value = value;
  }

  bool get hasParentPin => _prefs.getString(_parentPinHashKey) != null;
  bool get parentAccessGranted => _parentAccessGranted;

  Future<void> setParentToolsEnabled(bool value) async {
    await _prefs.setBool(_parentEnabledKey, value);
    parentToolsEnabled.value = value;
    if (!value) _parentAccessGranted = false;
  }

  Future<void> setRewardsEnabled(bool value) async {
    await _prefs.setBool(_rewardsEnabledKey, value);
    rewardsEnabled.value = value;
  }

  Future<void> setReduceMotion(bool value) async {
    await _prefs.setBool(_reduceMotionKey, value);
    reduceMotion.value = value;
  }

  Future<void> setQuietStudyMode(bool value) async {
    await _prefs.setBool(_quietStudyModeKey, value);
    quietStudyMode.value = value;
  }

  Future<void> setSoundEnabled(bool value) async {
    await _prefs.setBool(_soundEnabledKey, value);
    soundEnabled.value = value;
  }

  Future<bool> setParentPin(String pin) async {
    if (!RegExp(r'^\d{4}$').hasMatch(pin)) return false;
    await _prefs.setString(_parentPinHashKey, _hash(pin));
    return true;
  }

  bool verifyParentPin(String pin) =>
      _prefs.getString(_parentPinHashKey) == _hash(pin);

  bool unlockParentTools(String pin) {
    _parentAccessGranted = verifyParentPin(pin);
    return _parentAccessGranted;
  }

  Future<bool> resetParentPin(String currentPin, String newPin) async {
    if (!verifyParentPin(currentPin)) return false;
    return setParentPin(newPin);
  }

  void grantParentToolsAfterPinCreation() => _parentAccessGranted = true;

  void clearSessionAccess() {
    _parentAccessGranted = false;
  }

  bool get hasFamilyStudioGraceAccess => _familyStudioGraceAccess;

  /// Called exactly once, right when the dedicated Family/Tutor onboarding
  /// finishes, right before navigating to Family Studio. Expires — via
  /// [clearFamilyStudioGraceAccess] — on sign-out ([SignOutService]), a
  /// user-role change ([OnboardingProfileService.setUserType]), the app
  /// being backgrounded (`AppLifecycleState.paused`/`.detached`, observed at
  /// app root), and for free on every app restart since this field is never
  /// persisted. It is never a substitute for the PIN on Family Maths, the
  /// Cheat Sheet, or any other existing [ParentGate]-protected screen —
  /// only [ParentGate]'s new `allowGraceAccess: true` call sites (the new
  /// Family Studio screens) honor it.
  void grantFamilyStudioGraceAccess() => _familyStudioGraceAccess = true;

  void clearFamilyStudioGraceAccess() => _familyStudioGraceAccess = false;

  /// Frequency policy for the Family Studio "Protect Family Studio" Parent
  /// PIN reminder banner: shown once immediately (a parent's first
  /// PIN-less visit), then no more often than this interval — never every
  /// launch/visit. 7 days is a deliberate middle ground: frequent enough
  /// that an unprotected Family Studio doesn't go unnoticed for a whole
  /// billing cycle, gentle enough that it never reads as nagging. Documented
  /// here (not just in code) per the sprint's "document reminder frequency"
  /// requirement — see also POLISH_AUDIT.md-style reports for the
  /// human-readable version.
  static const parentPinReminderInterval = Duration(days: 7);

  DateTime? get parentPinReminderLastShownAt {
    final millis = _prefs.getInt(_parentPinReminderLastShownKey);
    return millis == null ? null : DateTime.fromMillisecondsSinceEpoch(millis);
  }

  Future<void> recordParentPinReminderShown([DateTime? now]) async {
    await _prefs.setInt(_parentPinReminderLastShownKey,
        (now ?? DateTime.now()).millisecondsSinceEpoch);
  }

  /// True when the reminder is due: no PIN exists yet, and either it has
  /// never been shown before or [parentPinReminderInterval] has elapsed
  /// since it last was. Callers are expected to also check [hasParentPin]
  /// themselves where relevant — kept as a separate condition here (not
  /// folded in) so this method reads as "is it time?" rather than
  /// duplicating the PIN-exists check silently.
  bool shouldShowParentPinReminder([DateTime? now]) {
    if (hasParentPin) return false;
    final lastShown = parentPinReminderLastShownAt;
    if (lastShown == null) return true;
    return (now ?? DateTime.now()).difference(lastShown) >=
        parentPinReminderInterval;
  }

  String _hash(String pin) => sha256.convert(utf8.encode(pin)).toString();
}
