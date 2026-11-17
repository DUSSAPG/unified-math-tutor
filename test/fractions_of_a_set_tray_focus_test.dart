import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/labs/fractions_of_a_set/fractions_of_a_set_screen.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';
import 'package:unified_math_tutor/widgets/labs/fractions_of_a_set/fractions_of_a_set_trays.dart';

/// Regression tests for the two 2026-11-17 Pixel UAT findings:
/// 1. a keyboard-focused tray shows an unmistakable ring drawn above the
///    tray, in light, dark and high contrast, distinct from every tray
///    state, with Tab, Enter and Space unchanged;
/// 2. every standalone take-one-out button, and every tray's take-one-out
///    action, names its own tray.
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

  Widget app(Widget home,
          {Locale locale = const Locale('en'),
          bool dark = false,
          bool highContrast = false}) =>
      MaterialApp(
        theme: dark ? AppTheme.dark() : AppTheme.light(),
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(highContrast: highContrast),
          child: child!,
        ),
        home: home,
      );

  Future<void> pump(WidgetTester tester,
      {Locale locale = const Locale('en'),
      bool dark = false,
      bool highContrast = false,
      Size size = const Size(411, 846)}) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(app(const FractionsOfASetScreen(seedForTesting: 0),
        locale: locale, dark: dark, highContrast: highContrast));
    await tester.pumpAndSettle();
  }

  Finder k(String key) => find.byKey(Key(key));

  /// Semantics nodes whose accessible name (label, or tooltip for icon
  /// buttons) is exactly [name].
  int named(WidgetTester tester, String name) {
    var count = 0;
    void visit(SemanticsNode n) {
      final d = n.getSemanticsData();
      if (d.label == name || d.tooltip == name) count++;
      n.visitChildren((c) {
        visit(c);
        return true;
      });
    }

    visit(tester
        .binding.renderViews.first.owner!.semanticsOwner!.rootSemanticsNode!);
    return count;
  }

  Future<void> tap(WidgetTester tester, Finder f) async {
    await tester.ensureVisible(f);
    await tester.pumpAndSettle();
    await tester.tap(f);
    await tester.pumpAndSettle();
  }

  Finder rings() => find.byWidgetPredicate((w) =>
      w.key is ValueKey<String> &&
      (w.key! as ValueKey<String>)
          .value
          .startsWith('fractionsOfASetTrayFocusRing-'));

  /// Tabs until tray [i]'s ink well has primary focus.
  Future<void> focusTray(WidgetTester tester, int i) async {
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

  /// The outer ring decoration and the halo decoration of tray [i].
  (BoxDecoration, BoxDecoration) ringOf(WidgetTester tester, int i) {
    final outer = tester
        .widget<DecoratedBox>(k('fractionsOfASetTrayFocusRing-$i'))
        .decoration as BoxDecoration;
    final halo = tester
        .widget<DecoratedBox>(find
            .descendant(
                of: k('fractionsOfASetTrayFocusRing-$i'),
                matching: find.byType(DecoratedBox))
            .last)
        .decoration as BoxDecoration;
    return (outer, halo);
  }

  /// The tray's own state outline colour.
  Color stateColour(WidgetTester tester, int i) {
    final box = tester.widget<Container>(k('fractionsOfASetTrayBox-$i'));
    return ((box.foregroundDecoration! as BoxDecoration).border! as Border)
        .top
        .color;
  }

  double luminance(Color c) => c.computeLuminance();
  double contrast(Color a, Color b) {
    final la = luminance(a), lb = luminance(b);
    return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
  }

  /// Moves the item 1 group phase (3 trays, 18 counters) to Take.
  Future<void> toTake(WidgetTester tester) async {
    while (tester.widget<OutlinedButton>(k('fractionsOfASetDeal')).onPressed !=
        null) {
      await tap(tester, k('fractionsOfASetDeal'));
    }
    await tap(tester, k('fractionsOfASetGroupsReady'));
  }

  group('focus ring', () {
    testWidgets(
        'appears only on the keyboard-focused tray, above and around it, '
        'unclipped and clear of neighbours', (tester) async {
      await pump(tester);
      await tap(tester, k('fractionsOfASetConfirm'));
      expect(rings(), findsNothing);

      await focusTray(tester, 2);
      expect(rings(), findsOneWidget);
      expect(k('fractionsOfASetTrayFocusRing-2'), findsOneWidget);

      // Around the tray: the ring encloses the tray box with a gap.
      final ring = tester.getRect(k('fractionsOfASetTrayFocusRing-2'));
      final box = tester.getRect(k('fractionsOfASetTrayBox-2'));
      expect(ring.left, lessThan(box.left));
      expect(ring.top, lessThan(box.top));
      expect(ring.right, greaterThan(box.right));
      expect(ring.bottom, greaterThan(box.bottom));

      // Above the tray: the ring is painted after the tray in its stack.
      final stack = tester.widget<Stack>(find
          .ancestor(
              of: k('fractionsOfASetTrayFocusRing-2'),
              matching: find.byType(Stack))
          .first);
      expect(stack.clipBehavior, Clip.none);
      expect(stack.children.last, isA<Positioned>());
      expect(
          find.descendant(
              of: find.byWidget(stack.children.first),
              matching: k('fractionsOfASetTrayBox-2')),
          findsOneWidget);

      // Never over a neighbouring tray, and inside the screen.
      for (final other in [1, 3]) {
        expect(
            ring.overlaps(tester.getRect(k('fractionsOfASetTrayBox-$other'))),
            isFalse,
            reason: 'tray $other');
      }
      expect(ring.left, greaterThanOrEqualTo(0));
      expect(ring.right, lessThanOrEqualTo(411));

      // The ring moves with focus.
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      expect(k('fractionsOfASetTrayFocusRing-2'), findsNothing);
    });

    testWidgets('touch input never shows the ring', (tester) async {
      await pump(tester);
      await tap(tester, k('fractionsOfASetConfirm'));
      await focusTray(tester, 1);
      expect(rings(), findsOneWidget);
      // A pointer tap switches to touch highlighting: the ring goes.
      await tap(tester, k('fractionsOfASetTray-2'));
      expect(rings(), findsNothing);
    });

    testWidgets('trays that are not targets never take focus or a ring',
        (tester) async {
      await pump(tester);
      // Answer phase: trays are shown but are not targets.
      final boxes = [
        for (var i = 1; i <= 3; i++)
          tester.getRect(k('fractionsOfASetTrayBox-$i')),
      ];
      expect(k('fractionsOfASetTray-1'), findsNothing);
      for (var n = 0; n < 30; n++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
        expect(rings(), findsNothing);
        final f = FocusManager.instance.primaryFocus;
        if (f != null) expect(boxes, isNot(contains(f.rect)));
      }
    });

    for (final (name, dark, hc) in [
      ('light', false, false),
      ('dark', true, false),
      ('light high contrast', false, true),
      ('dark high contrast', true, true),
    ]) {
      testWidgets('$name: ring colour, width and halo are high-contrast',
          (tester) async {
        await pump(tester, dark: dark, highContrast: hc);
        await tap(tester, k('fractionsOfASetConfirm'));
        await focusTray(tester, 1);
        final (outer, halo) = ringOf(tester, 1);
        final outerBorder = outer.border! as Border;
        final haloBorder = halo.border! as Border;
        expect(outerBorder.top.color, fosFocusRingColour(dark));
        expect(outerBorder.top.width, hc ? 4 : 3);
        expect(haloBorder.top.color, fosFocusHaloColour(dark));
        expect(haloBorder.top.width, fosFocusHaloWidth);

        final theme = Theme.of(tester.element(k('fractionsOfASetTray-1')));
        // The ring stands out from the page and the tray (≥ 3:1), and the
        // halo separates ring from tray.
        for (final bg in [
          theme.scaffoldBackgroundColor,
          theme.colorScheme.surface,
        ]) {
          expect(contrast(outerBorder.top.color, bg), greaterThanOrEqualTo(3),
              reason: '$name ring vs $bg');
        }
        expect(contrast(outerBorder.top.color, haloBorder.top.color),
            greaterThanOrEqualTo(7));
      });
    }

    for (final dark in [false, true]) {
      testWidgets(
          '${dark ? 'dark' : 'light'} screen: a selected tray keeps its '
          'selected outline under a distinct focus ring', (tester) async {
        await pump(tester, dark: dark, highContrast: dark);
        await tap(tester, k('fractionsOfASetConfirm'));
        await toTake(tester);
        await focusTray(tester, 3);
        final idle = stateColour(tester, 3);
        await tester.sendKeyEvent(LogicalKeyboardKey.space);
        await tester.pumpAndSettle();
        expect(k('fractionsOfASetTrayFocusRing-3'), findsOneWidget);
        final selected = stateColour(tester, 3);
        expect(selected, isNot(idle));
        expect(
            selected,
            Theme.of(tester.element(k('fractionsOfASetTray-3')))
                .colorScheme
                .primary);
        expect(fosFocusRingColour(dark), isNot(selected));
      });
    }

    // Every tray state, with every tray a target so each can take focus.
    for (final (name, dark, hc) in [
      ('light', false, false),
      ('dark', true, false),
      ('light high contrast', false, true),
      ('dark high contrast', true, true),
    ]) {
      testWidgets(
          '$name: ring is distinct from idle, selected, different and equal '
          'trays, whose outlines stay unchanged under it', (tester) async {
        final l = lookupAppLocalizations(const Locale('en'));
        tester.view.physicalSize = const Size(411, 846);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        const states = [
          FosTrayState(count: 2),
          FosTrayState(count: 2, chosen: true),
          FosTrayState(count: 3, differs: true),
          FosTrayState(count: 2, equalMark: true),
        ];
        await tester.pumpWidget(app(
          Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: FosTrayGrid(
                trays: states,
                control: FosTrayControl.none,
                labelFor: (i) => l.labsFractionsOfASetTray(4, 2, i + 1),
                takeOneOutLabelFor: (i) =>
                    l.labsFractionsOfASetTakeOneOutOfTray(i + 1),
                chosenLabel: l.labsFractionsOfASetChosen,
                differentLabel: l.labsFractionsOfASetDifferent,
                onActivate: (_) {},
                onTakeOneOut: null,
                showSelected: true,
              ),
            ),
          ),
          dark: dark,
          highContrast: hc,
        ));
        await tester.pumpAndSettle();

        final ringColour = fosFocusRingColour(dark);
        final before = [for (var i = 1; i <= 4; i++) stateColour(tester, i)];
        // The four states are themselves distinct.
        expect(before.toSet(), hasLength(4));
        for (var i = 1; i <= 4; i++) {
          await focusTray(tester, i);
          expect(rings(), findsOneWidget, reason: '$name tray $i');
          expect(k('fractionsOfASetTrayFocusRing-$i'), findsOneWidget);
          expect(stateColour(tester, i), before[i - 1],
              reason: '$name tray $i state outline unchanged under focus');
          expect(ringColour, isNot(before[i - 1]), reason: '$name tray $i');
          final (outer, _) = ringOf(tester, i);
          expect((outer.border! as Border).top.width, hc ? 4 : 3);
          // Outside the tray, so the state outline is never covered.
          final ring = tester.getRect(k('fractionsOfASetTrayFocusRing-$i'));
          final box = tester.getRect(k('fractionsOfASetTrayBox-$i'));
          expect(ring.deflate(fosFocusRingWidth(hc) + fosFocusHaloWidth), box);
        }
      });
    }

    testWidgets('landscape: a top-row ring is not clipped by the tray scroll',
        (tester) async {
      await pump(tester, size: const Size(915, 412), highContrast: true);
      await tap(tester, k('fractionsOfASetConfirm'));
      await focusTray(tester, 1);
      final ring = tester.getRect(k('fractionsOfASetTrayFocusRing-1'));
      final viewport = tester.getRect(k('fractionsOfASetTrayScroll'));
      expect(viewport.contains(ring.topLeft), isTrue);
      expect(viewport.contains(ring.bottomRight - const Offset(1, 1)), isTrue);
    });
  });

  group('keyboard', () {
    testWidgets('Tab visits the trays in order; Enter and Space activate',
        (tester) async {
      await pump(tester);
      await tap(tester, k('fractionsOfASetConfirm'));

      final order = <int>[];
      for (var n = 0; n < 40 && order.length < 3; n++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
        final f = FocusManager.instance.primaryFocus;
        for (var i = 1; i <= 3; i++) {
          if (f != null &&
              f.rect == tester.getRect(k('fractionsOfASetTray-$i')) &&
              !order.contains(i)) {
            order.add(i);
          }
        }
      }
      expect(order, [1, 2, 3]);

      final sem = tester.getSemantics(k('fractionsOfASetTraySemantics-3'));
      expect(sem.label, 'Tray 3 of 3: empty');
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(tester.getSemantics(k('fractionsOfASetTraySemantics-3')).label,
          'Tray 3 of 3: 1 counter');
      expect(k('fractionsOfASetTrayFocusRing-3'), findsOneWidget,
          reason: 'focus and ring stay after Enter');
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      expect(tester.getSemantics(k('fractionsOfASetTraySemantics-3')).label,
          'Tray 3 of 3: 2 counters');
      expect(k('fractionsOfASetTrayFocusRing-3'), findsOneWidget);
    });
  });

  group('take-one-out names its tray', () {
    for (final locale in locales) {
      testWidgets('$locale: every button and tray action is unique',
          (tester) async {
        await pump(tester, locale: locale);
        final l = lookupAppLocalizations(locale);
        await tap(tester, k('fractionsOfASetConfirm'));
        // One counter in every tray so every control is live.
        await tap(tester, k('fractionsOfASetDeal'));

        final buttonLabels = <String>{};
        for (var i = 1; i <= 3; i++) {
          final expected = l.labsFractionsOfASetTakeOneOutOfTray(i);
          expect(expected, contains('$i'));
          final button =
              tester.widget<IconButton>(k('fractionsOfASetTakeOneOut-$i'));
          expect(button.tooltip, expected);
          expect(named(tester, expected), 1, reason: '$locale button $i');
          buttonLabels.add(expected);

          final sem = tester.getSemantics(k('fractionsOfASetTraySemantics-$i'));
          final ids = sem.getSemanticsData().customSemanticsActionIds!;
          expect(ids.map((id) => CustomSemanticsAction.getAction(id)!.label),
              [expected],
              reason: '$locale tray $i action');
        }
        expect(buttonLabels, hasLength(3));
      });
    }

    testWidgets('a ten-tray grid gives ten distinct button names',
        (tester) async {
      final l = lookupAppLocalizations(const Locale('en'));
      tester.view.physicalSize = const Size(411, 846);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final taken = <int>[];
      await tester.pumpWidget(app(Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: FosTrayGrid(
            trays: [
              for (var i = 0; i < 10; i++)
                const FosTrayState(count: 2, canTakeOneOut: true),
            ],
            control: FosTrayControl.takeOneOut,
            labelFor: (i) => l.labsFractionsOfASetTray(10, 2, i + 1),
            takeOneOutLabelFor: (i) =>
                l.labsFractionsOfASetTakeOneOutOfTray(i + 1),
            chosenLabel: l.labsFractionsOfASetChosen,
            differentLabel: l.labsFractionsOfASetDifferent,
            onActivate: (_) {},
            onTakeOneOut: taken.add,
          ),
        ),
      )));
      await tester.pumpAndSettle();

      final names = <String>{};
      for (var i = 1; i <= 10; i++) {
        final name = 'Take one out of tray $i';
        expect(named(tester, name), 1, reason: name);
        names.add(name);
      }
      expect(names, hasLength(10));
      expect(named(tester, 'Take one out'), 0);

      // Each button and each tray action acts on its own tray only.
      await tester.ensureVisible(k('fractionsOfASetTakeOneOut-7'));
      await tester.tap(k('fractionsOfASetTakeOneOut-7'));
      expect(taken, [6]);
      final sem = tester.getSemantics(k('fractionsOfASetTraySemantics-9'));
      final id = sem.getSemanticsData().customSemanticsActionIds!.single;
      expect(
          CustomSemanticsAction.getAction(id)!.label, 'Take one out of tray 9');
      tester.binding.renderViews.first.owner!.semanticsOwner!
          .performAction(sem.id, SemanticsAction.customAction, id);
      expect(taken, [6, 8]);
    });

    testWidgets('tray action semantics are otherwise unchanged',
        (tester) async {
      await pump(tester);
      await tap(tester, k('fractionsOfASetConfirm'));
      final owner = tester.binding.renderViews.first.owner!.semanticsOwner!;
      SemanticsNode tray(int i) =>
          tester.getSemantics(k('fractionsOfASetTraySemantics-$i'));

      // Empty tray: tap adds, no take-one-out action.
      expect(tray(2).getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
      expect(
          tray(2).getSemanticsData().customSemanticsActionIds ?? [], isEmpty);
      owner.performAction(tray(2).id, SemanticsAction.tap);
      await tester.pumpAndSettle();
      expect(tray(2).label, 'Tray 2 of 3: 1 counter');

      // Filled tray: the named action removes one from that tray only.
      final id = tray(2).getSemanticsData().customSemanticsActionIds!.single;
      owner.performAction(tray(2).id, SemanticsAction.customAction, id);
      await tester.pumpAndSettle();
      expect(tray(2).label, 'Tray 2 of 3: empty');
      expect(tray(1).label, 'Tray 1 of 3: empty');

      // Take phase: no take-one-out actions remain; selection is exposed.
      await toTake(tester);
      for (var i = 1; i <= 3; i++) {
        expect(
            tray(i).getSemanticsData().customSemanticsActionIds ?? [], isEmpty);
      }
      expect(k('fractionsOfASetTakeOneOut-1'), findsNothing);
    });
  });
}
