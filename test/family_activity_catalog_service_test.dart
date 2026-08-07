import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/family_activity.dart';
import 'package:unified_math_tutor/services/family_activity_catalog_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('byId resolves a known activity and throws for an unknown one',
      () async {
    final activity =
        await FamilyActivityCatalogService.instance.byId('build-twenty');
    expect(activity.id, 'build-twenty');
    expect(
      () => FamilyActivityCatalogService.instance.byId('does-not-exist'),
      throwsStateError,
    );
  });

  test('byCategory filters correctly', () async {
    final fractions = await FamilyActivityCatalogService.instance
        .byCategory(FamilyMathsCategory.fractions);
    expect(fractions, hasLength(1));
    expect(fractions.single.id, 'kitchen-fractions');

    final decimals = await FamilyActivityCatalogService.instance
        .byCategory(FamilyMathsCategory.decimals);
    expect(decimals, hasLength(1));
    expect(decimals.single.id, 'travel-maths');
  });

  test('activityOfTheDay is deterministic for the same day', () async {
    final date = DateTime.utc(2026, 3, 10);
    final first =
        await FamilyActivityCatalogService.instance.activityOfTheDay(date);
    final second =
        await FamilyActivityCatalogService.instance.activityOfTheDay(date);
    expect(first.id, second.id);
  });

  test('activityOfTheDay only ever returns a catalog id', () async {
    final activities = await FamilyActivityCatalogService.instance.all();
    final validIds = activities.map((a) => a.id).toSet();
    for (var day = 0; day < 14; day++) {
      final date = DateTime.utc(2026, 1, 1 + day);
      final activity =
          await FamilyActivityCatalogService.instance.activityOfTheDay(date);
      expect(validIds, contains(activity.id));
    }
  });

  test('activityOfTheDay never repeats on consecutive days', () async {
    // Governance requirement: with N > 1 authored activities, a day-offset
    // rotation (dayOffset % N) can never repeat between two consecutive
    // days — verified empirically here rather than just by inspection.
    FamilyActivity? previous;
    for (var day = 0; day < 60; day++) {
      final date = DateTime.utc(2026, 1, 1 + day);
      final activity =
          await FamilyActivityCatalogService.instance.activityOfTheDay(date);
      if (previous != null) {
        expect(activity.id, isNot(previous.id),
            reason: 'day $day repeated the previous day\'s activity');
      }
      previous = activity;
    }
  });

  test('activityOfTheDay rotates through every activity in the catalog',
      () async {
    final activities = await FamilyActivityCatalogService.instance.all();
    final seen = <String>{};
    for (var day = 0; day < activities.length; day++) {
      final date = DateTime.utc(2026, 1, 1 + day);
      final activity =
          await FamilyActivityCatalogService.instance.activityOfTheDay(date);
      seen.add(activity.id);
    }
    expect(seen, activities.map((a) => a.id).toSet(),
        reason:
            'one full cycle should visit every authored activity, none unreachable');
  });
}
