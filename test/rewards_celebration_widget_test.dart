import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/widgets/shared/reward_confetti.dart';

void main() {
  test('Rewards toggle persists locally', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = LocalPreferencesService.instance;
    await prefs.init();
    await prefs.setRewardsEnabled(true);
    await prefs.init();

    final storage = await SharedPreferences.getInstance();
    expect(storage.getBool('rewards_enabled'), isTrue);
    expect(prefs.rewardsEnabled.value, isTrue);
  });

  testWidgets('celebration renders only when Rewards is enabled',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = LocalPreferencesService.instance;
    await prefs.init();
    final confettiPaint = find.byWidgetPredicate(
      (widget) =>
          widget is CustomPaint &&
          widget.painter.runtimeType.toString() == '_ConfettiPainter',
    );

    Future<void> pumpConfetti(String state) => tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox.expand(
                child: RewardConfetti(key: ValueKey('celebration-$state')),
              ),
            ),
          ),
        );

    await pumpConfetti('off-1');
    expect(
      confettiPaint,
      findsNothing,
    );

    await prefs.setRewardsEnabled(true);
    await pumpConfetti('on');
    expect(
      confettiPaint,
      findsOneWidget,
    );

    await prefs.setRewardsEnabled(false);
    await pumpConfetti('off-2');
    expect(
      confettiPaint,
      findsNothing,
    );
  });
}
