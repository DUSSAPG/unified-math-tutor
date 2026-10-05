import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/core/question_id_rule.dart';
import 'package:unified_math_tutor/models/exact_fraction.dart';
import 'package:unified_math_tutor/models/number_sense_example.dart';
import 'package:unified_math_tutor/models/number_sense_transfer.dart';

void main() {
  group('IDs', () {
    test('all ten IDs pass the canonical question-id validator', () {
      for (final item in numberSenseTransferItems) {
        expect(isValidQuestionId(item.id), isTrue, reason: item.id);
      }
    });

    test('all ten IDs are unique', () {
      final ids = numberSenseTransferItems.map((item) => item.id).toList();
      expect(ids.toSet(), hasLength(ids.length));
      expect(ids, hasLength(10));
    });

    test('the IDs are the stable published set, in order', () {
      expect(numberSenseTransferItems.map((item) => item.id).toList(), [
        'nsl-v1-eq-01',
        'nsl-v1-eq-02',
        'nsl-v1-eq-03',
        'nsl-v1-eq-04',
        'nsl-v1-pl-01',
        'nsl-v1-pl-02',
        'nsl-v1-pl-03',
        'nsl-v1-cmp-01',
        'nsl-v1-cmp-02',
        'nsl-v1-cmp-03',
      ]);
    });

    test('an item rejects an ID the canonical validator refuses', () {
      expect(
        () => PlacementTransferItem.derive(
          id: 'bad id!',
          target: ExactFraction(1, 2),
          partitionDenominator: 2,
        ),
        throwsArgumentError,
      );
      expect(
        () => ComparisonTransferItem.derive(
          id: '',
          left: ExactFraction(1, 2),
          right: ExactFraction(1, 3),
        ),
        throwsArgumentError,
      );
    });
  });

  group('split', () {
    test('exactly 4 equivalence, 3 placement and 3 comparison items', () {
      int countOf<T extends NumberSenseTransferItem>() =>
          numberSenseTransferItems.whereType<T>().length;
      expect(countOf<EquivalenceTransferItem>(), 4);
      expect(countOf<PlacementTransferItem>(), 3);
      expect(countOf<ComparisonTransferItem>(), 3);
      expect(numberSenseTransferItems, hasLength(10));
    });

    test('every item is one of the three sealed types', () {
      for (final item in numberSenseTransferItems) {
        final kind = switch (item) {
          EquivalenceTransferItem() => 'equivalence',
          PlacementTransferItem() => 'placement',
          ComparisonTransferItem() => 'comparison',
        };
        expect(kind, isNotEmpty, reason: item.id);
      }
    });
  });

  group('denominator policy', () {
    test('every presented denominator is in {2, 3, 4, 6, 8}', () {
      for (final item in numberSenseTransferItems) {
        final denominators = switch (item) {
          EquivalenceTransferItem() => [
              item.answerDenominator,
              item.source.denominator,
            ],
          PlacementTransferItem() => [
              item.partitionDenominator,
              item.target.denominator,
            ],
          ComparisonTransferItem() => [
              item.left.denominator,
              item.right.denominator,
            ],
        };
        for (final d in denominators) {
          expect(numberSenseV1Denominators.contains(d), isTrue,
              reason: '${item.id} uses denominator $d');
        }
      }
    });

    test('the presented denominators span the policy set', () {
      final used = <int>{
        for (final item in numberSenseTransferItems)
          ...switch (item) {
            EquivalenceTransferItem() => [
                item.answerDenominator,
                item.source.denominator,
              ],
            PlacementTransferItem() => [item.partitionDenominator],
            ComparisonTransferItem() => [
                item.left.denominator,
                item.right.denominator,
              ],
          },
      };
      expect(used, containsAll([2, 3, 4, 6, 8]));
    });
  });

  group('equivalence answers are derived exactly', () {
    test('each expected answer equals its source fraction', () {
      for (final item
          in numberSenseTransferItems.whereType<EquivalenceTransferItem>()) {
        expect(item.expected, item.source, reason: item.id);
      }
    });

    test(
        'the expected numerator is the source scaled to the answer denominator',
        () {
      final eq01 = _equivalence('nsl-v1-eq-01');
      expect(eq01.expectedNumerator, 3); // 1/2 over sixths is 3/6
      expect(eq01.expected.toString(), '1/2');
      expect(_equivalence('nsl-v1-eq-02').expectedNumerator, 4); // 2/3 -> 4/6
      expect(_equivalence('nsl-v1-eq-03').expectedNumerator, 6); // 3/4 -> 6/8
      expect(_equivalence('nsl-v1-eq-04').expectedNumerator, 2); // 1/4 -> 2/8
    });

    test('every distractor is over the answer denominator and not equivalent',
        () {
      for (final item
          in numberSenseTransferItems.whereType<EquivalenceTransferItem>()) {
        expect(item.distractorNumerators, isNotEmpty, reason: item.id);
        for (final n in item.distractorNumerators) {
          final distractor = ExactFraction(n, item.answerDenominator);
          expect(distractor == item.source, isFalse,
              reason: '${item.id}: $distractor');
          expect(distractor.compareTo(item.source) == 0, isFalse,
              reason: '${item.id}: $distractor');
        }
      }
    });

    test('a derived equivalence is accepted for a valid representation', () {
      final item = EquivalenceTransferItem.derive(
        id: 'nsl-v1-eq-99',
        source: ExactFraction(2, 4),
        answerDenominator: 8,
        distractorNumerators: [1, 3],
      );
      expect(item.expectedNumerator, 4);
      expect(item.expected, ExactFraction(1, 2));
    });
  });

  group('impossible equivalence construction is rejected', () {
    test('1/3 cannot be expressed in fourths', () {
      expect(
        () => EquivalenceTransferItem.derive(
          id: 'nsl-v1-eq-bad',
          source: ExactFraction(1, 3),
          answerDenominator: 4,
          distractorNumerators: [1, 2],
        ),
        throwsArgumentError,
      );
    });

    test('2/3 cannot be expressed in fourths', () {
      expect(
        () => EquivalenceTransferItem.derive(
          id: 'nsl-v1-eq-bad',
          source: ExactFraction(2, 3),
          answerDenominator: 4,
          distractorNumerators: [1],
        ),
        throwsArgumentError,
      );
    });

    test('1/4 cannot be expressed in sixths', () {
      expect(
        () => EquivalenceTransferItem.derive(
          id: 'nsl-v1-eq-bad',
          source: ExactFraction(1, 4),
          answerDenominator: 6,
          distractorNumerators: [1],
        ),
        throwsArgumentError,
      );
    });

    test('an answer denominator outside the policy is rejected', () {
      expect(
        () => EquivalenceTransferItem.derive(
          id: 'nsl-v1-eq-bad',
          source: ExactFraction(1, 2),
          answerDenominator: 5,
          distractorNumerators: [1],
        ),
        throwsArgumentError,
      );
    });

    test('a distractor equivalent to the source is rejected', () {
      expect(
        () => EquivalenceTransferItem.derive(
          id: 'nsl-v1-eq-bad',
          source: ExactFraction(1, 2),
          answerDenominator: 6,
          distractorNumerators: [3],
        ),
        throwsArgumentError,
      );
    });
  });

  group('placement targets are exact', () {
    test('each placement target is stored exactly as given', () {
      expect(_placement('nsl-v1-pl-01').target, ExactFraction(3, 8));
      expect(_placement('nsl-v1-pl-02').target, ExactFraction(5, 6));
      expect(_placement('nsl-v1-pl-03').target, ExactFraction(1, 4));
    });

    test('the partition numerator is the exact count on the partition', () {
      expect(_placement('nsl-v1-pl-01').partitionNumerator, 3); // 3 of 8
      expect(_placement('nsl-v1-pl-02').partitionNumerator, 5); // 5 of 6
      expect(_placement('nsl-v1-pl-03').partitionNumerator, 2); // 2 of 8
    });

    test('a target that cannot sit on the partition is rejected', () {
      expect(
        () => PlacementTransferItem.derive(
          id: 'nsl-v1-pl-bad',
          target: ExactFraction(1, 3),
          partitionDenominator: 4,
        ),
        throwsArgumentError,
      );
    });

    test('a partition outside the policy is rejected', () {
      expect(
        () => PlacementTransferItem.derive(
          id: 'nsl-v1-pl-bad',
          target: ExactFraction(1, 2),
          partitionDenominator: 10,
        ),
        throwsArgumentError,
      );
    });
  });

  group('comparisons agree with ExactFraction.compareTo', () {
    test('every expected result matches compareTo in sign', () {
      for (final item
          in numberSenseTransferItems.whereType<ComparisonTransferItem>()) {
        final order = item.left.compareTo(item.right);
        final expectedOrder = switch (item.expected) {
          NumberSenseComparison.lessThan => -1,
          NumberSenseComparison.equal => 0,
          NumberSenseComparison.greaterThan => 1,
        };
        expect(order.sign, expectedOrder, reason: item.id);
      }
    });

    test('2/3 is less than 3/4, so cmp-01 expects lessThan', () {
      final item = _comparison('nsl-v1-cmp-01');
      expect(item.left, ExactFraction(2, 3));
      expect(item.right, ExactFraction(3, 4));
      expect(item.expected, NumberSenseComparison.lessThan);
    });

    test('5/8 is greater than 1/2, and 3/6 equals 1/2', () {
      expect(_comparison('nsl-v1-cmp-02').expected,
          NumberSenseComparison.greaterThan);
      expect(
          _comparison('nsl-v1-cmp-03').expected, NumberSenseComparison.equal);
    });

    test('the derived expectation matches compareExactFractions directly', () {
      for (final item
          in numberSenseTransferItems.whereType<ComparisonTransferItem>()) {
        expect(
          compareExactFractions(item.left, item.right),
          item.expected,
          reason: item.id,
        );
      }
    });
  });

  group('public API uses no doubles', () {
    test('the model source declares no double type or literal', () {
      final source =
          File('lib/models/number_sense_transfer.dart').readAsStringSync();
      expect(RegExp(r'\bdouble\b').hasMatch(source), isFalse);
      expect(RegExp(r'\b\d+\.\d+\b').hasMatch(source), isFalse);
    });

    test('every public value has an integer or exact-fraction type', () {
      for (final item in numberSenseTransferItems) {
        expect(item.id, isA<String>());
        switch (item) {
          case EquivalenceTransferItem():
            expect(item.source, isA<ExactFraction>());
            expect(item.answerDenominator, isA<int>());
            expect(item.expectedNumerator, isA<int>());
            expect(item.expected, isA<ExactFraction>());
            for (final n in item.distractorNumerators) {
              expect(n, isA<int>());
            }
          case PlacementTransferItem():
            expect(item.target, isA<ExactFraction>());
            expect(item.partitionDenominator, isA<int>());
            expect(item.partitionNumerator, isA<int>());
          case ComparisonTransferItem():
            expect(item.left, isA<ExactFraction>());
            expect(item.right, isA<ExactFraction>());
            expect(item.expected, isA<NumberSenseComparison>());
        }
      }
    });
  });

  group('the list is stable and immutable', () {
    test('the same ordered list is returned on every access', () {
      final first = numberSenseTransferItems.map((i) => i.id).toList();
      final second = numberSenseTransferItems.map((i) => i.id).toList();
      expect(second, first);
      expect(identical(numberSenseTransferItems, numberSenseTransferItems),
          isTrue);
    });

    test('the top-level list cannot be grown, shrunk or reordered', () {
      expect(() => numberSenseTransferItems.add(_comparison('nsl-v1-cmp-01')),
          throwsUnsupportedError);
      expect(
          () => numberSenseTransferItems.removeLast(), throwsUnsupportedError);
      expect(() => numberSenseTransferItems.sort(), throwsUnsupportedError);
    });

    test('distractor lists cannot be changed after construction', () {
      final item = _equivalence('nsl-v1-eq-01');
      expect(() => item.distractorNumerators.add(0), throwsUnsupportedError);
    });
  });
}

EquivalenceTransferItem _equivalence(String id) => numberSenseTransferItems
    .whereType<EquivalenceTransferItem>()
    .firstWhere((item) => item.id == id);

PlacementTransferItem _placement(String id) => numberSenseTransferItems
    .whereType<PlacementTransferItem>()
    .firstWhere((item) => item.id == id);

ComparisonTransferItem _comparison(String id) => numberSenseTransferItems
    .whereType<ComparisonTransferItem>()
    .firstWhere((item) => item.id == id);
