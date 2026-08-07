import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/discovery_card.dart';
import 'package:unified_math_tutor/services/discovery_card_catalog_service.dart';

const _productionLocales = ['en', 'en-GB', 'de-CH', 'fr-CH', 'it-CH'];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('catalog contains exactly 54 cards with unique ids', () async {
    // 24 from RC1 + 30 from Sprint 2's Applied Discovery Category Pack
    // (see docs/APPLIED_DISCOVERY_PACK_BUILD_REPORT.md). Update this
    // count deliberately alongside the audit docs on any future content
    // change.
    final cards = await DiscoveryCardCatalogService.instance.all();
    expect(cards, hasLength(54));
    expect(cards.map((c) => c.id).toSet(), hasLength(54));
  });

  test('every sports card has a sport tag and non-sports cards do not',
      () async {
    final cards = await DiscoveryCardCatalogService.instance.all();
    for (final card in cards) {
      if (card.category == DiscoveryCategory.sports) {
        expect(card.sport, isNotNull,
            reason: '${card.id} is sports but has no sport tag');
      } else {
        expect(card.sport, isNull,
            reason: '${card.id} is not sports but has a sport tag');
      }
    }
  });

  test('all 6 named sports are represented in the RC1 catalog', () async {
    final cards = await DiscoveryCardCatalogService.instance.all();
    final sports = cards.map((c) => c.sport).whereType<SportType>().toSet();
    expect(sports, SportType.values.toSet());
  });

  test('every card has real, non-empty text for all 5 production locales',
      () async {
    final cards = await DiscoveryCardCatalogService.instance.all();
    for (final card in cards) {
      for (final locale in _productionLocales) {
        final text = card.locales[locale];
        expect(text, isNotNull, reason: '${card.id} missing locale "$locale"');
        expect(text!.title.trim(), isNotEmpty,
            reason: '${card.id}/$locale title empty');
        expect(text.scenario.trim(), isNotEmpty,
            reason: '${card.id}/$locale scenario empty');
        expect(text.challengeQuestion.trim(), isNotEmpty,
            reason: '${card.id}/$locale challengeQuestion empty');
        expect(text.workedSteps, isNotEmpty,
            reason: '${card.id}/$locale has no worked steps');
        expect(text.explanation.trim(), isNotEmpty,
            reason: '${card.id}/$locale explanation empty');
        expect(text.whereYoullUseThis.trim(), isNotEmpty,
            reason: '${card.id}/$locale whereYoullUseThis empty');
        expect(text.followUpQuestion.trim(), isNotEmpty,
            reason: '${card.id}/$locale followUpQuestion empty');
        expect(text.followUpAnswerText.trim(), isNotEmpty,
            reason: '${card.id}/$locale followUpAnswerText empty');
        expect(text.illustrationAlt.trim(), isNotEmpty,
            reason: '${card.id}/$locale illustrationAlt empty');
      }
    }
  });

  test('CH locale titles do not silently leak the English string', () async {
    final cards = await DiscoveryCardCatalogService.instance.all();
    const chLocales = ['de-CH', 'fr-CH', 'it-CH'];
    for (final card in cards) {
      final english = card.locales['en']!;
      for (final locale in chLocales) {
        final localized = card.locales[locale]!;
        expect(
          _normalize(localized.scenario),
          isNot(_normalize(english.scenario)),
          reason: '${card.id}/$locale scenario leaks English',
        );
      }
    }
  });

  test('no runtime-forbidden "Vedic Maths" label anywhere in the catalog',
      () async {
    final raw =
        await rootBundle.loadString(DiscoveryCardCatalogService.assetPath);
    expect(raw.toLowerCase().contains('vedic'), isFalse);
  });

  test(
      'deferred categories (still no card, post-Sprint-2) validate against the schema',
      () async {
    // gaming/businessFinance ship no dedicated card (Sprint 2's Applied
    // Discovery Category Pack populated engineeringConstruction and
    // artDesign, which used to be in this list too — see
    // docs/APPLIED_DISCOVERY_PACK_BUILD_REPORT.md), but must remain
    // valid, parseable enum values so a future content-only batch can
    // add cards without a schema change.
    for (final id in ['gaming', 'businessFinance']) {
      expect(() => DiscoveryCategory.fromId(id), returnsNormally);
    }
  });

  test(
      "Sprint 2's 3 new categories (no enum value before this sprint) parse correctly",
      () async {
    for (final id in [
      'architectureConstruction',
      'environmentClimate',
      'computingCryptography',
    ]) {
      expect(() => DiscoveryCategory.fromId(id), returnsNormally);
    }
  });

  test('bundled catalog JSON round-trips through jsonDecode without error',
      () async {
    final raw =
        await rootBundle.loadString(DiscoveryCardCatalogService.assetPath);
    expect(() => jsonDecode(raw), returnsNormally);
  });
}

String _normalize(String value) =>
    value.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
