import 'dart:math' as math;

/// Pitch Coordinates: positions on a square grid named by ordered pairs of
/// signed whole numbers, and translations as signed right/left and up/down
/// moves (contract CC-COORD-POS-001 v1.2).
///
/// Pure Dart: grid limits, the fixed eight-item deck, deterministic
/// selection, answer evaluation, snapping and the input models. All learner
/// wording lives in the screen; this file returns structured results only.
/// Nothing here is persisted.

/// One grid position, or one signed move.
class PitchPair {
  const PitchPair(this.x, this.y);

  final int x;
  final int y;

  static const zero = PitchPair(0, 0);

  PitchPair operator +(PitchPair o) => PitchPair(x + o.x, y + o.y);

  @override
  bool operator ==(Object other) =>
      other is PitchPair && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => '($x, $y)';
}

/// Where the origin sits. Internal identifier only: never shown as a stage.
enum PitchStart { corner, centre }

/// The grid for one start.
class PitchGrid {
  const PitchGrid._(this.start, this.lo, this.hi, this.maxSteps, this.salt);

  static const corner = PitchGrid._(PitchStart.corner, 0, 8, 8, 0);
  static const centre = PitchGrid._(PitchStart.centre, -5, 5, 10, 8);

  static PitchGrid of(PitchStart start) =>
      start == PitchStart.corner ? corner : centre;

  final PitchStart start;
  final int lo;
  final int hi;

  /// Largest step count offered by an inverse-item steps stepper.
  final int maxSteps;

  /// Added to the selection input so the two starts never share a stream.
  final int salt;

  /// Grid lines per axis.
  int get lines => hi - lo + 1;

  bool contains(PitchPair p) =>
      p.x >= lo && p.x <= hi && p.y >= lo && p.y <= hi;

  int clampAxis(int v) => math.max(lo, math.min(hi, v));
}

/// R read, P place, T translate, I inverse, X transfer (bare grid).
enum PitchItemKind { read, place, translate, inverse, transfer }

/// Every move component a, b lies in [-maxMove, maxMove].
const pitchMaxMove = 4;

/// One item. For read and place items [move] is [PitchPair.zero] and
/// [start] is the player's position.
class PitchItem {
  const PitchItem(this.slot, this.kind, this.start,
      [this.move = PitchPair.zero]);

  final int slot;
  final PitchItemKind kind;
  final PitchPair start;
  final PitchPair move;

  PitchPair get finish => start + move;

  bool get isPositionAnswer => kind != PitchItemKind.inverse;

  /// The single correct answer.
  PitchPair get correct => switch (kind) {
        PitchItemKind.read || PitchItemKind.place => start,
        PitchItemKind.translate || PitchItemKind.transfer => finish,
        PitchItemKind.inverse => move,
      };

  /// Where the answer input starts (contract §7.4). Never the correct answer.
  PitchPair get initialState => switch (kind) {
        PitchItemKind.translate || PitchItemKind.transfer => start,
        _ => PitchPair.zero,
      };

  @override
  bool operator ==(Object other) =>
      other is PitchItem &&
      other.slot == slot &&
      other.kind == kind &&
      other.start == start &&
      other.move == move;

  @override
  int get hashCode => Object.hash(slot, kind, start, move);

  /// Compact form used by the fixed test vectors, e.g. `4T(3,4,-2,2)`.
  String get code {
    final k = switch (kind) {
      PitchItemKind.read => 'R',
      PitchItemKind.place => 'P',
      PitchItemKind.translate => 'T',
      PitchItemKind.inverse => 'I',
      PitchItemKind.transfer => 'X',
    };
    final p = kind == PitchItemKind.read || kind == PitchItemKind.place
        ? '${start.x},${start.y}'
        : '${start.x},${start.y},${move.x},${move.y}';
    return '$slot$k($p)';
  }

  @override
  String toString() => code;
}

// ---------------------------------------------------------------------------
// Diagnostic rules (contract §8.1)

enum PitchRule {
  orderSwapped('D-R1'),
  originCountedHorizontal('D-R2x'),
  originCountedVertical('D-R2y'),
  originCountedBoth('D-R2xy'),
  startNotMoved('D-T1'),
  horizontalOnly('D-T2'),
  verticalOnly('D-T3'),
  bothReversed('D-T4'),
  horizontalReversed('D-T5'),
  verticalReversed('D-T6'),
  movesSwapped('D-T7'),
  gaveMove('D-T8'),
  gaveFinish('D-I1'),
  gaveStart('D-I2'),
  moveReversed('D-I3'),
  inverseMovesSwapped('D-I4');

  const PitchRule(this.id);

  final String id;
}

/// One step further from the origin. Defined for v != 0 only.
int pitchAway(int v) => v > 0 ? v + 1 : v - 1;

/// One step nearer the origin. Defined for v != 0 only.
int pitchToward(int v) => v > 0 ? v - 1 : v + 1;

/// Every rule whose condition holds for [item], with its predicted answer.
/// Position predictions that fall off [grid] cannot be entered and are
/// dropped; move predictions are kept.
Map<PitchRule, PitchPair> pitchPredictions(PitchItem item, PitchGrid grid) {
  final r = <PitchRule, PitchPair>{};
  final x = item.start.x, y = item.start.y, a = item.move.x, b = item.move.y;
  switch (item.kind) {
    case PitchItemKind.read:
    case PitchItemKind.place:
      // A learner who labels the origin 1 reads one step too far, and
      // places one step too near (M-2).
      final f = item.kind == PitchItemKind.read ? pitchAway : pitchToward;
      if (x != y) r[PitchRule.orderSwapped] = PitchPair(y, x);
      if (x != 0) r[PitchRule.originCountedHorizontal] = PitchPair(f(x), y);
      if (y != 0) r[PitchRule.originCountedVertical] = PitchPair(x, f(y));
      if (x != 0 && y != 0) {
        r[PitchRule.originCountedBoth] = PitchPair(f(x), f(y));
      }
      r.removeWhere((_, p) => !grid.contains(p));
    case PitchItemKind.translate:
    case PitchItemKind.transfer:
      r[PitchRule.startNotMoved] = PitchPair(x, y);
      if (a != 0 && b != 0) {
        r[PitchRule.horizontalOnly] = PitchPair(x + a, y);
        r[PitchRule.verticalOnly] = PitchPair(x, y + b);
        r[PitchRule.horizontalReversed] = PitchPair(x - a, y + b);
        r[PitchRule.verticalReversed] = PitchPair(x + a, y - b);
      }
      r[PitchRule.bothReversed] = PitchPair(x - a, y - b);
      if (a != b) r[PitchRule.movesSwapped] = PitchPair(x + b, y + a);
      if (x != 0 || y != 0) r[PitchRule.gaveMove] = PitchPair(a, b);
      r.removeWhere((_, p) => !grid.contains(p));
    case PitchItemKind.inverse:
      if (x != 0 || y != 0) r[PitchRule.gaveFinish] = PitchPair(x + a, y + b);
      if (x != a || y != b) r[PitchRule.gaveStart] = PitchPair(x, y);
      r[PitchRule.moveReversed] = PitchPair(-a, -b);
      if (a != b) r[PitchRule.inverseMovesSwapped] = PitchPair(b, a);
  }
  return r;
}

enum PitchOutcome { correct, diagnostic, generic }

class PitchEvaluation {
  const PitchEvaluation(this.outcome, [this.rule]);

  final PitchOutcome outcome;

  /// Set only when exactly one rule matched.
  final PitchRule? rule;

  bool get isCorrect => outcome == PitchOutcome.correct;
}

/// Correctness first; then exactly one matching rule gives that rule, and a
/// tie or no match gives generic feedback (contract §8).
PitchEvaluation pitchEvaluate(
    PitchItem item, PitchGrid grid, PitchPair answer) {
  if (answer == item.correct) {
    return const PitchEvaluation(PitchOutcome.correct);
  }
  final hits = [
    for (final e in pitchPredictions(item, grid).entries)
      if (e.value == answer) e.key,
  ];
  return hits.length == 1
      ? PitchEvaluation(PitchOutcome.diagnostic, hits.single)
      : const PitchEvaluation(PitchOutcome.generic);
}

// ---------------------------------------------------------------------------
// Deterministic selection (contract §6)

int _u64(int hi, int lo) => (hi << 32) | lo;
final int _gamma = _u64(0x9E3779B9, 0x7F4A7C15);
final int _mix1 = _u64(0xBF58476D, 0x1CE4E5B9);
final int _mix2 = _u64(0x94D049BB, 0x133111EB);

/// splitmix64 over 64-bit two's-complement ints (wrapping on the Dart VM).
int pitchSplitmix64(int v) {
  var z = v + _gamma;
  z = (z ^ (z >>> 30)) * _mix1;
  z = (z ^ (z >>> 27)) * _mix2;
  return z ^ (z >>> 31);
}

/// Unsigned [z] mod [n]; Dart's `%` on a negative int would differ.
int pitchUnsignedMod(int z, int n) =>
    (BigInt.from(z).toUnsigned(64) % BigInt.from(n)).toInt();

const pitchSlotKinds = {
  1: PitchItemKind.read,
  2: PitchItemKind.place,
  3: PitchItemKind.read,
  4: PitchItemKind.translate,
  5: PitchItemKind.translate,
  6: PitchItemKind.inverse,
  7: PitchItemKind.inverse,
  8: PitchItemKind.transfer,
};

final _candidateCache = <PitchStart, Map<int, List<PitchItem>>>{};

/// Every item that satisfies each slot rule, in canonical order:
/// (x, y) ascending, then (a, b) ascending.
Map<int, List<PitchItem>> pitchSlotCandidates(PitchStart start) =>
    _candidateCache.putIfAbsent(start, () => _buildCandidates(start));

Map<int, List<PitchItem>> _buildCandidates(PitchStart start) {
  final g = PitchGrid.of(start);
  final corner = start == PitchStart.corner;
  final pts = [
    for (var x = g.lo; x <= g.hi; x++)
      for (var y = g.lo; y <= g.hi; y++) PitchPair(x, y),
  ];
  final moves = [
    for (var a = -pitchMaxMove; a <= pitchMaxMove; a++)
      for (var b = -pitchMaxMove; b <= pitchMaxMove; b++)
        if (a != 0 || b != 0) PitchPair(a, b),
  ];
  final tri = [
    for (final p in pts)
      for (final m in moves)
        if (g.contains(p + m)) (p, m),
  ];
  bool notOrigin(PitchPair p) => p != PitchPair.zero;
  bool bothNonZero(PitchPair m) => m.x != 0 && m.y != 0;
  bool singleAxis(PitchPair m) => (m.x == 0) != (m.y == 0);
  // Inverse items: no finish coordinate may restate a move component.
  bool noRestate((PitchPair, PitchPair) t) =>
      (t.$2.x == 0 || t.$1.x != 0) && (t.$2.y == 0 || t.$1.y != 0);

  List<PitchItem> items(int slot, Iterable<(PitchPair, PitchPair)> src) => [
        for (final t in src) PitchItem(slot, pitchSlotKinds[slot]!, t.$1, t.$2),
      ];
  List<PitchItem> positions(int slot, bool Function(PitchPair) keep) => [
        for (final p in pts)
          if (keep(p)) PitchItem(slot, pitchSlotKinds[slot]!, p),
      ];

  final slot4Rule = [
    for (final t in tri)
      if (notOrigin(t.$1) && bothNonZero(t.$2) && t.$2.x != t.$2.y) t,
  ];
  final base6 = [
    for (final t in tri)
      if (notOrigin(t.$1) && bothNonZero(t.$2) && t.$1 != t.$2 && noRestate(t))
        t,
  ];
  final base7 = [
    for (final t in tri)
      if (notOrigin(t.$1) && singleAxis(t.$2) && t.$1 != t.$2 && noRestate(t))
        t,
  ];
  return {
    1: positions(
        1,
        (p) =>
            corner ? p.x >= 1 && p.y >= 1 && p.x != p.y : p.x < 0 && p.y > 0),
    2: positions(
        2,
        (p) =>
            corner ? p.x >= 1 && p.y >= 1 && p.x != p.y : p.y < 0 && p.x > 0),
    3: positions(
        3, (p) => corner ? (p.x == 0) != (p.y == 0) : p.y == 0 && p.x != 0),
    4: items(
        4,
        corner
            ? slot4Rule
            : [
                for (final t in tri)
                  if (t.$1.x < 0 &&
                      t.$1.y < 0 &&
                      bothNonZero(t.$2) &&
                      t.$2.x != t.$2.y)
                    t,
              ]),
    5: items(5, [
      for (final t in tri)
        if (notOrigin(t.$1) && singleAxis(t.$2) && math.min(t.$2.x, t.$2.y) < 0)
          t,
    ]),
    6: items(
        6,
        corner
            ? base6
            : [
                for (final t in base6)
                  if (t.$1.x > 0 && t.$1.y > 0) t,
              ]),
    7: items(
        7,
        corner
            ? base7
            : [
                for (final t in base7)
                  if (t.$1.x == 0 && t.$1.y != 0) t,
              ]),
    8: items(8, slot4Rule),
  };
}

bool _sameParams(PitchItem a, PitchItem b) =>
    a.start == b.start && a.move == b.move;

/// The fixed eight-item session for [start] and [seed]. The same pair
/// always gives the same eight items.
List<PitchItem> pitchSessionItems(PitchStart start, int seed) {
  final g = PitchGrid.of(start);
  final cands = pitchSlotCandidates(start);
  final out = <PitchItem>[];
  for (var s = 1; s <= 8; s++) {
    var c = cands[s]!;
    if (s == 2) {
      c = [
        for (final p in c)
          if (!_sameParams(p, out[0])) p
      ];
    }
    if (s == 8) {
      c = [
        for (final p in c)
          if (!_sameParams(p, out[3])) p
      ];
    }
    if (out.isNotEmpty) {
      final prev = out.last;
      c = [
        for (final p in c)
          if (!_sameParams(p, prev)) p
      ];
    }
    final index =
        pitchUnsignedMod(pitchSplitmix64(seed * 16 + s + g.salt), c.length);
    out.add(c[index]);
  }
  return out;
}

// ---------------------------------------------------------------------------
// Snapping (contract §7.2)

/// Rounds half away from zero (Dart's `round()` does this), then clamps.
int pitchSnapAxis(double u, PitchGrid g) => g.clampAxis(u.round());

/// The grid spot for continuous grid units (u, v), or null when the
/// pointer is more than one unit outside the grid (the drag is cancelled).
PitchPair? pitchSnap(double u, double v, PitchGrid g) {
  if (u < g.lo - 1 || u > g.hi + 1 || v < g.lo - 1 || v > g.hi + 1) return null;
  return PitchPair(pitchSnapAxis(u, g), pitchSnapAxis(v, g));
}

// ---------------------------------------------------------------------------
// Inverse-item direction picker (contract §7.3)

enum PitchDirection { positive, negative, none }

/// One picker: Right / Left / No move (or Up / Down / No move) plus steps.
class PitchMovePicker {
  PitchMovePicker(this.maxSteps);

  final int maxSteps;
  PitchDirection direction = PitchDirection.none;
  int _steps = 1;

  /// The steps stepper is disabled, and ignored, on No move.
  bool get stepsEnabled => direction != PitchDirection.none;
  int get steps => _steps;

  int get value => switch (direction) {
        PitchDirection.none => 0,
        PitchDirection.positive => _steps,
        PitchDirection.negative => -_steps,
      };

  void choose(PitchDirection d) {
    if (direction == PitchDirection.none && d != PitchDirection.none) {
      _steps = 1;
    }
    direction = d;
  }

  bool get canIncrease => stepsEnabled && _steps < maxSteps;
  bool get canDecrease => stepsEnabled && _steps > 1;

  void increase() {
    if (canIncrease) _steps++;
  }

  void decrease() {
    if (canDecrease) _steps--;
  }

  void setValue(int v) {
    direction = v == 0
        ? PitchDirection.none
        : (v > 0 ? PitchDirection.positive : PitchDirection.negative);
    _steps = v == 0 ? 1 : v.abs();
  }

  void reset() {
    direction = PitchDirection.none;
    _steps = 1;
  }
}

// ---------------------------------------------------------------------------
// One visit

enum PitchPhase { answering, notYet, solved, revealed, finished }

/// One eight-item session. Lives only as long as the screen; nothing is
/// stored anywhere.
class PitchCoordinatesSession {
  PitchCoordinatesSession(this.start, this.seed)
      : grid = PitchGrid.of(start),
        items = pitchSessionItems(start, seed),
        horizontal = PitchMovePicker(PitchGrid.of(start).maxSteps),
        vertical = PitchMovePicker(PitchGrid.of(start).maxSteps) {
    _enterItem();
  }

  /// A seed from a non-persisted source.
  static int freshSeed() => math.Random().nextInt(1 << 30);

  final PitchStart start;
  final int seed;
  final PitchGrid grid;
  final List<PitchItem> items;
  final PitchMovePicker horizontal;
  final PitchMovePicker vertical;

  int _index = 0;
  PitchPhase phase = PitchPhase.answering;
  PitchEvaluation? lastEvaluation;

  /// Spot selection on place, translate and transfer items; the
  /// exploration cursor on read items.
  PitchPair cursor = PitchPair.zero;

  /// The two numbers entered on a read item (First number, Second number).
  PitchPair numbers = PitchPair.zero;

  int get index => _index;
  PitchItem get item => items[_index];
  bool get isLast => _index == items.length - 1;

  /// Input is accepted only before confirmation; after a "not yet" the
  /// learner chooses Try again or Show me.
  bool get answering => phase == PitchPhase.answering;
  bool get showsResult =>
      phase == PitchPhase.solved || phase == PitchPhase.revealed;

  /// The learner's current answer, from the input this item uses.
  PitchPair get answer => switch (item.kind) {
        PitchItemKind.read => numbers,
        PitchItemKind.inverse => PitchPair(horizontal.value, vertical.value),
        _ => cursor,
      };

  void _enterItem() {
    final it = item;
    cursor = it.kind == PitchItemKind.read ? PitchPair.zero : it.initialState;
    numbers = PitchPair.zero;
    horizontal.reset();
    vertical.reset();
    lastEvaluation = null;
    phase = PitchPhase.answering;
  }

  /// Moves the cursor one grid step; false (and no move) at the edge.
  bool step(int dx, int dy) {
    if (!answering) return false;
    final next = PitchPair(cursor.x + dx, cursor.y + dy);
    if (!grid.contains(next)) return false;
    cursor = next;
    return true;
  }

  /// Sets the spot from a snapped pointer. Read items take no spot: tapping
  /// or dragging on the grid never answers them.
  void select(PitchPair p) {
    if (!answering || item.kind == PitchItemKind.read) return;
    if (item.kind == PitchItemKind.inverse) return;
    if (grid.contains(p)) cursor = p;
  }

  bool canChangeNumber(int which, int delta) {
    final v = (which == 0 ? numbers.x : numbers.y) + delta;
    return answering && v >= grid.lo && v <= grid.hi;
  }

  /// Read items: changes the first (0) or second (1) number by [delta].
  void changeNumber(int which, int delta) {
    if (item.kind != PitchItemKind.read || !canChangeNumber(which, delta)) {
      return;
    }
    numbers = which == 0
        ? PitchPair(numbers.x + delta, numbers.y)
        : PitchPair(numbers.x, numbers.y + delta);
  }

  PitchEvaluation confirm() {
    final e = pitchEvaluate(item, grid, answer);
    lastEvaluation = e;
    phase = e.isCorrect ? PitchPhase.solved : PitchPhase.notYet;
    return e;
  }

  /// Same item, restored to its initial state.
  void tryAgain() => _enterItem();

  /// Shows the correct answer in the item's own input.
  void showMe() {
    final c = item.correct;
    switch (item.kind) {
      case PitchItemKind.read:
        numbers = c;
      case PitchItemKind.inverse:
        horizontal.setValue(c.x);
        vertical.setValue(c.y);
      default:
        cursor = c;
    }
    phase = PitchPhase.revealed;
  }

  void next() {
    if (isLast) {
      phase = PitchPhase.finished;
      return;
    }
    _index++;
    _enterItem();
  }
}
