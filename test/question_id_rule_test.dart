import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/core/question_id_rule.dart';

void main() {
  group('isValidQuestionId', () {
    test('accepts every id shape already shipped in the product', () {
      expect(isValidQuestionId('ks2_fractions_of_amount_011efdb103'), isTrue);
      expect(isValidQuestionId('ks4_linear_solve_0'), isTrue);
      expect(isValidQuestionId('bc-001'), isTrue);
      expect(isValidQuestionId('clc_1787467492650501'), isTrue);
      expect(
          isValidQuestionId('ks4_gen_fractions_add_subtract_99a3f8dd'), isTrue);
    });

    test('rejects null, empty, and whitespace-only', () {
      expect(isValidQuestionId(null), isFalse);
      expect(isValidQuestionId(''), isFalse);
      expect(isValidQuestionId('  '), isFalse);
    });

    test('rejects ids shorter than 3 characters', () {
      expect(isValidQuestionId('ab'), isFalse);
    });

    test('rejects ids containing spaces or other unsafe characters', () {
      expect(isValidQuestionId('has space'), isFalse);
      expect(isValidQuestionId('has/slash'), isFalse);
      expect(isValidQuestionId('has.dot'), isFalse);
    });
  });

  group('generateDeterministicId', () {
    String gen({required int line, required String stem}) =>
        generateDeterministicId(
          stagePrefix: 'ks4',
          skillSlug: 'Fractions add/subtract',
          sourceLineNumber: line,
          stemText: stem,
          options: const ['a', 'b'],
          answerIndex: 0,
        );

    test('is deterministic — same inputs always produce the same id', () {
      final first = gen(line: 100, stem: 'Compute 1/2 + 1/3');
      final second = gen(line: 100, stem: 'Compute 1/2 + 1/3');
      expect(first, equals(second));
    });

    test('produces a valid id under its own validator', () {
      expect(isValidQuestionId(gen(line: 1, stem: 'x')), isTrue);
    });

    test('includes the stage prefix and a human-readable skill slug', () {
      final id = gen(line: 1, stem: 'x');
      expect(id, startsWith('ks4_gen_fractions_add_subtract_'));
    });

    test(
        'two rows with byte-identical content but different line numbers '
        'get different ids — the real, confirmed duplicate-content case in '
        'this dataset', () {
      final a = gen(line: 205, stem: 'Expand and simplify: (x +0)(x +0)');
      final b = gen(line: 1271, stem: 'Expand and simplify: (x +0)(x +0)');
      expect(a, isNot(equals(b)));
    });

    test('a wording change alone (same line) changes the generated id', () {
      // Documents that generation-time wording is part of the hash input —
      // NOT that a stored id ever gets recomputed later. Once written into
      // a pack file, an id is frozen; nothing re-derives it from wording at
      // load time. This test is about the generator function in isolation.
      final a = gen(line: 1, stem: 'Compute 1/2 + 1/3');
      final b = gen(line: 1, stem: 'Compute 1/2 + 1/4');
      expect(a, isNot(equals(b)));
    });

    test('slugifies a messy skill name into a safe, readable component', () {
      final id = generateDeterministicId(
        stagePrefix: 'ks4',
        skillSlug: 'Rearrange Formulae!! (advanced)',
        sourceLineNumber: 1,
        stemText: 'x',
        options: const ['a', 'b'],
        answerIndex: 0,
      );
      expect(id, matches(RegExp(r'^ks4_gen_rearrange_formulae_advanced_')));
    });
  });
}
