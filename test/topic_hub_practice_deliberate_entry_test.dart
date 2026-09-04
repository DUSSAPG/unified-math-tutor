import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/practice/practice_screen.dart';
import 'package:unified_math_tutor/screens/topics/topic_learning_hub_screen.dart';

import 'support/topic_hub_practice_crash_test_utils.dart';

/// USER-VERIFIED BEHAVIOUR TO FIX (Pixel, KS5 Statistics & Probability):
/// tapping Quick Start from the Hub skipped the drill/setup choice and
/// started/restarted a session instead of landing on setup awaiting an
/// explicit Start Practice press.
///
/// Root cause: the '/practice' GoRoute built an unkeyed PracticeScreen.
/// Two separate Hub navigations to '/practice' (Topic Drill, then Quick
/// Start) landed at the same widget-tree position, so Flutter's element
/// reconciliation reused the existing State and called didUpdateWidget
/// instead of initState — the ONLY place that reads widget.selectedTopicId/
/// preselectQuickStart to decide _selectedMode/_screenState. Whatever the
/// first navigation left behind (mode, or a mid-session state) silently
/// carried into the second. Fixed by keying PracticeScreen so every Hub tap
/// is a genuinely fresh widget — see router.dart's '/practice' builder and
/// topic_learning_hub_screen.dart's hubNavNonce comment.
///
/// This test drives the exact reported sequence against the real appRouter:
/// Topic -> Hub -> Topic Drill -> setup -> Back -> Hub -> Quick Start ->
/// setup -> Back -> Hub -> Topic Drill again (repeated transitions), never
/// pressing Start, asserting neither card ever shows anything but a clean
/// setup screen with the correct mode preselected.
void main() {
  setUpAll(preloadCrashRegressionCatalogs);
  setUp(initCrashRegressionServices);

  Finder modeCard(String title) => find.byWidgetPredicate(
        (widget) =>
            widget.runtimeType.toString() == '_ModeCard' &&
            (widget as dynamic).title == title,
      );

  bool modeCardSelected(WidgetTester tester, String title) {
    final widget = tester.widget(modeCard(title));
    return (widget as dynamic).selected == true;
  }

  Future<void> backToHub(WidgetTester tester) async {
    final navigator = Navigator.of(tester.element(find.byType(PracticeScreen)));
    await navigator.maybePop();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(TopicLearningHubScreen), findsOneWidget,
        reason: 'Back from a Hub-reached Practice setup must return to the '
            'Hub, not fall through to default shell-branch back behaviour');
    await pumpUntilLoaded(tester);
  }

  testWidgets(
      'KS5 Statistics & Probability: Topic -> Hub -> Topic Drill -> setup '
      '-> Back -> Hub -> Quick Start -> setup -> Back -> Hub -> Topic Drill '
      'again; neither card ever starts a session before an explicit Start '
      'press', (tester) async {
    final l10n = await AppLocalizations.delegate.load(testLocale);
    await openHubFreshOnStatisticsProbability(tester);

    // ── Topic Drill tap ──────────────────────────────────────────────────
    final topicDrill = activityCard('topicDrill');
    await tester.ensureVisible(topicDrill);
    await tester.tap(topicDrill);
    await tester.pumpAndSettle();

    expect(find.byType(PracticeScreen), findsOneWidget);
    expect(find.text(l10n.practiceStartButton), findsOneWidget,
        reason:
            'Topic Drill tap must land on setup, awaiting an explicit Start '
            'press — never skip straight to a session');
    expect(find.byKey(const Key('practiceOption0')), findsNothing,
        reason: 'No question is shown before Start is pressed');
    expect(modeCardSelected(tester, l10n.practiceModeTopicDrill), isTrue);
    expect(modeCardSelected(tester, l10n.practiceModeQuickStart), isFalse);

    // ── Back returns to the Hub ─────────────────────────────────────────
    await backToHub(tester);

    // ── Quick Start tap — the exact reported failure ────────────────────
    final quickStart = activityCard('quickStart');
    await tester.ensureVisible(quickStart);
    await tester.tap(quickStart);
    await tester.pumpAndSettle();

    expect(find.byType(PracticeScreen), findsOneWidget);
    expect(find.text(l10n.practiceStartButton), findsOneWidget,
        reason: 'Quick Start tap must land on setup, not silently resume or '
            'restart whatever the previous Topic Drill visit left behind');
    expect(find.byKey(const Key('practiceOption0')), findsNothing);
    expect(modeCardSelected(tester, l10n.practiceModeQuickStart), isTrue,
        reason: 'Quick Start must actually be selected, not left stuck on '
            "the previous visit's Topic Drill mode");
    expect(modeCardSelected(tester, l10n.practiceModeTopicDrill), isFalse);

    // ── Repeated transitions: Back -> Hub -> Topic Drill once more ─────
    await backToHub(tester);
    await tester.ensureVisible(topicDrill);
    await tester.tap(topicDrill);
    await tester.pumpAndSettle();

    expect(find.byType(PracticeScreen), findsOneWidget);
    expect(find.text(l10n.practiceStartButton), findsOneWidget);
    expect(find.byKey(const Key('practiceOption0')), findsNothing);
    expect(modeCardSelected(tester, l10n.practiceModeTopicDrill), isTrue);
    expect(modeCardSelected(tester, l10n.practiceModeQuickStart), isFalse);
  });
}
