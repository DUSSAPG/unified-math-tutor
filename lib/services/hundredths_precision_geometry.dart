import '../models/exact_fraction.dart';
import 'number_sense_geometry.dart';

/// Exact tick and display helpers for the Number Sense hundredths line.
class HundredthsPrecisionGeometry {
  const HundredthsPrecisionGeometry._();

  static const int maximumHundredths = 10;

  /// The exact fraction represented by a labelled tick on the zoomed line.
  static ExactFraction fractionAt(int hundredths) {
    _validateHundredths(hundredths);
    return ExactFraction(hundredths, 100);
  }

  /// The fixed two-decimal display for a labelled tick, without floating
  /// point conversion.
  static String decimalAt(int hundredths) {
    _validateHundredths(hundredths);
    return '0.${hundredths.toString().padLeft(2, '0')}';
  }

  /// Snaps a normalized pointer position along the zoomed line to a tick.
  static int snapPosition(double position) {
    if (position.isNaN) {
      throw ArgumentError.value(position, 'position', 'must not be NaN');
    }
    final snapped = NumberSenseGeometry.snapUnitPosition(
      position,
      maximumHundredths,
    );
    return snapped.numerator * (maximumHundredths ~/ snapped.denominator);
  }

  static void _validateHundredths(int hundredths) {
    if (hundredths < 0 || hundredths > maximumHundredths) {
      throw ArgumentError.value(
        hundredths,
        'hundredths',
        'must be between 0 and $maximumHundredths',
      );
    }
  }
}
