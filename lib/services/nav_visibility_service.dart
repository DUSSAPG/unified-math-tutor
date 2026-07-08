import 'package:flutter/foundation.dart';

/// Lets a focused, in-shell flow (e.g. an active practice session) hide the
/// bottom navigation / rail owned by [AppShell] without needing its own
/// top-level route. Screens set [hidden] true on entering the focused state
/// and false again on leaving it or disposing.
class NavVisibilityService {
  NavVisibilityService._();
  static final NavVisibilityService instance = NavVisibilityService._();

  final ValueNotifier<bool> hidden = ValueNotifier(false);

  void hide() => hidden.value = true;
  void show() => hidden.value = false;
}
