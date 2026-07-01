import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/services/topic_catalog_service.dart';

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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('resolves locale fallback chain through language then English',
      () async {
    final service = TopicCatalogService(bundle: _CatalogBundle('''
{
  "version": 1,
  "topics": [{
    "id": "fractions",
    "aliases": ["Fractions"],
    "locales": {
      "en": {"title": "Fractions", "subtitle": "Operations with fractions"},
      "fr": {"title": "Fractions FR", "subtitle": "Operations FR"}
    }
  }]
}
'''));

    final fr = await service.byId(
      'fractions',
      const Locale('fr', 'CH'),
    );
    final de = await service.byId(
      'fractions',
      const Locale('de', 'CH'),
    );

    expect(fr.title, 'Fractions FR');
    expect(de.title, 'Fractions');
  });

  test('actual catalog has CH topic translations without English title leaks',
      () async {
    final raw = await rootBundle.loadString(TopicCatalogService.assetPath);
    final catalog = jsonDecode(raw) as Map<String, dynamic>;
    final topics = catalog['topics'] as List<dynamic>;
    const chLocales = ['fr-CH', 'de-CH', 'it-CH'];

    for (final topicValue in topics) {
      final topic = topicValue as Map<String, dynamic>;
      final locales = topic['locales'] as Map<String, dynamic>;
      final english = locales['en'] as Map<String, dynamic>;
      final englishTitle = _normalize(english['title'] as String);
      final englishSubtitle = _normalize(english['subtitle'] as String);

      for (final locale in chLocales) {
        final localized = locales[locale] as Map<String, dynamic>?;
        expect(localized, isNotNull, reason: '${topic['id']} missing $locale');
        expect(
          _normalize(localized!['title'] as String),
          isNot(englishTitle),
          reason: '${topic['id']} $locale title leaks English',
        );
        expect(
          _normalize(localized['subtitle'] as String),
          isNot(englishSubtitle),
          reason: '${topic['id']} $locale subtitle leaks English',
        );
      }
    }
  });

  test('resolves raw pack labels through aliases', () async {
    final service = TopicCatalogService();
    final display = await service.byRawLabel(
      'Fractions multiply/divide',
      const Locale('de', 'CH'),
    );

    expect(display.id, 'fractions');
    expect(display.title, isNot('Fractions'));
  });
}

String _normalize(String value) {
  return value
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
      .trim()
      .replaceAll(RegExp(r'\s+'), ' ');
}
