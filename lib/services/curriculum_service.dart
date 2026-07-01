import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurriculumService {
  CurriculumService._() {
    _loadSaved();
  }

  static final CurriculumService instance = CurriculumService._();

  static const _key = 'selected_curriculum';

  final ValueNotifier<String> notifier = ValueNotifier<String>('ks2');

  String get current => notifier.value;

  void _loadSaved() {
    SharedPreferences.getInstance().then((prefs) {
      final saved = prefs.getString(_key);
      if (saved != null) notifier.value = saved;
    });
  }

  Future<void> select(String curriculum) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, curriculum);
    notifier.value = curriculum;
  }

  // Maps stored key → practice stage label used by PracticeScreen / pack paths.
  String get stage => current.toUpperCase(); // ks2 → KS2, etc.
}
