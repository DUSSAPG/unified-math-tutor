import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/discovery_card.dart';

/// Loads and validates the Discovery Card catalog. Mirrors
/// [TopicCatalogService]/[PackRegistryService]'s fail-fast-on-malformed-data
/// convention: any structural problem in the bundled JSON throws at load
/// time rather than surfacing as a broken card mid-session.
class DiscoveryCardCatalogService {
  DiscoveryCardCatalogService({AssetBundle? bundle})
      : _bundle = bundle ?? rootBundle;

  static const assetPath = 'assets/config/discovery_cards.json';
  static final DiscoveryCardCatalogService instance =
      DiscoveryCardCatalogService();

  final AssetBundle _bundle;
  List<DiscoveryCard>? _cards;

  Future<List<DiscoveryCard>> all() async {
    final cached = _cards;
    if (cached != null) return cached;

    final decoded = jsonDecode(await _bundle.loadString(assetPath));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
          'Discovery card catalog root must be an object.');
    }
    if (decoded['version'] is! int) {
      throw const FormatException(
          'Discovery card catalog "version" must be an integer.');
    }
    final cardsValue = decoded['cards'];
    if (cardsValue is! List || cardsValue.isEmpty) {
      throw const FormatException(
          'Discovery card catalog "cards" must be a non-empty list.');
    }

    final cards = <DiscoveryCard>[];
    final seenIds = <String>{};
    for (final value in cardsValue) {
      if (value is! Map<String, dynamic>) {
        throw const FormatException('Discovery card entry must be an object.');
      }
      final card = DiscoveryCard.fromJson(value);
      if (!seenIds.add(card.id)) {
        throw FormatException(
            'Discovery card catalog contains duplicate id "${card.id}".');
      }
      cards.add(card);
    }

    _cards = List.unmodifiable(cards);
    return _cards!;
  }

  Future<DiscoveryCard> byId(String id) async {
    for (final card in await all()) {
      if (card.id == id) return card;
    }
    throw StateError('No discovery card registered with id "$id".');
  }

  Future<List<DiscoveryCard>> byCategory(DiscoveryCategory category) async {
    return [
      for (final card in await all())
        if (card.category == category) card,
    ];
  }

  /// Deterministic "card of the day" — same day, same card for everyone,
  /// mirroring [MentalMathVaultService.getDailyTeaser]'s date-keyed pattern.
  Future<DiscoveryCard> cardOfTheDay(DateTime date) async {
    final cards = await all();
    final sortedIds = cards.map((card) => card.id).toList()..sort();
    final utcDay = DateTime.utc(date.year, date.month, date.day);
    final dayOffset = utcDay.difference(DateTime.utc(2020, 1, 1)).inDays;
    final id = sortedIds[dayOffset % sortedIds.length];
    return byId(id);
  }
}
