import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/exact_fraction.dart';
import 'package:unified_math_tutor/services/number_sense_geometry.dart';

void main() {
  // Used by the tie tests: the midpoint between tick k and tick k+1 on a
  // denominator d, computed the way a caller would compute it.
  double midpoint(int k, int d) => (k + 0.5) / d;

  group('denominator validation', () {
    test('a positive denominator is returned unchanged', () {
      expect(NumberSenseGeometry.validateDenominator(1), 1);
      expect(NumberSenseGeometry.validateDenominator(8), 8);
    });

    test('zero and negative denominators throw ArgumentError', () {
      expect(() => NumberSenseGeometry.validateDenominator(0),
          throwsArgumentError);
      expect(() => NumberSenseGeometry.validateDenominator(-1),
          throwsArgumentError);
      expect(() => NumberSenseGeometry.validateDenominator(-8),
          throwsArgumentError);
    });

    test('every public helper rejects an invalid denominator', () {
      for (final bad in [0, -3]) {
        expect(() => NumberSenseGeometry.unitTicks(bad), throwsArgumentError);
        expect(() => NumberSenseGeometry.unitTickPositions(bad),
            throwsArgumentError);
        expect(() => NumberSenseGeometry.snapUnitPosition(0.5, bad),
            throwsArgumentError);
      }
    });
  });

  group('unit ticks', () {
    test('there are denominator + 1 ticks', () {
      for (final d in [1, 2, 3, 4, 6, 8, 5, 10]) {
        expect(NumberSenseGeometry.unitTicks(d), hasLength(d + 1),
            reason: 'denominator $d');
      }
    });

    test('ticks start at 0 and end at 1', () {
      final ticks = NumberSenseGeometry.unitTicks(4);
      expect(ticks.first, ExactFraction(0, 1));
      expect(ticks.last, ExactFraction(1, 1));
    });

    test('ticks are in strictly ascending order', () {
      final ticks = NumberSenseGeometry.unitTicks(6);
      for (var i = 0; i < ticks.length - 1; i++) {
        expect(ticks[i].compareTo(ticks[i + 1]), lessThan(0));
      }
    });

    test('rendered endpoints are exact: 0.0 and 1.0', () {
      for (final d in [2, 3, 4, 6, 8]) {
        final positions = NumberSenseGeometry.unitTickPositions(d);
        expect(positions.first, 0.0, reason: 'denominator $d');
        expect(positions.last, 1.0, reason: 'denominator $d');
      }
    });

    test('rendered ticks are uniformly spaced at 1/denominator', () {
      for (final d in [2, 3, 4, 6, 8]) {
        final positions = NumberSenseGeometry.unitTickPositions(d);
        for (var i = 0; i < positions.length - 1; i++) {
          expect(positions[i + 1] - positions[i], closeTo(1 / d, 1e-12),
              reason: 'denominator $d, gap $i');
        }
      }
    });

    test('ticks are reduced canonical fractions', () {
      final ticks = NumberSenseGeometry.unitTicks(8);
      expect(ticks.map((t) => t.toString()).toList(), [
        '0/1',
        '1/8',
        '1/4',
        '3/8',
        '1/2',
        '5/8',
        '3/4',
        '7/8',
        '1/1',
      ]);
    });
  });

  group('exact unit positions for painting', () {
    test('1/2 is at 0.5', () {
      expect(NumberSenseGeometry.unitPositionOf(ExactFraction(1, 2)), 0.5);
    });

    test('3/8 is at 0.375', () {
      expect(NumberSenseGeometry.unitPositionOf(ExactFraction(3, 8)), 0.375);
    });

    test('2/3 is at 2/3 to floating-point precision', () {
      expect(NumberSenseGeometry.unitPositionOf(ExactFraction(2, 3)),
          closeTo(2 / 3, 1e-15));
    });

    test('0 is at exactly 0.0 and 1 is at exactly 1.0', () {
      expect(NumberSenseGeometry.unitPositionOf(ExactFraction(0, 1)), 0.0);
      expect(NumberSenseGeometry.unitPositionOf(ExactFraction(1, 1)), 1.0);
    });

    test('a zero value written with any denominator is at exactly 0.0', () {
      expect(NumberSenseGeometry.unitPositionOf(ExactFraction(0, 8)), 0.0);
    });
  });

  group('snapping at ticks', () {
    test('snapping each tick position returns that exact tick', () {
      for (final d in [2, 3, 4, 6, 8]) {
        for (final tick in NumberSenseGeometry.unitTicks(d)) {
          final position = NumberSenseGeometry.unitPositionOf(tick);
          expect(NumberSenseGeometry.snapUnitPosition(position, d), tick,
              reason: 'tick $tick on denominator $d');
        }
      }
    });
  });

  group('clamping outside the unit interval', () {
    test('positions below 0 snap to 0/1', () {
      expect(
          NumberSenseGeometry.snapUnitPosition(-5.0, 4), ExactFraction(0, 1));
      expect(NumberSenseGeometry.snapUnitPosition(-0.0001, 4),
          ExactFraction(0, 1));
      expect(NumberSenseGeometry.snapUnitPosition(double.negativeInfinity, 8),
          ExactFraction(0, 1));
    });

    test('positions above 1 snap to 1/1', () {
      expect(NumberSenseGeometry.snapUnitPosition(7.0, 4), ExactFraction(1, 1));
      expect(NumberSenseGeometry.snapUnitPosition(1.0000001, 4),
          ExactFraction(1, 1));
      expect(NumberSenseGeometry.snapUnitPosition(double.infinity, 6),
          ExactFraction(1, 1));
    });
  });

  group('values either side of a tick', () {
    test('a value just below a tick snaps to that tick', () {
      // 1/4 is at 0.25, and the midpoint with 0 is 0.125 and with 1/2 is 0.375.
      expect(
          NumberSenseGeometry.snapUnitPosition(0.2499, 4), ExactFraction(1, 4));
      expect(
          NumberSenseGeometry.snapUnitPosition(0.2501, 4), ExactFraction(1, 4));
    });

    test('values either side of a midpoint go to the nearer tick', () {
      // Midpoint between 1/4 and 1/2 on denominator 4 is 0.375 (3/8).
      expect(
          NumberSenseGeometry.snapUnitPosition(0.374, 4), ExactFraction(1, 4));
      expect(
          NumberSenseGeometry.snapUnitPosition(0.376, 4), ExactFraction(1, 2));
    });
  });

  group('midpoint ties snap upward', () {
    test('denominator 2: the midpoint 0.25 snaps up to 1/2', () {
      expect(NumberSenseGeometry.snapUnitPosition(midpoint(0, 2), 2),
          ExactFraction(1, 2));
    });

    test('denominator 4: every midpoint snaps to the higher tick', () {
      expect(NumberSenseGeometry.snapUnitPosition(midpoint(0, 4), 4),
          ExactFraction(1, 4)); // 0.125 -> 1/4
      expect(NumberSenseGeometry.snapUnitPosition(midpoint(1, 4), 4),
          ExactFraction(1, 2)); // 0.375 -> 1/2
      expect(NumberSenseGeometry.snapUnitPosition(midpoint(2, 4), 4),
          ExactFraction(3, 4)); // 0.625 -> 3/4
      expect(NumberSenseGeometry.snapUnitPosition(midpoint(3, 4), 4),
          ExactFraction(1, 1)); // 0.875 -> 1/1
    });

    test('denominator 3: the midpoints 1/6, 1/2 and 5/6 snap upward', () {
      expect(NumberSenseGeometry.snapUnitPosition(midpoint(0, 3), 3),
          ExactFraction(1, 3));
      expect(NumberSenseGeometry.snapUnitPosition(midpoint(1, 3), 3),
          ExactFraction(2, 3));
      expect(NumberSenseGeometry.snapUnitPosition(midpoint(2, 3), 3),
          ExactFraction(1, 1));
    });

    test('a tie exactly one tolerance below the midpoint still snaps up', () {
      final justBelow = midpoint(0, 2) - 1e-12;
      expect(NumberSenseGeometry.snapUnitPosition(justBelow, 2),
          ExactFraction(1, 2));
    });

    test('a value clearly below the midpoint does not snap up', () {
      expect(NumberSenseGeometry.snapUnitPosition(midpoint(0, 2) - 0.01, 2),
          ExactFraction(0, 1));
    });
  });

  group('invalid pointer input', () {
    test('a NaN pointer position throws ArgumentError', () {
      expect(() => NumberSenseGeometry.snapUnitPosition(double.nan, 4),
          throwsArgumentError);
    });
  });

  group('snap results', () {
    test('results are ExactFraction values', () {
      final result = NumberSenseGeometry.snapUnitPosition(0.4, 4);
      expect(result, isA<ExactFraction>());
    });

    test('results are reduced canonical forms', () {
      expect(NumberSenseGeometry.snapUnitPosition(0.5, 4).toString(), '1/2');
      expect(NumberSenseGeometry.snapUnitPosition(0.5, 6).toString(), '1/2');
      expect(NumberSenseGeometry.snapUnitPosition(0.0, 6).toString(), '0/1');
      expect(NumberSenseGeometry.snapUnitPosition(1.0, 6).toString(), '1/1');
    });

    test('a snapped value equals the canonical ExactFraction for that tick',
        () {
      expect(NumberSenseGeometry.snapUnitPosition(0.66, 6),
          ExactFraction(4, 6)); // reduces to 2/3
      expect(NumberSenseGeometry.snapUnitPosition(0.66, 6).denominator, 3);
    });

    test('denominators outside the UI policy still snap correctly', () {
      expect(
          NumberSenseGeometry.snapUnitPosition(0.3, 10), ExactFraction(3, 10));
    });
  });
}
