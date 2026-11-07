import 'family_activity.dart';

/// The two suggested starting points for early maths, plus "I'm not sure".
///
/// A lane is a **presentation and suggestion concept only** — never an
/// ability label, level, placement result, or evidence field (see
/// docs/learning_architecture/EARLY_MATHS_4_TO_7_LIFECYCLE_CONTRACT_V1.md).
/// It only decides which already-existing activities are shown first. It
/// deliberately adds no value to `CurriculumService`,
/// `PackRegistryService.practiceStages`, or the curriculum manifest.
enum EarlyMathsLane {
  /// Typical ages 4-5 / Reception.
  earlyMathsPlay('early_maths_play'),

  /// Typical ages 5-7 / Years 1-2.
  ks1MathsFoundations('ks1_maths_foundations'),

  /// The parent has not picked a lane. Shows the gentle default and never
  /// assigns one.
  notSure('not_sure');

  const EarlyMathsLane(this.storageValue);

  /// Stable persisted value. Never rename — it is stored on the device.
  final String storageValue;

  /// Returns null for anything unrecognised so a corrupt or future value
  /// reads as "no lane chosen" rather than throwing.
  static EarlyMathsLane? fromStorage(String? value) {
    for (final lane in EarlyMathsLane.values) {
      if (lane.storageValue == value) return lane;
    }
    return null;
  }
}

/// The child-facing activities that genuinely exist and are reachable today.
/// A closed list on purpose: a planned activity (Number Line, Fraction Bars,
/// Spatial Intelligence, Dino Polo, narration…) has no member here, so it
/// cannot be surfaced by accident.
enum EarlyMathsChildActivity {
  /// Feed the Hungry Panda — narrow scope: 1-3 apples out of 5, then how
  /// many are left.
  feedThePanda,

  /// Interactive Abacus — hundreds, tens and ones rods with beads that slide
  /// by tap or drag, plus a Number Board and guided feedback. Local, unscored;
  /// not a soroban course or a claim of full KS1 coverage.
  abacus,
}

/// Which activities each lane shows. Pure functions of the lane, so the rule
/// is unit-testable without a widget tree.
class EarlyMathsLaneContent {
  const EarlyMathsLaneContent._();

  /// [lane] is null when nothing has been chosen; that behaves exactly like
  /// [EarlyMathsLane.notSure].
  static List<EarlyMathsChildActivity> childActivities(EarlyMathsLane? lane) {
    switch (lane) {
      case EarlyMathsLane.earlyMathsPlay:
      case EarlyMathsLane.notSure:
      case null:
        return const [EarlyMathsChildActivity.feedThePanda];
      case EarlyMathsLane.ks1MathsFoundations:
        return const [EarlyMathsChildActivity.abacus];
    }
  }

  /// Whether the parent-led Family Maths section is shown for [lane]. Not
  /// shown while the lane is undecided — the gentle default stays one small
  /// activity.
  static bool showsParentLedSection(EarlyMathsLane? lane) =>
      lane == EarlyMathsLane.earlyMathsPlay ||
      lane == EarlyMathsLane.ks1MathsFoundations;

  /// Highest catalogue minimum age that still counts as fitting each lane at
  /// its core. Read from the catalogue's own declared ages, not a hand-typed
  /// id list, so the section cannot drift from the real data.
  static const _earlyMathsPlayMaxMinAge = 4;
  static const _ks1MaxMinAge = 6;

  static bool parentLedActivityFits(
    EarlyMathsLane? lane,
    FamilyActivity activity,
  ) {
    switch (lane) {
      case EarlyMathsLane.earlyMathsPlay:
        return activity.minAgeYears <= _earlyMathsPlayMaxMinAge;
      case EarlyMathsLane.ks1MathsFoundations:
        return activity.minAgeYears <= _ks1MaxMinAge;
      case EarlyMathsLane.notSure:
      case null:
        return false;
    }
  }
}
