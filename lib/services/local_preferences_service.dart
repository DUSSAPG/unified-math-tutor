import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Also home to the Parent PIN gate ("Learning Analytics"/Parent-Teacher
/// Tools reads [hasParentPin]/[verifyParentPin] straight from this
/// service). `_prefs` is nullable rather than `late` — see [init]'s doc —
/// so that a screen reached before `AppBootstrap`'s awaited [init] call
/// resolves (e.g. the splash screen's tap-to-skip gesture, or its hard
/// display-time cap firing before a slow first-launch finishes loading)
/// gets safe defaults instead of a `LateInitializationError`, rather than
/// relying solely on bootstrap ordering to prevent it.
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

  SharedPreferences? _prefs;
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

  /// [SharedPreferences.getInstance] is already idempotent and safely
  /// callable concurrently at the plugin level (it caches its own
  /// in-flight/completed load and retries fresh after a failure), so this
  /// just calls straight through to it rather than adding a second,
  /// redundant caching layer — the same convention `market_store.dart`
  /// already uses elsewhere in this codebase.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
    parentToolsEnabled.value = prefs.getBool(_parentEnabledKey) ?? false;
    rewardsEnabled.value = prefs.getBool(_rewardsEnabledKey) ?? false;
    reduceMotion.value = prefs.getBool(_reduceMotionKey) ?? false;
    textScale.value = prefs.getDouble(_textScaleKey) ?? 1.0;
    quietStudyMode.value = prefs.getBool(_quietStudyModeKey) ?? false;
    soundEnabled.value = prefs.getBool(_soundEnabledKey) ?? true;
    themeMode.value = _themeModeFromString(prefs.getString(_themeModeKey)) ??
        ThemeMode.system;
  }

  /// Starts loading in the background if nothing has requested it yet.
  /// Only called from the synchronous getters below, as a defence against
  /// being read before bootstrap's own awaited [init] call has resolved.
  /// Errors are swallowed here specifically — a write method's own
  /// `await init()` (or a later getter's own retry) surfaces the same
  /// failure properly; this fire-and-forget kick must not produce an
  /// unhandled-Future-error warning.
  void _ensureLoading() {
    if (_prefs == null) init().catchError((Object _) {});
  }

  ThemeMode? _themeModeFromString(String? value) => switch (value) {
        'dark' => ThemeMode.dark,
        'light' => ThemeMode.light,
        'system' => ThemeMode.system,
        _ => null,
      };

  Future<void> setThemeMode(ThemeMode value) async {
    if (_prefs == null) await init();
    await _prefs!.setString(_themeModeKey, value.name);
    themeMode.value = value;
  }

  Future<void> setTextScale(double value) async {
    if (_prefs == null) await init();
    await _prefs!.setDouble(_textScaleKey, value);
    textScale.value = value;
  }

  /// `false` (never having created a PIN) if read before loading has
  /// finished — the safe default, since it never grants access, it only
  /// means a learner would be asked to create a PIN they may already
  /// have, self-correcting on the next read once loading completes.
  bool get hasParentPin {
    _ensureLoading();
    return _prefs?.getString(_parentPinHashKey) != null;
  }

  bool get parentAccessGranted => _parentAccessGranted;

  Future<void> setParentToolsEnabled(bool value) async {
    if (_prefs == null) await init();
    await _prefs!.setBool(_parentEnabledKey, value);
    parentToolsEnabled.value = value;
    if (!value) _parentAccessGranted = false;
  }

  Future<void> setRewardsEnabled(bool value) async {
    if (_prefs == null) await init();
    await _prefs!.setBool(_rewardsEnabledKey, value);
    rewardsEnabled.value = value;
  }

  Future<void> setReduceMotion(bool value) async {
    if (_prefs == null) await init();
    await _prefs!.setBool(_reduceMotionKey, value);
    reduceMotion.value = value;
  }

  Future<void> setQuietStudyMode(bool value) async {
    if (_prefs == null) await init();
    await _prefs!.setBool(_quietStudyModeKey, value);
    quietStudyMode.value = value;
  }

  Future<void> setSoundEnabled(bool value) async {
    if (_prefs == null) await init();
    await _prefs!.setBool(_soundEnabledKey, value);
    soundEnabled.value = value;
  }

  Future<bool> setParentPin(String pin) async {
    if (!RegExp(r'^\d{4}$').hasMatch(pin)) return false;
    if (_prefs == null) await init();
    await _prefs!.setString(_parentPinHashKey, _hash(pin));
    return true;
  }

  /// `false` (PIN rejected) if read before loading has finished — the
  /// safe default, since it never grants access on unverified data.
  bool verifyParentPin(String pin) {
    _ensureLoading();
    return _prefs?.getString(_parentPinHashKey) == _hash(pin);
  }

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
    _ensureLoading();
    final millis = _prefs?.getInt(_parentPinReminderLastShownKey);
    return millis == null ? null : DateTime.fromMillisecondsSinceEpoch(millis);
  }

  Future<void> recordParentPinReminderShown([DateTime? now]) async {
    if (_prefs == null) await init();
    await _prefs!.setInt(_parentPinReminderLastShownKey,
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
