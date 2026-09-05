/// D2 — the one explicit, evidence-backed mapping from a learner's Topic
/// Drill selection (a canonical topic id, as already used by
/// `TopicCatalogService`/`topics_screen.dart`) to the raw `skill`/`strand`
/// values that actually appear in each stage's pack content.
///
/// This deliberately replaces `TopicCatalogService.idForRawLabel`'s fuzzy,
/// generic-English-alias matching for the purpose of *filtering practice
/// content* — that matching was audited (Part C coverage matrix,
/// `build/audit/part_c_coverage_matrix.json`) and found to resolve 0% of
/// KS2 and 17.5% of KS3 raw topic values, silently returning empty Topic
/// Drill results. `TopicCatalogService` itself is untouched and still owns
/// *display* (topic id -> localized title), which was never the broken
/// part.
///
/// P0 content-integrity repair (2026-09-05): [PracticeAvailabilityResolver]
/// no longer calls [canonicalTopicForRawValue] at query time — every pack
/// row now carries a `topicId` tag baked in once by
/// `tool/retag_practice_packs.dart`, using this exact same evidence, and
/// the resolver filters on that tag directly (a plain equality check,
/// nothing left to re-derive or drift). This file's role is now: (1) the
/// human-readable evidence record for that migration, (2) still directly
/// exercised by test/practice_topic_mapping_test.dart, and (3) the
/// comparison target for
/// test/practice_topic_mapping_pack_tag_drift_test.dart, which proves every
/// tagged row's `topicId` agrees with what this mapping would produce for
/// its raw `skill`/`strand` value — so this file and the shipped packs can
/// never silently disagree. `canonicalTopicIds` (below) is still live,
/// directly imported by `topic_capability_resolver.dart`.
///
/// # Rules
/// * Every entry here is explicit data, verified against the actual raw
///   `skill`/`strand` distribution in the shipped packs — never a
///   normalize-and-guess string match.
/// * A stage never inherits another stage's mapping, even where a raw
///   label string happens to look the same.
/// * A raw value with no entry is an intentional "unavailable" outcome for
///   Topic Drill, not a fallback to a similar-looking topic. Two raw
///   values are deliberately left unmapped despite being real, sizeable
///   content — [intentionallyUnmappedRawValues] documents exactly why.
/// * KS4/KS5 additionally use a finer `skill`-level override, but only
///   where the skill name is itself unambiguous, enumerated evidence (not
///   a keyword/fuzzy rule) — see [_ks4SkillOverrides] / [_ks5SkillOverrides].
library;

/// The canonical topic ids a learner can select from — identical to
/// `assets/config/topic_catalog.json`'s existing 11 entries. D2 does not
/// introduce new learner-facing topic categories (e.g. a separate
/// "Operations" or "Mechanics" card) — that would be a Topics-screen UI
/// change, out of this sprint's "smallest necessary" boundary. Content
/// that would need a new category to be reachable stays honestly
/// unavailable and is reported as a genuine gap instead.
const Set<String> canonicalTopicIds = {
  'number_place_value',
  'fractions',
  'decimals',
  'percentages',
  'ratio_proportion',
  'algebra',
  'geometry_measures',
  'statistics_probability',
  'calculus',
  'trigonometry',
  'mixed_review',
};

/// Stage-scoped raw-value -> canonical-topic-id table, keyed by the field
/// each stage's pack rows actually use for topic-level grouping:
/// KS2/KS3 -> `skill`; KS4/KS5 -> `strand`.
const Map<String, Map<String, String>> _stageStrandOrSkillMap = {
  'KS2': {
    'fractions_of_amount': 'fractions',
    // 'addition_subtraction' / 'multiplication_division' intentionally
    // absent — see [intentionallyUnmappedRawValues].
  },
  'KS3': {
    'integers_directed_numbers': 'number_place_value',
    'linear_equations_basic': 'algebra',
    'algebra_simplify_substitute': 'algebra',
    'ratio_proportion': 'ratio_proportion',
    'sequences_linear': 'algebra',
    // 'fractions_decimals_percent' intentionally absent — fused bucket,
    // see [intentionallyUnmappedRawValues].
  },
  'KS4': {
    'Number': 'number_place_value',
    'Algebra': 'algebra',
    'Geometry_Measures': 'geometry_measures',
    'Statistics_Probability': 'statistics_probability',
    'Ratio_Proportion': 'ratio_proportion',
  },
  'KS5': {
    'Calculus': 'calculus',
    'Pure_Calculus': 'calculus', // same subject, inconsistent source naming
    'Statistics': 'statistics_probability',
    // 'Mechanics' intentionally absent — no matching UI topic exists (Part
    // B: "do not force Mechanics into an unrelated existing topic").
    // 'Pure_Algebra_Trig' intentionally absent at the strand level — see
    // _ks5SkillOverrides for its skill-level resolution instead.
  },
};

/// KS4's `strand` field maps cleanly, but real fractions/percentages
/// content is hidden inside the generic `Number` strand alongside unrelated
/// skills (rounding, HCF/LCM). These are the exact (skill name -> topic)
/// pairs confirmed against the shipped pack's own skill distribution —
/// every skill under `Number` was individually reviewed, not pattern-matched.
const Map<String, String> _ks4SkillOverrides = {
  'Fractions of a quantity': 'fractions',
  'Fractions add/subtract': 'fractions',
  'Fractions multiply/divide': 'fractions',
  'Percentage change': 'percentages',
  'Percent of an amount': 'percentages',
};

/// `Pure_Algebra_Trig` is a fused KS5 strand name, but every one of its 494
/// rows carries one of exactly these three skill values — confirmed by
/// enumerating the strand's full skill distribution (Part C fused-bucket
/// evidence). None of them are actually algebra; all three are
/// unambiguously trigonometry. This is an exact enumerated lookup, not a
/// keyword rule — a skill name absent from this table is not trigonometry
/// by assumption.
const Map<String, String> _ks5SkillOverrides = {
  'Trig identities & rearranging': 'trigonometry',
  'Solve trig equations': 'trigonometry',
  'Radians + arc length/sector area': 'trigonometry',
};

/// Raw values deliberately left unmapped for Topic Drill, with the evidence
/// for why — real content exists, but it cannot be honestly routed to a
/// single existing UI topic without either forcing an unrelated label onto
/// it or inferring a split from question wording, which this deterministic,
/// evidence-first mapping does not do. This content remains reachable via
/// Quick Start (which never applies a topic filter) — it is not lost, only
/// not selectable by topic today.
const Map<String, String> intentionallyUnmappedRawValues = {
  'KS2:addition_subtraction':
      'Real Number-strand content, but no raw KS2 skill value maps to a '
          'single distinguishing topic beyond "fractions" — left unmapped '
          'rather than guessed onto number_place_value without the same '
          'per-skill evidence KS4 has.',
  'KS2:multiplication_division': 'Same reasoning as addition_subtraction.',
  'KS3:fractions_decimals_percent':
      'A fused bucket spanning fractions/decimals/percentages with no '
          'finer structured field to disambiguate (unlike KS5\'s '
          'Pure_Algebra_Trig, this stage\'s skill field IS the fused bucket '
          'name itself) — splitting it would require inferring from '
          'question wording, which this mapping deliberately does not do.',
  'KS5:Mechanics': 'Real, substantial content (863 questions) with no matching '
      'canonical topic in the current 11-topic UI — adding a Mechanics '
      'topic card is a Topics-screen change, out of D2\'s scope.',
};

/// Resolves one raw pack value to a canonical topic id for Topic Drill
/// filtering, or `null` for an intentional "unavailable" outcome. Never
/// throws, never guesses across stages.
String? canonicalTopicForRawValue({
  required String stage,
  required String? rawStrandOrSkillGroup,
  String? rawFineSkill,
}) {
  if (stage == 'KS4' && rawFineSkill != null) {
    final override = _ks4SkillOverrides[rawFineSkill];
    if (override != null) return override;
  }
  if (stage == 'KS5' && rawFineSkill != null) {
    final override = _ks5SkillOverrides[rawFineSkill];
    if (override != null) return override;
  }
  if (rawStrandOrSkillGroup == null) return null;
  return _stageStrandOrSkillMap[stage]?[rawStrandOrSkillGroup];
}

/// The pack-row field that carries the value [canonicalTopicForRawValue]'s
/// `rawStrandOrSkillGroup` parameter expects, per stage — KS2/KS3 group by
/// `skill`; KS4/KS5 group by the broader `strand` (with `skill` used
/// separately, and only for the stages/rows in [_ks4SkillOverrides] /
/// [_ks5SkillOverrides], as the finer override key).
String groupingFieldFor(String stage) =>
    (stage == 'KS4' || stage == 'KS5') ? 'strand' : 'skill';
