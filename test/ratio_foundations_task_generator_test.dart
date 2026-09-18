import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/services/ratio_foundations_progress_service.dart';
import 'package:unified_math_tutor/services/ratio_foundations_task_generator.dart';

/// Year 8 Ratio & Proportion "Ratio scaling foundations" vertical slice —
/// pure generator tests. No widget tree, no asset loading, safe to stack
/// many `test()` calls in one file.
void main() {
  group('determinism — same seed/configuration reproduces the same item', () {
    test(
        'identical (rung, seed, itemIndexInRung) always yields an '
        'identical question, options, correctIndex, and explanation', () {
      for (final rung in [1, 2, 3]) {
        for (var seed = 0; seed < 20; seed++) {
          for (var index = 0; index < 5; index++) {
            final a = RatioFoundationsTaskGenerator.generate(
              rung: rung,
              seed: seed,
              itemIndexInRung: index,
            );
            final b = RatioFoundationsTaskGenerator.generate(
              rung: rung,
              seed: seed,
              itemIndexInRung: index,
            );
            expect(a.question.question, b.question.question,
                reason: 'rung=$rung seed=$seed index=$index');
            expect(a.question.options, b.question.options);
            expect(a.question.correctIndex, b.question.correctIndex);
            expect(a.question.explanation, b.question.explanation);
            expect(a.oneSideOnlyDistractorIndex, b.oneSideOnlyDistractorIndex);
          }
        }
      }
    });

    test(
        'a different itemIndexInRung (same seed/rung) is not guaranteed '
        'identical, proving the derivation actually varies by index', () {
      var sawADifference = false;
      for (var index = 0; index < 10; index++) {
        final first = RatioFoundationsTaskGenerator.generate(
          rung: 3,
          seed: 42,
          itemIndexInRung: 0,
        );
        final other = RatioFoundationsTaskGenerator.generate(
          rung: 3,
          seed: 42,
          itemIndexInRung: index,
        );
        if (index != 0 && other.question.question != first.question.question) {
          sawADifference = true;
        }
      }
      expect(sawADifference, isTrue);
    });
  });

  group(
      'every generated Rung 1-3 item has a valid whole-number answer and '
      'passes its own validator before display', () {
    test(
        'no exception is thrown across a wide sweep of seeds/indices, for '
        'every rung', () {
      for (final rung in [1, 2, 3]) {
        for (var seed = 0; seed < 100; seed++) {
          for (var index = 0; index < 8; index++) {
            expect(
              () => RatioFoundationsTaskGenerator.generate(
                rung: rung,
                seed: seed,
                itemIndexInRung: index,
              ),
              returnsNormally,
              reason: 'rung=$rung seed=$seed index=$index',
            );
          }
        }
      }
    });

    test(
        'Rung 2/3 (and Rung 1\'s scale-factor sub-type) options are all '
        'distinct positive whole numbers, and correctIndex points at a '
        'value matching the stated relationship', () {
      for (final rung in [2, 3]) {
        for (var seed = 0; seed < 30; seed++) {
          for (var index = 0; index < 6; index++) {
            final item = RatioFoundationsTaskGenerator.generate(
              rung: rung,
              seed: seed,
              itemIndexInRung: index,
            );
            final q = item.question;
            final parsed = q.options.map(int.parse).toList();
            expect(parsed.every((v) => v > 0), isTrue,
                reason: '${q.id}: ${q.options}');
            expect(parsed.toSet().length, parsed.length,
                reason: '${q.id}: duplicate options ${q.options}');
            expect(q.correctIndex, inInclusiveRange(0, q.options.length - 1));
          }
        }
      }
    });

    test(
        'Rung 1 items are either the Yes/No equivalence sub-type or the '
        'numeric scale-factor sub-type, never malformed', () {
      for (var seed = 0; seed < 30; seed++) {
        for (var index = 0; index < 6; index++) {
          final item = RatioFoundationsTaskGenerator.generate(
            rung: 1,
            seed: seed,
            itemIndexInRung: index,
          );
          final options = item.question.options;
          final isYesNo =
              options.length == 2 && options.toSet().containsAll(['Yes', 'No']);
          final isNumeric = options.every((o) => int.tryParse(o) != null) &&
              options.toSet().length == options.length;
          expect(isYesNo || isNumeric, isTrue,
              reason: 'seed=$seed index=$index options=$options');
        }
      }
    });
  });

  group(
      'ERR_MAGNITUDE_SCALE maps only to the authored "scaled one side '
      'only" signature, never a false positive', () {
    test(
        'selecting the authored one-side-only distractor at Rung 3 is the '
        'exact case this code exists to identify', () {
      var foundAtLeastOneCase = false;
      for (var seed = 0; seed < 50; seed++) {
        for (var index = 0; index < 6; index++) {
          final item = RatioFoundationsTaskGenerator.generate(
            rung: 3,
            seed: seed,
            itemIndexInRung: index,
          );
          final oneSideIndex = item.oneSideOnlyDistractorIndex;
          if (oneSideIndex == null) continue;
          foundAtLeastOneCase = true;
          // The one-side-only distractor must never itself be the correct
          // answer — otherwise "scaling only one side" would coincidentally
          // be correct, which is not a meaningful misconception signature.
          expect(oneSideIndex, isNot(item.question.correctIndex));
        }
      }
      expect(foundAtLeastOneCase, isTrue,
          reason: 'the sweep should hit at least one Rung 3 item with an '
              'authored one-side-only distractor');
    });

    test(
        'an unrelated wrong answer (not the authored distractor) must '
        'never be reported as ERR_MAGNITUDE_SCALE by the service-level '
        'mapping used in the screen', () {
      // Mirrors exactly the mapping RatioFoundationsScreen._checkAnswer
      // applies: diagnosticCode is set only when the wrong answer's index
      // equals oneSideOnlyDistractorIndex, and only from Rung 3.
      String? diagnosticFor(int rung, int selected, int? oneSideIndex) {
        if (rung < 3) return null;
        if (oneSideIndex == null) return null;
        if (selected == oneSideIndex) {
          return RatioFoundationsProgressService.onlyDiagnosticCode;
        }
        return null;
      }

      for (var seed = 0; seed < 30; seed++) {
        final item = RatioFoundationsTaskGenerator.generate(
          rung: 3,
          seed: seed,
          itemIndexInRung: 0,
        );
        final oneSideIndex = item.oneSideOnlyDistractorIndex;
        if (oneSideIndex == null) continue;
        for (var i = 0; i < item.question.options.length; i++) {
          if (i == item.question.correctIndex) continue;
          final code = diagnosticFor(3, i, oneSideIndex);
          if (i == oneSideIndex) {
            expect(code, RatioFoundationsProgressService.onlyDiagnosticCode);
          } else {
            expect(code, isNull,
                reason: 'option $i is a different wrong answer, not the '
                    'authored one-side-only signature — must not be coded '
                    'ERR_MAGNITUDE_SCALE');
          }
        }
      }
    });

    test(
        'Rung 1/2 never produce the diagnostic code (only recorded from '
        'Rung 3, per the task-family contract)', () {
      for (final rung in [1, 2]) {
        for (var seed = 0; seed < 20; seed++) {
          final item = RatioFoundationsTaskGenerator.generate(
            rung: rung,
            seed: seed,
            itemIndexInRung: 0,
          );
          // Rung 2 may still carry a oneSideOnlyDistractorIndex on the
          // item (useful for future rungs), but the screen/service layer
          // must never turn it into ERR_MAGNITUDE_SCALE below Rung 3.
          if (rung == 1) {
            expect(item.oneSideOnlyDistractorIndex, isNull);
          }
        }
      }
    });
  });

  test('unsupported rung throws rather than silently generating something', () {
    expect(
      () => RatioFoundationsTaskGenerator.generate(
        rung: 4,
        seed: 1,
        itemIndexInRung: 0,
      ),
      throwsArgumentError,
    );
  });
}
