import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local-only account state. There is no backend/Firebase Auth wired into
/// this app (see [SignOutService]) — signing in or creating an account here
/// just persists a display name/email on-device so Profile can show a real
/// "signed in as" state and so Sign Out has something concrete to clear.
class AccountState {
  const AccountState._(this.isSignedIn, this.displayName, this.email);

  const AccountState.guest() : this._(false, '', '');

  const AccountState.signedIn(
      {required String displayName, required String email})
      : this._(true, displayName, email);

  final bool isSignedIn;
  final String displayName;
  final String email;
}

class LocalAccountService {
  LocalAccountService._();
  static final instance = LocalAccountService._();

  static const _signedInKey = 'account_signed_in';
  static const _displayNameKey = 'account_display_name';
  static const _emailKey = 'account_email';

  late SharedPreferences _prefs;
  final ValueNotifier<AccountState> notifier =
      ValueNotifier(const AccountState.guest());

  AccountState get state => notifier.value;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.getBool(_signedInKey) ?? false) {
      notifier.value = AccountState.signedIn(
        displayName: _prefs.getString(_displayNameKey) ?? '',
        email: _prefs.getString(_emailKey) ?? '',
      );
    }
  }

  Future<void> signIn({required String email, String? displayName}) async {
    final name = (displayName == null || displayName.isEmpty)
        ? (_prefs.getString(_displayNameKey) ?? email.split('@').first)
        : displayName;
    await _prefs.setBool(_signedInKey, true);
    await _prefs.setString(_emailKey, email);
    await _prefs.setString(_displayNameKey, name);
    notifier.value = AccountState.signedIn(displayName: name, email: email);
  }

  Future<void> createAccount({
    required String email,
    required String displayName,
  }) =>
      signIn(email: email, displayName: displayName);

  Future<void> signOut() async {
    await _prefs.setBool(_signedInKey, false);
    await _prefs.remove(_emailKey);
    await _prefs.remove(_displayNameKey);
    notifier.value = const AccountState.guest();
  }
}
