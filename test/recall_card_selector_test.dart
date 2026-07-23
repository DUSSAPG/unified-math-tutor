import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/services/recall_card_selector.dart';

void main() {
  test('quickReview is deterministic for the same date and same candidate membership', () {
    final date = DateTime.utc(2026, 3, 1);
    final due = ['a', 'b'];
    final learning = ['c', 'd', 'e'];
    final fresh = ['f', 'g', 'h'];

    final first = RecallCardSelector.quickReview(
      date: date,
      reviewDueIdsSorted: due,
      learningIdsSorted: learning,
      newIdsSorted: fresh,
      recentlyShownIds: const {},
    );
    final second = RecallCardSelector.quickReview(
      date: date,
      reviewDueIdsSorted: due,
      learningIdsSorted: learning,
      newIdsSorted: fresh,
      recentlyShownIds: const {},
    );
    expect(first, second);
  });

  test('quickReview fills from Review Due first, then Learning, then New', () {
    final result = RecallCardSelector.quickReview(
      date: DateTime.utc(2026, 3, 1),
      reviewDueIdsSorted: ['due-1', 'due-2'],
      learningIdsSorted: ['learn-1', 'learn-2', 'learn-3'],
      newIdsSorted: ['new-1', 'new-2', 'new-3', 'new-4'],
      recentlyShownIds: const {},
      count: 5,
    );
    expect(result, hasLength(5));
    expect(result.where((id) => id.startsWith('due')).length, 2);
    expect(result.where((id) => id.startsWith('learn')).length, 3);
  });

  test('quickReview skips recently-shown ids when enough alternatives exist', () {
    final result = RecallCardSelector.quickReview(
      date: DateTime.utc(2026, 3, 1),
      reviewDueIdsSorted: [],
      learningIdsSorted: [],
      newIdsSorted: ['a', 'b', 'c', 'd', 'e', 'f'],
      recentlyShownIds: {'a', 'b', 'c'},
      count: 3,
    );
    expect(result.toSet().intersection({'a', 'b', 'c'}), isEmpty);
  });

  test('quickReview falls back to a repeat rather than returning fewer than requested', () {
    final result = RecallCardSelector.quickReview(
      date: DateTime.utc(2026, 3, 1),
      reviewDueIdsSorted: [],
      learningIdsSorted: [],
      newIdsSorted: ['a', 'b'],
      recentlyShownIds: {'a', 'b'},
      count: 5,
    );
    expect(result, hasLength(2));
  });

  test('quickReview returns fewer than count when total candidates are scarce', () {
    final result = RecallCardSelector.quickReview(
      date: DateTime.utc(2026, 3, 1),
      reviewDueIdsSorted: ['only-one'],
      learningIdsSorted: [],
      newIdsSorted: [],
      recentlyShownIds: const {},
      count: 5,
    );
    expect(result, ['only-one']);
  });

  test('a different date can produce a different rotation order', () {
    final learning = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
    final day1 = RecallCardSelector.quickReview(
      date: DateTime.utc(2026, 1, 1),
      reviewDueIdsSorted: [],
      learningIdsSorted: learning,
      newIdsSorted: [],
      recentlyShownIds: const {},
      count: 3,
    );
    final day2 = RecallCardSelector.quickReview(
      date: DateTime.utc(2026, 1, 2),
      reviewDueIdsSorted: [],
      learningIdsSorted: learning,
      newIdsSorted: [],
      recentlyShownIds: const {},
      count: 3,
    );
    expect(day1, isNot(day2));
  });
}
