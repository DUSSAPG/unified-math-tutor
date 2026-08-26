import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/core/practice_topic_mapping.dart';

void main() {
  group('canonicalTopicForRawValue — per-stage explicit mapping', () {
    test('KS2: fractions_of_amount maps to fractions', () {
      expect(
        canonicalTopicForRawValue(
          stage: 'KS2',
          rawStrandOrSkillGroup: 'fractions_of_amount',
        ),
        'fractions',
      );
    });

    test(
        'KS2: addition_subtraction/multiplication_division are '
        'intentionally unmapped, not guessed onto a nearby topic', () {
      expect(
        canonicalTopicForRawValue(
          stage: 'KS2',
          rawStrandOrSkillGroup: 'addition_subtraction',
        ),
        isNull,
      );
      expect(
        canonicalTopicForRawValue(
          stage: 'KS2',
          rawStrandOrSkillGroup: 'multiplication_division',
        ),
        isNull,
      );
    });

    test('KS3: ratio_proportion, algebra family, and number map correctly', () {
      expect(
        canonicalTopicForRawValue(
          stage: 'KS3',
          rawStrandOrSkillGroup: 'ratio_proportion',
        ),
        'ratio_proportion',
      );
      expect(
        canonicalTopicForRawValue(
          stage: 'KS3',
          rawStrandOrSkillGroup: 'linear_equations_basic',
        ),
        'algebra',
      );
      expect(
        canonicalTopicForRawValue(
          stage: 'KS3',
          rawStrandOrSkillGroup: 'algebra_simplify_substitute',
        ),
        'algebra',
      );
      expect(
        canonicalTopicForRawValue(
          stage: 'KS3',
          rawStrandOrSkillGroup: 'sequences_linear',
        ),
        'algebra',
      );
      expect(
        canonicalTopicForRawValue(
          stage: 'KS3',
          rawStrandOrSkillGroup: 'integers_directed_numbers',
        ),
        'number_place_value',
      );
    });

    test(
        'KS3: the fused fractions_decimals_percent bucket is '
        'intentionally unmapped (no finer structured field to split it)', () {
      expect(
        canonicalTopicForRawValue(
          stage: 'KS3',
          rawStrandOrSkillGroup: 'fractions_decimals_percent',
        ),
        isNull,
      );
    });

    test('KS4: strand-level mapping for the five strands', () {
      expect(
        canonicalTopicForRawValue(
            stage: 'KS4', rawStrandOrSkillGroup: 'Number'),
        'number_place_value',
      );
      expect(
        canonicalTopicForRawValue(
            stage: 'KS4', rawStrandOrSkillGroup: 'Algebra'),
        'algebra',
      );
      expect(
        canonicalTopicForRawValue(
            stage: 'KS4', rawStrandOrSkillGroup: 'Geometry_Measures'),
        'geometry_measures',
      );
      expect(
        canonicalTopicForRawValue(
            stage: 'KS4', rawStrandOrSkillGroup: 'Statistics_Probability'),
        'statistics_probability',
      );
      expect(
        canonicalTopicForRawValue(
            stage: 'KS4', rawStrandOrSkillGroup: 'Ratio_Proportion'),
        'ratio_proportion',
      );
    });

    test(
        'KS4: fine-skill override recovers fractions/percentages hidden '
        'inside the generic Number strand', () {
      expect(
        canonicalTopicForRawValue(
          stage: 'KS4',
          rawStrandOrSkillGroup: 'Number',
          rawFineSkill: 'Fractions of a quantity',
        ),
        'fractions',
      );
      expect(
        canonicalTopicForRawValue(
          stage: 'KS4',
          rawStrandOrSkillGroup: 'Number',
          rawFineSkill: 'Fractions add/subtract',
        ),
        'fractions',
      );
      expect(
        canonicalTopicForRawValue(
          stage: 'KS4',
          rawStrandOrSkillGroup: 'Number',
          rawFineSkill: 'Fractions multiply/divide',
        ),
        'fractions',
      );
      expect(
        canonicalTopicForRawValue(
          stage: 'KS4',
          rawStrandOrSkillGroup: 'Number',
          rawFineSkill: 'Percent of an amount',
        ),
        'percentages',
      );
      expect(
        canonicalTopicForRawValue(
          stage: 'KS4',
          rawStrandOrSkillGroup: 'Number',
          rawFineSkill: 'Percentage change',
        ),
        'percentages',
      );
    });

    test(
        'KS4: a Number-strand skill with no override still falls back to '
        'the strand mapping', () {
      expect(
        canonicalTopicForRawValue(
          stage: 'KS4',
          rawStrandOrSkillGroup: 'Number',
          rawFineSkill: 'Rounding (sig figs)',
        ),
        'number_place_value',
      );
    });

    test(
        'KS5: Calculus and Pure_Calculus unify to the same canonical '
        'topic despite inconsistent source naming', () {
      expect(
        canonicalTopicForRawValue(
            stage: 'KS5', rawStrandOrSkillGroup: 'Calculus'),
        'calculus',
      );
      expect(
        canonicalTopicForRawValue(
            stage: 'KS5', rawStrandOrSkillGroup: 'Pure_Calculus'),
        'calculus',
      );
    });

    test('KS5: Statistics maps to statistics_probability', () {
      expect(
        canonicalTopicForRawValue(
            stage: 'KS5', rawStrandOrSkillGroup: 'Statistics'),
        'statistics_probability',
      );
    });

    test(
        'KS5: Mechanics is intentionally unmapped — no matching UI topic '
        'exists, and it must not be forced into geometry_measures or '
        'calculus', () {
      expect(
        canonicalTopicForRawValue(
            stage: 'KS5', rawStrandOrSkillGroup: 'Mechanics'),
        isNull,
      );
    });

    test(
        'KS5: the fused Pure_Algebra_Trig strand resolves via its exact, '
        'enumerated fine-skill values — all three are trigonometry, none '
        'are algebra', () {
      for (final skill in [
        'Trig identities & rearranging',
        'Solve trig equations',
        'Radians + arc length/sector area',
      ]) {
        expect(
          canonicalTopicForRawValue(
            stage: 'KS5',
            rawStrandOrSkillGroup: 'Pure_Algebra_Trig',
            rawFineSkill: skill,
          ),
          'trigonometry',
          reason: 'skill "$skill" should resolve to trigonometry',
        );
      }
    });

    test(
        'KS5: Pure_Algebra_Trig with an unrecognised fine skill (no '
        'enumerated match) is unmapped, not guessed', () {
      expect(
        canonicalTopicForRawValue(
          stage: 'KS5',
          rawStrandOrSkillGroup: 'Pure_Algebra_Trig',
          rawFineSkill: 'Some future skill not yet reviewed',
        ),
        isNull,
      );
    });

    test(
        'a raw value valid at one stage does not leak into another stage '
        'just because the string looks similar', () {
      // KS3's own 'ratio_proportion' raw value is a real, exact match at
      // KS3 — but KS2 has no raw value with that name at all, and must not
      // inherit KS3's mapping.
      expect(
        canonicalTopicForRawValue(
          stage: 'KS2',
          rawStrandOrSkillGroup: 'ratio_proportion',
        ),
        isNull,
      );
    });

    test('an unknown stage never matches anything', () {
      expect(
        canonicalTopicForRawValue(
          stage: 'KS1',
          rawStrandOrSkillGroup: 'anything',
        ),
        isNull,
      );
    });
  });

  group('groupingFieldFor', () {
    test('KS2/KS3 group by skill; KS4/KS5 group by strand', () {
      expect(groupingFieldFor('KS2'), 'skill');
      expect(groupingFieldFor('KS3'), 'skill');
      expect(groupingFieldFor('KS4'), 'strand');
      expect(groupingFieldFor('KS5'), 'strand');
    });
  });

  test(
      'canonicalTopicIds matches the existing 11-topic UI catalogue — '
      'D2 does not introduce new learner-facing categories', () {
    expect(canonicalTopicIds, hasLength(11));
    expect(canonicalTopicIds, contains('fractions'));
    expect(canonicalTopicIds, contains('mixed_review'));
    expect(canonicalTopicIds, isNot(contains('mechanics')));
    expect(canonicalTopicIds, isNot(contains('operations')));
  });
}
