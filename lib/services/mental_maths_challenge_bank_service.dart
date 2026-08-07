import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/mental_maths_challenge.dart';

/// Loads and validates the Mental Maths challenge bank. Mirrors
/// [DiscoveryCardCatalogService]'s fail-fast-on-malformed-data convention.
class MentalMathsChallengeBankService {
  MentalMathsChallengeBankService({AssetBundle? bundle})
      : _bundle = bundle ?? rootBundle;

  static const assetPath = 'assets/config/mental_maths_challenges.json';
  static final MentalMathsChallengeBankService instance =
      MentalMathsChallengeBankService();

  final AssetBundle _bundle;
  Map<MentalMathsCategory, List<MentalMathsChallenge>>? _byCategory;

  Future<Map<MentalMathsCategory, List<MentalMathsChallenge>>> _load() async {
    final cached = _byCategory;
    if (cached != null) return cached;

    final decoded = jsonDecode(await _bundle.loadString(assetPath));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Mental maths bank root must be an object.');
    }
    if (decoded['version'] is! int) {
      throw const FormatException(
          'Mental maths bank "version" must be an integer.');
    }
    final categoriesValue = decoded['categories'];
    if (categoriesValue is! List || categoriesValue.isEmpty) {
      throw const FormatException(
          'Mental maths bank "categories" must be a non-empty list.');
    }

    final byCategory = <MentalMathsCategory, List<MentalMathsChallenge>>{};
    final seenIds = <String>{};
    for (final categoryValue in categoriesValue) {
      if (categoryValue is! Map<String, dynamic>) {
        throw const FormatException(
            'Mental maths bank category entry must be an object.');
      }
      final categoryId = categoryValue['id'];
      if (categoryId is! String) {
        throw const FormatException(
            'Mental maths bank category "id" must be a string.');
      }
      final category = MentalMathsCategory.fromId(categoryId);

      final itemsValue = categoryValue['items'];
      if (itemsValue is! List || itemsValue.isEmpty) {
        throw FormatException(
            'Mental maths bank category "$categoryId" items must be a non-empty list.');
      }
      final challenges = <MentalMathsChallenge>[];
      for (final itemValue in itemsValue) {
        if (itemValue is! Map<String, dynamic>) {
          throw const FormatException(
              'Mental maths bank item must be an object.');
        }
        final challenge = MentalMathsChallenge.fromJson(itemValue, category);
        if (!seenIds.add(challenge.id)) {
          throw FormatException(
              'Mental maths bank contains duplicate id "${challenge.id}".');
        }
        challenges.add(challenge);
      }
      byCategory[category] = List.unmodifiable(challenges);
    }

    _byCategory = byCategory;
    return byCategory;
  }

  Future<List<MentalMathsChallenge>> challengesFor(
      MentalMathsCategory category) async {
    final byCategory = await _load();
    final challenges = byCategory[category];
    if (challenges == null) {
      throw StateError(
          'No mental maths challenges registered for category "$category".');
    }
    return challenges;
  }

  Future<MentalMathsChallenge> byId(
      MentalMathsCategory category, String id) async {
    for (final challenge in await challengesFor(category)) {
      if (challenge.id == id) return challenge;
    }
    throw StateError(
        'No mental maths challenge "$id" in category "$category".');
  }
}
