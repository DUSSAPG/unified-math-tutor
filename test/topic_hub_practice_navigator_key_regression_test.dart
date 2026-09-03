import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/screens/practice/practice_screen.dart';

import 'support/topic_hub_practice_crash_test_utils.dart';

/// P0 regression coverage for the release-blocking crash:
///
///   'package:flutter/src/widgets/navigator.dart':
///   Failed assertion: line 4049 pos 18: '!_keyReservation.contains(key)'
///
/// reported from: select KS5 Topic Drill -> return to the drill/mode
/// selection (the Topic Learning Hub's own Practise cards) -> tap Quick
/// Drill.
///
/// ROOT CAUSE (lib/screens/topics/topic_learning_hub_screen.dart,
/// `_ActivityCard._navigate`): '/practice' is a StatefulShellBranch-owned
/// root route (see safe_navigation.dart's `_shellBranchRoots`), and
/// TopicLearningHubScreen itself lives OUTSIDE the shell — it's reached via
/// a nested GoRoute under '/topics' declared with `parentNavigatorKey:
/// _rootNavigatorKey` in router.dart, breaking out full-screen exactly like
/// Profile's settings sub-pages. The Hub's topicDrill/quickStart cards were
/// calling `context.push('/practice', ...)`. Pushing a shell-branch-root
/// route from a screen hosted on the ROOT navigator forces go_router to
/// build a second instance of the Practice branch's page, reusing its
/// already-mounted `GlobalKey<NavigatorState>` (`_practiceNavKey`) a second
/// time — exactly the defect class already documented and fixed once
/// before for '/topics'/'/formulas' pushes from Explore/Interactive
/// Labs/Family Studio (see route_navigator_key_regression_test.dart and
/// recall_labs_family_studio_navigator_key_regression_test.dart). It didn't
/// crash on the very first Topic Drill launch because the Practice branch's
/// shell-owned Navigator hadn't been built yet for this session; returning
/// to the Hub and launching Quick Drill next collided with the key that
/// first (duplicate) instance had already reserved.
///
/// FIX: both cases now call `context.go('/practice', ...)`, matching every
/// other caller of '/practice' in this codebase (home_shell.dart,
/// explore_math_intelligence_screen.dart, user_type_screen.dart,
/// entrance_exam_hub_screen.dart's popOrGo) — none of which push it.
///
/// One real-router, real-asset-loading `testWidgets` per file — see
/// support/topic_hub_practice_crash_test_utils.dart's doc comment for why.
void main() {
  setUpAll(preloadCrashRegressionCatalogs);
  setUp(initCrashRegressionServices);

  testWidgets(
      'the exact reported P0 sequence: KS5 Topic Drill, back to the Hub, '
      'Quick Drill — launches Practice both times with no exception',
      (tester) async {
    // 1. select KS5 Topic Drill
    await openHubFreshOnStatisticsProbability(tester);
    final topicDrill = activityCard('topicDrill');
    expect(topicDrill, findsOneWidget,
        reason: 'Statistics & Probability has real KS5 content');
    await tester.ensureVisible(topicDrill);
    await tester.tap(topicDrill);
    await tester.pumpAndSettle();
    expect(find.byType(PracticeScreen), findsOneWidget);
    expect(tester.takeException(), isNull);

    // 2. return to the drill/mode selection (the Hub's own Practise
    // cards) — go() replaced the stack, so this is a fresh re-entry via
    // Topics, exactly like the app's bottom nav would produce.
    await openHubFreshOnStatisticsProbability(tester);

    // 3. tap Quick Drill
    final quickStart = activityCard('quickStart');
    expect(quickStart, findsOneWidget,
        reason: 'Quick Start is never topic-filtered — always real');
    await tester.ensureVisible(quickStart);
    await tester.tap(quickStart);
    await tester.pumpAndSettle();

    // 4. must not crash — Quick Drill launches once, cleanly.
    expect(find.byType(PracticeScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
