/// Pure, deterministic selection logic for Mental Maths daily challenges.
/// No widget/service dependencies — fully unit-testable in isolation.
///
/// Same day + same category always resolves to the same base item for every
/// learner (mirrors [MentalMathVaultService.getDailyTeaser]'s determinism);
/// a per-learner "recently shown" set is then walked forward to avoid
/// repeats without needing a `Random` or the wall clock.
class MentalMathsChallengeSelector {
  MentalMathsChallengeSelector._();

  static final DateTime _epoch = DateTime.utc(2020, 1, 1);

  static String dailyChallengeId({
    required DateTime date,
    required int categoryIndex,
    required List<String> bankIdsSorted,
    required Set<String> recentlyShownIds,
  }) {
    if (bankIdsSorted.isEmpty) {
      throw ArgumentError.value(
          bankIdsSorted, 'bankIdsSorted', 'must not be empty');
    }
    final utcDay = DateTime.utc(date.year, date.month, date.day);
    final dayOffset = utcDay.difference(_epoch).inDays;
    final baseIndex = (dayOffset + categoryIndex) % bankIdsSorted.length;

    for (var i = 0; i < bankIdsSorted.length; i++) {
      final candidate = bankIdsSorted[(baseIndex + i) % bankIdsSorted.length];
      if (!recentlyShownIds.contains(candidate)) return candidate;
    }
    // Bank exhausted for this learner: allow a repeat rather than error.
    return bankIdsSorted[baseIndex];
  }
}
