import 'package:shared_preferences/shared_preferences.dart';

import 'canonical_learner_state_service.dart';
import 'learner_profiles_service.dart';
import 'local_account_service.dart';
import 'local_preferences_service.dart';
import 'mascot_fuel_service.dart';
import 'onboarding_profile_service.dart';
import 'practice_context_service.dart';
import 'session_history_service.dart';
import 'streak_service.dart';
import 'tutor_credit_service.dart';

/// Wipes every piece of app data persisted on this device. This is a
/// local-only app with no cloud sync ("Local-only profile details. No cloud
/// sync is claimed for this release." — see the onboarding privacy note),
/// so a full [SharedPreferences] clear plus re-initializing every service is
/// the complete, correct implementation of "delete my data," not a
/// partial gesture.
class LocalDataResetService {
  LocalDataResetService._();
  static final instance = LocalDataResetService._();

  Future<void> resetAllLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await SessionHistoryService.instance.clear();
    PracticeContextService.instance.clear();

    // Re-run init() on every stateful service so their in-memory
    // ValueNotifiers reset to defaults and every listener updates
    // immediately, without requiring an app restart. Onboarding must run
    // before LearnerProfiles, which migrates from it.
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await LocalAccountService.instance.init();
    await LocalPreferencesService.instance.init();
    await StreakService.instance.init();
    await MascotFuelService.instance.init();
    await TutorCreditService.instance.init();

    // The re-init()s above already fire every ValueNotifier
    // CanonicalLearnerStateService listens to, so its identity/streak/
    // curriculum/account fields self-correct automatically. Its session-
    // and recall-derived evidence has no such notifier (see that service's
    // doc comment) and would otherwise keep showing pre-reset counts —
    // pull it explicitly so a full reset can't leave stale evidence behind
    // — but only when something has actually opted into that cache
    // existing (see CanonicalLearnerStateService.isInitialized's doc
    // comment).
    if (CanonicalLearnerStateService.instance.isInitialized) {
      await CanonicalLearnerStateService.instance.refreshEvidence();
    }
  }
}
