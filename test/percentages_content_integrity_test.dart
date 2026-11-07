import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/core/ks4_inexact_percentage_question_ids.dart';
import 'package:unified_math_tutor/models/pack_quarantine_diagnostic.dart';
import 'package:unified_math_tutor/services/jsonl_pack_loader.dart';
import 'package:unified_math_tutor/services/pack_registry_service.dart';
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
  const retaggedKs3Ids = {
    'ks3_fractions_decimals_percent_0eab859de8',
    'ks3_fractions_decimals_percent_9bdaa6bb76',
    'ks3_fractions_decimals_percent_1b72bb0bba',
    'ks3_fractions_decimals_percent_245e1a5fe6',
    'ks3_fractions_decimals_percent_05c3a3e2de',
  };
  // Of the 649 pre-existing generated KS4 rows, 111 are mathematically exact
  // and stay tagged; the other 538 are untagged (see
  // ks4InexactPercentageQuestionIds) and left unmodified in the pack.
  const preExistingKs4Percentages = 111;
  const expectedTagged = {'KS2': 15, 'KS3': 20, 'KS4': 126};
  const expectedCorrectOptions = {
    'ks2_percentages_v2_001': '37 out of every 100',
    'ks2_percentages_v2_002': '9/100',
    'ks2_percentages_v2_003': '64%',
    'ks2_percentages_v2_004': '1/2',
    'ks2_percentages_v2_005': '65%',
    'ks2_percentages_v2_006': '8',
    'ks2_percentages_v2_007': '\u00a318',
    'ks2_percentages_v2_008': '15 cm',
    'ks2_percentages_v2_009': '40%',
    'ks2_percentages_v2_010': '0.07',
    'ks2_percentages_v2_011': '90%',
    'ks2_percentages_v2_012': '\u00a34',
    'ks2_percentages_v2_013': '100 ml',
    'ks2_percentages_v2_014': '54%',
    'ks2_percentages_v2_015': '15',
    'ks3_percentages_v2_001': '40%',
    'ks3_percentages_v2_002': '84',
    'ks3_percentages_v2_003': '8%',
    'ks3_percentages_v2_004': '1.4',
    'ks3_percentages_v2_005': '\u00a369',
    'ks3_percentages_v2_006': '\u00a336',
    'ks3_percentages_v2_007': '25%',
    'ks3_percentages_v2_008': '\u00a380',
    'ks3_percentages_v2_009': '7/20',
    'ks3_percentages_v2_010': '35%, 3/8, 0.4',
    'ks3_percentages_v2_011': '\u00a360',
    'ks3_percentages_v2_012': 'Test A: 75% against 70%',
    'ks3_percentages_v2_013': '8',
    'ks3_percentages_v2_014': '\u00a32.70',
    'ks3_percentages_v2_015': '75',
    'ks4_percentages_v2_001': '\u00a3600',
    'ks4_percentages_v2_002': '\u00a3300',
    'ks4_percentages_v2_003': '4,500',
    'ks4_percentages_v2_004': '\u00a375',
    'ks4_percentages_v2_005': '25%',
    'ks4_percentages_v2_006': '7.5%',
    'ks4_percentages_v2_007': '3.75%',
    'ks4_percentages_v2_008': '15%',
    'ks4_percentages_v2_009': '24%',
    'ks4_percentages_v2_010': '15%',
    'ks4_percentages_v2_011': '1.075',
    'ks4_percentages_v2_012': '\u00a32,205',
    'ks4_percentages_v2_013': '\u00a37,680',
    'ks4_percentages_v2_014': '0.99',
    'ks4_percentages_v2_015': '\u00a374.18',
  };

  List<Map<String, dynamic>> readRows(String path) => File(path)
      .readAsLinesSync()
      .where((line) => line.trim().isNotEmpty)
      .map((line) => jsonDecode(line) as Map<String, dynamic>)
      .toList();

  List<Map<String, dynamic>> percentageRows(String stage) => readRows(
        packPaths[stage]!,
      ).where((row) => row['topicId'] == 'percentages').toList();

  void expectExactReadyOutcome(
    PracticeLoadOutcome outcome, {
    required String stage,
  }) {
    expect(outcome, isA<PracticeLoadReady>());
    final records = (outcome as PracticeLoadReady).records;
    expect(records, isNotEmpty);
    for (final row in records) {
      expect(row['stage'], stage);
      expect(row['topicId'], 'percentages');
    }
  }

  test('only audited Percentage rows and the original slice are tagged', () {
    for (final stage in packPaths.keys) {
      final rows = percentageRows(stage);
      expect(rows, hasLength(expectedTagged[stage]!));

      final prefix = '${stage.toLowerCase()}_percentages_v2_';
      final authored = rows
          .where((row) => (row['id'] as String).startsWith(prefix))
          .toList();
      expect(authored, hasLength(15));
      expect(
        authored.map((row) => row['id']).toSet(),
        expectedCorrectOptions.keys
            .where((id) => id.startsWith('${stage.toLowerCase()}_'))
            .toSet(),
      );
      for (final row in authored) {
        expect((row['rationale'] as String).trim(), isNotEmpty);
        final options = (row['options'] as List).cast<String>();
        expect(options, hasLength(4));
        expect(options.toSet(), hasLength(4));
        expect(
          options[row['answer_index'] as int],
          expectedCorrectOptions[row['id']],
          reason: 'Incorrect option is marked correct for ${row['id']}',
        );
        if (row.containsKey('answer_value')) {
          expect(row['answer_value'], options[row['answer_index'] as int]);
        }
      }

      if (stage == 'KS4') {
        expect(rows.length - authored.length, preExistingKs4Percentages);
      }
    }

    final fusedPercentageIds = readRows(packPaths['KS3']!)
        .where((row) =>
            row['skill'] == 'fractions_decimals_percent' &&
            row['topicId'] == 'percentages')
        .map((row) => row['id'] as String)
        .toSet();
    expect(fusedPercentageIds, retaggedKs3Ids);
    for (final row in percentageRows('KS3')
        .where((row) => retaggedKs3Ids.contains(row['id']))) {
      expect(row['subtopicId'], 'fraction_percentage_equivalence');
      expect(row['stem'] as String, contains('to a percentage'));
    }
  });

  test('Percentage-tagged rows never carry a different topic or stage', () {
    for (final stage in packPaths.keys) {
      for (final row in percentageRows(stage)) {
        expect(row['stage'], stage);
      }
    }
  });

  // Exact rational arithmetic on hundredths-scaled integers.
  (int, int)? parseRational(String raw) {
    final s = raw.replaceAll(',', '').trim();
    final slash = RegExp(r'^(\d+(?:\.\d+)?)/100$').firstMatch(s);
    final text = slash != null ? slash.group(1)! : s;
    if (!RegExp(r'^\d+(?:\.\d+)?$').hasMatch(text)) return null;
    final parts = text.split('.');
    final decimals = parts.length == 2 ? parts[1].length : 0;
    var den = 1;
    for (var i = 0; i < decimals; i++) {
      den *= 10;
    }
    var num = int.parse(parts.join());
    if (slash != null) den *= 100;
    return (num, den);
  }

  bool sameRational((int, int) a, (int, int) b) => a.$1 * b.$2 == b.$1 * a.$2;

  // The exact result of the pre-existing generated KS4 templates, or null
  // when the stem is not one of them.
  (int, int)? templateResult(String question) {
    final of = RegExp(r'^Find (\d+)% of (\d+)\.').firstMatch(question);
    if (of != null) {
      return (int.parse(of.group(1)!) * int.parse(of.group(2)!), 100);
    }
    final change = RegExp(
      r'^(?:Increase (\d+) by (\d+)%|Decrease (\d+) by (\d+)%|'
      r'A value of (\d+) is (increased|decreased) by (\d+)%)',
    ).firstMatch(question);
    if (change == null) return null;
    final inc = question.startsWith('Increase') ||
        (change.group(6) ?? '') == 'increased';
    final base =
        int.parse(change.group(1) ?? change.group(3) ?? change.group(5)!);
    final pct =
        int.parse(change.group(2) ?? change.group(4) ?? change.group(7)!);
    return (base * (inc ? 100 + pct : 100 - pct), 100);
  }

  test(
      'no mathematically inexact KS4 item remains tagged or servable as '
      'percentages; the 538 inexact rows are untagged but not deleted',
      () async {
    final ks4 = readRows(packPaths['KS4']!);
    final byId = {for (final row in ks4) row['id'] as String: row};

    expect(ks4InexactPercentageQuestionIds, hasLength(538));
    for (final id in ks4InexactPercentageQuestionIds) {
      final row = byId[id];
      expect(row, isNotNull, reason: '$id must still exist (not deleted)');
      expect(row!['topicId'], isNull, reason: '$id must not be tagged');
      final truth = templateResult(row['question'] as String)!;
      final key = parseRational(
        (row['options'] as List)[row['answer_index'] as int] as String,
      )!;
      expect(sameRational(truth, key), isFalse,
          reason: '$id was excluded but its key is exact');
    }

    // Every tagged legacy-template row is exactly correct, and every
    // legacy-template row that is exactly correct stays tagged.
    var retainedExact = 0;
    for (final row in ks4) {
      final truth = templateResult(row['question'] as String);
      if (truth == null) continue;
      final key = parseRational(
        (row['options'] as List)[row['answer_index'] as int] as String,
      );
      final exact = key != null && sameRational(truth, key);
      expect(row['topicId'] == 'percentages', exact,
          reason: '${row['id']}: tag must equal exactness');
      if (exact) retainedExact++;
    }
    expect(retainedExact, 111);

    final served = <String>{};
    final drill = await PracticeAvailabilityResolver.resolveTopicDrill(
        'KS4', 'percentages');
    final quick = await PracticeAvailabilityResolver.resolveQuickStart('KS4',
        topicId: 'percentages');
    for (final outcome in [drill, quick]) {
      final records = (outcome as PracticeLoadReady).records;
      expect(records, hasLength(126));
      for (final row in records) {
        served.add(row['id'] as String);
        expect(row['topicId'], 'percentages');
      }
    }
    expect(served.intersection(ks4InexactPercentageQuestionIds), isEmpty);
  });

  test('KS3 retags are individually verified representatives only', () {
    const expected = {
      'Convert 1/2 to a percentage.': '50',
      'Convert 1/4 to a percentage.': '25',
      'Convert 1/5 to a percentage.': '20',
      'Convert 2/5 to a percentage.': '40',
      'Convert 3/4 to a percentage.': '75',
    };
    final ks3 = readRows(packPaths['KS3']!);
    final retagged =
        ks3.where((row) => retaggedKs3Ids.contains(row['id'])).toList();
    expect(retagged, hasLength(5));
    expect(retagged.map((row) => row['stem']).toSet(), expected.keys.toSet());
    for (final row in retagged) {
      expect((row['options'] as List)[row['answer_index'] as int],
          expected[row['stem']]);
    }
    // Duplicate conversions (same stem, different id) were not retagged.
    final duplicates = ks3.where((row) =>
        expected.containsKey(row['stem']) &&
        !retaggedKs3Ids.contains(row['id']));
    expect(duplicates, isNotEmpty);
    for (final row in duplicates) {
      expect(row['topicId'], isNull, reason: '${row['id']} must stay untagged');
    }
    // The fused bucket's other rows are never tagged percentages.
    expect(
      ks3
          .where((row) =>
              row['skill'] == 'fractions_decimals_percent' &&
              row['topicId'] == 'percentages')
          .length,
      5,
    );
  });

  test('opt-in translated packs stay unavailable for Percentage practice', () {
    const files = {
      'KS2': 'KS2_bank_ok_10000.jsonl',
      'KS3': 'KS3_bank_ok_10000.jsonl',
      'KS4': 'KS4_merged_deduped.jsonl',
    };
    for (final locale in const ['de-CH', 'fr-CH', 'it-CH']) {
      for (final file in files.values) {
        expect(
          readRows('assets/packs/$locale/$file')
              .where((row) => row['topicId'] == 'percentages'),
          isEmpty,
          reason: '$locale $file must not carry Percentage tags',
        );
      }
    }
  });

  test('manifest enables exactly Percentages KS2-KS4 and matches pack tags',
      () async {
    final manifest = await CurriculumManifestService.instance.load();
    final records = manifest.records.values
        .where((TopicStageRecord r) => r.topicId == 'percentages')
        .toList();
    const enabled = {'KS2', 'KS3', 'KS4'};
    expect(
      records
          .where((r) => r.topicDrillReady && r.quickStartReady)
          .map((r) => r.stage)
          .toSet(),
      enabled,
    );
    for (final record in records) {
      final isEnabled = enabled.contains(record.stage);
      expect(record.topicDrillReady, isEnabled, reason: record.stage);
      expect(record.quickStartReady, isEnabled, reason: record.stage);
      if (!isEnabled) continue;
      expect(record.selectionPolicy, 'exact_topic_and_stage_tag_match');
      expect(record.questionPackIds, [record.stage.toLowerCase()]);
      expect(
        record.provenanceStatus,
        record.stage == 'KS2'
            ? 'original_content_with_research_attribution'
            : 'mixed_original_and_existing_licensed_bank',
      );
      expect(record.provenanceNote, contains('concept verification only'));
      expect(
        record.provenanceNote,
        contains('Percentage content is en-GB only'),
      );
      // Tag drift: manifest subtopics must equal the pack's tagged subtopics.
      final packSubtopics = percentageRows(record.stage)
          .map((row) => row['subtopicId'] as String)
          .toSet();
      expect(record.subtopics.toSet(), packSubtopics,
          reason: 'Manifest/pack subtopic drift for ${record.stage}');
    }
  });

  String optionText(Map<String, dynamic> row) =>
      (row['options'] as List)[row['answer_index'] as int] as String;

  test('exclusion allowlist equals the dynamically recomputed inexact set', () {
    final ks4 = readRows(packPaths['KS4']!);
    final recomputed = <String>{};
    for (final row in ks4) {
      final truth = templateResult(row['question'] as String);
      if (truth == null) continue;
      final key = parseRational(optionText(row));
      // An unparseable key is never treated as safe.
      if (key == null || !sameRational(truth, key)) {
        recomputed.add(row['id'] as String);
      }
    }
    expect(recomputed, ks4InexactPercentageQuestionIds);
  });

  test('final KS4 totals: 538 untagged, 111 retained, 15 added, 126 served',
      () async {
    final ks4 = readRows(packPaths['KS4']!);
    final tagged = ks4.where((r) => r['topicId'] == 'percentages').toList();
    final authored = tagged
        .where((r) => (r['id'] as String).startsWith('ks4_percentages_v2_'))
        .toList();
    final legacyTagged = tagged.length - authored.length;
    expect(ks4InexactPercentageQuestionIds, hasLength(538));
    expect(
      ks4
          .where((r) => ks4InexactPercentageQuestionIds.contains(r['id']))
          .where((r) => r['topicId'] == null),
      hasLength(538),
    );
    expect(legacyTagged, 111);
    expect(authored, hasLength(15));
    expect(tagged, hasLength(126));
    for (final outcome in [
      await PracticeAvailabilityResolver.resolveTopicDrill(
          'KS4', 'percentages'),
      await PracticeAvailabilityResolver.resolveQuickStart('KS4',
          topicId: 'percentages'),
    ]) {
      expect((outcome as PracticeLoadReady).records, hasLength(126));
    }
  });

  test('every served Percentage row is verified, keyed and consistent', () {
    const requiredTokens = {
      'ks2_percentages_v2_007': ['\u00a336'],
      'ks4_percentages_v2_001': ['690 / 1.15 = 600'],
      'ks4_percentages_v2_015': ['\u00a374.18'],
    };
    final equation = RegExp(
      r'(\d+(?:\.\d+)?)\s*([x\u00d7/+\-\u2212])\s*(\d+(?:\.\d+)?)\s*=\s*'
      r'\u00a3?(\d+(?:\.\d+)?)',
    );
    for (final stage in packPaths.keys) {
      final rows = percentageRows(stage);
      for (final row in rows) {
        final id = row['id'] as String;
        final options = (row['options'] as List).cast<String>();
        final correct = optionText(row);
        expect(row['stage'], stage, reason: id);
        expect(row['topicId'], 'percentages', reason: id);
        expect((row['rationale'] as String).trim(), isNotEmpty,
            reason: '$id must carry a worked rationale');
        expect(options.where((o) => o == correct), hasLength(1), reason: id);
        expect(options.toSet(), hasLength(options.length), reason: id);

        if (id.contains('_percentages_v2_')) {
          expect(correct, expectedCorrectOptions[id], reason: id);
          final rationale = (row['rationale'] as String).replaceAll(',', '');
          final plainKey = correct.replaceAll(',', '').replaceAll('\u00a3', '');
          final lead = RegExp(r'^\d[\d.]*').firstMatch(plainKey)?.group(0);
          final plainRationale = rationale.replaceAll('\u00a3', '');
          if (id != 'ks3_percentages_v2_012') {
            expect(
              plainRationale.contains(plainKey) ||
                  (lead != null && plainRationale.contains(lead)),
              isTrue,
              reason: '$id rationale does not reach the keyed answer',
            );
          } else {
            expect(rationale, allOf(contains('75%'), contains('70%')));
          }
          for (final token in requiredTokens[id] ?? const <String>[]) {
            expect(row['rationale'], contains(token), reason: id);
          }
          for (final m in equation.allMatches(plainRationale)) {
            // Chained sums ("24 + 24 + 24 + 12 = 84") only match their tail.
            if (plainRationale
                .substring(0, m.start)
                .trimRight()
                .contains(RegExp(r'[+x\u00d7]$'))) {
              continue;
            }
            final a = double.parse(m.group(1)!);
            final b = double.parse(m.group(3)!);
            final c = double.parse(m.group(4)!);
            final op = m.group(2)!;
            final candidates = switch (op) {
              'x' || '\u00d7' => [a * b],
              '/' => [a / b, a / b * 100],
              '+' => [a + b],
              _ => [a - b],
            };
            expect(candidates.any((v) => (v - c).abs() < 0.01 * (1 + c.abs())),
                isTrue,
                reason: '$id rationale equation ${m.group(0)} is wrong');
          }
        } else if (stage == 'KS3') {
          expect(retaggedKs3Ids, contains(id));
          final stem = row['stem'] as String;
          final m = RegExp(r'^Convert (\d+)/(\d+) to a percentage\.$')
              .firstMatch(stem)!;
          final pct = int.parse(m.group(1)!) * 100 / int.parse(m.group(2)!);
          expect(double.parse(correct), pct, reason: id);
          final rationale = row['rationale'] as String;
          expect(rationale, contains('${m.group(1)}/${m.group(2)}'),
              reason: id);
          expect(rationale, contains('${correct.trim()}%'), reason: id);
          expect(rationale, contains('= ${correct.trim()}'), reason: id);
        } else {
          final question = row['question'] as String;
          final truth = templateResult(question)!;
          expect(sameRational(truth, parseRational(correct)!), isTrue,
              reason: '$id key must be exact');
          final rationale = row['rationale'] as String;
          if (question.startsWith('Find')) {
            final m = RegExp(r'^Find (\d+)% of (\d+)\.').firstMatch(question)!;
            expect(
                rationale,
                '${m.group(1)}% = ${m.group(1)}/100. '
                'Multiply ${m.group(2)} by ${m.group(1)}/100.',
                reason: id);
          } else if (question.startsWith('Increase')) {
            expect(rationale, contains('(1 + p/100)'), reason: id);
          } else if (question.startsWith('Decrease')) {
            expect(rationale, contains('(1 \u2212 p/100)'), reason: id);
          }
        }
      }
    }
  });

  test(
      'no selector or locale can serve any of the 538 audited inexact KS4 '
      'rows', () async {
    final ids = ks4InexactPercentageQuestionIds;
    void expectNoInexact(Iterable<Map<String, dynamic>> rows, String label) {
      final leaked =
          rows.map((row) => row['id'] as String).where(ids.contains).toList();
      expect(leaked, isEmpty, reason: '$label served inexact rows');
    }

    // Global Quick Start (no topic filter).
    final global = await PracticeAvailabilityResolver.resolveQuickStart('KS4');
    expectNoInexact(
        (global as PracticeLoadReady).records, 'global Quick Start');
    expect(global.records, hasLength(17921));

    // Topic-scoped Quick Start and Topic Drill across every KS4 topic.
    final manifest = await CurriculumManifestService.instance.load();
    final ks4Topics = manifest.records.values
        .where((r) => r.stage == 'KS4')
        .map((r) => r.topicId)
        .toSet();
    expect(ks4Topics, contains('percentages'));
    for (final topic in ks4Topics) {
      for (final outcome in [
        await PracticeAvailabilityResolver.resolveTopicDrill('KS4', topic),
        await PracticeAvailabilityResolver.resolveQuickStart('KS4',
            topicId: topic),
      ]) {
        if (outcome is PracticeLoadReady) {
          expectNoInexact(outcome.records, 'KS4 $topic');
        }
      }
    }

    // The loader is the only reader of practice packs (Practice, Quick
    // Start, Topic Drill, Continue Learning resume), so every locale's KS4
    // pack is checked through it directly.
    for (final locale in const ['en-GB', 'de-CH', 'fr-CH', 'it-CH']) {
      final loader = JsonlPackLoader();
      final path = 'assets/packs/$locale/KS4_merged_deduped.jsonl';
      final served = await loader.load(PackEntry(id: 'ks4', path: path));
      expectNoInexact(served, locale);
      final present = readRows(path)
          .map((row) => row['id'] as String)
          .where(ids.contains)
          .toSet();
      if (locale == 'en-GB') expect(present, ids);
      expect(
        loader
            .quarantineFor(path)
            .where((d) => d.reason == QuarantineReason.knownInexactAnswer)
            .map((d) => d.rawId)
            .toSet(),
        present,
        reason: '$locale audit trail',
      );
    }
  });

  test('stages that never carried the inexact rows contain none of them', () {
    for (final file in const [
      'assets/packs/en-GB/KS2_bank_ok_10000.jsonl',
      'assets/packs/en-GB/KS3_bank_ok_10000.jsonl',
      'assets/packs/en-GB/KS5_merged_deduped.jsonl',
      'assets/packs/en-GB/ALL_merged_deduped.jsonl',
      'assets/packs/en-GB/KS4_bank_ok_2000_A.jsonl',
      'assets/packs/en-GB/KS4_bank_ok_2000_B.jsonl',
    ]) {
      final leaked = readRows(file)
          .map((row) => row['id'] as String?)
          .where(ks4InexactPercentageQuestionIds.contains);
      expect(leaked, isEmpty, reason: file);
    }
  });

  test('no duplicate IDs and registry counts match the packs', () {
    final registry =
        jsonDecode(File('assets/pack_registry.json').readAsStringSync())
            as Map<String, dynamic>;
    final registryText = jsonEncode(registry);
    for (final entry in packPaths.entries) {
      final rows = readRows(entry.value);
      final ids = rows.map((r) => r['id'] as String).toList();
      expect(ids.toSet(), hasLength(ids.length),
          reason: 'Duplicate IDs in ${entry.key}');
      expect(registryText, contains('${rows.length}'),
          reason: 'Registry lacks the ${entry.key} row count');
    }
  });

  test(
      'topic-scoped launch paths are exact-tagged; unavailable stages never '
      'fall back to unrelated questions', () async {
    for (final stage in const ['KS2', 'KS3', 'KS4']) {
      expectExactReadyOutcome(
        await PracticeAvailabilityResolver.resolveTopicDrill(
          stage,
          'percentages',
        ),
        stage: stage,
      );
      expectExactReadyOutcome(
        await PracticeAvailabilityResolver.resolveQuickStart(
          stage,
          topicId: 'percentages',
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
          'percentages',
        ),
        isA<PracticeLoadTopicUnavailable>(),
        reason: stage,
      );
      expect(
        await PracticeAvailabilityResolver.resolveQuickStart(
          stage,
          topicId: 'percentages',
        ),
        isA<PracticeLoadTopicUnavailable>(),
        reason: stage,
      );
    }
  });
}
