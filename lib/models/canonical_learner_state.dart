import 'package:flutter/foundation.dart';

/// Account state this app can actually establish today.
///
/// There is no cloud/Firebase auth (`LocalAccountService`'s own doc comment
/// says so explicitly) and no payment backend — `TutorCreditService.setPaid`
/// is only ever called from bootstrap/reset, never from a real purchase
/// flow. This deliberately has no `premium`/`subscribed` member: adding one
/// would let a future screen claim entitlement state that no authoritative
/// service can currently establish. Add a member here only when a real
/// service can set it.
enum CanonicalAccountState {
  /// Not signed in. Progress and preferences are still real and persisted
  /// — "guest" describes identity, not data durability.
  guest,

  /// Signed in via [LocalAccountService] (on-device only; see that class's
  /// doc comment — there is no cloud account behind this today).
  signedInLocally,
}

/// One read-only, aggregated snapshot of learner state, composed entirely
/// from other services' already-persisted state (see the field-by-field
/// ownership comments below). This class is NOT a new source of truth and
/// is deliberately never persisted anywhere itself — every value here is
/// recomputed on demand from another service, so each fact still has
/// exactly one place it's stored. See [CanonicalLearnerStateService] for the
/// aggregation/refresh logic that produces instances of this class.
///
/// Deliberately absent fields: this snapshot has no Continue Learning
/// progress, no per-topic mastery/confidence/weakness score, no Oxford
/// Track state, no ALI/Allie recommendation, and no premium entitlement
/// field. None of those have an authoritative source in the app today (see
/// the Home/Learner-State/Entitlements/Theme audit) — adding a field for
/// any of them here would let a future consumer read a fabricated value out
/// of what looks like a canonical, trustworthy contract. Add such a field
/// only once its own real contract exists, not before.
@immutable
class CanonicalLearnerState {
  const CanonicalLearnerState({
    required this.schemaVersion,
    required this.preferredName,
    required this.role,
    required this.activeLearnerId,
    required this.accountState,
    required this.curriculumLevel,
    required this.streakDays,
    required this.completedSessionCount,
    required this.answeredQuestionCount,
    required this.correctQuestionCount,
    required this.recallDueCount,
    required this.recallLearningCount,
    required this.recallMasteredCount,
    required this.dailyMissionProgress,
    required this.dailyMissionTarget,
  });

  /// Bump when a field's meaning changes, so a future consumer that has
  /// cached or logged a copy can detect a stale assumption. This model is
  /// never persisted, so this is forward-compatibility bookkeeping only,
  /// not a migration key.
  final int schemaVersion;

  /// The one learner-facing display name, already resolved through
  /// [resolveLearnerFacingName]. `null` means no name is available — render
  /// the neutral localised greeting fallback, never fabricate a name.
  /// Source: `OnboardingProfileService.preferredDisplayName` /
  /// `LearnerProfilesService.activeLearner` /
  /// `OnboardingProfileService.childName`. Never
  /// `LocalAccountService.displayName`/`.email`.
  final String? preferredName;

  /// Mirrors `OnboardingProfileService.userType` verbatim ('student',
  /// 'parent', 'teacher') or `null` if no role has been chosen yet. Kept as
  /// the existing raw string rather than reinterpreted into a new enum, so
  /// this can never drift from the onboarding contract that owns it.
  final String? role;

  /// Source: `LearnerProfilesService.activeLearnerId`. `null` for a
  /// learner-role user, or before any learner profile exists.
  final String? activeLearnerId;

  /// Source: `LocalAccountService.state.isSignedIn`, narrowed to the two
  /// states this app can actually establish (see [CanonicalAccountState]).
  /// Deliberately excludes `LocalAccountService`'s email/displayName —
  /// account metadata never enters this snapshot, per the child-safety and
  /// identity-separation boundary this contract exists to enforce.
  final CanonicalAccountState accountState;

  /// Source: `CurriculumService.current` ('ks2'..'ks5').
  final String curriculumLevel;

  /// Source: `StreakService.days` — the same canonical value Home and
  /// Journey already both read; this does not introduce a second number.
  final int streakDays;

  /// Derived from `SessionHistoryService.load()`, the same computation
  /// Journey's `_JourneyActivity.from()` already performs, so this can
  /// never disagree with what Journey shows. `SessionHistoryService` has no
  /// synchronous cache and no change notifier, so this field is `null`
  /// until `CanonicalLearnerStateService.refreshEvidence()` has completed
  /// at least once this run — `null` means "not yet loaded", never a real
  /// zero.
  final int? completedSessionCount;

  /// Total questions across all sessions in `SessionHistoryService`. Same
  /// nullability rule as [completedSessionCount].
  final int? answeredQuestionCount;

  /// Of [answeredQuestionCount], how many had `selectedIndex ==
  /// correctIndex`. Same nullability rule as [completedSessionCount].
  final int? correctQuestionCount;

  /// Cross-references `RecallCardCatalogService.all()` (the full card list)
  /// against `RecallCardsProgressService.stateFor()` per card. `null` until
  /// `refreshEvidence()` has completed at least once — the catalog requires
  /// an async asset load with no synchronous cache before that. Never
  /// interpreted as mastery, confidence or a recommendation — purely a
  /// count of the scheduler's own `RecallCardState.reviewDue` bucket.
  final int? recallDueCount;

  /// Count of cards in `RecallCardState.learning`. Same nullability rule as
  /// [recallDueCount].
  final int? recallLearningCount;

  /// Count of cards in `RecallCardState.mastered`. Same nullability rule as
  /// [recallDueCount].
  final int? recallMasteredCount;

  /// Source: `MascotFuelService.dailyMissionProgress`.
  final int dailyMissionProgress;

  /// Source: `MascotFuelService.missionTarget` (currently a constant, not
  /// per-learner configurable — mirrored here rather than hard-coded again).
  final int dailyMissionTarget;

  /// `true` once [completedSessionCount]/[answeredQuestionCount]/
  /// [correctQuestionCount] reflect a real `refreshEvidence()` pull rather
  /// than the not-yet-loaded default.
  bool get sessionEvidenceLoaded => completedSessionCount != null;

  /// `true` once the recall-count fields reflect a real `refreshEvidence()`
  /// pull rather than the not-yet-loaded default.
  bool get recallEvidenceLoaded => recallDueCount != null;

  /// Debug/test serialization only — this is never written to disk or sent
  /// anywhere. Field set is intentionally exhaustive and stable so a test
  /// can assert on `.keys` to guard against a future field silently adding
  /// fabricated data (see `canonical_learner_state_service_test.dart`).
  Map<String, Object?> toJson() => {
        'schemaVersion': schemaVersion,
        'preferredName': preferredName,
        'role': role,
        'activeLearnerId': activeLearnerId,
        'accountState': accountState.name,
        'curriculumLevel': curriculumLevel,
        'streakDays': streakDays,
        'completedSessionCount': completedSessionCount,
        'answeredQuestionCount': answeredQuestionCount,
        'correctQuestionCount': correctQuestionCount,
        'recallDueCount': recallDueCount,
        'recallLearningCount': recallLearningCount,
        'recallMasteredCount': recallMasteredCount,
        'dailyMissionProgress': dailyMissionProgress,
        'dailyMissionTarget': dailyMissionTarget,
      };
}
