import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the selections made during onboarding (role, learning goal,
/// parent email, preferred display name) so they can inform future
/// recommendations and the Home greeting.
class OnboardingProfileService {
  OnboardingProfileService._();
  static final instance = OnboardingProfileService._();

  static const _userTypeKey = 'onboarding_user_type';
  static const _goalKey = 'onboarding_goal';
  static const _parentEmailKey = 'onboarding_parent_email';
  static const _childNameKey = 'onboarding_child_name';
  static const _preferredDisplayNameKey = 'identity_preferred_display_name';
  static const _relationshipLabelKey = 'identity_relationship_label';
  static const _hasCompletedOnboardingKey = 'onboarding_has_completed';

  late SharedPreferences _prefs;
  final ValueNotifier<String?> userType = ValueNotifier(null);
  final ValueNotifier<String?> goal = ValueNotifier(null);

  /// True once the user has reached Home at least once via onboarding, Guest
  /// Mode, sign-in or account creation — read by the splash screen so a
  /// returning user resumes on Home instead of replaying onboarding.
  final ValueNotifier<bool> hasCompletedOnboarding = ValueNotifier(false);

  /// Active learner's display name, kept in sync by [LearnerProfilesService].
  /// Left in place (rather than renamed) so existing consumers such as the
  /// Journey card keep working untouched.
  final ValueNotifier<String?> childName = ValueNotifier(null);

  /// The signed-in/current user's own preferred display name — a
  /// presentation preference only, never a legal-name requirement.
  final ValueNotifier<String?> preferredDisplayName = ValueNotifier(null);

  /// One of 'parent', 'guardian', 'grandparent', 'tutor', 'other'.
  final ValueNotifier<String?> relationshipLabel = ValueNotifier(null);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    userType.value = _prefs.getString(_userTypeKey);
    goal.value = _prefs.getString(_goalKey);
    childName.value = _prefs.getString(_childNameKey);
    preferredDisplayName.value = _prefs.getString(_preferredDisplayNameKey);
    relationshipLabel.value = _prefs.getString(_relationshipLabelKey);
    hasCompletedOnboarding.value =
        _prefs.getBool(_hasCompletedOnboardingKey) ?? false;
  }

  Future<void> markOnboardingComplete() async {
    hasCompletedOnboarding.value = true;
    await _prefs.setBool(_hasCompletedOnboardingKey, true);
  }

  /// 'student', 'parent' or 'teacher'.
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

  /// Set by [LearnerProfilesService] whenever the active learner changes.
  /// Not intended to be called directly from onboarding/profile UI.
  Future<void> setChildName(String value) async {
    childName.value = value;
    await _prefs.setString(_childNameKey, value);
  }

  Future<void> clearChildName() async {
    childName.value = null;
    await _prefs.remove(_childNameKey);
  }

  Future<void> setPreferredDisplayName(String? value) async {
    final trimmed = value?.trim();
    final normalized = (trimmed == null || trimmed.isEmpty) ? null : trimmed;
    preferredDisplayName.value = normalized;
    if (normalized == null) {
      await _prefs.remove(_preferredDisplayNameKey);
    } else {
      await _prefs.setString(_preferredDisplayNameKey, normalized);
    }
  }

  Future<void> setRelationshipLabel(String value) async {
    relationshipLabel.value = value;
    await _prefs.setString(_relationshipLabelKey, value);
  }

  String? get parentEmail => _prefs.getString(_parentEmailKey);
}
