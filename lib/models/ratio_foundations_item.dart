import 'package:flutter_shared_models/question_item.dart';

/// One deterministically generated item for the Year 8 Ratio & Proportion
/// "Ratio scaling foundations" vertical slice (Calculate layer, Rungs 1-3
/// only) — see `assets/config/ratio_foundations_task_family_v1.json` for
/// the versioned task-family contract this is generated from, and
/// `docs/learning_architecture/YEAR8_RATIO_AND_KS4_QUADRATICS_BLUEPRINTS_V1.md`
/// for the full design this is one narrow slice of.
class RatioFoundationsItem {
  const RatioFoundationsItem({
    required this.question,
    required this.rung,
    required this.seed,
    required this.itemIndexInRung,
    required this.taskFamilyId,
    required this.taskFamilyVersion,
    this.oneSideOnlyDistractorIndex,
  });

  /// Reuses the app's existing MCQ content shape (`flutter_shared_models`'
  /// `QuestionItem`, the same type Practice sessions render) so this slice
  /// preserves current response formats/rendering conventions rather than
  /// inventing a new one.
  final QuestionItem question;

  final int rung;

  /// The base seed for this generation session — combined with [rung] and
  /// [itemIndexInRung], deterministically reproduces this exact item,
  /// including its options and explanation. See
  /// `RatioFoundationsTaskGenerator._rngFor`.
  final int seed;

  final int itemIndexInRung;
  final String taskFamilyId;
  final int taskFamilyVersion;

  /// Index into `question.options` that represents the authored "scaled
  /// one side only" misconception signature (`ERR_MAGNITUDE_SCALE`) for
  /// this item, or `null` when this item has no such authored distractor
  /// (Rung 1, and Rung 2's items — the signature is only recorded from
  /// Rung 3 per the task-family contract). Never inferred from the numeric
  /// relationship between a wrong answer and the correct one.
  final int? oneSideOnlyDistractorIndex;
}
