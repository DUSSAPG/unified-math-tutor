import 'package:flutter/foundation.dart';

import 'continue_learning_checkpoint.dart';

/// Distinguishes "we haven't looked yet" from "we looked and there is truly
/// nothing" from "there is something." Lives in the models layer (not
/// `continue_learning_service.dart`) so `CanonicalLearnerState` can depend
/// on it without a model-layer file importing a service. Never collapse the
/// first two into a single `null` — a consumer must be able to tell "not
/// loaded" from a genuine empty state before it can honestly render either
/// one.
enum ContinueLearningEvidenceStatus {
  notLoaded,
  noCheckpoint,
  checkpointAvailable,
}

/// The minimum learner-facing facts a future Home consumer needs to show
/// "Continue Learning" honestly — deliberately a narrower view than
/// [ContinueLearningCheckpoint] itself. Excludes
/// [ContinueLearningCheckpoint.restorationPayload],
/// [ContinueLearningCheckpoint.learnerScopeId] and
/// [ContinueLearningCheckpoint.checkpointId] from anything that would
/// otherwise be logged/displayed at large, keeping raw restoration
/// internals and storage identifiers out of UI consumers' hands even
/// though this type is technically constructed from them.
@immutable
class ContinueLearningSummary {
  const ContinueLearningSummary({
    required this.checkpointId,
    required this.activityType,
    required this.curriculumLevel,
    required this.topicId,
    required this.currentStep,
    required this.totalSteps,
    required this.updatedAtUtc,
  });

  /// Kept so a future "Continue"/"Discard" action can reference exactly
  /// which checkpoint it acted on — opaque, not personal data, safe to
  /// round-trip through UI state.
  final String checkpointId;

  final ContinueLearningActivityType activityType;
  final String curriculumLevel;
  final String? topicId;

  /// Real, recoverable step counts — see
  /// [ContinueLearningCheckpoint.currentStep]/`.totalSteps`. Never a
  /// fabricated percentage.
  final int currentStep;
  final int totalSteps;

  final DateTime updatedAtUtc;

  factory ContinueLearningSummary.fromCheckpoint(
    ContinueLearningCheckpoint checkpoint,
  ) {
    return ContinueLearningSummary(
      checkpointId: checkpoint.checkpointId,
      activityType: checkpoint.activityType,
      curriculumLevel: checkpoint.curriculumLevel,
      topicId: checkpoint.topicId,
      currentStep: checkpoint.currentStep,
      totalSteps: checkpoint.totalSteps,
      updatedAtUtc: checkpoint.updatedAtUtc,
    );
  }
}
