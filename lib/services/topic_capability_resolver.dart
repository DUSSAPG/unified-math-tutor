import '../core/practice_topic_mapping.dart' show canonicalTopicIds;
import '../models/interactive_lab_id.dart';
import 'formula_library_service.dart';
import 'practice_availability_resolver.dart';
import 'recall_card_catalog_service.dart';

/// D3 — the Topic Learning Hub's single source of truth for "what can a
/// learner genuinely do with this topic, at this stage." Every other file
/// in the hub (the screen, its tests) consumes [TopicCapabilityResolver
/// .resolve] rather than re-deriving availability itself — see the sprint
/// report's "Data Contract" requirement.
///
/// # Design principle: where does stage-eligibility come from?
/// Practice content (Topic Drill, Quick Start) already carries real,
/// per-stage evidence via [PracticeAvailabilityResolver] — the same D1/D2
/// pipeline audited in topic_drill_truthfulness_test.dart. Formula Library,
/// Recall Cards and Interactive Labs carry no such per-stage tag of their
/// own (their content is stage-agnostic reference/practice material). Bolting
/// on a second, hand-authored stage tag for each would be exactly the kind
/// of unverifiable guess this app has repeatedly had to correct — so instead
/// this resolver gates all three on the SAME already-audited signal:
/// "does this topic have real Topic Drill content at this stage?" A topic
/// with no real Topic Drill content at a stage gets no supporting-material
/// cards at that stage either, since there is nothing at that stage for
/// them to support. This is a documented, deterministic, auditable rule —
/// never a fabrication of new stage data.
enum TopicActivitySection { practise, learn, explore, workbook }

enum TopicActivityType {
  topicDrill,
  quickStart,
  formulaLibrary,
  recallCards,
  interactiveLab,
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
  });

  final String topicId;
  final String stage;
  final TopicActivitySection section;
  final TopicActivityType activityType;
  final String route;
  final Map<String, dynamic> routeExtra;
  final bool available;

  /// A short, truthful, human-readable explanation — used both as the
  /// audit record and (for unavailable rows a screen chooses to surface)
  /// as learner-facing copy. Never claims content exists when it does not.
  final String reason;

  /// Optional identifier for the specific formula/lab/recall-card evidence
  /// behind this row — e.g. an [InteractiveLabId] name, a formula
  /// category, or null for rows that aggregate a count (Formula Library,
  /// Recall Cards) rather than pointing at one item.
  final String? supportingId;
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
  /// earlyMathsPlayground currently fall in that category.
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
  /// grouped by canonical topic id — built by reading every category the
  /// catalog actually contains (Algebra, Area, Circle, Coordinate Geometry,
  /// Fractions, Percentages, Probability, Pythagoras, Statistics,
  /// Trigonometry, Volume) and assigning each to the topic it belongs to.
  /// A topic with no entry here (number_place_value, ratio_proportion,
  /// decimals) genuinely has zero relevant formulas in the catalog today.
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

  /// Resolves every activity row for [topicId] at [stage]. Always returns
  /// one row each for topicDrill/quickStart/formulaLibrary/recallCards/
  /// workbook, plus one row per genuinely-linked Interactive Lab (or one
  /// unavailable row if none is linked) — never zero rows for a section,
  /// so an audit always sees why a section is empty.
  static Future<List<TopicActivityCapability>> resolve({
    required String topicId,
    required String stage,
  }) async {
    final topicDrillOutcome =
        await PracticeAvailabilityResolver.resolveTopicDrill(stage, topicId);
    final topicDrillReady = topicDrillOutcome is PracticeLoadReady;
    final topicDrillCount = topicDrillOutcome is PracticeLoadReady
        ? topicDrillOutcome.records.length
        : 0;

    final quickStartOutcome =
        await PracticeAvailabilityResolver.resolveQuickStart(stage);
    final quickStartReady = quickStartOutcome is PracticeLoadReady;
    final quickStartCount = quickStartOutcome is PracticeLoadReady
        ? quickStartOutcome.records.length
        : 0;

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
        // stack ambiguity across shell branches. Same topicId value here,
        // but kept as its own key since quickStart below has no filtering
        // topicId at all yet still needs a Hub to return to.
        routeExtra: {
          'topicId': topicId,
          'stage': stage,
          'returnToHubTopicId': topicId,
        },
        available: topicDrillReady,
        reason: topicDrillReady
            ? '$topicDrillCount real question${topicDrillCount == 1 ? '' : 's'} available for $stage.'
            : 'No real questions exist for this topic at $stage yet.',
      ),
      TopicActivityCapability(
        topicId: topicId,
        stage: stage,
        section: TopicActivitySection.practise,
        activityType: TopicActivityType.quickStart,
        route: '/practice',
        // No 'topicId' here deliberately — resolveQuickStart draws from the
        // whole stage's mixed pool, never filtered by topic (see the resolve
        // call above). 'returnToHubTopicId' is unrelated to that filtering:
        // it's only which Hub Back should return to.
        routeExtra: {
          'stage': stage,
          'preselectQuickStart': true,
          'returnToHubTopicId': topicId,
        },
        available: quickStartReady,
        reason: quickStartReady
            ? '$quickStartCount real question${quickStartCount == 1 ? '' : 's'} in the $stage pool.'
            : 'No real questions exist for $stage yet.',
      ),
      await _formulaLibraryRow(topicId, stage, topicDrillReady),
      await _recallCardsRow(topicId, stage, topicDrillReady),
      TopicActivityCapability(
        topicId: topicId,
        stage: stage,
        section: TopicActivitySection.workbook,
        activityType: TopicActivityType.workbook,
        route: '',
        routeExtra: const {},
        available: false,
        reason: 'No workbook exists for this topic yet.',
      ),
      ..._interactiveLabRows(topicId, stage, topicDrillReady),
    ];
    return rows;
  }

  static Future<TopicActivityCapability> _formulaLibraryRow(
    String topicId,
    String stage,
    bool topicDrillReady,
  ) async {
    final categories = formulaCategoriesForTopic[topicId] ?? const {};
    final entries = categories.isEmpty
        ? const <FormulaEntry>[]
        : (await FormulaLibraryService.instance.load())
            .where((f) => categories.contains(f.category))
            .toList();
    final available = topicDrillReady && entries.isNotEmpty;
    return TopicActivityCapability(
      topicId: topicId,
      stage: stage,
      section: TopicActivitySection.learn,
      activityType: TopicActivityType.formulaLibrary,
      route: '/formulas',
      routeExtra: {'categories': categories.toList()..sort()},
      available: available,
      reason: entries.isEmpty
          ? 'No relevant formulas in the library for this topic.'
          : !topicDrillReady
              ? 'Formulas exist, but this topic has no real content at $stage.'
              : '${entries.length} relevant formula${entries.length == 1 ? '' : 's'} in the library.',
      // Aggregates a count across possibly several categories — see the
      // class doc on `supportingId`. The category list itself is already
      // carried in routeExtra for navigation.
    );
  }

  static Future<TopicActivityCapability> _recallCardsRow(
    String topicId,
    String stage,
    bool topicDrillReady,
  ) async {
    final cards = (await RecallCardCatalogService.instance.all())
        .where((c) => c.relatedPracticeTopicIds.contains(topicId))
        .toList();
    final available = topicDrillReady && cards.isNotEmpty;
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
          : !topicDrillReady
              ? 'Recall Cards exist, but this topic has no real content at $stage.'
              : '${cards.length} Recall Card${cards.length == 1 ? '' : 's'} support this topic.',
    );
  }

  static List<TopicActivityCapability> _interactiveLabRows(
    String topicId,
    String stage,
    bool topicDrillReady,
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
    return [
      for (final labId in matches)
        TopicActivityCapability(
          topicId: topicId,
          stage: stage,
          section: TopicActivitySection.explore,
          activityType: TopicActivityType.interactiveLab,
          route: labRoutes[labId]!,
          routeExtra: const {},
          available: topicDrillReady,
          reason: topicDrillReady
              ? '${labId.name} is mapped to this topic and stage.'
              : '${labId.name} is mapped to this topic, but it has no real content at $stage.',
          supportingId: labId.name,
        ),
    ];
  }
}
