import '../services/number_sense_geometry.dart';
import 'exact_fraction.dart';
import 'number_sense_example.dart';

/// Whether the learner is following a guided example or exploring freely.
enum NumberSenseMode { guided, freeExplore }

/// Immutable Number Sense state. Every transition returns a new state; the
/// original is never changed.
///
/// The partition is the source of truth: [denominator] equal parts, of
/// which [shadedParts] are shaded. The value is derived from them, so 2 of 4
/// keeps its partition (two fourths) while its value is `1/2`.
///
/// Stores integers and enums only. No doubles. Pointer doubles are converted
/// by [NumberSenseGeometry] inside a single transition and never kept.
class NumberSenseState {
  const NumberSenseState._({
    required this.mode,
    required this.denominator,
    required this.shadedParts,
    required this.activeExample,
    required this.comparisonAnswer,
    required this.usesPrecisionLine,
    required this.precisionHundredths,
    required this.precisionLineTouched,
    required this.wholePartModelTouched,
  });

  /// Guided mode at the starting state of [id] (the first example by default).
  factory NumberSenseState.guided([
    NumberSenseExampleId id = NumberSenseExampleId.equivalenceHalf,
  ]) =>
      _startOf(NumberSenseExample.of(id));

  /// Free Explore on [denominator] (a V1 denominator), with nothing shaded.
  factory NumberSenseState.freeExplore({int denominator = 2}) {
    _requireV1Denominator(denominator);
    return NumberSenseState._(
      mode: NumberSenseMode.freeExplore,
      denominator: denominator,
      shadedParts: 0,
      activeExample: null,
      comparisonAnswer: null,
      usesPrecisionLine: false,
      precisionHundredths: 0,
      precisionLineTouched: false,
      wholePartModelTouched: false,
    );
  }

  final NumberSenseMode mode;

  /// The selected partition: the number of equal parts. A V1 denominator.
  final int denominator;

  /// Shaded parts within the partition, from `0` through [denominator].
  final int shadedParts;

  /// The guided example in progress, or `null` in Free Explore.
  final NumberSenseExampleId? activeExample;

  /// The learner's stated comparison, for a comparison example.
  final NumberSenseComparison? comparisonAnswer;

  /// Whether the precision line is selected instead of the whole-part model.
  final bool usesPrecisionLine;

  /// Selected tick on the zoomed line, in hundredths from 0 through 10.
  final int precisionHundredths;

  /// Whether a learner has interacted with the precision line in this state.
  final bool precisionLineTouched;

  /// Whether a learner has changed the guided whole-part model.
  final bool wholePartModelTouched;

  /// The canonical exact value from the selected model.
  ExactFraction get value => usesPrecisionLine
      ? ExactFraction(precisionHundredths, 100)
      : ExactFraction(shadedParts, denominator);

  bool get canIncrement => shadedParts < denominator;

  bool get canDecrement => shadedParts > 0;

  /// Whether the guided example is complete, decided by exact state only.
  ///
  /// A comparison example is complete when the learner's stated answer equals
  /// the exact result. Every other example is complete when its value equals
  /// its primary fraction. The route taken (which denominator, how many taps)
  /// does not matter.
  bool get isGuidedComplete {
    if (mode != NumberSenseMode.guided || activeExample == null) return false;
    final example = NumberSenseExample.of(activeExample!);
    final expected = example.expectedComparison;
    if (expected != null) return comparisonAnswer == expected;
    return value == example.primary;
  }

  /// Selects a V1 denominator and re-snaps the value to it.
  ///
  /// The value is snapped with [NumberSenseGeometry.snapUnitPosition], so
  /// 2/3 moved to fourths becomes 3/4 (rounding the midpoint upward). The
  /// shaded count is then expressed in the new partition.
  NumberSenseState selectDenominator(int newDenominator) {
    if (usesPrecisionLine) {
      throw StateError(
          'selectDenominator is unavailable on the precision line.');
    }
    _requireV1Denominator(newDenominator);
    final snapped = NumberSenseGeometry.snapUnitPosition(
      NumberSenseGeometry.unitPositionOf(value),
      newDenominator,
    );
    // The reduced denominator always divides the new partition exactly.
    final count = snapped.numerator * (newDenominator ~/ snapped.denominator);
    return _copy(
      denominator: newDenominator,
      shadedParts: count,
      wholePartModelTouched: true,
    );
  }

  /// Sets the shaded count to [count], from `0` through [denominator].
  NumberSenseState setShadedParts(int count) {
    if (usesPrecisionLine) {
      throw StateError('setShadedParts is unavailable on the precision line.');
    }
    if (count < 0 || count > denominator) {
      throw ArgumentError.value(
          count, 'count', 'must be between 0 and $denominator');
    }
    return _copy(shadedParts: count, wholePartModelTouched: true);
  }

  /// Shades one more part. Throws [StateError] at the maximum, so a control
  /// must check [canIncrement] first rather than relying on a silent no-op.
  NumberSenseState increment() {
    if (!canIncrement) {
      throw StateError('Cannot shade more than $denominator of $denominator.');
    }
    return _copy(
      shadedParts: shadedParts + 1,
      wholePartModelTouched: true,
    );
  }

  /// Unshades one part. Throws [StateError] at zero.
  NumberSenseState decrement() {
    if (!canDecrement) {
      throw StateError('Cannot shade fewer than zero parts.');
    }
    return _copy(
      shadedParts: shadedParts - 1,
      wholePartModelTouched: true,
    );
  }

  /// Selects a hundredth tick from `0/100` through `10/100`.
  NumberSenseState setPrecisionHundredths(int hundredths) {
    if (!usesPrecisionLine) {
      throw StateError('The precision line is not selected.');
    }
    if (hundredths < 0 || hundredths > 10) {
      throw ArgumentError.value(
        hundredths,
        'hundredths',
        'must be between 0 and 10',
      );
    }
    return _copy(
      precisionHundredths: hundredths,
      precisionLineTouched: true,
    );
  }

  /// Switches the Free Explore display between the starter bar and precision
  /// line without changing either model's current selection.
  NumberSenseState selectPrecisionLine(bool selected) {
    _requireMode(NumberSenseMode.freeExplore, 'selectPrecisionLine');
    if (selected == usesPrecisionLine) return this;
    return _copy(usesPrecisionLine: selected);
  }

  /// Switches mode. Guided starts the active example, or the first example
  /// if none is active, at its starting state. Free Explore keeps the current
  /// partition and shading.
  NumberSenseState switchMode(NumberSenseMode target) {
    if (target == mode) return this;
    if (target == NumberSenseMode.guided) {
      return _startOf(NumberSenseExample.of(
          activeExample ?? NumberSenseExampleId.equivalenceHalf));
    }
    return NumberSenseState._(
      mode: NumberSenseMode.freeExplore,
      denominator: denominator,
      shadedParts: shadedParts,
      activeExample: null,
      comparisonAnswer: null,
      usesPrecisionLine: usesPrecisionLine,
      precisionHundredths: precisionHundredths,
      precisionLineTouched: precisionLineTouched,
      wholePartModelTouched: wholePartModelTouched,
    );
  }

  /// Returns the active guided example to its starting state. Only valid in
  /// Guided mode.
  NumberSenseState resetGuided() {
    _requireMode(NumberSenseMode.guided, 'resetGuided');
    return _startOf(NumberSenseExample.of(activeExample!));
  }

  /// Clears Free Explore to zero shaded parts, keeping the partition. Only
  /// valid in Free Explore mode.
  NumberSenseState resetFreeExplore() {
    _requireMode(NumberSenseMode.freeExplore, 'resetFreeExplore');
    return usesPrecisionLine
        ? _copy(precisionHundredths: 0, precisionLineTouched: false)
        : _copy(shadedParts: 0);
  }

  /// Moves to the next guided example in the fixed cycling order (wrapping
  /// after the last), starting at its starting state.
  NumberSenseState cycleExample() {
    final all = NumberSenseExample.all;
    final current = activeExample == null
        ? -1
        : all.indexWhere((example) => example.id == activeExample);
    return _startOf(all[(current + 1) % all.length]);
  }

  /// Records the learner's comparison for a comparison example. Only valid in
  /// Guided mode, and only for an example that has an expected comparison.
  NumberSenseState answerComparison(NumberSenseComparison answer) {
    _requireMode(NumberSenseMode.guided, 'answerComparison');
    final example = NumberSenseExample.of(activeExample!);
    if (example.expectedComparison == null) {
      throw StateError('The active example does not compare fractions.');
    }
    return _copy(comparisonAnswer: answer);
  }

  static NumberSenseState _startOf(NumberSenseExample example) =>
      NumberSenseState._(
        mode: NumberSenseMode.guided,
        denominator: example.startDenominator,
        shadedParts: example.startShadedParts,
        activeExample: example.id,
        comparisonAnswer: null,
        usesPrecisionLine: example.id == NumberSenseExampleId.findOneHundredth,
        precisionHundredths: 0,
        precisionLineTouched: false,
        wholePartModelTouched: false,
      );

  NumberSenseState _copy({
    int? denominator,
    int? shadedParts,
    NumberSenseComparison? comparisonAnswer,
    bool? usesPrecisionLine,
    int? precisionHundredths,
    bool? precisionLineTouched,
    bool? wholePartModelTouched,
  }) =>
      NumberSenseState._(
        mode: mode,
        denominator: denominator ?? this.denominator,
        shadedParts: shadedParts ?? this.shadedParts,
        activeExample: activeExample,
        comparisonAnswer: comparisonAnswer ?? this.comparisonAnswer,
        usesPrecisionLine: usesPrecisionLine ?? this.usesPrecisionLine,
        precisionHundredths: precisionHundredths ?? this.precisionHundredths,
        precisionLineTouched: precisionLineTouched ?? this.precisionLineTouched,
        wholePartModelTouched:
            wholePartModelTouched ?? this.wholePartModelTouched,
      );

  void _requireMode(NumberSenseMode required, String operation) {
    if (mode != required) {
      throw StateError('$operation requires ${required.name} mode.');
    }
    if (required == NumberSenseMode.guided && activeExample == null) {
      throw StateError('$operation requires an active guided example.');
    }
  }

  static void _requireV1Denominator(int denominator) {
    if (!numberSenseV1Denominators.contains(denominator)) {
      throw ArgumentError.value(denominator, 'denominator',
          'must be one of ${numberSenseV1Denominators.toList()..sort()}');
    }
  }

  @override
  String toString() =>
      'NumberSenseState(${mode.name}, $shadedParts of $denominator = $value)';
}
