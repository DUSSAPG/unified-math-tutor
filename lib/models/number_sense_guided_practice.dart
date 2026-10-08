import 'number_sense_example.dart';

/// The top-level Guided skills, in teaching order.
enum NumberSenseGuidedSkill {
  placeFraction,
  makeEquivalent,
  compareFractions,
  findOneHundredth,
}

/// The optional comparison focus within [NumberSenseGuidedSkill.compareFractions].
enum NumberSenseComparisonFocus {
  sameDenominator,
  sameNumerator,
  equivalentFractions,
  compareToHalf,
  mixed,
}

/// In-memory, deterministic Guided practice path. It only chooses which
/// existing example is loaded; it holds no learner data and never persists.
class NumberSenseGuidedPractice {
  NumberSenseGuidedPractice([
    NumberSenseExampleId start = NumberSenseExampleId.placeThreeEighths,
  ]) : _skill = skillOf(start);

  static const _comparisonOrder = [
    NumberSenseExampleId.compareTwoEighthsAndFiveEighths,
    NumberSenseExampleId.compareThreeQuartersAndThreeEighths,
    NumberSenseExampleId.compareThreeSixthsAndOneHalf,
    NumberSenseExampleId.compareFiveEighthsAndOneHalf,
    NumberSenseExampleId.compareTwoThirdsAndThreeQuarters,
  ];

  static const _focusExample = {
    NumberSenseComparisonFocus.sameDenominator:
        NumberSenseExampleId.compareTwoEighthsAndFiveEighths,
    NumberSenseComparisonFocus.sameNumerator:
        NumberSenseExampleId.compareThreeQuartersAndThreeEighths,
    NumberSenseComparisonFocus.equivalentFractions:
        NumberSenseExampleId.compareThreeSixthsAndOneHalf,
    NumberSenseComparisonFocus.compareToHalf:
        NumberSenseExampleId.compareFiveEighthsAndOneHalf,
  };

  NumberSenseGuidedSkill _skill;
  NumberSenseComparisonFocus _focus = NumberSenseComparisonFocus.mixed;

  NumberSenseGuidedSkill get skill => _skill;
  NumberSenseComparisonFocus get comparisonFocus => _focus;

  /// One-based position of the current skill, for progress labels.
  int get skillNumber => _skill.index + 1;
  int get skillCount => NumberSenseGuidedSkill.values.length;

  /// The top-level skill that a guided example belongs to.
  static NumberSenseGuidedSkill skillOf(NumberSenseExampleId id) =>
      switch (id) {
        NumberSenseExampleId.placeThreeEighths =>
          NumberSenseGuidedSkill.placeFraction,
        NumberSenseExampleId.equivalenceHalf =>
          NumberSenseGuidedSkill.makeEquivalent,
        NumberSenseExampleId.findOneHundredth =>
          NumberSenseGuidedSkill.findOneHundredth,
        _ => NumberSenseGuidedSkill.compareFractions,
      };

  /// Keeps the path in step when the example changed elsewhere, such as
  /// through a direct example load.
  void syncTo(NumberSenseExampleId id) {
    final skill = skillOf(id);
    if (skill != _skill) _focus = NumberSenseComparisonFocus.mixed;
    _skill = skill;
    if (skill == NumberSenseGuidedSkill.compareFractions &&
        _focus != NumberSenseComparisonFocus.mixed &&
        _focusExample[_focus] != id) {
      _focus = NumberSenseComparisonFocus.mixed;
    }
  }

  /// Selects [skill] and returns its first example. Comparison starts in
  /// mixed practice.
  NumberSenseExampleId selectSkill(NumberSenseGuidedSkill skill) {
    _skill = skill;
    _focus = NumberSenseComparisonFocus.mixed;
    return _firstExample(skill);
  }

  /// Advances to the next skill, wrapping after the last.
  NumberSenseExampleId nextSkill() => selectSkill(
        NumberSenseGuidedSkill
            .values[(_skill.index + 1) % NumberSenseGuidedSkill.values.length],
      );

  /// Selects a comparison focus and returns its example.
  NumberSenseExampleId selectComparisonFocus(NumberSenseComparisonFocus focus) {
    _skill = NumberSenseGuidedSkill.compareFractions;
    _focus = focus;
    return _focusExample[focus] ?? _comparisonOrder.first;
  }

  /// A fresh deterministic example within the current skill. Single-example
  /// skills and focused comparisons restart; mixed comparison practice moves
  /// to the next comparison in order.
  NumberSenseExampleId practise(NumberSenseExampleId current) {
    if (_skill == NumberSenseGuidedSkill.compareFractions) {
      final focused = _focusExample[_focus];
      if (focused != null) return focused;
      final index = _comparisonOrder.indexOf(current);
      return _comparisonOrder[(index + 1) % _comparisonOrder.length];
    }
    return _firstExample(_skill);
  }

  static NumberSenseExampleId _firstExample(NumberSenseGuidedSkill skill) =>
      switch (skill) {
        NumberSenseGuidedSkill.placeFraction =>
          NumberSenseExampleId.placeThreeEighths,
        NumberSenseGuidedSkill.makeEquivalent =>
          NumberSenseExampleId.equivalenceHalf,
        NumberSenseGuidedSkill.compareFractions => _comparisonOrder.first,
        NumberSenseGuidedSkill.findOneHundredth =>
          NumberSenseExampleId.findOneHundredth,
      };
}
