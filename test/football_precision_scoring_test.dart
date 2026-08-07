import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/football_precision_scoring.dart';

void main() {
  group('footballTargetZoneForAttempt', () {
    test('cycles 1-5 and wraps back to 1 on the 6th attempt', () {
      expect(footballTargetZoneForAttempt(0), 1);
      expect(footballTargetZoneForAttempt(1), 2);
      expect(footballTargetZoneForAttempt(2), 3);
      expect(footballTargetZoneForAttempt(3), 4);
      expect(footballTargetZoneForAttempt(4), 5);
      expect(footballTargetZoneForAttempt(5), 1);
    });
  });

  group('footballIdealAngleForZone', () {
    test('spans -30 to 30 degrees across the 5 zones', () {
      expect(footballIdealAngleForZone(1), -30);
      expect(footballIdealAngleForZone(2), -15);
      expect(footballIdealAngleForZone(3), 0);
      expect(footballIdealAngleForZone(4), 15);
      expect(footballIdealAngleForZone(5), 30);
    });
  });

  group('scoreFootballKick', () {
    test('scores 100 for a perfect angle and ideal power', () {
      final score = scoreFootballKick(
        angle: footballIdealAngleForZone(3).toDouble(),
        power: footballIdealPower,
        targetZone: 3,
      );
      expect(score, 100);
      expect(isFootballKickHit(score), isTrue);
    });

    test('degrades score with angle error, weighted more than power error', () {
      final angleOff = scoreFootballKick(
        angle: footballIdealAngleForZone(1) + 10,
        power: footballIdealPower,
        targetZone: 1,
      );
      final powerOff = scoreFootballKick(
        angle: footballIdealAngleForZone(1).toDouble(),
        power: footballIdealPower + 10,
        targetZone: 1,
      );
      expect(angleOff, 82); // 100 - 10*1.8
      expect(powerOff, 92); // 100 - 10*0.8
      expect(angleOff, lessThan(powerOff),
          reason: 'Angle error must cost more than the same power error');
    });

    test('clamps at 0 for a wildly wrong kick, never negative', () {
      final score = scoreFootballKick(angle: 40, power: 40, targetZone: 1);
      expect(score, 0);
      expect(isFootballKickHit(score), isFalse);
    });

    test('hit threshold is exactly score >= 75', () {
      expect(isFootballKickHit(75), isTrue);
      expect(isFootballKickHit(74), isFalse);
    });
  });
}
