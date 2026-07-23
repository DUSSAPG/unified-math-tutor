import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/recall_card.dart';
import 'package:unified_math_tutor/services/recall_card_catalog_service.dart';

class _CatalogBundle extends CachingAssetBundle {
  _CatalogBundle(this.catalog);
  final String catalog;

  @override
  Future<String> loadString(String key, {bool cache = true}) async => catalog;

  @override
  Future<ByteData> load(String key) async {
    return ByteData.sublistView(Uint8List.fromList(utf8.encode(catalog)));
  }
}

const _minimalCard = '''
{
  "id": "number-test-card",
  "topicId": "number",
  "cardType": "formula",
  "difficulty": "foundation",
  "curriculumTags": [],
  "relatedDiscoveryCardIds": [],
  "relatedInteractiveLabIds": [],
  "relatedPracticeTopicIds": [],
  "contentVersion": 1,
  "spacedReviewEligible": true,
  "locales": {
    "en": {
      "frontPrompt": "Prompt", "answer": "Answer", "explanation": "Why",
      "commonMistake": "Mistake", "whereUsed": ["Somewhere"]
    }
  }
}
''';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads and validates a minimal well-formed catalog', () async {
    final service = RecallCardCatalogService(
      bundle: _CatalogBundle('{"version": 1, "cards": [$_minimalCard]}'),
    );
    final cards = await service.all();
    expect(cards, hasLength(1));
    expect(cards.single.id, 'number-test-card');
    expect(cards.single.topicId, RecallTopic.number);
    expect(cards.single.cardType, RecallCardType.formula);
  });

  test('throws on duplicate card ids (fail fast, not silently drops)', () async {
    final service = RecallCardCatalogService(
      bundle: _CatalogBundle('{"version": 1, "cards": [$_minimalCard, $_minimalCard]}'),
    );
    expect(service.all(), throwsA(isA<FormatException>()));
  });

  test('throws when a visual asset id is set without a matching frontVisualAlt', () async {
    final malformed = _minimalCard.replaceFirst(
      '"spacedReviewEligible": true,',
      '"spacedReviewEligible": true, "frontVisualAssetId": "some_asset",',
    );
    final service = RecallCardCatalogService(
      bundle: _CatalogBundle('{"version": 1, "cards": [$malformed]}'),
    );
    expect(service.all(), throwsA(isA<FormatException>()));
  });

  test('throws when locales is missing the required "en" entry', () async {
    final malformed = _minimalCard.replaceFirst('"en":', '"fr":');
    final service = RecallCardCatalogService(
      bundle: _CatalogBundle('{"version": 1, "cards": [$malformed]}'),
    );
    expect(service.all(), throwsA(isA<FormatException>()));
  });

  test('byId returns the matching card and throws for an unknown id', () async {
    final service = RecallCardCatalogService(
      bundle: _CatalogBundle('{"version": 1, "cards": [$_minimalCard]}'),
    );
    final card = await service.byId('number-test-card');
    expect(card.id, 'number-test-card');
    expect(service.byId('does-not-exist'), throwsA(isA<StateError>()));
  });

  test('byTopic and byType filter correctly against the real bundled catalog', () async {
    final numberCards = await RecallCardCatalogService.instance.byTopic(RecallTopic.number);
    expect(numberCards, hasLength(20));
    expect(numberCards.every((c) => c.topicId == RecallTopic.number), isTrue);

    final formulaCards = await RecallCardCatalogService.instance.byType(RecallCardType.formula);
    expect(formulaCards, isNotEmpty);
    expect(formulaCards.every((c) => c.cardType == RecallCardType.formula), isTrue);
  });

  test('search matches on id, topic, type and English prompt/answer text', () async {
    final results = await RecallCardCatalogService.instance.search('pythagoras');
    expect(results, isNotEmpty);
    expect(results.any((c) => c.id.contains('pythagoras')), isTrue);
  });

  test('search returns nothing for a blank query', () async {
    final results = await RecallCardCatalogService.instance.search('   ');
    expect(results, isEmpty);
  });
}
