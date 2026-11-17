import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/fractions_of_a_set/fractions_of_a_set_session.dart';
import 'package:unified_math_tutor/screens/labs/fractions_of_a_set/fractions_of_a_set_screen.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';
import 'package:unified_math_tutor/widgets/labs/fractions_of_a_set/fractions_of_a_set_bar.dart';

/// Screen-reader semantics in all five governed locales (brief §8 group 3):
/// before an answer locks no semantics state the answer; trays carry their
/// counts and chosen, selected and different states; Take one out is a
/// visible control and a custom action in Group only; tray activate is
/// absent when the collection is empty; the collection deals a round;
/// steppers carry Increase and Decrease; fractions are spoken in words with
/// no sentinel leak; targets are at least 48 dp; counters are not targets;
/// the live region states what is left to place.
void main() {
  const locales = [
    Locale('en'),
    Locale('en', 'GB'),
    Locale('de', 'CH'),
    Locale('fr', 'CH'),
    Locale('it', 'CH'),
  ];

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
  });

  Future<void> pump(WidgetTester tester, Locale locale, {int seed = 0}) async {
    tester.view.physicalSize = const Size(411, 846);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.light(),
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: FractionsOfASetScreen(seedForTesting: seed),
    ));
    await tester.pumpAndSettle();
  }

  Finder k(String key) => find.byKey(Key(key));
  bool present(String key) => k(key).evaluate().isNotEmpty;

  Future<void> tap(WidgetTester tester, Finder f) async {
    await tester.ensureVisible(f);
    await tester.pumpAndSettle();
    await tester.tap(f);
    await tester.pumpAndSettle();
  }

  SemanticsOwner owner(WidgetTester tester) =>
      tester.binding.renderViews.first.owner!.semanticsOwner!;

  /// Every node in the tree.
  List<SemanticsNode> nodes(WidgetTester tester) {
    final out = <SemanticsNode>[];
    void visit(SemanticsNode n) {
      out.add(n);
      n.visitChildren((c) {
        visit(c);
        return true;
      });
    }

    visit(owner(tester).rootSemanticsNode!);
    return out;
  }

  /// Every label, value, hint, tooltip and custom-action label.
  List<String> strings(WidgetTester tester) {
    final out = <String>[];
    for (final n in nodes(tester)) {
      final d = n.getSemanticsData();
      for (final s in [
        d.label,
        d.value,
        d.hint,
        d.increasedValue,
        d.decreasedValue,
        d.tooltip,
      ]) {
        if (s.isNotEmpty) out.add(s);
      }
      for (final id in d.customSemanticsActionIds ?? const <int>[]) {
        final label = CustomSemanticsAction.getAction(id)?.label;
        if (label != null) out.add(label);
      }
    }
    return out;
  }

  void noSentinel(WidgetTester tester, String where) {
    for (final s in strings(tester)) {
      expect(s.contains(fosSentinelA) || s.contains(fosSentinelB), isFalse,
          reason: '$where: sentinel in "$s"');
    }
    for (final t in tester.widgetList<Text>(find.byType(Text))) {
      final plain = t.data ?? t.textSpan?.toPlainText() ?? '';
      expect(
          plain.contains(fosSentinelA) || plain.contains(fosSentinelB), isFalse,
          reason: '$where: sentinel in rendered "$plain"');
    }
  }

  bool mentions(Iterable<String> all, int value) =>
      all.any((s) => RegExp('(?<![\\d])$value(?![\\d])').hasMatch(s));

  SemanticsNode tray(WidgetTester tester, int i) =>
      tester.getSemantics(k('fractionsOfASetTraySemantics-$i'));

  /// Finishes the tray steps of a U or N item from the Group phase.
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

  for (final locale in locales) {
    final l = lookupAppLocalizations(locale);

    testWidgets(
        '$locale: no answer in semantics before it locks; fractions in '
        'words; no sentinel anywhere', (tester) async {
      await pump(tester, locale);
      final deck = fosDeck(0);

      // Slot 1, U 1/3 of 18 = 6.
      var all = strings(tester);
      expect(
          all,
          contains(l.labsFractionsOfASetPromptFind(
              18, l.labsFractionsOfASetThirds(1))));
      expect(mentions(all, 6), isFalse, reason: 'U answer 6 leaked: $all');
      noSentinel(tester, 'slot 1');
      // Negative control: once locked and revealed, the answer is spoken.
      await tap(tester, k('fractionsOfASetConfirm'));
      noSentinel(tester, 'slot 1 group');
      await finishTrays(tester, 1);
      all = strings(tester);
      expect(
          all,
          contains(l.labsFractionsOfASetRevealFind(
              18, 6, l.labsFractionsOfASetThirds(1))));
      expect(mentions(all, 6), isTrue);
      noSentinel(tester, 'slot 1 reveal');
      await tap(tester, k('fractionsOfASetNext'));

      // Slot 2, N 5/10 of 30 = 15.
      all = strings(tester);
      expect(mentions(all, 15), isFalse, reason: 'N answer 15 leaked');
      expect(
          all,
          contains(l.labsFractionsOfASetPromptFind(
              30, l.labsFractionsOfASetTenths(5))));
      await tap(tester, k('fractionsOfASetConfirm'));
      await finishTrays(tester, 5);
      noSentinel(tester, 'slot 2 reveal');
      await tap(tester, k('fractionsOfASetNext'));

      // Slot 3, E: tray counts are the question, so they are announced.
      expect(tray(tester, 4).label, l.labsFractionsOfASetTray(10, 1, 4));
      await tap(tester, k('fractionsOfASetNo'));
      await tap(tester, k('fractionsOfASetConfirm'));
      expect(tray(tester, 4).label,
          '${l.labsFractionsOfASetTray(10, 1, 4)}, ${l.labsFractionsOfASetDifferent}');
      expect(tray(tester, 2).label, l.labsFractionsOfASetTray(10, 2, 2));
      await tap(tester, k('fractionsOfASetNext'));

      // Slot 4, W 4 of 12 → 1/3: no group structure before it locks.
      final w = deck[3].find!;
      all = strings(tester);
      expect(
          all.any((s) => s.contains(l.labsFractionsOfASetThirds(1))), isFalse,
          reason: 'W fraction leaked: $all');
      for (var i = 1; i <= w.d; i++) {
        expect(all, isNot(contains(l.labsFractionsOfASetTray(w.d, w.g, i))));
      }
      expect(present('fractionsOfASetTraySemantics-1'), isFalse);
      expect(all, contains(l.labsFractionsOfASetOutOfGroups(3)));
      expect(all, contains(l.labsFractionsOfASetTopNumber));
      await tap(tester, k('fractionsOfASetConfirm'));
      expect(tray(tester, 1).label,
          '${l.labsFractionsOfASetTray(3, 4, 1)}, ${l.labsFractionsOfASetChosen}');
      expect(tray(tester, 1).getSemanticsData().flagsCollection.isSelected,
          Tristate.isTrue);
      expect(tray(tester, 2).getSemanticsData().flagsCollection.isSelected,
          Tristate.isFalse);
      noSentinel(tester, 'slot 4 reveal');
      await tap(tester, k('fractionsOfASetNext'));

      // Slot 5, C 1/2 vs 1/3 of 30: neither value (15, 10) before it locks.
      all = strings(tester);
      expect(mentions(all, 15) || mentions(all, 10), isFalse,
          reason: 'C value leaked: $all');
      expect(tester.getSemantics(k('fractionsOfASetOptionFirst')).label,
          l.labsFractionsOfASetHalves(1));
      expect(tester.getSemantics(k('fractionsOfASetOptionSecond')).label,
          l.labsFractionsOfASetThirds(1));
      noSentinel(tester, 'slot 5');
      await tap(tester, k('fractionsOfASetOptionFirst'));
      expect(
          tester
              .getSemantics(k('fractionsOfASetOptionFirst'))
              .getSemanticsData()
              .flagsCollection
              .isSelected,
          Tristate.isTrue);
      await tap(tester, k('fractionsOfASetConfirm'));
      expect(
          strings(tester),
          contains(l.labsFractionsOfASetRevealCompare(30, 15, 10,
              l.labsFractionsOfASetHalves(1), l.labsFractionsOfASetThirds(1))));
      await tap(tester, k('fractionsOfASetNext'));

      // Slot 6, N 8/10 of 20 = 16.
      expect(mentions(strings(tester), 16), isFalse);
      await tap(tester, k('fractionsOfASetConfirm'));
      await finishTrays(tester, 8);
      await tap(tester, k('fractionsOfASetNext'));
      await tap(tester, k('fractionsOfASetYes'));
      await tap(tester, k('fractionsOfASetConfirm'));
      await tap(tester, k('fractionsOfASetNext'));

      // Slot 8, X 3/5 of 20 = 12.
      all = strings(tester);
      expect(mentions(all, 12), isFalse, reason: 'X answer 12 leaked');
      expect(
          all,
          contains(l.labsFractionsOfASetPromptTransfer(
              20, l.labsFractionsOfASetFifths(3))));
      noSentinel(tester, 'slot 8');
    });
  }

  final l = lookupAppLocalizations(const Locale('en'));

  testWidgets(
      'group phase: tray actions, Take one out, collection deal, '
      'live region', (tester) async {
    await pump(tester, const Locale('en'));
    // Predict: trays are not buttons.
    expect(tray(tester, 1).getSemanticsData().hasAction(SemanticsAction.tap),
        isFalse);
    expect(tray(tester, 1).label, 'Tray 1 of 3: empty');
    expect(present('fractionsOfASetTakeOneOut-1'), isFalse);
    await tap(tester, k('fractionsOfASetConfirm'));

    // Group: tray activate adds one; no Take one out on an empty tray.
    expect(tray(tester, 1).getSemanticsData().hasAction(SemanticsAction.tap),
        isTrue);
    expect(tray(tester, 1).getSemanticsData().customSemanticsActionIds ?? [],
        isEmpty);
    owner(tester).performAction(tray(tester, 1).id, SemanticsAction.tap);
    await tester.pumpAndSettle();
    expect(tray(tester, 1).label, 'Tray 1 of 3: 1 counter');

    // Take one out: a visible 48 dp control and a custom action.
    final ids = tray(tester, 1).getSemanticsData().customSemanticsActionIds!;
    expect(ids.map((id) => CustomSemanticsAction.getAction(id)!.label),
        ['Take one out of tray 1']);
    final takeOut = tester.widget<IconButton>(k('fractionsOfASetTakeOneOut-1'));
    expect(takeOut.tooltip, 'Take one out of tray 1');
    expect(takeOut.onPressed, isNotNull);
    expect(
        tester.widget<IconButton>(k('fractionsOfASetTakeOneOut-2')).onPressed,
        isNull);
    owner(tester).performAction(
        tray(tester, 1).id, SemanticsAction.customAction, ids.single);
    await tester.pumpAndSettle();
    expect(tray(tester, 1).label, 'Tray 1 of 3: empty');

    // The collection's activate deals one round.
    final collection =
        tester.getSemantics(k('fractionsOfASetCollectionSemantics'));
    expect(collection.label, 'Collection: 18 counters to place');
    expect(
        collection.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
    owner(tester).performAction(collection.id, SemanticsAction.tap);
    await tester.pumpAndSettle();
    for (var i = 1; i <= 3; i++) {
      expect(tray(tester, i).label, 'Tray $i of 3: 1 counter');
    }

    // Live region: one node, updated per change.
    final live = nodes(tester)
        .where((n) => n.label == '15 counters left to place')
        .toList();
    expect(live, hasLength(1));
    expect(live.single.getSemanticsData().flagsCollection.isLiveRegion, isTrue);

    // Collection empty: no tray activate, no collection activate.
    while (tester.widget<OutlinedButton>(k('fractionsOfASetDeal')).onPressed !=
        null) {
      await tap(tester, k('fractionsOfASetDeal'));
    }
    expect(tray(tester, 1).getSemanticsData().hasAction(SemanticsAction.tap),
        isFalse);
    expect(
        tester
            .getSemantics(k('fractionsOfASetCollectionSemantics'))
            .getSemanticsData()
            .hasAction(SemanticsAction.tap),
        isFalse);
    expect(nodes(tester).where((n) => n.label == 'Every counter is placed.'),
        hasLength(1));
    expect(
        tray(tester, 1).getSemanticsData().customSemanticsActionIds, isNotEmpty,
        reason: 'Take one out stays available on a filled tray');

    // Take: tray activate toggles chosen; Take one out is gone.
    await tap(tester, k('fractionsOfASetGroupsReady'));
    expect(present('fractionsOfASetTakeOneOut-1'), isFalse);
    expect(tray(tester, 1).getSemanticsData().customSemanticsActionIds ?? [],
        isEmpty);
    expect(tray(tester, 1).getSemanticsData().flagsCollection.isSelected,
        isNot(Tristate.none));
    owner(tester).performAction(tray(tester, 2).id, SemanticsAction.tap);
    await tester.pumpAndSettle();
    expect(tray(tester, 2).label, 'Tray 2 of 3: 6 counters, chosen');
    expect(tray(tester, 2).getSemanticsData().flagsCollection.isSelected,
        Tristate.isTrue);
  });

  testWidgets('steppers and picker carry Increase and Decrease',
      (tester) async {
    await pump(tester, const Locale('en'));
    void check(String key) {
      final node = tester.getSemantics(k(key));
      expect(
          node.getSemanticsData().hasAction(SemanticsAction.increase), isTrue);
      final inc = tester.widget<IconButton>(
          find.descendant(of: k(key), matching: k('increase')));
      final dec = tester.widget<IconButton>(
          find.descendant(of: k(key), matching: k('decrease')));
      expect(inc.tooltip, l.labsFractionsOfASetStepperIncrease);
      expect(dec.tooltip, l.labsFractionsOfASetStepperDecrease);
    }

    check('fractionsOfASetPrediction');
    final node = tester.getSemantics(k('fractionsOfASetPrediction'));
    expect(node.label, 'Your answer');
    expect(node.value, '0');
    expect(
        node.getSemanticsData().hasAction(SemanticsAction.decrease), isFalse);
    owner(tester).performAction(node.id, SemanticsAction.increase);
    await tester.pumpAndSettle();
    expect(tester.getSemantics(k('fractionsOfASetPrediction')).value, '1');

    // Seed 0, slot 4 is the W picker.
    await tap(tester, k('fractionsOfASetConfirm'));
    await finishTrays(tester, 1);
    await tap(tester, k('fractionsOfASetNext'));
    await tap(tester, k('fractionsOfASetConfirm'));
    await finishTrays(tester, 5);
    await tap(tester, k('fractionsOfASetNext'));
    await tap(tester, k('fractionsOfASetYes'));
    await tap(tester, k('fractionsOfASetConfirm'));
    await tap(tester, k('fractionsOfASetNext'));
    check('fractionsOfASetTopNumber');
    expect(
        tester.getSemantics(k('fractionsOfASetTopNumber')).label, 'Top number');
  });

  testWidgets('every target is at least 48 × 48; counters are not targets',
      (tester) async {
    await pump(tester, const Locale('en'));
    void targets(String where) {
      for (final n in nodes(tester)) {
        final d = n.getSemanticsData();
        final tappable = d.hasAction(SemanticsAction.tap) ||
            d.hasAction(SemanticsAction.increase) ||
            d.hasAction(SemanticsAction.decrease);
        if (!tappable) continue;
        expect(n.rect.width, greaterThanOrEqualTo(48),
            reason: '$where: "${d.label}" ${n.rect}');
        expect(n.rect.height, greaterThanOrEqualTo(48),
            reason: '$where: "${d.label}" ${n.rect}');
      }
    }

    targets('predict');
    await tap(tester, k('fractionsOfASetConfirm'));
    targets('group');
    // Tapping a counter inside a filled tray hits the tray, never a
    // counter: the tray count rises by exactly one.
    await tap(tester, k('fractionsOfASetTray-1'));
    final box = tester.getRect(k('fractionsOfASetTrayBox-1'));
    await tester.tapAt(box.topLeft + const Offset(16, 40));
    await tester.pumpAndSettle();
    expect(tray(tester, 1).label, 'Tray 1 of 3: 2 counters');
    await tap(tester, k('fractionsOfASetStartAgain'));
    await finishTrays(tester, 1);
    targets('reveal');
    await tap(tester, k('fractionsOfASetNext'));
    await tap(tester, k('fractionsOfASetConfirm'));
    await finishTrays(tester, 5);
    await tap(tester, k('fractionsOfASetNext'));
    await tap(tester, k('fractionsOfASetYes'));
    targets('E');
    await tap(tester, k('fractionsOfASetConfirm'));
    await tap(tester, k('fractionsOfASetNext'));

    // W: the collection is visual only. Tapping a counter changes nothing
    // and exposes no node.
    targets('W');
    expect(present('fractionsOfASetCollection'), isFalse);
    expect(present('fractionsOfASetCollectionSemantics'), isFalse);
    final before = strings(tester);
    await tester.tapAt(
        tester.getRect(k('fractionsOfASetCollectionBox')).topLeft +
            const Offset(16, 16));
    await tester.pumpAndSettle();
    expect(strings(tester), before);
    await tap(tester, k('fractionsOfASetConfirm'));
    await tap(tester, k('fractionsOfASetNext'));
    targets('C');
  });

  testWidgets('keyboard: Tab reaches the trays; Enter adds and toggles',
      (tester) async {
    await pump(tester, const Locale('en'));
    await tap(tester, k('fractionsOfASetConfirm'));

    /// Tabs until the tray's ink well has focus.
    Future<void> focusTray(int i) async {
      for (var n = 0; n < 60; n++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
        final focused = FocusManager.instance.primaryFocus;
        if (focused != null &&
            focused.rect == tester.getRect(k('fractionsOfASetTray-$i'))) {
          return;
        }
      }
      fail('tray $i never took focus');
    }

    await focusTray(2);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(tray(tester, 2).label, 'Tray 2 of 3: 1 counter');
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(tray(tester, 2).label, 'Tray 2 of 3: 2 counters');

    await tap(tester, k('fractionsOfASetStartAgain'));
    while (tester.widget<OutlinedButton>(k('fractionsOfASetDeal')).onPressed !=
        null) {
      await tap(tester, k('fractionsOfASetDeal'));
    }
    await tap(tester, k('fractionsOfASetGroupsReady'));
    await focusTray(3);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(tray(tester, 3).label, 'Tray 3 of 3: 6 counters, chosen');
  });
}
