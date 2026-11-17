import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/fractions_of_a_set/fractions_of_a_set_session.dart';

/// Fractions of a Set session model (brief §8 group 1): parameter spaces,
/// the contract §13 fixed vectors, answer uniqueness, zero false diagnostic
/// triggers, ties, deck rules over 10,000 seeds, the unequal construction
/// (errata M-1, M-2), grouping validity, the take count, the I-1 phase
/// machine, and the unsigned final modulo.
void main() {
  String code(FosItem it) {
    switch (it.kind) {
      case FosItemKind.unit:
      case FosItemKind.nonUnit:
      case FosItemKind.transfer:
        final f = it.find!;
        final k = it.kind == FosItemKind.unit
            ? 'U'
            : it.kind == FosItemKind.nonUnit
                ? 'N'
                : 'X';
        return '$k ${f.n}/${f.d} of ${f.total}';
      case FosItemKind.what:
        final f = it.find!;
        return 'W n${f.n} d${f.d} g${f.g}';
      case FosItemKind.compare:
        final c = it.compare!;
        return 'C 1/${c.a} vs 1/${c.b} of ${c.total}';
      case FosItemKind.equalCheck:
        final e = it.check!;
        return e.isEqual
            ? 'E d${e.d} g${e.g}'
            : 'E d${e.d} g${e.g} m${e.m} i${e.i} j${e.j}';
    }
  }

  group('parameter spaces (contract §6.1)', () {
    test('sizes 102 / 28 / 74 / 88 / 43 / 28 / 1,008', () {
      expect(fosFindSpace.length, 102);
      expect(fosUnitSpace.length, 28);
      expect(fosNonUnitSpace.length, 74);
      expect(fosWhatSpace.length, 88);
      expect(fosCompareSpace.length, 43);
      expect(fosEqualSpace.length, 28);
      expect(fosUnequalSpace.length, 1008);
      expect(fosUnequalSpace.where((e) => e.m == 1).length, 612);
      expect(fosUnequalSpace.where((e) => e.m == 2).length, 396);
    });

    test('no group of one anywhere; T ≤ 30; n in 1 … d − 1', () {
      for (final f in fosFindSpace) {
        expect(f.g, greaterThanOrEqualTo(2));
        expect(f.total, lessThanOrEqualTo(30));
        expect(f.n, inInclusiveRange(1, f.d - 1));
      }
      for (final c in fosCompareSpace) {
        expect(c.valueB, greaterThanOrEqualTo(2));
        expect(c.valueA, greaterThan(c.valueB));
        expect(c.total % c.a, 0);
        expect(c.total % c.b, 0);
      }
      for (final e in [...fosEqualSpace, ...fosUnequalSpace]) {
        expect(e.g, greaterThanOrEqualTo(2));
      }
    });

    test('16 separating candidates, exactly as validated', () {
      expect(fosSeparatingSpace.map((f) => (f.n, f.d, f.g)).toList(), const [
        (2, 5, 4), (2, 5, 6), (3, 5, 6), (3, 6, 2), (2, 6, 3), //
        (2, 6, 4), (3, 6, 4), (2, 6, 5), (3, 6, 5), (2, 8, 3),
        (4, 8, 3), (4, 10, 2), (5, 10, 2), (2, 10, 3), (5, 10, 3),
        (6, 10, 3),
      ]);
    });
  });

  group('fixed vectors (contract §13), 1-based trays (M-1)', () {
    final vectors = <int, (List<String>, bool)>{
      0: (
        [
          'U 1/3 of 18',
          'N 5/10 of 30',
          'E d10 g2 m1 i4 j1',
          'W n1 d3 g4',
          'C 1/2 vs 1/3 of 30',
          'N 8/10 of 20',
          'E d6 g3',
          'X 3/5 of 20',
        ],
        true
      ),
      1: (
        [
          'U 1/10 of 30',
          'N 3/5 of 30',
          'E d3 g4 m1 i1 j2',
          'W n2 d6 g3',
          'C 1/2 vs 1/4 of 16',
          'N 2/8 of 24',
          'E d2 g6',
          'X 6/8 of 16',
        ],
        false
      ),
      2: (
        [
          'U 1/8 of 16',
          'N 2/10 of 30',
          'E d6 g2 m1 i1 j5',
          'W n6 d10 g2',
          'C 1/3 vs 1/6 of 18',
          'N 4/8 of 16',
          'E d4 g6',
          'X 2/6 of 30',
        ],
        false
      ),
      42: (
        [
          'U 1/4 of 16',
          'N 2/5 of 30',
          'E d10 g2 m1 i9 j8',
          'W n1 d5 g2',
          'C 1/2 vs 1/4 of 20',
          'N 5/6 of 12',
          'E d6 g5',
          'X 2/10 of 30',
        ],
        false
      ),
    };
    vectors.forEach((seed, v) {
      test('seed $seed', () {
        final deck = fosDeck(seed);
        expect(deck.map(code).toList(), v.$1);
        expect(deck[4].smallerDenominatorFirst, v.$2, reason: 'C option order');
        expect(deck.map((it) => it.slot).toList(), [1, 2, 3, 4, 5, 6, 7, 8]);
      });
    });

    test('seed 0 slot 3 trays: tray 4 gives one to tray 1', () {
      final e = fosDeck(0)[2].check!;
      expect(e.trays, [3, 2, 2, 1, 2, 2, 2, 2, 2, 2]);
    });
  });

  group('answers and diagnostics (contract §7, §8)', () {
    test('find: one correct prediction in 0–30; no rule value equals it', () {
      for (final f in fosFindSpace) {
        final correct = [
          for (var p = 0; p <= fosStepperMax; p++)
            if (fosEvaluateFind(f, p) is FosCorrect) p,
        ];
        expect(correct, [f.answer]);
        expect(fosFindRuleValues(f).values, isNot(contains(f.answer)),
            reason: '${f.n}/${f.d} of ${f.total}');
      }
    });

    test('W: one correct numerator in 0 … d; no rule value equals it', () {
      for (final f in fosWhatSpace) {
        final correct = [
          for (var k = 0; k <= f.d; k++)
            if (fosEvaluateWhat(f, k) is FosCorrect) k,
        ];
        expect(correct, [f.n]);
        expect(fosWhatRuleValues(f).values, isNot(contains(f.n)));
      }
    });

    test('find outcomes over all 3,162 pairs match the validation', () {
      final counts = <String, int>{};
      for (final f in fosFindSpace) {
        for (var p = 0; p <= fosStepperMax; p++) {
          final o = fosEvaluateFind(f, p);
          final k = switch (o) {
            FosCorrect() => 'correct',
            FosDiagnostic(:final rule) => rule.name,
            FosGeneric() => 'generic',
          };
          counts[k] = (counts[k] ?? 0) + 1;
        }
      }
      expect(counts, {
        'correct': 102,
        'r1DividedByTop': 34,
        'r2TookN': 85,
        'r3OneGroup': 41,
        'r4OtherGroups': 59,
        'r5Whole': 102,
        'generic': 2739,
      });
    });

    test('W outcomes over all 614 pairs match the validation', () {
      final counts = <String, int>{};
      for (final f in fosWhatSpace) {
        for (var k = 0; k <= f.d; k++) {
          final o = fosEvaluateWhat(f, k);
          final key = switch (o) {
            FosCorrect() => 'correct',
            FosDiagnostic(:final rule) => rule.name,
            FosGeneric() => 'generic',
          };
          counts[key] = (counts[key] ?? 0) + 1;
        }
      }
      expect(counts, {
        'correct': 88,
        'w1ObjectCount': 4,
        'w2GroupSize': 36,
        'w3NotChosen': 59,
        'w4Whole': 74,
        'generic': 353,
      });
    });

    test('headline 3/5 of 20: every modelled error is distinct', () {
      const f = FosFind(3, 5, 4);
      expect(fosEvaluateFind(f, 12), isA<FosCorrect>());
      expect(fosEvaluateFind(f, 3), const FosDiagnostic(FosRule.r2TookN));
      expect(fosEvaluateFind(f, 4), const FosDiagnostic(FosRule.r3OneGroup));
      expect(fosEvaluateFind(f, 8), const FosDiagnostic(FosRule.r4OtherGroups));
      expect(fosEvaluateFind(f, 20), const FosDiagnostic(FosRule.r5Whole));
      expect(fosEvaluateFind(f, 7), isA<FosGeneric>());
      // 20 ÷ 3 is not whole, so R1 does not apply.
      expect(fosFindRuleValues(f).containsKey(FosRule.r1DividedByTop), isFalse);
    });

    test('a tie gives generic feedback', () {
      // n = g: R2 = R3 = 2 (R1 suppressed by d = n², R4 by d = 2n).
      expect(fosEvaluateFind(const FosFind(2, 4, 2), 2), isA<FosGeneric>());
      // n = d − 1: R3 = R4.
      expect(fosEvaluateFind(const FosFind(4, 5, 3), 3), isA<FosGeneric>());
      // T = n²: R1 = R2 (4/8 of 16).
      expect(fosEvaluateFind(const FosFind(4, 8, 2), 4), isA<FosGeneric>());
      // R1 alone on a separating probe.
      expect(fosEvaluateFind(const FosFind(2, 5, 4), 10),
          const FosDiagnostic(FosRule.r1DividedByTop));
    });

    test('suppressions: d = 2n has no R4; d = n² has no R1', () {
      expect(fosFindRuleValues(const FosFind(3, 6, 2)),
          isNot(contains(FosRule.r4OtherGroups)));
      expect(fosFindRuleValues(const FosFind(2, 4, 3)),
          isNot(contains(FosRule.r1DividedByTop)));
      expect(fosWhatRuleValues(const FosFind(3, 6, 2)),
          isNot(contains(FosRule.w3NotChosen)));
    });

    test('C: 1/a is correct; 1/b is C1; "same" is C2', () {
      for (final c in fosCompareSpace) {
        expect(c.valueA, greaterThan(c.valueB));
      }
      expect(fosEvaluateCompare(FosCompareChoice.larger), isA<FosCorrect>());
      expect(fosEvaluateCompare(FosCompareChoice.smaller),
          const FosDiagnostic(FosRule.c1BiggerDenominator));
      expect(fosEvaluateCompare(FosCompareChoice.same),
          const FosDiagnostic(FosRule.c2Same));
    });

    test('E: exactly one of Yes and No is correct; E1 and E2', () {
      for (final e in [...fosEqualSpace, ...fosUnequalSpace]) {
        final yes = fosEvaluateEqual(e, true) is FosCorrect;
        final no = fosEvaluateEqual(e, false) is FosCorrect;
        expect(yes != no, isTrue);
        expect(yes, e.isEqual);
      }
      expect(fosEvaluateEqual(fosUnequalSpace.first, true),
          const FosDiagnostic(FosRule.e1UnequalAccepted));
      expect(fosEvaluateEqual(fosEqualSpace.first, false),
          const FosDiagnostic(FosRule.e2EqualRejected));
    });
  });

  group('deck rules (contract §6.2)', () {
    test('10,000 seeds: every deck valid; C order split 5,077 : 4,923', () {
      var smallerFirst = 0;
      for (var seed = 0; seed < 10000; seed++) {
        final deck = fosDeck(seed);
        expect(deck.map((it) => it.kind).toList(), const [
          FosItemKind.unit,
          FosItemKind.nonUnit,
          FosItemKind.equalCheck,
          FosItemKind.what,
          FosItemKind.compare,
          FosItemKind.nonUnit,
          FosItemKind.equalCheck,
          FosItemKind.transfer,
        ]);
        final numeric = [
          for (final i in const [0, 1, 3, 5, 7]) deck[i].find!
        ];
        expect(numeric.toSet().length, 5, reason: 'seed $seed');
        expect(numeric.every((f) => f.g >= 2), isTrue);
        expect(deck[0].find!.n, 1);
        expect(fosSeparatingSpace, contains(deck[1].find));
        expect(deck[2].check!.isEqual, isFalse);
        expect(deck[6].check!.isEqual, isTrue);
        expect(
            (deck[6].check!.d, deck[6].check!.g) ==
                (deck[2].check!.d, deck[2].check!.g),
            isFalse,
            reason: 'seed $seed: slot 7 trays equal slot 3');
        expect(deck[3].find!.g, isNot(deck[3].find!.n));
        expect(deck[5].find!.n, greaterThanOrEqualTo(2));
        expect(deck[7].find!.n, greaterThanOrEqualTo(2));
        if (deck[4].smallerDenominatorFirst!) smallerFirst++;
      }
      expect((smallerFirst, 10000 - smallerFirst), (5077, 4923));
    });

    test('unsigned final modulo', () {
      final z = fosSplitmix64(0);
      expect(BigInt.from(z).toUnsigned(64),
          BigInt.parse('e220a8397b1dcdaf', radix: 16));
      expect(z, isNegative, reason: 'top bit set: signed % would differ');
      expect(fosUnsignedMod(z, 7), 2);
      expect(z % 7, 0, reason: 'the signed result this guards against');
      expect(fosUnsignedMod(z, 1008), 79);
      expect(fosUnsignedMod(z, 43), 18);
    });
  });

  group('unequal construction (M-1, M-2)', () {
    test('keeps T, keeps every tray ≥ 1, exactly trays i and j differ', () {
      for (final e in fosUnequalSpace) {
        final t = e.trays;
        expect(t.length, e.d);
        expect(t.fold<int>(0, (a, b) => a + b), e.total);
        expect(t.every((c) => c >= 1), isTrue);
        final differing = [
          for (var k = 0; k < t.length; k++)
            if (fosTrayDiffers(t[k], e.g)) k + 1,
        ];
        expect(differing.toSet(), {e.i, e.j});
        expect(t[e.i - 1], e.g - e.m);
        expect(t[e.j - 1], e.g + e.m);
        expect(fosGroupsValid(t, 0), isFalse);
      }
      for (final e in fosEqualSpace) {
        expect(e.trays, List.filled(e.d, e.g));
        expect(fosGroupsValid(e.trays, 0), isTrue);
      }
    });
  });

  group('grouping and take (contract §5.3)', () {
    test('brute force: exactly one valid final state for small (d, g)', () {
      var checked = 0;
      for (final e in fosEqualSpace) {
        final d = e.d, t = e.total;
        // Compositions of T into d parts: C(T + d − 1, d − 1).
        var states = BigInt.one;
        for (var k = 1; k < d; k++) {
          states = states * BigInt.from(t + k) ~/ BigInt.from(k);
        }
        if (states > BigInt.from(60000)) {
          // All-equal property: d equal parts summing to dg are all g.
          expect(fosGroupsValid(List.filled(d, e.g), 0), isTrue);
          expect(
              fosGroupsValid([e.g + 1, e.g - 1, ...List.filled(d - 2, e.g)], 0),
              isFalse);
          continue;
        }
        var valid = <List<int>>[];
        void walk(List<int> prefix, int left) {
          if (prefix.length == d - 1) {
            final s = [...prefix, left];
            if (fosGroupsValid(s, 0)) valid.add(s);
            return;
          }
          for (var c = 0; c <= left; c++) {
            walk([...prefix, c], left - c);
          }
        }

        walk([], t);
        expect(valid, [List.filled(d, e.g)], reason: 'd ${e.d} g ${e.g}');
        checked++;
      }
      expect(checked, greaterThanOrEqualTo(10));
    });

    test('not valid while counters remain in the collection', () {
      expect(fosGroupsValid([2, 2], 2), isFalse);
      expect(fosGroupsValid([0, 0], 0), isTrue,
          reason: 'never reachable: the collection starts with T ≥ 4');
    });

    test('take: correct exactly when the number chosen is n', () {
      for (final f in fosFindSpace) {
        for (var k = 0; k <= f.d; k++) {
          expect(fosTakeCorrect(k, f.n), k == f.n);
        }
      }
    });
  });

  group('phase machine (errata I-1)', () {
    test('U item: predict, group with G1, take with G0, reveal, next', () {
      final s = FractionsOfASetSession(0);
      expect(code(s.item), 'U 1/3 of 18');
      // Predict: trays empty and not targets; every tray control hidden.
      expect(s.phase, FosPhase.answer);
      expect(s.value, 0);
      expect(s.trays, [0, 0, 0]);
      expect(s.collection, 18);
      expect(s.trayActivatable, isFalse);
      expect(s.canAddToTray, isFalse);
      expect(s.canTakeOneOut(0), isFalse);
      expect(s.canDeal, isFalse);
      expect(s.canStartAgain, isFalse);
      expect(s.canGroupsReady, isFalse);
      expect(s.canTakeConfirm, isFalse);
      expect(s.canConfirm, isTrue);
      s.addToTray(0);
      expect(s.trays, [0, 0, 0], reason: 'no tray action while predicting');

      s.increase();
      s.increase();
      s.confirm();
      expect(s.outcome, isA<FosGeneric>(),
          reason: '2 is no rule for 1/3 of 18');
      expect(s.phase, FosPhase.group);
      expect(s.canIncrease, isFalse, reason: 'the prediction is locked');

      // Group.
      expect(s.canAddToTray, isTrue);
      expect(s.trayActivatable, isTrue);
      expect(s.canDeal, isTrue);
      expect(s.canStartAgain, isFalse);
      expect(s.canGroupsReady, isFalse);
      expect(s.canTakeOneOut(0), isFalse);
      s.addToTray(0);
      expect(s.trays, [1, 0, 0]);
      expect(s.collection, 17);
      expect(s.canTakeOneOut(0), isTrue);
      expect(s.canTakeOneOut(1), isFalse);
      expect(s.canStartAgain, isTrue);
      for (var r = 0; r < 6; r++) {
        s.dealRound();
      }
      expect(s.trays, [7, 6, 5]);
      expect(s.collection, 0);
      expect(s.canAddToTray, isFalse);
      expect(s.trayActivatable, isFalse,
          reason: 'tray activate is absent when the collection is empty');
      expect(s.canDeal, isFalse);
      expect(s.canGroupsReady, isTrue);
      s.groupsReady();
      expect(s.phase, FosPhase.group, reason: 'G1: stay in Group');
      expect(s.unequalNotice, isTrue);
      expect(
          [for (var k = 0; k < 3; k++) s.trayDiffers(k)], [true, false, true]);
      s.takeOneOut(0);
      expect(s.unequalNotice, isFalse);
      expect(s.trayDiffers(0), isFalse);
      s.addToTray(2);
      expect(s.trays, [6, 6, 6]);
      s.groupsReady();
      expect(s.phase, FosPhase.take);

      // Take.
      expect(s.trayActivatable, isTrue);
      expect(s.canAddToTray, isFalse);
      expect(s.canTakeOneOut(0), isFalse);
      expect(s.canDeal, isFalse);
      expect(s.canStartAgain, isFalse);
      expect(s.canGroupsReady, isFalse);
      expect(s.canTakeConfirm, isFalse);
      s.activateTray(0);
      s.activateTray(2);
      expect(s.chosen, {0, 2});
      expect(s.canTakeConfirm, isTrue);
      s.takeConfirm();
      expect(s.phase, FosPhase.take, reason: 'G0: stay in Take');
      expect(s.takeCountNotice, 2);
      s.activateTray(2);
      expect(s.takeCountNotice, isNull);
      s.takeConfirm();
      expect(s.phase, FosPhase.reveal);

      // Reveal: nothing is interactive.
      expect(s.trayActivatable, isFalse);
      expect(s.canDeal, isFalse);
      expect(s.canTakeConfirm, isFalse);
      expect(s.canConfirm, isFalse);
      s.activateTray(1);
      expect(s.chosen, {0});

      s.next();
      expect(s.index, 1);
      expect(s.phase, FosPhase.answer);
      expect(s.value, 0);
      expect(s.chosen, isEmpty);
      expect(s.trays, List.filled(10, 0));
      expect(s.collection, 30);
    });

    test('Start again returns every counter; deal always completes', () {
      final s = FractionsOfASetSession(1)..confirm();
      expect(s.phase, FosPhase.group);
      s
        ..addToTray(3)
        ..addToTray(3)
        ..dealRound();
      s.startAgain();
      expect(s.trays.every((c) => c == 0), isTrue);
      expect(s.collection, s.item.total);
      while (s.canDeal) {
        s.dealRound();
      }
      s.groupsReady();
      expect(s.phase, FosPhase.take);
    });

    test('X, W, C and E reveal on confirm; C and E need a choice first', () {
      final s = FractionsOfASetSession(0);
      void finishTrays() {
        s.confirm();
        while (s.canDeal) {
          s.dealRound();
        }
        s.groupsReady();
        for (var k = 0; k < s.item.find!.n; k++) {
          s.toggleChosen(k);
        }
        s.takeConfirm();
        expect(s.phase, FosPhase.reveal);
        s.next();
      }

      finishTrays(); // slot 1
      finishTrays(); // slot 2
      // Slot 3, E unequal: trays shown as constructed; no tray target.
      expect(s.item.kind, FosItemKind.equalCheck);
      expect(s.trays, [3, 2, 2, 1, 2, 2, 2, 2, 2, 2]);
      expect(s.trayActivatable, isFalse);
      expect(s.canConfirm, isFalse);
      s.chooseFair(true);
      s.confirm();
      expect(s.outcome, const FosDiagnostic(FosRule.e1UnequalAccepted));
      expect(s.phase, FosPhase.reveal);
      expect([for (var k = 0; k < 10; k++) s.trayDiffers(k)].where((x) => x),
          hasLength(2));
      s.next();
      // Slot 4, W: picker 0 … d.
      expect(s.item.kind, FosItemKind.what);
      expect(s.valueMax, 3);
      for (var k = 0; k < 5; k++) {
        s.increase();
      }
      expect(s.value, 3);
      s.confirm();
      expect(s.outcome, const FosDiagnostic(FosRule.w4Whole));
      s.next();
      // Slot 5, C.
      expect(s.canConfirm, isFalse);
      s.chooseCompare(FosCompareChoice.same);
      s.confirm();
      expect(s.outcome, const FosDiagnostic(FosRule.c2Same));
      s.next();
      finishTrays(); // slot 6
      s.chooseFair(true);
      s.confirm();
      expect(s.outcome, isA<FosCorrect>());
      s.next();
      // Slot 8, X: stepper to 12.
      for (var k = 0; k < 12; k++) {
        s.increase();
      }
      s.confirm();
      expect(s.outcome, isA<FosCorrect>());
      expect(s.phase, FosPhase.reveal);
      s.next();
      expect(s.finished, isTrue);
    });
  });
}
