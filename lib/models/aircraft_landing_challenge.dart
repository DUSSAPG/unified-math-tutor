import 'dart:math' as math;

/// Deterministic challenge generators for the four Aircraft Landing Lab
/// activities — every `forIndex` is a pure function of its index (no
/// unseeded `Random()`), mirroring `spatial_cube_challenge.dart`'s
/// convention exactly.

/// "Find the Time" — a horizontal speed and ground distance (angle
/// deliberately not involved, so this activity teaches plain
/// speed-distance-time before the later activities add angle/gradient),
/// multiple-choice among the correct time and three deterministic decoys.
class FindTheTimeChallenge {
  const FindTheTimeChallenge({
    required this.groundDistanceM,
    required this.horizontalSpeedMps,
  });

  final double groundDistanceM;
  final double horizontalSpeedMps;

  double get correctTimeSeconds => groundDistanceM / horizontalSpeedMps;

  /// The correct time plus three deterministic decoys (half, 1.5x, double),
  /// sorted ascending so the UI can present them in a stable, predictable
  /// order.
  List<double> get options {
    final correct = correctTimeSeconds;
    final all = <double>{correct, correct * 0.5, correct * 1.5, correct * 2}
        .toList()
      ..sort();
    return all;
  }

  static final List<FindTheTimeChallenge> _scenarios = [
    const FindTheTimeChallenge(groundDistanceM: 6000, horizontalSpeedMps: 60),
    const FindTheTimeChallenge(groundDistanceM: 9000, horizontalSpeedMps: 50),
    const FindTheTimeChallenge(groundDistanceM: 4000, horizontalSpeedMps: 40),
    const FindTheTimeChallenge(groundDistanceM: 12000, horizontalSpeedMps: 80),
  ];

  static FindTheTimeChallenge forIndex(int index) {
    final safeIndex = index < 0 ? 0 : index;
    return _scenarios[safeIndex % _scenarios.length];
  }
}

/// "Follow the Descent Line" — a target descent angle (the line's
/// gradient) the learner adjusts their own angle to match, checked with an
/// angular tolerance rather than exact equality.
class DescentLineChallenge {
  const DescentLineChallenge({
    required this.targetAngleDegrees,
    required this.groundDistanceM,
    required this.startingAltitudeM,
  });

  final double targetAngleDegrees;
  final double groundDistanceM;
  final double startingAltitudeM;

  static const double toleranceDegrees = 1.5;

  double get targetAngleRadians => targetAngleDegrees * math.pi / 180;

  bool matches(double angleRadians) {
    final degrees = angleRadians * 180 / math.pi;
    return (degrees - targetAngleDegrees).abs() <= toleranceDegrees;
  }

  static final List<DescentLineChallenge> _scenarios = [
    const DescentLineChallenge(
        targetAngleDegrees: 3, groundDistanceM: 5000, startingAltitudeM: 262),
    const DescentLineChallenge(
        targetAngleDegrees: 5, groundDistanceM: 3000, startingAltitudeM: 262),
    const DescentLineChallenge(
        targetAngleDegrees: 8, groundDistanceM: 2000, startingAltitudeM: 281),
    const DescentLineChallenge(
        targetAngleDegrees: 12, groundDistanceM: 1200, startingAltitudeM: 255),
  ];

  static DescentLineChallenge forIndex(int index) {
    final safeIndex = index < 0 ? 0 : index;
    return _scenarios[safeIndex % _scenarios.length];
  }
}

/// "Land on the Glide Path" — a fixed altitude/ground-distance pair; the
/// learner adjusts angle and speed until `FlightApproachModel.status` is
/// `safe`.
class GlidePathChallenge {
  const GlidePathChallenge({
    required this.startingAltitudeM,
    required this.groundDistanceM,
    required this.suggestedAirspeedMps,
  });

  final double startingAltitudeM;
  final double groundDistanceM;

  /// A reasonable default airspeed shown when the challenge loads —
  /// deliberately not the exact correct answer, so choosing angle still
  /// matters.
  final double suggestedAirspeedMps;

  static final List<GlidePathChallenge> _scenarios = [
    const GlidePathChallenge(
        startingAltitudeM: 300,
        groundDistanceM: 4000,
        suggestedAirspeedMps: 65),
    const GlidePathChallenge(
        startingAltitudeM: 450,
        groundDistanceM: 5500,
        suggestedAirspeedMps: 70),
    const GlidePathChallenge(
        startingAltitudeM: 200,
        groundDistanceM: 2600,
        suggestedAirspeedMps: 55),
    const GlidePathChallenge(
        startingAltitudeM: 380,
        groundDistanceM: 3000,
        suggestedAirspeedMps: 60),
  ];

  static GlidePathChallenge forIndex(int index) {
    final safeIndex = index < 0 ? 0 : index;
    return _scenarios[safeIndex % _scenarios.length];
  }
}

/// "Vector Approach" — a target horizontal/vertical speed component pair;
/// the learner adjusts both components directly (rather than an
/// angle+airspeed pair) and observes the resultant combined vector.
class VectorApproachChallenge {
  const VectorApproachChallenge({
    required this.targetHorizontalMps,
    required this.targetVerticalMps,
  });

  final double targetHorizontalMps;
  final double targetVerticalMps;

  static const double toleranceMps = 4.0;

  double get targetResultantMps =>
      math.sqrt(targetHorizontalMps * targetHorizontalMps +
          targetVerticalMps * targetVerticalMps);

  double get targetAngleDegrees =>
      math.atan2(targetVerticalMps, targetHorizontalMps) * 180 / math.pi;

  bool matches(double horizontalMps, double verticalMps) {
    return (horizontalMps - targetHorizontalMps).abs() <= toleranceMps &&
        (verticalMps - targetVerticalMps).abs() <= toleranceMps;
  }

  static final List<VectorApproachChallenge> _scenarios = [
    const VectorApproachChallenge(
        targetHorizontalMps: 60, targetVerticalMps: 4),
    const VectorApproachChallenge(
        targetHorizontalMps: 55, targetVerticalMps: 7),
    const VectorApproachChallenge(
        targetHorizontalMps: 68, targetVerticalMps: 3),
    const VectorApproachChallenge(
        targetHorizontalMps: 50, targetVerticalMps: 9),
  ];

  static VectorApproachChallenge forIndex(int index) {
    final safeIndex = index < 0 ? 0 : index;
    return _scenarios[safeIndex % _scenarios.length];
  }
}
