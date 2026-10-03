import 'package:flutter/foundation.dart';

/// The three place-value rods, most significant first.
enum AbacusRod { hundreds, tens, ones }

/// What (if anything) had to be swapped between rods when a Number Board
/// control changed the number. Shown as one calm sentence so the change stays
/// understandable, especially when animation is off.
enum AbacusExchangeNote {
  none,
  tenOnesForTen,
  tenTensForHundred,
  tenOnesAndTensCascade,
  tenForTenOnes,
  hundredForTenTens,
  hundredCascade,
}

/// The result of applying a Number Board control.
@immutable
class AbacusMove {
  const AbacusMove(this.state, this.note);

  final AbacusState state;
  final AbacusExchangeNote note;
}

/// How many beads are counted on each rod. Pure, immutable and deterministic:
/// no persistence, no learner data. Each rod holds at most [beadsPerRod]
/// beads, so the number is always 0-999 and always in ordinary place-value
/// form (ten on one rod always become one on the rod to its left).
///
/// Beads on a rod are numbered 1..9 by their distance from the divider on
/// the counted side, so "bead k is counted" means `k <= count`.
@immutable
class AbacusState {
  const AbacusState(this.hundreds, this.tens, this.ones)
      : assert(hundreds >= 0 && hundreds <= beadsPerRod),
        assert(tens >= 0 && tens <= beadsPerRod),
        assert(ones >= 0 && ones <= beadsPerRod);

  static const beadsPerRod = 9;
  static const maxValue = 999;
  static const empty = AbacusState(0, 0, 0);

  /// Value must be 0..[maxValue].
  factory AbacusState.fromValue(int value) {
    assert(value >= 0 && value <= maxValue);
    return AbacusState(value ~/ 100, (value ~/ 10) % 10, value % 10);
  }

  final int hundreds;
  final int tens;
  final int ones;

  int get value => hundreds * 100 + tens * 10 + ones;

  int count(AbacusRod rod) {
    switch (rod) {
      case AbacusRod.hundreds:
        return hundreds;
      case AbacusRod.tens:
        return tens;
      case AbacusRod.ones:
        return ones;
    }
  }

  AbacusState withCount(AbacusRod rod, int count) {
    final n = count.clamp(0, beadsPerRod);
    switch (rod) {
      case AbacusRod.hundreds:
        return AbacusState(n, tens, ones);
      case AbacusRod.tens:
        return AbacusState(hundreds, n, ones);
      case AbacusRod.ones:
        return AbacusState(hundreds, tens, n);
    }
  }

  /// Tapping (or dragging across the divider) bead [bead] (1..9) on [rod].
  ///
  /// * A waiting bead slides across, taking every waiting bead between it and
  ///   the divider with it: the count becomes [bead].
  /// * A counted bead slides back, taking every counted bead beyond it with
  ///   it: the count becomes `bead - 1`.
  AbacusState afterBeadTap(AbacusRod rod, int bead) {
    assert(bead >= 1 && bead <= beadsPerRod);
    final current = count(rod);
    return withCount(rod, bead <= current ? bead - 1 : bead);
  }

  /// Number Board controls are +1, -1, +10 and -10.
  static const boardDeltas = [1, -1, 10, -10];

  /// A control is available only when the result stays within 0..999.
  bool canApply(int delta) {
    assert(boardDeltas.contains(delta));
    final next = value + delta;
    return next >= 0 && next <= maxValue;
  }

  /// Moves the beads so the number changes by [delta], swapping between rods
  /// where needed (39 + 1 = 40 clears the ones and moves one tens bead).
  /// Returns null when [canApply] is false — callers disable the control
  /// rather than let it silently do nothing.
  AbacusMove? apply(int delta) {
    if (!canApply(delta)) return null;
    final next = AbacusState.fromValue(value + delta);
    return AbacusMove(next, _noteFor(delta));
  }

  AbacusExchangeNote _noteFor(int delta) {
    switch (delta) {
      case 1:
        if (ones != 9) return AbacusExchangeNote.none;
        return tens == 9
            ? AbacusExchangeNote.tenOnesAndTensCascade
            : AbacusExchangeNote.tenOnesForTen;
      case 10:
        return tens == 9
            ? AbacusExchangeNote.tenTensForHundred
            : AbacusExchangeNote.none;
      case -1:
        if (ones != 0) return AbacusExchangeNote.none;
        return tens == 0
            ? AbacusExchangeNote.hundredCascade
            : AbacusExchangeNote.tenForTenOnes;
      case -10:
        return tens == 0
            ? AbacusExchangeNote.hundredForTenTens
            : AbacusExchangeNote.none;
    }
    return AbacusExchangeNote.none;
  }

  @override
  bool operator ==(Object other) =>
      other is AbacusState &&
      other.hundreds == hundreds &&
      other.tens == tens &&
      other.ones == ones;

  @override
  int get hashCode => Object.hash(hundreds, tens, ones);

  @override
  String toString() => 'AbacusState($hundreds h, $tens t, $ones o = $value)';
}
