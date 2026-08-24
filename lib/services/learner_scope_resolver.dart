import 'package:flutter/foundation.dart';

import 'canonical_identity_resolver.dart';

/// Opaque, non-identifying handle for "whose Continue Learning checkpoint
/// this is." Deliberately never an email address, email prefix, display
/// name, preferred name or password — those are all presentation data, not
/// storage identity (see [resolveLearnerFacingName] for the equivalent rule
/// on the greeting/identity side). Two different learners must never
/// resolve to the same scope; the same learner must always resolve back to
/// the same scope after a restart.
@immutable
class LearnerScopeId {
  const LearnerScopeId._(this.value);

  /// The single guest identity this device has. There is no multi-guest-
  /// profile concept in this app (only [LearnerProfilesService] gives a
  /// parent/teacher multiple learners), so a fixed sentinel is stable
  /// across restarts without needing its own persisted token.
  static const deviceGuest = LearnerScopeId._('device-guest');

  /// A parent/teacher's selected learner. [activeLearnerId] must already be
  /// [LearnerProfilesService]'s stable per-learner id — never a name.
  factory LearnerScopeId.learnerProfile(String activeLearnerId) {
    assert(activeLearnerId.trim().isNotEmpty);
    return LearnerScopeId._('learner:${activeLearnerId.trim()}');
  }

  /// A directly signed-in local account with no active managed learner.
  /// [accountScopeToken] must come from [LocalAccountScopeTokenStore] —
  /// never derived from email or display name.
  factory LearnerScopeId.localAccount(String accountScopeToken) {
    assert(accountScopeToken.trim().isNotEmpty);
    return LearnerScopeId._('account:${accountScopeToken.trim()}');
  }

  /// The full opaque scope value, safe to use as a SharedPreferences key
  /// suffix. Contains no personal data.
  final String value;

  @override
  bool operator ==(Object other) =>
      other is LearnerScopeId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'LearnerScopeId($value)';
}

/// Resolves the current [LearnerScopeId] from the same identity signals
/// [resolveLearnerFacingName] already uses, with the same precedence: an
/// active managed learner (parent/teacher role) always wins over the raw
/// account/guest scope, because that's the specific learner actually doing
/// the work. [localAccountScopeToken] should already be the cached result
/// of [LocalAccountScopeTokenStore.ensureToken] — this function is
/// deliberately synchronous and does no I/O itself.
LearnerScopeId resolveLearnerScope({
  required String? userType,
  required String? activeLearnerId,
  required bool isSignedInLocally,
  required String? localAccountScopeToken,
}) {
  final trimmedLearnerId = activeLearnerId?.trim();
  if (isLearnerFacingRole(userType) &&
      trimmedLearnerId != null &&
      trimmedLearnerId.isNotEmpty) {
    return LearnerScopeId.learnerProfile(trimmedLearnerId);
  }
  final trimmedToken = localAccountScopeToken?.trim();
  if (isSignedInLocally && trimmedToken != null && trimmedToken.isNotEmpty) {
    return LearnerScopeId.localAccount(trimmedToken);
  }
  return LearnerScopeId.deviceGuest;
}
