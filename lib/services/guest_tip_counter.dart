import 'package:shared_preferences/shared_preferences.dart';

class GuestTipCounter {
  GuestTipCounter._();

  static const _key = 'guest_tips_used';

  static int read(SharedPreferences prefs) => prefs.getInt(_key) ?? 0;

  static Future<void> increment(SharedPreferences prefs) async {
    await prefs.setInt(_key, read(prefs) + 1);
  }

  static Future<void> reset(SharedPreferences prefs) async {
    await prefs.remove(_key);
  }
}
