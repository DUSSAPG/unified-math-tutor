import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/services/mental_maths_challenge_selector.dart';

void main() {
  final bankIds = ['a', 'b', 'c', 'd', 'e'];

  test('same day + same category always resolves to the same id', () {
    final first = MentalMathsChallengeSelector.dailyChallengeId(
      date: DateTime.utc(2026, 3, 1),
      categoryIndex: 2,
      bankIdsSorted: bankIds,
      recentlyShownIds: const {},
    );
    final second = MentalMathsChallengeSelector.dailyChallengeId(
      date: DateTime.utc(2026, 3, 1),
      categoryIndex: 2,
      bankIdsSorted: bankIds,
      recentlyShownIds: const {},
    );
    expect(first, second);
  });

  test('different categories on the same day can resolve to different ids', () {
    final resultsByCategory = {
      for (var i = 0; i < 5; i++)
        i: MentalMathsChallengeSelector.dailyChallengeId(
          date: DateTime.utc(2026, 3, 1),
          categoryIndex: i,
          bankIdsSorted: bankIds,
          recentlyShownIds: const {},
        ),
    };
    // With a 5-item bank and 5 categories spread across the same day offset,
    // every category should land on a distinct base index.
    expect(resultsByCategory.values.toSet(), hasLength(5));
  });

  test('different days for the same category can resolve to different ids', () {
    final day1 = MentalMathsChallengeSelector.dailyChallengeId(
      date: DateTime.utc(2026, 3, 1),
      categoryIndex: 0,
      bankIdsSorted: bankIds,
      recentlyShownIds: const {},
    );
    final day2 = MentalMathsChallengeSelector.dailyChallengeId(
      date: DateTime.utc(2026, 3, 2),
      categoryIndex: 0,
      bankIdsSorted: bankIds,
      recentlyShownIds: const {},
    );
    expect(day1 == day2, isFalse);
  });

  test('repeat protection skips ids already recently shown to this learner', () {
    final withoutHistory = MentalMathsChallengeSelector.dailyChallengeId(
      date: DateTime.utc(2026, 3, 1),
      categoryIndex: 0,
      bankIdsSorted: bankIds,
      recentlyShownIds: const {},
    );
    final withHistory = MentalMathsChallengeSelector.dailyChallengeId(
      date: DateTime.utc(2026, 3, 1),
      categoryIndex: 0,
      bankIdsSorted: bankIds,
      recentlyShownIds: {withoutHistory},
    );
    expect(withHistory, isNot(withoutHistory));
  });

  test('falls back to allowing a repeat once the whole bank has been recently shown', () {
    final result = MentalMathsChallengeSelector.dailyChallengeId(
      date: DateTime.utc(2026, 3, 1),
      categoryIndex: 0,
      bankIdsSorted: bankIds,
      recentlyShownIds: bankIds.toSet(),
    );
    expect(bankIds, contains(result));
  });

  test('throws on an empty bank', () {
    expect(
      () => MentalMathsChallengeSelector.dailyChallengeId(
        date: DateTime.utc(2026, 3, 1),
        categoryIndex: 0,
        bankIdsSorted: const [],
        recentlyShownIds: const {},
      ),
      throwsArgumentError,
    );
  });
}
