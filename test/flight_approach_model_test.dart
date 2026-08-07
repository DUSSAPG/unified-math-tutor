import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/flight_approach_model.dart';

void main() {
  group('required glide angle calculation', () {
    test('tan(angle) = altitude / groundDistance, rearranged for the angle',
        () {
      const model = FlightApproachModel(
        startingAltitudeM: 300,
        groundDistanceM: 300 / 0.05240778, // altitude/distance ~ tan(3deg)
        airspeedMps: 60,
        descentAngleRadians: 0.1,
      );
      expect(model.requiredGlideAngleDegrees, closeTo(3.0, 0.01));
    });

    test('a steeper altitude/distance ratio requires a steeper angle', () {
      const shallow = FlightApproachModel(
        startingAltitudeM: 100,
        groundDistanceM: 2000,
        airspeedMps: 60,
        descentAngleRadians: 0.1,
      );
      const steep = FlightApproachModel(
        startingAltitudeM: 500,
        groundDistanceM: 2000,
        airspeedMps: 60,
        descentAngleRadians: 0.1,
      );
      expect(steep.requiredGlideAngleDegrees,
          greaterThan(shallow.requiredGlideAngleDegrees));
    });
  });

  group('time-to-runway calculation', () {
    test('timeToRunway = groundDistance / horizontalSpeed', () {
      final angle = 10 * math.pi / 180;
      final model = FlightApproachModel(
        startingAltitudeM: 300,
        groundDistanceM: 5000,
        airspeedMps: 100,
        descentAngleRadians: angle,
      );
      final expectedHorizontalSpeed = 100 * math.cos(angle);
      expect(model.timeToRunwaySeconds,
          closeTo(5000 / expectedHorizontalSpeed, 1e-9));
    });
  });

  group('horizontal and vertical vector components', () {
    test(
        'horizontalSpeed = airspeed * cos(angle), verticalSpeed = airspeed * sin(angle)',
        () {
      final angle = 20 * math.pi / 180;
      final model = FlightApproachModel(
        startingAltitudeM: 200,
        groundDistanceM: 3000,
        airspeedMps: 80,
        descentAngleRadians: angle,
      );
      expect(model.horizontalSpeedMps, closeTo(80 * math.cos(angle), 1e-9));
      expect(model.verticalSpeedMps, closeTo(80 * math.sin(angle), 1e-9));
    });

    test(
        'the vector components combine back to the airspeed (Pythagoras check)',
        () {
      final angle = 33 * math.pi / 180;
      final model = FlightApproachModel(
        startingAltitudeM: 200,
        groundDistanceM: 3000,
        airspeedMps: 80,
        descentAngleRadians: angle,
      );
      final resultant = math.sqrt(
          model.horizontalSpeedMps * model.horizontalSpeedMps +
              model.verticalSpeedMps * model.verticalSpeedMps);
      expect(resultant, closeTo(80, 1e-9));
    });
  });

  group('touchdown prediction', () {
    test('touchdownDistance = altitude / tan(angle)', () {
      final angle = 5 * math.pi / 180;
      final model = FlightApproachModel(
        startingAltitudeM: 300,
        groundDistanceM: 4000,
        airspeedMps: 70,
        descentAngleRadians: angle,
      );
      expect(model.predictedTouchdownDistanceM,
          closeTo(300 / math.tan(angle), 1e-6));
    });

    test('flying exactly the required glide angle lands within tolerance', () {
      const model = FlightApproachModel(
        startingAltitudeM: 300,
        groundDistanceM: 4000,
        airspeedMps: 70,
        descentAngleRadians: 0, // placeholder, overwritten below
      );
      final onGlide =
          model.copyWith(descentAngleRadians: model.requiredGlideAngleRadians);
      expect(onGlide.touchdownErrorM.abs(),
          lessThan(kApproachTouchdownToleranceM));
      expect(onGlide.status, ApproachStatus.safe);
    });
  });

  group('steep and shallow classification', () {
    test('a much steeper angle than required touches down short (too steep)',
        () {
      const model = FlightApproachModel(
        startingAltitudeM: 300,
        groundDistanceM: 4000,
        airspeedMps: 70,
        descentAngleRadians: 0,
      );
      final tooSteep = model.copyWith(
          descentAngleRadians: model.requiredGlideAngleRadians * 3);
      expect(tooSteep.touchdownErrorM, lessThan(0));
      expect(tooSteep.status, ApproachStatus.tooSteep);
    });

    test(
        'a much shallower angle than required is still airborne past the runway (too shallow)',
        () {
      const model = FlightApproachModel(
        startingAltitudeM: 300,
        groundDistanceM: 4000,
        airspeedMps: 70,
        descentAngleRadians: 0,
      );
      final tooShallow = model.copyWith(
          descentAngleRadians: model.requiredGlideAngleRadians * 0.3);
      expect(tooShallow.touchdownErrorM, greaterThan(0));
      expect(tooShallow.status, ApproachStatus.tooShallow);
    });
  });

  group('touchdown position relative to the runway', () {
    test('a safe landing touches down at ~0 distance from the runway', () {
      const model = FlightApproachModel(
        startingAltitudeM: 300,
        groundDistanceM: 4000,
        airspeedMps: 70,
        descentAngleRadians: 0,
      );
      final onGlide =
          model.copyWith(descentAngleRadians: model.requiredGlideAngleRadians);
      expect(onGlide.touchdownPositionFromRunwayM.abs(),
          lessThan(kApproachTouchdownToleranceM));
    });

    test('too steep touches down before the runway (positive position)', () {
      const model = FlightApproachModel(
        startingAltitudeM: 300,
        groundDistanceM: 4000,
        airspeedMps: 70,
        descentAngleRadians: 0,
      );
      final tooSteep = model.copyWith(
          descentAngleRadians: model.requiredGlideAngleRadians * 3);
      expect(tooSteep.touchdownPositionFromRunwayM, greaterThan(0));
    });

    test('too shallow touches down past the runway (negative position)', () {
      const model = FlightApproachModel(
        startingAltitudeM: 300,
        groundDistanceM: 4000,
        airspeedMps: 70,
        descentAngleRadians: 0,
      );
      final tooShallow = model.copyWith(
          descentAngleRadians: model.requiredGlideAngleRadians * 0.3);
      expect(tooShallow.touchdownPositionFromRunwayM, lessThan(0));
    });
  });

  group('unit conversion', () {
    test('descentAngleDegrees is the radians value converted to degrees', () {
      const model = FlightApproachModel(
        startingAltitudeM: 100,
        groundDistanceM: 1000,
        airspeedMps: 50,
        descentAngleRadians: math.pi / 6, // 30 degrees
      );
      expect(model.descentAngleDegrees, closeTo(30, 1e-9));
    });
  });

  group('invalid and non-finite inputs', () {
    test('a zero descent angle does not divide by zero', () {
      const model = FlightApproachModel(
        startingAltitudeM: 200,
        groundDistanceM: 3000,
        airspeedMps: 60,
        descentAngleRadians: 0,
      );
      expect(model.verticalSpeedMps.isFinite, isTrue);
      expect(
          model.predictedTouchdownDistanceM.isFinite ||
              model.predictedTouchdownDistanceM == double.infinity,
          isTrue);
      expect(model.status, isNotNull);
    });

    test('a 90-degree descent angle does not divide by zero', () {
      const model = FlightApproachModel(
        startingAltitudeM: 200,
        groundDistanceM: 3000,
        airspeedMps: 60,
        descentAngleRadians: math.pi / 2,
      );
      expect(model.horizontalSpeedMps.isFinite, isTrue);
      expect(model.timeToRunwaySeconds.isFinite, isTrue);
    });

    test('NaN airspeed produces finite, non-crashing derived values', () {
      const model = FlightApproachModel(
        startingAltitudeM: 200,
        groundDistanceM: 3000,
        airspeedMps: double.nan,
        descentAngleRadians: 0.1,
      );
      expect(model.horizontalSpeedMps.isFinite, isTrue);
      expect(model.verticalSpeedMps.isFinite, isTrue);
      expect(model.timeToRunwaySeconds.isFinite, isTrue);
    });

    test('negative ground distance is treated as zero, not negative', () {
      const model = FlightApproachModel(
        startingAltitudeM: 200,
        groundDistanceM: -500,
        airspeedMps: 60,
        descentAngleRadians: 0.1,
      );
      expect(model.timeToRunwaySeconds, 0);
    });

    test('extreme non-finite descent angle falls back to a safe clamp', () {
      const model = FlightApproachModel(
        startingAltitudeM: 200,
        groundDistanceM: 3000,
        airspeedMps: 60,
        descentAngleRadians: double.infinity,
      );
      expect(model.horizontalSpeedMps.isFinite, isTrue);
      expect(model.verticalSpeedMps.isFinite, isTrue);
    });

    test(
        'altitudeAtHorizontalDistanceRemaining stays within [0, startingAltitude]',
        () {
      const model = FlightApproachModel(
        startingAltitudeM: 300,
        groundDistanceM: 4000,
        airspeedMps: 70,
        descentAngleRadians: 0.5, // steep enough to reach ground before x=0
      );
      for (final remaining in [
        4000.0,
        3000.0,
        2000.0,
        1000.0,
        0.0,
        -500.0,
        double.nan
      ]) {
        final altitude = model.altitudeAtHorizontalDistanceRemaining(remaining);
        expect(altitude, greaterThanOrEqualTo(0));
        expect(altitude, lessThanOrEqualTo(300));
      }
    });

    test('altitude decreases monotonically as remaining distance decreases',
        () {
      const model = FlightApproachModel(
        startingAltitudeM: 300,
        groundDistanceM: 4000,
        airspeedMps: 70,
        descentAngleRadians: 0.05,
      );
      double? previous;
      for (final remaining in [4000.0, 3000.0, 2000.0, 1000.0, 0.0]) {
        final altitude = model.altitudeAtHorizontalDistanceRemaining(remaining);
        if (previous != null) {
          expect(altitude, lessThanOrEqualTo(previous));
        }
        previous = altitude;
      }
    });
  });

  group('copyWith', () {
    test('copyWith replaces only the given fields', () {
      const model = FlightApproachModel(
        startingAltitudeM: 300,
        groundDistanceM: 4000,
        airspeedMps: 70,
        descentAngleRadians: 0.1,
      );
      final updated = model.copyWith(airspeedMps: 90);
      expect(updated.airspeedMps, 90);
      expect(updated.descentAngleRadians, 0.1);
      expect(updated.startingAltitudeM, 300);
      expect(updated.groundDistanceM, 4000);
    });
  });
}
