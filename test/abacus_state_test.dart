import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/abacus_example.dart';
import 'package:unified_math_tutor/models/abacus_state.dart';

/// The abacus's rules, with no widgets: what a bead tap does, what each
/// Number Board control does (including swaps between rods), when a control
/// is unavailable, and that the three guided examples are correct.
void main() {
  group('AbacusState', () {
    test('value and digits agree, and fromValue round-trips 0..999', () {
      for (var v = 0; v <= 999; v++) {
        final s = AbacusState.fromValue(v);
        expect(s.value, v);
        expect(s.hundreds * 100 + s.tens * 10 + s.ones, v);
      }
      expect(const AbacusState(3, 2, 1).value, 321);
    });

    test('tapping a waiting bead slides it and the beads before it across', () {
      // Ones rod empty: bead 4 is the 4th from the divider.
      final s = AbacusState.empty.afterBeadTap(AbacusRod.ones, 4);
      expect(s.ones, 4);
      expect(s.value, 4);
      // Only that rod changes.
      expect(s.tens, 0);
      expect(s.hundreds, 0);
    });

    test('tapping a counted bead slides it and the beads beyond it back', () {
      const s = AbacusState(0, 5, 0);
      expect(s.afterBeadTap(AbacusRod.tens, 5).tens, 4,
          reason: 'bead 5, the furthest counted bead, goes back alone');
      expect(s.afterBeadTap(AbacusRod.tens, 3).tens, 2,
          reason: 'beads 3, 4 and 5 all return');
      expect(s.afterBeadTap(AbacusRod.tens, 1).tens, 0,
          reason: 'bead 1 returns every counted bead');
    });

    test('every tap on every bead of every rod lands on a legal state', () {
      for (final rod in AbacusRod.values) {
        for (var count = 0; count <= 9; count++) {
          final base = AbacusState.empty.withCount(rod, count);
          for (var bead = 1; bead <= 9; bead++) {
            final next = base.afterBeadTap(rod, bead);
            expect(next.count(rod), inInclusiveRange(0, 9));
            expect(next.count(rod), bead <= count ? bead - 1 : bead);
          }
        }
      }
    });

    test('withCount clamps to the nine beads a rod holds', () {
      expect(AbacusState.empty.withCount(AbacusRod.ones, 12).ones, 9);
      expect(AbacusState.empty.withCount(AbacusRod.ones, -3).ones, 0);
    });
  });

  group('Number Board controls', () {
    test('+1 and -1 move the ones beads', () {
      expect(AbacusState.fromValue(34).apply(1)!.state.value, 35);
      expect(AbacusState.fromValue(34).apply(1)!.state.ones, 5);
      expect(AbacusState.fromValue(34).apply(-1)!.state.ones, 3);
    });

    test('+10 and -10 move the tens beads', () {
      final up = AbacusState.fromValue(34).apply(10)!.state;
      expect((up.tens, up.ones), (4, 4));
      final down = AbacusState.fromValue(34).apply(-10)!.state;
      expect((down.tens, down.ones), (2, 4));
    });

    test('ten ones swap for one ten (39 + 1 = 40)', () {
      final move = AbacusState.fromValue(39).apply(1)!;
      expect(
          (move.state.hundreds, move.state.tens, move.state.ones), (0, 4, 0));
      expect(move.note, AbacusExchangeNote.tenOnesForTen);
    });

    test('ten tens swap for one hundred (90 + 10 = 100)', () {
      final move = AbacusState.fromValue(90).apply(10)!;
      expect(
          (move.state.hundreds, move.state.tens, move.state.ones), (1, 0, 0));
      expect(move.note, AbacusExchangeNote.tenTensForHundred);
    });

    test('a cascade swaps twice (99 + 1 = 100)', () {
      final move = AbacusState.fromValue(99).apply(1)!;
      expect(
          (move.state.hundreds, move.state.tens, move.state.ones), (1, 0, 0));
      expect(move.note, AbacusExchangeNote.tenOnesAndTensCascade);
    });

    test('borrowing swaps back (40 - 1 = 39, 100 - 10 = 90, 100 - 1 = 99)', () {
      final a = AbacusState.fromValue(40).apply(-1)!;
      expect((a.state.tens, a.state.ones), (3, 9));
      expect(a.note, AbacusExchangeNote.tenForTenOnes);

      final b = AbacusState.fromValue(100).apply(-10)!;
      expect((b.state.hundreds, b.state.tens), (0, 9));
      expect(b.note, AbacusExchangeNote.hundredForTenTens);

      final c = AbacusState.fromValue(100).apply(-1)!;
      expect((c.state.hundreds, c.state.tens, c.state.ones), (0, 9, 9));
      expect(c.note, AbacusExchangeNote.hundredCascade);
    });

    test('a change with no swap has no swap note', () {
      expect(AbacusState.fromValue(34).apply(1)!.note, AbacusExchangeNote.none);
      expect(
          AbacusState.fromValue(34).apply(-10)!.note, AbacusExchangeNote.none);
    });

    test('every control result equals plain arithmetic, in place-value form',
        () {
      for (var v = 0; v <= 999; v++) {
        final s = AbacusState.fromValue(v);
        for (final d in AbacusState.boardDeltas) {
          final move = s.apply(d);
          if (v + d < 0 || v + d > 999) {
            expect(move, isNull, reason: '$v $d must be unavailable');
            expect(s.canApply(d), isFalse);
          } else {
            expect(s.canApply(d), isTrue);
            expect(move!.state, AbacusState.fromValue(v + d));
          }
        }
      }
    });

    test('controls are unavailable exactly at the edges', () {
      const zero = AbacusState.empty;
      expect(zero.canApply(-1), isFalse);
      expect(zero.canApply(-10), isFalse);
      expect(zero.canApply(1), isTrue);
      expect(zero.canApply(10), isTrue);

      expect(AbacusState.fromValue(9).canApply(-10), isFalse);
      expect(AbacusState.fromValue(10).canApply(-10), isTrue);

      final top = AbacusState.fromValue(999);
      expect(top.canApply(1), isFalse);
      expect(top.canApply(10), isFalse);
      expect(AbacusState.fromValue(989).canApply(10), isTrue);
      expect(AbacusState.fromValue(990).canApply(10), isFalse);
    });
  });

  group('guided examples', () {
    test('there are exactly three, in a fixed order', () {
      expect(AbacusExample.all.map((e) => e.id).toList(), [
        AbacusExampleId.build,
        AbacusExampleId.breakApart,
        AbacusExampleId.exchange,
      ]);
    });

    test('build starts empty and its target is 3 tens and 4 ones = 34', () {
      final e = AbacusExample.build;
      expect(e.start, AbacusState.empty);
      expect(e.target.value, 34);
      expect((e.target.tens, e.target.ones), (3, 4));
      expect(e.isDone(e.start), isFalse);
      // Reachable by tapping beads.
      final built = e.start
          .afterBeadTap(AbacusRod.tens, 3)
          .afterBeadTap(AbacusRod.ones, 4);
      expect(e.isDone(built), isTrue);
    });

    test('break apart starts at 47 and is done at 40 (the 7 taken away)', () {
      final e = AbacusExample.breakApart;
      expect(e.start.value, 47);
      expect(e.target.value, 40);
      expect(e.isDone(e.start), isFalse);
      expect(e.start.value, e.target.value + 7);
      expect(e.isDone(e.start.withCount(AbacusRod.ones, 0)), isTrue);
      // Also reachable with the board: -1 seven times.
      var s = e.start;
      for (var i = 0; i < 7; i++) {
        s = s.apply(-1)!.state;
      }
      expect(e.isDone(s), isTrue);
    });

    test('exchange starts at 29 and +1 swaps ten ones for one ten to reach 30',
        () {
      final e = AbacusExample.exchange;
      expect(e.start.value, 29);
      expect(e.start.ones, 9);
      final move = e.start.apply(1)!;
      expect(e.isDone(move.state), isTrue);
      expect(move.note, AbacusExchangeNote.tenOnesForTen);
      expect(move.state.value, e.start.value + 1);
    });

    test('a target is never already satisfied by its own start', () {
      for (final e in AbacusExample.all) {
        expect(e.isDone(e.start), isFalse, reason: '${e.id}');
      }
    });
  });
}
