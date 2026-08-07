import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/family_activity.dart';

/// Loads and validates the Family Maths activity catalog. Mirrors
/// [DiscoveryCardCatalogService]'s fail-fast-on-malformed-data convention:
/// any structural problem in the bundled JSON throws at load time rather
/// than surfacing as a broken activity mid-session.
class FamilyActivityCatalogService {
  FamilyActivityCatalogService({AssetBundle? bundle})
      : _bundle = bundle ?? rootBundle;

  static const assetPath = 'assets/config/family_activities.json';
  static final FamilyActivityCatalogService instance =
      FamilyActivityCatalogService();

  final AssetBundle _bundle;
  List<FamilyActivity>? _activities;

  Future<List<FamilyActivity>> all() async {
    final cached = _activities;
    if (cached != null) return cached;

    final decoded = jsonDecode(await _bundle.loadString(assetPath));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
          'Family activity catalog root must be an object.');
    }
    if (decoded['version'] is! int) {
      throw const FormatException(
          'Family activity catalog "version" must be an integer.');
    }
    final activitiesValue = decoded['activities'];
    if (activitiesValue is! List || activitiesValue.isEmpty) {
      throw const FormatException(
          'Family activity catalog "activities" must be a non-empty list.');
    }

    final activities = <FamilyActivity>[];
    final seenIds = <String>{};
    for (final value in activitiesValue) {
      if (value is! Map<String, dynamic>) {
        throw const FormatException('Family activity entry must be an object.');
      }
      final activity = FamilyActivity.fromJson(value);
      if (!seenIds.add(activity.id)) {
        throw FormatException(
            'Family activity catalog contains duplicate id "${activity.id}".');
      }
      activities.add(activity);
    }

    _activities = List.unmodifiable(activities);
    return _activities!;
  }

  Future<FamilyActivity> byId(String id) async {
    for (final activity in await all()) {
      if (activity.id == id) return activity;
    }
    throw StateError('No family activity registered with id "$id".');
  }

  Future<List<FamilyActivity>> byCategory(FamilyMathsCategory category) async {
    return [
      for (final activity in await all())
        if (activity.category == category) activity,
    ];
  }

  /// Deterministic "activity of the day" — same day, same activity for
  /// everyone, mirroring [DiscoveryCardCatalogService.cardOfTheDay].
  Future<FamilyActivity> activityOfTheDay(DateTime date) async {
    final activities = await all();
    final sortedIds = activities.map((activity) => activity.id).toList()
      ..sort();
    final utcDay = DateTime.utc(date.year, date.month, date.day);
    final dayOffset = utcDay.difference(DateTime.utc(2020, 1, 1)).inDays;
    final id = sortedIds[dayOffset % sortedIds.length];
    return byId(id);
  }
}
