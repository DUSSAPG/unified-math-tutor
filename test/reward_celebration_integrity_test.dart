import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/mascot_fuel_service.dart';
import 'package:unified_math_tutor/widgets/shared/reward_confetti.dart';

/// D2.1 rewards-integrity corrective pass.
Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await MascotFuelService.instance.init();
  });

  group('RewardConfetti preference gating', () {
    testWidgets('Rewards on + Reduce Motion off + play=true renders',
        (tester) async {
      await LocalPreferencesService.instance.setRewardsEnabled(true);
      await LocalPreferencesService.instance.setReduceMotion(false);
      await tester.pumpWidget(_wrap(const RewardConfetti(play: true)));
      await tester.pump();
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets(
        'Rewards on + Reduce Motion on renders nothing — calm, no '
        'animated confetti', (tester) async {
      await LocalPreferencesService.instance.setRewardsEnabled(true);
      await LocalPreferencesService.instance.setReduceMotion(true);
      await tester.pumpWidget(_wrap(const RewardConfetti(play: true)));
      await tester.pump();
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('Rewards off renders nothing, regardless of motion setting',
        (tester) async {
      await LocalPreferencesService.instance.setRewardsEnabled(false);
      await LocalPreferencesService.instance.setReduceMotion(false);
      await tester.pumpWidget(_wrap(const RewardConfetti(play: true)));
      await tester.pump();
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('play=false renders nothing even with Rewards on',
        (tester) async {
      await LocalPreferencesService.instance.setRewardsEnabled(true);
      await LocalPreferencesService.instance.setReduceMotion(false);
      await tester.pumpWidget(_wrap(const RewardConfetti(play: false)));
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
