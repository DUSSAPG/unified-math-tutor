import 'dart:math' as math;

/// Fractions of a Set: to find n/d of a collection of T objects, share the
/// collection into d equal groups of g = T / d, then take n of those groups
/// (contract CC-FRAC-SET-001 v1.1 plus the binding errata of build brief V1).
///
/// Pure Dart: parameter spaces, the fixed eight-item deck, deterministic
/// selection, answer evaluation, the grouping and take steps and the phase
/// state machine (errata I-1). All learner wording lives in the screen; this
/// file returns structured results only. Nothing here is persisted.

/// Denominators: how many equal groups to make.
const fosDenominators = [2, 3, 4, 5, 6, 8, 10];

/// Group sizes. Groups of one are excluded everywhere.
const fosGroupSizes = [2, 3, 4, 5, 6];

/// Largest collection.
const fosMaxTotal = 30;

/// The prediction stepper range is fixed, so it never depends on the answer.
const fosStepperMax = 30;

// ---------------------------------------------------------------------------
// Items

/// U unit find, N non-unit find, X bare transfer, W what fraction,
/// C compare, E equal-groups check.
enum FosItemKind { unit, nonUnit, transfer, what, compare, equalCheck }

/// One find, transfer or what-fraction case: n/d of T = d × g.
class FosFind {
  const FosFind(this.n, this.d, this.g);

  final int n;
  final int d;
  final int g;

  int get total => d * g;
  int get answer => n * g;

  @override
  bool operator ==(Object other) =>
      other is FosFind && other.n == n && other.d == d && other.g == g;

  @override
  int get hashCode => Object.hash(n, d, g);
}

/// One comparison case: 1/a of T against 1/b of T, with a < b.
class FosCompare {
  const FosCompare(this.total, this.a, this.b);

  final int total;
  final int a;
  final int b;

  /// 1/a of T: always the larger part.
  int get valueA => total ~/ a;

  /// 1/b of T: always the smaller part.
  int get valueB => total ~/ b;

  @override
  bool operator ==(Object other) =>
      other is FosCompare &&
      other.total == total &&
      other.a == a &&
      other.b == b;

  @override
  int get hashCode => Object.hash(total, a, b);
}

/// One equal-groups check. Equal when [m] is 0; otherwise [m] counters
/// moved from tray [i] to tray [j]. Trays are numbered 1 … d (errata M-1).
class FosEqualCheck {
  const FosEqualCheck(this.d, this.g, [this.m = 0, this.i = 0, this.j = 0]);

  final int d;
  final int g;
  final int m;
  final int i;
  final int j;

  bool get isEqual => m == 0;
  int get total => d * g;

  /// Tray counts, index 0 holding tray 1.
  List<int> get trays => [
        for (var t = 1; t <= d; t++)
          t == i
              ? g - m
              : t == j
                  ? g + m
                  : g,
      ];

  @override
  bool operator ==(Object other) =>
      other is FosEqualCheck &&
      other.d == d &&
      other.g == g &&
      other.m == m &&
      other.i == i &&
      other.j == j;

  @override
  int get hashCode => Object.hash(d, g, m, i, j);
}

/// One deck item. Exactly one of [find], [compare] and [check] is set.
class FosItem {
  const FosItem._(this.slot, this.kind,
      {this.find, this.compare, this.check, this.smallerDenominatorFirst});

  final int slot;
  final FosItemKind kind;
  final FosFind? find;
  final FosCompare? compare;
  final FosEqualCheck? check;

  /// C items only: true shows 1/a first (contract §6.3).
  final bool? smallerDenominatorFirst;

  /// U and N items have the tray steps (group, then take).
  bool get hasTraySteps =>
      kind == FosItemKind.unit || kind == FosItemKind.nonUnit;

  /// Number of trays shown for this item, or 0 when it has none.
  int get trayCount => switch (kind) {
        FosItemKind.unit || FosItemKind.nonUnit || FosItemKind.what => find!.d,
        FosItemKind.equalCheck => check!.d,
        _ => 0,
      };

  int get total => switch (kind) {
        FosItemKind.compare => compare!.total,
        FosItemKind.equalCheck => check!.total,
        _ => find!.total,
      };
}

// ---------------------------------------------------------------------------
// Parameter spaces (contract §6.1), in canonical order (§6.3)

/// Find space: d, then g, then n ascending. 102 cases.
final List<FosFind> fosFindSpace = List.unmodifiable([
  for (final d in fosDenominators)
    for (final g in fosGroupSizes)
      if (d * g <= fosMaxTotal)
        for (var n = 1; n < d; n++) FosFind(n, d, g),
]);

/// U: n = 1. 28 cases.
final List<FosFind> fosUnitSpace =
    List.unmodifiable(fosFindSpace.where((f) => f.n == 1));

/// N: n ≥ 2. 74 cases.
final List<FosFind> fosNonUnitSpace =
    List.unmodifiable(fosFindSpace.where((f) => f.n >= 2));

/// W: the find space with g ≠ n. 88 cases.
final List<FosFind> fosWhatSpace =
    List.unmodifiable(fosFindSpace.where((f) => f.g != f.n));

/// C: T, then a, then b ascending. 43 cases.
final List<FosCompare> fosCompareSpace = List.unmodifiable([
  for (var t = 1; t <= fosMaxTotal; t++)
    for (final a in fosDenominators)
      for (final b in fosDenominators)
        if (a < b && t % a == 0 && t % b == 0 && t ~/ b >= 2)
          FosCompare(t, a, b),
]);

/// E equal: d, then g. 28 cases.
final List<FosEqualCheck> fosEqualSpace = List.unmodifiable([
  for (final d in fosDenominators)
    for (final g in fosGroupSizes)
      if (d * g <= fosMaxTotal) FosEqualCheck(d, g),
]);

/// E unequal: d, g, m, i, j, with trays numbered 1 … d (errata M-1).
/// 1,008 cases.
final List<FosEqualCheck> fosUnequalSpace = List.unmodifiable([
  for (final d in fosDenominators)
    for (final g in fosGroupSizes)
      if (d * g <= fosMaxTotal)
        for (final m in const [1, 2])
          if (g >= m + 1)
            for (var i = 1; i <= d; i++)
              for (var j = 1; j <= d; j++)
                if (i != j) FosEqualCheck(d, g, m, i, j),
]);

/// Slot 2's separating probes: R1 applies, and every applicable rule value
/// is distinct and differs from the correct answer. 16 cases.
final List<FosFind> fosSeparatingSpace =
    List.unmodifiable(fosNonUnitSpace.where((f) {
  final values = fosFindRuleValues(f);
  if (!values.containsKey(FosRule.r1DividedByTop)) return false;
  final v = values.values.toList();
  return v.toSet().length == v.length && !v.contains(f.answer);
}));

// ---------------------------------------------------------------------------
// Diagnostics (contract §8; correctness first)

/// R* find, W* what fraction, C* compare, E* equal check, G1 grouping.
/// G0 (take count) is generic by design, so it is not a rule here.
enum FosRule {
  r1DividedByTop,
  r2TookN,
  r3OneGroup,
  r4OtherGroups,
  r5Whole,
  w1ObjectCount,
  w2GroupSize,
  w3NotChosen,
  w4Whole,
  c1BiggerDenominator,
  c2Same,
  e1UnequalAccepted,
  e2EqualRejected,
  g1UnequalTrays,
}

/// The result of one locked answer.
sealed class FosOutcome {
  const FosOutcome();
}

class FosCorrect extends FosOutcome {
  const FosCorrect();
}

class FosDiagnostic extends FosOutcome {
  const FosDiagnostic(this.rule);

  final FosRule rule;

  @override
  bool operator ==(Object other) =>
      other is FosDiagnostic && other.rule == rule;

  @override
  int get hashCode => rule.hashCode;
}

/// No rule matched, or two or more tied.
class FosGeneric extends FosOutcome {
  const FosGeneric();
}

/// Every applicable find rule (§8.2) and its value. Each applicability
/// condition already excludes the cases where the value equals n × g.
Map<FosRule, int> fosFindRuleValues(FosFind f) {
  final n = f.n, d = f.d, g = f.g, t = f.total;
  return {
    if (n >= 2 && t % n == 0 && d != n * n) FosRule.r1DividedByTop: t ~/ n,
    FosRule.r2TookN: n,
    if (n >= 2) FosRule.r3OneGroup: g,
    if (d != 2 * n) FosRule.r4OtherGroups: (d - n) * g,
    FosRule.r5Whole: t,
  };
}

/// Every applicable what-fraction rule (§8.3) and its value.
Map<FosRule, int> fosWhatRuleValues(FosFind f) => {
      FosRule.w1ObjectCount: f.n * f.g,
      FosRule.w2GroupSize: f.g,
      if (f.d != 2 * f.n) FosRule.w3NotChosen: f.d - f.n,
      FosRule.w4Whole: f.d,
    };

FosOutcome _byRules(Map<FosRule, int> rules, int value) {
  final hits = [
    for (final e in rules.entries)
      if (e.value == value) e.key,
  ];
  return hits.length == 1 ? FosDiagnostic(hits.single) : const FosGeneric();
}

/// U, N and X: the prediction [p].
FosOutcome fosEvaluateFind(FosFind f, int p) =>
    p == f.answer ? const FosCorrect() : _byRules(fosFindRuleValues(f), p);

/// W: the picked numerator [k].
FosOutcome fosEvaluateWhat(FosFind f, int k) =>
    k == f.n ? const FosCorrect() : _byRules(fosWhatRuleValues(f), k);

/// C answer choices. [larger] is 1/a, the smaller denominator.
enum FosCompareChoice { larger, smaller, same }

FosOutcome fosEvaluateCompare(FosCompareChoice choice) => switch (choice) {
      FosCompareChoice.larger => const FosCorrect(),
      FosCompareChoice.smaller =>
        const FosDiagnostic(FosRule.c1BiggerDenominator),
      FosCompareChoice.same => const FosDiagnostic(FosRule.c2Same),
    };

/// E: [fair] is the learner's Yes.
FosOutcome fosEvaluateEqual(FosEqualCheck e, bool fair) {
  if (fair == e.isEqual) return const FosCorrect();
  return FosDiagnostic(
      e.isEqual ? FosRule.e2EqualRejected : FosRule.e1UnequalAccepted);
}

/// Grouping validity (§5.3): every counter placed, and every tray equal.
bool fosGroupsValid(List<int> trays, int collection) =>
    collection == 0 && trays.isNotEmpty && trays.every((c) => c == trays[0]);

/// Errata M-2: a tray differs when its count is not g = T / d.
bool fosTrayDiffers(int count, int g) => count != g;

/// Take (§5.3): the number of chosen trays must be exactly n.
bool fosTakeCorrect(int chosenCount, int n) => chosenCount == n;

// ---------------------------------------------------------------------------
// Deterministic selection (contract §6.3)

int _u64(int hi, int lo) => (hi << 32) | lo;
final int _gamma = _u64(0x9E3779B9, 0x7F4A7C15);
final int _mix1 = _u64(0xBF58476D, 0x1CE4E5B9);
final int _mix2 = _u64(0x94D049BB, 0x133111EB);

/// splitmix64 over 64-bit two's-complement ints (wrapping on the Dart VM).
int fosSplitmix64(int v) {
  var z = v + _gamma;
  z = (z ^ (z >>> 30)) * _mix1;
  z = (z ^ (z >>> 27)) * _mix2;
  return z ^ (z >>> 31);
}

/// Unsigned [z] mod [n]; Dart's `%` on a negative int would differ.
int fosUnsignedMod(int z, int n) =>
    (BigInt.from(z).toUnsigned(64) % BigInt.from(n)).toInt();

T _pick<T>(List<T> list, int seed, int slot) =>
    list[fosUnsignedMod(fosSplitmix64(seed * 16 + slot), list.length)];

/// The fixed eight-item deck for [seed] (contract §6.2): slots chosen 1 → 8
/// in ascending order, each filtered against the slots already chosen.
List<FosItem> fosDeck(int seed) {
  final s1 = _pick(fosUnitSpace, seed, 1);
  final s2 = _pick([
    for (final f in fosSeparatingSpace)
      if (f != s1) f,
  ], seed, 2);
  final s3 = _pick(fosUnequalSpace, seed, 3);
  final s4 = _pick([
    for (final f in fosWhatSpace)
      if (f != s1 && f != s2) f,
  ], seed, 4);
  final s5 = _pick(fosCompareSpace, seed, 5);
  final s6 = _pick([
    for (final f in fosNonUnitSpace)
      if (f != s1 && f != s2 && f != s4) f,
  ], seed, 6);
  final s7 = _pick([
    for (final e in fosEqualSpace)
      if (e.d != s3.d || e.g != s3.g) e,
  ], seed, 7);
  final s8 = _pick([
    for (final f in fosNonUnitSpace)
      if (f != s1 && f != s2 && f != s4 && f != s6) f,
  ], seed, 8);
  final smallerFirst = fosUnsignedMod(fosSplitmix64(seed * 16 + 9), 2) == 0;
  return [
    FosItem._(1, FosItemKind.unit, find: s1),
    FosItem._(2, FosItemKind.nonUnit, find: s2),
    FosItem._(3, FosItemKind.equalCheck, check: s3),
    FosItem._(4, FosItemKind.what, find: s4),
    FosItem._(5, FosItemKind.compare,
        compare: s5, smallerDenominatorFirst: smallerFirst),
    FosItem._(6, FosItemKind.nonUnit, find: s6),
    FosItem._(7, FosItemKind.equalCheck, check: s7),
    FosItem._(8, FosItemKind.transfer, find: s8),
  ];
}

// ---------------------------------------------------------------------------
// Session and phase state machine (errata I-1)

/// [answer] is I-1's Predict phase on U and N items, and the single
/// answering phase of X, W, C and E items.
enum FosPhase { answer, group, take, reveal, finished }

class FractionsOfASetSession {
  FractionsOfASetSession(this.seed) : items = fosDeck(seed) {
    _enterItem();
  }

  /// A non-persisted session seed.
  static int freshSeed() => math.Random().nextInt(1 << 30);

  final int seed;
  final List<FosItem> items;

  int index = 0;
  FosPhase phase = FosPhase.answer;

  /// U, N, X prediction (0 … 30) and W numerator (0 … d). Starts at 0.
  int value = 0;

  /// C and E choices. Nothing selected at first.
  FosCompareChoice? compareChoice;
  bool? fairChoice;

  /// The locked answer's outcome.
  FosOutcome? outcome;

  /// Tray counts (index 0 is tray 1) and counters left in the collection.
  List<int> trays = const [];
  int collection = 0;

  /// Chosen trays in the take step (0-based indexes).
  final Set<int> chosen = {};

  /// G1 was triggered and nothing has changed since.
  bool unequalNotice = false;

  /// G0: the number chosen when Take these groups was pressed with a
  /// count other than n; null when not shown.
  int? takeCountNotice;

  FosItem get item => items[index];
  bool get finished => phase == FosPhase.finished;

  int get valueMax =>
      item.kind == FosItemKind.what ? item.find!.d : fosStepperMax;

  void _enterItem() {
    phase = FosPhase.answer;
    value = 0;
    compareChoice = null;
    fairChoice = null;
    outcome = null;
    chosen.clear();
    unequalNotice = false;
    takeCountNotice = null;
    final it = item;
    switch (it.kind) {
      case FosItemKind.unit:
      case FosItemKind.nonUnit:
        trays = List.filled(it.find!.d, 0);
        collection = it.find!.total;
      case FosItemKind.equalCheck:
        trays = it.check!.trays;
        collection = 0;
      case FosItemKind.what:
      case FosItemKind.compare:
      case FosItemKind.transfer:
        trays = const [];
        collection = it.total;
    }
  }

  // --- answer phase -------------------------------------------------------

  bool get canIncrease => phase == FosPhase.answer && value < valueMax;
  bool get canDecrease => phase == FosPhase.answer && value > 0;

  void increase() {
    if (canIncrease) value++;
  }

  void decrease() {
    if (canDecrease) value--;
  }

  void chooseCompare(FosCompareChoice c) {
    if (phase == FosPhase.answer) compareChoice = c;
  }

  void chooseFair(bool fair) {
    if (phase == FosPhase.answer) fairChoice = fair;
  }

  bool get canConfirm =>
      phase == FosPhase.answer &&
      switch (item.kind) {
        FosItemKind.compare => compareChoice != null,
        FosItemKind.equalCheck => fairChoice != null,
        _ => true,
      };

  /// Locks the answer. U and N go on to the group step; everything else
  /// reveals at once.
  void confirm() {
    if (!canConfirm) return;
    final it = item;
    outcome = switch (it.kind) {
      FosItemKind.unit ||
      FosItemKind.nonUnit ||
      FosItemKind.transfer =>
        fosEvaluateFind(it.find!, value),
      FosItemKind.what => fosEvaluateWhat(it.find!, value),
      FosItemKind.compare => fosEvaluateCompare(compareChoice!),
      FosItemKind.equalCheck => fosEvaluateEqual(it.check!, fairChoice!),
    };
    phase = it.hasTraySteps ? FosPhase.group : FosPhase.reveal;
  }

  // --- group phase (I-1) ----------------------------------------------------

  bool get inGroup => phase == FosPhase.group;

  /// Tray activate in the group phase: only while counters remain.
  bool get canAddToTray => inGroup && collection > 0;
  bool canTakeOneOut(int tray) => inGroup && trays[tray] > 0;
  bool get canDeal => inGroup && collection > 0;
  bool get canStartAgain => inGroup && trays.any((c) => c > 0);
  bool get canGroupsReady => inGroup && collection == 0;

  void addToTray(int tray) {
    if (!canAddToTray) return;
    trays = [...trays]..[tray] += 1;
    collection--;
    unequalNotice = false;
  }

  void takeOneOut(int tray) {
    if (!canTakeOneOut(tray)) return;
    trays = [...trays]..[tray] -= 1;
    collection++;
    unequalNotice = false;
  }

  /// One counter to each tray in tray order while counters remain. Also
  /// the collection's own activate action.
  void dealRound() {
    if (!canDeal) return;
    final next = [...trays];
    for (var t = 0; t < next.length && collection > 0; t++) {
      next[t]++;
      collection--;
    }
    trays = next;
    unequalNotice = false;
  }

  void startAgain() {
    if (!canStartAgain) return;
    collection += trays.fold(0, (a, b) => a + b);
    trays = List.filled(trays.length, 0);
    unequalNotice = false;
  }

  /// Equal trays go on to the take step; unequal trays trigger G1 and stay.
  void groupsReady() {
    if (!canGroupsReady) return;
    if (fosGroupsValid(trays, collection)) {
      unequalNotice = false;
      phase = FosPhase.take;
    } else {
      unequalNotice = true;
    }
  }

  /// Trays outlined after G1: exactly those whose count is not g (M-2).
  bool trayDiffers(int tray) => switch (item.kind) {
        FosItemKind.unit ||
        FosItemKind.nonUnit =>
          unequalNotice && fosTrayDiffers(trays[tray], item.find!.g),
        FosItemKind.equalCheck => phase == FosPhase.reveal &&
            fosTrayDiffers(trays[tray], item.check!.g),
        _ => false,
      };

  // --- take phase (I-1) -----------------------------------------------------

  bool get inTake => phase == FosPhase.take;
  bool get canTakeConfirm => inTake && chosen.isNotEmpty;

  void toggleChosen(int tray) {
    if (!inTake) return;
    if (!chosen.remove(tray)) chosen.add(tray);
    takeCountNotice = null;
  }

  void takeConfirm() {
    if (!canTakeConfirm) return;
    if (fosTakeCorrect(chosen.length, item.find!.n)) {
      takeCountNotice = null;
      phase = FosPhase.reveal;
    } else {
      takeCountNotice = chosen.length;
    }
  }

  /// Tray activate is available in the group phase (add one, while counters
  /// remain) and the take phase (toggle chosen); otherwise not at all.
  bool get trayActivatable => canAddToTray || inTake;

  void activateTray(int tray) {
    if (inTake) {
      toggleChosen(tray);
    } else {
      addToTray(tray);
    }
  }

  // --- reveal ---------------------------------------------------------------

  void next() {
    if (phase != FosPhase.reveal) return;
    if (index == items.length - 1) {
      phase = FosPhase.finished;
      return;
    }
    index++;
    _enterItem();
  }
}
