/// The single deterministic learner-facing identity precedence contract.
///
/// This exists because the app has always had two separate name concepts
/// living in two separate services — [OnboardingProfileService]'s
/// `preferredDisplayName`/`childName` (learner-facing identity) and
/// [LocalAccountService]'s `displayName` (account sign-in metadata, which
/// can be derived from an email prefix — see `LocalAccountService.signIn`).
/// Before this file, `_HeroGreeting` (home_shell.dart) and `_IdentitySection`
/// (profile_screen.dart) each independently re-implemented the same
/// role-based precedence inline. Centralising it here means both surfaces —
/// and any future consumer, e.g. [CanonicalLearnerStateService] — can never
/// drift on what counts as a "learner role" or which name wins.
///
/// [LocalAccountService.displayName]/`.email` are deliberately never
/// consulted anywhere in this file. Account metadata must never become a
/// polished learner-facing name — see the audit finding that
/// `LocalAccountService.signIn()` can derive a display name from the email
/// prefix (e.g. "gerald" from "gerald@example.com"). That value is real and
/// valid *account* metadata (Profile's "Signed in as …" card may still show
/// it) but is out of scope for this resolver by design, not by oversight.
library;

/// True for the two roles where the app greets/shows a *learner*'s name
/// rather than the account holder's own preferred name — a parent or
/// teacher browsing on a learner's behalf. Mirrors
/// `OnboardingProfileService.userType`'s raw string contract ('student',
/// 'parent', 'teacher') rather than introducing a competing enum.
bool isLearnerFacingRole(String? userType) =>
    userType == 'parent' || userType == 'teacher';

/// Resolves the one learner-facing display name per the canonical identity
/// precedence contract:
///
/// * Learner role (student, or role not yet chosen): non-empty
///   [preferredDisplayName], else `null`.
/// * Parent/teacher role: non-empty [activeLearnerName] (from
///   `LearnerProfilesService.activeLearner`), else non-empty
///   [legacyChildName] (from `OnboardingProfileService.childName`, kept for
///   the narrow window where an active learner id exists but the profile
///   list hasn't caught up yet — see `LearnerProfilesService`'s init-order
///   comment in bootstrap.dart), else `null`.
///
/// A `null` return means "no name available" — pass it straight into
/// `greetingFor`, which already renders the correct localised neutral
/// fallback for a null name. This function never fabricates a name, never
/// reads account email/displayName, and whitespace-only input is treated as
/// absent (matching `OnboardingProfileService.setPreferredDisplayName`'s own
/// trim-and-normalize behaviour).
String? resolveLearnerFacingName({
  required String? userType,
  required String? preferredDisplayName,
  required String? activeLearnerName,
  required String? legacyChildName,
}) {
  if (!isLearnerFacingRole(userType)) {
    return _nonEmptyOrNull(preferredDisplayName);
  }
  return _nonEmptyOrNull(activeLearnerName) ?? _nonEmptyOrNull(legacyChildName);
}

String? _nonEmptyOrNull(String? value) {
  if (value == null) return null;
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
