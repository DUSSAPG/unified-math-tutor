import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/create_angle/create_angle_session.dart';

/// The maths contract of Create the Angle, independent of any widget.
void main() {
  group('includedAngle (atan2 of cross and dot)', () {
    test('exact 30°, 45°, 60° and 90° from independent exact vectors', () {
      // Screen coordinates: y grows downwards, so "up" is negative y. The
      // included angle is the same above or below the baseline.
      for (final (x, y, expected) in [
        (math.sqrt(3), -1.0, 30.0),
        (1.0, -1.0, 45.0),
        (1.0, -math.sqrt(3), 60.0),
        (0.0, -1.0, 90.0),
      ]) {
        expect(includedAngle(1, 0, x, y), closeTo(expected, 1e-10));
        expect(includedAngle(1, 0, x, -y), closeTo(expected, 1e-10));
        // Scaling either vector never changes the angle.
        expect(includedAngle(7, 0, x * 250, y * 250), closeTo(expected, 1e-10));
      }
    });

    test('edge directions and extreme magnitudes', () {
      expect(includedAngle(1, 0, 1, 0), 0);
      expect(includedAngle(1, 0, -1, 0), 180);
      expect(includedAngle(0, 1, -1, 0), 90);
      expect(includedAngle(1e300, 0, 0, 1e300), 90);
      expect(includedAngle(1e-300, 0, 1e-300, 1e-300), closeTo(45, 1e-10));
      // Near 0° and 180°, where acos would lose precision.
      expect(includedAngle(1, 0, 1, 1e-9), closeTo(5.729577951e-8, 1e-15));
      expect(includedAngle(1, 0, -1, 1e-9), closeTo(180, 1e-7));
    });

    test('rejects zero-length and non-finite vectors', () {
      expect(() => includedAngle(0, 0, 1, 1), throwsArgumentError);
      expect(() => includedAngle(1, 0, 0, 0), throwsArgumentError);
      expect(() => includedAngle(1, 0, double.nan, 1), throwsArgumentError);
      expect(
          () => includedAngle(double.infinity, 0, 1, 1), throwsArgumentError);
    });
  });

  test('normalisation folds negative, reflex and full turns onto 0–180°', () {
    for (final (input, expected) in [
      (0.0, 0.0),
      (45.0, 45.0),
      (180.0, 180.0),
      (360.0, 0.0),
      (-30.0, 30.0),
      (390.0, 30.0),
      (270.0, 90.0),
      (315.0, 45.0),
      (720.0, 0.0),
      (-240.0, 120.0),
      (-180.0, 180.0),
    ]) {
      expect(normaliseLearningAngle(input), expected, reason: '$input');
    }
    expect(() => normaliseLearningAngle(double.infinity), throwsArgumentError);
    expect(() => normaliseLearningAngle(double.nan), throwsArgumentError);
  });

  test('success tolerance is exactly an inclusive ±2°', () {
    expect(createAngleTolerance, 2);
    for (final target in CreateAngleSession.targets) {
      final t = target.toDouble();
      expect(matchesAngle(t, t), isTrue);
      expect(matchesAngle(t - 2, t), isTrue);
      expect(matchesAngle(t + 2, t), isTrue);
      expect(matchesAngle(t - 2.001, t), isFalse);
      expect(matchesAngle(t + 2.001, t), isFalse);
    }
    expect(matchesAngle(double.nan, 30), isFalse);
  });

  group('CreateAngleSession', () {
    test('starts at the first target with the aim on the baseline', () {
      final s = CreateAngleSession();
      expect(CreateAngleSession.targets, [30, 45, 60, 90]);
      expect(s.target, 30);
      expect(s.angle, 0);
      expect(s.lastCheck, isNull);
      expect(s.matched, isEmpty);
      expect(s.allMatched, isFalse);
    });

    test('aim normalises; adjust steps and clamps without wrapping', () {
      final s = CreateAngleSession()..aim(-30);
      expect(s.angle, 30);
      s.aim(390);
      expect(s.angle, 30);
      s.adjust(1);
      expect(s.angle, 31);
      s.adjust(-2);
      expect(s.angle, 29);
      s.adjust(500);
      expect(s.angle, 180);
      s.adjust(1);
      expect(s.angle, 180, reason: 'never wraps from 180° back to 0°');
      s.adjust(-500);
      expect(s.angle, 0);
    });

    test('a near miss reports the difference and direction as data', () {
      final s = CreateAngleSession()..aim(25);
      var c = s.check();
      expect(c.outcome, CreateAngleOutcome.turnWider);
      expect(c.matched, isFalse);
      expect(c.attempted, 25);
      expect(c.difference, 5);
      expect(s.angle, 25, reason: 'a miss never moves the aim');
      expect(s.matched, isEmpty);

      s.aim(32.5);
      c = s.check();
      expect(c.outcome, CreateAngleOutcome.turnNarrower);
      expect(c.difference, closeTo(2.5, 1e-12));
    });

    test('a match within ±2° snaps to exactly the target', () {
      for (final offset in [-2.0, -1.5, 0.0, 1.0, 2.0]) {
        final s = CreateAngleSession()..select(60);
        s.aim(60 + offset);
        final c = s.check();
        expect(c.outcome, CreateAngleOutcome.matched, reason: '$offset');
        expect(c.attempted, 60 + offset);
        expect(s.angle, 60);
        expect(s.isMatched(60), isTrue);
      }
    });

    test('changing the aim clears the previous check', () {
      final s = CreateAngleSession()..aim(10);
      s.check();
      expect(s.lastCheck, isNotNull);
      s.adjust(1);
      expect(s.lastCheck, isNull);
    });

    test('target selection, reset, next and all-four completion', () {
      final s = CreateAngleSession();
      expect(() => s.select(75), throwsArgumentError);
      for (final target in CreateAngleSession.targets) {
        s.select(target);
        expect(s.target, target);
        expect(s.angle, 0, reason: 'selecting starts a fresh attempt');
        s.aim(target + 1.5);
        expect(s.check().matched, isTrue);
      }
      expect(s.allMatched, isTrue);
      expect(s.matched, {30, 45, 60, 90});

      // Reset Pitch is not a new session.
      s.resetPitch();
      expect(s.angle, 0);
      expect(s.lastCheck, isNull);
      expect(s.matched.length, 4);

      // Restart is.
      s.restart();
      expect(s.matched, isEmpty);
      expect(s.target, 30);
      expect(CreateAngleSession().matched, isEmpty);
    });

    test('next suggests the next unmatched target, wrapping round', () {
      final s = CreateAngleSession()..select(30);
      expect(s.nextTarget, 45);
      s
        ..select(45)
        ..aim(45)
        ..check()
        ..select(30);
      expect(s.nextTarget, 60, reason: '45° is already matched');
      s.select(90);
      expect(s.nextTarget, 30);
      s.next();
      expect(s.target, 30);
      // Once all are matched, it simply walks the list.
      for (final t in CreateAngleSession.targets) {
        s
          ..select(t)
          ..aim(t.toDouble())
          ..check();
      }
      s.select(90);
      expect(s.nextTarget, 30);
    });

    test('the matched set cannot be edited from outside', () {
      final s = CreateAngleSession();
      expect(() => s.matched.add(30), throwsUnsupportedError);
    });
  });
}
