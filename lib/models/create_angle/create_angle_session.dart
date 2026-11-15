import 'dart:math' as math;

/// Angle maths and visit state for Create the Angle, an optional applied
/// exploration in Applied Maths Studio.
///
/// Pure Dart: no Flutter, no copy. The screen turns the structured
/// [CreateAngleCheck] results below into localised sentences, so nothing in
/// this file is learner-visible text.

/// Inclusive success tolerance, in degrees, either side of the target.
const double createAngleTolerance = 2;

/// Smallest and largest angle the aim line can make with the baseline.
const double createAngleMin = 0;
const double createAngleMax = 180;

/// The included angle, in degrees (0–180), between vector [b] = (bx, by) and
/// vector [a] = (ax, ay), computed as atan2(|b × a|, b · a).
///
/// atan2 of the cross and dot products is well-conditioned at every angle
/// (unlike acos of a dot product near 0° and 180°). Each vector is scaled by
/// its largest component first so very large inputs cannot overflow.
double includedAngle(double bx, double by, double ax, double ay) {
  if (![bx, by, ax, ay].every((v) => v.isFinite) ||
      (bx == 0 && by == 0) ||
      (ax == 0 && ay == 0)) {
    throw ArgumentError('Two finite, non-zero vectors are required.');
  }
  final bs = math.max(bx.abs(), by.abs());
  final as = math.max(ax.abs(), ay.abs());
  bx /= bs;
  by /= bs;
  ax /= as;
  ay /= as;
  return math.atan2((bx * ay - by * ax).abs(), bx * ax + by * ay) *
      180 /
      math.pi;
}

/// Folds any finite angle onto the 0–180° range the learner works in:
/// negative and reflex turns map to the equivalent included angle.
double normaliseLearningAngle(double degrees) {
  if (!degrees.isFinite) throw ArgumentError.value(degrees);
  final wrapped = degrees % 360; // Dart's % is always non-negative here.
  return wrapped > 180 ? 360 - wrapped : wrapped;
}

/// Whether [actual] is within the inclusive ±[createAngleTolerance] of
/// [target]. The tiny epsilon only absorbs floating-point noise.
bool matchesAngle(double actual, double target) =>
    actual.isFinite &&
    target.isFinite &&
    (actual - target).abs() <= createAngleTolerance + 1e-9;

/// How a checked aim compares with the target.
enum CreateAngleOutcome {
  /// Within the tolerance; the aim line snaps to exactly the target.
  matched,

  /// Short of the target: the learner should turn the aim line wider.
  turnWider,

  /// Past the target: the learner should turn the aim line narrower.
  turnNarrower,
}

/// The structured result of one Check. Holds numbers only — the screen
/// chooses the words.
class CreateAngleCheck {
  const CreateAngleCheck({
    required this.target,
    required this.attempted,
    required this.outcome,
  });

  final int target;

  /// The aim, in degrees, at the moment Check was pressed.
  final double attempted;
  final CreateAngleOutcome outcome;

  bool get matched => outcome == CreateAngleOutcome.matched;

  /// Absolute distance from the target, in degrees.
  double get difference => (attempted - target).abs();
}

/// One visit's state. Session-only by design: nothing is persisted, scored,
/// timed or reported anywhere, and a new screen starts a new session.
class CreateAngleSession {
  /// The four target angles, in the order they are offered.
  static const targets = [30, 45, 60, 90];

  int _target = targets.first;
  double _angle = createAngleMin;
  CreateAngleCheck? _lastCheck;
  final Set<int> _matched = {};

  /// The target currently being created.
  int get target => _target;

  /// The current aim, in degrees from the baseline (0–180).
  double get angle => _angle;

  /// The most recent Check for the current attempt, or null if the aim has
  /// changed since (or nothing has been checked yet).
  CreateAngleCheck? get lastCheck => _lastCheck;

  /// Targets matched at least once in this session.
  Set<int> get matched => Set.unmodifiable(_matched);

  bool isMatched(int target) => _matched.contains(target);

  /// True once every target has been matched in this session.
  bool get allMatched => _matched.length == targets.length;

  /// Sets the aim to [degrees], folded onto 0–180°. Any previous Check no
  /// longer describes the aim, so it is cleared.
  void aim(double degrees) {
    _angle = normaliseLearningAngle(degrees);
    _lastCheck = null;
  }

  /// Turns the aim by [delta] degrees, stopping at 0° and 180° rather than
  /// wrapping (a button should never jump from 180° back to 0°).
  void adjust(double delta) =>
      aim((_angle + delta).clamp(createAngleMin, createAngleMax).toDouble());

  /// Chooses [value] as the target and starts a fresh attempt at it.
  void select(int value) {
    if (!targets.contains(value)) {
      throw ArgumentError.value(
          value, 'value', 'not a Create the Angle target');
    }
    _target = value;
    resetPitch();
  }

  /// The next target to suggest: the first one after the current target
  /// (wrapping round) not yet matched in this session, or simply the next
  /// one in order once every target has been matched.
  int get nextTarget {
    final start = targets.indexOf(_target);
    for (var step = 1; step <= targets.length; step++) {
      final candidate = targets[(start + step) % targets.length];
      if (allMatched || !_matched.contains(candidate)) return candidate;
    }
    return _target; // Unreachable: the current target is a candidate last.
  }

  /// Moves on to [nextTarget].
  void next() => select(nextTarget);

  /// Returns the aim line to the baseline and clears the current Check.
  /// Matched targets are kept: resetting the pitch is not a new session.
  void resetPitch() {
    _angle = createAngleMin;
    _lastCheck = null;
  }

  /// Starts the whole session again: first target, nothing matched.
  void restart() {
    _matched.clear();
    _target = targets.first;
    resetPitch();
  }

  /// Compares the aim with the target. On a match the target is recorded
  /// for this session and the aim snaps to exactly the target.
  CreateAngleCheck check() {
    final attempted = _angle;
    final outcome = matchesAngle(attempted, _target.toDouble())
        ? CreateAngleOutcome.matched
        : attempted < _target
            ? CreateAngleOutcome.turnWider
            : CreateAngleOutcome.turnNarrower;
    final result = CreateAngleCheck(
      target: _target,
      attempted: attempted,
      outcome: outcome,
    );
    if (result.matched) {
      _matched.add(_target);
      _angle = _target.toDouble();
    }
    _lastCheck = result;
    return result;
  }
}
