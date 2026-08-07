/// Pure, deterministic scoring for the Football Precision lab, extracted
/// from the screen so the formula itself is unit-testable without pumping
/// a widget tree. Target zones cycle 1-5 across attempts; each zone has a
/// fixed ideal angle, and a fixed ideal power (76%) applies to every zone.
int footballTargetZoneForAttempt(int attempts) => (attempts % 5) + 1;

int footballIdealAngleForZone(int targetZone) => -30 + (targetZone - 1) * 15;

const footballIdealPower = 76.0;

int scoreFootballKick({
  required double angle,
  required double power,
  required int targetZone,
}) {
  final angleError = (angle - footballIdealAngleForZone(targetZone)).abs();
  final powerError = (power - footballIdealPower).abs();
  return (100 - angleError * 1.8 - powerError * 0.8).clamp(0, 100).round();
}

bool isFootballKickHit(int score) => score >= 75;
