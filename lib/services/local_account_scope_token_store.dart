import 'package:shared_preferences/shared_preferences.dart';

/// Generates and persists a single opaque, non-identifying token
/// representing "this device's local account slot," the first time one is
/// needed, and reuses it after that.
///
/// Lifecycle: [LocalAccountService] has no stable identifier of its own
/// (its `AccountState.email`/`displayName` are personal data, and an email
/// prefix must never become storage identity — see
/// `LocalAccountService.AccountState`'s own doc comment). Rather than
/// derive one from those fields, this store generates a fresh opaque token
/// the first time a Continue Learning checkpoint needs to be scoped to a
/// signed-in-but-no-active-learner identity, using the exact same
/// `microsecondsSinceEpoch + sequence` pattern `LearnerProfilesService`
/// already uses for its own per-learner ids. The token survives sign-out/
/// sign-in cycles of "the same" local account slot — this app has no real
/// backend and cannot otherwise tell two sign-ins apart, so treating every
/// sign-in into this device's one local-account slot as continuous is the
/// correct, least-destructive behaviour. A full local data reset (which
/// clears all of `SharedPreferences`) wipes it along with everything else,
/// same as every other piece of local state.
class LocalAccountScopeTokenStore {
  LocalAccountScopeTokenStore._();
  static final instance = LocalAccountScopeTokenStore._();

  static const _key = 'continue_learning_local_account_scope_token';

  SharedPreferences? _prefs;
  int _sequence = 0;

  /// Returns the existing token, or generates, persists and returns a new
  /// one. Safe to call repeatedly and concurrently — SharedPreferences
  /// writes are idempotent here since the value never changes once set.
  Future<String> ensureToken() async {
    _prefs ??= await SharedPreferences.getInstance();
    final existing = _prefs!.getString(_key);
    if (existing != null && existing.isNotEmpty) return existing;
    final generated = '${DateTime.now().microsecondsSinceEpoch}_${_sequence++}';
    await _prefs!.setString(_key, generated);
    return generated;
  }

  /// Test-isolation only: forces the next [ensureToken] call to re-read
  /// SharedPreferences instead of trusting a cached handle from an earlier
  /// test's mock values.
  void resetForTests() {
    _prefs = null;
    _sequence = 0;
  }
}
