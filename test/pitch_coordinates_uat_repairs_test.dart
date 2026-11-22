import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/pitch_coordinates/pitch_coordinates_session.dart';
import 'package:unified_math_tutor/screens/labs/pitch_coordinates/pitch_coordinates_screen.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';
import 'package:unified_math_tutor/widgets/labs/pitch_coordinates/pitch_coordinates_grid_painter.dart';

/// Regression tests for the five Pixel 6a UAT follow-ups:
/// 1. the edge notice is a semantic live region, not an announcement;
/// 2. portrait feedback below the fold is scrolled into view (jump under
///    Reduce Motion);
/// 3. markers never cover axis numbers; the top-row finish keeps clear of
///    the border;
/// 4. one noun ("player") on the grid-only item, in every governed locale;
/// 5. after a Move button or Explore the grid, the first arrow key moves
///    the cursor.
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

  Future<void> pump(
    WidgetTester tester, {
    Size size = const Size(390, 844),
    bool reduceMotion = false,
    Locale locale = const Locale('en'),
  }) async {
    tester.view.physicalSize = size;
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
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: reduceMotion),
        child: child!,
      ),
      home: const PitchCoordinatesScreen(seedForTesting: 0),
    ));
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, Finder f) async {
    await tester.ensureVisible(f);
    await tester.pumpAndSettle();
    await tester.tap(f);
    await tester.pumpAndSettle();
  }

  Finder k(String key) => find.byKey(Key(key));

  PitchCoordinatesGridPainter painter(WidgetTester tester) =>
      tester.widget<CustomPaint>(k('pitchCoordinatesGridPaint')).painter!
          as PitchCoordinatesGridPainter;

  /// Start a corner visit and skip ahead to [slot] via Show me.
  Future<void> goToSlot(WidgetTester tester, int slot) async {
    await tap(tester, k('pitchCoordinatesCornerStart'));
    for (var i = 1; i < slot; i++) {
      await tap(tester, k('pitchCoordinatesConfirm'));
      if (k('pitchCoordinatesShowMe').evaluate().isNotEmpty) {
        await tap(tester, k('pitchCoordinatesShowMe'));
      }
      await tap(tester, k('pitchCoordinatesNext'));
    }
  }

  ScrollPosition panel(WidgetTester tester) => tester
      .state<ScrollableState>(find.descendant(
          of: k('pitchCoordinatesPanelScroll'),
          matching: find.byType(Scrollable)))
      .position;

  // ---------------------------------------------------------------------
  group('1. edge notice is a semantic live region', () {
    test('the screen no longer makes imperative announcements', () {
      final src = File(
              'lib/screens/labs/pitch_coordinates/pitch_coordinates_screen.dart')
          .readAsStringSync();
      expect(src.contains('sendAnnouncement'), isFalse);
      expect(src.contains('SemanticsService'), isFalse);
      expect(src.contains('announce('), isFalse);
    });

    for (final locale in locales) {
      testWidgets('button and arrow key at an edge, $locale', (tester) async {
        final sent = <Object?>[];
        tester.binding.defaultBinaryMessenger.setMockDecodedMessageHandler(
            SystemChannels.accessibility, (message) async {
          sent.add(message);
          return null;
        });
        addTearDown(() => tester.binding.defaultBinaryMessenger
            .setMockDecodedMessageHandler(SystemChannels.accessibility, null));
        final handle = tester.ensureSemantics();
        await pump(tester, locale: locale);
        final l = AppLocalizations.of(
            tester.element(find.byType(PitchCoordinatesScreen)));
        await goToSlot(tester, 2); // place item, selection at the origin

        await tap(tester, k('pitchCoordinatesStepLeft'));
        final node = tester.getSemantics(k('pitchCoordinatesEdgeNoticeRegion'));
        final data = node.getSemanticsData();
        expect(data.flagsCollection.isLiveRegion, isTrue);
        expect(data.label, l.labsPitchCoordinatesEdgeLeft);

        // A successful step clears it; the arrow key brings it back.
        await tap(tester, k('pitchCoordinatesStepUp'));
        expect(k('pitchCoordinatesEdgeNotice'), findsNothing);
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pumpAndSettle();
        expect(
            tester
                .getSemantics(k('pitchCoordinatesEdgeNoticeRegion'))
                .getSemanticsData()
                .label,
            l.labsPitchCoordinatesEdgeDown);

        final announcements = sent
            .whereType<Map<Object?, Object?>>()
            .where((m) => m['type'] == 'announce');
        expect(announcements, isEmpty,
            reason: 'no deprecated announce on Android');
        handle.dispose();
      });
    }
  });

  // ---------------------------------------------------------------------
  group('2. portrait feedback is brought into view', () {
    void expectCardVisible(WidgetTester tester) {
      final view = tester.getRect(k('pitchCoordinatesPanelScroll'));
      final card = tester.getRect(k('pitchCoordinatesFeedback'));
      expect(card.top, greaterThanOrEqualTo(view.top - .5), reason: '$card');
      expect(card.bottom, lessThanOrEqualTo(view.bottom + .5),
          reason: '$card in $view');
      for (final b in ['pitchCoordinatesTryAgain', 'pitchCoordinatesShowMe']) {
        expect(tester.getRect(k(b)).bottom, lessThanOrEqualTo(view.bottom));
      }
    }

    testWidgets('inverse item: animated scroll by default', (tester) async {
      await pump(tester);
      await goToSlot(tester, 6);
      final before = panel(tester).pixels;
      final cardTopBefore = tester
          .getRect(k('pitchCoordinatesConfirm'))
          .top; // the card replaces Confirm
      expect(cardTopBefore, greaterThan(0));
      await tester.ensureVisible(k('pitchCoordinatesConfirm'));
      await tester.pumpAndSettle();
      await tester.tap(k('pitchCoordinatesConfirm'));
      await tester.pump(); // card built; reveal scheduled
      await tester.pump(const Duration(milliseconds: 16));
      expect(panel(tester).isScrollingNotifier.value, isTrue,
          reason: 'without Reduce Motion the reveal animates');
      await tester.pumpAndSettle();
      expect(panel(tester).pixels, greaterThan(before),
          reason: 'the card started below the fold');
      expectCardVisible(tester);

      // Show me keeps the revealed answer and Next in view too.
      await tester.tap(k('pitchCoordinatesShowMe'));
      await tester.pumpAndSettle();
      expect(
          tester.getRect(k('pitchCoordinatesNext')).bottom,
          lessThanOrEqualTo(
              tester.getRect(k('pitchCoordinatesPanelScroll')).bottom));
    });

    testWidgets('inverse item: instant jump under Reduce Motion',
        (tester) async {
      await pump(tester, reduceMotion: true);
      await goToSlot(tester, 6);
      await tester.ensureVisible(k('pitchCoordinatesConfirm'));
      await tester.pumpAndSettle();
      final before = panel(tester).pixels;
      await tester.tap(k('pitchCoordinatesConfirm'));
      await tester.pump(); // card built; the reveal jumps after this frame
      await tester.pump();
      expect(panel(tester).isScrollingNotifier.value, isFalse,
          reason: 'no scroll animation under Reduce Motion');
      expect(panel(tester).pixels, greaterThan(before));
      expectCardVisible(tester);
    });

    testWidgets('compact landscape: the card is also visible', (tester) async {
      await pump(tester, size: const Size(844, 390));
      await goToSlot(tester, 6);
      await tap(tester, k('pitchCoordinatesConfirm'));
      expectCardVisible(tester);
    });
  });

  // ---------------------------------------------------------------------
  group('3. axis numbers stay clear of every marker', () {
    const palette = PitchGridPalette(
      surface: Colors.green,
      markings: Colors.white,
      gridLine: Colors.white,
      axis: Colors.white,
      label: Colors.white,
      player: Colors.white,
      outline: Colors.black,
      cursor: Colors.yellow,
      start: Colors.orange,
      finish: Colors.blue,
      arrow: Colors.yellow,
    );

    double distanceToRect(Offset p, Rect r) {
      final dx = math.max(math.max(r.left - p.dx, 0.0), p.dx - r.right);
      final dy = math.max(math.max(r.top - p.dy, 0.0), p.dy - r.bottom);
      return math.sqrt(dx * dx + dy * dy);
    }

    for (final grid in [PitchGrid.corner, PitchGrid.centre]) {
      for (final scale in [1.0, 1.15, 2.0]) {
        for (final hc in [false, true]) {
          test('${grid.start.name} grid, text ×$scale, high contrast $hc', () {
            for (final side in [
              PitchGridGeometry.minSide(grid),
              300.0,
              360.0,
              411.0,
              600.0,
            ]) {
              if (side < PitchGridGeometry.minSide(grid)) continue;
              final size = Size(side, side);
              final g = PitchGridGeometry(size, grid);
              final p = PitchCoordinatesGridPainter(
                grid: grid,
                bare: false,
                palette: palette,
                highContrast: hc,
                textScaler: TextScaler.linear(scale),
                textDirection: TextDirection.ltr,
              );
              expect(g.unit, greaterThanOrEqualTo(PitchGridGeometry.minUnit));
              final reach = p.markerReach(g);
              expect(reach, lessThan(g.clearance));
              final labels = p.axisLabelRects(g);
              expect(labels, hasLength(2 * grid.lines));
              for (final r in labels) {
                expect((Offset.zero & size).inflate(.5).contains(r.topLeft),
                    isTrue,
                    reason: 'label $r inside $size');
                expect((Offset.zero & size).inflate(.5).contains(r.bottomRight),
                    isTrue,
                    reason: 'label $r inside $size');
              }
              for (var x = grid.lo; x <= grid.hi; x++) {
                for (var y = grid.lo; y <= grid.hi; y++) {
                  final c = g.point(x, y);
                  for (final r in labels) {
                    expect(distanceToRect(c, r), greaterThan(reach),
                        reason: '($x, $y) at side $side reaches label $r');
                  }
                }
              }
              // The top-row finish diamond keeps clear of the 3 dp focus
              // border, and nothing on the outer lines leaves the area.
              for (var x = grid.lo; x <= grid.hi; x++) {
                final top = g.point(x, grid.hi).dy - p.finishReach(g);
                expect(top, greaterThanOrEqualTo(6), reason: 'side $side');
                expect(g.point(x, grid.hi).dy - reach, greaterThan(3));
              }
              for (var y = grid.lo; y <= grid.hi; y++) {
                expect(
                    g.point(grid.hi, y).dx + reach, lessThan(size.width - 3));
              }
            }
          });
        }
      }
    }
  });

  // ---------------------------------------------------------------------
  group('4. one noun on the grid-only item', () {
    const files = {
      'app_en.arb': 'player',
      'app_en_GB.arb': 'player',
      'app_de_CH.arb': 'Spieler',
      'app_fr_CH.arb': 'joueur',
      'app_it_CH.arb': 'giocatore',
    };
    final otherNoun = RegExp(
        r'\bmarkers?\b|Markierung|repère|marqueur|indicatore|segnaposto',
        caseSensitive: false);

    for (final MapEntry(key: f, value: noun) in files.entries) {
      test(f, () {
        final arb = jsonDecode(File('lib/l10n/$f').readAsStringSync())
            as Map<String, dynamic>;
        String v(String key) => arb['labsPitchCoordinates$key'] as String;
        // Prompt, feedback and reveal all name the same thing.
        for (final key in [
          'PromptTransfer',
          'PromptTranslate',
          'FbStartNotMoved',
          'FbGaveMove',
          'PlayerAnswered',
        ]) {
          expect(v(key).toLowerCase(), contains(noun.toLowerCase()),
              reason: '$f $key');
        }
        for (final e in arb.entries) {
          if (!e.key.startsWith('labsPitchCoordinates')) continue;
          expect(otherNoun.hasMatch(e.value as String), isFalse,
              reason: '$f ${e.key}: ${e.value}');
        }
      });
    }

    for (final locale in locales) {
      testWidgets('grid-only item on screen, $locale', (tester) async {
        await pump(tester, locale: locale);
        final l = AppLocalizations.of(
            tester.element(find.byType(PitchCoordinatesScreen)));
        final noun = l.labsPitchCoordinatesPlayerUnanswered.toLowerCase();
        await goToSlot(tester, 8);
        final prompt = tester.widget<Text>(k('pitchCoordinatesPrompt')).data!;
        expect(prompt.toLowerCase(), contains(noun));
        await tap(tester, k('pitchCoordinatesConfirm'));
        await tap(tester, k('pitchCoordinatesShowMe'));
        final reveal =
            tester.widget<Text>(k('pitchCoordinatesFeedbackText')).data!;
        expect(reveal.toLowerCase(), contains(noun));
        expect(otherNoun.hasMatch('$prompt $reveal'), isFalse);
      });
    }
  });

  // ---------------------------------------------------------------------
  group('5. arrow keys move the cursor straight after a button', () {
    bool gridFocused() =>
        FocusManager.instance.primaryFocus?.debugLabel ==
        'pitchCoordinatesGrid';

    testWidgets('spot item: Move button, then the first arrow key',
        (tester) async {
      await pump(tester);
      await goToSlot(tester, 2);
      expect(painter(tester).cursor, PitchPair.zero);
      await tap(tester, k('pitchCoordinatesStepRight'));
      expect(painter(tester).cursor, const PitchPair(1, 0));
      expect(gridFocused(), isTrue, reason: 'focus restored to the grid');
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(painter(tester).cursor, const PitchPair(2, 0),
          reason: 'the very first arrow key moves the cursor');
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();
      expect(painter(tester).cursor, const PitchPair(2, 1));
    });

    testWidgets('read item: Explore the grid, then the first arrow key',
        (tester) async {
      await pump(tester);
      await goToSlot(tester, 1);
      await tap(tester, k('pitchCoordinatesExploreGrid'));
      expect(gridFocused(), isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(painter(tester).cursor, const PitchPair(1, 0));
      expect(tester.widget<Text>(k('pitchCoordinatesYourPair')).data,
          contains('(0, 0)'),
          reason: 'exploring never enters an answer');
    });

    testWidgets('Try again and Next keep the grid as the keyboard target',
        (tester) async {
      await pump(tester);
      await goToSlot(tester, 2);
      await tap(tester, k('pitchCoordinatesStepUp'));
      await tap(tester, k('pitchCoordinatesConfirm'));
      await tap(tester, k('pitchCoordinatesTryAgain'));
      expect(gridFocused(), isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(painter(tester).cursor, const PitchPair(1, 0));

      // Enter confirms from the keyboard; Show me, then Next to item 3
      // (read: no cursor until explored) and item 4 (translate).
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      await tap(tester, k('pitchCoordinatesShowMe'));
      await tap(tester, k('pitchCoordinatesNext'));
      await tap(tester, k('pitchCoordinatesConfirm'));
      await tap(tester, k('pitchCoordinatesShowMe'));
      await tap(tester, k('pitchCoordinatesNext'));
      final start = painter(tester).cursor!;
      expect(gridFocused(), isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(painter(tester).cursor!.y, start.y - 1);
    });

    testWidgets('number steppers do not pull focus to the grid',
        (tester) async {
      await pump(tester);
      await goToSlot(tester, 1);
      await tap(
          tester,
          find.descendant(
              of: k('pitchCoordinatesFirstNumber'),
              matching: find.byKey(const Key('increase'))));
      expect(gridFocused(), isFalse);
    });
  });
}
