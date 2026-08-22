import 'package:shared_preferences/shared_preferences.dart';

import 'canonical_learner_state_service.dart';
import 'guest_tip_counter.dart';
import 'local_account_service.dart';
import 'local_preferences_service.dart';
import 'practice_context_service.dart';
import 'session_history_service.dart';

class SignOutService {
  SignOutService._();
  static final instance = SignOutService._();

  Future<void> signOut() async {
    // Firebase Auth is not wired in this app. If it is added later, call
    // FirebaseAuth.instance.signOut() here before clearing local session state.
    await LocalAccountService.instance.signOut();
    PracticeContextService.instance.clear();
    LocalPreferencesService.instance.clearSessionAccess();
    LocalPreferencesService.instance.clearFamilyStudioGraceAccess();
    await SessionHistoryService.instance.clear();
    await GuestTipCounter.reset(await SharedPreferences.getInstance());
    // LocalAccountService.signOut() above already fires its own notifier,
    // so CanonicalLearnerStateService's account-state field self-corrects.
    // Session history has no such notifier (see that service's doc
    // comment), so its cached session-derived evidence needs an explicit
    // pull or it would keep showing the just-cleared history — but only
    // when something has actually opted into that cache existing (see
    // CanonicalLearnerStateService.isInitialized's doc comment).
    if (CanonicalLearnerStateService.instance.isInitialized) {
      await CanonicalLearnerStateService.instance.refreshEvidence();
    }
  }
}
