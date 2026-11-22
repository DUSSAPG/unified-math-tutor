import 'dart:math' as math;
import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/binomial_volume_model.dart';
import 'package:unified_math_tutor/screens/labs/binomial_volume/binomial_volume_lab_screen.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';
import 'package:unified_math_tutor/widgets/labs/binomial_volume/binomial_cube_painter.dart';

final _l10n = lookupAppLocalizations(const Locale('en'));

final _slider = find.byKey(const Key('binomialExplosionSlider'));
final _canvas = find.byKey(const Key('binomialCubeCanvas'));
final _explanation = find.byKey(const Key('binomialExplanation'));
final _stepTitle = find.byKey(const Key('binomialStepTitle'));
final _stepStatus = find.byKey(const Key('binomialStepStatus'));
final _completion = find.byKey(const Key('binomialCompletionCard'));

double _explosion(WidgetTester tester) => tester.widget<Slider>(_slider).value;

String _text(WidgetTester tester, Finder f) => tester.widget<Text>(f).data!;

SemanticsFinder _semanticsLabel(String label, {bool button = false}) =>
    find.semantics.byPredicate((n) {
      final d = n.getSemanticsData();
      return d.label == label && (!button || d.flagsCollection.isButton);
    });

Future<void> _pump(
  WidgetTester tester, {
  Size size = const Size(390, 844),
  double textScale = 1,
  bool dark = false,
  bool disableAnimations = false,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(
    theme: AppTheme.light(),
    darkTheme: AppTheme.dark(),
    themeMode: dark ? ThemeMode.dark : ThemeMode.light,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(textScale),
        disableAnimations: disableAnimations,
      ),
      child: child!,
    ),
    home: const BinomialVolumeLabScreen(),
  ));
  await tester.pumpAndSettle();
}

/// Requests focus on the first focusable node inside [of].
void _focusInside(WidgetTester tester, Finder of) {
  tester
      .widgetList<Focus>(find.descendant(of: of, matching: find.byType(Focus)))
      .map((f) => f.focusNode)
      .whereType<FocusNode>()
      .firstWhere((n) => n.canRequestFocus)
      .requestFocus();
}

Future<void> _tap(WidgetTester tester, Finder f) async {
  await tester.ensureVisible(f);
  await tester.pumpAndSettle();
  await tester.tap(f);
  await tester.pumpAndSettle();
}

/// A screen point (global) inside the canvas that hits [term]'s front-most
/// visible area, found by sampling the same layout the painter uses.
Offset? _pointFor(WidgetTester tester, BinomialTerm term,
    {BinomialDimensions? dims}) {
  final size = tester.getSize(_canvas);
  final topLeft = tester.getTopLeft(_canvas);
  final layout = BinomialCubeLayout(
    size: size,
    dimensions: dims ?? BinomialDimensions.initial,
    explosion: _explosion(tester),
  );
  final target = BinomialVolumeModel.blocksFor(term);
  for (final pb in layout.blocks.where((p) => target.contains(p.block))) {
    // Try the centre first, then a coarse grid across the piece's hull.
    final bounds = pb.hullPath.getBounds();
    final candidates = [
      pb.centre,
      for (var fx = 0.1; fx < 1; fx += 0.1)
        for (var fy = 0.1; fy < 1; fy += 0.1)
          Offset(
              bounds.left + bounds.width * fx, bounds.top + bounds.height * fy),
    ];
    for (final c in candidates) {
      if (layout.hitTest(c)?.term == term) return topLeft + c;
    }
  }
  return null;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await LocalPreferencesService.instance.setReduceMotion(false);
  });

  group('introduction and semantics', () {
    testWidgets('shows the intro and named controls', (tester) async {
      final handle = tester.ensureSemantics();
      await _pump(tester);
      expect(find.text(_l10n.labsBinomialIntro), findsOneWidget);
      expect(
          find.text('A cube with side length a + b can be split into '
              'smaller volumes. Move the slider to pull the pieces apart.'),
          findsOneWidget);

      for (final label in [
        'Assemble cube',
        'Pull cube apart',
        'Reset cube view',
        'Select a cubed block',
        'Select an a squared b prism',
        'Select an a b squared prism',
        'Select b cubed block',
      ]) {
        expect(_semanticsLabel(label, button: true), findsOneWidget,
            reason: label);
      }

      expect(
        tester.getSemantics(_slider),
        isSemantics(
          label: 'Explosion amount',
          value: '0 percent',
          isSlider: true,
          hasIncreaseAction: true,
          hasDecreaseAction: true,
          isFocusable: true,
          hasEnabledState: true,
          isEnabled: true,
        ),
      );
      final model = find.semantics.byPredicate((n) =>
          n.getSemanticsData().label.startsWith('Cube model with side length'));
      expect(model, findsOneWidget);
      handle.dispose();
    });

    testWidgets('slider value is announced as "Explosion amount: 40 percent"',
        (tester) async {
      final handle = tester.ensureSemantics();
      await _pump(tester);
      tester.widget<Slider>(_slider).onChanged!(0.4);
      await tester.pumpAndSettle();
      expect(find.text('Explosion amount: 40 percent'), findsOneWidget);
      expect(tester.getSemantics(_slider),
          isSemantics(label: 'Explosion amount', value: '40 percent'));
      expect(
        find.semantics.byPredicate((n) =>
            n.getSemanticsData().label.contains('Pulled apart 40 percent')),
        findsOneWidget,
      );
      handle.dispose();
    });
  });

  group('slider, buttons, reset and motion', () {
    testWidgets('Pull apart animates briefly, then settles at 100 percent',
        (tester) async {
      await _pump(tester);
      await tester.tap(find.byKey(const Key('binomialPullApartButton')));
      await tester.pump();
      await tester.pump(BinomialVolumeLabScreen.transitionDuration ~/ 2);
      final mid = _explosion(tester);
      expect(mid, greaterThan(0));
      expect(mid, lessThan(1));
      await tester.pumpAndSettle();
      expect(_explosion(tester), 1);
      expect(tester.binding.hasScheduledFrame, isFalse);

      await tester.tap(find.byKey(const Key('binomialAssembleButton')));
      await tester.pumpAndSettle();
      expect(_explosion(tester), 0);
    });

    testWidgets('Reset view stops a running transition cleanly',
        (tester) async {
      await _pump(tester);
      await tester.tap(find.byKey(const Key('binomialPullApartButton')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(_explosion(tester), greaterThan(0));
      await tester.tap(find.byKey(const Key('binomialResetButton')));
      await tester.pump();
      expect(_explosion(tester), 0);
      await tester.pump(const Duration(seconds: 1));
      expect(_explosion(tester), 0, reason: 'animation must not resume');
      expect(tester.binding.hasScheduledFrame, isFalse);
    });

    testWidgets('Reset view clears the selection but keeps dimensions',
        (tester) async {
      await _pump(tester);
      tester.widget<Slider>(_slider).onChanged!(0.6);
      await _tap(tester, find.byKey(const Key('binomialTermButton-aCubed')));
      await _tap(tester, find.text('3').first);
      await _tap(tester, find.byKey(const Key('binomialResetButton')));
      expect(_explosion(tester), 0);
      expect(_text(tester, _explanation), _l10n.labsBinomialSelectPrompt);
      expect(_text(tester, find.byKey(const Key('binomialNumericCheck'))),
          '4³ = 27 + 27 + 9 + 1 = 64');
    });

    testWidgets('dragging the slider moves the pieces with no animation',
        (tester) async {
      await _pump(tester);
      await tester.ensureVisible(_slider);
      await tester.drag(_slider, const Offset(400, 0));
      await tester.pump();
      expect(_explosion(tester), 1);
    });

    testWidgets('app pause finishes a transition at its destination',
        (tester) async {
      await _pump(tester);
      await tester.tap(find.byKey(const Key('binomialPullApartButton')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 80));
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump();
      expect(_explosion(tester), 1);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expect(_explosion(tester), 1);
    });

    testWidgets('leaving mid-transition disposes without errors',
        (tester) async {
      await _pump(tester);
      await tester.tap(find.byKey(const Key('binomialPullApartButton')));
      await tester.pump(const Duration(milliseconds: 60));
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
      expect(tester.takeException(), isNull);
    });
  });

  group('Reduce Motion', () {
    testWidgets('app preference: buttons update in a single frame',
        (tester) async {
      await LocalPreferencesService.instance.setReduceMotion(true);
      await _pump(tester);
      await tester.tap(find.byKey(const Key('binomialPullApartButton')));
      // One frame, no intermediate values: the change is immediate.
      await tester.pump();
      expect(_explosion(tester), 1);
      await tester.pump(const Duration(milliseconds: 50));
      expect(_explosion(tester), 1);
      await tester.tap(find.byKey(const Key('binomialAssembleButton')));
      await tester.pump();
      expect(_explosion(tester), 0);
    });

    testWidgets('system "remove animations" setting is honoured too',
        (tester) async {
      await _pump(tester, disableAnimations: true);
      await tester.tap(find.byKey(const Key('binomialPullApartButton')));
      await tester.pump();
      expect(_explosion(tester), 1);
    });
  });

  group('selection and explanation copy', () {
    testWidgets('a²b button explains the prism and highlights its term',
        (tester) async {
      final handle = tester.ensureSemantics();
      await _pump(tester);
      expect(_text(tester, _explanation), _l10n.labsBinomialSelectPrompt);
      await _tap(tester, find.byKey(const Key('binomialTermButton-aSquaredB')));
      final copy = _text(tester, _explanation);
      expect(
          copy,
          contains('This prism measures a × a × b, so its volume is a²b. '
              'There are three of these prisms.'));
      expect(copy, contains('With a = 2 and b = 1, each one has volume 4.'));
      final node = _semanticsLabel('Select an a squared b prism', button: true);
      expect(
          node.evaluate().single.getSemanticsData().flagsCollection.isSelected,
          Tristate.isTrue);
      handle.dispose();
    });

    testWidgets('every term has the right explanation and volume',
        (tester) async {
      await _pump(tester);
      final expected = {
        BinomialTerm.aCubed: (
          'This cube measures a × a × a, so its volume is '
              'a³. There is one of these cubes.',
          8
        ),
        BinomialTerm.aBSquared: (
          'This prism measures a × b × b, so its volume '
              'is ab². There are three of these prisms.',
          2
        ),
        BinomialTerm.bCubed: (
          'This cube measures b × b × b, so its volume is '
              'b³. There is one of these cubes.',
          1
        ),
      };
      for (final MapEntry(key: term, value: (copy, volume))
          in expected.entries) {
        await _tap(tester, find.byKey(Key('binomialTermButton-${term.name}')));
        expect(_text(tester, _explanation), contains(copy));
        expect(_text(tester, _explanation),
            contains('each one has volume $volume.'));
      }
    });

    testWidgets('tapping a piece in the model selects it', (tester) async {
      await _pump(tester);
      await tester.ensureVisible(_canvas);
      await tester.pumpAndSettle();
      // Assembled: the front b³ cube is directly tappable.
      final b3 = _pointFor(tester, BinomialTerm.bCubed);
      expect(b3, isNotNull);
      await tester.tapAt(b3!);
      await tester.pumpAndSettle();
      expect(_text(tester, _explanation),
          contains('This cube measures b × b × b'));

      // Pulled apart: the hidden a³ cube becomes reachable by touch.
      tester.widget<Slider>(_slider).onChanged!(1);
      await tester.pumpAndSettle();
      final a3 = _pointFor(tester, BinomialTerm.aCubed);
      expect(a3, isNotNull, reason: 'a³ must be tappable when pulled apart');
      await tester.tapAt(a3!);
      await tester.pumpAndSettle();
      expect(_text(tester, _explanation),
          contains('This cube measures a × a × a'));

      // Tapping empty canvas clears the selection.
      await tester.tapAt(tester.getTopLeft(_canvas) + const Offset(4, 4));
      await tester.pumpAndSettle();
      expect(_text(tester, _explanation), _l10n.labsBinomialSelectPrompt);
    });

    testWidgets('every piece is tappable when fully pulled apart',
        (tester) async {
      await _pump(tester, size: const Size(844, 390));
      tester.widget<Slider>(_slider).onChanged!(1);
      await tester.pumpAndSettle();
      for (final term in BinomialTerm.values) {
        expect(_pointFor(tester, term), isNotNull, reason: term.name);
      }
    });
  });

  group('layout geometry (pure)', () {
    test('every term is touchable at full pull-apart, for every a and b', () {
      for (final size in const [Size(358, 400), Size(480, 330)]) {
        for (final a in BinomialDimensions.allowedA) {
          for (final b in BinomialDimensions.allowedB) {
            final layout = BinomialCubeLayout(
              size: size,
              dimensions: BinomialDimensions(a: a, b: b),
              explosion: 1,
            );
            final hits = <BinomialTerm, int>{};
            for (var x = 0.0; x < size.width; x += 3) {
              for (var y = 0.0; y < size.height; y += 3) {
                final t = layout.hitTest(Offset(x, y))?.term;
                if (t != null) hits[t] = (hits[t] ?? 0) + 1;
              }
            }
            for (final term in BinomialTerm.values) {
              // Visible and touchable: 40+ samples on a 3px grid is at least
              // ~360 px². (Smallest case is a³ at a = 1, b = 2, where a³ is
              // 1/27 of the cube; the term buttons are the dependable path.)
              // Regression: in a true isometric view a³ was fully hidden
              // behind b³ whenever a = b.
              expect(hits[term] ?? 0, greaterThan(40),
                  reason: 'a=$a b=$b size=$size ${term.name}');
            }
          }
        }
      }
    });

    test(
        'at full pull-apart no tag overlaps or hides another, for every a '
        'and b, at standard and large text', () {
      // Regression (Pixel UAT): a³'s tag sat under b³'s body at 100 %.
      for (final size in const [Size(358, 400), Size(480, 330)]) {
        for (final scale in const [1.0, 1.4]) {
          for (final a in BinomialDimensions.allowedA) {
            for (final b in BinomialDimensions.allowedB) {
              final why = 'a=$a b=$b size=$size text=${scale}x';
              final layout = BinomialCubeLayout(
                size: size,
                dimensions: BinomialDimensions(a: a, b: b),
                explosion: 1,
              );
              // Same sizing rule as the painter's tags.
              Size pill(BinomialBlock block) {
                final hull = layout.projected(block).hullPath.getBounds();
                final font =
                    (math.min(hull.width, hull.height) * 0.26).clamp(9.0, 18.0);
                final tp = TextPainter(
                  text: TextSpan(
                      text: block.term.symbol,
                      style: TextStyle(fontSize: font.toDouble())),
                  textDirection: TextDirection.ltr,
                  textScaler: TextScaler.linear(scale),
                )..layout();
                return Size(tp.width + 8, tp.height + 2);
              }

              final places = placeBinomialLabels(layout, pill);
              expect(places.keys.toSet(), {0, 1, 2, 3, 4, 5, 6, 7},
                  reason: why);
              final rects = places.values.map((p) => p.rect).toList();
              for (var i = 0; i < rects.length; i++) {
                for (var j = i + 1; j < rects.length; j++) {
                  final x = rects[i].intersect(rects[j]);
                  expect(x.width > 0.5 && x.height > 0.5, isFalse,
                      reason: '$why tags $i and $j overlap');
                }
              }
              for (final pb in layout.blocks) {
                final place = places[pb.block.index]!;
                // A tag painted with its piece must sit on that piece's
                // visible area; otherwise it is painted on top of all.
                if (!place.onTop) {
                  expect(
                      layout.hitTest(place.rect.center)?.index, pb.block.index,
                      reason: '$why ${pb.block.term.name} tag is covered');
                }
              }
              // The reported pair specifically.
              final a3 = places[
                  BinomialVolumeModel.blocksFor(BinomialTerm.aCubed)
                      .single
                      .index]!;
              final b3 = places[
                  BinomialVolumeModel.blocksFor(BinomialTerm.bCubed)
                      .single
                      .index]!;
              expect(a3.rect.overlaps(b3.rect), isFalse, reason: why);
              final b3Hull = layout
                  .projected(
                      BinomialVolumeModel.blocksFor(BinomialTerm.bCubed).single)
                  .hullPath;
              expect(a3.onTop || !b3Hull.contains(a3.rect.center), isTrue,
                  reason: '$why a³ tag under b³');
            }
          }
        }
      }
    });

    test('the picture never rescales while pulling apart', () {
      final d = BinomialDimensions.initial;
      final scales = [
        for (final e in [0.0, 0.5, 1.0])
          BinomialCubeLayout(
                  size: const Size(400, 400), dimensions: d, explosion: e)
              .scale,
      ];
      expect(scales.toSet(), hasLength(1));
    });
  });

  group('keyboard', () {
    testWidgets('arrow keys move between pieces; Escape clears',
        (tester) async {
      await _pump(tester);
      await tester.ensureVisible(_canvas);
      Focus.of(tester.element(_canvas)).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(_text(tester, _explanation), contains('a × a × a'));
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(_text(tester, _explanation), contains('a × a × b'));
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();
      expect(_text(tester, _explanation), contains('b × b × b'));
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(_text(tester, _explanation), _l10n.labsBinomialSelectPrompt);
    });

    testWidgets('slider responds to arrow keys', (tester) async {
      await _pump(tester);
      await tester.ensureVisible(_slider);
      _focusInside(tester, _slider);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(_explosion(tester), closeTo(0.05, 1e-9));
    });

    testWidgets('term buttons activate with Enter', (tester) async {
      await _pump(tester);
      final button = find.byKey(const Key('binomialTermButton-aBSquared'));
      await tester.ensureVisible(button);
      // InkWell owns an internal node: reach it from a widget inside it.
      Focus.of(tester.element(
              find.descendant(of: button, matching: find.byType(Text)).first))
          .requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(_text(tester, _explanation), contains('a × b × b'));
    });
  });

  group('guided steps', () {
    testWidgets('steps are free to choose; finding and next work',
        (tester) async {
      final handle = tester.ensureSemantics();
      await _pump(tester);
      expect(_text(tester, _stepTitle), 'Find the a³ cube');
      expect(_semanticsLabel('Step 2: Find the three a²b prisms', button: true),
          findsOneWidget);

      // Jump straight to step 4 — no forced order.
      await _tap(tester, find.byKey(const Key('binomialStepChip-4')));
      expect(_text(tester, _stepTitle), 'Find the b³ cube');
      expect(find.byKey(const Key('binomialNextStepButton')), findsNothing);

      // A different piece is not counted, and the copy stays gentle.
      await _tap(tester, find.byKey(const Key('binomialTermButton-aSquaredB')));
      expect(_text(tester, _stepStatus), _l10n.labsBinomialStepKeepLooking);

      await _tap(tester, find.byKey(const Key('binomialTermButton-bCubed')));
      expect(_text(tester, _stepStatus), _l10n.labsBinomialStepFound);
      expect(_completion, findsNothing);

      await _tap(tester, find.byKey(const Key('binomialNextStepButton')));
      expect(_text(tester, _stepTitle), 'Reveal the complete expansion');
      expect(find.text('(a + b)³ = a³ + 3a²b + 3ab² + b³'), findsOneWidget);
      expect(find.text('(2 + 1)³ = 3³ = 8 + 12 + 6 + 1 = 27'), findsOneWidget);
      expect(_completion, findsOneWidget);
      handle.dispose();
    });

    testWidgets('a new step starts neutrally: no carried-over selection',
        (tester) async {
      // Regression (Pixel UAT): select a³ in step 1 → Next step → step 2
      // said "That piece has a different volume" with no new choice made.
      await _pump(tester);
      await _tap(tester, find.byKey(const Key('binomialTermButton-aCubed')));
      expect(_text(tester, _stepStatus), _l10n.labsBinomialStepFound);

      await _tap(tester, find.byKey(const Key('binomialNextStepButton')));
      expect(_text(tester, _stepTitle), 'Find the three a²b prisms');
      expect(_text(tester, _stepStatus), _l10n.labsBinomialSelectPrompt);
      expect(_text(tester, _explanation), _l10n.labsBinomialSelectPrompt);
      final painter = tester
          .widgetList<CustomPaint>(
              find.descendant(of: _canvas, matching: find.byType(CustomPaint)))
          .map((w) => w.painter)
          .whereType<BinomialCubePainter>()
          .single;
      expect(painter.selected, isNull, reason: 'nothing highlighted');
      expect(find.byKey(const Key('binomialNextStepButton')), findsNothing);

      // The same holds for choosing a step chip directly...
      await _tap(tester, find.byKey(const Key('binomialTermButton-bCubed')));
      await _tap(tester, find.byKey(const Key('binomialStepChip-3')));
      expect(_text(tester, _stepStatus), _l10n.labsBinomialSelectPrompt);
      expect(_text(tester, _explanation), _l10n.labsBinomialSelectPrompt);

      // ...and for Explore again.
      await _tap(tester, find.byKey(const Key('binomialTermButton-aBSquared')));
      await _tap(tester, find.byKey(const Key('binomialStepChip-5')));
      await _tap(tester, find.byKey(const Key('binomialTermButton-aBSquared')));
      await _tap(tester, find.byKey(const Key('binomialExploreAgainButton')));
      expect(_text(tester, _stepStatus), _l10n.labsBinomialSelectPrompt);
      expect(_text(tester, _explanation), _l10n.labsBinomialSelectPrompt);
    });

    for (final (label, size, scale) in const [
      ('portrait', Size(390, 844), 1.0),
      ('portrait 2x text', Size(390, 844), 2.0),
      ('landscape', Size(844, 390), 1.0),
    ]) {
      testWidgets('step chips never move when ticks appear ($label)',
          (tester) async {
        await _pump(tester, size: size, textScale: scale);
        Map<int, Rect> chipRects() => {
              for (var n = 1; n <= 5; n++)
                n: tester.getRect(find.byKey(Key('binomialStepChip-$n'))),
            };
        // Chips are measured relative to chip 1, so scrolling to tap a
        // term button cannot disguise a reflow.
        Map<int, Rect> relative() {
          final r = chipRects();
          final o = r[1]!.topLeft;
          return r.map((k, v) => MapEntry(k, v.shift(-o)));
        }

        final before = relative();
        for (final (n, term) in const [
          (1, 'aCubed'),
          (2, 'aSquaredB'),
          (3, 'aBSquared'),
          (4, 'bCubed'),
        ]) {
          await _tap(tester, find.byKey(Key('binomialStepChip-$n')));
          await _tap(tester, find.byKey(Key('binomialTermButton-$term')));
          expect(
              find.descendant(
                  of: find.byKey(Key('binomialStepChip-$n')),
                  matching: find.byIcon(Icons.check_circle)),
              findsOneWidget);
          final now = relative();
          for (var k = 1; k <= 5; k++) {
            for (final (got, want) in [
              (now[k]!.left, before[k]!.left),
              (now[k]!.top, before[k]!.top),
              (now[k]!.width, before[k]!.width),
              (now[k]!.height, before[k]!.height),
            ]) {
              expect(got, closeTo(want, 0.5),
                  reason: 'chip $k moved after ticking step $n');
            }
          }
        }
      });
    }

    testWidgets(
        'reopening a completed step keeps its tick but shows the neutral '
        'prompt until its pieces are selected again', (tester) async {
      // Regression (Pixel UAT): reopened completed steps said "Found it.
      // Every matching piece is outlined." while nothing was outlined.
      await _pump(tester);
      final chip1 = find.byKey(const Key('binomialStepChip-1'));
      Finder tick() =>
          find.descendant(of: chip1, matching: find.byIcon(Icons.check_circle));

      await _tap(tester, find.byKey(const Key('binomialTermButton-aCubed')));
      expect(_text(tester, _stepStatus), _l10n.labsBinomialStepFound);
      await _tap(tester, find.byKey(const Key('binomialStepChip-3')));
      await _tap(tester, chip1);

      expect(_text(tester, _stepTitle), 'Find the a³ cube');
      expect(tick(), findsOneWidget, reason: 'completion tick preserved');
      expect(_text(tester, _stepStatus), _l10n.labsBinomialSelectPrompt);
      expect(find.text(_l10n.labsBinomialStepFound), findsNothing);
      final painter = tester
          .widgetList<CustomPaint>(
              find.descendant(of: _canvas, matching: find.byType(CustomPaint)))
          .map((w) => w.painter)
          .whereType<BinomialCubePainter>()
          .single;
      expect(painter.selected, isNull, reason: 'nothing is outlined');

      // A different piece gets the gentle "keep looking", never "found"...
      await _tap(tester, find.byKey(const Key('binomialTermButton-bCubed')));
      expect(_text(tester, _stepStatus), _l10n.labsBinomialStepKeepLooking);
      // ...and "found" returns only once the matching pieces are outlined.
      await _tap(tester, find.byKey(const Key('binomialTermButton-aCubed')));
      expect(_text(tester, _stepStatus), _l10n.labsBinomialStepFound);
      expect(tick(), findsOneWidget);
    });

    testWidgets('step 2 is found by any of the three a²b prisms',
        (tester) async {
      await _pump(tester);
      await _tap(tester, find.byKey(const Key('binomialStepChip-2')));
      await _tap(tester, find.byKey(const Key('binomialTermButton-aSquaredB')));
      expect(_text(tester, _stepStatus), _l10n.labsBinomialStepFound);
      expect(
          find.descendant(
              of: find.byKey(const Key('binomialStepChip-2')),
              matching: find.byIcon(Icons.check_circle)),
          findsOneWidget);
    });

    testWidgets('completion offers Explore again / Choose a step / Back',
        (tester) async {
      await _pump(tester);
      await _tap(tester, find.byKey(const Key('binomialStepChip-5')));
      expect(_completion, findsOneWidget);
      for (final label in [
        'Explore again',
        'Choose a step',
        'Back to Applied Maths Studio',
      ]) {
        expect(find.descendant(of: _completion, matching: find.text(label)),
            findsOneWidget);
      }
      // No marks, scores or timers anywhere on the finished screen.
      for (final word in ['score', 'mark', 'timer', 'streak', 'mastery']) {
        expect(find.textContaining(RegExp(word, caseSensitive: false)),
            findsNothing,
            reason: word);
      }

      await _tap(tester, find.byKey(const Key('binomialChooseStepButton')));
      final chip1 = find.byKey(const Key('binomialStepChip-1'));
      expect(
          Focus.of(tester.element(find
                  .descendant(of: chip1, matching: find.byType(Text))
                  .first))
              .hasFocus,
          isTrue);

      await _tap(tester, find.byKey(const Key('binomialExploreAgainButton')));
      expect(_completion, findsNothing);
      expect(_text(tester, _stepTitle), 'Find the a³ cube');
      expect(_explosion(tester), 0);
    });
  });

  group('adjustable dimensions', () {
    testWidgets('a and b pickers update the numeric check only',
        (tester) async {
      final handle = tester.ensureSemantics();
      await _pump(tester);
      final check = find.byKey(const Key('binomialNumericCheck'));
      expect(_text(tester, check), '3³ = 8 + 12 + 6 + 1 = 27');
      expect(
        _semanticsLabel(
            '3 cubed equals 8 plus 12 plus 6 plus 1, which equals 27.'),
        findsOneWidget,
      );

      await _tap(
          tester,
          find.descendant(
              of: find.byKey(const Key('binomialSideAPicker')),
              matching: find.text('3')));
      await _tap(
          tester,
          find.descendant(
              of: find.byKey(const Key('binomialSideBPicker')),
              matching: find.text('2')));
      expect(_text(tester, check), '5³ = 27 + 54 + 36 + 8 = 125');

      // Symbolic terms stay visible whatever the numbers are.
      for (final symbol in ['a³', '3a²b', '3ab²', 'b³']) {
        expect(find.text(symbol), findsOneWidget, reason: symbol);
      }
      expect(find.textContaining('a = 3, b = 2'), findsOneWidget);
      handle.dispose();
    });
  });

  group('layouts', () {
    Future<void> walkThrough(WidgetTester tester) async {
      // Every control is reachable and usable without overflow.
      await _tap(tester, find.byKey(const Key('binomialPullApartButton')));
      await _tap(tester, find.byKey(const Key('binomialTermButton-aBSquared')));
      await _tap(tester, find.byKey(const Key('binomialStepChip-5')));
      await tester
          .ensureVisible(find.byKey(const Key('binomialBackToStudioButton')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('binomialBackToStudioButton')).hitTestable(),
          findsOneWidget);
      expect(tester.takeException(), isNull);
    }

    testWidgets('portrait phone', (tester) async {
      await _pump(tester);
      expect(find.byKey(const Key('binomialPortraitLayout')), findsOneWidget);
      expect(tester.getSize(_canvas).height, greaterThanOrEqualTo(220));
      await walkThrough(tester);
    });

    testWidgets('portrait phone at 2x text, dark theme', (tester) async {
      await _pump(tester, textScale: 2, dark: true);
      expect(tester.takeException(), isNull);
      await walkThrough(tester);
    });

    testWidgets('compact landscape phone gives the model the full height',
        (tester) async {
      await _pump(tester, size: const Size(844, 390));
      expect(find.byKey(const Key('binomialLandscapeLayout')), findsOneWidget);
      final canvas = tester.getSize(_canvas);
      expect(canvas.height, greaterThan(250));
      expect(canvas.width, greaterThan(400));
      await walkThrough(tester);
    });

    testWidgets('compact landscape at 2x text, dark theme', (tester) async {
      await _pump(tester, size: const Size(844, 390), textScale: 2, dark: true);
      expect(tester.takeException(), isNull);
      await walkThrough(tester);
    });

    testWidgets('tablet landscape', (tester) async {
      await _pump(tester, size: const Size(1280, 800));
      expect(find.byKey(const Key('binomialLandscapeLayout')), findsOneWidget);
      expect(tester.getSize(_canvas).height, greaterThan(600));
      await walkThrough(tester);
    });

    testWidgets('high contrast renders without errors', (tester) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(highContrast: true);
      addTearDown(
          tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
      await _pump(tester, dark: true);
      final painter = tester
          .widgetList<CustomPaint>(
              find.descendant(of: _canvas, matching: find.byType(CustomPaint)))
          .map((c) => c.painter)
          .whereType<BinomialCubePainter>()
          .single;
      expect(painter.palette.highContrast, isTrue);
      await walkThrough(tester);
    });
  });
}
