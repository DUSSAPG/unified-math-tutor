import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/screens/topics/topic_learning_hub_screen.dart';
import 'package:unified_math_tutor/screens/topics/topics_screen.dart';

import 'support/topic_hub_practice_crash_test_utils.dart';

/// P0 navigation-architecture correction: the Topic Learning Hub must be a
/// normal Topics-branch screen (bottom nav + normal branch back stack), not
/// a root-navigator break-out. Previously `/topics/hub` used
/// `parentNavigatorKey: _rootNavigatorKey` (see router.dart's git history) —
/// full-screen with no bottom nav, matching Profile's settings sub-pages.
/// That hosting was never the actual cause of the P0 navigator-key crash
/// (already fixed at the push()->go() call site), but it did cost the Hub
/// its normal shell chrome for no reason. This asserts the bottom nav bar
/// stays visible the whole time the Hub is on screen, and that ordinary
/// screens keep it too (unaffected by the change).
void main() {
  setUpAll(preloadCrashRegressionCatalogs);
  setUp(initCrashRegressionServices);

  testWidgets(
      'Hub keeps the bottom nav bar (normal Topics-branch screen, not a '
      'root-navigator break-out) and Back returns to Topics with the bar '
      'still there', (tester) async {
    await pumpRealRoute(tester, '/topics');
    expect(find.byType(TopicsScreen), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget,
        reason: 'ordinary-screen bottom-nav preservation baseline');

    await tapNoSettle(tester, 'Statistics & Probability');
    await pumpUntilLoaded(tester);
    expect(find.byType(TopicLearningHubScreen), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget,
        reason: 'the Hub is now a normal Topics-branch screen, so it must '
            'keep the bottom nav exactly like every other in-shell screen');
    expect(tester.takeException(), isNull);

    // The Hub's own AppBar back arrow is a plain IconButton (not the
    // Cupertino/Material BackButton type tester.pageBack() looks for — see
    // its leading: in topic_learning_hub_screen.dart), so tap it directly.
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.byType(TopicsScreen), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
