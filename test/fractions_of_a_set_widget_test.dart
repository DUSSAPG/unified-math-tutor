import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/labs/fractions_of_a_set/fractions_of_a_set_screen.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';

/// Fractions of a Set screen behaviour (brief §8 groups 5 and 8): the
/// eight-item flow with exact feedback strings, the grouping and take steps,
/// Reduce Motion, session-only state, and pause/resume.
void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({'existing': 'value'});
    await LocalPreferencesService.instance.init();
  });

  Future<void> pump(WidgetTester tester,
      {int seed = 0,
      bool reduceMotion = false,
      Size size = const Size(390, 844)}) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.light(),
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: reduceMotion),
        child: child!,
      ),
      home: FractionsOfASetScreen(seedForTesting: seed),
    ));
    await tester.pumpAndSettle();
  }

  Finder k(String key) => find.byKey(Key(key));

  Future<void> tap(WidgetTester tester, Finder f) async {
    await tester.ensureVisible(f);
    await tester.pumpAndSettle();
    await tester.tap(f);
    await tester.pumpAndSettle();
  }

  String text(WidgetTester tester, String key) =>
      tester.widget<Text>(k(key)).data!;

  /// Visible text of a widget that may hold stacked fractions.
  String semantic(WidgetTester tester, String key) =>
      tester.getSemantics(k(key)).label;

  Finder stepper(String s, String b) =>
      find.descendant(of: k(s), matching: k(b));

  int trayCount(WidgetTester tester, int i) =>
      int.parse(text(tester, 'fractionsOfASetTrayCount-$i'));

  Future<void> setValue(WidgetTester tester, String s, int v) async {
    for (var i = 0; i < v; i++) {
      await tap(tester, stepper(s, 'increase'));
    }
  }

  /// Completes a U or N item's tray steps: deal, groups ready, take [n].
  Future<void> finishTrays(WidgetTester tester, int n) async {
    while (tester.widget<OutlinedButton>(k('fractionsOfASetDeal')).onPressed !=
        null) {
      await tap(tester, k('fractionsOfASetDeal'));
    }
    await tap(tester, k('fractionsOfASetGroupsReady'));
    for (var t = 1; t <= n; t++) {
      await tap(tester, k('fractionsOfASetTray-$t'));
    }
    await tap(tester, k('fractionsOfASetTakeConfirm'));
  }

  testWidgets('seed 0: the full eight-item visit with exact copy',
      (tester) async {
    await pump(tester);

    // Slot 1: U 1/3 of 18. Intro shown first; the prompt speaks words.
    expect(
        find.text(
            'The bottom number says how many equal groups to make. The top '
            'number says how many groups to take.'),
        findsOneWidget);
    expect(semantic(tester, 'fractionsOfASetPrompt'),
        'What is one third of these 18 counters?');
    expect(k('fractionsOfASetDeal'), findsNothing);
    expect(k('fractionsOfASetTakeOneOut-1'), findsNothing);
    await setValue(tester, 'fractionsOfASetPrediction', 2);
    await tap(tester, k('fractionsOfASetConfirm'));

    // Group: tray tap adds one; the collection deals a round.
    expect(text(tester, 'fractionsOfASetStepText'),
        'Make 3 equal groups. Tap a tray to put a counter in it.');
    expect(text(tester, 'fractionsOfASetLeftToPlace'),
        '18 counters left to place');
    expect(k('fractionsOfASetPrediction'), findsNothing);
    await tap(tester, k('fractionsOfASetTray-1'));
    expect(trayCount(tester, 1), 1);
    expect(text(tester, 'fractionsOfASetLeftToPlace'),
        '17 counters left to place');
    await tap(tester, k('fractionsOfASetCollection'));
    expect([for (var t = 1; t <= 3; t++) trayCount(tester, t)], [2, 1, 1]);
    for (var r = 0; r < 5; r++) {
      await tap(tester, k('fractionsOfASetDeal'));
    }
    expect([for (var t = 1; t <= 3; t++) trayCount(tester, t)], [7, 6, 5]);
    expect(
        text(tester, 'fractionsOfASetLeftToPlace'), 'Every counter is placed.');
    expect(k('fractionsOfASetTray-1'), findsNothing,
        reason: 'no tray target once the collection is empty');
    expect(k('fractionsOfASetCollection'), findsNothing);

    // G1: unequal trays stay in Group; the differing trays are outlined.
    await tap(tester, k('fractionsOfASetGroupsReady'));
    expect(
        find.descendant(
            of: k('fractionsOfASetGroupNotice'),
            matching: find.text(
                'Some trays have different numbers of counters, so the groups '
                'are not equal. The trays that differ are outlined. "Deal one '
                'to each tray" shares fairly.')),
        findsOneWidget);
    expect(tester.getSemantics(k('fractionsOfASetTraySemantics-1')).label,
        'Tray 1 of 3: 7 counters, different');
    expect(tester.getSemantics(k('fractionsOfASetTraySemantics-2')).label,
        'Tray 2 of 3: 6 counters');
    expect(tester.getSemantics(k('fractionsOfASetTraySemantics-3')).label,
        'Tray 3 of 3: 5 counters, different');
    await tap(tester, k('fractionsOfASetTakeOneOut-1'));
    expect(k('fractionsOfASetGroupNotice'), findsNothing);
    await tap(tester, k('fractionsOfASetTray-3'));
    expect([for (var t = 1; t <= 3; t++) trayCount(tester, t)], [6, 6, 6]);
    await tap(tester, k('fractionsOfASetGroupsReady'));

    // Take: toggling trays; G0 with the singular form.
    expect(text(tester, 'fractionsOfASetStepText'),
        'Take 1 of the 3 groups. Tap the trays you want.');
    expect(k('fractionsOfASetTakeOneOut-1'), findsNothing);
    expect(
        tester.widget<FilledButton>(k('fractionsOfASetTakeConfirm')).onPressed,
        isNull);
    await tap(tester, k('fractionsOfASetTray-1'));
    await tap(tester, k('fractionsOfASetTray-2'));
    expect(k('fractionsOfASetChosenBadge-1'), findsOneWidget);
    await tap(tester, k('fractionsOfASetTakeConfirm'));
    expect(
        find.descendant(
            of: k('fractionsOfASetTakeNotice'),
            matching: find.text('Take 1 tray. You have chosen 2.')),
        findsOneWidget);
    await tap(tester, k('fractionsOfASetTray-2'));
    await tap(tester, k('fractionsOfASetTakeConfirm'));

    // Reveal: abstract line, result, and generic feedback for 2.
    expect(text(tester, 'fractionsOfASetRevealSteps'),
        '18 ÷ 3 = 6, then 1 × 6 = 6');
    expect(
        semantic(tester, 'fractionsOfASetRevealText'), 'one third of 18 is 6.');
    expect(text(tester, 'fractionsOfASetFeedbackText'),
        'Make 3 equal groups, then count the counters in one of them.');
    expect(k('fractionsOfASetBar'), findsOneWidget);
    await tap(tester, k('fractionsOfASetNext'));

    // Slot 2: N 5/10 of 30; predicting 6 (= 30 ÷ 5) is R1.
    expect(semantic(tester, 'fractionsOfASetPrompt'),
        'What is 5 tenths of these 30 counters?');
    expect(k('fractionsOfASetIntro'), findsNothing);
    await setValue(tester, 'fractionsOfASetPrediction', 6);
    await tap(tester, k('fractionsOfASetConfirm'));
    await finishTrays(tester, 5);
    expect(
        text(tester, 'fractionsOfASetFeedbackText'),
        'The bottom number, 10, says how many equal groups to make. The top '
        'number, 5, says how many of those groups to take.');
    await tap(tester, k('fractionsOfASetNext'));

    // Slot 3: E unequal; Yes is E1.
    expect(text(tester, 'fractionsOfASetPrompt'),
        'Is this a fair split into 10 equal groups?');
    expect(tester.getSemantics(k('fractionsOfASetTraySemantics-1')).label,
        'Tray 1 of 10: 3 counters');
    expect(tester.widget<FilledButton>(k('fractionsOfASetConfirm')).onPressed,
        isNull,
        reason: 'no choice selected at first');
    await tap(tester, k('fractionsOfASetYes'));
    await tap(tester, k('fractionsOfASetConfirm'));
    expect(
        text(tester, 'fractionsOfASetFeedbackText'),
        'Look again: two trays have different counts. They are outlined. '
        'Equal groups must all be the same size.');
    expect(k('fractionsOfASetDifferentLabel-1'), findsOneWidget);
    expect(k('fractionsOfASetDifferentLabel-4'), findsOneWidget);
    expect(k('fractionsOfASetDifferentLabel-2'), findsNothing);
    expect(tester.getSemantics(k('fractionsOfASetTraySemantics-4')).label,
        'Tray 4 of 10: 1 counter, different');
    await tap(tester, k('fractionsOfASetNext'));

    // Slot 4: W 4 of 12 → 1/3; picking 2 is W3 (not chosen).
    expect(
        text(tester, 'fractionsOfASetPrompt'),
        '4 of these 12 counters are chosen. What fraction of the collection '
        'is that?');
    expect(tester.getSemantics(k('fractionsOfASetDenominator')).label,
        'out of 3 equal groups');
    await setValue(tester, 'fractionsOfASetTopNumber', 2);
    await tap(tester, k('fractionsOfASetConfirm'));
    expect(text(tester, 'fractionsOfASetFeedbackText'),
        'That counts the groups that are not chosen.');
    expect(semantic(tester, 'fractionsOfASetRevealText'),
        '4 of 12 is one third: 1 of the 3 equal groups.');
    expect(tester.getSemantics(k('fractionsOfASetTraySemantics-1')).label,
        'Tray 1 of 3: 4 counters, chosen');
    await tap(tester, k('fractionsOfASetNext'));

    // Slot 5: C 1/2 vs 1/3 of 30, 1/2 first; choosing 1/3 is C1.
    expect(semantic(tester, 'fractionsOfASetPrompt'),
        'Which is more: one half of 30 or one third of 30?');
    expect(
        tester.getSemantics(k('fractionsOfASetOptionFirst')).label, 'one half');
    await tap(tester, k('fractionsOfASetOptionSecond'));
    await tap(tester, k('fractionsOfASetConfirm'));
    expect(
        semantic(tester, 'fractionsOfASetFeedbackText'),
        'More equal groups means each group is smaller, so one third of 30 '
        'is less than one half of 30.');
    expect(semantic(tester, 'fractionsOfASetRevealText'),
        'one half of 30 is 15; one third of 30 is 10.');
    await tap(tester, k('fractionsOfASetNext'));

    // Slot 6: N 8/10 of 20, answered correctly.
    await setValue(tester, 'fractionsOfASetPrediction', 16);
    await tap(tester, k('fractionsOfASetConfirm'));
    await finishTrays(tester, 8);
    expect(text(tester, 'fractionsOfASetFeedbackText'), "Yes, that's correct.");
    await tap(tester, k('fractionsOfASetNext'));

    // Slot 7: E equal; No is E2.
    await tap(tester, k('fractionsOfASetNo'));
    await tap(tester, k('fractionsOfASetConfirm'));
    expect(text(tester, 'fractionsOfASetFeedbackText'),
        'Every tray has 3 counters, so these groups are equal.');
    expect(
        text(tester, 'fractionsOfASetRevealText'), '6 trays with 3 in each.');
    await tap(tester, k('fractionsOfASetNext'));

    // Slot 8: X 3/5 of 20, no counters or trays; 8 is R4 (other groups).
    expect(semantic(tester, 'fractionsOfASetPrompt'), '3 fifths of 20 = ?');
    expect(k('fractionsOfASetTrays'), findsNothing);
    expect(k('fractionsOfASetCollectionBox'), findsNothing);
    await setValue(tester, 'fractionsOfASetPrediction', 8);
    await tap(tester, k('fractionsOfASetConfirm'));
    expect(
        text(tester, 'fractionsOfASetFeedbackText'),
        'That counts the groups you did not take. Count only the 3 groups '
        'the top number asks for.');
    expect(text(tester, 'fractionsOfASetRevealSteps'),
        '20 ÷ 5 = 4, then 3 × 4 = 12');
    await tap(tester, k('fractionsOfASetNext'));

    // Explore again starts seed + 1.
    await tap(tester, k('fractionsOfASetExploreAgain'));
    expect(semantic(tester, 'fractionsOfASetPrompt'),
        'What is one tenth of these 30 counters?');
  });

  testWidgets('a full visit and Explore again leave prefs byte-identical',
      (tester) async {
    final prefs = await SharedPreferences.getInstance();
    final before = {for (final key in prefs.getKeys()) key: prefs.get(key)};
    await pump(tester, seed: 7);
    for (var round = 0; round < 2; round++) {
      for (var i = 0; i < 8; i++) {
        final choice = [
          'fractionsOfASetYes',
          'fractionsOfASetOptionSame',
        ].map(k).where((f) => f.evaluate().isNotEmpty);
        if (choice.isNotEmpty) await tap(tester, choice.first);
        await tap(tester, k('fractionsOfASetConfirm'));
        if (k('fractionsOfASetDeal').evaluate().isNotEmpty) {
          await finishTrays(tester, 1);
          if (k('fractionsOfASetTakeNotice').evaluate().isNotEmpty) {
            // N items: take more trays until the count matches.
            for (var t = 2; k('fractionsOfASetNext').evaluate().isEmpty; t++) {
              await tap(tester, k('fractionsOfASetTray-$t'));
              await tap(tester, k('fractionsOfASetTakeConfirm'));
            }
          }
        }
        await tap(tester, k('fractionsOfASetNext'));
      }
      expect(k('fractionsOfASetExploreAgain'), findsOneWidget);
      if (round == 0) await tap(tester, k('fractionsOfASetExploreAgain'));
    }
    final after = {for (final key in prefs.getKeys()) key: prefs.get(key)};
    expect(after, before);
  });

  testWidgets('Reduce Motion: deal and take are instant; the scroll jumps',
      (tester) async {
    await pump(tester, reduceMotion: true, size: const Size(360, 640));
    await tap(tester, k('fractionsOfASetConfirm'));
    // Deal: drawn on the very next frame.
    await tester.ensureVisible(k('fractionsOfASetDeal'));
    await tester.pumpAndSettle();
    final before = trayCount(tester, 1);
    await tester.tap(k('fractionsOfASetDeal'));
    await tester.pump();
    expect(trayCount(tester, 1), before + 1);
    await tester.pumpAndSettle();
    await finishTrays(tester, 1);
    await tap(tester, k('fractionsOfASetNext'));

    // Slot 2 (d = 10): the reveal is taller than the screen; the feedback
    // scroll lands within one frame and nothing moves afterwards.
    await tap(tester, k('fractionsOfASetConfirm'));
    while (tester.widget<OutlinedButton>(k('fractionsOfASetDeal')).onPressed !=
        null) {
      await tap(tester, k('fractionsOfASetDeal'));
    }
    await tap(tester, k('fractionsOfASetGroupsReady'));
    for (var t = 1; t <= 5; t++) {
      await tap(tester, k('fractionsOfASetTray-$t'));
    }
    await tester.ensureVisible(k('fractionsOfASetTakeConfirm'));
    await tester.pumpAndSettle();
    await tester.tap(k('fractionsOfASetTakeConfirm'));
    await tester.pump(); // build the reveal; schedule the scroll
    await tester.pump(); // the jump
    final scroll = tester
        .widget<SingleChildScrollView>(k('fractionsOfASetPanelScroll'))
        .controller!;
    final landed = scroll.offset;
    expect(landed, greaterThan(0), reason: 'the feedback was below the fold');
    await tester.pumpAndSettle();
    expect(scroll.offset, landed, reason: 'no animated scroll follows');
    final next = tester.getRect(k('fractionsOfASetNext'));
    expect(next.bottom, lessThanOrEqualTo(640));
    expect(next.top, greaterThanOrEqualTo(0));
  });

  testWidgets('without Reduce Motion the feedback scroll animates',
      (tester) async {
    await pump(tester, size: const Size(360, 640));
    await tap(tester, k('fractionsOfASetConfirm'));
    await finishTrays(tester, 1);
    await tap(tester, k('fractionsOfASetNext'));
    await tap(tester, k('fractionsOfASetConfirm'));
    while (tester.widget<OutlinedButton>(k('fractionsOfASetDeal')).onPressed !=
        null) {
      await tap(tester, k('fractionsOfASetDeal'));
    }
    await tap(tester, k('fractionsOfASetGroupsReady'));
    for (var t = 1; t <= 5; t++) {
      await tap(tester, k('fractionsOfASetTray-$t'));
    }
    await tester.ensureVisible(k('fractionsOfASetTakeConfirm'));
    await tester.pumpAndSettle();
    await tester.tap(k('fractionsOfASetTakeConfirm'));
    await tester.pump();
    await tester.pump();
    final scroll = tester
        .widget<SingleChildScrollView>(k('fractionsOfASetPanelScroll'))
        .controller!;
    final early = scroll.offset;
    await tester.pumpAndSettle();
    expect(scroll.offset, isNot(early), reason: 'the scroll is animated');
  });

  testWidgets('pause and resume keep the item, phase, trays and chosen set',
      (tester) async {
    await pump(tester);
    await tap(tester, k('fractionsOfASetConfirm'));
    await finishTrays(tester, 0);
    await tap(tester, k('fractionsOfASetTray-2'));
    expect(k('fractionsOfASetChosenBadge-2'), findsOneWidget);
    for (final state in [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(state);
      await tester.pump();
    }
    await tester.pumpAndSettle();
    expect(text(tester, 'fractionsOfASetStepText'),
        'Take 1 of the 3 groups. Tap the trays you want.');
    expect([for (var t = 1; t <= 3; t++) trayCount(tester, t)], [6, 6, 6]);
    expect(k('fractionsOfASetChosenBadge-2'), findsOneWidget);
    expect(k('fractionsOfASetChosenBadge-1'), findsNothing);
  });
}
