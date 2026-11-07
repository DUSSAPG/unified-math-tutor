import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/early_maths_lane.dart';
import 'learner_profiles_service.dart';
import 'learner_scope_resolver.dart';
import 'local_account_scope_token_store.dart';
import 'local_account_service.dart';
import 'onboarding_profile_service.dart';

/// Remembers which early-maths starting point a parent chose, per learner
/// scope. A **preference**, not evidence: it stores no score, level or
/// ability signal, and changing it touches nothing else — in particular it
/// never reads, writes or clears Feed the Hungry Panda's progress, which
/// lives under its own `feed_panda_v1_*` keys.
///
/// Keyed by the canonical [LearnerScopeId] (same primitive Panda,
/// Continue Learning and Ratio Foundations use) as
/// `early_maths_lane_v1_<scope>`.
///
/// Holds **no cached state**: every call re-resolves the scope and re-reads
/// `SharedPreferences`. That makes it safe across "delete my data" without a
/// witness key — after a wipe there is simply no stored value, and the
/// account token store regenerates a fresh token on the next call, so a write
/// can never land under the deleted account's scope.
class EarlyMathsLanePreferenceService {
  EarlyMathsLanePreferenceService._();
  static final instance = EarlyMathsLanePreferenceService._();

  static const keyPrefix = 'early_maths_lane_v1_';

  /// Bumped after every successful write so a screen showing the lane can
  /// refresh. Carries no data.
  final ValueNotifier<int> updateSerial = ValueNotifier(0);

  Future<LearnerScopeId> _resolveScope() async {
    final token = await LocalAccountScopeTokenStore.instance.ensureToken();
    return resolveLearnerScope(
      userType: OnboardingProfileService.instance.userType.value,
      activeLearnerId: LearnerProfilesService.instance.activeLearnerId.value,
      isSignedInLocally: LocalAccountService.instance.state.isSignedIn,
      localAccountScopeToken: token,
    );
  }

  /// The stored lane for the current learner scope, or null when none has
  /// been chosen (or the stored value is unrecognised).
  Future<EarlyMathsLane?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final scope = await _resolveScope();
    return EarlyMathsLane.fromStorage(
      prefs.getString('$keyPrefix${scope.value}'),
    );
  }

  Future<void> write(EarlyMathsLane lane) async {
    final prefs = await SharedPreferences.getInstance();
    final scope = await _resolveScope();
    await prefs.setString('$keyPrefix${scope.value}', lane.storageValue);
    updateSerial.value++;
  }
}
