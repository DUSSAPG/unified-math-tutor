import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import 'support/route_sweep_support.dart';

/// Production Polish Audit — every static (or single-sample-id) route in
/// `router.dart`, swept across the audit's 4 named device categories
/// (Mobile/Pixel 6a, Tablet, Web/Desktop, Landscape), asserting zero
/// exceptions — which, per Flutter's own contract, is exactly how a
/// RenderFlex overflow surfaces in a widget test (it throws during layout,
/// it does not just paint the yellow/black stripes and continue). This is
/// the single broadest overflow check in the suite; targeted regressions
/// for specific previously-found risks stay in their own files
/// (`rc1_responsive_hardening_test.dart`, `family_maths_layout_test.dart`,
/// `theme_representative_screens_test.dart`) rather than being folded in
/// here, so each can be run independently.
void main() {
  const mobilePixel6a = Size(412, 915);
  const tablet = Size(768, 1024);
  const webDesktop = Size(1280, 800);
  const landscape = Size(844, 390);

  registerRouteSweepSetUp();

  // Bounded pump sequence rather than pumpAndSettle() — several screens run
  // repeating Timers (e.g. Maze Driver's status clock) that never let
  // pumpAndSettle's "no more frames scheduled" condition converge. Matches
  // the same fix already applied in theme_representative_screens_test.dart.
  Future<void> pumpRoute(WidgetTester tester, String route, Size size) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;

    appRouter.go(route);
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: appRouter,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
    await tester.pump();
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }
  }

  // Every content route in router.dart, minus: `/splash` (transient),
  // `/` (a bare redirect to `/home`), and
  // `/math-studio/recall-cards/session` (requires a live `extra` selection
  // passed in-app, not a directly go()-able destination — already covered by
  // recall_cards_hub_screen's own widget tests). Parameterised routes use one
  // real, catalog-verified sample id each.
  const routes = polishAuditRoutes;

  const deviceCategories = <String, Size>{
    'Mobile (Pixel 6a)': mobilePixel6a,
    'Tablet': tablet,
    'Web/Desktop': webDesktop,
    'Landscape': landscape,
  };

  for (final device in deviceCategories.entries) {
    group('${device.key} — no overflow/exception', () {
      for (final route in routes.entries) {
        testWidgets(route.key, (tester) async {
          await pumpRoute(tester, route.value, device.value);
          expect(tester.takeException(), isNull,
              reason: '${route.key} (${route.value}) at ${device.key} '
                  '(${device.value.width}x${device.value.height})');
        });
      }
    });
  }
}
