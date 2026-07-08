import 'package:shared_preferences/shared_preferences.dart';

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
    await SessionHistoryService.instance.clear();
    await GuestTipCounter.reset(await SharedPreferences.getInstance());
  }
}
