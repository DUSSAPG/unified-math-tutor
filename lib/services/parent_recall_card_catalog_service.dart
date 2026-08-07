import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/parent_recall_card.dart';

/// Loads and validates the Parent Recall Card catalog. Mirrors
/// [RecallCardCatalogService]'s fail-fast-on-malformed-data convention,
/// but is a fully separate service over a separate model and a separate
/// bundled asset — not a filtered view over the student catalog.
class ParentRecallCardCatalogService {
  ParentRecallCardCatalogService({AssetBundle? bundle})
      : _bundle = bundle ?? rootBundle;

  static const assetPath = 'assets/config/parent_recall_cards.json';
  static final ParentRecallCardCatalogService instance =
      ParentRecallCardCatalogService();

  final AssetBundle _bundle;
  List<ParentRecallCard>? _cards;

  Future<List<ParentRecallCard>> all() async {
    final cached = _cards;
    if (cached != null) return cached;

    final decoded = jsonDecode(await _bundle.loadString(assetPath));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
          'Parent recall card catalog root must be an object.');
    }
    if (decoded['version'] is! int) {
      throw const FormatException(
          'Parent recall card catalog "version" must be an integer.');
    }
    final cardsValue = decoded['cards'];
    if (cardsValue is! List || cardsValue.isEmpty) {
      throw const FormatException(
          'Parent recall card catalog "cards" must be a non-empty list.');
    }

    final cards = <ParentRecallCard>[];
    final seenIds = <String>{};
    for (final value in cardsValue) {
      if (value is! Map<String, dynamic>) {
        throw const FormatException(
            'Parent recall card entry must be an object.');
      }
      final card = ParentRecallCard.fromJson(value);
      if (!seenIds.add(card.id)) {
        throw FormatException(
            'Parent recall card catalog contains duplicate id "${card.id}".');
      }
      cards.add(card);
    }

    _cards = List.unmodifiable(cards);
    return _cards!;
  }

  Future<List<ParentRecallCard>> byCategory(
      ParentRecallCardCategory category) async {
    return [
      for (final card in await all())
        if (card.category == category) card,
    ];
  }
}
