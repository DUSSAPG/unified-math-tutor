import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/continue_learning_checkpoint.dart';
import 'package:unified_math_tutor/models/curriculum_manifest.dart';
import 'package:unified_math_tutor/models/practice_session_restoration_payload.dart';
import 'package:unified_math_tutor/services/continue_learning_destination_resolver.dart';
import 'package:unified_math_tutor/services/curriculum_manifest_service.dart';
import 'package:unified_math_tutor/services/practice_availability_resolver.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const ks3Path = 'assets/packs/en-GB/KS3_bank_ok_10000.jsonl';
  const gbp = '\u00a3';

  // Keyed answers recomputed independently of the pack (and by the content
  // builder with exact rational arithmetic).
  const expectedKeys = {
    'ks3_fractions_v1_001': '12/20',
    'ks3_fractions_v1_002': '3/8',
    'ks3_fractions_v1_003': '35',
    'ks3_fractions_v1_004': '5/8',
    'ks3_fractions_v1_005': '1/3, 3/8, 2/5, 1/2',
    'ks3_fractions_v1_006': '17/24',
    'ks3_fractions_v1_007': '11/15',
    'ks3_fractions_v1_008': '17/24',
    'ks3_fractions_v1_009': '1 5/12',
    'ks3_fractions_v1_010': '1/4',
    'ks3_fractions_v1_011': '5/4',
    'ks3_fractions_v1_012': '2',
    'ks3_fractions_v1_013': '24',
    'ks3_fractions_v1_014': '${gbp}60',
    'ks3_fractions_v1_015': '5/12',
    'ks3_fractions_v1_016': '3 2/5',
    'ks3_fractions_v1_017': '17/7',
    'ks3_fractions_v1_018': '4 5/12',
  };
  const expectedSubtopics = {
    'fractions_add_subtract',
    'fractions_compare_order',
    'fractions_equivalence',
    'fractions_mixed_numbers',
    'fractions_multiply_divide',
    'fractions_of_amount',
  };

  List<Map<String, dynamic>> readRows(String path) => File(path)
      .readAsLinesSync()
      .where((line) => line.trim().isNotEmpty)
      .map((line) => jsonDecode(line) as Map<String, dynamic>)
      .toList();

  List<Map<String, dynamic>> fractionRows() =>
      readRows(ks3Path).where((row) => row['topicId'] == 'fractions').toList();

  String optionText(Map<String, dynamic> row) =>
      (row['options'] as List)[row['answer_index'] as int] as String;

  test('KS3 Fractions is exactly the 18 original rows, all verified', () {
    final rows = fractionRows();
    expect(rows, hasLength(18));
    expect(rows.map((r) => r['id']).toSet(), expectedKeys.keys.toSet());
    expect(rows.map((r) => r['subtopicId']).toSet(), expectedSubtopics);
    for (final row in rows) {
      final id = row['id'] as String;
      final options = (row['options'] as List).cast<String>();
      final correct = optionText(row);
      expect(row['stage'], 'KS3', reason: id);
      expect(row['lang'], 'en-GB', reason: id);
      expect(row['packId'], 'ks3', reason: id);
      expect(row['skill'], row['subtopicId'], reason: id);
      expect(correct, expectedKeys[id], reason: '$id keyed answer');
      expect(row['answer_value'], correct, reason: id);
      expect(options, hasLength(4), reason: id);
      expect(options.toSet(), hasLength(4), reason: id);
      expect(options.where((o) => o == correct), hasLength(1), reason: id);
      final rationale = (row['rationale'] as String).trim();
      expect(rationale, isNotEmpty, reason: '$id needs a rationale');
      expect(rationale, contains(correct),
          reason: '$id rationale must state its keyed answer');
      expect((row['hint'] as String).trim(), isNotEmpty, reason: id);
    }
  });

  test('no legacy or fused-bucket KS3 row is tagged Fractions', () {
    final ks3 = readRows(ks3Path);
    final legacyTagged = ks3.where((r) =>
        r['topicId'] == 'fractions' &&
        !(r['id'] as String).startsWith('ks3_fractions_v1_'));
    expect(legacyTagged, isEmpty);
    final fused = ks3.where((r) => r['skill'] == 'fractions_decimals_percent');
    // The whole fused skill is 1,538 rows: 1,526 untagged + 7 Decimals + 5
    // Percentages retags, with none left over for any other topic.
    expect(fused, hasLength(1538));
    expect(
      fused.map((r) => r['topicId']).toSet(),
      {null, 'decimals', 'percentages'},
    );
    expect(fused.where((r) => r['topicId'] == 'fractions'), isEmpty);
    expect(fused.where((r) => r['topicId'] == null), hasLength(1526));
    expect(fused.where((r) => r['topicId'] == 'decimals'), hasLength(7));
    expect(fused.where((r) => r['topicId'] == 'percentages'), hasLength(5));
    final ids = ks3.map((r) => r['id'] as String).toList();
    expect(ids.toSet(), hasLength(ids.length), reason: 'duplicate IDs');
  });

  test('KS2 and KS4 Fractions tags and other KS3 topic counts are unchanged',
      () {
    int count(String path, String topic) =>
        readRows(path).where((r) => r['topicId'] == topic).length;
    expect(
        count('assets/packs/en-GB/KS2_bank_ok_10000.jsonl', 'fractions'), 3221);
    expect(
        count('assets/packs/en-GB/KS4_merged_deduped.jsonl', 'fractions'), 647);
    expect(count(ks3Path, 'decimals'), 16);
    expect(count(ks3Path, 'percentages'), 20);
  });

  test('manifest enables Fractions at KS2-KS4 only and matches pack tags',
      () async {
    final manifest = await CurriculumManifestService.instance.load();
    final records = manifest.records.values
        .where((TopicStageRecord r) => r.topicId == 'fractions')
        .toList();
    const enabled = {'KS2', 'KS3', 'KS4'};
    expect(
      records
          .where((r) => r.topicDrillReady && r.quickStartReady)
          .map((r) => r.stage)
          .toSet(),
      enabled,
    );
    final ks3 = records.singleWhere((r) => r.stage == 'KS3');
    expect(ks3.selectionPolicy, 'exact_topic_and_stage_tag_match');
    expect(ks3.questionPackIds, ['ks3']);
    expect(ks3.provenanceStatus, 'original_content_with_research_attribution');
    expect(ks3.provenanceNote, contains('Middle School Math for Parents'));
    expect(ks3.provenanceNote, contains('concept verification only'));
    expect(ks3.provenanceNote, contains('en-GB only'));
    // Tag drift: manifest subtopics must equal the pack's tagged subtopics.
    expect(ks3.subtopics.toSet(), expectedSubtopics);
    expect(
      ks3.subtopics.toSet(),
      fractionRows().map((r) => r['subtopicId'] as String).toSet(),
    );
  });

  test('opt-in translated KS3 packs carry no Fractions tags', () {
    for (final locale in const ['de-CH', 'fr-CH', 'it-CH']) {
      expect(
        readRows('assets/packs/$locale/KS3_bank_ok_10000.jsonl')
            .where((r) => r['topicId'] == 'fractions'),
        isEmpty,
        reason: locale,
      );
    }
  });

  test('Topic Drill and topic Quick Start serve only the 18 Fractions rows',
      () async {
    for (final outcome in [
      await PracticeAvailabilityResolver.resolveTopicDrill('KS3', 'fractions'),
      await PracticeAvailabilityResolver.resolveQuickStart('KS3',
          topicId: 'fractions'),
    ]) {
      expect(outcome, isA<PracticeLoadReady>());
      final records = (outcome as PracticeLoadReady).records;
      expect(records, hasLength(18));
      for (final row in records) {
        expect(row['stage'], 'KS3');
        expect(row['topicId'], 'fractions');
        expect(expectedKeys.keys, contains(row['id']));
      }
    }
  });

  test('other KS3 topics never serve Fractions rows', () async {
    for (final topic in const ['decimals', 'percentages', 'algebra']) {
      for (final outcome in [
        await PracticeAvailabilityResolver.resolveTopicDrill('KS3', topic),
        await PracticeAvailabilityResolver.resolveQuickStart('KS3',
            topicId: topic),
      ]) {
        final records = (outcome as PracticeLoadReady).records;
        expect(records, isNotEmpty);
        expect(records.where((r) => r['topicId'] != topic), isEmpty);
        expect(
          records.where((r) => expectedKeys.containsKey(r['id'])),
          isEmpty,
          reason: topic,
        );
      }
    }
  });

  test(
      'global Quick Start stays stage-wide and Fractions unavailable stages '
      'do not fall back', () async {
    final global = await PracticeAvailabilityResolver.resolveQuickStart('KS3');
    final records = (global as PracticeLoadReady).records;
    expect(records, hasLength(10042));
    expect(records.every((r) => r['stage'] == 'KS3'), isTrue);
    final fractionIds = records
        .where((r) => r['topicId'] == 'fractions')
        .map((r) => r['id'])
        .toSet();
    expect(fractionIds, expectedKeys.keys.toSet());

    for (final stage in const [
      'early_years',
      'KS1',
      'KS5',
      'advanced_enrichment',
    ]) {
      expect(
        await PracticeAvailabilityResolver.resolveTopicDrill(
            stage, 'fractions'),
        isA<PracticeLoadTopicUnavailable>(),
        reason: stage,
      );
      expect(
        await PracticeAvailabilityResolver.resolveQuickStart(stage,
            topicId: 'fractions'),
        isA<PracticeLoadTopicUnavailable>(),
        reason: stage,
      );
    }
  });

  test('Continue Learning resumes a Fractions KS3 session in order', () async {
    final ids = expectedKeys.keys.take(4).toList().reversed.toList();
    final checkpoint = ContinueLearningCheckpoint(
      schemaVersion: ContinueLearningCheckpoint.currentSchemaVersion,
      checkpointId: 'clc_fractions_ks3',
      learnerScopeId: 'device-guest',
      activityType: ContinueLearningActivityType.practiceSession,
      contentVersion: 'ks3',
      curriculumLevel: 'KS3',
      topicId: 'fractions',
      currentStep: 1,
      totalSteps: ids.length,
      startedAtUtc: DateTime.utc(2026, 1, 1),
      updatedAtUtc: DateTime.utc(2026, 1, 1),
      resumeCount: 0,
      restorationPayload: PracticeSessionRestorationPayload(
        questionIds: ids,
        selectedIndices: const [0],
      ).toJson(),
    );
    final resolved =
        await ContinueLearningDestinationResolver.resolvePracticeSession(
      checkpoint,
    );
    expect(resolved, isNotNull);
    expect(resolved!.questions.map((q) => q.id).toList(), ids);
    expect(resolved.topicId, 'fractions');
    expect(resolved.stage, 'KS3');
  });
}
