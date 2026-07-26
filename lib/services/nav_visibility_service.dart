import 'package:flutter/widgets.dart';

/// Lets a focused, in-shell flow (e.g. an active practice session) hide the
/// bottom navigation / rail owned by [AppShell] without needing its own
/// top-level route. Screens set [hidden] true on entering the focused state
/// and false again on leaving it or disposing.
///
/// [hide]/[show] are commonly called from `initState()`/`dispose()`, which
/// run while the framework's widget tree is locked for the current build —
/// mutating [hidden] synchronously there would notify [AppShell]'s
/// `ValueListenableBuilder` mid-build and throw ("setState() or
/// markNeedsBuild() called during build"). Deferring the mutation to the
/// next frame here means every call site is safe without needing to
/// remember a post-frame wrapper itself.
class NavVisibilityService {
  NavVisibilityService._();
  static final NavVisibilityService instance = NavVisibilityService._();

  final ValueNotifier<bool> hidden = ValueNotifier(false);

  void hide() => _setHidden(true);
  void show() => _setHidden(false);

  void _setHidden(bool value) {
    // addPostFrameCallback alone only fires once a frame is actually drawn —
    // if nothing else happens to have one pending, the callback would sit
    // queued indefinitely. scheduleFrame() guarantees one, regardless of
    // whatever else is happening in the caller's build/dispose cycle.
    WidgetsBinding.instance.addPostFrameCallback((_) => hidden.value = value);
    WidgetsBinding.instance.scheduleFrame();
  }
}
