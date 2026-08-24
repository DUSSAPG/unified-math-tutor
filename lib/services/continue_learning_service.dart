import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/continue_learning_checkpoint.dart';
import '../models/continue_learning_summary.dart';
import 'learner_profiles_service.dart';
import 'learner_scope_resolver.dart';
import 'local_account_service.dart';
import 'local_account_scope_token_store.dart';
import 'onboarding_profile_service.dart';

/// The single authoritative owner of Continue Learning persistence.
///
/// One checkpoint per [LearnerScopeId] at a time — starting a new activity
/// for the same learner scope replaces whatever checkpoint existed before,
/// which is this app's answer to "abandonment" without adding a new UI
/// concept (see the Continue Learning Contract report for why). Storage key
/// per scope: `continue_learning_checkpoint_v1_<scope>` — versioned,
/// scoped, and this service's only key namespace; nothing else in the
/// codebase writes to it.
///
/// Reactive to identity changes: listens to the same
/// `OnboardingProfileService.userType` / `LearnerProfilesService.
/// activeLearnerId` / `LocalAccountService.notifier` signals
/// `canonical_identity_resolver.dart` already uses, so switching the active
/// learner, signing in, or signing out immediately reloads (or clears) the
/// visible checkpoint for the new scope — without ever exposing one
/// learner's checkpoint while another scope is active.
class ContinueLearningService {
  ContinueLearningService._();
  static final instance = ContinueLearningService._();

  static const _keyPrefix = 'continue_learning_checkpoint_v1_';

  SharedPreferences? _prefs;
  bool _initialized = false;
  String? _localAccountScopeToken;
  LearnerScopeId _currentScope = LearnerScopeId.deviceGuest;
  ContinueLearningCheckpoint? _currentCheckpoint;
  Listenable? _identitySources;

  /// Bumped on every observable change (load complete, save, update,
  /// complete, invalidate, scope change) — the one reactive signal
  /// consumers (chiefly `CanonicalLearnerStateService`) should listen to.
  /// Mirrors `RecallCardsProgressService.updateSerial`'s exact pattern.
  final ValueNotifier<int> updateSerial = ValueNotifier(0);

  bool get isInitialized => _initialized;

  ContinueLearningEvidenceStatus get status {
    if (!_initialized) return ContinueLearningEvidenceStatus.notLoaded;
    return _currentCheckpoint == null
        ? ContinueLearningEvidenceStatus.noCheckpoint
        : ContinueLearningEvidenceStatus.checkpointAvailable;
  }

  /// Full checkpoint, including its restoration payload — for
  /// `ContinueLearningDestinationResolver` and the practice-session adapter
  /// only. Not for direct UI consumption; see [currentSummary].
  ContinueLearningCheckpoint? get currentCheckpoint => _currentCheckpoint;

  /// The safe, UI-facing view of [currentCheckpoint] — `null` whenever
  /// [currentCheckpoint] is `null`, regardless of [status] (a caller that
  /// cares about the not-loaded/no-checkpoint distinction should check
  /// [status] itself, not infer it from nullability here).
  ContinueLearningSummary? get currentSummary {
    final checkpoint = _currentCheckpoint;
    return checkpoint == null
        ? null
        : ContinueLearningSummary.fromCheckpoint(checkpoint);
  }

  Future<void> init() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    // Cache once; safe even for a guest who never signs in — the token is
    // simply never consulted for scope resolution until it's needed. See
    // LocalAccountScopeTokenStore's own doc comment for its lifecycle.
    _localAccountScopeToken =
        await LocalAccountScopeTokenStore.instance.ensureToken();

    _identitySources = Listenable.merge(<Listenable>[
      OnboardingProfileService.instance.userType,
      LearnerProfilesService.instance.activeLearnerId,
      LocalAccountService.instance.notifier,
    ]);
    _identitySources!.addListener(_onIdentityMaybeChanged);

    _currentScope = _resolveScope();
    _loadForCurrentScope();
    _initialized = true;
    updateSerial.value++;
  }

  LearnerScopeId _resolveScope() {
    return resolveLearnerScope(
      userType: OnboardingProfileService.instance.userType.value,
      activeLearnerId: LearnerProfilesService.instance.activeLearnerId.value,
      isSignedInLocally: LocalAccountService.instance.state.isSignedIn,
      localAccountScopeToken: _localAccountScopeToken,
    );
  }

  void _onIdentityMaybeChanged() {
    final nextScope = _resolveScope();
    if (nextScope == _currentScope) return;
    _currentScope = nextScope;
    _loadForCurrentScope();
    updateSerial.value++;
  }

  String get _currentKey => '$_keyPrefix${_currentScope.value}';

  void _loadForCurrentScope() {
    final prefs = _prefs;
    if (prefs == null) {
      _currentCheckpoint = null;
      return;
    }
    final raw = prefs.getString(_currentKey);
    if (raw == null) {
      _currentCheckpoint = null;
      return;
    }
    ContinueLearningCheckpoint? decoded;
    try {
      decoded = ContinueLearningCheckpoint.tryDecode(jsonDecode(raw));
    } catch (_) {
      decoded = null;
    }
    if (decoded == null) {
      // Quarantine policy: remove a corrupt/unsupported stored value
      // immediately rather than leaving it to be re-parsed (and fail
      // again) on every future load.
      unawaited(prefs.remove(_currentKey));
      _currentCheckpoint = null;
      return;
    }
    if (decoded.learnerScopeId != _currentScope.value) {
      // Defensive: a value stored under this scope's key that claims a
      // different scope indicates corruption or a key-collision bug, not
      // a valid checkpoint for the current learner.
      unawaited(prefs.remove(_currentKey));
      _currentCheckpoint = null;
      return;
    }
    _currentCheckpoint = decoded;
  }

  /// Generates a fresh, opaque checkpoint id — callers starting a new
  /// resumable activity use this once, then reuse the same id for every
  /// subsequent [saveCheckpoint] call updating that same activity.
  String generateCheckpointId() =>
      'clc_${DateTime.now().microsecondsSinceEpoch}';

  /// The current scope's id, for adapters that need to construct a new
  /// [ContinueLearningCheckpoint] (e.g. `checkpoint.learnerScopeId:
  /// service.currentLearnerScopeId`). Never expose this directly to a UI
  /// consumer as if it were a display value — it carries no personal data
  /// but is a storage identifier, not presentation data.
  String get currentLearnerScopeId => _currentScope.value;

  /// Persists [checkpoint] — a full save or update, keyed by the current
  /// scope. Rejects a checkpoint whose `learnerScopeId` doesn't match the
  /// currently-resolved scope, so a caller can never accidentally write
  /// into another learner's slot (e.g. after a scope change raced with an
  /// in-flight save).
  Future<bool> saveCheckpoint(ContinueLearningCheckpoint checkpoint) async {
    if (!_initialized) return false;
    if (checkpoint.learnerScopeId != _currentScope.value) return false;
    final prefs = _prefs!;
    await prefs.setString(_currentKey, jsonEncode(checkpoint.toJson()));
    _currentCheckpoint = checkpoint;
    updateSerial.value++;
    return true;
  }

  /// Marks the checkpoint with [checkpointId] complete and removes it. A
  /// mismatched or already-absent id is a safe no-op — never throws.
  Future<void> markCompleted(String checkpointId) => _remove(checkpointId);

  /// Removes the checkpoint with [checkpointId] because its content is no
  /// longer available/supported. Same no-op-on-mismatch behaviour as
  /// [markCompleted]; kept as a separate method so call sites document
  /// *why* the checkpoint went away.
  Future<void> invalidate(String checkpointId) => _remove(checkpointId);

  Future<void> _remove(String checkpointId) async {
    if (!_initialized) return;
    if (_currentCheckpoint?.checkpointId != checkpointId) return;
    await _prefs!.remove(_currentKey);
    _currentCheckpoint = null;
    updateSerial.value++;
  }

  /// Re-reads the current scope's checkpoint from storage. Callers that
  /// clear `SharedPreferences` out from under this service (namely
  /// `LocalDataResetService`) must call this afterwards, mirroring
  /// `CanonicalLearnerStateService.refreshEvidence`'s exact reasoning —
  /// without it, this service's in-memory cache would keep reporting the
  /// pre-reset checkpoint even though storage no longer has it.
  Future<void> refreshForScopeChange() async {
    if (!_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _currentScope = _resolveScope();
    _loadForCurrentScope();
    updateSerial.value++;
  }

  /// Test-isolation only: detaches listeners and resets every field to its
  /// pre-init default so consecutive tests never observe another test's
  /// state.
  void resetForTests() {
    _identitySources?.removeListener(_onIdentityMaybeChanged);
    _identitySources = null;
    _prefs = null;
    _initialized = false;
    _localAccountScopeToken = null;
    _currentScope = LearnerScopeId.deviceGuest;
    _currentCheckpoint = null;
  }
}
