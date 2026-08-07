/// Pure, deterministic selection logic for Recall Cards. No widget/service
/// dependencies — fully unit-testable in isolation, and safe to run fully
/// offline (no network, no LLM, no `Random`).
///
/// Mirrors [MentalMathsChallengeSelector]'s exact determinism strategy: same
/// day + same candidate-id membership always resolves to the same result for
/// every learner; a per-learner "recently shown" set is walked forward to
/// avoid repeats without needing randomness or the wall clock beyond the
/// current date.
class RecallCardSelector {
  RecallCardSelector._();

  static final DateTime _epoch = DateTime.utc(2020, 1, 1);

  static List<String> _rotate({
    required DateTime date,
    required List<String> bankIdsSorted,
    required Set<String> recentlyShownIds,
    required int count,
  }) {
    if (bankIdsSorted.isEmpty || count <= 0) return const [];
    final utcDay = DateTime.utc(date.year, date.month, date.day);
    final dayOffset = utcDay.difference(_epoch).inDays;
    final baseIndex = dayOffset % bankIdsSorted.length;

    final result = <String>[];
    final skippedRecent = <String>[];
    for (var i = 0; i < bankIdsSorted.length && result.length < count; i++) {
      final candidate = bankIdsSorted[(baseIndex + i) % bankIdsSorted.length];
      if (recentlyShownIds.contains(candidate)) {
        skippedRecent.add(candidate);
        continue;
      }
      result.add(candidate);
    }
    // Bank exhausted for this learner: allow a repeat rather than returning
    // fewer than requested, mirroring MentalMathsChallengeSelector's fallback.
    for (final candidate in skippedRecent) {
      if (result.length >= count) break;
      result.add(candidate);
    }
    return result;
  }

  /// Deterministic Five-Card Quick Review. Fills from Review Due first, then
  /// Learning, then New, so a learner with overdue cards always sees those
  /// first; within each bucket the same day always yields the same ordering.
  static List<String> quickReview({
    required DateTime date,
    required List<String> reviewDueIdsSorted,
    required List<String> learningIdsSorted,
    required List<String> newIdsSorted,
    required Set<String> recentlyShownIds,
    int count = 5,
  }) {
    final result = <String>[];
    for (final bucket in [
      reviewDueIdsSorted,
      learningIdsSorted,
      newIdsSorted
    ]) {
      if (result.length >= count) break;
      result.addAll(
        _rotate(
          date: date,
          bankIdsSorted: bucket,
          recentlyShownIds: {...recentlyShownIds, ...result},
          count: count - result.length,
        ),
      );
    }
    return result;
  }
}
