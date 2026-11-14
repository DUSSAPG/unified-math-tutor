import '../models/interactive_lab_id.dart';

/// Topic Hub Coverage Truth Repair V1 — the per-item, stage-evidenced
/// eligibility table for every piece of *supporting learning* (Formula
/// Library items, Recall Cards, Interactive Labs and other Math Studio
/// activities) the Topic Learning Hub may show for a (topic, stage) cell.
///
/// # Why this exists
/// Before this repair, `TopicCapabilityResolver` showed supporting learning
/// only when the cell also had topic-specific MCQs ("MCQ-only gate"). That
/// both hid real, stage-appropriate content from cells with no MCQs and
/// showed GCSE-level material at KS5 purely because KS5 MCQs existed.
///
/// Supporting learning is now resolved from this table alone — never from
/// MCQ availability — and every row records *why* it is allowed at that
/// stage ([SupportingEvidenceBasis] + a human-readable evidence string).
/// A (topic, stage, item) combination absent from this table is never
/// shown. There is no fallback, no generic card, and no companion-app
/// (Applied Maths Studio / Football Studio) entry of any kind in this
/// table: companion bindings need their own explicit mapping contract.
///
/// Supporting learning never counts as topic-specific MCQ coverage and
/// never claims formal curriculum coverage of a whole stage — the Hub
/// always renders it beneath an explicit stage-status message.
enum SupportingEvidenceBasis {
  /// The item's own shipped metadata names this stage — e.g.
  /// `assets/config/studio_content_registry.json` `curriculumRefs`, or a
  /// Recall Card's GCSE `curriculumTags` (GCSE = KS4).
  curriculumTagged,

  /// A code-verified repository audit maps this exact activity to this
  /// stage (`docs/learning_architecture/STUDIO_ACTIVITY_CURRICULUM_LINK_AUDIT_V1.md`)
  /// or the activity's own source fixes its scope (e.g. the Abacus model).
  codeVerifiedAudit,

  /// Each listed formula is a named statement in the National Curriculum
  /// in England programme of study / GCSE subject content for this stage.
  programmeOfStudy,

  /// Exposure already shown at integration base c7b3e7f next to verified
  /// MCQs at KS2-KS4, retained unchanged by this repair. This is NOT a new
  /// stage claim — it is recorded so the exposure is explicit and auditable
  /// rather than implied by an MCQ gate. Never used at KS5.
  legacyRetained,
}

/// Math Studio activities that are not Interactive Labs (and so have no
/// [InteractiveLabId]) but are verified supporting learning for a cell.
enum SupportingActivityId {
  interactiveAbacus,
  cubeNets,
  shapePropertiesPuzzles,
  transformations,
  rotations,
}

/// go_router destinations for [SupportingActivityId]. All live under the
/// top-level `/math-studio` route (outside the StatefulShellRoute), so a
/// `push` from the Hub is the same safe pattern used for Interactive Labs.
const Map<SupportingActivityId, String> supportingActivityRoutes = {
  SupportingActivityId.interactiveAbacus: '/math-studio/visual-maths/abacus',
  SupportingActivityId.cubeNets: '/math-studio/spatial-intelligence/cube-nets',
  // Only the three face/edge/vertex puzzles — see SpatialPuzzleSet.
  SupportingActivityId.shapePropertiesPuzzles:
      '/math-studio/spatial-intelligence/spatial-puzzles?set=shape-properties',
  SupportingActivityId.transformations:
      '/math-studio/spatial-intelligence/transformations',
  SupportingActivityId.rotations: '/math-studio/spatial-intelligence/rotations',
};

/// Learner-facing scope statement for a supporting row. Mapped to copy by
/// the Hub screen; describes exactly what the item contains, never a
/// coverage claim.
enum SupportingScope {
  numberLineExplorer,
  interactiveAbacus,
  cubeNets,
  shapePropertiesPuzzles,
  transformations,
  rotations,
  dataDetective,
  aircraftLanding,
}

/// Whether a (topic, stage) cell has topic-specific MCQs, is a genuine
/// content gap, or is outside the app's current product scope
/// ([noPlannedActivity] — a product decision, not a curriculum ruling).
enum TopicStageStatus { mcqAvailable, contentGap, noPlannedActivity }

class StageEvidence {
  const StageEvidence(this.basis, this.evidence);

  final SupportingEvidenceBasis basis;
  final String evidence;
}

class FormulaStageEntry {
  const FormulaStageEntry(this.formulaIds, this.stageEvidence);

  final List<String> formulaIds;
  final StageEvidence stageEvidence;
}

class LabStageEntry {
  const LabStageEntry(this.labId, this.stageEvidence, {this.scope});

  final InteractiveLabId labId;
  final StageEvidence stageEvidence;
  final SupportingScope? scope;
}

class ActivityStageEntry {
  const ActivityStageEntry(this.activityId, this.stageEvidence, this.scope);

  final SupportingActivityId activityId;
  final StageEvidence stageEvidence;
  final SupportingScope scope;
}

/// Everything a single (topic, stage) cell may show as supporting learning.
class SupportingLearningCell {
  const SupportingLearningCell({
    this.formulas,
    this.recallCards,
    this.labs = const [],
    this.activities = const [],
  });

  final FormulaStageEntry? formulas;

  /// Recall Cards are shown as one Topic-filtered browse row; this records
  /// whether that row is allowed at this stage and why.
  final StageEvidence? recallCards;
  final List<LabStageEntry> labs;
  final List<ActivityStageEntry> activities;

  bool get isEmpty =>
      formulas == null &&
      recallCards == null &&
      labs.isEmpty &&
      activities.isEmpty;
}

class TopicSupportingLearningRegistry {
  TopicSupportingLearningRegistry._();

  static const _empty = SupportingLearningCell();

  static SupportingLearningCell cellFor(String topicId, String stage) =>
      cells[(topicId, stage)] ?? _empty;

  /// (topic, stage) cells outside the app's current product scope: no
  /// learning activity is planned for them. Shown as "No planned learning
  /// activity for this stage".
  ///
  /// This is a PRODUCT-SCOPE decision, not a curriculum ruling. No official
  /// curriculum source is recorded for these cells (each is an absence, and
  /// no official document states an absence verbatim), so neither this map
  /// nor the learner-facing copy may claim what a stage's curriculum does
  /// or does not contain. The value is the internal product rationale.
  static const Map<(String, String), String> noPlannedActivity = {
    ('number_place_value', 'KS5'):
        'Product scope: no standalone KS5 number / place-value activity.',
    ('fractions', 'KS5'):
        'Product scope: no standalone KS5 fractions activity.',
    ('decimals', 'KS5'): 'Product scope: no standalone KS5 decimals activity.',
    ('percentages', 'KS5'):
        'Product scope: no standalone KS5 percentages activity.',
    ('ratio_proportion', 'KS5'):
        'Product scope: no standalone KS5 ratio activity.',
    ('calculus', 'KS2'): 'Product scope: no calculus activity at KS2.',
    ('calculus', 'KS3'): 'Product scope: no calculus activity at KS3.',
    ('calculus', 'KS4'): 'Product scope: no calculus activity at KS4.',
    ('trigonometry', 'KS2'): 'Product scope: no trigonometry activity at KS2.',
  };

  static const _legacy = StageEvidence(
    SupportingEvidenceBasis.legacyRetained,
    'Shown at integration base c7b3e7f alongside verified MCQs; retained '
    'unchanged. Not a new stage claim.',
  );

  static const _gcseRecall = StageEvidence(
    SupportingEvidenceBasis.curriculumTagged,
    'assets/config/recall_cards.json curriculumTags are gcseFoundation / '
    'gcseHigher / igcse only (GCSE = KS4).',
  );

  static const _gcseLab = StageEvidence(
    SupportingEvidenceBasis.curriculumTagged,
    'assets/config/studio_content_registry.json curriculumRefs include a '
    'GCSE tier (GCSE = KS4).',
  );

  static const _fractionsFormulas = [
    'fractions_adding',
    'fractions_multiplying',
    'fractions_dividing',
  ];
  static const _percentageFormulas = [
    'percentage_of_amount',
    'percentage_change',
  ];
  static const _algebraFormulas = [
    'algebra_difference_of_squares',
    'algebra_perfect_square',
    'algebra_quadratic_formula',
  ];
  static const _geometryKs4Formulas = [
    'area_rectangle',
    'area_triangle',
    'area_parallelogram',
    'area_trapezium',
    'volume_cuboid',
    'volume_cylinder',
    'volume_sphere',
    'volume_cone',
    'circle_circumference',
    'circle_area',
    'circle_arc_length',
    'pythagoras_theorem',
    'coordinate_gradient',
    'coordinate_distance',
    'coordinate_midpoint',
  ];
  static const _statisticsKs4Formulas = [
    'probability_basic',
    'probability_combined_and',
    'statistics_mean',
    'statistics_range',
  ];

  /// The complete eligibility table. KS5 deliberately has no supporting
  /// entries: no supporting item carries KS5 stage evidence today (the
  /// GCSE-tagged Recall Cards, the GCSE formulas, Aircraft Landing, Data
  /// Detective and Football Precision are all KS3/KS4 material).
  static const Map<(String, String), SupportingLearningCell> cells = {
    // ── Number & Place Value ────────────────────────────────────────────
    // Approved cell 1 (no topic-specific MCQs at KS2).
    ('number_place_value', 'KS2'): SupportingLearningCell(
      labs: [
        LabStageEntry(
          InteractiveLabId.numberLineExplorer,
          StageEvidence(
            SupportingEvidenceBasis.curriculumTagged,
            'studio_content_registry.json lab-number-line-explorer '
            "curriculumRefs ['ks2', 'gcse-foundation']; challenge set in "
            'number_line_explorer_screen.dart: whole numbers 0-20, halves, '
            'quarters, negatives -10..10.',
          ),
          scope: SupportingScope.numberLineExplorer,
        ),
      ],
      activities: [
        ActivityStageEntry(
          SupportingActivityId.interactiveAbacus,
          StageEvidence(
            SupportingEvidenceBasis.codeVerifiedAudit,
            'abacus_state.dart: 3 rods (hundreds/tens/ones), beadsPerRod = 9 '
            '-> values 0-999 (Year 3 three-digit place value); '
            'STUDIO_ACTIVITY_CURRICULUM_LINK_AUDIT_V1.md row 1: early '
            'KS1/lower-KS2 place value, not KS2-wide coverage.',
          ),
          SupportingScope.interactiveAbacus,
        ),
      ],
    ),
    ('number_place_value', 'KS3'): SupportingLearningCell(
      recallCards: _legacy,
      labs: [LabStageEntry(InteractiveLabId.numberLineExplorer, _legacy)],
    ),
    ('number_place_value', 'KS4'): SupportingLearningCell(
      recallCards: _gcseRecall,
      labs: [LabStageEntry(InteractiveLabId.numberLineExplorer, _gcseLab)],
    ),

    // ── Fractions ───────────────────────────────────────────────────────
    ('fractions', 'KS2'): SupportingLearningCell(
      formulas: FormulaStageEntry(_fractionsFormulas, _legacy),
      recallCards: _legacy,
      labs: [LabStageEntry(InteractiveLabId.fractionBuilder, _legacy)],
    ),
    ('fractions', 'KS3'): SupportingLearningCell(
      formulas: FormulaStageEntry(_fractionsFormulas, _legacy),
      recallCards: _legacy,
      labs: [LabStageEntry(InteractiveLabId.fractionBuilder, _legacy)],
    ),
    ('fractions', 'KS4'): SupportingLearningCell(
      formulas: FormulaStageEntry(_fractionsFormulas, _legacy),
      recallCards: _gcseRecall,
      labs: [LabStageEntry(InteractiveLabId.fractionBuilder, _gcseLab)],
    ),

    // ── Decimals ────────────────────────────────────────────────────────
    ('decimals', 'KS2'): SupportingLearningCell(recallCards: _legacy),
    ('decimals', 'KS3'): SupportingLearningCell(recallCards: _legacy),
    ('decimals', 'KS4'): SupportingLearningCell(recallCards: _gcseRecall),

    // ── Percentages ─────────────────────────────────────────────────────
    ('percentages', 'KS2'): SupportingLearningCell(
      formulas: FormulaStageEntry(_percentageFormulas, _legacy),
      recallCards: _legacy,
    ),
    ('percentages', 'KS3'): SupportingLearningCell(
      formulas: FormulaStageEntry(_percentageFormulas, _legacy),
      recallCards: _legacy,
    ),
    ('percentages', 'KS4'): SupportingLearningCell(
      formulas: FormulaStageEntry(_percentageFormulas, _legacy),
      recallCards: _gcseRecall,
    ),

    // ── Ratio & Proportion ──────────────────────────────────────────────
    ('ratio_proportion', 'KS3'): SupportingLearningCell(recallCards: _legacy),
    ('ratio_proportion', 'KS4'):
        SupportingLearningCell(recallCards: _gcseRecall),

    // ── Algebra ─────────────────────────────────────────────────────────
    ('algebra', 'KS3'): SupportingLearningCell(
      formulas: FormulaStageEntry(_algebraFormulas, _legacy),
      recallCards: _legacy,
      labs: [LabStageEntry(InteractiveLabId.algebraBalance, _legacy)],
    ),
    ('algebra', 'KS4'): SupportingLearningCell(
      formulas: FormulaStageEntry(_algebraFormulas, _legacy),
      recallCards: _gcseRecall,
      labs: [LabStageEntry(InteractiveLabId.algebraBalance, _gcseLab)],
    ),

    // ── Geometry & Measures ─────────────────────────────────────────────
    // Approved cell 2 (no topic-specific MCQs at KS2).
    ('geometry_measures', 'KS2'): SupportingLearningCell(
      activities: [
        ActivityStageEntry(
          SupportingActivityId.cubeNets,
          StageEvidence(
            SupportingEvidenceBasis.codeVerifiedAudit,
            'STUDIO_ACTIVITY_CURRICULUM_LINK_AUDIT_V1.md row 3: Cube Nets — '
            'nets of 3D solids, KS2 (4 fixed nets).',
          ),
          SupportingScope.cubeNets,
        ),
        ActivityStageEntry(
          SupportingActivityId.shapePropertiesPuzzles,
          StageEvidence(
            SupportingEvidenceBasis.codeVerifiedAudit,
            'STUDIO_ACTIVITY_CURRICULUM_LINK_AUDIT_V1.md row 6: only the '
            'face/edge/vertex Spatial Puzzles subset is defensible at KS2; '
            'served via SpatialPuzzleSet.shapeProperties (3 puzzles).',
          ),
          SupportingScope.shapePropertiesPuzzles,
        ),
      ],
    ),
    // Approved cell 3 (no topic-specific MCQs at KS3).
    ('geometry_measures', 'KS3'): SupportingLearningCell(
      formulas: FormulaStageEntry(
        [
          'area_rectangle',
          'area_triangle',
          'area_parallelogram',
          'area_trapezium',
          'volume_cuboid',
          'volume_cylinder',
          'circle_circumference',
          'circle_area',
          'pythagoras_theorem',
        ],
        StageEvidence(
          SupportingEvidenceBasis.programmeOfStudy,
          'KS3 programme of study (DfE 2013), Geometry and measures: area of '
          'triangles, parallelograms, trapezia; volume of cuboids and prisms '
          'including cylinders; perimeter/area of circles; Pythagoras. '
          'Excludes sphere, cone, arc length and coordinate formulas.',
        ),
      ),
      activities: [
        ActivityStageEntry(
          SupportingActivityId.transformations,
          StageEvidence(
            SupportingEvidenceBasis.codeVerifiedAudit,
            'STUDIO_ACTIVITY_CURRICULUM_LINK_AUDIT_V1.md row 5: '
            'translate/reflect/rotate/enlarge — KS3 (enlargement).',
          ),
          SupportingScope.transformations,
        ),
        ActivityStageEntry(
          SupportingActivityId.rotations,
          StageEvidence(
            SupportingEvidenceBasis.codeVerifiedAudit,
            'STUDIO_ACTIVITY_CURRICULUM_LINK_AUDIT_V1.md row 4: rotation '
            'about a centre with angle control — KS3.',
          ),
          SupportingScope.rotations,
        ),
      ],
    ),
    ('geometry_measures', 'KS4'): SupportingLearningCell(
      formulas: FormulaStageEntry(_geometryKs4Formulas, _legacy),
      recallCards: _gcseRecall,
      labs: [
        LabStageEntry(InteractiveLabId.flightPathLab, _gcseLab),
        LabStageEntry(InteractiveLabId.footballPrecision, _gcseLab),
        LabStageEntry(InteractiveLabId.mazeDriver, _gcseLab),
        LabStageEntry(InteractiveLabId.aircraftLandingLab, _gcseLab),
      ],
    ),

    // ── Statistics & Probability ────────────────────────────────────────
    // Approved cell 4 (no topic-specific MCQs at KS3).
    ('statistics_probability', 'KS3'): SupportingLearningCell(
      formulas: FormulaStageEntry(
        ['probability_basic', 'statistics_mean', 'statistics_range'],
        StageEvidence(
          SupportingEvidenceBasis.programmeOfStudy,
          'KS3 programme of study (DfE 2013), Statistics: mean and range; '
          'Probability: outcomes and probabilities of single events.',
        ),
      ),
      labs: [
        LabStageEntry(
          InteractiveLabId.dataDetective,
          StageEvidence(
            SupportingEvidenceBasis.codeVerifiedAudit,
            'STUDIO_ACTIVITY_CURRICULUM_LINK_AUDIT_V1.md row 8: mean, median '
            'and outlier effects — KS3-KS4, directly confirmed in code.',
          ),
          scope: SupportingScope.dataDetective,
        ),
      ],
    ),
    ('statistics_probability', 'KS4'): SupportingLearningCell(
      formulas: FormulaStageEntry(_statisticsKs4Formulas, _legacy),
      recallCards: _gcseRecall,
      labs: [
        LabStageEntry(InteractiveLabId.footballPrecision, _gcseLab),
        LabStageEntry(InteractiveLabId.dataDetective, _gcseLab),
      ],
    ),

    // ── Trigonometry ────────────────────────────────────────────────────
    // Approved cell 5 (no topic-specific MCQs at KS4).
    ('trigonometry', 'KS4'): SupportingLearningCell(
      formulas: FormulaStageEntry(
        ['trig_sohcahtoa', 'trig_sine_rule', 'trig_cosine_rule'],
        StageEvidence(
          SupportingEvidenceBasis.programmeOfStudy,
          'GCSE mathematics subject content (DfE 2013): trigonometric ratios '
          'in right-angled triangles; sine and cosine rules (higher tier).',
        ),
      ),
      labs: [
        LabStageEntry(
          InteractiveLabId.aircraftLandingLab,
          StageEvidence(
            SupportingEvidenceBasis.curriculumTagged,
            "studio_content_registry.json lab-aircraft-landing curriculumRefs "
            "['gcse-higher']; descent-line / glide-path / vector-approach "
            'sub-missions declare practiceTopicIds trigonometry.',
          ),
          scope: SupportingScope.aircraftLanding,
        ),
      ],
    ),
  };
}
