import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// D2.1 — whether the learner has collapsed the compact-landscape root
/// navigation bar. Scoped to exactly that one presentation: portrait's
/// established BottomNavigationBar and the desktop/tablet NavigationRail
/// are never affected by this preference, and this service is never
/// consulted while either of those is on screen.
///
/// Persisted locally (SharedPreferences) so the choice survives navigating
/// away and restarting the app, but it is a presentation preference only —
/// not a Continue Learning-style cross-device concept, and it never gates
/// or substitutes any content.
class CompactLandscapeNavPreferenceService {
  CompactLandscapeNavPreferenceService._();
  static final instance = CompactLandscapeNavPreferenceService._();

  static const _key = 'compact_landscape_nav_collapsed';

  final ValueNotifier<bool> collapsed = ValueNotifier(false);
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    collapsed.value = prefs.getBool(_key) ?? false;
    _initialized = true;
  }

  Future<void> setCollapsed(bool value) async {
    collapsed.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }

  Future<void> toggle() => setCollapsed(!collapsed.value);

  /// Test-isolation only.
  void resetForTests() {
    collapsed.value = false;
    _initialized = false;
  }
}
