import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/app/reading_size_text_scaler.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import 'support/route_sweep_support.dart';

/// Accessibility Release Gate B: every route in the real router, with
/// Android's accessibility text size at 1.3x and 1.6x passed through the
/// app's real `MaterialApp.builder` ([readingSizeAppBuilder]), on a Pixel 6a
/// in portrait and landscape. Asserts the effective scale actually reaches
/// the screen and that no layout overflow or other exception occurs.
///
/// `RC1_FEATURE_FREEZE.md` §6 treats overflow at 1.6x text as
/// release-blocking; before Gate B the app replaced the system scale with
/// its own maximum of 1.15x, so this was never reachable on a device.
void main() {
  registerRouteSweepSetUp();

  const portrait = Size(412, 915);
  const landscape = Size(844, 390);

  /// The sweep's routes plus the critical lab routes it does not list.
  const routes = <String, String>{
    ...polishAuditRoutes,
    'Lab — Early Maths hub':
        '/math-studio/interactive-labs/early-maths-playground',
    'Lab — Feed the Panda':
        '/math-studio/interactive-labs/early-maths-playground/feed-the-hungry-panda',
    'Lab — Panda Portions':
        '/math-studio/interactive-labs/early-maths-playground/panda-portions',
    'Lab — Create the Angle':
        '/math-studio/interactive-labs/applied-maths-studio/create-the-angle',
    'Lab — Fractions of a Set':
        '/math-studio/interactive-labs/applied-maths-studio/fractions-of-a-set',
  };

  Future<void> pumpRoute(
      WidgetTester tester, String route, Size size, double system) async {
    tester.platformDispatcher.textScaleFactorTestValue = system;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;

    appRouter.go(route);
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: appRouter,
        builder: readingSizeAppBuilder,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
    // Bounded pumps, as in the 1.0x sweep: some screens run repeating
    // timers that never let pumpAndSettle converge.
    await tester.pump();
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }
  }

  for (final system in const [1.3, 1.6]) {
    for (final (orientation, size) in const [
      ('portrait', portrait),
      ('landscape', landscape),
    ]) {
      group('Android text ${system}x, $orientation', () {
        for (final route in routes.entries) {
          testWidgets(route.key, (tester) async {
            await pumpRoute(tester, route.value, size, system);
            final scaler = MediaQuery.textScalerOf(
                tester.element(find.byType(Navigator).first));
            expect(scaler.scale(10), closeTo(10 * system, 0.001),
                reason: 'The ${system}x system scale must reach the screen.');
            expect(tester.takeException(), isNull,
                reason: '${route.key} (${route.value}) at Android text '
                    '${system}x, $orientation '
                    '(${size.width}x${size.height})');
          });
        }
      });
    }
  }
}
