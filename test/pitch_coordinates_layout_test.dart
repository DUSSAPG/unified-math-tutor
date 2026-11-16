import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/pitch_coordinates/pitch_coordinates_session.dart';
import 'package:unified_math_tutor/screens/labs/pitch_coordinates/pitch_coordinates_screen.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';
import 'package:unified_math_tutor/widgets/labs/pitch_coordinates/pitch_coordinates_grid_painter.dart';

/// Pitch Coordinates stays usable across orientations, themes, text sizes,
/// contrast and motion settings: no overflow, the grid unit never below
/// 24 dp, axis numbers capped but always drawn, and every control of all
/// eight items reachable and genuinely tappable.
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
    bool disableAnimations = false,
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
          disableAnimations: disableAnimations,
        ),
        child: child!,
      ),
      home: const PitchCoordinatesScreen(seedForTesting: 0),
    ));
    await tester.pumpAndSettle();
  }

  Future<void> tapVisible(WidgetTester tester, Finder f) async {
    await tester.ensureVisible(f);
    await tester.pumpAndSettle();
    await tester.tap(f);
    await tester.pumpAndSettle();
  }

  PitchCoordinatesGridPainter painter(WidgetTester tester) => tester
      .widget<CustomPaint>(find.byKey(const Key('pitchCoordinatesGridPaint')))
      .painter! as PitchCoordinatesGridPainter;

  for (final (name, size, scale, dark, contrast, reduced, start) in [
    (
      'portrait',
      const Size(390, 844),
      1.0,
      false,
      false,
      false,
      PitchStart.corner
    ),
    (
      'portrait-centre',
      const Size(390, 844),
      1.0,
      false,
      false,
      false,
      PitchStart.centre
    ),
    (
      'compact-landscape',
      const Size(844, 390),
      1.0,
      false,
      false,
      false,
      PitchStart.corner
    ),
    (
      'compact-landscape-centre',
      const Size(844, 390),
      1.0,
      false,
      false,
      false,
      PitchStart.centre
    ),
    ('dark', const Size(390, 844), 1.0, true, false, false, PitchStart.centre),
    (
      'dark-landscape',
      const Size(844, 390),
      1.0,
      true,
      false,
      false,
      PitchStart.corner
    ),
    (
      'in-app-max-text',
      const Size(390, 844),
      1.15,
      false,
      false,
      false,
      PitchStart.centre
    ),
    (
      'large-text',
      const Size(390, 844),
      2.0,
      false,
      false,
      false,
      PitchStart.centre
    ),
    (
      'large-text-landscape',
      const Size(844, 390),
      2.0,
      false,
      false,
      false,
      PitchStart.corner
    ),
    (
      'high-contrast',
      const Size(390, 844),
      1.0,
      false,
      true,
      false,
      PitchStart.corner
    ),
    (
      'high-contrast-dark',
      const Size(390, 844),
      1.0,
      true,
      true,
      false,
      PitchStart.centre
    ),
    (
      'reduce-motion',
      const Size(390, 844),
      1.0,
      false,
      false,
      true,
      PitchStart.corner
    ),
    (
      'small-phone',
      const Size(320, 568),
      1.0,
      false,
      false,
      false,
      PitchStart.centre
    ),
    (
      'pixel-6a-class',
      const Size(411, 846),
      1.0,
      false,
      false,
      false,
      PitchStart.centre
    ),
    (
      'short-landscape-centre',
      const Size(640, 320),
      1.0,
      false,
      false,
      false,
      PitchStart.centre
    ),
  ]) {
    testWidgets('layout: $name', (tester) async {
      final previous = WidgetController.hitTestWarningShouldBeFatal;
      WidgetController.hitTestWarningShouldBeFatal = true;
      addTearDown(
          () => WidgetController.hitTestWarningShouldBeFatal = previous);
      await pump(tester,
          size: size,
          textScale: scale,
          dark: dark,
          highContrast: contrast,
          disableAnimations: reduced);
      expect(tester.takeException(), isNull);
      await tapVisible(
          tester,
          find.byKey(Key(start == PitchStart.corner
              ? 'pitchCoordinatesCornerStart'
              : 'pitchCoordinatesCentreStart')));
      final landscape = size.width > size.height;
      expect(
          find.byKey(Key(landscape
              ? 'pitchCoordinatesLandscapeLayout'
              : 'pitchCoordinatesPortraitLayout')),
          findsOneWidget);

      final gridFinder = find.byKey(const Key('pitchCoordinatesGrid'));
      final p = painter(tester);
      final g = PitchGridGeometry(tester.getSize(gridFinder), p.grid);
      expect(g.unit, greaterThanOrEqualTo(24), reason: '$name unit ${g.unit}');
      expect(g.size.width, closeTo(g.size.height, .5), reason: 'square area');
      // Axis numbers scale with text but are capped at 0.8 × unit, and
      // shrink further only if the widest number would overflow the gutter.
      final cap = (12 * scale) < .8 * g.unit ? 12 * scale : .8 * g.unit;
      expect(p.labelFontCap(g), closeTo(cap, 1e-9));
      expect(p.labelFontSize(g), lessThanOrEqualTo(cap + 1e-9));
      for (final r in p.axisLabelRects(g)) {
        expect(r.left, greaterThanOrEqualTo(-.5), reason: '$name label $r');
        expect(r.bottom, lessThanOrEqualTo(g.size.height + .5),
            reason: '$name label $r');
      }
      expect(p.highContrast, contrast);
      expect(
          p.palette.surface,
          Theme.of(tester.element(gridFinder))
              .extension<AppLabColors>()!
              .pitchSurface);

      final screen = Offset.zero & size;
      final gridRect = tester.getRect(gridFinder);
      if (name != 'short-landscape-centre') {
        expect(screen.contains(gridRect.topLeft), isTrue, reason: '$gridRect');
        expect(
            screen.contains(gridRect.bottomRight - const Offset(1, 1)), isTrue,
            reason: '$gridRect');
      } else {
        // 320 dp tall: the grid keeps 24 dp and its own panel scrolls.
        expect(find.byKey(const Key('pitchCoordinatesGridScroll')),
            findsOneWidget);
      }

      // Walk all eight items: confirm, Show me, Next; every control must be
      // genuinely tappable (hit-test warnings are fatal here).
      for (var i = 0; i < 8; i++) {
        final kind = pitchSlotKinds[i + 1]!;
        if (kind == PitchItemKind.read) {
          await tapVisible(
              tester,
              find.descendant(
                  of: find.byKey(const Key('pitchCoordinatesFirstNumber')),
                  matching: find.byKey(const Key('increase'))));
          await tapVisible(
              tester, find.byKey(const Key('pitchCoordinatesExploreGrid')));
          await tapVisible(
              tester, find.byKey(const Key('pitchCoordinatesStepUp')));
        } else if (kind == PitchItemKind.inverse) {
          await tapVisible(tester,
              find.byKey(const Key('pitchCoordinatesHorizontal-positive')));
          await tapVisible(
              tester,
              find.descendant(
                  of: find.byKey(const Key('pitchCoordinatesHorizontal-steps')),
                  matching: find.byKey(const Key('increase'))));
          await tapVisible(
              tester, find.byKey(const Key('pitchCoordinatesVertical-none')));
        } else {
          await tapVisible(
              tester, find.byKey(const Key('pitchCoordinatesStepRight')));
          await tapVisible(
              tester, find.byKey(const Key('pitchCoordinatesStepUp')));
        }
        await tapVisible(
            tester, find.byKey(const Key('pitchCoordinatesConfirm')));
        if (find
            .byKey(const Key('pitchCoordinatesShowMe'))
            .evaluate()
            .isNotEmpty) {
          await tapVisible(
              tester, find.byKey(const Key('pitchCoordinatesShowMe')));
        }
        await tapVisible(tester, find.byKey(const Key('pitchCoordinatesNext')));
        expect(tester.takeException(), isNull, reason: '$name item ${i + 1}');
      }
      await tapVisible(
          tester, find.byKey(const Key('pitchCoordinatesExploreAgain')));
      expect(tester.takeException(), isNull, reason: name);
    });
  }

  testWidgets('360 x 640: prompt and readout visible without scrolling',
      (tester) async {
    await pump(tester, size: const Size(360, 640));
    await tapVisible(
        tester, find.byKey(const Key('pitchCoordinatesCentreStart')));
    await tapVisible(tester, find.byKey(const Key('pitchCoordinatesConfirm')));
    await tapVisible(tester, find.byKey(const Key('pitchCoordinatesShowMe')));
    await tapVisible(tester, find.byKey(const Key('pitchCoordinatesNext')));
    // Place item: scroll back to the top, then check the readout's position.
    final scroll = tester.widget<SingleChildScrollView>(
        find.byKey(const Key('pitchCoordinatesPanelScroll')));
    scroll.controller!.jumpTo(0);
    await tester.pumpAndSettle();
    final readout =
        tester.getRect(find.byKey(const Key('pitchCoordinatesReadout')));
    expect(readout.bottom, lessThanOrEqualTo(640), reason: '$readout');
    final g = PitchGridGeometry(
        tester.getSize(find.byKey(const Key('pitchCoordinatesGrid'))),
        PitchGrid.centre);
    expect(g.unit, greaterThanOrEqualTo(24));
  });

  testWidgets('German large text: long labels wrap without overflow',
      (tester) async {
    await pump(tester,
        size: const Size(320, 568),
        textScale: 2,
        locale: const Locale('de', 'CH'));
    await tapVisible(
        tester, find.byKey(const Key('pitchCoordinatesCornerStart')));
    for (var i = 0; i < 8; i++) {
      await tapVisible(
          tester, find.byKey(const Key('pitchCoordinatesConfirm')));
      await tapVisible(tester, find.byKey(const Key('pitchCoordinatesShowMe')));
      await tapVisible(tester, find.byKey(const Key('pitchCoordinatesNext')));
      expect(tester.takeException(), isNull);
    }
  });
}
