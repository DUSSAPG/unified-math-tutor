import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/core/market/canton.dart';
import 'package:unified_math_tutor/core/market/market_store.dart';

void main() {
  test('CH canton selection persists and survives cold start', () async {
    SharedPreferences.setMockInitialValues({});

    final firstStore = MarketStore();
    await firstStore.init();
    await firstStore.setMarketAndLocales(
      uiMarketId: 'CH',
      uiLocale: 'it-CH',
      contentLocale: 'en-GB',
      selectedCanton: Canton.byId('TI'),
    );

    final coldStartStore = MarketStore();
    await coldStartStore.init();
    final selection = await coldStartStore.load();

    expect(selection?.uiMarketId, 'CH');
    expect(selection?.uiLocale, 'it-CH');
    expect(selection?.selectedCanton?.id, 'TI');
  });

  test('CH without canton defaults from device locale and persists', () async {
    SharedPreferences.setMockInitialValues({});

    final firstStore = MarketStore();
    await firstStore.init();
    await firstStore.setMarketAndLocales(
      uiMarketId: 'CH',
      uiLocale: 'fr-CH',
      contentLocale: 'en-GB',
    );

    final coldStartStore = MarketStore();
    await coldStartStore.init();
    final selection = await coldStartStore.load(
      deviceLocale: const Locale('fr', 'CH'),
    );

    expect(selection?.selectedCanton?.id, 'GE');
    expect(
      (await SharedPreferences.getInstance()).getString('selectedCanton'),
      'GE',
    );
  });
}
