import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/aircraft_landing_challenge.dart';

void main() {
  group('FindTheTimeChallenge deterministic sequence', () {
    test('same index always produces the same scenario', () {
      final a = FindTheTimeChallenge.forIndex(2);
      final b = FindTheTimeChallenge.forIndex(2);
      expect(a.groundDistanceM, b.groundDistanceM);
      expect(a.horizontalSpeedMps, b.horizontalSpeedMps);
    });

    test('correctTimeSeconds = distance / speed', () {
      final challenge = FindTheTimeChallenge.forIndex(0);
      expect(challenge.correctTimeSeconds,
          challenge.groundDistanceM / challenge.horizontalSpeedMps);
    });

    test('options always include the correct answer exactly once', () {
      for (var i = 0; i < 4; i++) {
        final challenge = FindTheTimeChallenge.forIndex(i);
        final matches =
            challenge.options.where((o) => o == challenge.correctTimeSeconds);
        expect(matches.length, 1);
      }
    });

    test('options are sorted ascending', () {
      final options = FindTheTimeChallenge.forIndex(0).options;
      for (var i = 1; i < options.length; i++) {
        expect(options[i], greaterThanOrEqualTo(options[i - 1]));
      }
    });

    test('negative index does not throw', () {
      expect(() => FindTheTimeChallenge.forIndex(-1), returnsNormally);
    });
  });

  group('DescentLineChallenge deterministic sequence', () {
    test('same index always produces the same target', () {
      final a = DescentLineChallenge.forIndex(1);
      final b = DescentLineChallenge.forIndex(1);
      expect(a.targetAngleDegrees, b.targetAngleDegrees);
    });

    test('matches() uses angular tolerance, not exact equality', () {
      final challenge = DescentLineChallenge.forIndex(0);
      final closeAngle = (challenge.targetAngleDegrees + 0.5) * math.pi / 180;
      expect(challenge.matches(closeAngle), isTrue);
    });

    test('matches() rejects an angle well outside tolerance', () {
      final challenge = DescentLineChallenge.forIndex(0);
      final farAngle = (challenge.targetAngleDegrees + 10) * math.pi / 180;
      expect(challenge.matches(farAngle), isFalse);
    });

    test('cycles through scenarios deterministically', () {
      final seen = <double>{};
      for (var i = 0; i < 4; i++) {
        seen.add(DescentLineChallenge.forIndex(i).targetAngleDegrees);
      }
      expect(seen.length, 4);
      expect(DescentLineChallenge.forIndex(4).targetAngleDegrees,
          DescentLineChallenge.forIndex(0).targetAngleDegrees);
    });
  });

  group('GlidePathChallenge deterministic sequence', () {
    test('same index always produces the same scenario', () {
      final a = GlidePathChallenge.forIndex(3);
      final b = GlidePathChallenge.forIndex(3);
      expect(a.startingAltitudeM, b.startingAltitudeM);
      expect(a.groundDistanceM, b.groundDistanceM);
    });

    test('every scenario has a positive altitude and ground distance', () {
      for (var i = 0; i < 4; i++) {
        final challenge = GlidePathChallenge.forIndex(i);
        expect(challenge.startingAltitudeM, greaterThan(0));
        expect(challenge.groundDistanceM, greaterThan(0));
      }
    });
  });

  group('VectorApproachChallenge deterministic sequence', () {
    test('same index always produces the same target components', () {
      final a = VectorApproachChallenge.forIndex(2);
      final b = VectorApproachChallenge.forIndex(2);
      expect(a.targetHorizontalMps, b.targetHorizontalMps);
      expect(a.targetVerticalMps, b.targetVerticalMps);
    });

    test('matches() uses component tolerance, not exact equality', () {
      final challenge = VectorApproachChallenge.forIndex(0);
      expect(
        challenge.matches(
            challenge.targetHorizontalMps + 1, challenge.targetVerticalMps - 1),
        isTrue,
      );
    });

    test('matches() rejects components well outside tolerance', () {
      final challenge = VectorApproachChallenge.forIndex(0);
      expect(
        challenge.matches(
            challenge.targetHorizontalMps + 20, challenge.targetVerticalMps),
        isFalse,
      );
    });

    test('targetResultantMps is the Pythagorean magnitude of the components',
        () {
      final challenge = VectorApproachChallenge.forIndex(1);
      final expected = math.sqrt(
          challenge.targetHorizontalMps * challenge.targetHorizontalMps +
              challenge.targetVerticalMps * challenge.targetVerticalMps);
      expect(challenge.targetResultantMps, closeTo(expected, 1e-9));
    });
  });
}
