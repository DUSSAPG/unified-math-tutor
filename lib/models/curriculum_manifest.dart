/// P0 content-integrity repair — the canonical, versioned contract for
/// which (topic, stage) combinations are real. Loaded from
/// assets/config/curriculum_manifest.json by [CurriculumManifestService];
/// see that file's own `description` field for the full authority
/// statement. Deliberately data-only (no logic) — every class here is a
/// typed, validated view of the JSON, nothing more.
library;

enum ActivityAvailability {
  available,
  unavailable,
  planned;

  static ActivityAvailability parse(String raw, String context) =>
      switch (raw) {
        'available' => ActivityAvailability.available,
        'unavailable' => ActivityAvailability.unavailable,
        'planned' => ActivityAvailability.planned,
        _ => throw FormatException(
            'Unknown activityAvailability value "$raw" in $context.',
          ),
      };
}

class CurriculumStage {
  const CurriculumStage({
    required this.id,
    required this.order,
    required this.label,
    required this.hasContent,
  });

  final String id;
  final int order;
  final String label;
  final bool hasContent;
}

class CurriculumStrand {
  const CurriculumStrand({required this.id, required this.label});

  final String id;
  final String label;
}

/// One (topicId, stage) record — the atomic unit of truth this whole
/// repair is about. `topicDrillAvailable`/`quickStartAvailable` are the
/// only two activity types this manifest owns (see the manifest's own
/// `description` for why formulaLibrary/recallCards stay resolver-owned).
class TopicStageRecord {
  const TopicStageRecord({
    required this.topicId,
    required this.stage,
    required this.curriculumMapping,
    required this.title,
    required this.subtitle,
    required this.strandId,
    required this.subtopics,
    required this.prerequisites,
    required this.iconKey,
    required this.topicDrillAvailability,
    required this.quickStartAvailability,
    required this.questionPackIds,
    required this.selectionPolicy,
    required this.provenanceStatus,
    required this.provenanceNote,
    required this.unavailableMessage,
    required this.feedbackContextId,
  });

  final String topicId;
  final String stage;
  final String curriculumMapping;
  final String title;
  final String subtitle;
  final String? strandId;
  final List<String> subtopics;
  final List<String> prerequisites;
  final String iconKey;
  final ActivityAvailability topicDrillAvailability;
  final ActivityAvailability quickStartAvailability;
  final List<String> questionPackIds;
  final String selectionPolicy;
  final String provenanceStatus;
  final String provenanceNote;

  /// Truthful, learner-facing "why not" copy — non-null exactly when
  /// either activity is not `available`. Never a generic technical error.
  final String? unavailableMessage;

  /// Stable id for correlating future feedback records to this exact
  /// topic+stage (Part E, deferred this sprint — field reserved now so
  /// nothing has to migrate later).
  final String feedbackContextId;

  bool get topicDrillReady =>
      topicDrillAvailability == ActivityAvailability.available;
  bool get quickStartReady =>
      quickStartAvailability == ActivityAvailability.available;

  factory TopicStageRecord.fromJson(Map<String, dynamic> json) {
    final topicId = json['topicId'] as String;
    final stage = json['stage'] as String;
    final context = '$topicId::$stage';
    final availability = json['activityAvailability'] as Map<String, dynamic>;
    return TopicStageRecord(
      topicId: topicId,
      stage: stage,
      curriculumMapping: json['curriculumMapping'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      strandId: json['strandId'] as String?,
      subtopics: (json['subtopics'] as List).cast<String>(),
      prerequisites: (json['prerequisites'] as List).cast<String>(),
      iconKey: json['iconKey'] as String,
      topicDrillAvailability: ActivityAvailability.parse(
        availability['topicDrill'] as String,
        '$context.activityAvailability.topicDrill',
      ),
      quickStartAvailability: ActivityAvailability.parse(
        availability['quickStart'] as String,
        '$context.activityAvailability.quickStart',
      ),
      questionPackIds: (json['questionPackIds'] as List).cast<String>(),
      selectionPolicy: json['selectionPolicy'] as String,
      provenanceStatus:
          (json['provenance'] as Map<String, dynamic>)['status'] as String,
      provenanceNote:
          (json['provenance'] as Map<String, dynamic>)['note'] as String,
      unavailableMessage: json['unavailableMessage'] as String?,
      feedbackContextId: json['feedbackContextId'] as String,
    );
  }
}

class CurriculumManifest {
  const CurriculumManifest({
    required this.manifestVersion,
    required this.curriculumMapping,
    required this.stages,
    required this.strands,
    required this.records,
  });

  final int manifestVersion;
  final String curriculumMapping;
  final List<CurriculumStage> stages;
  final List<CurriculumStrand> strands;

  /// Keyed by `'$topicId::$stage'`.
  final Map<String, TopicStageRecord> records;

  TopicStageRecord? recordFor(String topicId, String stage) =>
      records['$topicId::$stage'];

  factory CurriculumManifest.fromJson(Map<String, dynamic> json) {
    final stages = (json['stages'] as List)
        .cast<Map<String, dynamic>>()
        .map((s) => CurriculumStage(
              id: s['id'] as String,
              order: s['order'] as int,
              label: s['label'] as String,
              hasContent: s['hasContent'] as bool,
            ))
        .toList();
    final strands = (json['strands'] as List)
        .cast<Map<String, dynamic>>()
        .map((s) => CurriculumStrand(
              id: s['id'] as String,
              label: s['label'] as String,
            ))
        .toList();
    final records = <String, TopicStageRecord>{};
    for (final raw
        in (json['topicStageRecords'] as List).cast<Map<String, dynamic>>()) {
      final record = TopicStageRecord.fromJson(raw);
      final key = '${record.topicId}::${record.stage}';
      if (records.containsKey(key)) {
        throw FormatException('Duplicate topic-stage record "$key" in the '
            'curriculum manifest.');
      }
      records[key] = record;
    }
    return CurriculumManifest(
      manifestVersion: json['manifestVersion'] as int,
      curriculumMapping: json['curriculumMapping'] as String,
      stages: stages,
      strands: strands,
      records: records,
    );
  }
}
