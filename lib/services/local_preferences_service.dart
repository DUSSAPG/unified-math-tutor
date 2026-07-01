import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalPreferencesService {
  LocalPreferencesService._();
  static final instance = LocalPreferencesService._();

  static const _parentEnabledKey = 'parent_tools_enabled';
  static const _parentPinHashKey = 'parent_tools_pin_hash';
  static const _rewardsEnabledKey = 'rewards_enabled';
  static const _reduceMotionKey = 'reduce_motion';
  static const _textScaleKey = 'text_scale';

  late SharedPreferences _prefs;
  bool _parentAccessGranted = false;
  final ValueNotifier<bool> parentToolsEnabled = ValueNotifier(false);
  final ValueNotifier<bool> rewardsEnabled = ValueNotifier(false);
  final ValueNotifier<bool> reduceMotion = ValueNotifier(false);
  final ValueNotifier<double> textScale = ValueNotifier(1.0);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    parentToolsEnabled.value = _prefs.getBool(_parentEnabledKey) ?? false;
    rewardsEnabled.value = _prefs.getBool(_rewardsEnabledKey) ?? false;
    reduceMotion.value = _prefs.getBool(_reduceMotionKey) ?? false;
    textScale.value = _prefs.getDouble(_textScaleKey) ?? 1.0;
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

  String _hash(String pin) => sha256.convert(utf8.encode(pin)).toString();
}
