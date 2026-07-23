import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/recall_card.dart';

/// Loads and validates the Recall Card catalog. Mirrors
/// [DiscoveryCardCatalogService]'s fail-fast-on-malformed-data convention:
/// any structural problem in the bundled JSON throws at load time rather
/// than surfacing as a broken card mid-session.
class RecallCardCatalogService {
  RecallCardCatalogService({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  static const assetPath = 'assets/config/recall_cards.json';
  static final RecallCardCatalogService instance = RecallCardCatalogService();

  final AssetBundle _bundle;
  List<RecallCard>? _cards;

  Future<List<RecallCard>> all() async {
    final cached = _cards;
    if (cached != null) return cached;

    final decoded = jsonDecode(await _bundle.loadString(assetPath));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Recall card catalog root must be an object.');
    }
    if (decoded['version'] is! int) {
      throw const FormatException('Recall card catalog "version" must be an integer.');
    }
    final cardsValue = decoded['cards'];
    if (cardsValue is! List || cardsValue.isEmpty) {
      throw const FormatException('Recall card catalog "cards" must be a non-empty list.');
    }

    final cards = <RecallCard>[];
    final seenIds = <String>{};
    for (final value in cardsValue) {
      if (value is! Map<String, dynamic>) {
        throw const FormatException('Recall card entry must be an object.');
      }
      final card = RecallCard.fromJson(value);
      if (!seenIds.add(card.id)) {
        throw FormatException('Recall card catalog contains duplicate id "${card.id}".');
      }
      cards.add(card);
    }

    _cards = List.unmodifiable(cards);
    return _cards!;
  }

  Future<RecallCard> byId(String id) async {
    for (final card in await all()) {
      if (card.id == id) return card;
    }
    throw StateError('No recall card registered with id "$id".');
  }

  Future<List<RecallCard>> byTopic(RecallTopic topic) async {
    return [
      for (final card in await all())
        if (card.topicId == topic) card,
    ];
  }

  Future<List<RecallCard>> byType(RecallCardType type) async {
    return [
      for (final card in await all())
        if (card.cardType == type) card,
    ];
  }

  /// Case-insensitive substring search over id, topic/type names, and the
  /// English-locale front prompt/answer text. RC1 keeps this simple and
  /// synchronous over the already-loaded catalog rather than a search index.
  Future<List<RecallCard>> search(String query) async {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) return const [];
    return [
      for (final card in await all())
        if (_matches(card, trimmed)) card,
    ];
  }

  bool _matches(RecallCard card, String query) {
    final en = card.locales['en'];
    return card.id.contains(query) ||
        card.topicId.name.toLowerCase().contains(query) ||
        card.cardType.name.toLowerCase().contains(query) ||
        (en != null && en.frontPrompt.toLowerCase().contains(query)) ||
        (en != null && en.answer.toLowerCase().contains(query));
  }
}
