import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// D3 — the Topic Learning Hub is a nested route inside the existing
/// Topics branch (`/topics/hub`), not a new StatefulShellBranch — the
/// sprint's explicit "no new bottom-nav destination is added" requirement.
/// Router-branch structure isn't easily introspectable from a widget test
/// without pumping the full app shell (heavy, many real screens), so this
/// asserts the concrete, auditable fact directly: home_shell.dart's own
/// bottom navigation bar declares exactly the same 5
/// `BottomNavigationBarItem`s it did before this sprint (Home, Topics,
/// Practice, Journey, More) — this sprint's router.dart change added only
/// a nested GoRoute under the existing '/topics' branch, touching no
/// branch/nav-bar declaration at all.
void main() {
  test('home_shell.dart still declares exactly 5 BottomNavigationBarItems', () {
    final source = File('lib/screens/home/home_shell.dart').readAsStringSync();
    final count =
        RegExp('BottomNavigationBarItem\\(').allMatches(source).length;
    expect(count, 5,
        reason: 'a change in this count means a bottom-nav destination was '
            'added or removed — the Topic Learning Hub must never do that');
  });

  test(
      'router.dart\'s Topics branch gained a nested route, not a new '
      'StatefulShellBranch', () {
    final source = File('lib/app/router.dart').readAsStringSync();
    // Exactly 8 StatefulShellBranch declarations — Home, Topics, Practice,
    // Journey, Formula Library, Profile, Tutor, Help — unchanged by this
    // sprint's addition of '/topics/hub' as a nested GoRoute.
    final branchCount =
        RegExp('StatefulShellBranch\\(').allMatches(source).length;
    expect(branchCount, 8);
    expect(source, contains("path: 'hub'"));
    expect(
      source,
      contains('parentNavigatorKey: _rootNavigatorKey'),
      reason: 'the Hub route must break out full-screen like every other '
          'drill-down detail page in this app (Profile settings, Help '
          "parent-teacher-tools), not silently join the bottom nav's tab set",
    );
  });
}
