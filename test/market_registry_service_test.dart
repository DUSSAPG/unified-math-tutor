import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/services/market_registry_service.dart';

class _RegistryBundle extends CachingAssetBundle {
  _RegistryBundle(this.registry);

  final String registry;

  @override
  Future<ByteData> load(String key) => throw UnimplementedError();

  @override
  Future<String> loadString(String key, {bool cache = true}) async => registry;
}

void main() {
  test('runtime registry enables base-English US and SG markets only',
      () async {
    final markets = await MarketRegistryService(
      bundle: _RegistryBundle(
        File('assets/market_registry.json').readAsStringSync(),
      ),
    ).load();
    final byId = {for (final market in markets) market.id: market};

    for (final id in ['US', 'SG']) {
      expect(byId[id]?.enabled, isTrue);
      expect(byId[id]?.effectiveLocale, 'en');
      expect(byId[id]?.packLocale, 'en-GB');
    }
    for (final id in ['SE', 'NO', 'DK', 'KR', 'AR']) {
      expect(byId[id]?.enabled, isFalse);
      expect(byId[id]?.devOnly, isTrue);
    }
  });

  test('loads valid market registry schema', () async {
    final markets = await MarketRegistryService(bundle: _RegistryBundle('''
      {
        "version":1,
        "defaultMarket":"UK",
        "markets":[{
          "id":"UK",
          "label":"United Kingdom",
          "defaultLocale":"en-GB",
          "locales":["en-GB"]
        }]
      }
    ''')).load();
    expect(markets.single.id, 'UK');
    expect(markets.single.enabled, isTrue);
    expect(markets.single.effectiveLocale, 'en-GB');
    expect(markets.single.packLocale, 'en-GB');
  });

  test('returns base English effective locale and GB packs for US and SG',
      () async {
    final markets = await MarketRegistryService(bundle: _RegistryBundle('''
      {
        "version":1,
        "defaultMarket":"US",
        "markets":[
          {
            "id":"US",
            "label":"United States",
            "defaultLocale":"en",
            "effectiveLocale":"en",
            "packLocale":"en-GB",
            "locales":["en"]
          },
          {
            "id":"SG",
            "label":"Singapore",
            "defaultLocale":"en",
            "effectiveLocale":"en",
            "packLocale":"en-GB",
            "locales":["en"]
          }
        ]
      }
    ''')).load();
    expect(markets.map((market) => market.effectiveLocale), everyElement('en'));
    expect(markets.map((market) => market.packLocale), everyElement('en-GB'));
  });

  test('rejects default locale outside market locales', () async {
    final service = MarketRegistryService(bundle: _RegistryBundle('''
      {
        "version":1,
        "defaultMarket":"CH",
        "markets":[{
          "id":"CH",
          "label":"Switzerland",
          "defaultLocale":"de-CH",
          "locales":["fr-CH"]
        }]
      }
    '''));
    await expectLater(service.load(), throwsA(isA<FormatException>()));
  });
}
