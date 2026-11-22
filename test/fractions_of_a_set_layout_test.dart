import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/fractions_of_a_set/fractions_of_a_set_session.dart';
import 'package:unified_math_tutor/screens/labs/fractions_of_a_set/fractions_of_a_set_screen.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';
import 'package:unified_math_tutor/widgets/labs/fractions_of_a_set/fractions_of_a_set_trays.dart';

/// Fractions of a Set stays usable across widths, orientations, themes,
/// text sizes and contrast (brief §8 group 4): no overflow, counters never
/// below 24 dp, every control of all eight items reachable and genuinely
/// tappable, the no-scroll phases of errata I-2 at 360 × 640, and reveals
/// that bring the feedback and Next into view.
void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
  });

  Future<void> pump(
    WidgetTester tester, {
    required Size size,
    double textScale = 1,
    bool dark = false,
    bool highContrast = false,
    int seed = 0,
    Locale locale = const Locale('en'),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(textScale),
          highContrast: highContrast,
        ),
        child: child!,
      ),
      home: FractionsOfASetScreen(seedForTesting: seed),
    ));
    await tester.pumpAndSettle();
  }

  Finder k(String key) => find.byKey(Key(key));
  bool present(String key) => k(key).evaluate().isNotEmpty;

  Future<void> tapVisible(WidgetTester tester, Finder f) async {
    await tester.ensureVisible(f);
    await tester.pumpAndSettle();
    await tester.tap(f);
    await tester.pumpAndSettle();
  }

  bool enabled(WidgetTester tester, String key) {
    final w = tester.widget(k(key));
    return switch (w) {
      OutlinedButton(:final onPressed) => onPressed != null,
      FilledButton(:final onPressed) => onPressed != null,
      _ => throw StateError(key),
    };
  }

  ScrollPosition panel(WidgetTester tester) => tester
      .widget<SingleChildScrollView>(k('fractionsOfASetPanelScroll'))
      .controller!
      .position;

  /// Answers the current item touching every control type on the way.
  Future<void> walkItem(WidgetTester tester, {bool checkReveal = true}) async {
    final size = tester.view.physicalSize;
    if (present('fractionsOfASetYes')) {
      await tapVisible(tester, k('fractionsOfASetNo'));
      await tapVisible(tester, k('fractionsOfASetYes'));
    } else if (present('fractionsOfASetOptionFirst')) {
      await tapVisible(tester, k('fractionsOfASetOptionSame'));
      await tapVisible(tester, k('fractionsOfASetOptionSecond'));
      await tapVisible(tester, k('fractionsOfASetOptionFirst'));
    } else {
      final s = present('fractionsOfASetTopNumber')
          ? 'fractionsOfASetTopNumber'
          : 'fractionsOfASetPrediction';
      final inc = find.descendant(of: k(s), matching: k('increase'));
      final dec = find.descendant(of: k(s), matching: k('decrease'));
      await tapVisible(tester, inc);
      await tapVisible(tester, inc);
      await tapVisible(tester, dec);
    }
    await tapVisible(tester, k('fractionsOfASetConfirm'));
    if (present('fractionsOfASetDeal')) {
      // Group: every control.
      await tapVisible(tester, k('fractionsOfASetTray-1'));
      await tapVisible(tester, k('fractionsOfASetTakeOneOut-1'));
      await tapVisible(tester, k('fractionsOfASetCollection'));
      await tapVisible(tester, k('fractionsOfASetStartAgain'));
      await tapVisible(tester, k('fractionsOfASetTray-2'));
      while (enabled(tester, 'fractionsOfASetDeal')) {
        await tapVisible(tester, k('fractionsOfASetDeal'));
      }
      await tapVisible(tester, k('fractionsOfASetGroupsReady'));
      // One extra in tray 2 then dealing leaves unequal trays, except with
      // two trays, where the last partial round evens them out.
      if (present('fractionsOfASetGroupNotice')) {
        await tapVisible(tester, k('fractionsOfASetTakeOneOut-2'));
        await tapVisible(tester, k('fractionsOfASetStartAgain'));
        while (enabled(tester, 'fractionsOfASetDeal')) {
          await tapVisible(tester, k('fractionsOfASetDeal'));
        }
        await tapVisible(tester, k('fractionsOfASetGroupsReady'));
      }
      expect(k('fractionsOfASetTakeConfirm'), findsOneWidget);
      // Take: add trays until the count is right.
      for (var t = 1; !present('fractionsOfASetNext'); t++) {
        await tapVisible(tester, k('fractionsOfASetTray-$t'));
        await tapVisible(tester, k('fractionsOfASetTakeConfirm'));
      }
    }
    if (checkReveal) {
      // The reveal scrolled the feedback card and Next fully into view.
      final screen = Offset.zero & size;
      final next = tester.getRect(k('fractionsOfASetNext'));
      expect(screen.contains(next.topLeft), isTrue, reason: '$next');
      expect(screen.contains(next.bottomRight - const Offset(1, 1)), isTrue,
          reason: '$next');
    }
    await tapVisible(tester, k('fractionsOfASetNext'));
  }

  test('counters and tray boxes keep their minimum sizes', () {
    expect(fosCounterSize, 24);
    expect(fosTrayBoxHeight, 112);
    expect(fosTrayControlHeight, 48);
    expect(fosTrayMinWidth, greaterThanOrEqualTo(2 * fosCounterSize + 4));
  });

  test('tray grid columns follow contract §9.3, fewer only when too narrow',
      () {
    for (final (d, cols) in const [
      (2, 2),
      (3, 3),
      (4, 4),
      (5, 5),
      (6, 3),
      (8, 4),
      (10, 5),
    ]) {
      expect(fosColumnsFor(d, 328), cols, reason: 'd $d at 360 dp');
    }
    expect(fosColumnsFor(5, 288), 4, reason: '320 dp keeps trays ≥ 60 dp');
  });

  for (final (name, size, scale, dark, contrast) in [
    ('portrait-320', const Size(320, 568), 1.0, false, false),
    ('portrait-360', const Size(360, 640), 1.0, false, false),
    ('portrait-411', const Size(411, 846), 1.0, false, false),
    ('portrait-360-max-text', const Size(360, 640), 1.15, false, false),
    ('portrait-320-max-text', const Size(320, 568), 1.15, false, false),
    ('landscape-360', const Size(780, 360), 1.0, false, false),
    ('landscape-360-max-text', const Size(780, 360), 1.15, false, false),
    ('short-landscape', const Size(640, 360), 1.0, false, false),
    ('dark', const Size(360, 640), 1.0, true, false),
    ('dark-landscape', const Size(780, 360), 1.0, true, false),
    ('high-contrast', const Size(360, 640), 1.0, false, true),
    ('high-contrast-dark', const Size(411, 846), 1.0, true, true),
    ('large-text', const Size(411, 846), 2.0, false, false),
  ]) {
    testWidgets('layout: $name', (tester) async {
      final previous = WidgetController.hitTestWarningShouldBeFatal;
      WidgetController.hitTestWarningShouldBeFatal = true;
      addTearDown(
          () => WidgetController.hitTestWarningShouldBeFatal = previous);
      await pump(tester,
          size: size, textScale: scale, dark: dark, highContrast: contrast);
      expect(tester.takeException(), isNull);
      final landscape = size.width > size.height;
      for (var i = 0; i < 8; i++) {
        final it = fosDeck(0)[i];
        if (it.trayCount > 0) {
          expect(
              k(landscape
                  ? 'fractionsOfASetLandscapeLayout'
                  : 'fractionsOfASetPortraitLayout'),
              findsOneWidget,
              reason: '$name slot ${i + 1}');
        }
        await walkItem(tester);
        expect(tester.takeException(), isNull, reason: '$name item ${i + 1}');
      }
      await tapVisible(tester, k('fractionsOfASetExploreAgain'));
      expect(tester.takeException(), isNull, reason: name);
    });
  }

  testWidgets('landscape: trays left, controls right, each scrolling',
      (tester) async {
    await pump(tester, size: const Size(780, 360));
    await tapVisible(tester, k('fractionsOfASetConfirm'));
    final trays = tester.getRect(k('fractionsOfASetTrays'));
    final deal = tester.getRect(k('fractionsOfASetDeal'));
    expect(trays.right, lessThanOrEqualTo(deal.left));
    expect(k('fractionsOfASetTrayScroll'), findsOneWidget);
    expect(k('fractionsOfASetPanelScroll'), findsOneWidget);
  });

  group('360 × 640, default text: no scroll in the I-2 phases', () {
    /// First seed whose slot-1 unit item has [d] trays, preferring the
    /// largest collection.
    int seedForUnit(int d) {
      var best = -1, bestTotal = -1;
      for (var seed = 0; seed < 3000; seed++) {
        final f = fosDeck(seed)[0].find!;
        if (f.d == d && f.total > bestTotal) {
          best = seed;
          bestTotal = f.total;
        }
      }
      return best;
    }

    for (final d in fosDenominators) {
      testWidgets(
          'd = $d: Group ${d <= 5 ? "fits" : "may scroll"}; '
          'Take fits', (tester) async {
        final seed = seedForUnit(d);
        expect(seed, isNonNegative);
        await pump(tester, size: const Size(360, 640), seed: seed);
        await tapVisible(tester, k('fractionsOfASetConfirm'));
        if (d <= 5) {
          expect(panel(tester).maxScrollExtent, 0,
              reason: 'Group, d = $d, T = ${fosDeck(seed)[0].total}');
        }
        while (enabled(tester, 'fractionsOfASetDeal')) {
          await tapVisible(tester, k('fractionsOfASetDeal'));
        }
        await tapVisible(tester, k('fractionsOfASetGroupsReady'));
        expect(k('fractionsOfASetTakeConfirm'), findsOneWidget);
        expect(panel(tester).maxScrollExtent, 0, reason: 'Take, d = $d');
      });
    }

    testWidgets('E, W and C answer phases fit (seed 0: E d = 10, d = 6)',
        (tester) async {
      await pump(tester, size: const Size(360, 640));
      await walkItem(tester);
      await walkItem(tester);
      expect(present('fractionsOfASetYes'), isTrue);
      expect(panel(tester).maxScrollExtent, 0, reason: 'E, d = 10');
      await walkItem(tester);
      expect(present('fractionsOfASetTopNumber'), isTrue);
      expect(panel(tester).maxScrollExtent, 0, reason: 'W');
      await walkItem(tester);
      expect(present('fractionsOfASetOptionFirst'), isTrue);
      expect(panel(tester).maxScrollExtent, 0, reason: 'C');
      await walkItem(tester);
      await walkItem(tester);
      expect(present('fractionsOfASetYes'), isTrue);
      expect(panel(tester).maxScrollExtent, 0, reason: 'E, d = 6');
    });

    testWidgets('C and W answer phases fit with the largest collections',
        (tester) async {
      // A deck whose C item has T = 30 and whose W item has T = 30.
      var seed = 0;
      while (fosDeck(seed)[4].total != 30 || fosDeck(seed)[3].total != 30) {
        seed++;
      }
      await pump(tester, size: const Size(360, 640), seed: seed);
      for (var i = 0; i < 3; i++) {
        await walkItem(tester, checkReveal: false);
      }
      expect(panel(tester).maxScrollExtent, 0, reason: 'W, T = 30');
      await walkItem(tester, checkReveal: false);
      expect(panel(tester).maxScrollExtent, 0, reason: 'C, T = 30');
    });
  });

  testWidgets('German at maximum text on 320 dp: long labels wrap',
      (tester) async {
    await pump(tester,
        size: const Size(320, 568),
        textScale: 1.15,
        locale: const Locale('de', 'CH'));
    for (var i = 0; i < 8; i++) {
      await walkItem(tester);
      expect(tester.takeException(), isNull);
    }
  });
}
