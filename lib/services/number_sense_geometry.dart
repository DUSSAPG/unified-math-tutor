import '../models/exact_fraction.dart';

/// Pure geometry and snapping helpers for the Number Sense Lab.
///
/// [ExactFraction] is the only mathematical state. Doubles appear only at the
/// rendering and pointer boundary: [unitPositionOf] turns an exact value into
/// a position for painting, and [snapUnitPosition] turns a pointer position
/// back into an exact value. Nothing here stores a double.
///
/// These helpers accept any positive denominator. The Number Sense V1
/// denominator policy lives in [numberSenseV1Denominators] and is applied by
/// the UI, not here.
///
/// Deterministic, side-effect-free and Flutter-free: no persistence, no
/// animation, no shared state.
class NumberSenseGeometry {
  const NumberSenseGeometry._();

  /// Pointer positions this close below a midpoint are still treated as the
  /// midpoint, so a tie is not lost to binary floating-point error.
  static const double _tieTolerance = 1e-9;

  /// Returns [denominator] unchanged if it is strictly positive.
  ///
  /// Throws [ArgumentError] otherwise.
  static int validateDenominator(int denominator) {
    if (denominator <= 0) {
      throw ArgumentError.value(
          denominator, 'denominator', 'must be strictly positive');
    }
    return denominator;
  }

  /// All `denominator + 1` unit ticks, from `0/1` to `1/1`, in ascending
  /// order. Equal spacing `1/denominator` is exact in the fractions; their
  /// rendered positions are given by [unitTickPositions].
  static List<ExactFraction> unitTicks(int denominator) {
    validateDenominator(denominator);
    return [
      for (var i = 0; i <= denominator; i++) ExactFraction(i, denominator),
    ];
  }

  /// The rendered position of every tick from [unitTicks], as doubles in
  /// `[0, 1]`. The first is exactly `0.0` and the last exactly `1.0`.
  static List<double> unitTickPositions(int denominator) => [
        for (final tick in unitTicks(denominator)) unitPositionOf(tick),
      ];

  /// The rendered position of [value] on the unit interval, for painting.
  ///
  /// Exact at both endpoints: `0/1` gives `0.0` and `1/1` gives `1.0`.
  /// Never used to decide a value.
  static double unitPositionOf(ExactFraction value) =>
      value.numerator / value.denominator;

  /// Snaps a pointer position on `[0, 1]` to the nearest tick for
  /// [denominator], returned as an exact, reduced [ExactFraction].
  ///
  /// Rules:
  /// - Positions below 0 snap as 0, and positions above 1 snap as 1.
  /// - A position exactly halfway between two ticks snaps upward to the
  ///   higher tick. A position within [_tieTolerance] below the midpoint is
  ///   treated as the midpoint.
  /// - A NaN position throws [ArgumentError].
  /// - A non-positive [denominator] throws [ArgumentError].
  static ExactFraction snapUnitPosition(double pointer, int denominator) {
    validateDenominator(denominator);
    if (pointer.isNaN) {
      throw ArgumentError.value(pointer, 'pointer', 'must not be NaN');
    }
    final clamped = pointer < 0.0
        ? 0.0
        : pointer > 1.0
            ? 1.0
            : pointer;
    final scaled = clamped * denominator;
    var numerator = (scaled + 0.5 + _tieTolerance).floor();
    if (numerator < 0) numerator = 0;
    if (numerator > denominator) numerator = denominator;
    return ExactFraction(numerator, denominator);
  }
}
