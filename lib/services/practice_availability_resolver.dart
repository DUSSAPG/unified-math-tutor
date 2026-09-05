import '../models/curriculum_manifest.dart';
import 'curriculum_manifest_service.dart';
import 'jsonl_pack_loader.dart';
import 'pack_registry_service.dart';

/// D2/P0 — the one place that decides what a Practice session actually has
/// to work with, for either Quick Start or Topic Drill. Separated out from
/// `PracticeScreen` so the resolution logic (which stage pool, which topic
/// filter, what counts as "nothing usable") is testable without pumping a
/// widget tree, and so Quick Start and Topic Drill can never accidentally
/// share behaviour by both routing through one under-specified code path.
///
/// P0 content-integrity repair (2026-09-05): every pack row now carries an
/// explicit `topicId` tag (see tool/retag_practice_packs.dart) and every
/// (topicId, stage) combination has a declared availability in
/// [CurriculumManifestService]'s canonical manifest. Topic filtering is
/// therefore a plain field-equality check against that tag — never a
/// runtime re-derivation from raw skill/strand values, never a fuzzy or
/// partial match, and never a fallback to a broader pool when the exact
/// match is empty. This is a hard invariant: neither `resolveTopicDrill`
/// nor a topic-scoped `resolveQuickStart` call may return a question whose
/// tagged `topicId` differs from what was asked for.
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

/// Quick Start only (global, no Topic Hub context): the stage's entire
/// practice pool is empty (every row quarantined, or the pack itself has
/// none) — distinct from a normal "picked a smaller-than-requested
/// session" result, which is not this.
class PracticeLoadStageUnavailable extends PracticeLoadOutcome {
  const PracticeLoadStageUnavailable();
}

/// Topic Drill, or a Topic-Hub-launched Quick Start: either the manifest
/// declares this (topicId, stage) combination unavailable, or it declares
/// it available but zero tagged records actually exist after quarantine
/// (a manifest/pack drift that should never happen — caught here as
/// defence in depth, never surfaced as a silent substitution). Both
/// collapse to the same learner-facing truth — "not available for this
/// topic right now" — never a substitution into a different topic's or a
/// stage-wide pool's content.
class PracticeLoadTopicUnavailable extends PracticeLoadOutcome {
  const PracticeLoadTopicUnavailable();
}

class PracticeAvailabilityResolver {
  PracticeAvailabilityResolver._();

  /// Quick Start. [topicId] is `null` for the *global* Quick Start entry
  /// (Home/Practice with no Topic Hub context) — the one place a stage-wide,
  /// no-topic-filter pool is still the honest, intended contract. When
  /// [topicId] is non-null (a Topic Hub launch, Topic Drill or Quick
  /// Start card alike), this applies the exact same manifest-gated,
  /// tag-equality filter [resolveTopicDrill] does — never a stage-wide
  /// fallback for a Hub-scoped launch.
  static Future<PracticeLoadOutcome> resolveQuickStart(
    String stage, {
    String? topicId,
  }) async {
    if (topicId == null) {
      final records = await _loadStagePool(stage);
      if (records.isEmpty) return const PracticeLoadStageUnavailable();
      return PracticeLoadReady(records);
    }
    return _resolveExactTopic(
        stage, topicId, (record) => record.quickStartReady);
  }

  /// Topic Drill: only records whose baked-in `topicId` tag exactly equals
  /// [topicId] — never a fuzzy match, never a fallback to a different
  /// topic or the stage-wide pool.
  static Future<PracticeLoadOutcome> resolveTopicDrill(
    String stage,
    String topicId,
  ) async {
    return _resolveExactTopic(
        stage, topicId, (record) => record.topicDrillReady);
  }

  static Future<PracticeLoadOutcome> _resolveExactTopic(
    String stage,
    String topicId,
    bool Function(TopicStageRecord) isReady,
  ) async {
    final record =
        await CurriculumManifestService.instance.recordFor(topicId, stage);
    if (record == null || !isReady(record)) {
      return const PracticeLoadTopicUnavailable();
    }
    final records = await _loadStagePool(stage);
    final matched =
        records.where((record) => record['topicId'] == topicId).toList();
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
