import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/home/home_shell.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/mascot_fuel_service.dart';
import 'package:unified_math_tutor/services/streak_service.dart';

/// Confetti lifecycle fix — the end-to-end "Home" half of the contract:
/// once a real milestone has fired, rebuilding the Home screen (a tab
/// switch away and back, a parent state change, anything that makes
/// Flutter re-run HomeTabContent's build methods) must never replay the
/// celebration. reward_celebration_integrity_test.dart proves this at the
/// RewardConfetti widget level directly; this proves it through the real
/// service Home's own confetti call sites listen to.
Widget _homeApp() => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(body: HomeTabContent()),
    );

Finder _streakConfettiPaint() => find.byWidgetPredicate(
      (widget) =>
          widget is CustomPaint &&
          widget.painter.runtimeType.toString() == '_ConfettiPainter',
    );

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await LocalPreferencesService.instance.setRewardsEnabled(true);
    await LocalPreferencesService.instance.setReduceMotion(false);
    await StreakService.instance.init();
    await MascotFuelService.instance.init();
    // Fresh baseline for every test — StreakService is a process-wide
    // singleton, and its serial must not leak a nonzero value in from a
    // previous test in this file.
    StreakService.instance.celebrationSerial.value = 0;
  });

  testWidgets(
      'a genuine streak milestone plays confetti once, and rebuilding the '
      'whole Home tree afterwards does not replay it', (tester) async {
    await tester.pumpWidget(_homeApp());
    await tester.pumpAndSettle();
    expect(_streakConfettiPaint(), findsNothing,
        reason: 'no celebration has happened yet');

    // A real milestone completing — the same signal
    // StreakService.recordSessionCompletion fires on day-streak completion.
    StreakService.instance.celebrationSerial.value++;
    await tester.pump();
    expect(_streakConfettiPaint(), findsWidgets,
        reason: 'a genuine new milestone must play');

    // Let its bounded auto-hide timer run out, matching real usage where
    // nothing forces an immediate clear on Home.
    await tester.pump(const Duration(milliseconds: 1500));
    expect(_streakConfettiPaint(), findsNothing);

    // Simulate "Home rebuilds" — a full fresh build of the same screen,
    // as StatefulShellRoute.indexedStack or any ancestor rebuild would
    // produce — while celebrationSerial is still sitting at its
    // already-fired value from before.
    await tester.pumpWidget(_homeApp());
    await tester.pumpAndSettle();
    expect(_streakConfettiPaint(), findsNothing,
        reason: 'must never replay just because Home rebuilt — the '
            'serial did not genuinely change again');
  });

  testWidgets('Rewards off: a genuine milestone never shows confetti on Home',
      (tester) async {
    await LocalPreferencesService.instance.setRewardsEnabled(false);
    await tester.pumpWidget(_homeApp());
    await tester.pumpAndSettle();

    StreakService.instance.celebrationSerial.value++;
    await tester.pump();
    expect(_streakConfettiPaint(), findsNothing);
  });

  testWidgets(
      'Reduce Motion on: a genuine milestone never shows animated confetti '
      'on Home', (tester) async {
    await LocalPreferencesService.instance.setReduceMotion(true);
    await tester.pumpWidget(_homeApp());
    await tester.pumpAndSettle();

    StreakService.instance.celebrationSerial.value++;
    await tester.pump();
    expect(_streakConfettiPaint(), findsNothing);
  });
}
