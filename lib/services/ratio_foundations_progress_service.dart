import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'learner_profiles_service.dart';
import 'learner_scope_resolver.dart';
import 'local_account_scope_token_store.dart';
import 'local_account_service.dart';
import 'onboarding_profile_service.dart';

/// The deterministic rung this learner scope should attempt next, given
/// the evidence recorded so far — see [RatioFoundationsProgressService
/// .currentStage]. `completed` means Rung 3's advancement threshold has
/// been met; it is never "full topic mastery," only this one narrow slice.
enum RatioFoundationsStage { rung1, rung2, rung3, completed }

/// Minimal, profile-scoped local evidence for the Year 8 Ratio &
/// Proportion "Ratio scaling foundations" vertical slice (Calculate layer,
/// Rungs 1-3 only).
///
/// Reuses this app's existing profile-scoping mechanism exactly —
/// [LearnerScopeId]/[resolveLearnerScope], the same two primitives
/// `ContinueLearningService` already uses — rather than inventing a new
/// scoping or persistence system. Storage key per scope:
/// `ratio_foundations_evidence_v1_<scope>`, a dedicated key namespace
/// nobody else writes to, following the same one-service-per-feature
/// pattern as `RecallCardsProgressService`/`MentalMathsProgressService`.
///
/// Deliberately does **not** compute broad mastery, readiness, confidence,
/// retention, or analytics — only the narrow deterministic decision rule
/// this slice's brief specifies (see [currentStage]).
class RatioFoundationsProgressService {
  RatioFoundationsProgressService._();
  static final instance = RatioFoundationsProgressService._();

  static const _keyPrefix = 'ratio_foundations_evidence_v1_';
  static const _seedKeyPrefix = 'ratio_foundations_seed_v1_';

  static const schemaVersion = 1;
  static const taskFamilyId = 'ratio_scaling_foundations';
  static const taskFamilyVersion = 1;
  static const topicId = 'ratio_proportion';
  static const stage = 'KS3';
  static const objectiveId = 'ratio_scaling_and_equivalence';

  /// Authored advancement thresholds for this narrow slice — mirrors
  /// `assets/config/ratio_foundations_task_family_v1.json`'s
  /// `rungs[].advanceOnCorrectCount`. Rung 1/2 advance on a single correct
  /// answer (this slice's own deliberately simple rule, matching its
  /// brief exactly); Rung 3 ("fluency") requires more than one to reflect
  /// that fluency is not proven by a single correct answer.
  static const rung1AdvanceOnCorrect = 1;
  static const rung2AdvanceOnCorrect = 1;
  static const rung3AdvanceOnCorrect = 3;

  static const onlyDiagnosticCode = 'ERR_MAGNITUDE_SCALE';

  SharedPreferences? _prefs;
  bool _initialized = false;
  String? _localAccountScopeToken;
  LearnerScopeId _currentScope = LearnerScopeId.deviceGuest;
  List<Map<String, dynamic>> _evidence = [];

  /// Bumped on every observable change, mirroring
  /// `ContinueLearningService.updateSerial`'s exact pattern for UI
  /// reactivity via a `ValueListenableBuilder`.
  final ValueNotifier<int> updateSerial = ValueNotifier(0);

  bool get isInitialized => _initialized;

  Future<void> init() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _localAccountScopeToken =
        await LocalAccountScopeTokenStore.instance.ensureToken();
    _currentScope = _resolveScope();
    _loadForCurrentScope();
    _initialized = true;
    updateSerial.value++;
  }

  LearnerScopeId _resolveScope() => resolveLearnerScope(
        userType: OnboardingProfileService.instance.userType.value,
        activeLearnerId: LearnerProfilesService.instance.activeLearnerId.value,
        isSignedInLocally: LocalAccountService.instance.state.isSignedIn,
        localAccountScopeToken: _localAccountScopeToken,
      );

  String get currentLearnerScopeId => _currentScope.value;

  String get _currentKey => '$_keyPrefix${_currentScope.value}';

  void _loadForCurrentScope() {
    final prefs = _prefs;
    if (prefs == null) {
      _evidence = [];
      return;
    }
    final raw = prefs.getStringList(_currentKey) ?? const [];
    final decoded = <Map<String, dynamic>>[];
    for (final entry in raw) {
      try {
        final parsed = jsonDecode(entry);
        if (parsed is Map<String, dynamic> &&
            parsed['learnerScopeId'] == _currentScope.value) {
          decoded.add(parsed);
        }
        // A record stamped with a different scope than the key it was
        // read from indicates corruption/collision, not valid evidence
        // for this scope — silently dropped rather than trusted.
      } catch (_) {
        // Quarantine policy: skip a corrupt individual record rather than
        // losing the whole scope's evidence to one bad entry.
      }
    }
    _evidence = decoded;
  }

  /// Re-resolves scope if identity changed since [init] — call this when a
  /// screen using this service is (re)entered, mirroring
  /// `ContinueLearningService.refreshForScopeChange`'s reasoning. This
  /// slice's evidence does not need a persistent app-wide listener the way
  /// a Continue Learning banner does, so it is refreshed on entry instead
  /// of reactively.
  Future<void> refreshForScopeChange() async {
    if (!_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _currentScope = _resolveScope();
    _loadForCurrentScope();
    updateSerial.value++;
  }

  /// Read-only view of every evidence record for the current scope, for
  /// tests and any future debug/QA surface. Never exposed as a mastery
  /// percentage or summary — see the class doc.
  List<Map<String, dynamic>> get evidenceForCurrentScope =>
      List.unmodifiable(_evidence);

  int _correctCountForRung(int rung) => _evidence
      .where((e) => e['rung'] == rung && e['result'] == 'correct')
      .length;

  /// The one deterministic decision rule this slice needs: no mastery
  /// score, no confidence estimate — just "has enough correct evidence
  /// been recorded at each rung to offer the next one."
  RatioFoundationsStage currentStage() {
    if (_correctCountForRung(3) >= rung3AdvanceOnCorrect) {
      return RatioFoundationsStage.completed;
    }
    if (_correctCountForRung(2) >= rung2AdvanceOnCorrect) {
      return RatioFoundationsStage.rung3;
    }
    if (_correctCountForRung(1) >= rung1AdvanceOnCorrect) {
      return RatioFoundationsStage.rung2;
    }
    return RatioFoundationsStage.rung1;
  }

  /// How many correct Rung 3 items have been recorded so far — used only
  /// to show truthful "X of Y correct so far" progress toward completing
  /// this slice, never a broader mastery/completion percentage.
  int rung3CorrectCount() => _correctCountForRung(3);

  /// Total attempts already recorded at [rung] for the current scope — the
  /// deterministic `itemIndexInRung` the next item at that rung should use,
  /// so a fresh generation call never repeats an item the learner has
  /// already seen (correct or not) while still being fully reproducible
  /// from (seed, rung, itemIndexInRung) alone.
  int attemptCountForRung(int rung) =>
      _evidence.where((e) => e['rung'] == rung).length;

  /// The one seed this scope's whole Ratio Foundations attempt uses,
  /// created once and persisted so every rung's items stay reproducible
  /// across app restarts, not just within one screen instance. Choosing
  /// the seed itself (a one-time configuration value, not a learner-facing
  /// generated item) uses the device clock rather than an unseeded
  /// `Random()` — every actual item generated *from* this seed is fully
  /// deterministic via `RatioFoundationsTaskGenerator`.
  Future<int> seedForCurrentScope() async {
    final prefs = _prefs;
    if (prefs == null) {
      return DateTime.now().microsecondsSinceEpoch & 0x7fffffff;
    }
    final key = '$_seedKeyPrefix${_currentScope.value}';
    final existing = prefs.getInt(key);
    if (existing != null) return existing;
    final fresh = DateTime.now().microsecondsSinceEpoch & 0x7fffffff;
    await prefs.setInt(key, fresh);
    return fresh;
  }

  /// Records one attempt. [diagnosticCode] must be either `null` or
  /// [onlyDiagnosticCode] — this service records only the single
  /// authored diagnostic this slice defines, never a fabricated or
  /// inferred one.
  Future<void> recordAttempt({
    required int rung,
    required int itemIndexInRung,
    required int seed,
    required bool correct,
    String? diagnosticCode,
  }) async {
    if (!_initialized) return;
    assert(
      diagnosticCode == null || diagnosticCode == onlyDiagnosticCode,
      'RatioFoundationsProgressService only ever records '
      '$onlyDiagnosticCode as a diagnostic code.',
    );
    final record = <String, dynamic>{
      'schemaVersion': schemaVersion,
      'topicId': topicId,
      'stage': stage,
      'objectiveId': objectiveId,
      'taskFamilyId': taskFamilyId,
      'taskFamilyVersion': taskFamilyVersion,
      'rung': rung,
      'itemIndexInRung': itemIndexInRung,
      'seed': seed,
      'result': correct ? 'correct' : 'incorrect',
      'diagnosticCode': diagnosticCode,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
      'learnerScopeId': _currentScope.value,
    };
    _evidence = [..._evidence, record];
    final prefs = _prefs;
    if (prefs != null) {
      await prefs.setStringList(
        _currentKey,
        _evidence.map(jsonEncode).toList(),
      );
    }
    updateSerial.value++;
  }

  /// Test-isolation only: resets every field to its pre-init default.
  void resetForTests() {
    _prefs = null;
    _initialized = false;
    _localAccountScopeToken = null;
    _currentScope = LearnerScopeId.deviceGuest;
    _evidence = [];
  }
}
