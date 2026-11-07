// Generates assets/config/curriculum_manifest.json from the real, just-
// retagged pack content (tool/retag_practice_packs.dart must have already
// run) — so every availability/subtopic claim in the manifest is read back
// from actual tagged rows, never hand-typed and never able to silently
// drift from what the packs really contain. Run with:
//   dart run tool/generate_curriculum_manifest.dart
import 'dart:convert';
import 'dart:io';

const manifestVersion = 1;
const curriculumMapping = 'england_national_curriculum';

const decimalProvenanceByStage = {
  'KS2': 'Original questions informed by learning objectives in Math - No '
      'Problem! Fractions and Decimals, Grade 4 Ages 9-10, sections '
      '"Tenths," "Hundredths," "Tenths and Hundredths as Decimals," '
      '"Decimals," and "Rounding Decimals" (PDF pp. 26-36; local metadata '
      'does not identify an individual author). No source question wording '
      'was copied. Decimal content is en-GB only; opt-in de-CH, fr-CH, and '
      'it-CH packs remain without Decimal-tagged rows and unavailable under '
      'exact-topic selection.',
  'KS3': 'Nine original questions informed by Scott Meltzer, Middle School '
      'Math for Parents, Chapter 3, "Understanding Decimals by Unlocking the '
      'Secrets of the Base-Ten System" (place value, fraction conversion, '
      'and decimal operations). Seven existing licensed-bank fused-bucket '
      'fraction-to-decimal conversion questions were individually checked '
      'and retagged; other fused-bucket questions remain untagged. No source '
      'question wording was copied. Decimal content is en-GB only; opt-in '
      'de-CH, fr-CH, and it-CH packs remain without Decimal-tagged rows and '
      'unavailable under exact-topic selection.',
  'KS4': 'Original questions informed by CGP, GCSE Maths Edexcel Revision '
      'Guide Higher, "Rounding Numbers" (p. 14) and "Bounds" (p. 16), with '
      'decimal precision and rounding objectives. No source question wording '
      'was copied. Decimal content is en-GB only; opt-in de-CH, fr-CH, and '
      'it-CH packs remain without Decimal-tagged rows and unavailable under '
      'exact-topic selection.',
};

const fractionProvenanceByStage = {
  'KS3': 'Eighteen original questions (equivalence and simplifying, comparing '
      'and ordering, adding and subtracting, multiplying and dividing, '
      'fractions of an amount, and mixed numbers) informed by Scott Meltzer, '
      'Middle School Math for Parents, Chapter 2, "Fractionphobia" (EPUB, no '
      'stable page numbers; unit fractions, non-unit fractions, mixed '
      'numbers and improper fractions). Consulted for concept verification '
      'only; no source wording or numbers were copied. No legacy KS3 row '
      'was retagged as Fractions: the fused-bucket conversion rows belong '
      'to Decimals and Percentages. Fractions content for KS3 is en-GB '
      'only; opt-in de-CH, fr-CH, and it-CH packs remain without '
      'KS3 Fractions-tagged rows.',
};

const percentageProvenanceByStage = {
  'KS2': 'Fifteen original questions informed by learning objectives in Math '
      '- No Problem! Fractions, Decimals and Percentage, Ages 9-10 (KS2), '
      'Lesson 16 "Percentages" (printed pp. 36-39), and Math - No Problem! '
      'Fractions, Decimals, Percentage and Ratio, Ages 10-11 (KS2), '
      '"Percentages of numbers" (p. 28), "Percentages of quantities" '
      '(p. 30), "Percentages as increases or decreases" (p. 32) and '
      '"Percentages as a comparison" (p. 36). Consulted for concept '
      'verification only; no source wording or numbers were copied. '
      'Percentage content is en-GB only; opt-in de-CH, fr-CH, and it-CH '
      'packs remain without Percentage-tagged rows.',
  'KS3': 'Fifteen original questions informed by Scott Meltzer, Middle '
      'School Math for Parents, Chapter 4, "Percentages: A Special and Very '
      'Common Use of Proportions" (EPUB, no stable page numbers). Five '
      'existing licensed-bank fused-bucket fraction-to-percentage '
      'conversion questions (1/2, 1/4, 1/5, 2/5, 3/4) were individually '
      'checked and retagged unchanged; other fused-bucket questions remain '
      'untagged. Consulted for concept verification only; no source wording '
      'was copied. Percentage content is en-GB only; opt-in de-CH, fr-CH, '
      'and it-CH packs remain without Percentage-tagged rows.',
  'KS4': 'Fifteen original gap-filling questions (reverse percentages, '
      'expressing as a percentage, percentage change and compound '
      'percentage change) informed by CGP, GCSE Maths Edexcel Revision '
      'Guide Higher, Section Four "Percentages" (pp. 64-66) and "Compound '
      'Growth and Decay" (p. 67). Of the 649 pre-existing generated Percentage '
      'rows, 111 were recomputed exactly and retained unchanged; 538 whose '
      'keyed answer is a rounded-down whole number rather than the exact '
      'result were left in the pack unmodified but untagged, so exact-topic '
      'selection never serves them. Consulted for concept '
      'verification only; no source wording was copied. Percentage content '
      'is en-GB only; opt-in de-CH, fr-CH, and it-CH packs remain without '
      'Percentage-tagged rows.',
};

/// The continuous concept graph this sprint's brief requires — EY through
/// Advanced/Enrichment — even though only KS2-KS5 have any shipped pack
/// today. `hasContent: false` stages are declared, not fabricated: no
/// topic-stage record for them claims anything is available.
const stages = [
  {'id': 'early_years', 'order': 0, 'label': 'Early Years', 'packId': null},
  {'id': 'KS1', 'order': 1, 'label': 'Key Stage 1', 'packId': null},
  {'id': 'KS2', 'order': 2, 'label': 'Key Stage 2', 'packId': 'ks2'},
  {'id': 'KS3', 'order': 3, 'label': 'Key Stage 3', 'packId': 'ks3'},
  {'id': 'KS4', 'order': 4, 'label': 'Key Stage 4 (GCSE)', 'packId': 'ks4'},
  {'id': 'KS5', 'order': 5, 'label': 'Key Stage 5 (A-Level)', 'packId': 'ks5'},
  {
    'id': 'advanced_enrichment',
    'order': 6,
    'label': 'Advanced / Enrichment',
    'packId': null,
  },
];

/// title/subtitle copied verbatim from assets/config/topic_catalog.json's
/// 'en' locale — that file remains the canonical *localized display* layer
/// (all locales); these are the single English fallback strings this
/// manifest carries for its own audit/debug purposes, not a second
/// translation surface. strandId groups topics for the future icon system
/// (Part F, deferred) — Number/Algebra/Geometry/Data & Statistics/
/// Probability/Logic & Combinatorics/Computing per this sprint's brief;
/// calculus and trigonometry are placed with their closest conventional
/// family (Algebra, Geometry respectively) since neither is its own
/// icon-language strand.
const topics = [
  {
    'id': 'number_place_value',
    'title': 'Number & Place Value',
    'subtitle': 'Place value, rounding & estimation',
    'strandId': 'number',
  },
  {
    'id': 'fractions',
    'title': 'Fractions',
    'subtitle': 'Operations with fractions',
    'strandId': 'number',
  },
  {
    'id': 'decimals',
    'title': 'Decimals',
    'subtitle': 'Decimal operations & conversions',
    'strandId': 'number',
  },
  {
    'id': 'percentages',
    'title': 'Percentages',
    'subtitle': 'Percentages, increase & decrease',
    'strandId': 'number',
  },
  {
    'id': 'ratio_proportion',
    'title': 'Ratio & Proportion',
    'subtitle': 'Ratios, rates & proportional reasoning',
    'strandId': 'number',
  },
  {
    'id': 'algebra',
    'title': 'Algebra',
    'subtitle': 'Equations, expressions & variables',
    'strandId': 'algebra',
  },
  {
    'id': 'geometry_measures',
    'title': 'Geometry & Measures',
    'subtitle': 'Shapes, angles & spatial reasoning',
    'strandId': 'geometry',
  },
  {
    'id': 'statistics_probability',
    'title': 'Statistics & Probability',
    'subtitle': 'Data handling & probability',
    'strandId': 'data_statistics',
  },
  {
    'id': 'calculus',
    'title': 'Calculus',
    'subtitle': 'Differentiation & integration',
    'strandId': 'algebra',
  },
  {
    'id': 'trigonometry',
    'title': 'Trigonometry',
    'subtitle': 'Sin, cos, tan & triangle geometry',
    'strandId': 'geometry',
  },
  {
    'id': 'mixed_review',
    'title': 'General Practice',
    'subtitle': 'Mixed review across topics',
    'strandId': null,
  },
];

Future<Map<String, List<Map<String, dynamic>>>> _loadTaggedPacks() async {
  final result = <String, List<Map<String, dynamic>>>{};
  const files = {
    'ks2': 'assets/packs/en-GB/KS2_bank_ok_10000.jsonl',
    'ks3': 'assets/packs/en-GB/KS3_bank_ok_10000.jsonl',
    'ks4': 'assets/packs/en-GB/KS4_merged_deduped.jsonl',
    'ks5': 'assets/packs/en-GB/KS5_merged_deduped.jsonl',
  };
  for (final entry in files.entries) {
    final lines = await File(entry.value).readAsLines();
    result[entry.key] = lines
        .where((l) => l.trim().isNotEmpty)
        .map((l) => jsonDecode(l) as Map<String, dynamic>)
        .toList();
  }
  return result;
}

void main() async {
  final packs = await _loadTaggedPacks();

  final topicStageRecords = <Map<String, dynamic>>[];

  for (final topic in topics) {
    final topicId = topic['id'] as String;
    for (final stage in stages) {
      final stageId = stage['id'] as String;
      final packId = stage['packId'] as String?;

      if (topicId == 'mixed_review') {
        // Not a topic-scoped activity — Quick Start's own stage-wide mode,
        // never shown as a Topic Drill card (see
        // topic_capability_resolver.dart's canonicalTopicIds.difference).
        final hasContent = packId != null;
        topicStageRecords.add({
          'topicId': topicId,
          'stage': stageId,
          'curriculumMapping': curriculumMapping,
          'title': topic['title'],
          'subtitle': topic['subtitle'],
          'strandId': topic['strandId'],
          'subtopics': const [],
          'prerequisites': const [],
          'iconKey': 'topic_$topicId',
          'activityAvailability': {
            'topicDrill': 'unavailable',
            'quickStart': hasContent ? 'available' : 'unavailable',
          },
          'questionPackIds': hasContent ? [packId] : const [],
          'selectionPolicy':
              hasContent ? 'stage_wide_no_topic_filter' : 'no_content',
          'provenance': {
            'status':
                hasContent ? 'existing_licensed_bank' : 'no_pack_authored',
            'note': hasContent
                ? 'Deliberately not topic-scoped — this is Quick Start\'s '
                    'own global, no-topic-filter mode for $stageId.'
                : 'No pack exists for $stageId yet.',
          },
          'unavailableMessage': hasContent
              ? null
              : 'General practice isn\'t available for $stageId yet — no '
                  'question pack has been authored for this stage.',
          'feedbackContextId': '$topicId::$stageId',
        });
        continue;
      }

      if (packId == null) {
        topicStageRecords.add({
          'topicId': topicId,
          'stage': stageId,
          'curriculumMapping': curriculumMapping,
          'title': topic['title'],
          'subtitle': topic['subtitle'],
          'strandId': topic['strandId'],
          'subtopics': const [],
          'prerequisites': const [],
          'iconKey': 'topic_$topicId',
          'activityAvailability': {
            'topicDrill': 'unavailable',
            'quickStart': 'unavailable',
          },
          'questionPackIds': const [],
          'selectionPolicy': 'no_content',
          'provenance': {
            'status': 'no_pack_authored',
            'note': 'No question pack exists for $stageId yet — nothing to '
                'tag as ${topic['title']} or otherwise.',
          },
          'unavailableMessage':
              '${topic['title']} practice isn\'t available for $stageId yet '
                  '— no question pack has been authored for this stage.',
          'feedbackContextId': '$topicId::$stageId',
        });
        continue;
      }

      final rows =
          packs[packId]!.where((row) => row['topicId'] == topicId).toList();
      final available = rows.isNotEmpty;
      final decimalProvenance = topicId == 'decimals' && available
          ? decimalProvenanceByStage[stageId]
          : topicId == 'percentages' && available
              ? percentageProvenanceByStage[stageId]
              : topicId == 'fractions' && available
                  ? fractionProvenanceByStage[stageId]
                  : null;
      final decimalProvenanceStatus = topicId == 'fractions'
          ? 'original_content_with_research_attribution'
          : (stageId == 'KS3' || (stageId == 'KS4' && topicId == 'percentages'))
              ? 'mixed_original_and_existing_licensed_bank'
              : 'original_content_with_research_attribution';
      final subtopicIds =
          rows.map((r) => r['subtopicId'] as String).toSet().toList()..sort();

      topicStageRecords.add({
        'topicId': topicId,
        'stage': stageId,
        'curriculumMapping': curriculumMapping,
        'title': topic['title'],
        'subtitle': topic['subtitle'],
        'strandId': topic['strandId'],
        'subtopics': subtopicIds,
        'prerequisites': const [],
        'iconKey': 'topic_$topicId',
        'activityAvailability': {
          'topicDrill': available ? 'available' : 'unavailable',
          // Post-fix policy (this sprint): Quick Start launched from a
          // Topic Hub is exact-topic too — see
          // practice_availability_resolver.dart's resolveQuickStart. It can
          // only ever be available where Topic Drill is.
          'quickStart': available ? 'available' : 'unavailable',
        },
        'questionPackIds': available ? [packId] : const [],
        'selectionPolicy':
            available ? 'exact_topic_and_stage_tag_match' : 'no_content',
        'provenance': {
          'status': decimalProvenance != null
              ? decimalProvenanceStatus
              : available
                  ? 'existing_licensed_bank'
                  : 'real_content_intentionally_uncategorised',
          'note': decimalProvenance ??
              (available
                  ? '${rows.length} tagged rows in the $packId pack carry '
                      'topicId "$topicId".'
                  : 'No row in the $packId pack maps to "$topicId" under the '
                      'evidence-backed raw skill/strand mapping — see '
                      'tool/retag_practice_packs.dart. Real, differently-'
                      'categorised content may still exist in this pack.'),
        },
        'unavailableMessage': available
            ? null
            : '${topic['title']} practice isn\'t available for $stageId yet '
                '— no verified questions exist for this topic at this '
                'stage.',
        'feedbackContextId': '$topicId::$stageId',
      });
    }
  }

  final manifest = {
    'manifestVersion': manifestVersion,
    'curriculumMapping': curriculumMapping,
    'description': 'Canonical, versioned contract for which (topic, stage) '
        'combinations are real. Generated by '
        'tool/generate_curriculum_manifest.dart from the tagged pack '
        'content itself (tool/retag_practice_packs.dart) — never hand-'
        'edited. The practice resolver and Topic Learning Hub both read '
        'topic-stage availability from here; no other file may declare it. '
        'topic_catalog.json remains the canonical *localized display* '
        'layer (title/subtitle per locale) and is unaffected. '
        'formulaLibrary/recallCards activity availability is still owned '
        'by topic_capability_resolver.dart, unchanged by this sprint — '
        'only topicDrill/quickStart (this sprint\'s confirmed defect) are '
        'modelled here.',
    'stages': stages
        .map((s) => {
              'id': s['id'],
              'order': s['order'],
              'label': s['label'],
              'hasContent': s['packId'] != null,
            })
        .toList(),
    'strands': const [
      {'id': 'number', 'label': 'Number'},
      {'id': 'algebra', 'label': 'Algebra'},
      {'id': 'geometry', 'label': 'Geometry'},
      {'id': 'data_statistics', 'label': 'Data & Statistics'},
      {'id': 'probability', 'label': 'Probability'},
      {'id': 'logic_combinatorics', 'label': 'Logic & Combinatorics'},
      {'id': 'computing', 'label': 'Computing'},
    ],
    'topicStageRecords': topicStageRecords,
  };

  final file = File('assets/config/curriculum_manifest.json');
  const encoder = JsonEncoder.withIndent('  ');
  await file.writeAsString('${encoder.convert(manifest)}\n');
  stdout.writeln(
    'Wrote ${topicStageRecords.length} topic-stage records to '
    '${file.path}.',
  );
}
