/// Denominators offered by the Number Sense Lab V1 user interface.
///
/// This is a UI and content policy, not a mathematical validity rule:
/// [ExactFraction] itself accepts any valid unit-interval fraction, such as
/// 0/5 or 3/10. Chosen so that every shown value bridges to another through
/// a shared partition: halving (2, 4, 8), thirds (3, 6) and the bridge 6
/// between halves and thirds.
const Set<int> numberSenseV1Denominators = {2, 3, 4, 6, 8};

/// An exact, immutable fraction in the closed unit interval [0, 1].
///
/// Stored as integers only, and always in canonical form: the numerator and
/// denominator are reduced by their greatest common divisor, and zero is
/// `0/1`. Two values that are equal as numbers therefore have identical
/// fields, so equality, hashing and ordering never depend on floating-point
/// arithmetic.
class ExactFraction implements Comparable<ExactFraction> {
  const ExactFraction._(this.numerator, this.denominator);

  /// Creates the canonical form of [numerator] / [denominator].
  ///
  /// Throws [ArgumentError] unless [denominator] is positive and
  /// `0 <= numerator <= denominator`.
  factory ExactFraction(int numerator, int denominator) {
    if (denominator <= 0) {
      throw ArgumentError.value(
          denominator, 'denominator', 'must be strictly positive');
    }
    if (numerator < 0) {
      throw ArgumentError.value(numerator, 'numerator', 'must be non-negative');
    }
    if (numerator > denominator) {
      throw ArgumentError.value(
          numerator, 'numerator', 'must not exceed the denominator');
    }
    final divisor = _greatestCommonDivisor(numerator, denominator);
    return ExactFraction._(numerator ~/ divisor, denominator ~/ divisor);
  }

  /// Numerator of the canonical (reduced) form. Always in `0..denominator`.
  final int numerator;

  /// Denominator of the canonical (reduced) form. Always positive.
  final int denominator;

  /// Euclid's algorithm on non-negative integers. `gcd(0, d)` is `d`, which
  /// is what turns zero into `0/1`.
  static int _greatestCommonDivisor(int a, int b) {
    var x = a;
    var y = b;
    while (y != 0) {
      final remainder = x % y;
      x = y;
      y = remainder;
    }
    return x;
  }

  @override
  bool operator ==(Object other) =>
      other is ExactFraction &&
      other.numerator == numerator &&
      other.denominator == denominator;

  @override
  int get hashCode => Object.hash(numerator, denominator);

  /// Orders by value using integer cross-multiplication:
  /// `a/b` compares with `c/d` by comparing `a*d` with `c*b`, which is exact
  /// because both denominators are positive.
  @override
  int compareTo(ExactFraction other) =>
      (numerator * other.denominator).compareTo(other.numerator * denominator);

  /// The canonical form, for example `1/2`, `0/1` or `1/1`.
  @override
  String toString() => '$numerator/$denominator';
}
