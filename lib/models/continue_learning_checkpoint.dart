import 'package:flutter/foundation.dart';

/// The closed set of activity kinds that can hold a Continue Learning
/// checkpoint. A new lab/Studio activity/exam pack adopting this contract
/// adds a new member here plus its own restoration-payload
/// encode/decode pair (see `practice_session_restoration_payload.dart` for
/// the one that exists today) — the core [ContinueLearningCheckpoint] model
/// never needs to change to support it.
enum ContinueLearningActivityType {
  practiceSession('practice_session');

  const ContinueLearningActivityType(this.id);

  final String id;

  static ContinueLearningActivityType? fromId(String? id) {
    if (id == null) return null;
    for (final value in values) {
      if (value.id == id) return value;
    }
    return null;
  }
}

/// One learner's single in-progress, resumable activity. Immutable and
/// versioned — see [ContinueLearningService] for the persistence/lifecycle
/// rules that produce and consume instances of this class.
///
/// Deliberately absent: no raw question/answer text, no tutor
/// conversation, no free-text notes, no timer/elapsed-time state, no
/// fabricated progress percentage, no ALI recommendation, no premium
/// status. [currentStep]/[totalSteps] are the only progress signal, and
/// both are real, recoverable integers — never a guess.
@immutable
class ContinueLearningCheckpoint {
  const ContinueLearningCheckpoint({
    required this.schemaVersion,
    required this.checkpointId,
    required this.learnerScopeId,
    required this.activityType,
    required this.contentVersion,
    required this.curriculumLevel,
    required this.topicId,
    required this.currentStep,
    required this.totalSteps,
    required this.startedAtUtc,
    required this.updatedAtUtc,
    required this.resumeCount,
    required this.restorationPayload,
  });

  /// The only schema version this build writes or accepts. A checkpoint
  /// written by a future version fails closed (see [tryDecode]) rather than
  /// guessing at an unknown shape — there is no migration path yet.
  static const currentSchemaVersion = 1;

  final int schemaVersion;

  /// Stable across updates to the same unfinished activity — generated
  /// once when the checkpoint is first created, unchanged by subsequent
  /// saves. Opaque; carries no meaning beyond identity.
  final String checkpointId;

  /// [LearnerScopeId.value] — see that class for what this can and cannot
  /// be derived from.
  final String learnerScopeId;

  final ContinueLearningActivityType activityType;

  /// A resolvable content coordinate (e.g. `"ks2:en-GB"`), not a real
  /// semantic version — the pack registry this app ships has no version
  /// number of its own. The authoritative integrity check is not this
  /// string; it's whether every id in [restorationPayload] still resolves
  /// after reloading the named content (see
  /// `ContinueLearningDestinationResolver`). This field is a cheap
  /// pre-check / diagnostic, not the source of truth.
  final String contentVersion;

  /// Curriculum stage this checkpoint belongs to (e.g. `'KS2'`).
  final String curriculumLevel;

  /// Topic filter, if the activity was topic-scoped. `null` for an
  /// unfiltered session — this is a genuinely meaningful nullable field
  /// (needed to reconstruct the original activity parameters), not a
  /// placeholder.
  final String? topicId;

  /// The step to resume into next. Truthful and recoverable — for the
  /// practice-session adapter this is the index of the next unanswered
  /// question.
  final int currentStep;

  /// The real total step count for this activity instance. Never a guess;
  /// never expressed as a percentage without both numbers being real.
  final int totalSteps;

  final DateTime startedAtUtc;
  final DateTime updatedAtUtc;

  /// Incremented each time this checkpoint is resumed (not merely read) —
  /// counts actual reopenings, not queries.
  final int resumeCount;

  /// Activity-type-specific restoration detail (e.g. the exact ordered
  /// question ids and recorded answer indices for a practice session — see
  /// `practice_session_restoration_payload.dart`). Opaque to this model by
  /// design: [ContinueLearningService] and [ContinueLearningCheckpoint]
  /// never interpret it, only the matching activity-type adapter does. May
  /// contain integers and short id strings only — never raw question/answer
  /// text, callbacks, widget state or service objects (enforced by
  /// [tryDecode]'s JSON-safety, not by this model reaching into it).
  final Map<String, Object?> restorationPayload;

  ContinueLearningCheckpoint copyWith({
    int? currentStep,
    DateTime? updatedAtUtc,
    int? resumeCount,
    Map<String, Object?>? restorationPayload,
  }) {
    return ContinueLearningCheckpoint(
      schemaVersion: schemaVersion,
      checkpointId: checkpointId,
      learnerScopeId: learnerScopeId,
      activityType: activityType,
      contentVersion: contentVersion,
      curriculumLevel: curriculumLevel,
      topicId: topicId,
      currentStep: currentStep ?? this.currentStep,
      totalSteps: totalSteps,
      startedAtUtc: startedAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      resumeCount: resumeCount ?? this.resumeCount,
      restorationPayload: restorationPayload ?? this.restorationPayload,
    );
  }

  Map<String, dynamic> toJson() => {
        'schemaVersion': schemaVersion,
        'checkpointId': checkpointId,
        'learnerScopeId': learnerScopeId,
        'activityType': activityType.id,
        'contentVersion': contentVersion,
        'curriculumLevel': curriculumLevel,
        'topicId': topicId,
        'currentStep': currentStep,
        'totalSteps': totalSteps,
        'startedAtUtc': startedAtUtc.toUtc().toIso8601String(),
        'updatedAtUtc': updatedAtUtc.toUtc().toIso8601String(),
        'resumeCount': resumeCount,
        'restorationPayload': restorationPayload,
      };

  /// Strict, corruption-tolerant decode. Never throws — returns `null` for
  /// anything malformed, an unrecognised activity type, or a schema version
  /// this build doesn't understand ("fail closed"). A caller that gets
  /// `null` back should treat the stored value as if no checkpoint existed
  /// (see [ContinueLearningService]'s quarantine policy) rather than crash
  /// bootstrap or Home.
  static ContinueLearningCheckpoint? tryDecode(Object? raw) {
    try {
      if (raw is! Map) return null;
      final json = raw;
      if (json['schemaVersion'] != currentSchemaVersion) return null;

      final checkpointId = json['checkpointId'];
      final learnerScopeId = json['learnerScopeId'];
      final contentVersion = json['contentVersion'];
      final curriculumLevel = json['curriculumLevel'];
      final topicId = json['topicId'];
      final currentStep = json['currentStep'];
      final totalSteps = json['totalSteps'];
      final resumeCount = json['resumeCount'];
      final restorationPayload = json['restorationPayload'];

      if (checkpointId is! String || checkpointId.isEmpty) return null;
      if (learnerScopeId is! String || learnerScopeId.isEmpty) return null;
      if (contentVersion is! String || contentVersion.isEmpty) return null;
      if (curriculumLevel is! String || curriculumLevel.isEmpty) return null;
      if (topicId != null && topicId is! String) return null;
      if (currentStep is! int || currentStep < 0) return null;
      if (totalSteps is! int || totalSteps <= 0) return null;
      if (currentStep > totalSteps) return null;
      if (resumeCount is! int || resumeCount < 0) return null;
      if (restorationPayload is! Map) return null;

      final activityType =
          ContinueLearningActivityType.fromId(json['activityType'] as String?);
      if (activityType == null) return null;

      final startedAtUtc =
          DateTime.tryParse(json['startedAtUtc'] as String? ?? '');
      final updatedAtUtc =
          DateTime.tryParse(json['updatedAtUtc'] as String? ?? '');
      if (startedAtUtc == null || updatedAtUtc == null) return null;

      return ContinueLearningCheckpoint(
        schemaVersion: currentSchemaVersion,
        checkpointId: checkpointId,
        learnerScopeId: learnerScopeId,
        activityType: activityType,
        contentVersion: contentVersion,
        curriculumLevel: curriculumLevel,
        topicId: topicId as String?,
        currentStep: currentStep,
        totalSteps: totalSteps,
        startedAtUtc: startedAtUtc.toUtc(),
        updatedAtUtc: updatedAtUtc.toUtc(),
        resumeCount: resumeCount,
        restorationPayload: Map<String, Object?>.from(restorationPayload),
      );
    } catch (_) {
      // Any unexpected shape (wrong runtime type on a cast, etc.) is a
      // corrupt checkpoint, not a crash — fail closed, same as every
      // explicit validation branch above.
      return null;
    }
  }
}
