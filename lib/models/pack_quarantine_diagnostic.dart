/// Why one JSONL row was excluded ("quarantined") from a loaded practice
/// pack rather than served to a learner. See `JsonlPackLoader`'s quarantine
/// policy — this exists specifically so a defect is auditable (visible in
/// diagnostics, testable) instead of silently dropped with no trace.
enum QuarantineReason {
  /// `id` is missing, empty, or fails [isValidQuestionId] — see
  /// `lib/core/question_id_rule.dart`.
  missingOrInvalidId,

  /// This row's `id` also appears on an earlier row in the same file — the
  /// later occurrence is quarantined, the first is kept.
  duplicateIdInFile,

  /// Fewer than 2 `options` — not a usable multiple-choice question.
  insufficientOptions,

  /// `answer_index`/`correct_index` is missing, non-numeric, or outside the
  /// bounds of `options`.
  invalidAnswerIndex,
}

/// One quarantined row, kept for audit/diagnostics — never shown to a
/// learner, but visible to logs and tests so a defect is discoverable
/// rather than silently absent.
class PackQuarantineDiagnostic {
  const PackQuarantineDiagnostic({
    required this.path,
    required this.lineNumber,
    required this.reason,
    this.rawId,
  });

  final String path;

  /// 1-indexed, matching how a human would count lines in the file.
  final int lineNumber;
  final QuarantineReason reason;

  /// The row's `id` field, if it had one (even an invalid one) — null for
  /// [QuarantineReason.missingOrInvalidId] when the field was entirely
  /// absent or not a string.
  final String? rawId;

  @override
  String toString() =>
      'PackQuarantineDiagnostic($path:$lineNumber, ${reason.name}'
      '${rawId != null ? ', id=$rawId' : ''})';
}
