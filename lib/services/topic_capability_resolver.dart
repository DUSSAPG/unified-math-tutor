import '../core/practice_topic_mapping.dart' show canonicalTopicIds;
import '../models/interactive_lab_id.dart';
import 'formula_library_service.dart';
import 'practice_availability_resolver.dart';
import 'recall_card_catalog_service.dart';
import 'topic_supporting_learning_registry.dart';

export 'topic_supporting_learning_registry.dart'
    show
        StageEvidence,
        SupportingActivityId,
        SupportingEvidenceBasis,
        SupportingScope,
        TopicStageStatus;

/// D3 — the Topic Learning Hub's single source of truth for "what can a
/// learner genuinely do with this topic, at this stage." Every other file
/// in the hub (the screen, its tests) consumes [TopicCapabilityResolver
/// .resolve] rather than re-deriving availability itself — see the sprint
/// report's "Data Contract" requirement.
///
/// # Where does stage-eligibility come from?
/// * **MCQ practice** (Topic Drill, Quick Start) — unchanged: real,
///   per-stage evidence via [PracticeAvailabilityResolver] (canonical
///   manifest + exact `topicId` pack tags), audited in
///   topic_drill_truthfulness_test.dart.
/// * **Supporting learning** (Formula Library items, Recall Cards,
///   Interactive Labs, other Math Studio activities) — Topic Hub Coverage
///   Truth Repair V1: resolved per item from
///   [TopicSupportingLearningRegistry], which records the stage evidence
///   for every (topic, stage, item). It is deliberately independent of MCQ
///   availability: a cell can have supporting learning with no MCQs (shown
///   under an explicit "no topic-specific questions" status), and MCQs at a
///   stage no longer imply that unrelated-stage material is shown there.
enum TopicActivitySection { practise, learn, explore, workbook }

enum TopicActivityType {
  topicDrill,
  quickStart,
  formulaLibrary,
  recallCards,
  interactiveLab,

  /// A verified Math Studio activity that is not an Interactive Lab (see
  /// [SupportingActivityId]) — Abacus, Spatial Intelligence activities.
  supportingActivity,
  workbook,
}

/// One row of the capability matrix. `route`/`routeExtra` are always
/// populated (deterministically, from topicId/stage alone) even when
/// [available] is false, purely for audit purposes — the UI must never
/// navigate using them unless [available] is true.
class TopicActivityCapability {
  const TopicActivityCapability({
    required this.topicId,
    required this.stage,
    required this.section,
    required this.activityType,
    required this.route,
    required this.routeExtra,
    required this.available,
    required this.reason,
    this.supportingId,
    this.scope,
    this.evidence,
  });

  final String topicId;
  final String stage;
  final TopicActivitySection section;
  final TopicActivityType activityType;
  final String route;
  final Map<String, dynamic> routeExtra;
  final bool available;

  /// A short, truthful, human-readable explanation — used both as the
  /// audit record and (for rows without a [scope]) as learner-facing copy.
  /// Never claims content exists when it does not.
  final String reason;

  /// Optional identifier for the specific formula/lab/activity evidence
  /// behind this row — e.g. an [InteractiveLabId] or [SupportingActivityId]
  /// name, or null for rows that aggregate a count (Formula Library, Recall
  /// Cards) rather than pointing at one item.
  final String? supportingId;

  /// Learner-facing scope statement for supporting rows that have one —
  /// describes exactly what the item contains, never a coverage claim.
  final SupportingScope? scope;

  /// The stage evidence this row was made available on (null for MCQ and
  /// unavailable rows). Audit data only — never shown to learners.
  final StageEvidence? evidence;
}

class TopicCapabilityResolver {
  TopicCapabilityResolver._();

  /// Every canonical topic id this resolver knows how to evaluate (mirrors
  /// [canonicalTopicIds] minus 'mixed_review', which is Quick Start's own
  /// pseudo-topic and never a Topic Learning Hub entry).
  static final Set<String> supportedTopicIds =
      canonicalTopicIds.difference({'mixed_review'});

  /// Interactive Lab -> real, evidence-backed canonical topic ids, taken
  /// directly from each lab screen's own `LabRelatedLinks.practiceTopicIds`
  /// (the same field InteractiveLabsProgressService/Recall Cards already
  /// treat as that lab's authoritative topic linkage — cross-checked
  /// against the source screens by
  /// test/topic_capability_resolver_test.dart's drift guard). A lab absent
  /// from this table, or mapped to an empty set, has no explicit topic
  /// linkage and is never shown by the Hub — spatialCubeLab and
  /// earlyMathsPlayground currently fall in that category. Topic linkage
  /// is necessary but not sufficient: a lab is shown at a stage only when
  /// [TopicSupportingLearningRegistry] also records stage evidence for it.
  static const Map<InteractiveLabId, Set<String>> labTopicIds = {
    // fraction_builder_screen.dart
    InteractiveLabId.fractionBuilder: {'fractions'},
    // algebra_balance_screen.dart
    InteractiveLabId.algebraBalance: {'algebra'},
    // number_line_explorer_screen.dart
    InteractiveLabId.numberLineExplorer: {'number_place_value'},
    // flight_path_lab_screen.dart
    InteractiveLabId.flightPathLab: {'geometry_measures'},
    // football_precision_lab_screen.dart
    InteractiveLabId.footballPrecision: {
      'statistics_probability',
      'geometry_measures',
    },
    // maze_driver_lab_screen.dart
    InteractiveLabId.mazeDriver: {'geometry_measures'},
    // data_detective_screen.dart
    InteractiveLabId.dataDetective: {'statistics_probability'},
    // spatial_cube/*.dart — every sub-mission explicitly declares an empty
    // practiceTopicIds list; no topic linkage exists to show.
    InteractiveLabId.spatialCubeLab: {},
    // aircraft_landing/*.dart — union across its 4 sub-missions
    // (find-the-time: geometry_measures; descent-line: trigonometry;
    // glide-path: trigonometry+geometry_measures; vector-approach:
    // trigonometry).
    InteractiveLabId.aircraftLandingLab: {'trigonometry', 'geometry_measures'},
    // early_maths_playground_hub_screen.dart has no LabRelatedLinks/topic
    // linkage at all.
    InteractiveLabId.earlyMathsPlayground: {},
  };

  /// go_router path under /math-studio/interactive-labs for each lab.
  /// Aircraft Landing / Spatial Cube route to their hub (sub-mission
  /// choice), matching how spatial_intelligence_screen.dart and
  /// visual_maths_hub_screen.dart already link to labs.
  static const Map<InteractiveLabId, String> labRoutes = {
    InteractiveLabId.fractionBuilder:
        '/math-studio/interactive-labs/fraction-builder',
    InteractiveLabId.algebraBalance:
        '/math-studio/interactive-labs/algebra-balance',
    InteractiveLabId.numberLineExplorer:
        '/math-studio/interactive-labs/number-line-explorer',
    InteractiveLabId.flightPathLab:
        '/math-studio/interactive-labs/flight-path-lab',
    InteractiveLabId.footballPrecision:
        '/math-studio/interactive-labs/football-precision',
    InteractiveLabId.mazeDriver: '/math-studio/interactive-labs/maze-driver',
    InteractiveLabId.dataDetective:
        '/math-studio/interactive-labs/data-detective',
    InteractiveLabId.spatialCubeLab:
        '/math-studio/interactive-labs/spatial-cube-lab',
    InteractiveLabId.aircraftLandingLab:
        '/math-studio/interactive-labs/aircraft-landing-lab',
    InteractiveLabId.earlyMathsPlayground:
        '/math-studio/interactive-labs/early-maths-playground',
  };

  /// Formula catalog `category` values (assets/config/formula_catalog.json)
  /// grouped by canonical topic id. Since Coverage Truth Repair V1 the Hub
  /// links to an explicit, per-stage list of formula *ids* (see
  /// [TopicSupportingLearningRegistry]); this table is kept as the topic
  /// boundary those ids must stay inside (enforced by
  /// test/topic_supporting_learning_registry_test.dart).
  static const Map<String, Set<String>> formulaCategoriesForTopic = {
    'algebra': {'Algebra'},
    'fractions': {'Fractions'},
    'percentages': {'Percentages'},
    'geometry_measures': {
      'Area',
      'Circle',
      'Coordinate Geometry',
      'Pythagoras',
      'Volume',
    },
    'statistics_probability': {'Statistics', 'Probability'},
    'trigonometry': {'Trigonometry'},
  };

  /// The stage-status message the Hub shows above (or instead of) any
  /// cards. Depends only on MCQ availability and the registry's verified
  /// product-scope (no planned activity) list — never on supporting learning.
  static TopicStageStatus stageStatus({
    required String topicId,
    required String stage,
    required bool mcqAvailable,
  }) {
    if (mcqAvailable) return TopicStageStatus.mcqAvailable;
    if (TopicSupportingLearningRegistry.noPlannedActivity
        .containsKey((topicId, stage))) {
      return TopicStageStatus.noPlannedActivity;
    }
    return TopicStageStatus.contentGap;
  }

  /// Resolves every activity row for [topicId] at [stage]. Always returns
  /// one row each for topicDrill/quickStart/formulaLibrary/recallCards/
  /// workbook, plus one row per topic-linked Interactive Lab (or one
  /// unavailable row if none is linked) and one row per registered
  /// supporting activity — never zero rows for a section, so an audit
  /// always sees why a section is empty.
  static Future<List<TopicActivityCapability>> resolve({
    required String topicId,
    required String stage,
  }) async {
    final topicDrillOutcome =
        await PracticeAvailabilityResolver.resolveTopicDrill(stage, topicId);
    final topicDrillReady = topicDrillOutcome is PracticeLoadReady;

    // P0 content-integrity repair: Quick Start launched from a Topic Hub is
    // now exact-topic, same invariant as Topic Drill — never the stage-wide
    // pool. Passing topicId here is what makes resolveQuickStart apply that
    // filter instead of its global (Home/Practice, no Hub context) fallback.
    final quickStartOutcome =
        await PracticeAvailabilityResolver.resolveQuickStart(stage,
            topicId: topicId);
    final quickStartReady = quickStartOutcome is PracticeLoadReady;

    // Supporting learning: per-item stage evidence only. topicDrillReady is
    // intentionally NOT consulted below this line.
    final cell = TopicSupportingLearningRegistry.cellFor(topicId, stage);

    final rows = <TopicActivityCapability>[
      TopicActivityCapability(
        topicId: topicId,
        stage: stage,
        section: TopicActivitySection.practise,
        activityType: TopicActivityType.topicDrill,
        route: '/practice',
        // returnToHubTopicId: distinct from the topicId key above (which
        // filters the drill itself) — it tells PracticeScreen which Hub to
        // return to on Back, deterministically, regardless of Navigator
        // stack ambiguity across shell branches.
        routeExtra: {
          'topicId': topicId,
          'stage': stage,
          'returnToHubTopicId': topicId,
        },
        available: topicDrillReady,
        // No pool/aggregate counts here (P0 content-integrity repair,
        // part D) — a count invites exactly the misleading "N real
        // questions" impression that caused the reported defect. Truthful
        // presence/absence only.
        reason: topicDrillReady
            ? 'Real questions are available for this topic at $stage.'
            : 'No topic-specific questions are available for this topic at '
                '$stage.',
      ),
      TopicActivityCapability(
        topicId: topicId,
        stage: stage,
        section: TopicActivitySection.practise,
        activityType: TopicActivityType.quickStart,
        route: '/practice',
        // 'topicId' filters the session content; 'preselectQuickStart'
        // chooses the MODE shown on setup; 'returnToHubTopicId' is which
        // Hub Back returns to.
        routeExtra: {
          'topicId': topicId,
          'stage': stage,
          'preselectQuickStart': true,
          'returnToHubTopicId': topicId,
        },
        available: quickStartReady,
        reason: quickStartReady
            ? 'Real questions are available for this topic at $stage.'
            : 'No topic-specific questions are available for this topic at '
                '$stage.',
      ),
      await _formulaLibraryRow(topicId, stage, cell.formulas),
      await _recallCardsRow(topicId, stage, cell.recallCards),
      TopicActivityCapability(
        topicId: topicId,
        stage: stage,
        section: TopicActivitySection.workbook,
        activityType: TopicActivityType.workbook,
        route: '',
        routeExtra: const {},
        available: false,
        reason: 'No workbook exists for this topic.',
      ),
      ..._interactiveLabRows(topicId, stage, cell.labs),
      ..._supportingActivityRows(topicId, stage, cell.activities),
    ];
    return rows;
  }

  static Future<TopicActivityCapability> _formulaLibraryRow(
    String topicId,
    String stage,
    FormulaStageEntry? entry,
  ) async {
    final categories = formulaCategoriesForTopic[topicId] ?? const {};
    final wantedIds = entry?.formulaIds.toSet() ?? const <String>{};
    final matching = wantedIds.isEmpty
        ? const <FormulaEntry>[]
        : (await FormulaLibraryService.instance.load())
            .where((f) =>
                wantedIds.contains(f.id) && categories.contains(f.category))
            .toList();
    final available = matching.isNotEmpty;
    final formulaIds = [for (final f in matching) f.id];
    return TopicActivityCapability(
      topicId: topicId,
      stage: stage,
      section: TopicActivitySection.learn,
      activityType: TopicActivityType.formulaLibrary,
      route: '/formulas',
      routeExtra: {'formulaIds': formulaIds},
      available: available,
      reason: categories.isEmpty
          ? 'No relevant formulas in the library for this topic.'
          : !available
              ? 'No formulas have stage evidence for this topic at $stage.'
              : '${matching.length} relevant formula${matching.length == 1 ? '' : 's'} in the library.',
      evidence: available ? entry!.stageEvidence : null,
    );
  }

  static Future<TopicActivityCapability> _recallCardsRow(
    String topicId,
    String stage,
    StageEvidence? stageEvidence,
  ) async {
    final cards = (await RecallCardCatalogService.instance.all())
        .where((c) => c.relatedPracticeTopicIds.contains(topicId))
        .toList();
    final available = stageEvidence != null && cards.isNotEmpty;
    return TopicActivityCapability(
      topicId: topicId,
      stage: stage,
      section: TopicActivitySection.learn,
      activityType: TopicActivityType.recallCards,
      route: '/math-studio/recall-cards/browse',
      routeExtra: {'practiceTopicId': topicId},
      available: available,
      reason: cards.isEmpty
          ? 'No Recall Cards are tagged for this topic.'
          : !available
              ? 'Recall Cards exist, but none have stage evidence for $stage.'
              : '${cards.length} Recall Card${cards.length == 1 ? '' : 's'} support this topic.',
      evidence: available ? stageEvidence : null,
    );
  }

  static List<TopicActivityCapability> _interactiveLabRows(
    String topicId,
    String stage,
    List<LabStageEntry> stageEntries,
  ) {
    final matches = [
      for (final entry in labTopicIds.entries)
        if (entry.value.contains(topicId)) entry.key,
    ];
    if (matches.isEmpty) {
      return [
        TopicActivityCapability(
          topicId: topicId,
          stage: stage,
          section: TopicActivitySection.explore,
          activityType: TopicActivityType.interactiveLab,
          route: '',
          routeExtra: const {},
          available: false,
          reason: 'No Interactive Lab is mapped to this topic.',
        ),
      ];
    }
    final byLab = {for (final e in stageEntries) e.labId: e};
    return [
      for (final labId in matches)
        TopicActivityCapability(
          topicId: topicId,
          stage: stage,
          section: TopicActivitySection.explore,
          activityType: TopicActivityType.interactiveLab,
          route: labRoutes[labId]!,
          routeExtra: const {},
          available: byLab.containsKey(labId),
          reason: byLab.containsKey(labId)
              ? '${labId.name} is mapped to this topic and stage.'
              : '${labId.name} is mapped to this topic, but has no stage '
                  'evidence for $stage.',
          supportingId: labId.name,
          scope: byLab[labId]?.scope,
          evidence: byLab[labId]?.stageEvidence,
        ),
    ];
  }

  static List<TopicActivityCapability> _supportingActivityRows(
    String topicId,
    String stage,
    List<ActivityStageEntry> entries,
  ) =>
      [
        for (final entry in entries)
          TopicActivityCapability(
            topicId: topicId,
            stage: stage,
            section: TopicActivitySection.explore,
            activityType: TopicActivityType.supportingActivity,
            route: supportingActivityRoutes[entry.activityId]!,
            routeExtra: const {},
            available: true,
            reason: '${entry.activityId.name} has stage evidence for this '
                'topic at $stage.',
            supportingId: entry.activityId.name,
            scope: entry.scope,
            evidence: entry.stageEvidence,
          ),
      ];
}
