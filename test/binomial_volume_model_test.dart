import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/binomial_volume_model.dart';
import 'package:unified_math_tutor/models/binomial_volume_session.dart';

/// Every (a, b) pair the lab offers.
final _allDimensions = [
  for (final a in BinomialDimensions.allowedA)
    for (final b in BinomialDimensions.allowedB) BinomialDimensions(a: a, b: b),
];

void main() {
  group('composition and multiplicities', () {
    test('exactly eight pieces, one per (x, y, z) choice of a / b', () {
      final blocks = BinomialVolumeModel.blocks;
      expect(blocks, hasLength(8));
      final combos = blocks.map((b) => '${b.x.name}${b.y.name}${b.z.name}');
      expect(combos.toSet(), hasLength(8));
      expect(blocks.map((b) => b.index), [0, 1, 2, 3, 4, 5, 6, 7]);
    });

    test('multiplicities are 1 a³, 3 a²b, 3 ab², 1 b³', () {
      final counts = {
        for (final t in BinomialTerm.values)
          t: BinomialVolumeModel.blocksFor(t).length,
      };
      expect(counts, {
        BinomialTerm.aCubed: 1,
        BinomialTerm.aSquaredB: 3,
        BinomialTerm.aBSquared: 3,
        BinomialTerm.bCubed: 1,
      });
      for (final t in BinomialTerm.values) {
        expect(BinomialVolumeModel.blocksFor(t).length, t.coefficient);
        expect(t.aPower + t.bPower, 3);
      }
    });

    test('each piece\'s side lengths match its term\'s factors', () {
      for (final d in _allDimensions) {
        for (final block in BinomialVolumeModel.blocks) {
          final (sx, sy, sz) = block.size(d);
          final sides = [sx, sy, sz];
          final term = block.term;
          // a-count and b-count of the actual box agree with the term.
          final aSides = block.sides.where((s) => s == BinomialSide.a).length;
          expect(aSides, term.aPower);
          expect(3 - aSides, term.bPower);
          expect(sides.fold<int>(1, (p, v) => p * v), term.volume(d));
          expect(block.volume(d), term.volume(d));
        }
      }
    });

    test('the three a²b prisms are the three orientations of a × a × b', () {
      final prisms = BinomialVolumeModel.blocksFor(BinomialTerm.aSquaredB);
      final bAxis = prisms
          .map((p) => p.sides.indexWhere((s) => s == BinomialSide.b))
          .toSet();
      expect(bAxis, {0, 1, 2});
      final abPrisms = BinomialVolumeModel.blocksFor(BinomialTerm.aBSquared);
      final aAxis = abPrisms
          .map((p) => p.sides.indexWhere((s) => s == BinomialSide.a))
          .toSet();
      expect(aAxis, {0, 1, 2});
    });

    test('assembled pieces tile the (a + b)³ cube exactly, with no overlap',
        () {
      for (final d in _allDimensions) {
        final n = d.side;
        final cover = List.filled(n * n * n, 0);
        for (final block in BinomialVolumeModel.blocks) {
          final (ox, oy, oz) = block.assembledOrigin(d);
          final (sx, sy, sz) = block.size(d);
          for (var x = ox; x < ox + sx; x++) {
            for (var y = oy; y < oy + sy; y++) {
              for (var z = oz; z < oz + sz; z++) {
                expect(x < n && y < n && z < n, isTrue);
                cover[(x * n + y) * n + z]++;
              }
            }
          }
        }
        expect(cover.every((c) => c == 1), isTrue,
            reason: 'a=${d.a} b=${d.b}: every unit cell covered exactly once');
      }
    });

    test('explosion 0 equals the assembled layout', () {
      final d = BinomialDimensions.initial;
      for (final block in BinomialVolumeModel.blocks) {
        final (ox, oy, oz) = block.assembledOrigin(d);
        expect(block.originAt(d, 0),
            (ox.toDouble(), oy.toDouble(), oz.toDouble()));
      }
    });

    test('pulling apart never makes two pieces overlap', () {
      bool overlap(
          BinomialBlock p, BinomialBlock q, BinomialDimensions d, double e) {
        final (px, py, pz) = p.originAt(d, e);
        final (qx, qy, qz) = q.originAt(d, e);
        final (psx, psy, psz) = p.size(d);
        final (qsx, qsy, qsz) = q.size(d);
        bool sep(double a0, int al, double b0, int bl) =>
            a0 + al <= b0 + 1e-9 || b0 + bl <= a0 + 1e-9;
        return !(sep(px, psx, qx, qsx) ||
            sep(py, psy, qy, qsy) ||
            sep(pz, psz, qz, qsz));
      }

      for (final d in _allDimensions) {
        for (final e in [0.0, 0.1, 0.4, 0.75, 1.0]) {
          final blocks = BinomialVolumeModel.blocks;
          for (var i = 0; i < 8; i++) {
            for (var j = i + 1; j < 8; j++) {
              expect(overlap(blocks[i], blocks[j], d, e), isFalse,
                  reason: 'a=${d.a} b=${d.b} e=$e pieces $i,$j');
            }
          }
        }
      }
    });

    test('explosion is clamped to 0–1 and reported as a whole percentage', () {
      expect(clampExplosion(-1), 0);
      expect(clampExplosion(2), 1);
      expect(clampExplosion(double.nan), 0);
      expect(explosionPercent(0.4), 40);
      expect(explosionPercent(0.333), 33);
      expect(explosionPercent(1), 100);
    });

    test('draw order is back-to-front: a³ first, b³ last', () {
      final order = BinomialVolumeModel.drawOrder;
      expect(order.first.term, BinomialTerm.aCubed);
      expect(order.last.term, BinomialTerm.bCubed);
      for (var i = 1; i < order.length; i++) {
        expect(order[i].depthKey, greaterThanOrEqualTo(order[i - 1].depthKey));
      }
    });
  });

  group('symbolic decomposition', () {
    test('the expansion is exactly a³ + 3a²b + 3ab² + b³', () {
      expect(BinomialVolumeModel.expansion, '(a + b)³ = a³ + 3a²b + 3ab² + b³');
      expect(BinomialVolumeModel.expansionTerms, 'a³ + 3a²b + 3ab² + b³');
    });

    test('term symbols and factor products', () {
      expect(
          BinomialTerm.values.map((t) => t.symbol), ['a³', 'a²b', 'ab²', 'b³']);
      expect(BinomialTerm.values.map((t) => t.factorProduct), [
        'a × a × a',
        'a × a × b',
        'a × b × b',
        'b × b × b',
      ]);
      expect(BinomialTerm.aCubed.isCube, isTrue);
      expect(BinomialTerm.bCubed.isCube, isTrue);
      expect(BinomialTerm.aSquaredB.isCube, isFalse);
      expect(BinomialTerm.aBSquared.isCube, isFalse);
    });

    test('expansion coefficients sum to the 8 pieces', () {
      expect(BinomialTerm.values.fold<int>(0, (s, t) => s + t.coefficient), 8);
    });

    test('fromPowers rejects anything outside (a + b)³', () {
      expect(() => BinomialTerm.fromPowers(4, 0), throwsArgumentError);
      expect(() => BinomialTerm.fromPowers(2, 2), throwsArgumentError);
    });
  });

  group('numeric checks', () {
    test('a = 2, b = 1 reads 3³ = 8 + 12 + 6 + 1 = 27', () {
      final check = BinomialNumericCheck(BinomialDimensions(a: 2, b: 1));
      expect(check.contributions, [8, 12, 6, 1]);
      expect(check.display, '3³ = 8 + 12 + 6 + 1 = 27');
      expect(check.substitutedSide, '(2 + 1)³');
      expect(check.holds, isTrue);
    });

    test('every offered (a, b) pair satisfies the identity', () {
      final expected = {
        (1, 1): '2³ = 1 + 3 + 3 + 1 = 8',
        (1, 2): '3³ = 1 + 6 + 12 + 8 = 27',
        (2, 1): '3³ = 8 + 12 + 6 + 1 = 27',
        (2, 2): '4³ = 8 + 24 + 24 + 8 = 64',
        (3, 1): '4³ = 27 + 27 + 9 + 1 = 64',
        (3, 2): '5³ = 27 + 54 + 36 + 8 = 125',
      };
      for (final d in _allDimensions) {
        final check = BinomialNumericCheck(d);
        expect(check.holds, isTrue);
        expect(check.termSum, d.side * d.side * d.side);
        expect(check.display, expected[(d.a, d.b)]);
        final pieceSum =
            BinomialVolumeModel.blocks.fold<int>(0, (s, b) => s + b.volume(d));
        expect(pieceSum, check.cubeVolume);
      }
    });

    test('only a ∈ {1,2,3} and b ∈ {1,2} are accepted', () {
      expect(() => BinomialDimensions(a: 0, b: 1), throwsArgumentError);
      expect(() => BinomialDimensions(a: 4, b: 1), throwsArgumentError);
      expect(() => BinomialDimensions(a: 2, b: 3), throwsArgumentError);
      expect(BinomialDimensions.initial, BinomialDimensions(a: 2, b: 1));
    });
  });

  group('session (guided steps, selection, reset)', () {
    test('steps can be opened in any order; reveal marks the sequence done',
        () {
      final s = BinomialVolumeSession();
      expect(s.step, BinomialGuidedStep.findACubed);
      s.goToStep(BinomialGuidedStep.findBCubed);
      expect(s.step, BinomialGuidedStep.findBCubed);
      expect(s.sequenceComplete, isFalse);
      s.goToStep(BinomialGuidedStep.revealExpansion);
      expect(s.sequenceComplete, isTrue);
      expect(s.currentStepFound, isTrue);
      s.goToStep(BinomialGuidedStep.findASquaredB);
      expect(s.step, BinomialGuidedStep.findASquaredB);
      expect(s.sequenceComplete, isTrue, reason: 'stays done for the visit');
    });

    test('"found" wording only while matching pieces are selected', () {
      final s = BinomialVolumeSession()..selectTerm(BinomialTerm.aCubed);
      expect(s.selectionMatchesStep, isTrue);
      s.goToStep(BinomialGuidedStep.findBCubed);
      s.goToStep(BinomialGuidedStep.findACubed); // reopen completed step
      expect(s.isFound(BinomialGuidedStep.findACubed), isTrue, reason: 'tick');
      expect(s.selected, isNull);
      expect(s.selectionMatchesStep, isFalse, reason: 'nothing outlined');
      s.selectTerm(BinomialTerm.bCubed);
      expect(s.selectionMatchesStep, isFalse);
      s.selectTerm(BinomialTerm.aCubed);
      expect(s.selectionMatchesStep, isTrue);
      s.goToStep(BinomialGuidedStep.revealExpansion);
      expect(s.selectionMatchesStep, isFalse, reason: 'reveal has no target');
    });

    test('a find-step is found only by its own term', () {
      final s = BinomialVolumeSession()
        ..goToStep(BinomialGuidedStep.findASquaredB)
        ..selectTerm(BinomialTerm.aBSquared);
      expect(s.isFound(BinomialGuidedStep.findASquaredB), isFalse);
      expect(s.selectionMissesStep, isTrue);
      s.selectTerm(BinomialTerm.aSquaredB);
      expect(s.isFound(BinomialGuidedStep.findASquaredB), isTrue);
      expect(s.selectionMissesStep, isFalse);
      expect(s.highlightedTerm, BinomialTerm.aSquaredB);
    });

    test('changing step starts it neutrally: selection cleared, no feedback',
        () {
      // Regression (Pixel UAT): a³ found in step 1, then Next step showed
      // step 2 "That piece has a different volume" before any new choice.
      final s = BinomialVolumeSession()..selectTerm(BinomialTerm.aCubed);
      expect(s.isFound(BinomialGuidedStep.findACubed), isTrue);
      s.goToStep(BinomialGuidedStep.findACubed.next!);
      expect(s.selected, isNull);
      expect(s.highlightedTerm, isNull);
      expect(s.selectionMissesStep, isFalse);
      expect(s.currentStepFound, isFalse);

      // Opening a step whose piece was selected no longer counts it either:
      // the learner must choose again, in the new step.
      s.selectTerm(BinomialTerm.bCubed);
      s.goToStep(BinomialGuidedStep.findBCubed);
      expect(s.selected, isNull);
      expect(s.isFound(BinomialGuidedStep.findBCubed), isFalse);

      // Re-opening the current step is a no-op, not a reset.
      s.selectTerm(BinomialTerm.bCubed);
      s.goToStep(BinomialGuidedStep.findBCubed);
      expect(s.selectedTerm, BinomialTerm.bCubed);
      expect(s.isFound(BinomialGuidedStep.findBCubed), isTrue);

      // Restart ("Explore again") also clears it.
      s.restart();
      expect(s.selected, isNull);
    });

    test('step order and next', () {
      expect(BinomialGuidedStep.values.map((s) => s.number), [1, 2, 3, 4, 5]);
      expect(BinomialGuidedStep.values.map((s) => s.target), [
        BinomialTerm.aCubed,
        BinomialTerm.aSquaredB,
        BinomialTerm.aBSquared,
        BinomialTerm.bCubed,
        null,
      ]);
      expect(BinomialGuidedStep.revealExpansion.next, isNull);
      expect(
          BinomialGuidedStep.findACubed.next, BinomialGuidedStep.findASquaredB);
    });

    test('cycleSelection walks all eight pieces both ways', () {
      final s = BinomialVolumeSession();
      final seen = <int>[];
      for (var i = 0; i < 8; i++) {
        s.cycleSelection();
        seen.add(s.selected!.index);
      }
      expect(seen, [0, 1, 2, 3, 4, 5, 6, 7]);
      s.cycleSelection();
      expect(s.selected!.index, 0);
      s.cycleSelection(forward: false);
      expect(s.selected!.index, 7);
    });

    test('reset view keeps dimensions and steps; restart clears everything',
        () {
      final s = BinomialVolumeSession()
        ..setDimensions(a: 3, b: 2)
        ..setExplosion(0.7)
        ..selectTerm(BinomialTerm.aCubed)
        ..goToStep(BinomialGuidedStep.revealExpansion);
      s.resetView();
      expect(s.explosion, 0);
      expect(s.selected, isNull);
      expect(s.dimensions, BinomialDimensions(a: 3, b: 2));
      expect(s.isFound(BinomialGuidedStep.findACubed), isTrue);
      expect(s.sequenceComplete, isTrue);

      s.restart();
      expect(s.dimensions, BinomialDimensions.initial);
      expect(s.found, isEmpty);
      expect(s.step, BinomialGuidedStep.findACubed);
      expect(s.sequenceComplete, isFalse);
    });

    test('changing dimensions is deterministic and keeps the selection', () {
      final s = BinomialVolumeSession()..selectTerm(BinomialTerm.aSquaredB);
      s.setDimensions(a: 3);
      expect(s.selectedTerm, BinomialTerm.aSquaredB);
      expect(s.numericCheck.display, '4³ = 27 + 27 + 9 + 1 = 64');
      s.setDimensions(a: 3); // no-op
      expect(s.numericCheck.display, '4³ = 27 + 27 + 9 + 1 = 64');
    });
  });
}
