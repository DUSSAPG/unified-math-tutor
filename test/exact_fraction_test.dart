import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/exact_fraction.dart';

void main() {
  group('reduction and canonical form', () {
    test('reduces by the greatest common divisor', () {
      expect(ExactFraction(2, 4).toString(), '1/2');
      expect(ExactFraction(3, 6).toString(), '1/2');
      expect(ExactFraction(6, 8).toString(), '3/4');
      expect(ExactFraction(5, 8).toString(), '5/8');
    });

    test('a whole unit reduces to 1/1', () {
      final one = ExactFraction(6, 6);
      expect(one.numerator, 1);
      expect(one.denominator, 1);
    });

    test('zero is canonicalised to 0/1 whatever its denominator', () {
      for (final d in [1, 2, 5, 8, 9]) {
        final zero = ExactFraction(0, d);
        expect(zero.numerator, 0, reason: '0/$d');
        expect(zero.denominator, 1, reason: '0/$d');
        expect(zero.toString(), '0/1');
      }
    });

    test('supports valid fractions that are outside the UI denominator set',
        () {
      final fifth = ExactFraction(0, 5);
      expect(fifth, ExactFraction(0, 1));
      expect(ExactFraction(3, 10).toString(), '3/10');
      expect(ExactFraction(7, 9).toString(), '7/9');
    });

    test('fields are always reduced, so no unreduced pair can exist', () {
      for (var d = 1; d <= 12; d++) {
        for (var n = 0; n <= d; n++) {
          final f = ExactFraction(n, d);
          // gcd(0, 1) is 1, so zero's canonical 0/1 also has gcd 1.
          expect(_gcd(f.numerator, f.denominator), 1, reason: '$n/$d');
        }
      }
    });
  });

  group('rejection of invalid input', () {
    test('a zero denominator throws ArgumentError', () {
      expect(() => ExactFraction(1, 0), throwsArgumentError);
      expect(() => ExactFraction(0, 0), throwsArgumentError);
    });

    test('a negative denominator throws ArgumentError', () {
      expect(() => ExactFraction(1, -2), throwsArgumentError);
    });

    test('a negative numerator throws ArgumentError', () {
      expect(() => ExactFraction(-1, 2), throwsArgumentError);
    });

    test('a numerator greater than the denominator throws ArgumentError', () {
      expect(() => ExactFraction(3, 2), throwsArgumentError);
      expect(() => ExactFraction(9, 8), throwsArgumentError);
    });

    test('the boundary values 0 and 1 are accepted', () {
      expect(ExactFraction(0, 1), ExactFraction(0, 7));
      expect(ExactFraction(1, 1), ExactFraction(4, 4));
    });
  });

  group('equality and hashing', () {
    test('equivalent forms are equal', () {
      expect(ExactFraction(1, 2), ExactFraction(2, 4));
      expect(ExactFraction(1, 2), ExactFraction(3, 6));
      expect(ExactFraction(1, 2), ExactFraction(4, 8));
    });

    test('equivalent forms have equal hash codes', () {
      expect(ExactFraction(1, 2).hashCode, ExactFraction(2, 4).hashCode);
      expect(ExactFraction(1, 2).hashCode, ExactFraction(3, 6).hashCode);
      expect(ExactFraction(0, 3).hashCode, ExactFraction(0, 8).hashCode);
    });

    test('different values are not equal', () {
      expect(ExactFraction(1, 3), isNot(ExactFraction(1, 2)));
      expect(ExactFraction(2, 3), isNot(ExactFraction(3, 4)));
    });

    test('equal values collapse to one entry in a hash set', () {
      final set = {
        ExactFraction(1, 2),
        ExactFraction(2, 4),
        ExactFraction(3, 6),
        ExactFraction(4, 8),
      };
      expect(set, hasLength(1));
    });
  });

  group('ordering', () {
    test('2/3 is less than 3/4', () {
      expect(ExactFraction(2, 3).compareTo(ExactFraction(3, 4)), lessThan(0));
      expect(
          ExactFraction(3, 4).compareTo(ExactFraction(2, 3)), greaterThan(0));
    });

    test('equivalent forms compare as zero', () {
      expect(ExactFraction(1, 2).compareTo(ExactFraction(3, 6)), 0);
    });

    test('sorting a mixed list orders by value, not by numerator', () {
      final list = [
        ExactFraction(3, 4),
        ExactFraction(1, 8),
        ExactFraction(5, 6),
        ExactFraction(0, 1),
        ExactFraction(2, 3),
        ExactFraction(1, 2),
      ]..sort();
      expect(list.map((f) => f.toString()).toList(),
          ['0/1', '1/8', '1/2', '2/3', '3/4', '5/6']);
    });

    test('is consistent with equality across the whole V1 range', () {
      final values = [
        for (final d in [2, 3, 4, 6, 8])
          for (var n = 0; n <= d; n++) ExactFraction(n, d),
      ];
      for (final a in values) {
        for (final b in values) {
          expect(a.compareTo(b) == 0, a == b, reason: '$a vs $b');
        }
      }
    });
  });

  group('the Number Sense V1 denominator policy', () {
    test('the policy set is exactly {2, 3, 4, 6, 8}', () {
      expect(numberSenseV1Denominators, {2, 3, 4, 6, 8});
    });

    test('the policy set does not restrict the model itself', () {
      // 10 is outside the UI policy, but must still be a valid fraction.
      expect(numberSenseV1Denominators.contains(10), isFalse);
      expect(ExactFraction(3, 10).toString(), '3/10');
    });

    test('the policy yields exactly 13 distinct values in [0, 1]', () {
      final distinct = {
        for (final d in numberSenseV1Denominators)
          for (var n = 0; n <= d; n++) ExactFraction(n, d),
      };
      expect(distinct, hasLength(13));
    });

    test('the 13 values are exactly the expected canonical fractions', () {
      final distinct = {
        for (final d in numberSenseV1Denominators)
          for (var n = 0; n <= d; n++) ExactFraction(n, d).toString(),
      };
      expect(
        distinct,
        {
          '0/1',
          '1/1',
          '1/2',
          '1/3',
          '2/3',
          '1/4',
          '3/4',
          '1/6',
          '5/6',
          '1/8',
          '3/8',
          '5/8',
          '7/8',
        },
      );
    });
  });

  group('integer-only state', () {
    test('numerator and denominator are integers', () {
      final f = ExactFraction(3, 8);
      expect(f.numerator, isA<int>());
      expect(f.denominator, isA<int>());
    });

    test('equality depends only on the integer fields', () {
      // The canonical fields alone determine identity and ordering.
      expect(ExactFraction(3, 8).numerator, 3);
      expect(ExactFraction(3, 8).denominator, 8);
      expect(ExactFraction(6, 16), ExactFraction(3, 8));
    });
  });
}

int _gcd(int a, int b) {
  var x = a;
  var y = b;
  while (y != 0) {
    final r = x % y;
    x = y;
    y = r;
  }
  return x;
}
