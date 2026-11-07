import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/curriculum_manifest.dart';
import 'package:unified_math_tutor/services/curriculum_manifest_service.dart';
import 'package:unified_math_tutor/services/practice_availability_resolver.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const packPaths = {
    'KS2': 'assets/packs/en-GB/KS2_bank_ok_10000.jsonl',
    'KS3': 'assets/packs/en-GB/KS3_bank_ok_10000.jsonl',
    'KS4': 'assets/packs/en-GB/KS4_merged_deduped.jsonl',
  };
  const curatedKs3Ids = {
    'ks3_fractions_decimals_percent_abc79a992d',
    'ks3_fractions_decimals_percent_a736c3cf7b',
    'ks3_fractions_decimals_percent_abb1038062',
    'ks3_fractions_decimals_percent_1071492c1d',
    'ks3_fractions_decimals_percent_7340b421e0',
    'ks3_fractions_decimals_percent_019f3dd25e',
    'ks3_fractions_decimals_percent_ddb860a3c3',
  };
  const authoredCounts = {'KS2': 15, 'KS3': 9, 'KS4': 15};
  const expectedCorrectOptions = {
    'ks2_decimals_v1_001': '0.6',
    'ks2_decimals_v1_002': '0.37',
    'ks2_decimals_v1_003': '4 tenths',
    'ks2_decimals_v1_004': '0.5',
    'ks2_decimals_v1_005': '0.5, 0.56, 0.65, 0.7',
    'ks2_decimals_v1_006': '0.70',
    'ks2_decimals_v1_007': '\u00a33.55',
    'ks2_decimals_v1_008': '\u00a35.00',
    'ks2_decimals_v1_009': '120 cm',
    'ks2_decimals_v1_010': '800 g',
    'ks2_decimals_v1_011': '0.55',
    'ks2_decimals_v1_012': '1.76',
    'ks2_decimals_v1_013': '2.45',
    'ks2_decimals_v1_014': '6',
    'ks2_decimals_v1_015': '0.09 < 0.1',
    'ks3_decimals_v1_001': '6 tenths',
    'ks3_decimals_v1_002': '1.09, 1.109, 1.19, 1.9',
    'ks3_decimals_v1_003': '18.75',
    'ks3_decimals_v1_004': '0.125',
    'ks3_decimals_v1_005': '0.6',
    'ks3_decimals_v1_006': '9.08',
    'ks3_decimals_v1_007': '7',
    'ks3_decimals_v1_008': '0.28',
    'ks3_decimals_v1_009': '2.26',
    'ks4_decimals_v1_001': '0.0064',
    'ks4_decimals_v1_002': '4.65 \u2264 x < 4.75',
    'ks4_decimals_v1_003': '6.275 \u2264 x < 6.285',
    'ks4_decimals_v1_004': '0.004815 \u2264 x < 0.004825',
    'ks4_decimals_v1_005': '0.0084',
    'ks4_decimals_v1_006': '180',
    'ks4_decimals_v1_007': '2.223',
    'ks4_decimals_v1_008': '3.921',
    'ks4_decimals_v1_009': '0.4375',
    'ks4_decimals_v1_010': '0.325',
    'ks4_decimals_v1_011': '0.407 < 0.47',
    'ks4_decimals_v1_012': '3/11',
    'ks4_decimals_v1_013': '48.4',
    'ks4_decimals_v1_014': '7.4175 cm\u00b2',
    'ks4_decimals_v1_015': '7.29',
  };

  List<Map<String, dynamic>> rowsFor(String stage) => File(packPaths[stage]!)
      .readAsLinesSync()
      .where((line) => line.trim().isNotEmpty)
      .map((line) => jsonDecode(line) as Map<String, dynamic>)
      .toList();

  TopicStageRecord recordFor(
    CurriculumManifest manifest,
    String stage,
  ) =>
      manifest.records.values.singleWhere(
        (record) => record.topicId == 'decimals' && record.stage == stage,
      );

  void expectExactReadyOutcome(
    PracticeLoadOutcome outcome, {
    required String stage,
  }) {
    expect(outcome, isA<PracticeLoadReady>());
    final records = (outcome as PracticeLoadReady).records;
    expect(records, isNotEmpty);
    for (final row in records) {
      expect(row['stage'], stage);
      expect(row['topicId'], 'decimals');
    }
  }

  test('only the audited Decimal rows and original slice are tagged', () {
    for (final entry in packPaths.entries) {
      final stageRows = rowsFor(entry.key);
      final decimalRows =
          stageRows.where((row) => row['topicId'] == 'decimals').toList();
      final expectedCount = entry.key == 'KS3' ? 16 : 15;
      expect(decimalRows, hasLength(expectedCount));

      final authoredRows = decimalRows
          .where((row) => (row['id'] as String).startsWith(
                '${entry.key.toLowerCase()}_decimals_v1_',
              ))
          .toList();
      expect(authoredRows, hasLength(authoredCounts[entry.key]));
      expect(
        authoredRows.map((row) => row['id']).toSet(),
        expectedCorrectOptions.keys
            .where((id) => id.startsWith('${entry.key.toLowerCase()}_'))
            .toSet(),
      );
      for (final row in authoredRows) {
        expect(row['rationale'], isA<String>());
        expect((row['rationale'] as String).trim(), isNotEmpty);
        expect(row['options'], hasLength(4));
        final options = (row['options'] as List).cast<String>();
        final answerIndex = row['answer_index'] as int;
        expect(answerIndex, inInclusiveRange(0, options.length - 1));
        expect(options.toSet(), hasLength(options.length));
        expect(
          options[answerIndex],
          expectedCorrectOptions[row['id']],
          reason: 'Incorrect option is marked correct for ${row['id']}',
        );
        if (row.containsKey('answer_value')) {
          expect(row['answer_value'], options[answerIndex]);
        }
      }
    }

    final ks3Rows = rowsFor('KS3');
    final fusedBucketDecimalIds = ks3Rows
        .where((row) =>
            row['skill'] == 'fractions_decimals_percent' &&
            row['topicId'] == 'decimals')
        .map((row) => row['id'] as String)
        .toSet();
    expect(fusedBucketDecimalIds, curatedKs3Ids);

    final curated =
        ks3Rows.where((row) => curatedKs3Ids.contains(row['id'])).toList();
    expect(curated, hasLength(curatedKs3Ids.length));
    for (final row in curated) {
      expect(row['subtopicId'], 'fraction_decimal_equivalence');
      expect(row['rationale'], isA<String>());
      expect((row['rationale'] as String).trim(), isNotEmpty);
    }
  });

  test('opt-in translated packs stay unavailable for Decimal practice', () {
    for (final locale in const ['de-CH', 'fr-CH', 'it-CH']) {
      for (final stage in const ['KS2', 'KS3', 'KS4']) {
        final filename = switch (stage) {
          'KS2' => 'KS2_bank_ok_10000.jsonl',
          'KS3' => 'KS3_bank_ok_10000.jsonl',
          _ => 'KS4_merged_deduped.jsonl',
        };
        final rows = File('assets/packs/$locale/$filename')
            .readAsLinesSync()
            .where((line) => line.trim().isNotEmpty)
            .map((line) => jsonDecode(line) as Map<String, dynamic>);
        expect(
          rows.where((row) => row['topicId'] == 'decimals'),
          isEmpty,
          reason: '$locale $stage has no localized Decimal slice; exact-tag '
              'selection must leave the pair unavailable rather than '
              'substituting another topic.',
        );
      }
    }
  });

  test('manifest enables only Decimal KS2-KS4 with attributed provenance',
      () async {
    final manifest = await CurriculumManifestService.instance.load();
    final decimalRecords = manifest.records.values
        .where((record) => record.topicId == 'decimals')
        .toList();
    final enabledStages = decimalRecords
        .where((record) => record.topicDrillReady && record.quickStartReady)
        .map((record) => record.stage)
        .toSet();
    expect(enabledStages, {'KS2', 'KS3', 'KS4'});

    for (final record in decimalRecords) {
      final shouldBeAvailable =
          const {'KS2', 'KS3', 'KS4'}.contains(record.stage);
      expect(record.topicDrillReady, shouldBeAvailable,
          reason: 'Topic Drill availability drifted for ${record.stage}');
      expect(record.quickStartReady, shouldBeAvailable,
          reason: 'Quick Start availability drifted for ${record.stage}');
      if (shouldBeAvailable) {
        expect(record.selectionPolicy, 'exact_topic_and_stage_tag_match');
        expect(record.questionPackIds, [record.stage.toLowerCase()]);
        expect(
          record.provenanceStatus,
          record.stage == 'KS3'
              ? 'mixed_original_and_existing_licensed_bank'
              : 'original_content_with_research_attribution',
        );
        expect(record.provenanceNote, contains('No source question wording'));
        expect(
            record.provenanceNote, contains('Decimal content is en-GB only'));
        expect(record.provenanceNote, isNotEmpty);
      }
    }
  });

  test(
      'both topic-scoped launch paths are exact-tagged; unavailable stages '
      'never fall back to unrelated questions', () async {
    for (final stage in const ['KS2', 'KS3', 'KS4']) {
      expectExactReadyOutcome(
        await PracticeAvailabilityResolver.resolveTopicDrill(
          stage,
          'decimals',
        ),
        stage: stage,
      );
      expectExactReadyOutcome(
        await PracticeAvailabilityResolver.resolveQuickStart(
          stage,
          topicId: 'decimals',
        ),
        stage: stage,
      );
    }

    for (final stage in const [
      'early_years',
      'KS1',
      'KS5',
      'advanced_enrichment',
    ]) {
      expect(
        await PracticeAvailabilityResolver.resolveTopicDrill(
          stage,
          'decimals',
        ),
        isA<PracticeLoadTopicUnavailable>(),
      );
      expect(
        await PracticeAvailabilityResolver.resolveQuickStart(
          stage,
          topicId: 'decimals',
        ),
        isA<PracticeLoadTopicUnavailable>(),
      );
    }

    final manifest = await CurriculumManifestService.instance.load();
    for (final stage in const ['KS5']) {
      final record = recordFor(manifest, stage);
      expect(record.topicDrillReady, isFalse);
      expect(record.quickStartReady, isFalse);
    }
  });
}
