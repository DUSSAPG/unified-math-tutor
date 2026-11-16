import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/pitch_coordinates/pitch_coordinates_session.dart';

/// The Pitch Coordinates model against contract V1.2 and the independent
/// validator (PITCH_COORDINATES_VALIDATION_V1_2.md): session generation and
/// fixed vectors, answer uniqueness, every diagnostic rule (none fires on a
/// correct answer), read-item number entry, the placement origin-counting
/// direction, the move pickers and snapping.
void main() {
  const grids = [PitchGrid.corner, PitchGrid.centre];

  List<PitchPair> positions(PitchGrid g) => [
        for (var x = g.lo; x <= g.hi; x++)
          for (var y = g.lo; y <= g.hi; y++) PitchPair(x, y),
      ];
  final moves = [
    for (var a = -4; a <= 4; a++)
      for (var b = -4; b <= 4; b++)
        if (a != 0 || b != 0) PitchPair(a, b),
  ];
  List<PitchItem> fullSpace(PitchGrid g, PitchItemKind kind) =>
      kind == PitchItemKind.read || kind == PitchItemKind.place
          ? [for (final p in positions(g)) PitchItem(0, kind, p)]
          : [
              for (final p in positions(g))
                for (final m in moves)
                  if (g.contains(p + m)) PitchItem(0, kind, p, m),
            ];
  List<PitchPair> answers(PitchGrid g, PitchItemKind kind) =>
      kind == PitchItemKind.inverse
          ? [
              for (var a = -g.maxSteps; a <= g.maxSteps; a++)
                for (var b = -g.maxSteps; b <= g.maxSteps; b++) PitchPair(a, b),
            ]
          : positions(g);

  group('session generation', () {
    const vectors = {
      (
        PitchStart.corner,
        0
      ): '1R(2,4)2P(8,3)3R(6,0)4T(3,4,-2,2)5T(2,0,-1,0)6I(5,8,-1,-4)7I(1,2,0,3)8X(4,4,-3,1)',
      (
        PitchStart.corner,
        1
      ): '1R(4,8)2P(6,2)3R(0,5)4T(3,7,2,1)5T(3,6,-1,0)6I(4,6,-4,-2)7I(1,1,1,0)8X(5,5,-3,-2)',
      (
        PitchStart.corner,
        2
      ): '1R(4,5)2P(1,6)3R(4,0)4T(5,3,3,4)5T(6,6,-1,0)6I(6,4,1,1)7I(8,5,-2,0)8X(2,6,3,1)',
      (
        PitchStart.corner,
        12345
      ): '1R(8,2)2P(4,7)3R(1,0)4T(0,1,3,-1)5T(6,6,0,-4)6I(8,7,-1,-4)7I(5,4,0,4)8X(5,8,-1,-3)',
      (
        PitchStart.centre,
        0
      ): '1R(-5,4)2P(4,-4)3R(-2,0)4T(-3,-4,-1,3)5T(0,-2,-4,0)6I(3,1,-4,-4)7I(0,-1,0,-4)8X(1,3,4,-2)',
      (
        PitchStart.centre,
        1
      ): '1R(-4,4)2P(3,-1)3R(-1,0)4T(-4,-4,-1,1)5T(5,-2,-1,0)6I(4,3,-2,2)7I(0,-5,0,3)8X(1,1,2,-4)',
      (
        PitchStart.centre,
        2
      ): '1R(-3,4)2P(3,-2)3R(-5,0)4T(-1,-1,-3,-4)5T(0,5,0,-4)6I(4,1,-2,2)7I(0,-4,0,1)8X(3,4,-2,-1)',
      (
        PitchStart.centre,
        12345
      ): '1R(-4,5)2P(2,-3)3R(1,0)4T(-4,-2,1,4)5T(4,-2,0,-3)6I(2,1,-1,2)7I(0,4,0,1)8X(4,-4,-4,1)',
    };
    for (final MapEntry(key: (start, seed), value: expected)
        in vectors.entries) {
      test('fixed vector: ${start.name} seed $seed', () {
        expect(
            pitchSessionItems(start, seed).map((i) => i.code).join(), expected);
      });
    }

    test('splitmix64 and unsigned modulo match the reference', () {
      // Reference first output for state 0: 0xE220A8397B1DCDAF.
      expect(BigInt.from(pitchSplitmix64(0)).toUnsigned(64),
          BigInt.parse('E220A8397B1DCDAF', radix: 16));
      // -1 is 2^64 - 1 unsigned; 18446744073709551615 mod 10 = 5.
      expect(pitchUnsignedMod(-1, 10), 5);
      expect(pitchUnsignedMod(7, 3), 1);
    });

    test('candidate list sizes match the validation record', () {
      expect([
        for (var s = 1; s <= 8; s++)
          pitchSlotCandidates(PitchStart.corner)[s]!.length
      ], [
        56,
        56,
        16,
        2344,
        468,
        2288,
        856,
        2344
      ]);
      expect([
        for (var s = 1; s <= 8; s++)
          pitchSlotCandidates(PitchStart.centre)[s]!.length
      ], [
        25,
        25,
        10,
        770,
        740,
        896,
        56,
        3980
      ]);
    });

    test('10,000 seeds per start: every slot rule and guarantee holds', () {
      int quad(PitchPair p) => p.x > 0 && p.y > 0
          ? 1
          : p.x < 0 && p.y > 0
              ? 2
              : p.x < 0 && p.y < 0
                  ? 3
                  : p.x > 0 && p.y < 0
                      ? 4
                      : 0;
      for (final g in grids) {
        for (var seed = 0; seed < 10000; seed++) {
          final s = pitchSessionItems(g.start, seed);
          expect(s.length, 8);
          final quads = <int>{}, axes = <String>{};
          for (var i = 0; i < 8; i++) {
            final it = s[i];
            final slot = i + 1;
            final why = '${g.start.name} seed $seed $it';
            expect(it.slot, slot, reason: why);
            expect(it.kind, pitchSlotKinds[slot], reason: why);
            expect(g.contains(it.start), isTrue, reason: why);
            expect(g.contains(it.finish), isTrue, reason: why);
            expect(it.move.x.abs() <= 4 && it.move.y.abs() <= 4, isTrue);
            if (it.kind == PitchItemKind.read ||
                it.kind == PitchItemKind.place) {
              expect(it.start, isNot(PitchPair.zero), reason: why);
            } else {
              expect(it.move, isNot(PitchPair.zero), reason: why);
            }
            if (it.kind == PitchItemKind.inverse) {
              expect(it.start, isNot(PitchPair.zero), reason: why);
              expect(it.start, isNot(it.move), reason: why);
              if (it.move.x != 0) expect(it.start.x, isNot(0), reason: why);
              if (it.move.y != 0) expect(it.start.y, isNot(0), reason: why);
            }
            expect(it.initialState, isNot(it.correct), reason: why);
            for (final p in pitchPredictions(it, g).values) {
              expect(p, isNot(it.correct), reason: why);
            }
            if (i > 0) {
              final prev = s[i - 1];
              expect(prev.start == it.start && prev.move == it.move, isFalse,
                  reason: why);
            }
            if (slot == 1 && g.start == PitchStart.corner) {
              expect(it.start.x, isNot(it.start.y));
            }
            if (slot == 5) {
              expect((it.move.x == 0) != (it.move.y == 0), isTrue);
              expect(it.move.x < 0 || it.move.y < 0, isTrue);
            }
            if ([1, 2, 4, 6].contains(slot)) quads.add(quad(it.start));
            if (slot == 3) axes.add(it.start.y == 0 ? 'x' : 'y');
            if (slot == 7) axes.add(it.start.x == 0 ? 'y' : 'x');
          }
          expect(s[1].start == s[0].start, isFalse);
          expect(s[7].start == s[3].start && s[7].move == s[3].move, isFalse);
          if (g.start == PitchStart.centre) {
            expect(quads, {1, 2, 3, 4}, reason: 'seed $seed');
            expect(axes, {'x', 'y'}, reason: 'seed $seed');
          } else {
            expect((s[2].start.x == 0) != (s[2].start.y == 0), isTrue);
          }
        }
      }
    });

    test('the same start and seed always give the same eight items', () {
      for (final seed in [0, 7, 99999]) {
        expect(pitchSessionItems(PitchStart.centre, seed),
            pitchSessionItems(PitchStart.centre, seed));
      }
    });
  });

  group('answers and diagnostic rules (full space)', () {
    test(
        'exactly one CORRECT per item; zero rules fire on a correct answer; '
        'totals match the validator', () {
      var items = 0, evaluations = 0, correct = 0, diagnostic = 0, generic = 0;
      final applications = <PitchRule, int>{};
      for (final g in grids) {
        for (final kind in [
          PitchItemKind.read,
          PitchItemKind.place,
          PitchItemKind.translate,
          PitchItemKind.inverse,
        ]) {
          final domain = answers(g, kind);
          for (final it in fullSpace(g, kind)) {
            items++;
            final preds = pitchPredictions(it, g);
            for (final e in preds.entries) {
              applications.update(e.key, (n) => n + 1, ifAbsent: () => 1);
              expect(e.value, isNot(it.correct), reason: '$it ${e.key.id}');
            }
            var nCorrect = 0;
            for (final a in domain) {
              evaluations++;
              final r = pitchEvaluate(it, g, a);
              switch (r.outcome) {
                case PitchOutcome.correct:
                  nCorrect++;
                  correct++;
                  expect(r.rule, isNull);
                  expect(a, it.correct);
                case PitchOutcome.diagnostic:
                  diagnostic++;
                  expect(preds[r.rule], a);
                case PitchOutcome.generic:
                  generic++;
              }
            }
            expect(nCorrect, 1, reason: '$it');
          }
        }
      }
      expect(items, 19924);
      expect(evaluations, 4828644);
      expect(correct, 19924);
      expect(diagnostic, 87665);
      expect(generic, 4721055);
      expect(applications.values.fold<int>(0, (a, b) => a + b), 91555);
      expect({
        for (final e in applications.entries) e.key.id: e.value
      }, {
        'D-R1': 364, 'D-R2x': 333, 'D-R2y': 333, 'D-R2xy': 277, //
        'D-T1': 9760, 'D-T2': 7328, 'D-T3': 7328, 'D-T4': 4960,
        'D-T5': 4928, 'D-T6': 4928, 'D-T7': 5904, 'D-T8': 7160,
        'D-I1': 9656, 'D-I2': 9712, 'D-I3': 9760, 'D-I4': 8824,
      });
    });

    // One concrete item per rule where that rule alone predicts the answer.
    final cases = <(PitchRule, PitchItem, PitchGrid, PitchPair)>[
      (
        PitchRule.orderSwapped,
        const PitchItem(1, PitchItemKind.read, PitchPair(2, 5)),
        PitchGrid.corner,
        const PitchPair(5, 2)
      ),
      (
        PitchRule.originCountedHorizontal,
        const PitchItem(1, PitchItemKind.read, PitchPair(2, 5)),
        PitchGrid.corner,
        const PitchPair(3, 5)
      ),
      (
        PitchRule.originCountedVertical,
        const PitchItem(1, PitchItemKind.read, PitchPair(2, 5)),
        PitchGrid.corner,
        const PitchPair(2, 6)
      ),
      (
        PitchRule.originCountedBoth,
        const PitchItem(1, PitchItemKind.read, PitchPair(2, 5)),
        PitchGrid.corner,
        const PitchPair(3, 6)
      ),
      (
        PitchRule.startNotMoved,
        const PitchItem(
            4, PitchItemKind.translate, PitchPair(3, 4), PitchPair(-2, 2)),
        PitchGrid.corner,
        const PitchPair(3, 4)
      ),
      (
        PitchRule.horizontalOnly,
        const PitchItem(
            4, PitchItemKind.translate, PitchPair(3, 4), PitchPair(-2, 2)),
        PitchGrid.corner,
        const PitchPair(1, 4)
      ),
      (
        PitchRule.verticalOnly,
        const PitchItem(
            4, PitchItemKind.translate, PitchPair(3, 4), PitchPair(-2, 2)),
        PitchGrid.corner,
        const PitchPair(3, 6)
      ),
      (
        PitchRule.bothReversed,
        const PitchItem(
            4, PitchItemKind.translate, PitchPair(3, 4), PitchPair(-1, 2)),
        PitchGrid.corner,
        const PitchPair(4, 2)
      ),
      (
        PitchRule.horizontalReversed,
        const PitchItem(
            4, PitchItemKind.translate, PitchPair(3, 4), PitchPair(-2, 2)),
        PitchGrid.corner,
        const PitchPair(5, 6)
      ),
      (
        PitchRule.verticalReversed,
        const PitchItem(
            4, PitchItemKind.translate, PitchPair(3, 4), PitchPair(-2, 2)),
        PitchGrid.corner,
        const PitchPair(1, 2)
      ),
      (
        PitchRule.movesSwapped,
        const PitchItem(
            4, PitchItemKind.translate, PitchPair(3, 4), PitchPair(-1, 2)),
        PitchGrid.corner,
        const PitchPair(5, 3)
      ),
      (
        PitchRule.gaveMove,
        const PitchItem(
            4, PitchItemKind.transfer, PitchPair(4, 4), PitchPair(3, 1)),
        PitchGrid.corner,
        const PitchPair(3, 1)
      ),
      (
        PitchRule.gaveFinish,
        const PitchItem(
            6, PitchItemKind.inverse, PitchPair(5, 8), PitchPair(-1, -4)),
        PitchGrid.corner,
        const PitchPair(4, 4)
      ),
      (
        PitchRule.gaveStart,
        const PitchItem(
            6, PitchItemKind.inverse, PitchPair(5, 8), PitchPair(-1, -4)),
        PitchGrid.corner,
        const PitchPair(5, 8)
      ),
      (
        PitchRule.moveReversed,
        const PitchItem(
            6, PitchItemKind.inverse, PitchPair(5, 8), PitchPair(-1, -4)),
        PitchGrid.corner,
        const PitchPair(1, 4)
      ),
      (
        PitchRule.inverseMovesSwapped,
        const PitchItem(
            6, PitchItemKind.inverse, PitchPair(5, 8), PitchPair(-1, -4)),
        PitchGrid.corner,
        const PitchPair(-4, -1)
      ),
    ];
    for (final (rule, item, g, answer) in cases) {
      test('${rule.id} fires on its own predicted answer, never on correct',
          () {
        final r = pitchEvaluate(item, g, answer);
        expect(r.outcome, PitchOutcome.diagnostic);
        expect(r.rule, rule);
        expect(
            pitchEvaluate(item, g, item.correct).outcome, PitchOutcome.correct);
      });
    }
    test('every rule is covered by a case above', () {
      expect(cases.map((c) => c.$1).toSet(), PitchRule.values.toSet());
    });

    test('a tie resolves to generic feedback, never a misconception', () {
      // a = -b: both moves reversed and moves swapped predict (4, 4).
      const t = PitchItem(
          4, PitchItemKind.translate, PitchPair(6, 2), PitchPair(2, -2));
      final p = pitchPredictions(t, PitchGrid.corner);
      expect(p[PitchRule.bothReversed], p[PitchRule.movesSwapped]);
      expect(pitchEvaluate(t, PitchGrid.corner, const PitchPair(4, 4)).outcome,
          PitchOutcome.generic);
      // D-I3 = D-I4 when a = -b.
      const i = PitchItem(
          6, PitchItemKind.inverse, PitchPair(3, 3), PitchPair(2, -2));
      expect(pitchEvaluate(i, PitchGrid.corner, const PitchPair(-2, 2)).outcome,
          PitchOutcome.generic);
    });

    test('an unmatched wrong answer is generic', () {
      const t = PitchItem(1, PitchItemKind.read, PitchPair(2, 5));
      expect(pitchEvaluate(t, PitchGrid.corner, const PitchPair(7, 0)).outcome,
          PitchOutcome.generic);
    });

    test('conditions suppress rules that would equal the correct answer', () {
      // x = y: no order swap; start at origin: no "gave the move".
      expect(
          pitchPredictions(
                  const PitchItem(1, PitchItemKind.read, PitchPair(4, 4)),
                  PitchGrid.corner)
              .containsKey(PitchRule.orderSwapped),
          isFalse);
      expect(
          pitchPredictions(
                  const PitchItem(4, PitchItemKind.translate, PitchPair.zero,
                      PitchPair(4, 4)),
                  PitchGrid.corner)
              .containsKey(PitchRule.gaveMove),
          isFalse);
      final inv = pitchPredictions(
          const PitchItem(
              6, PitchItemKind.inverse, PitchPair(2, 3), PitchPair(2, 3)),
          PitchGrid.corner);
      expect(inv.containsKey(PitchRule.gaveStart), isFalse);
      expect(inv.containsKey(PitchRule.inverseMovesSwapped), isTrue);
    });
  });

  group('placement origin-counting direction (M-2)', () {
    test('read predicts one step further from the origin', () {
      final p = pitchPredictions(
          const PitchItem(1, PitchItemKind.read, PitchPair(-3, 2)),
          PitchGrid.centre);
      expect(p[PitchRule.originCountedHorizontal], const PitchPair(-4, 2));
      expect(p[PitchRule.originCountedVertical], const PitchPair(-3, 3));
      expect(p[PitchRule.originCountedBoth], const PitchPair(-4, 3));
    });

    test('place predicts one step nearer the origin', () {
      final p = pitchPredictions(
          const PitchItem(2, PitchItemKind.place, PitchPair(-3, 2)),
          PitchGrid.centre);
      expect(p[PitchRule.originCountedHorizontal], const PitchPair(-2, 2));
      expect(p[PitchRule.originCountedVertical], const PitchPair(-3, 1));
      expect(p[PitchRule.originCountedBoth], const PitchPair(-2, 1));
      final edge = pitchPredictions(
          const PitchItem(2, PitchItemKind.place, PitchPair(8, 3)),
          PitchGrid.corner);
      expect(edge[PitchRule.originCountedHorizontal], const PitchPair(7, 3));
      expect(edge[PitchRule.originCountedBoth], const PitchPair(7, 2));
      final one = pitchPredictions(
          const PitchItem(2, PitchItemKind.place, PitchPair(1, 6)),
          PitchGrid.corner);
      expect(one[PitchRule.originCountedHorizontal], const PitchPair(0, 6));
    });

    test('direction holds on every read and place item of both grids', () {
      var r = 0, p = 0;
      for (final g in grids) {
        for (final pos in positions(g)) {
          for (final kind in [PitchItemKind.read, PitchItemKind.place]) {
            final preds = pitchPredictions(PitchItem(0, kind, pos), g);
            for (final e in preds.entries) {
              if (e.key == PitchRule.orderSwapped) continue;
              kind == PitchItemKind.read ? r++ : p++;
              for (final (v, pv) in [(pos.x, e.value.x), (pos.y, e.value.y)]) {
                if (v == pv) continue;
                expect(pv.abs(),
                    kind == PitchItemKind.read ? v.abs() + 1 : v.abs() - 1,
                    reason: '$kind $pos ${e.key.id}');
              }
            }
          }
        }
      }
      expect((r, p), (415, 528));
    });

    test('a placement one step too near the origin gets the origin feedback',
        () {
      const it = PitchItem(2, PitchItemKind.place, PitchPair(8, 3));
      final r = pitchEvaluate(it, PitchGrid.corner, const PitchPair(7, 3));
      expect(r.rule, PitchRule.originCountedHorizontal);
      // One step too far is not that misconception on a placement.
      expect(
          pitchEvaluate(
                  const PitchItem(2, PitchItemKind.place, PitchPair(4, 7)),
                  PitchGrid.corner,
                  const PitchPair(5, 7))
              .outcome,
          PitchOutcome.generic);
    });
  });

  group('read items: number steppers only (M-1)', () {
    test('selecting a spot never answers a read item', () {
      final s = PitchCoordinatesSession(PitchStart.corner, 0);
      expect(s.item.kind, PitchItemKind.read);
      expect(s.item.start, const PitchPair(2, 4));
      s.select(const PitchPair(2, 4)); // the player's own spot
      expect(s.numbers, PitchPair.zero);
      expect(s.answer, PitchPair.zero);
      expect(s.confirm().isCorrect, isFalse);
    });

    test('steppers start at 0, 0 and stay within the grid', () {
      final s = PitchCoordinatesSession(PitchStart.centre, 0);
      expect(s.numbers, PitchPair.zero);
      for (var i = 0; i < 9; i++) {
        s.changeNumber(0, -1);
      }
      expect(s.numbers.x, -5);
      expect(s.canChangeNumber(0, -1), isFalse);
      for (var i = 0; i < 4; i++) {
        s.changeNumber(1, 1);
      }
      expect(s.answer, const PitchPair(-5, 4));
      expect(s.confirm().isCorrect, isTrue,
          reason: 'centre seed 0 slot 1 is (-5, 4)');
    });

    test('Try again restores 0, 0; Show me reveals the pair', () {
      final s = PitchCoordinatesSession(PitchStart.corner, 0);
      s.changeNumber(0, 1);
      s.confirm();
      expect(s.phase, PitchPhase.notYet);
      s.changeNumber(0, 1);
      expect(s.numbers, const PitchPair(1, 0),
          reason: 'input locked after a not-yet');
      s.tryAgain();
      expect(s.numbers, PitchPair.zero);
      expect(s.phase, PitchPhase.answering);
      s.showMe();
      expect(s.numbers, s.item.correct);
      expect(s.phase, PitchPhase.revealed);
    });
  });

  group('move pickers and No move (M-3)', () {
    test('initial No move gives 0 and disables steps', () {
      final p = PitchMovePicker(8);
      expect(p.direction, PitchDirection.none);
      expect(p.value, 0);
      expect(p.stepsEnabled, isFalse);
      expect(p.canIncrease || p.canDecrease, isFalse);
      p.increase();
      expect(p.value, 0);
    });

    test('choosing a direction starts at 1; switching keeps the steps', () {
      final p = PitchMovePicker(8)..choose(PitchDirection.positive);
      expect(p.value, 1);
      p
        ..increase()
        ..increase();
      expect(p.value, 3);
      p.choose(PitchDirection.negative);
      expect(p.value, -3);
      p.choose(PitchDirection.none);
      expect(p.value, 0, reason: 'No move ignores the steps');
      p.choose(PitchDirection.positive);
      expect(p.value, 1, reason: 'from No move a direction starts at 1');
    });

    test('steps stay in 1..maxSteps and reach every value', () {
      for (final g in grids) {
        final values = <int>{};
        for (final d in PitchDirection.values) {
          final p = PitchMovePicker(g.maxSteps)..choose(d);
          values.add(p.value);
          for (var i = 0; i < 20; i++) {
            p.increase();
            values.add(p.value);
          }
          expect(p.steps <= g.maxSteps, isTrue);
          for (var i = 0; i < 20; i++) {
            p.decrease();
          }
          expect(p.steps >= 1, isTrue);
        }
        expect(values, {for (var v = -g.maxSteps; v <= g.maxSteps; v++) v});
      }
    });

    test('an inverse item starts at (No move, No move) and Try again resets',
        () {
      final s = PitchCoordinatesSession(PitchStart.corner, 0);
      while (s.item.kind != PitchItemKind.inverse) {
        s.showMe();
        s.next();
      }
      expect(s.answer, PitchPair.zero);
      s.horizontal.choose(PitchDirection.negative);
      s.vertical.choose(PitchDirection.negative);
      for (var i = 0; i < 3; i++) {
        s.vertical.increase();
      }
      expect(s.answer, s.item.correct, reason: '6I(5,8,-1,-4)');
      expect(s.confirm().isCorrect, isTrue);
      s.next();
      s.horizontal.choose(PitchDirection.positive);
      s.confirm();
      s.tryAgain();
      expect(s.horizontal.direction, PitchDirection.none);
      expect(s.answer, PitchPair.zero);
    });
  });

  group('snapping and tie-breaks', () {
    test('half away from zero, then clamp', () {
      const g = PitchGrid.centre;
      expect(pitchSnapAxis(2.5, g), 3);
      expect(pitchSnapAxis(-2.5, g), -3);
      expect(pitchSnapAxis(2.45, g), 2);
      expect(pitchSnapAxis(-2.45, g), -2);
      expect(pitchSnapAxis(.5, g), 1);
      expect(pitchSnapAxis(-.5, g), -1);
      expect(pitchSnapAxis(0, g), 0);
      expect(pitchSnapAxis(5.6, g), 5);
      expect(pitchSnapAxis(-5.6, g), -5);
    });

    test('cancel beyond one unit outside the grid, per axis', () {
      const g = PitchGrid.corner;
      expect(pitchSnap(-1, 4, g), const PitchPair(0, 4));
      expect(pitchSnap(-1.01, 4, g), isNull);
      expect(pitchSnap(9, 9, g), const PitchPair(8, 8));
      expect(pitchSnap(3, 9.05, g), isNull);
      expect(pitchSnap(3.5, 2.5, g), const PitchPair(4, 3));
    });

    test('every 0.05-unit pointer position snaps as the rule says', () {
      for (final g in grids) {
        for (var n = (g.lo - 1) * 20 - 5; n <= (g.hi + 1) * 20 + 5; n++) {
          final u = n / 20;
          final r = pitchSnap(u, 0, g);
          if (u < g.lo - 1 || u > g.hi + 1) {
            expect(r, isNull, reason: '$u');
          } else {
            final expected =
                ((u.abs() + .5).floor() * (u < 0 ? -1 : 1)).clamp(g.lo, g.hi);
            expect(r!.x, expected, reason: '$u');
          }
        }
      }
    });

    test('select only accepts spots on spot items', () {
      final s = PitchCoordinatesSession(PitchStart.corner, 0)
        ..showMe()
        ..next();
      expect(s.item.kind, PitchItemKind.place);
      expect(s.cursor, PitchPair.zero);
      s.select(const PitchPair(8, 3));
      expect(s.confirm().isCorrect, isTrue);
    });
  });

  group('visit flow', () {
    test('eight items, then finished; Explore again uses seed + 1', () {
      final s = PitchCoordinatesSession(PitchStart.corner, 41);
      for (var i = 0; i < 8; i++) {
        expect(s.index, i);
        s
          ..showMe()
          ..next();
      }
      expect(s.phase, PitchPhase.finished);
      final again = PitchCoordinatesSession(s.start, s.seed + 1);
      expect(again.items, pitchSessionItems(PitchStart.corner, 42));
    });

    test('the cursor stops at the grid edge', () {
      final s = PitchCoordinatesSession(PitchStart.corner, 0)
        ..showMe()
        ..next();
      expect(s.step(-1, 0), isFalse);
      expect(s.step(0, -1), isFalse);
      expect(s.cursor, PitchPair.zero);
      expect(s.step(1, 0), isTrue);
      expect(s.cursor, const PitchPair(1, 0));
    });
  });
}
