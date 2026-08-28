import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/mascot_fuel_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/streak_service.dart';

/// D2.1 Phase A diagnostic — Pixel 6a landscape (915x412, rotated from the
/// already-established 412x915 portrait constant in
/// polish_audit_overflow_sweep_test.dart). Not yet a fix; this run is to see
/// what actually breaks before touching production code.
void main() {
  const pixel6aLandscape = Size(915, 412);
  const pixel6aPortrait = Size(412, 915);

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await StreakService.instance.init();
    await MascotFuelService.instance.init();
    await OnboardingProfileService.instance.init();
  });

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

  const routes = <String, String>{
    'Topics': '/topics',
    'Practice setup': '/practice',
    'Learning Analytics': '/help/parent-teacher-tools',
    'Formula Library': '/formulas',
  };

  for (final entry in routes.entries) {
    testWidgets('${entry.key} — Pixel 6a landscape (915x412)', (tester) async {
      await pumpRoute(tester, entry.value, pixel6aLandscape);
      expect(tester.takeException(), isNull,
          reason: '${entry.key} threw at Pixel 6a landscape');
    });

    testWidgets('${entry.key} — Pixel 6a portrait (412x915) [regression]',
        (tester) async {
      await pumpRoute(tester, entry.value, pixel6aPortrait);
      expect(tester.takeException(), isNull,
          reason: '${entry.key} threw at Pixel 6a portrait');
    });
  }
}
