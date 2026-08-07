import 'dart:math' as math;

/// Whether a descent, played out to the runway threshold, lands safely,
/// touches down early ("too steep"), or is still airborne once it passes
/// over the runway ("too shallow"). Purely a function of [touchdownErrorM]
/// against a fixed tolerance — no lateral/bearing dimension exists in this
/// side-profile-only model, so there is no "misaligned" outcome here (see
/// the Aircraft Landing Lab build report for that explicitly deferred
/// scope).
enum ApproachStatus { safe, tooSteep, tooShallow }

/// Metres of touchdown error either side of the runway threshold that
/// still counts as a safe landing.
const double kApproachTouchdownToleranceM = 30.0;

/// A descent angle is never allowed to reach exactly 0° (infinite time to
/// runway) or 90° (infinite touchdown distance) — clamped to a realistic,
/// numerically safe range for every derived calculation.
const double kMinDescentAngleRadians = 1 * math.pi / 180;
const double kMaxDescentAngleRadians = 60 * math.pi / 180;

double _clampAngle(double radians) {
  if (!radians.isFinite) return kMinDescentAngleRadians;
  return radians.clamp(kMinDescentAngleRadians, kMaxDescentAngleRadians);
}

double _safeDivide(double numerator, double denominator,
    {double fallback = 0}) {
  if (!numerator.isFinite || !denominator.isFinite || denominator == 0) {
    return fallback;
  }
  final result = numerator / denominator;
  return result.isFinite ? result : fallback;
}

/// The testable mathematical core of the Aircraft Landing Lab — a straight-
/// line descent from `(groundDistanceM, startingAltitudeM)` toward the
/// runway threshold at `(0, 0)`. Angles are stored **internally in
/// radians** ([descentAngleRadians]); [descentAngleDegrees] is a display
/// convenience only. Every derived getter guards against non-finite or
/// zero-denominator inputs rather than throwing, since learner-controlled
/// sliders can legally reach the edges of their range.
///
/// Sign convention: [touchdownErrorM] is positive when the aircraft is
/// still airborne after passing over the runway threshold (too shallow —
/// it would overshoot), negative when it touches down before reaching the
/// threshold (too steep — it would land short).
class FlightApproachModel {
  const FlightApproachModel({
    required this.startingAltitudeM,
    required this.groundDistanceM,
    required this.airspeedMps,
    required this.descentAngleRadians,
  });

  final double startingAltitudeM;
  final double groundDistanceM;
  final double airspeedMps;
  final double descentAngleRadians;

  double get descentAngleDegrees => descentAngleRadians * 180 / math.pi;

  double get _safeAngle => _clampAngle(descentAngleRadians);
  double get _safeAirspeed =>
      airspeedMps.isFinite && airspeedMps > 0 ? airspeedMps : 0.0;
  double get _safeGroundDistance =>
      groundDistanceM.isFinite && groundDistanceM >= 0 ? groundDistanceM : 0.0;
  double get _safeAltitude =>
      startingAltitudeM.isFinite && startingAltitudeM >= 0
          ? startingAltitudeM
          : 0.0;

  /// `horizontalSpeed = airspeed * cos(angle)`.
  double get horizontalSpeedMps => _safeAirspeed * math.cos(_safeAngle);

  /// `verticalSpeed = airspeed * sin(angle)`.
  double get verticalSpeedMps => _safeAirspeed * math.sin(_safeAngle);

  /// `timeToRunway = groundDistance / horizontalSpeed` — time to cover the
  /// horizontal distance to the runway threshold at the current heading's
  /// horizontal speed component. Zero if horizontal speed is (numerically)
  /// zero rather than a division-by-zero crash.
  double get timeToRunwaySeconds =>
      _safeDivide(_safeGroundDistance, horizontalSpeedMps);

  /// `tan(angle) = altitude / groundDistance`, rearranged for the angle —
  /// the exact glide slope this altitude/distance pair requires for a
  /// perfectly smooth landing.
  double get requiredGlideAngleRadians =>
      math.atan2(_safeAltitude, _safeGroundDistance);
  double get requiredGlideAngleDegrees =>
      requiredGlideAngleRadians * 180 / math.pi;

  /// Horizontal distance *covered* — flown forward from the starting
  /// position — before this descent reaches ground level
  /// (`altitude / tan(angle)`). Compared against [groundDistanceM] (the
  /// distance that needed to be covered to reach the runway) via
  /// [touchdownErrorM]: covering *less* than [groundDistanceM] means
  /// touching down before the runway (too steep); covering *more* means
  /// still airborne once past the runway's horizontal position (too
  /// shallow). Not clamped to [groundDistanceM] — overshooting or
  /// undershooting it is exactly what this predicts. `double.infinity` for
  /// a (numerically) level descent that never reaches the ground.
  double get predictedTouchdownDistanceM =>
      _safeDivide(_safeAltitude, math.tan(_safeAngle),
          fallback: double.infinity);

  /// Positive = still airborne past the runway threshold (too shallow).
  /// Negative = touched down before reaching it (too steep).
  double get touchdownErrorM {
    final touchdown = predictedTouchdownDistanceM;
    if (!touchdown.isFinite) return double.infinity;
    return touchdown - _safeGroundDistance;
  }

  /// Where touchdown actually happens, expressed in the same "distance
  /// remaining to the runway threshold" terms as
  /// [altitudeAtHorizontalDistanceRemaining]'s input — 0 at the runway,
  /// positive before it (undershoot/too steep), negative past it
  /// (overshoot/too shallow). Convenience for painters/views so they don't
  /// need to re-derive `groundDistanceM - predictedTouchdownDistanceM`
  /// themselves.
  double get touchdownPositionFromRunwayM => -touchdownErrorM;

  ApproachStatus get status {
    final error = touchdownErrorM;
    if (!error.isFinite || error > kApproachTouchdownToleranceM) {
      return ApproachStatus.tooShallow;
    }
    if (error < -kApproachTouchdownToleranceM) return ApproachStatus.tooSteep;
    return ApproachStatus.safe;
  }

  /// Altitude when [remainingM] of ground distance are left to the runway
  /// threshold (counts down from [groundDistanceM] to 0 as the aircraft
  /// approaches) — the function [FlightApproachView] samples to draw and
  /// animate the actual descent path. Clamped to `[0, startingAltitudeM]`:
  /// the drawn path never shows the aircraft below ground or above its
  /// starting altitude.
  double altitudeAtHorizontalDistanceRemaining(double remainingM) {
    final safeRemaining = remainingM.isFinite
        ? remainingM.clamp(0.0, _safeGroundDistance)
        : _safeGroundDistance;
    final distanceCovered = _safeGroundDistance - safeRemaining;
    final altitude = _safeAltitude - distanceCovered * math.tan(_safeAngle);
    if (!altitude.isFinite) return _safeAltitude;
    return altitude.clamp(0.0, _safeAltitude);
  }

  FlightApproachModel copyWith({
    double? descentAngleRadians,
    double? airspeedMps,
  }) {
    return FlightApproachModel(
      startingAltitudeM: startingAltitudeM,
      groundDistanceM: groundDistanceM,
      airspeedMps: airspeedMps ?? this.airspeedMps,
      descentAngleRadians: descentAngleRadians ?? this.descentAngleRadians,
    );
  }
}
