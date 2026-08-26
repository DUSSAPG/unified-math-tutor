import '../core/practice_topic_mapping.dart';
import 'jsonl_pack_loader.dart';
import 'pack_registry_service.dart';

/// D2 — the one place that decides what a Practice session actually has to
/// work with, for either Quick Start or Topic Drill. Separated out from
/// `PracticeScreen` so the resolution logic (which stage pool, which topic
/// filter, what counts as "nothing usable") is testable without pumping a
/// widget tree, and so Quick Start and Topic Drill can never accidentally
/// share behaviour by both routing through one under-specified code path.
sealed class PracticeLoadOutcome {
  const PracticeLoadOutcome();
}

/// Real, non-quarantined records are available — ready to build a session
/// from. Never contains quarantined/invalid/malformed rows: they were
/// already excluded by `JsonlPackLoader`'s D1 quarantine policy before this
/// resolver ever sees them.
class PracticeLoadReady extends PracticeLoadOutcome {
  const PracticeLoadReady(this.records);
  final List<Map<String, dynamic>> records;
}

/// Quick Start only: the stage's entire practice pool is empty (every row
/// quarantined, or the pack itself has none) — distinct from a normal
/// "picked a smaller-than-requested session" result, which is not this.
class PracticeLoadStageUnavailable extends PracticeLoadOutcome {
  const PracticeLoadStageUnavailable();
}

/// Topic Drill only: either the chosen topic has no evidence-backed mapping
/// for this stage at all (see `practice_topic_mapping.dart`'s
/// `intentionallyUnmappedRawValues`), or it does map but zero usable
/// records exist after quarantine. Both collapse to the same learner-facing
/// truth — "not available for this topic right now" — never a silent
/// substitution into a different topic's content.
class PracticeLoadTopicUnavailable extends PracticeLoadOutcome {
  const PracticeLoadTopicUnavailable();
}

class PracticeAvailabilityResolver {
  PracticeAvailabilityResolver._();

  /// Quick Start: the stage's whole usable pool, no topic filter — matches
  /// the product's existing "mixed review" contract exactly.
  static Future<PracticeLoadOutcome> resolveQuickStart(String stage) async {
    final records = await _loadStagePool(stage);
    if (records.isEmpty) return const PracticeLoadStageUnavailable();
    return PracticeLoadReady(records);
  }

  /// Topic Drill: only records whose raw pack value maps to [topicId] under
  /// the explicit, stage-scoped mapping — never a fuzzy match, never a
  /// fallback to a different topic.
  static Future<PracticeLoadOutcome> resolveTopicDrill(
    String stage,
    String topicId,
  ) async {
    final records = await _loadStagePool(stage);
    final groupingField = groupingFieldFor(stage);
    final matched = records.where((record) {
      final group = record[groupingField] as String?;
      final fineSkill = record['skill'] as String?;
      final canonical = canonicalTopicForRawValue(
        stage: stage,
        rawStrandOrSkillGroup: group,
        rawFineSkill: fineSkill,
      );
      return canonical == topicId;
    }).toList();
    if (matched.isEmpty) return const PracticeLoadTopicUnavailable();
    return PracticeLoadReady(matched);
  }

  static Future<List<Map<String, dynamic>>> _loadStagePool(
    String stage,
  ) async {
    final pack = await PackRegistryService.instance.forStage(stage);
    // JsonlPackLoader already excludes quarantined rows (D1) — nothing
    // further to filter for validity here.
    return JsonlPackLoader.instance.load(pack);
  }
}
