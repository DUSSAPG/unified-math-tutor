import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/discovery_card.dart';
import 'package:unified_math_tutor/services/discovery_card_catalog_service.dart';

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
  "id": "shopping-test-card",
  "category": "shopping",
  "sport": null,
  "difficulty": "foundation",
  "curriculumTags": [],
  "illustrationAssetId": "shopping_test_card",
  "relatedDisciplineIds": ["businessFinance"],
  "contentVersion": 1,
  "followUp": { "answerValue": 5, "answerUnit": null },
  "locales": {
    "en": {
      "title": "Test", "scenario": "Scenario", "challengeQuestion": "Q?",
      "thinkPrompt": "Think", "workedSteps": ["Step 1"], "explanation": "Why",
      "whereYoullUseThis": "Uses", "followUpQuestion": "FQ?",
      "followUpAnswerText": "5", "illustrationAlt": "Alt"
    }
  }
}
''';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads and validates a minimal well-formed catalog', () async {
    final service = DiscoveryCardCatalogService(
      bundle: _CatalogBundle('{"version": 1, "cards": [$_minimalCard]}'),
    );
    final cards = await service.all();
    expect(cards, hasLength(1));
    expect(cards.single.id, 'shopping-test-card');
    expect(cards.single.category, DiscoveryCategory.shopping);
  });

  test('throws on duplicate card ids (fail fast, not silently drops)',
      () async {
    final service = DiscoveryCardCatalogService(
      bundle: _CatalogBundle(
        '{"version": 1, "cards": [$_minimalCard, $_minimalCard]}',
      ),
    );
    expect(service.all(), throwsA(isA<FormatException>()));
  });

  test('throws when a sports card is missing its sport tag', () async {
    final malformed = _minimalCard.replaceFirst(
      '"category": "shopping"',
      '"category": "sports"',
    );
    final service = DiscoveryCardCatalogService(
      bundle: _CatalogBundle('{"version": 1, "cards": [$malformed]}'),
    );
    expect(service.all(), throwsA(isA<FormatException>()));
  });

  test('byId returns the matching card and throws for an unknown id', () async {
    final service = DiscoveryCardCatalogService(
      bundle: _CatalogBundle('{"version": 1, "cards": [$_minimalCard]}'),
    );
    final card = await service.byId('shopping-test-card');
    expect(card.id, 'shopping-test-card');
    expect(service.byId('does-not-exist'), throwsA(isA<StateError>()));
  });

  test('cardOfTheDay is deterministic for the same date', () async {
    final service = DiscoveryCardCatalogService();
    final first = await service.cardOfTheDay(DateTime.utc(2026, 3, 1));
    final second = await service.cardOfTheDay(DateTime.utc(2026, 3, 1));
    expect(first.id, second.id);
  });

  test('resolves text with region -> language -> English fallback', () async {
    final withFrenchOnly = _minimalCard.replaceFirst(
      '"illustrationAlt": "Alt"\n    }',
      '"illustrationAlt": "Alt"\n    },'
          '\n    "fr": {"title": "Titre FR", "scenario": "Scenario FR", '
          '"challengeQuestion": "Q FR?", "thinkPrompt": "Reflechis", '
          '"workedSteps": ["Etape 1"], "explanation": "Pourquoi", '
          '"whereYoullUseThis": "Usages", "followUpQuestion": "FQ FR?", '
          '"followUpAnswerText": "5", "illustrationAlt": "Alt FR"}',
    );
    final service = DiscoveryCardCatalogService(
      bundle: _CatalogBundle('{"version": 1, "cards": [$withFrenchOnly]}'),
    );
    final card = await service.byId('shopping-test-card');
    expect(card.textFor(const Locale('fr', 'CH')).title, 'Titre FR');
    expect(card.textFor(const Locale('de', 'CH')).title, 'Test');
  });
}
