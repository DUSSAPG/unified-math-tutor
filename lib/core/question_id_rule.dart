import 'dart:convert';

/// The single authoritative rule for stable question identifiers across the
/// whole KS2–KS5 practice namespace — used by both [tool/repair_ks4_question
/// _ids.dart] (the one-time data-repair migration) and
/// `JsonlPackLoader`'s runtime quarantine validation, so there is exactly
/// one definition of "valid id" and one definition of "how a replacement id
/// is generated," never two drifting copies.
///
/// # The rule
/// A valid id is a non-empty string, 3–120 characters, containing only
/// ASCII letters, digits, underscore and hyphen (matches every id already
/// shipped: `ks2_fractions_of_amount_011efdb103`, `ks4_linear_solve_0`,
/// `bc-001`, `clc_...` Continue Learning checkpoint ids, etc. — this is a
/// sanity envelope around the existing convention, not a new format).
///
/// # Generated replacement ids
/// [generateDeterministicId] is used only for rows that shipped with no id
/// at all. It is a pure function: the same inputs always produce the same
/// output, so re-running the migration against the same source file is a
/// no-op the second time (idempotent). It is deliberately **not** derived
/// solely from the question's wording — [sourceLineNumber] is always part
/// of the hash input specifically so that two rows with byte-identical
/// question content (a real, confirmed occurrence in this dataset — see the
/// Part C coverage-matrix content-duplication findings) still get distinct
/// ids. Once written into a pack file, a generated id is a normal, static,
/// permanent id like any other — nothing re-derives or recomputes it from
/// wording at load time, so a later wording correction never changes it.
final _validIdPattern = RegExp(r'^[A-Za-z0-9_-]{3,120}$');

bool isValidQuestionId(String? id) {
  if (id == null) return false;
  return _validIdPattern.hasMatch(id);
}

String generateDeterministicId({
  required String stagePrefix,
  required String skillSlug,
  required int sourceLineNumber,
  required String stemText,
  required List<String> options,
  required int answerIndex,
}) {
  final slug = _slugify(skillSlug);
  final hashInput = jsonEncode({
    'line': sourceLineNumber,
    'stem': stemText,
    'options': options,
    'answerIndex': answerIndex,
  });
  final hash = _shortDeterministicHash(hashInput);
  return '${stagePrefix}_gen_${slug}_$hash';
}

String _slugify(String value) {
  final lower = value.toLowerCase().trim();
  final replaced = lower.replaceAll(RegExp(r'[^a-z0-9]+'), '_');
  final collapsed = replaced.replaceAll(RegExp(r'_+'), '_');
  return collapsed.replaceAll(RegExp(r'^_|_$'), '');
}

/// A small, dependency-free, deterministic (not cryptographic) hash —
/// FNV-1a — good enough for generating a short, stable, collision-resistant
/// suffix for this one-time migration without pulling in `package:crypto`
/// for a single call site.
String _shortDeterministicHash(String input) {
  const fnvOffsetBasis = 0x811c9dc5;
  const fnvPrime = 0x01000193;
  var hash = fnvOffsetBasis;
  for (final byte in utf8.encode(input)) {
    hash ^= byte;
    hash = (hash * fnvPrime) & 0xFFFFFFFF;
  }
  return hash.toRadixString(16).padLeft(8, '0');
}
