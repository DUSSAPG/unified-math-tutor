// One-time migration (curriculum-contract repair, 2026-09-05): bakes
// topicId/subtopicId/packId/curriculumVersion directly onto every row of
// the four stage-scoped practice packs (KS2-KS5), so the resolver can
// filter by a plain field equality instead of re-deriving a topic from
// raw skill/strand values at query time. Run once with:
//   dart run tool/retag_practice_packs.dart
//
// The topicId assignment below is the exact same evidence previously
// encoded in lib/core/practice_topic_mapping.dart (KS2/KS3 raw-value ->
// topic map, KS4/KS5 strand map + skill overrides) — copied here, not
// re-derived, so the migration and that file's own drift-guard test
// (practice_topic_mapping_pack_drift_test.dart) can never silently
// disagree without a test failing. A raw skill/strand value with no
// entry below gets topicId: null deliberately (real content, honestly
// left un-categorised) — never a guess, never a fallback assignment.
//
// Scope: only the four PRACTICE stage packs (KS2/KS3/KS4/KS5). Deliberately
// does NOT touch ALL_merged_deduped.jsonl (Tutor's corpus, not a Practice
// selection surface) or build_confidence_pack.jsonl (not curriculum-stage
// content) — re-tagging those is out of this sprint's content-integrity
// scope.
import 'dart:convert';
import 'dart:io';

const curriculumVersion = 1;

/// KS2/KS3 group by the row's own `skill` field directly.
const Map<String, Map<String, String?>> _skillTopicByStage = {
  'ks2': {
    'fractions_of_amount': 'fractions',
    'addition_subtraction': null,
    'multiplication_division': null,
  },
  'ks3': {
    'integers_directed_numbers': 'number_place_value',
    'linear_equations_basic': 'algebra',
    'algebra_simplify_substitute': 'algebra',
    'ratio_proportion': 'ratio_proportion',
    'sequences_linear': 'algebra',
    'fractions_decimals_percent': null,
  },
};

/// KS4/KS5 group by `strand`; a skill-level override wins over the
/// strand's own default when present (fused/generic strands only).
const Map<String, Map<String, String?>> _strandTopicByStage = {
  'ks4': {
    'Number': 'number_place_value',
    'Algebra': 'algebra',
    'Geometry_Measures': 'geometry_measures',
    'Statistics_Probability': 'statistics_probability',
    'Ratio_Proportion': 'ratio_proportion',
  },
  'ks5': {
    'Calculus': 'calculus',
    'Pure_Calculus': 'calculus',
    'Statistics': 'statistics_probability',
    'Mechanics': null,
    'Pure_Algebra_Trig':
        null, // resolved per-skill below, never by strand default
  },
};

const Map<String, Map<String, String>> _skillOverrideByStage = {
  'ks4': {
    'Fractions of a quantity': 'fractions',
    'Fractions add/subtract': 'fractions',
    'Fractions multiply/divide': 'fractions',
    'Percentage change': 'percentages',
    'Percent of an amount': 'percentages',
  },
  'ks5': {
    'Trig identities & rearranging': 'trigonometry',
    'Solve trig equations': 'trigonometry',
    'Radians + arc length/sector area': 'trigonometry',
  },
};

String _slugify(String raw) => raw
    .toLowerCase()
    .replaceAll(RegExp(r"[^a-z0-9]+"), '_')
    .replaceAll(RegExp(r'^_+|_+$'), '');

String? _topicIdFor(String packId, Map<String, dynamic> row) {
  final skillGroup = _skillTopicByStage[packId];
  if (skillGroup != null) {
    final skill = row['skill'] as String?;
    if (skill == null || !skillGroup.containsKey(skill)) {
      throw StateError(
        '$packId: unrecognised skill "$skill" — update _skillTopicByStage '
        'in tool/retag_practice_packs.dart with real evidence before '
        're-running (never guess).',
      );
    }
    return skillGroup[skill];
  }
  final strandGroup = _strandTopicByStage[packId]!;
  final strand = row['strand'] as String?;
  if (strand == null || !strandGroup.containsKey(strand)) {
    throw StateError(
      '$packId: unrecognised strand "$strand" — update _strandTopicByStage '
      'before re-running.',
    );
  }
  final override = _skillOverrideByStage[packId]?[row['skill']];
  return override ?? strandGroup[strand];
}

String _subtopicIdFor(Map<String, dynamic> row) {
  final skill = row['skill'] as String?;
  if (skill == null || skill.isEmpty) {
    throw StateError('Row ${row['id']} has no skill value to derive a '
        'subtopicId from.');
  }
  return _slugify(skill);
}

Future<void> _retag(String packId, String path) async {
  final file = File(path);
  final lines = await file.readAsLines();
  final out = StringBuffer();
  var tagged = 0;
  var unmapped = 0;
  for (final line in lines) {
    if (line.trim().isEmpty) continue;
    final row = jsonDecode(line) as Map<String, dynamic>;
    final topicId = _topicIdFor(packId, row);
    row['topicId'] = topicId;
    row['subtopicId'] = _subtopicIdFor(row);
    row['packId'] = packId;
    row['curriculumVersion'] = curriculumVersion;
    if (topicId == null) unmapped++;
    tagged++;
    out.writeln(jsonEncode(row));
  }
  await file.writeAsString(out.toString());
  stdout.writeln(
    '$packId ($path): tagged $tagged rows, $unmapped intentionally left '
    'topicId: null (real content, no evidence-backed topic).',
  );
}

Future<void> main() async {
  const base = 'assets/packs/en-GB';
  await _retag('ks2', '$base/KS2_bank_ok_10000.jsonl');
  await _retag('ks3', '$base/KS3_bank_ok_10000.jsonl');
  await _retag('ks4', '$base/KS4_merged_deduped.jsonl');
  await _retag('ks5', '$base/KS5_merged_deduped.jsonl');
  stdout.writeln('Done. ALL_merged_deduped.jsonl and build_confidence_pack '
      '.jsonl were deliberately left untouched — see file header.');
}
