/// Pure, rendering-free maths contract for Binomial Volume Lab.
///
/// A cube of side `a + b` is cut once along each axis at distance `a`,
/// producing exactly eight cuboids. Each cuboid takes either `a` or `b` as its
/// length on each of the three axes, so its volume is a product of three
/// factors drawn from {a, b}. Grouping the eight pieces by how many `b`
/// factors they contain gives
///
///     (a + b)³ = a³ + 3a²b + 3ab² + b³
///
/// Everything here is deterministic and testable without Flutter: the
/// painter and screen only *read* these definitions, they never redefine a
/// dimension, multiplicity or volume.
library;

/// Which segment of a cut axis a piece occupies: the length-`a` segment
/// nearest the origin, or the length-`b` segment beyond it.
enum BinomialSide { a, b }

/// The four distinct volume terms of (a + b)³, in expansion order.
enum BinomialTerm {
  aCubed(aPower: 3, bPower: 0, coefficient: 1),
  aSquaredB(aPower: 2, bPower: 1, coefficient: 3),
  aBSquared(aPower: 1, bPower: 2, coefficient: 3),
  bCubed(aPower: 0, bPower: 3, coefficient: 1);

  const BinomialTerm({
    required this.aPower,
    required this.bPower,
    required this.coefficient,
  });

  final int aPower;
  final int bPower;

  /// How many of the eight pieces have this volume.
  final int coefficient;

  /// True for the two cubes (a³, b³); false for the six prisms.
  bool get isCube => aPower == 3 || bPower == 3;

  static BinomialTerm fromPowers(int aPower, int bPower) {
    for (final term in values) {
      if (term.aPower == aPower && term.bPower == bPower) return term;
    }
    throw ArgumentError('No term a^$aPower b^$bPower in (a + b)³.');
  }

  /// Symbolic volume of ONE piece, e.g. `a²b`.
  String get symbol => '${_power('a', aPower)}${_power('b', bPower)}';

  /// Symbolic contribution to the expansion, e.g. `3a²b`.
  String get symbolWithCoefficient =>
      coefficient == 1 ? symbol : '$coefficient$symbol';

  /// The three side factors in canonical order (a's first), e.g. `a × a × b`.
  String get factorProduct => [
        for (var i = 0; i < aPower; i++) 'a',
        for (var i = 0; i < bPower; i++) 'b',
      ].join(' × ');

  /// Volume of ONE piece of this term for concrete side lengths.
  int volume(BinomialDimensions d) => _pow(d.a, aPower) * _pow(d.b, bPower);

  /// Combined volume of every piece of this term (coefficient × volume).
  int contribution(BinomialDimensions d) => coefficient * volume(d);
}

/// One of the eight cuboids. [x], [y] and [z] record which segment the piece
/// occupies on each axis; its term follows from how many are [BinomialSide.b].
class BinomialBlock {
  const BinomialBlock({
    required this.index,
    required this.x,
    required this.y,
    required this.z,
  });

  /// Stable 0–7 index (bit 0 = x, bit 1 = y, bit 2 = z; set bit = side b).
  final int index;
  final BinomialSide x;
  final BinomialSide y;
  final BinomialSide z;

  List<BinomialSide> get sides => [x, y, z];

  int get bCount => sides.where((s) => s == BinomialSide.b).length;

  BinomialTerm get term => BinomialTerm.fromPowers(3 - bCount, bCount);

  /// Painter's-algorithm depth key: pieces further from the viewer (who
  /// looks from the +x, +y, +z corner) have a smaller key and draw first.
  int get depthKey => bCount;

  /// Lengths along x, y, z for concrete side values.
  (int, int, int) size(BinomialDimensions d) =>
      (d.length(x), d.length(y), d.length(z));

  /// Minimum corner when the cube is fully assembled.
  (int, int, int) assembledOrigin(BinomialDimensions d) => (
        x == BinomialSide.a ? 0 : d.a,
        y == BinomialSide.a ? 0 : d.a,
        z == BinomialSide.a ? 0 : d.a,
      );

  int volume(BinomialDimensions d) {
    final (sx, sy, sz) = size(d);
    return sx * sy * sz;
  }

  /// Outward pull direction per axis: the `a` segment moves towards the
  /// origin, the `b` segment away from it, so pieces always separate along
  /// the original cut planes and never pass through one another.
  (int, int, int) get pullDirection => (
        x == BinomialSide.a ? -1 : 1,
        y == BinomialSide.a ? -1 : 1,
        z == BinomialSide.a ? -1 : 1,
      );

  /// Minimum corner after pulling apart by [explosion] (0 = assembled,
  /// 1 = fully pulled apart). Each piece moves half of [maxGap] per axis, so
  /// at 1 neighbouring pieces are exactly [maxGap] apart.
  (double, double, double) originAt(
    BinomialDimensions d,
    double explosion, {
    double? maxGap,
  }) {
    final e = clampExplosion(explosion);
    final gap = (maxGap ?? BinomialVolumeModel.defaultMaxGap(d)) * e / 2;
    final (ox, oy, oz) = assembledOrigin(d);
    final (dx, dy, dz) = pullDirection;
    return (ox + dx * gap, oy + dy * gap, oz + dz * gap);
  }
}

/// Discrete, validated side lengths. a ∈ {1, 2, 3}, b ∈ {1, 2}.
class BinomialDimensions {
  BinomialDimensions({required this.a, required this.b}) {
    if (!allowedA.contains(a)) {
      throw ArgumentError.value(a, 'a', 'must be one of $allowedA');
    }
    if (!allowedB.contains(b)) {
      throw ArgumentError.value(b, 'b', 'must be one of $allowedB');
    }
  }

  static const allowedA = [1, 2, 3];
  static const allowedB = [1, 2];

  /// Default teaching values: a = 2, b = 1 (so the a-segment is visibly
  /// longer and every term has a distinct volume: 8, 4, 2, 1).
  static final initial = BinomialDimensions(a: 2, b: 1);

  final int a;
  final int b;

  int get side => a + b;

  int length(BinomialSide s) => s == BinomialSide.a ? a : b;

  @override
  bool operator ==(Object other) =>
      other is BinomialDimensions && other.a == a && other.b == b;

  @override
  int get hashCode => Object.hash(a, b);
}

/// The numeric check for one concrete pair of side lengths.
class BinomialNumericCheck {
  BinomialNumericCheck(this.dimensions)
      : contributions = [
          for (final t in BinomialTerm.values) t.contribution(dimensions),
        ];

  final BinomialDimensions dimensions;

  /// a³, 3a²b, 3ab², b³ evaluated, in expansion order.
  final List<int> contributions;

  int get termSum => contributions.fold(0, (s, v) => s + v);

  int get cubeVolume => _pow(dimensions.side, 3);

  bool get holds => termSum == cubeVolume;

  /// e.g. `3³ = 8 + 12 + 6 + 1 = 27`.
  String get display =>
      '${dimensions.side}³ = ${contributions.join(' + ')} = $cubeVolume';

  /// e.g. `(2 + 1)³` — the substituted left-hand side.
  String get substitutedSide => '(${dimensions.a} + ${dimensions.b})³';
}

/// The whole decomposition: eight blocks and their grouping into terms.
class BinomialVolumeModel {
  BinomialVolumeModel._();

  static final List<BinomialBlock> blocks = List.unmodifiable([
    for (var i = 0; i < 8; i++)
      BinomialBlock(
        index: i,
        x: (i & 1) == 0 ? BinomialSide.a : BinomialSide.b,
        y: (i & 2) == 0 ? BinomialSide.a : BinomialSide.b,
        z: (i & 4) == 0 ? BinomialSide.a : BinomialSide.b,
      ),
  ]);

  /// Blocks of one term, lowest index first.
  static List<BinomialBlock> blocksFor(BinomialTerm term) =>
      blocks.where((b) => b.term == term).toList(growable: false);

  /// Back-to-front draw order (stable within a depth band).
  static final List<BinomialBlock> drawOrder = List.unmodifiable(
    [...blocks]..sort((p, q) {
        final byDepth = p.depthKey.compareTo(q.depthKey);
        return byDepth != 0 ? byDepth : p.index.compareTo(q.index);
      }),
  );

  /// `(a + b)³ = a³ + 3a²b + 3ab² + b³`, built from [BinomialTerm] so the
  /// displayed identity can never drift from the modelled pieces.
  static String get expansion =>
      '(a + b)³ = ${BinomialTerm.values.map((t) => t.symbolWithCoefficient).join(' + ')}';

  /// Right-hand side only: `a³ + 3a²b + 3ab² + b³`.
  static String get expansionTerms =>
      BinomialTerm.values.map((t) => t.symbolWithCoefficient).join(' + ');

  /// Gap between neighbouring pieces when fully pulled apart, in the same
  /// units as a and b. Proportional to the cube so every size reads alike.
  static double defaultMaxGap(BinomialDimensions d) => d.side * 0.45;
}

/// Clamps an explosion amount to the slider's 0–1 range.
double clampExplosion(double value) =>
    value.isNaN ? 0 : value.clamp(0.0, 1.0).toDouble();

/// Whole-number percentage for a 0–1 explosion amount.
int explosionPercent(double value) => (clampExplosion(value) * 100).round();

int _pow(int base, int exponent) {
  var result = 1;
  for (var i = 0; i < exponent; i++) {
    result *= base;
  }
  return result;
}

String _power(String letter, int power) => switch (power) {
      0 => '',
      1 => letter,
      2 => '$letter²',
      3 => '$letter³',
      _ => throw ArgumentError('Only powers up to 3 occur in (a + b)³.'),
    };
