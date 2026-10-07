import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/exact_fraction.dart';
import 'package:unified_math_tutor/services/hundredths_precision_geometry.dart';

void main() {
  group('hundredths exact values and displays', () {
    test('every labelled value maps to an exact fraction and decimal', () {
      for (var hundredths = 0; hundredths <= 10; hundredths++) {
        expect(
          HundredthsPrecisionGeometry.fractionAt(hundredths),
          ExactFraction(hundredths, 100),
        );
        expect(
          HundredthsPrecisionGeometry.decimalAt(hundredths),
          '0.${hundredths.toString().padLeft(2, '0')}',
        );
      }
      expect(HundredthsPrecisionGeometry.fractionAt(7), ExactFraction(7, 100));
      expect(HundredthsPrecisionGeometry.decimalAt(7), '0.07');
    });

    test('fraction and decimal conversion reject ticks outside the line', () {
      expect(() => HundredthsPrecisionGeometry.fractionAt(-1),
          throwsArgumentError);
      expect(() => HundredthsPrecisionGeometry.fractionAt(11),
          throwsArgumentError);
      expect(
          () => HundredthsPrecisionGeometry.decimalAt(-1), throwsArgumentError);
    });
  });

  group('pointer snapping', () {
    test('each tenth of the zoomed track snaps to its matching hundredth', () {
      for (var hundredths = 0; hundredths <= 10; hundredths++) {
        expect(
          HundredthsPrecisionGeometry.snapPosition(hundredths / 10),
          hundredths,
        );
      }
    });

    test('midpoints snap upward and positions clamp to the endpoints', () {
      expect(HundredthsPrecisionGeometry.snapPosition(0.05), 1);
      expect(HundredthsPrecisionGeometry.snapPosition(-1), 0);
      expect(HundredthsPrecisionGeometry.snapPosition(2), 10);
      expect(
        () => HundredthsPrecisionGeometry.snapPosition(double.nan),
        throwsArgumentError,
      );
    });
  });
}
