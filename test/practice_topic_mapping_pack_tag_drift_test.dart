import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/core/practice_topic_mapping.dart';

/// P0 content-integrity repair — proves tool/retag_practice_packs.dart's
/// baked-in `topicId` tags can never silently drift from
/// practice_topic_mapping.dart's own evidence-backed mapping. For every row
/// in every stage pack, the tagged `topicId` must equal exactly what
/// [canonicalTopicForRawValue] would produce from that row's own raw
/// `skill`/`strand` value — a plain, exhaustive, per-row equality check,
/// not a spot sample.
void main() {
  const packs = {
    'KS2': 'assets/packs/en-GB/KS2_bank_ok_10000.jsonl',
    'KS3': 'assets/packs/en-GB/KS3_bank_ok_10000.jsonl',
    'KS4': 'assets/packs/en-GB/KS4_merged_deduped.jsonl',
    'KS5': 'assets/packs/en-GB/KS5_merged_deduped.jsonl',
  };

  for (final entry in packs.entries) {
    final stage = entry.key;
    test(
        '$stage: every tagged row\'s topicId matches '
        'canonicalTopicForRawValue for its own raw skill/strand value', () {
      final lines = File(entry.value).readAsLinesSync();
      final groupingField = groupingFieldFor(stage);
      var checked = 0;
      for (final line in lines) {
        if (line.trim().isEmpty) continue;
        final row = jsonDecode(line) as Map<String, dynamic>;
        final expected = canonicalTopicForRawValue(
          stage: stage,
          rawStrandOrSkillGroup: row[groupingField] as String?,
          rawFineSkill: row['skill'] as String?,
        );
        expect(row['topicId'], expected,
            reason: 'Row ${row['id']} ($stage): tagged topicId '
                '"${row['topicId']}" does not match what '
                'canonicalTopicForRawValue produces ("$expected") for its '
                'own $groupingField/skill value — the migration and the '
                'evidence table have drifted apart.');
        checked++;
      }
      expect(checked, greaterThan(0));
    });

    test(
        '$stage: every row also carries packId/curriculumVersion, and a '
        'non-empty subtopicId', () {
      final lines = File(entry.value).readAsLinesSync();
      for (final line in lines) {
        if (line.trim().isEmpty) continue;
        final row = jsonDecode(line) as Map<String, dynamic>;
        expect(row['packId'], stage.toLowerCase());
        expect(row['curriculumVersion'], 1);
        expect(row['subtopicId'], isA<String>());
        expect(row['subtopicId'], isNotEmpty);
      }
    });
  }
}
