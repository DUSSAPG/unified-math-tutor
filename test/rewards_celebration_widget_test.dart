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

    // Each call mounts a brand-new RewardConfetti (fresh key), standing in
    // for a widget created specifically for an event that just happened —
    // hence autoplayOnMount: true (see reward_confetti.dart class doc).
    // This is deliberately NOT the default (serial-delta) contract: this
    // test is purely about preference gating, not trigger detection.
    Future<void> pumpConfetti(String state) => tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox.expand(
                child: RewardConfetti(
                  key: ValueKey('celebration-$state'),
                  serial: 1,
                  autoplayOnMount: true,
                ),
              ),
            ),
          ),
        );

    await pumpConfetti('off-1');
    await tester.pump();
    expect(
      confettiPaint,
      findsNothing,
    );

    await prefs.setRewardsEnabled(true);
    await pumpConfetti('on');
    await tester.pump();
    expect(
      confettiPaint,
      findsOneWidget,
    );

    await prefs.setRewardsEnabled(false);
    await pumpConfetti('off-2');
    await tester.pump();
    expect(
      confettiPaint,
      findsNothing,
    );
  });
}
