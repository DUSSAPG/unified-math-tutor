import 'abacus_state.dart';

/// The three guided examples, in fixed order. Fully deterministic: each has
/// one starting arrangement and one target arrangement, and is "done" when
/// the beads show the target (by any route). Nothing is scored or saved.
enum AbacusExampleId { build, breakApart, exchange }

class AbacusExample {
  const AbacusExample(this.id, this.start, this.target);

  final AbacusExampleId id;
  final AbacusState start;
  final AbacusState target;

  bool isDone(AbacusState state) => state == target;

  /// Build 34 from an empty abacus: 3 tens and 4 ones.
  static const build = AbacusExample(
      AbacusExampleId.build, AbacusState.empty, AbacusState(0, 3, 4));

  /// Start from 47 and take the ones away to leave just the tens: 40.
  static const breakApart = AbacusExample(
      AbacusExampleId.breakApart, AbacusState(0, 4, 7), AbacusState(0, 4, 0));

  /// Start from 29 (9 ones) and add 1: ten ones swap for one ten, giving 30.
  static const exchange = AbacusExample(
      AbacusExampleId.exchange, AbacusState(0, 2, 9), AbacusState(0, 3, 0));

  static const all = [build, breakApart, exchange];
}
