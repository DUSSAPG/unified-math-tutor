import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/practice/practice_screen.dart';
import 'package:unified_math_tutor/screens/topics/topic_learning_hub_screen.dart';

import 'support/topic_hub_practice_crash_test_utils.dart';

/// Same reported sequence as topic_hub_practice_deliberate_entry_test.dart,
/// at the Pixel 6a's actual compact-landscape size (915x412) — the device
/// size the original report came from. A separate file/real load per the
/// established "one real load per file" convention; portrait is covered by
/// the sibling file (the default test viewport is already portrait-shaped).
void main() {
  setUpAll(preloadCrashRegressionCatalogs);
  setUp(initCrashRegressionServices);

  testWidgets(
      'KS5 Statistics & Probability at 915x412 landscape: Topic Drill -> '
      'setup -> Back -> Hub -> Quick Start -> setup, no auto-started '
      'session either time', (tester) async {
    setTestViewportSize(tester, pixel6aLandscape);
    final l10n = await AppLocalizations.delegate.load(testLocale);
    await openHubFreshOnStatisticsProbability(tester);

    final topicDrill = activityCard('topicDrill');
    await tester.ensureVisible(topicDrill);
    await tester.tap(topicDrill);
    await tester.pumpAndSettle();
    expect(find.byType(PracticeScreen), findsOneWidget);
    expect(find.text(l10n.practiceStartButton), findsOneWidget);
    expect(find.byKey(const Key('practiceOption0')), findsNothing);
    expect(tester.takeException(), isNull);

    final navigator = Navigator.of(tester.element(find.byType(PracticeScreen)));
    await navigator.maybePop();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(TopicLearningHubScreen), findsOneWidget);
    await pumpUntilLoaded(tester);

    final quickStart = activityCard('quickStart');
    await tester.ensureVisible(quickStart);
    await tester.tap(quickStart);
    await tester.pumpAndSettle();
    expect(find.byType(PracticeScreen), findsOneWidget);
    expect(find.text(l10n.practiceStartButton), findsOneWidget,
        reason: 'Quick Start must land on setup at compact-landscape size '
            'too, not resume a stale session');
    expect(find.byKey(const Key('practiceOption0')), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
