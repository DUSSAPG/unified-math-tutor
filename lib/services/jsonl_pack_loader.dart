import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../core/question_id_rule.dart';
import '../models/pack_quarantine_diagnostic.dart';
import 'pack_registry_service.dart';

class JsonlPackLoader {
  JsonlPackLoader({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  static final instance = JsonlPackLoader();

  final AssetBundle _bundle;

  /// Diagnostics from the most recent [load] call for a given pack path —
  /// overwritten (not accumulated) on the next load of that same path. Empty
  /// list, never null, when nothing was quarantined. Kept per-path (not a
  /// single "last load" slot) so a caller checking one pack's diagnostics
  /// can't be clobbered by an unrelated concurrent load of a different pack.
  final Map<String, List<PackQuarantineDiagnostic>> _quarantineByPath = {};

  List<PackQuarantineDiagnostic> quarantineFor(String path) =>
      List.unmodifiable(_quarantineByPath[path] ?? const []);

  /// Quarantine (id/uniqueness/answer-shape validation, see
  /// [PackQuarantineDiagnostic]) is applied only to the four practice-stage
  /// packs (KS2–KS5) — the ones Practice and Continue Learning actually
  /// serve as answerable multiple-choice questions. It is deliberately NOT
  /// applied to other registry entries such as the Tutor corpus (`all`) or
  /// Math Studio's `build_confidence` pack: those have different, valid
  /// shapes (the Tutor corpus isn't consumed as interactive MCQ content;
  /// `build_confidence_pack.jsonl` uses its own distinct schema —
  /// `correct_index`/`explanation`/`topic` — on purpose, see its own
  /// loader). Applying MCQ-shape quarantine there would risk silently
  /// dropping legitimate content those features depend on — out of scope
  /// for D1's "Stable Question Identity & Safe Resume" and a real
  /// regression risk, not a safety improvement.
  static final Set<String> _quarantinedStages =
      PackRegistryService.practiceStages.map((s) => s.toLowerCase()).toSet();

  Future<List<Map<String, dynamic>>> load(PackEntry pack) async {
    final raw = await _bundle.loadString(pack.path);
    final parsed = <Map<String, dynamic>>[];
    final lines = raw.split(RegExp(r'\r?\n'));
    for (var index = 0; index < lines.length; index++) {
      final line = lines[index].trim();
      if (line.isEmpty) continue;
      try {
        final decoded = jsonDecode(line);
        if (decoded is! Map<String, dynamic>) {
          throw const FormatException('JSONL line must be an object.');
        }
        parsed.add(decoded);
      } on FormatException catch (error) {
        throw FormatException(
          '${pack.path}:${index + 1}: invalid JSONL: ${error.message}',
        );
      }
    }
    final expected = pack.count;
    if (expected != null && expected != parsed.length) {
      final message =
          '${pack.path}: registry count $expected does not match ${parsed.length} parsed lines.';
      if (kReleaseMode) throw StateError(message);
      debugPrint(message);
    }

    if (!_quarantinedStages.contains(pack.id.toLowerCase())) {
      _quarantineByPath[pack.path] = const [];
      return parsed;
    }
    return _quarantine(pack.path, parsed);
  }

  /// Excludes rows that fail id/uniqueness/answer-shape validation —
  /// auditable via [quarantineFor], never silently served. A row that fails
  /// more than one check is reported once, for its first-detected reason.
  List<Map<String, dynamic>> _quarantine(
    String path,
    List<Map<String, dynamic>> rows,
  ) {
    final kept = <Map<String, dynamic>>[];
    final diagnostics = <PackQuarantineDiagnostic>[];
    final seenIds = <String>{};

    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      final lineNumber = i + 1;
      final rawId = row['id'];
      final idString = rawId is String ? rawId : null;

      if (!isValidQuestionId(idString)) {
        diagnostics.add(PackQuarantineDiagnostic(
          path: path,
          lineNumber: lineNumber,
          reason: QuarantineReason.missingOrInvalidId,
          rawId: idString,
        ));
        continue;
      }
      if (!seenIds.add(idString!)) {
        diagnostics.add(PackQuarantineDiagnostic(
          path: path,
          lineNumber: lineNumber,
          reason: QuarantineReason.duplicateIdInFile,
          rawId: idString,
        ));
        continue;
      }
      final options = row['options'];
      final optionsList = options is List ? options : const [];
      if (optionsList.length < 2) {
        diagnostics.add(PackQuarantineDiagnostic(
          path: path,
          lineNumber: lineNumber,
          reason: QuarantineReason.insufficientOptions,
          rawId: idString,
        ));
        continue;
      }
      final answerIndex = row['answer_index'] ?? row['correct_index'];
      final isValidAnswerIndex = answerIndex is int &&
          answerIndex >= 0 &&
          answerIndex < optionsList.length;
      if (!isValidAnswerIndex) {
        diagnostics.add(PackQuarantineDiagnostic(
          path: path,
          lineNumber: lineNumber,
          reason: QuarantineReason.invalidAnswerIndex,
          rawId: idString,
        ));
        continue;
      }

      kept.add(row);
    }

    _quarantineByPath[path] = diagnostics;
    if (diagnostics.isNotEmpty) {
      debugPrint('$path: quarantined ${diagnostics.length} of ${rows.length} '
          'rows (${kept.length} kept). See JsonlPackLoader.quarantineFor.');
    }
    return kept;
  }
}
