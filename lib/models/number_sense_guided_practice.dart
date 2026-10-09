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
/// curated example is loaded; it holds no learner data and never persists.
class NumberSenseGuidedPractice {
  NumberSenseGuidedPractice([
    NumberSenseExampleId start = NumberSenseExampleId.placeThreeEighths,
  ])  : _skill = skillOf(start),
        _current = start;

  /// The curated, ordered example bank for each skill. The comparison bank is
  /// the mixed-practice order.
  static const bank = <NumberSenseGuidedSkill, List<NumberSenseExampleId>>{
    NumberSenseGuidedSkill.placeFraction: [
      NumberSenseExampleId.placeThreeEighths,
      NumberSenseExampleId.placeOneHalf,
      NumberSenseExampleId.placeTwoThirds,
    ],
    NumberSenseGuidedSkill.makeEquivalent: [
      NumberSenseExampleId.equivalenceHalf,
      NumberSenseExampleId.equivalenceHalfFourths,
      NumberSenseExampleId.equivalenceHalfSixths,
      NumberSenseExampleId.equivalenceHalfEighths,
    ],
    NumberSenseGuidedSkill.compareFractions: [
      NumberSenseExampleId.compareTwoEighthsAndFiveEighths,
      NumberSenseExampleId.compareThreeQuartersAndThreeEighths,
      NumberSenseExampleId.compareThreeSixthsAndOneHalf,
      NumberSenseExampleId.compareFiveEighthsAndOneHalf,
      NumberSenseExampleId.compareTwoThirdsAndThreeQuarters,
    ],
    NumberSenseGuidedSkill.findOneHundredth: [
      NumberSenseExampleId.findOneHundredth,
      NumberSenseExampleId.findThreeHundredths,
      NumberSenseExampleId.findSixHundredths,
    ],
  };

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
  NumberSenseExampleId _current;

  NumberSenseGuidedSkill get skill => _skill;
  NumberSenseComparisonFocus get comparisonFocus => _focus;

  /// The example the learner is currently on.
  NumberSenseExampleId get current => _current;

  /// One-based position of the current skill, for progress labels.
  int get skillNumber => _skill.index + 1;
  int get skillCount => NumberSenseGuidedSkill.values.length;

  /// The top-level skill that a guided example belongs to.
  static NumberSenseGuidedSkill skillOf(NumberSenseExampleId id) {
    for (final entry in bank.entries) {
      if (entry.value.contains(id)) return entry.key;
    }
    throw ArgumentError.value(id, 'id', 'is not in any guided bank');
  }

  /// The examples that "Another example" cycles through for the current
  /// path: the skill's bank, or the single chosen comparison focus.
  List<NumberSenseExampleId> get activeBank {
    if (_skill == NumberSenseGuidedSkill.compareFractions) {
      final focused = _focusExample[_focus];
      if (focused != null) return [focused];
    }
    return bank[_skill]!;
  }

  /// Selects [skill] and returns its first example. Comparison starts in
  /// mixed practice.
  NumberSenseExampleId selectSkill(NumberSenseGuidedSkill skill) {
    _skill = skill;
    _focus = NumberSenseComparisonFocus.mixed;
    return _current = bank[skill]!.first;
  }

  /// Advances to the next skill, wrapping after the last, at its first
  /// example.
  NumberSenseExampleId nextSkill() => selectSkill(
        NumberSenseGuidedSkill
            .values[(_skill.index + 1) % NumberSenseGuidedSkill.values.length],
      );

  /// Selects a comparison focus and returns its example. Mixed practice
  /// starts the comparison bank from its first example.
  NumberSenseExampleId selectComparisonFocus(NumberSenseComparisonFocus focus) {
    _skill = NumberSenseGuidedSkill.compareFractions;
    _focus = focus;
    return _current = activeBank.first;
  }

  /// Restarts the exact current example.
  NumberSenseExampleId practise() => _current;

  /// The next example in the current path's bank, wrapping to its first.
  /// It never changes skill or comparison focus.
  NumberSenseExampleId anotherExample() {
    final examples = activeBank;
    final index = examples.indexOf(_current);
    return _current = examples[(index + 1) % examples.length];
  }
}
