import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/mascot_fuel_service.dart';
import 'package:unified_math_tutor/widgets/shared/reward_confetti.dart';

/// D2.1 rewards-integrity corrective pass, extended for the confetti
/// lifecycle fix: `play: bool` (sticky, replayed on any fresh mount) was
/// replaced with `serial: int` (baseline-at-mount, only plays on a genuine
/// in-place increase) plus `resetSignal` for immediate cancellation.
Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await MascotFuelService.instance.init();
  });

  group('RewardConfetti lifecycle', () {
    testWidgets(
        'mounting fresh with an already-nonzero serial does NOT play — '
        'this is the fix for confetti replaying on Home rebuild',
        (tester) async {
      await LocalPreferencesService.instance.setRewardsEnabled(true);
      await LocalPreferencesService.instance.setReduceMotion(false);
      // serial is already 3 the moment this widget is first built — as it
      // would be for a screen that gets disposed and freshly recreated
      // after an earlier milestone already happened elsewhere.
      await tester.pumpWidget(_wrap(const RewardConfetti(serial: 3)));
      await tester.pump();
      // The ambient MaterialApp/Scaffold tree already contains its own
      // CustomPaint widgets, so "nothing played" is asserted via
      // RewardConfetti's own SizedBox.shrink() sentinel (findsOneWidget,
      // as this widget tree contributes exactly one), not a global
      // findsNothing on CustomPaint.
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('serial increasing while mounted triggers a play',
        (tester) async {
      await LocalPreferencesService.instance.setRewardsEnabled(true);
      await LocalPreferencesService.instance.setReduceMotion(false);
      final key = GlobalKey();
      await tester.pumpWidget(_wrap(RewardConfetti(key: key, serial: 0)));
      await tester.pump();
      expect(find.byType(SizedBox), findsOneWidget);

      await tester.pumpWidget(_wrap(RewardConfetti(key: key, serial: 1)));
      await tester.pump();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('a triggered play auto-clears after its bounded duration',
        (tester) async {
      await LocalPreferencesService.instance.setRewardsEnabled(true);
      await LocalPreferencesService.instance.setReduceMotion(false);
      final key = GlobalKey();
      await tester.pumpWidget(_wrap(RewardConfetti(key: key, serial: 0)));
      await tester.pumpWidget(_wrap(RewardConfetti(key: key, serial: 1)));
      await tester.pump();
      expect(find.byType(CustomPaint), findsWidgets);

      // Still within the bounded visible window.
      await tester.pump(const Duration(milliseconds: 800));
      expect(find.byType(CustomPaint), findsWidgets);

      // Past the bounded visible window: cleared automatically, with no
      // further pumps needed to make it happen (a real Next Question
      // navigation may not pump this widget again at all).
      await tester.pump(const Duration(milliseconds: 700));
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets(
        'bumping resetSignal clears an in-progress play immediately, '
        'without waiting for the auto-hide timer', (tester) async {
      await LocalPreferencesService.instance.setRewardsEnabled(true);
      await LocalPreferencesService.instance.setReduceMotion(false);
      final key = GlobalKey();
      await tester.pumpWidget(
        _wrap(RewardConfetti(key: key, serial: 0, resetSignal: 0)),
      );
      await tester.pumpWidget(
        _wrap(RewardConfetti(key: key, serial: 1, resetSignal: 0)),
      );
      await tester.pump();
      expect(find.byType(CustomPaint), findsWidgets);

      // Next Question / Exit / Home bump resetSignal.
      await tester.pumpWidget(
        _wrap(RewardConfetti(key: key, serial: 1, resetSignal: 1)),
      );
      await tester.pump();
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets(
        'disposing mid-play cancels its timer cleanly (no post-dispose '
        'setState/timer errors)', (tester) async {
      await LocalPreferencesService.instance.setRewardsEnabled(true);
      await LocalPreferencesService.instance.setReduceMotion(false);
      final key = GlobalKey();
      await tester.pumpWidget(_wrap(RewardConfetti(key: key, serial: 0)));
      await tester.pumpWidget(_wrap(RewardConfetti(key: key, serial: 1)));
      await tester.pump();
      expect(find.byType(CustomPaint), findsWidgets);

      // Replace the whole tree — widget (and its State/Timer) is disposed
      // mid-celebration.
      await tester.pumpWidget(_wrap(const SizedBox.shrink()));
      // If dispose() didn't cancel the pending hide Timer, pumping past
      // its due time here would throw ("A Timer is still pending").
      await tester.pump(const Duration(milliseconds: 1500));
      expect(tester.takeException(), isNull);
    });
  });

  group('RewardConfetti preference gating', () {
    testWidgets('Rewards on + Reduce Motion off + a genuine trigger renders',
        (tester) async {
      await LocalPreferencesService.instance.setRewardsEnabled(true);
      await LocalPreferencesService.instance.setReduceMotion(false);
      final key = GlobalKey();
      await tester.pumpWidget(_wrap(RewardConfetti(key: key, serial: 0)));
      await tester.pumpWidget(_wrap(RewardConfetti(key: key, serial: 1)));
      await tester.pump();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets(
        'Rewards on + Reduce Motion on renders nothing even on a genuine '
        'trigger — calm, no animated confetti', (tester) async {
      await LocalPreferencesService.instance.setRewardsEnabled(true);
      await LocalPreferencesService.instance.setReduceMotion(true);
      final key = GlobalKey();
      await tester.pumpWidget(_wrap(RewardConfetti(key: key, serial: 0)));
      await tester.pumpWidget(_wrap(RewardConfetti(key: key, serial: 1)));
      await tester.pump();
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets(
        'Rewards off renders nothing on a genuine trigger, regardless of '
        'motion setting', (tester) async {
      await LocalPreferencesService.instance.setRewardsEnabled(false);
      await LocalPreferencesService.instance.setReduceMotion(false);
      final key = GlobalKey();
      await tester.pumpWidget(_wrap(RewardConfetti(key: key, serial: 0)));
      await tester.pumpWidget(_wrap(RewardConfetti(key: key, serial: 1)));
      await tester.pump();
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('an unchanged serial renders nothing even with Rewards on',
        (tester) async {
      await LocalPreferencesService.instance.setRewardsEnabled(true);
      await LocalPreferencesService.instance.setReduceMotion(false);
      await tester.pumpWidget(_wrap(const RewardConfetti(serial: 0)));
      await tester.pump();
      expect(find.byType(SizedBox), findsOneWidget);
    });
  });

  test(
      'MascotFuelService.celebrationSerial only advances when the daily '
      'mission target is actually reached — not on every fuel gain '
      '(this is the milestone signal practice_screen.dart\'s session '
      'confetti now listens to, replacing the old per-answer counter)',
      () async {
    final before = MascotFuelService.instance.celebrationSerial.value;
    for (var i = 0; i < MascotFuelService.missionTarget - 1; i++) {
      await MascotFuelService.instance.incrementDailyMission();
    }
    expect(MascotFuelService.instance.celebrationSerial.value, before,
        reason: 'no celebration yet — target not reached');

    await MascotFuelService.instance.incrementDailyMission();
    expect(MascotFuelService.instance.celebrationSerial.value, before + 1,
        reason: 'celebration fires exactly once the target is reached');

    // A 6th correct answer (past target) must not fire again.
    await MascotFuelService.instance.addFuel(4);
    expect(MascotFuelService.instance.celebrationSerial.value, before + 1);
  });
}
