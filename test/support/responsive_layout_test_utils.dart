import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';

/// Shared helpers for the responsive-layout regression tests (Recall Cards
/// filters, Learning Analytics locked state, the interactive Abacus). This
/// file has no `main()` and is never picked up by `flutter test` itself.

/// Pixel 6a, portrait and compact landscape, in logical pixels (DPR 1).
const pixel6aPortraitSize = Size(412, 915);
const pixel6aLandscapeSize = Size(915, 412);

/// One row of the required matrix: viewport x text scale x theme.
class LayoutScenario {
  const LayoutScenario(this.name, this.size, this.textScale, this.brightness);

  final String name;
  final Size size;
  final double textScale;
  final Brightness brightness;

  @override
  String toString() => name;
}

/// Pixel 6a portrait and compact landscape, at normal and 2.0x text, in both
/// themes.
final List<LayoutScenario> layoutScenarios = [
  for (final brightness in Brightness.values)
    for (final viewport in const [
      ('portrait', pixel6aPortraitSize),
      ('landscape', pixel6aLandscapeSize),
    ])
      for (final scale in const [1.0, 2.0])
        LayoutScenario(
          '${viewport.$1} ${scale}x ${brightness.name}',
          viewport.$2,
          scale,
          brightness,
        ),
];

void useViewport(WidgetTester tester, Size size) {
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
}

/// A plain (non-router) app shell with the real localisations and theme.
Widget layoutHarness(
  Widget home, {
  required LayoutScenario scenario,
  bool disableAnimations = false,
}) {
  return MaterialApp(
    theme: AppTheme.light(),
    darkTheme: AppTheme.dark(),
    themeMode: scenario.brightness == Brightness.dark
        ? ThemeMode.dark
        : ThemeMode.light,
    locale: const Locale('en'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(scenario.textScale),
        disableAnimations: disableAnimations,
      ),
      child: child!,
    ),
    home: home,
  );
}

/// The on-screen rectangle of the first match of [finder].
Rect rectOf(WidgetTester tester, Finder finder) => tester.getRect(finder.first);

/// True when [inner] lies fully inside [outer] (small tolerance for
/// sub-pixel layout).
bool isContained(Rect inner, Rect outer, {double tolerance = 0.5}) =>
    inner.left >= outer.left - tolerance &&
    inner.right <= outer.right + tolerance &&
    inner.top >= outer.top - tolerance &&
    inner.bottom <= outer.bottom + tolerance;

/// Fails if any widget in the tree threw during layout/paint (RenderFlex
/// overflow included).
void expectNoLayoutException(WidgetTester tester, {String? reason}) {
  expect(tester.takeException(), isNull, reason: reason);
}

/// Asserts that [finder]'s first match is fully visible horizontally within
/// the app viewport: nothing required is cropped by the left or right edge.
void expectHorizontallyOnScreen(
  WidgetTester tester,
  Finder finder,
  Size viewport, {
  String? reason,
}) {
  final rect = rectOf(tester, finder);
  expect(rect.left, greaterThanOrEqualTo(-0.5),
      reason: '${reason ?? finder} is clipped by the left edge: $rect');
  expect(rect.right, lessThanOrEqualTo(viewport.width + 0.5),
      reason: '${reason ?? finder} is clipped by the right edge: $rect');
}

/// Minimum touch target the screen must keep (Material guideline, dp).
const double minTouchTarget = 44;
