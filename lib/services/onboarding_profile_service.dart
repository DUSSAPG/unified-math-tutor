import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the selections made during onboarding (user type, learning goal,
/// parent email) so they can inform future recommendations.
class OnboardingProfileService {
  OnboardingProfileService._();
  static final instance = OnboardingProfileService._();

  static const _userTypeKey = 'onboarding_user_type';
  static const _goalKey = 'onboarding_goal';
  static const _parentEmailKey = 'onboarding_parent_email';

  late SharedPreferences _prefs;
  final ValueNotifier<String?> userType = ValueNotifier(null);
  final ValueNotifier<String?> goal = ValueNotifier(null);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    userType.value = _prefs.getString(_userTypeKey);
    goal.value = _prefs.getString(_goalKey);
  }

  /// 'student' or 'parent'.
  Future<void> setUserType(String value) async {
    userType.value = value;
    await _prefs.setString(_userTypeKey, value);
  }

  Future<void> setGoal(String value) async {
    goal.value = value;
    await _prefs.setString(_goalKey, value);
  }

  Future<void> setParentEmail(String value) async {
    await _prefs.setString(_parentEmailKey, value);
  }

  String? get parentEmail => _prefs.getString(_parentEmailKey);
}
