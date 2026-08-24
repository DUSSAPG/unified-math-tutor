import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/canonical_learner_state.dart';
import '../models/continue_learning_summary.dart';
import '../models/recall_card_state.dart';
import 'canonical_identity_resolver.dart';
import 'continue_learning_service.dart';
import 'curriculum_service.dart';
import 'learner_profiles_service.dart';
import 'local_account_service.dart';
import 'mascot_fuel_service.dart';
import 'onboarding_profile_service.dart';
import 'recall_card_catalog_service.dart';
import 'recall_cards_progress_service.dart';
import 'session_history_service.dart';
import 'streak_service.dart';

/// The single read-only aggregation boundary for [CanonicalLearnerState].
///
/// This is an aggregator, not a second database: it never writes to
/// `SharedPreferences` itself and owns no persistence key of its own. Every
/// field it exposes is recomputed on demand from the service that actually
/// owns it (see the per-field comments on [CanonicalLearnerState]).
///
/// Two refresh paths, because the underlying services split cleanly into
/// two shapes:
///
/// * Most sources (`OnboardingProfileService`, `LearnerProfilesService`,
///   `LocalAccountService`, `CurriculumService`, `StreakService`,
///   `MascotFuelService`) already expose a `ValueNotifier`/`Listenable` and
///   have their current value available synchronously once initialised —
///   [_recomputeSync] rebuilds the snapshot from these instantly, driven by
///   a merged listener, with no polling and no timers.
/// * `SessionHistoryService` (no notifier, no synchronous cache — every
///   call re-reads `SharedPreferences`) and `RecallCardCatalogService` (the
///   full card list requires an async asset load, cached only after the
///   first successful load) cannot be observed reactively without
///   refactoring services this task is explicitly scoped not to touch.
///   [refreshEvidence] pulls both on demand — call it after any action that
///   changes session history (already wired into `SignOutService` and
///   `LocalDataResetService`) — and their derived fields stay `null`
///   ("not yet loaded") until the first successful pull. `RecallCardsProgressService.updateSerial`
///   does fire on every recall attempt, so that one *is* wired reactively:
///   its listener calls [refreshEvidence] again automatically.
class CanonicalLearnerStateService {
  CanonicalLearnerStateService._();
  static final instance = CanonicalLearnerStateService._();

  static const _schemaVersion = 1;

  static const CanonicalLearnerState _emptySnapshot = CanonicalLearnerState(
    schemaVersion: _schemaVersion,
    preferredName: null,
    role: null,
    activeLearnerId: null,
    accountState: CanonicalAccountState.guest,
    curriculumLevel: 'ks2',
    streakDays: 0,
    completedSessionCount: null,
    answeredQuestionCount: null,
    correctQuestionCount: null,
    recallDueCount: null,
    recallLearningCount: null,
    recallMasteredCount: null,
    dailyMissionProgress: 0,
    dailyMissionTarget: MascotFuelService.missionTarget,
    continueLearningStatus: ContinueLearningEvidenceStatus.notLoaded,
    resumableActivity: null,
  );

  final ValueNotifier<CanonicalLearnerState> snapshot =
      ValueNotifier(_emptySnapshot);

  Listenable? _syncSources;
  bool _initialized = false;

  /// Whether [init] has run. `SignOutService` and `LocalDataResetService`
  /// check this before calling [refreshEvidence] so that a caller which
  /// never opted into this service (e.g. a narrow test harness that sets up
  /// only the handful of services it actually exercises, not the full
  /// bootstrap chain — `RecallCardsProgressService` in particular needs its
  /// own `init()` before `refreshEvidence()` can safely touch it) never
  /// pays for or risks a recall/session evidence pull it never asked for.
  /// In production this is always `true` by the time sign-out/reset can
  /// happen — `AppBootstrap` calls [init] before the app is interactive.
  bool get isInitialized => _initialized;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    _syncSources = Listenable.merge(<Listenable>[
      OnboardingProfileService.instance.preferredDisplayName,
      OnboardingProfileService.instance.childName,
      OnboardingProfileService.instance.userType,
      LearnerProfilesService.instance.profiles,
      LearnerProfilesService.instance.activeLearnerId,
      LocalAccountService.instance.notifier,
      CurriculumService.instance.notifier,
      StreakService.instance.days,
      MascotFuelService.instance.dailyMissionProgress,
      ContinueLearningService.instance.updateSerial,
    ]);
    _syncSources!.addListener(_recomputeSync);
    RecallCardsProgressService.instance.updateSerial
        .addListener(_onRecallChanged);

    _recomputeSync();
    await refreshEvidence();
  }

  /// Rebuilds every synchronously-available field from its owning service's
  /// current `.value`. Safe to call before those services are fully
  /// initialised — each one's `ValueNotifier` already holds a safe default
  /// (e.g. `StreakService.days` is `0` until `init()` loads the real
  /// count), so this never throws; it just reflects "not loaded yet" as the
  /// service's own documented default, same as every other consumer of
  /// these services already does.
  void _recomputeSync() {
    final onboarding = OnboardingProfileService.instance;
    final learnerProfiles = LearnerProfilesService.instance;
    final account = LocalAccountService.instance.state;
    final previous = snapshot.value;

    final resolvedName = resolveLearnerFacingName(
      userType: onboarding.userType.value,
      preferredDisplayName: onboarding.preferredDisplayName.value,
      activeLearnerName: learnerProfiles.activeLearner?.name,
      legacyChildName: onboarding.childName.value,
    );

    snapshot.value = CanonicalLearnerState(
      schemaVersion: _schemaVersion,
      preferredName: resolvedName,
      role: onboarding.userType.value,
      activeLearnerId: learnerProfiles.activeLearnerId.value,
      accountState: account.isSignedIn
          ? CanonicalAccountState.signedInLocally
          : CanonicalAccountState.guest,
      curriculumLevel: CurriculumService.instance.current,
      streakDays: StreakService.instance.days.value,
      // Evidence fields are owned by refreshEvidence(), not this sync pass —
      // carry them forward unchanged so a sync-only update (e.g. the
      // learner's name changing) never resets them to "not yet loaded".
      completedSessionCount: previous.completedSessionCount,
      answeredQuestionCount: previous.answeredQuestionCount,
      correctQuestionCount: previous.correctQuestionCount,
      recallDueCount: previous.recallDueCount,
      recallLearningCount: previous.recallLearningCount,
      recallMasteredCount: previous.recallMasteredCount,
      dailyMissionProgress:
          MascotFuelService.instance.dailyMissionProgress.value,
      dailyMissionTarget: MascotFuelService.missionTarget,
      continueLearningStatus: ContinueLearningService.instance.status,
      resumableActivity: ContinueLearningService.instance.currentSummary,
    );
  }

  void _onRecallChanged() {
    unawaited(refreshEvidence());
  }

  /// Pulls the two evidence sources that have no synchronous cache:
  /// completed-session totals from `SessionHistoryService`, and recall
  /// due/learning/mastered counts by cross-referencing
  /// `RecallCardCatalogService.all()` against
  /// `RecallCardsProgressService.stateFor()`. Deterministic — no network,
  /// no AI, no randomness. Call this after anything that changes session
  /// history (sign-out and full reset already do); recall changes trigger
  /// it automatically via `RecallCardsProgressService.updateSerial`.
  Future<void> refreshEvidence() async {
    final sessions = await SessionHistoryService.instance.load();
    var answered = 0;
    var correct = 0;
    for (final session in sessions) {
      answered += session.questions.length;
      for (final question in session.questions) {
        if (question.selectedIndex == question.correctIndex) correct++;
      }
    }

    int? due;
    int? learning;
    int? mastered;
    try {
      final cards = await RecallCardCatalogService.instance.all();
      final progress = RecallCardsProgressService.instance;
      due = 0;
      learning = 0;
      mastered = 0;
      for (final card in cards) {
        switch (progress.stateFor(card.id)) {
          case RecallCardState.reviewDue:
            due = due! + 1;
          case RecallCardState.learning:
            learning = learning! + 1;
          case RecallCardState.mastered:
            mastered = mastered! + 1;
          case RecallCardState.newCard:
            break;
        }
      }
    } catch (error, stackTrace) {
      // The bundled recall-card catalog is fail-fast validated (see
      // RecallCardCatalogService's own doc comment) so this should not
      // happen in production, but a foundation service other features will
      // depend on must degrade to "not yet loaded" rather than fabricate a
      // zero if it ever does.
      debugPrint('CanonicalLearnerStateService: recall evidence unavailable: '
          '$error\n$stackTrace');
      due = null;
      learning = null;
      mastered = null;
    }

    final previous = snapshot.value;
    snapshot.value = CanonicalLearnerState(
      schemaVersion: _schemaVersion,
      preferredName: previous.preferredName,
      role: previous.role,
      activeLearnerId: previous.activeLearnerId,
      accountState: previous.accountState,
      curriculumLevel: previous.curriculumLevel,
      streakDays: previous.streakDays,
      completedSessionCount: sessions.length,
      answeredQuestionCount: answered,
      correctQuestionCount: correct,
      recallDueCount: due,
      recallLearningCount: learning,
      recallMasteredCount: mastered,
      dailyMissionProgress: previous.dailyMissionProgress,
      dailyMissionTarget: previous.dailyMissionTarget,
      continueLearningStatus: previous.continueLearningStatus,
      resumableActivity: previous.resumableActivity,
    );
  }

  /// Test-isolation only: detaches listeners and resets to the empty
  /// snapshot so consecutive tests never observe another test's state.
  /// Production code has no equivalent lifecycle — this singleton lives for
  /// the app's process lifetime like every other service here.
  void resetForTests() {
    _syncSources?.removeListener(_recomputeSync);
    _syncSources = null;
    RecallCardsProgressService.instance.updateSerial
        .removeListener(_onRecallChanged);
    _initialized = false;
    snapshot.value = _emptySnapshot;
  }
}
