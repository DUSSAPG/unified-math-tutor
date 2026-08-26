// D1 — Stable Question Identity & Safe Resume: one-time repair of the 3,983
// KS4 questions that shipped with no `id` field (see the Part C coverage
// matrix, `build/audit/part_c_coverage_matrix.json`, for how these were
// found — a contiguous block, lines 14450-18432 of
// assets/packs/en-GB/KS4_merged_deduped.jsonl, from a later merge batch
// that never had ids assigned).
//
// Idempotent: rerunning against an already-repaired file finds nothing left
// to repair and makes no changes. Deterministic: uses the shared rule in
// lib/core/question_id_rule.dart, so a rerun from a fresh checkout of the
// same source content produces byte-identical ids.
//
// Usage: `dart run tool/repair_ks4_question_ids.dart`
// Add `--check` to only report what *would* change, without writing.
import 'dart:convert';
import 'dart:io';

import 'package:unified_math_tutor/core/question_id_rule.dart';

const _stage = 'KS4';
const _filename = 'KS4_merged_deduped.jsonl';
const _locales = ['en-GB', 'de-CH', 'fr-CH', 'it-CH'];

void main(List<String> args) {
  final checkOnly = args.contains('--check');
  final repoRoot = _findRepoRoot();

  final enPath = '${repoRoot.path}/assets/packs/en-GB/$_filename';
  final enFile = File(enPath);
  if (!enFile.existsSync()) {
    stderr.writeln('Cannot find $enPath — run from anywhere inside the repo.');
    exitCode = 1;
    return;
  }

  final enLines = enFile.readAsLinesSync();
  // id[i] == null means "line i needs a generated id" (i.e. the canonical
  // en-GB row at that position has none). Every locale mirror gets the same
  // generated id at the same line index, since the mirrors are structurally
  // parallel (same question count, same order) — verified in the Part D1
  // repair evidence below.
  final generatedIds = <int, String>{};
  var alreadyValid = 0;

  for (var i = 0; i < enLines.length; i++) {
    final line = enLines[i].trim();
    if (line.isEmpty) continue;
    final Map<String, dynamic> row = jsonDecode(line) as Map<String, dynamic>;
    final existing = row['id'];
    if (existing is String && isValidQuestionId(existing)) {
      alreadyValid++;
      continue;
    }
    final skillSlug = (row['skill_key'] ??
        row['skill'] ??
        row['strand'] ??
        'question') as String;
    final stem = (row['question'] ?? row['stem'] ?? '') as String;
    final options =
        (row['options'] as List?)?.cast<String>() ?? const <String>[];
    final answerIndex =
        (row['answer_index'] ?? row['correct_index'] ?? 0) as int;
    final id = generateDeterministicId(
      stagePrefix: _stage.toLowerCase(),
      skillSlug: skillSlug,
      sourceLineNumber: i,
      stemText: stem,
      options: options,
      answerIndex: answerIndex,
    );
    generatedIds[i] = id;
  }

  stdout.writeln(
      '$_stage: ${enLines.where((l) => l.trim().isNotEmpty).length} rows, '
      '$alreadyValid already valid, ${generatedIds.length} need a generated id.');

  if (generatedIds.isEmpty) {
    stdout.writeln('Nothing to repair — already idempotent-clean.');
    return;
  }

  // Uniqueness self-check before touching any file: generated ids must be
  // unique among themselves and must not collide with an id already present
  // anywhere in the en-GB file.
  final existingIds = <String>{};
  for (final line in enLines) {
    final t = line.trim();
    if (t.isEmpty) continue;
    final row = jsonDecode(t) as Map<String, dynamic>;
    final id = row['id'];
    if (id is String && isValidQuestionId(id)) existingIds.add(id);
  }
  final seenGenerated = <String>{};
  for (final id in generatedIds.values) {
    if (!seenGenerated.add(id)) {
      stderr.writeln(
          'FATAL: generated id "$id" is not unique among itself — refusing to write.');
      exitCode = 2;
      return;
    }
    if (existingIds.contains(id)) {
      stderr.writeln(
          'FATAL: generated id "$id" collides with an existing id — refusing to write.');
      exitCode = 2;
      return;
    }
  }

  if (checkOnly) {
    stdout.writeln(
        '--check: would repair ${generatedIds.length} rows across ${_locales.length} locale files. No files written.');
    return;
  }

  for (final locale in _locales) {
    final path = '${repoRoot.path}/assets/packs/$locale/$_filename';
    final file = File(path);
    if (!file.existsSync()) {
      stderr.writeln(
          'WARNING: $path not found — skipping (locale pack may not exist).');
      continue;
    }
    final lines = file.readAsLinesSync();
    if (lines.length != enLines.length) {
      stderr.writeln(
          'FATAL: $path has ${lines.length} lines, expected ${enLines.length} '
          '(en-GB) — locale mirror is not structurally aligned, refusing to write.');
      exitCode = 2;
      return;
    }
    var touched = 0;
    final out = StringBuffer();
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final trimmed = line.trim();
      if (trimmed.isEmpty) {
        out.writeln(line);
        continue;
      }
      final newId = generatedIds[i];
      if (newId == null) {
        out.writeln(line);
        continue;
      }
      final row = jsonDecode(trimmed) as Map<String, dynamic>;
      // Rebuild with `id` first, matching the convention every other row in
      // this dataset already uses.
      final reordered = <String, dynamic>{'id': newId, ...row};
      out.writeln(jsonEncode(reordered));
      touched++;
    }
    file.writeAsStringSync(out.toString());
    stdout.writeln('  $locale/$_filename: wrote $touched generated ids.');
  }

  stdout.writeln(
      'Repair complete: ${generatedIds.length} ids generated and applied '
      'across ${_locales.length} locale files.');
}

Directory _findRepoRoot() {
  var dir = Directory.current;
  while (true) {
    if (File('${dir.path}/pubspec.yaml').existsSync()) return dir;
    final parent = dir.parent;
    if (parent.path == dir.path) {
      stderr.writeln(
          'Could not find repo root (no pubspec.yaml found upward from ${Directory.current.path}).');
      exit(1);
    }
    dir = parent;
  }
}
