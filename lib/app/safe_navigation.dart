import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

void popOrGo(BuildContext context, String fallbackLocation) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(fallbackLocation);
  }
}

/// The exact 8 root paths each owned by their own
/// `StatefulShellBranch`/`GlobalKey<NavigatorState>` — see the navigator key
/// ownership model comment above the key declarations in lib/app/router.dart.
/// Every nested sub-route under these (e.g. `/profile/settings`,
/// `/help/parent-teacher-tools`) is deliberately re-parented to the root
/// Navigator via `parentNavigatorKey: _rootNavigatorKey`, so only these exact
/// 8 strings are actually branch-owned.
const _shellBranchRoots = {
  '/home',
  '/topics',
  '/practice',
  '/journey',
  '/formulas',
  '/profile',
  '/tutor',
  '/help',
};

/// True if `location` is one of the 8 shell-branch root paths — i.e.
/// navigating to it with `context.push()` from a screen outside the
/// bottom-nav shell would duplicate that branch's
/// `GlobalKey<NavigatorState>` and throw a Navigator key-reservation
/// assertion. Only the path portion is checked (before any `?query`), so a
/// route built with query parameters still matches correctly.
bool isShellBranchRoute(String location) {
  final path = Uri.parse(location).path;
  return _shellBranchRoots.contains(path);
}

/// Navigates to `location` the way the destination actually requires:
/// `go()` if it's one of the 8 shell-branch roots (a `push()` there would
/// duplicate that branch's Navigator key — see [isShellBranchRoute]),
/// `push()` otherwise, preserving normal "back returns here" behaviour for
/// every non-branch destination. Use this instead of a bare
/// `context.push(route)` whenever `route` is data-driven (not a string
/// literal you can reason about by hand at the call site) — e.g. the
/// Homework Companion session builder's generated destinations.
void pushOrGoIfShellBranch(BuildContext context, String location,
    {Object? extra}) {
  if (isShellBranchRoute(location)) {
    context.go(location, extra: extra);
  } else {
    context.push(location, extra: extra);
  }
}
