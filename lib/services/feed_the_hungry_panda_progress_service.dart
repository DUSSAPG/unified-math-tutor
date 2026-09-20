import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/feed_panda_event.dart';
import 'learner_profiles_service.dart';
import 'learner_scope_resolver.dart';
import 'local_account_scope_token_store.dart';
import 'local_account_service.dart';
import 'onboarding_profile_service.dart';

/// Local (non-network) progress/learning-evidence storage for Feed the
/// Hungry Panda: plain counters in `SharedPreferences`, a [ValueNotifier]
/// bumped on every write, no adaptive engine, no network calls.
///
/// This is the progress-event seam the round controller's `onEvent`
/// callback feeds into — the controller has no persistence knowledge of
/// its own; the owning screen wires `FeedPandaRoundController(onEvent:
/// FeedTheHungryPandaProgressService.instance.recordEvent)`.
///
/// ## Scoping
///
/// Every read and write is keyed by the canonical [LearnerScopeId] from
/// [resolveLearnerScope] — the same primitive `ContinueLearningService` and
/// `RatioFoundationsProgressService` use, with the same precedence: an
/// active managed learner (parent/teacher role) wins, then a signed-in local
/// account (via [LocalAccountScopeTokenStore]), then the device guest. Keys
/// are `feed_panda_v1_<field>_<scope>` (event counts:
/// `feed_panda_v1_event_count_<eventType>_<scope>`), a namespace disjoint
/// from the legacy keys below.
///
/// The scope is resolved live on every call from the identity services'
/// current values, never cached, so a scope change (learner switch, sign-in,
/// sign-out, role change) takes effect on the very next read and this
/// service needs no listeners. A write resolves the scope **once**, before
/// its first `await`, and uses that captured scope for every key it touches,
/// so a scope change while a write is in flight cannot move part of the
/// write into another scope.
///
/// ## Legacy data and the exact migration decision
///
/// Before scoping, keys were `feed_panda_<field>_<learnerKey>` (event
/// counts: `feed_panda_event_count_<learnerKey>_<eventType>`) where
/// `learnerKey` was `LearnerProfilesService.activeLearnerId ?? 'default'`.
/// Two kinds of legacy record therefore exist, and they are treated
/// differently because only one has provable ownership:
///
/// * **`<learnerKey>` is a learner profile id** (ids are
///   `<microseconds>_<sequence>`, so they can never equal `default`). That
///   key was written only while that one learner profile was active, so the
///   record belongs to that learner and to nobody else. It is adopted by
///   exactly one scope — `LearnerScopeId.learnerProfile(<that id>)` — and
///   by no other. Adoption is one-time, per scope and non-destructive: the
///   first read-through or write for that scope sees the legacy values
///   (read-through), and the first write copies every legacy field that has
///   no canonical value into the canonical keys, then records
///   `feed_panda_v1_legacy_state_<scope>` = `done`. From then on the legacy
///   keys are never read again for that scope. Different learners map to
///   different scopes, so nothing is ever copied into more than one scope.
///   The copy is resumable (`copying` state) so an interrupted copy cannot
///   leave a half-adopted record that later ignores the rest.
/// * **`<learnerKey>` is `default`.** This key was shared by the device
///   guest, by a signed-in account with no active learner, and by a
///   parent/teacher with no learner selected, so nothing stored says whose
///   it is. It is **never read and never copied** by any scope (guest,
///   account or learner) and is **never deleted**: it stays on disk
///   untouched. The cost is that pre-scoping guest/account Panda counters
///   and "last seed" are not carried over (the learner simply starts from
///   the default seed); the benefit is that no account or managed learner
///   can ever see progress that another identity produced. Adopting it later
///   would need an explicit, owner-approved claim step, not a silent
///   migration.
///
/// In every case a canonical value always wins: legacy data is consulted
/// only for a field that has no canonical value yet, and never once the
/// scope's legacy state is `done`. If a canonical record already exists for
/// a scope that has no legacy state, the legacy record is ignored entirely.
///
/// ## Loading
///
/// [init] is called from `AppBootstrap` like every sibling progress
/// service, so the preferences handle and the account-scope token are
/// normally ready before any screen can reach this service. The synchronous
/// getters defend against being read earlier anyway: until both are loaded
/// they return the "nothing recorded yet" default (never a guest fallback
/// for what might be a signed-in scope) and quietly start loading, and the
/// write methods `await` [init] themselves. [SharedPreferences.getInstance]
/// is idempotent and safely callable concurrently at the plugin level, so
/// [init] calls straight through to it — the same convention
/// `market_store.dart` uses elsewhere in this codebase.
///
/// ## Deletion and scope invalidation
///
/// The signed-in account scope is built from an opaque local-account token
/// that this service caches when it loads. "Delete my data" clears all of
/// `SharedPreferences` (which wipes the token and every progress key) and
/// then re-initialises other services, but a running process would otherwise
/// keep the deleted token in memory and write the learner's next progress
/// beneath the deleted account identity. Neither the reset service nor the
/// token store notifies this service, and no notifier fires for a token wipe,
/// so the cached token is validated against storage instead.
///
/// [init] writes a small witness key holding the token it cached, and
/// `_isReady` is true only while that stored witness still equals the cached
/// token. `prefs.clear()` removes the witness, so after any deletion the very
/// next read or write sees a mismatch **before it touches a progress key**.
/// A read then returns the "nothing recorded yet" default and starts a reload;
/// a write awaits the reload first. The reload is the existing [init] path: it
/// re-reads the token store (which mints a fresh token if the old one was
/// wiped) and re-publishes a valid scope, so a new event is written under the
/// current valid scope and never the deleted one. The witness lives outside
/// both the canonical and the legacy key namespaces and never holds progress.
class FeedTheHungryPandaProgressService {
  FeedTheHungryPandaProgressService._();
  static final instance = FeedTheHungryPandaProgressService._();

  static const _canonicalPrefix = 'feed_panda_v1_';
  static const _legacyDone = 'done';
  static const _legacyCopying = 'copying';

  /// Holds the account-scope token this process cached, so a storage wipe is
  /// detectable synchronously. See "Deletion and scope invalidation".
  static const _scopeWitnessKey = 'panda_progress_scope_witness_v1';

  SharedPreferences? _prefs;
  String? _accountScopeToken;
  Future<void>? _initInFlight;
  Future<void>? _loading;

  final ValueNotifier<int> updateSerial = ValueNotifier(0);

  /// True only while the cached handle and token are loaded **and** the token
  /// is still the one persisted as the witness — i.e. no storage wipe has
  /// invalidated the cached account identity since it was loaded. Every read
  /// and write gates on this before touching a progress key.
  bool get _isReady {
    final prefs = _prefs;
    final token = _accountScopeToken;
    return prefs != null &&
        token != null &&
        prefs.getString(_scopeWitnessKey) == token;
  }

  /// Loads the preferences handle and the local-account scope token, and
  /// persists the token as the scope witness. Both are published together so
  /// a reader can never observe one without the other. Overlapping calls
  /// share one load rather than each minting or reading the token separately
  /// (the token store itself is not single-flight). That only matters on a
  /// device's very first launch, before any account can be signed in, so this
  /// is defensive rather than load-bearing. A call made after a load has
  /// finished re-reads storage, as before — which is also how a deleted
  /// account scope is replaced by a freshly minted one.
  Future<void> init() => _initInFlight ??= _load().whenComplete(() {
        _initInFlight = null;
      });

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final token = await LocalAccountScopeTokenStore.instance.ensureToken();
    await prefs.setString(_scopeWitnessKey, token);
    _prefs = prefs;
    _accountScopeToken = token;
  }

  /// Starts loading in the background if nothing has requested it yet.
  /// Only called from the synchronous getters below, as a defence
  /// against being read before bootstrap's own awaited [init] call has
  /// resolved. Errors are swallowed here specifically — a write method's
  /// own `await init()` (or a later getter's own retry) surfaces the
  /// same failure properly; this fire-and-forget kick must not produce
  /// an unhandled-Future-error warning.
  void _ensureLoading() {
    if (_isReady || _loading != null) return;
    _loading = init().catchError((Object _) {}).whenComplete(() {
      _loading = null;
    });
  }

  /// The scope this service is currently reading and writing, for tests and
  /// adapters. A storage identifier, not presentation data.
  String get currentLearnerScopeId => _resolveContext().scope.value;

  _ScopeContext _resolveContext() {
    final activeLearnerId =
        LearnerProfilesService.instance.activeLearnerId.value;
    final scope = resolveLearnerScope(
      userType: OnboardingProfileService.instance.userType.value,
      activeLearnerId: activeLearnerId,
      isSignedInLocally: LocalAccountService.instance.state.isSignedIn,
      localAccountScopeToken: _accountScopeToken,
    );
    // Legacy keys embedded the raw learner profile id. It is only ever
    // adopted by the scope built from that same id.
    final trimmedId = activeLearnerId?.trim();
    final legacyLearnerId = trimmedId != null &&
            trimmedId.isNotEmpty &&
            scope == LearnerScopeId.learnerProfile(trimmedId)
        ? trimmedId
        : null;
    return _ScopeContext(scope, legacyLearnerId);
  }

  // --- key construction ---------------------------------------------------

  _FieldKeys _scalar(_ScopeContext c, String field, String legacyPrefix) {
    final legacyId = c.legacyLearnerId;
    return _FieldKeys(
      '$_canonicalPrefix${field}_${c.scope.value}',
      legacyId == null ? null : '$legacyPrefix$legacyId',
    );
  }

  _FieldKeys _roundsCompletedKeys(_ScopeContext c) =>
      _scalar(c, 'rounds_completed', 'feed_panda_rounds_completed_');
  _FieldKeys _lastSeedKeys(_ScopeContext c) =>
      _scalar(c, 'last_seed', 'feed_panda_last_seed_');
  _FieldKeys _lastTargetKeys(_ScopeContext c) =>
      _scalar(c, 'last_target', 'feed_panda_last_target_');
  _FieldKeys _lastAcceptedKeys(_ScopeContext c) =>
      _scalar(c, 'last_accepted', 'feed_panda_last_accepted_');
  _FieldKeys _lastAttemptsKeys(_ScopeContext c) =>
      _scalar(c, 'last_attempts', 'feed_panda_last_attempts_');
  _FieldKeys _lastRemainingAttemptsKeys(_ScopeContext c) => _scalar(
        c,
        'last_remaining_attempts',
        'feed_panda_last_remaining_attempts_',
      );

  _FieldKeys _eventCountKeys(_ScopeContext c, FeedPandaEventType type) {
    final legacyId = c.legacyLearnerId;
    return _FieldKeys(
      '${_canonicalPrefix}event_count_${type.name}_${c.scope.value}',
      legacyId == null
          ? null
          : 'feed_panda_event_count_${legacyId}_${type.name}',
    );
  }

  List<_FieldKeys> _allFields(_ScopeContext c) => [
        _roundsCompletedKeys(c),
        _lastSeedKeys(c),
        _lastTargetKeys(c),
        _lastAcceptedKeys(c),
        _lastAttemptsKeys(c),
        _lastRemainingAttemptsKeys(c),
        for (final type in FeedPandaEventType.values) _eventCountKeys(c, type),
      ];

  String _legacyStateKey(_ScopeContext c) =>
      '${_canonicalPrefix}legacy_state_${c.scope.value}';

  // --- legacy read-through and one-time adoption ---------------------------

  /// Whether this scope may still consult its own legacy record. Only a
  /// managed-learner scope ever can (its legacy keys are provably its own);
  /// guest and account scopes never can.
  bool _legacyReadable(SharedPreferences prefs, _ScopeContext c) {
    if (c.legacyLearnerId == null) return false;
    final state = prefs.getString(_legacyStateKey(c));
    if (state == _legacyDone) return false;
    if (state == _legacyCopying) return true;
    // No state yet: legacy is only consulted while the scope has no
    // canonical record at all — a canonical record always wins.
    return !_allFields(c).any((f) => prefs.containsKey(f.canonical));
  }

  int? _readInt(SharedPreferences prefs, _ScopeContext c, _FieldKeys keys) {
    final canonical = prefs.getInt(keys.canonical);
    if (canonical != null) return canonical;
    final legacy = keys.legacy;
    if (legacy != null && _legacyReadable(prefs, c)) {
      return prefs.getInt(legacy);
    }
    return null;
  }

  /// One-time, non-destructive adoption of the scope's own legacy record
  /// into its canonical keys. Runs before any write for a managed-learner
  /// scope; a no-op for every other scope. Never deletes a legacy key and
  /// never overwrites a canonical value.
  Future<void> _adoptLegacy(SharedPreferences prefs, _ScopeContext c) async {
    if (c.legacyLearnerId == null) return;
    final stateKey = _legacyStateKey(c);
    final state = prefs.getString(stateKey);
    if (state == _legacyDone) return;
    if (state == null && !_legacyReadable(prefs, c)) {
      // A canonical record already exists and nothing was ever adopted:
      // the canonical record wins and legacy is ignored for good.
      await prefs.setString(stateKey, _legacyDone);
      return;
    }
    await prefs.setString(stateKey, _legacyCopying);
    for (final f in _allFields(c)) {
      final legacy = f.legacy;
      if (legacy == null || prefs.containsKey(f.canonical)) continue;
      final value = prefs.getInt(legacy);
      if (value != null) await prefs.setInt(f.canonical, value);
    }
    await prefs.setString(stateKey, _legacyDone);
  }

  // --- reads ----------------------------------------------------------------

  ({SharedPreferences prefs, _ScopeContext c})? _readContext() {
    _ensureLoading();
    if (!_isReady) return null;
    return (prefs: _prefs!, c: _resolveContext());
  }

  /// How many rounds this learner has completed (correct remaining-answer
  /// reached).
  int roundsCompleted() {
    final r = _readContext();
    if (r == null) return 0;
    return _readInt(r.prefs, r.c, _roundsCompletedKeys(r.c)) ?? 0;
  }

  /// The generator seed the learner last played, so a future "resume"
  /// affordance could reopen the same round. Null until a round has run
  /// (or until loading finishes, whichever is later).
  int? lastSeed() {
    final r = _readContext();
    if (r == null) return null;
    return _readInt(r.prefs, r.c, _lastSeedKeys(r.c));
  }

  /// How many times an event of [type] has been recorded, across all
  /// rounds, for this learner.
  int eventCount(FeedPandaEventType type) {
    final r = _readContext();
    if (r == null) return 0;
    return _readInt(r.prefs, r.c, _eventCountKeys(r.c, type)) ?? 0;
  }

  int? lastTargetAmount() {
    final r = _readContext();
    if (r == null) return null;
    return _readInt(r.prefs, r.c, _lastTargetKeys(r.c));
  }

  int? lastAcceptedCount() {
    final r = _readContext();
    if (r == null) return null;
    return _readInt(r.prefs, r.c, _lastAcceptedKeys(r.c));
  }

  int? lastAttempts() {
    final r = _readContext();
    if (r == null) return null;
    return _readInt(r.prefs, r.c, _lastAttemptsKeys(r.c));
  }

  int? lastRemainingAnswerAttempts() {
    final r = _readContext();
    if (r == null) return null;
    return _readInt(r.prefs, r.c, _lastRemainingAttemptsKeys(r.c));
  }

  // --- writes ---------------------------------------------------------------

  Future<void> setLastSeed(int seed) async {
    if (!_isReady) await init();
    final prefs = _prefs!;
    final c = _resolveContext();
    await _adoptLegacy(prefs, c);
    await prefs.setInt(_lastSeedKeys(c).canonical, seed);
    updateSerial.value++;
  }

  /// Records one [FeedPandaEvent]: always bumps that event type's count,
  /// and for [FeedPandaEventType.roundCompleted] also snapshots the
  /// learning-evidence fields the brief asks for (target amount, accepted
  /// count, attempts, remaining-answer attempts) and increments the
  /// completed-rounds counter.
  ///
  /// The scope is captured once, synchronously when the service is already
  /// loaded, and used for every key below — so the whole event lands in the
  /// scope that was active when it was recorded, even if the active learner,
  /// role or sign-in changes while the writes are still in flight.
  Future<void> recordEvent(FeedPandaEvent event) async {
    if (!_isReady) await init();
    final prefs = _prefs!;
    final c = _resolveContext();
    await _adoptLegacy(prefs, c);

    final countKeys = _eventCountKeys(c, event.type);
    await prefs.setInt(
      countKeys.canonical,
      (_readInt(prefs, c, countKeys) ?? 0) + 1,
    );
    if (event.seed != null) {
      await prefs.setInt(_lastSeedKeys(c).canonical, event.seed!);
    }

    if (event.type == FeedPandaEventType.roundCompleted &&
        event.completionStatus == true) {
      final roundsKeys = _roundsCompletedKeys(c);
      await prefs.setInt(
        roundsKeys.canonical,
        (_readInt(prefs, c, roundsKeys) ?? 0) + 1,
      );
      if (event.targetAmount != null) {
        await prefs.setInt(_lastTargetKeys(c).canonical, event.targetAmount!);
      }
      if (event.acceptedCount != null) {
        await prefs.setInt(
            _lastAcceptedKeys(c).canonical, event.acceptedCount!);
      }
      if (event.attempts != null) {
        await prefs.setInt(_lastAttemptsKeys(c).canonical, event.attempts!);
      }
      if (event.remainingAnswerAttempts != null) {
        await prefs.setInt(_lastRemainingAttemptsKeys(c).canonical,
            event.remainingAnswerAttempts!);
      }
    }

    updateSerial.value++;
  }

  /// Test-isolation only: forgets the loaded handle and token so the next
  /// [init] re-reads storage, as a fresh app launch would.
  void resetForTests() {
    _prefs = null;
    _accountScopeToken = null;
    _initInFlight = null;
    _loading = null;
  }
}

/// The resolved scope for one read or write, plus — only when that scope is
/// a managed learner's — the raw learner profile id that legacy keys
/// embedded.
class _ScopeContext {
  const _ScopeContext(this.scope, this.legacyLearnerId);
  final LearnerScopeId scope;
  final String? legacyLearnerId;
}

/// One progress field's storage keys: the canonical scope-keyed key, and the
/// legacy key it replaced (null unless the scope is a managed learner's,
/// the only kind of scope with provable ownership of a legacy record).
class _FieldKeys {
  const _FieldKeys(this.canonical, this.legacy);
  final String canonical;
  final String? legacy;
}
