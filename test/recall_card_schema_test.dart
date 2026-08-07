import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/recall_card.dart';
import 'package:unified_math_tutor/services/discovery_card_catalog_service.dart';
import 'package:unified_math_tutor/services/recall_card_catalog_service.dart';
import 'package:unified_math_tutor/services/topic_catalog_service.dart';

const _launchLocales = ['en', 'en-GB'];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('launch inventory contains exactly 120 cards with unique ids', () async {
    final cards = await RecallCardCatalogService.instance.all();
    expect(cards, hasLength(120));
    expect(cards.map((c) => c.id).toSet(), hasLength(120));
  });

  test('each of the 6 domains ships exactly 20 launch cards', () async {
    final cards = await RecallCardCatalogService.instance.all();
    final byTopic = <RecallTopic, int>{};
    for (final card in cards) {
      byTopic[card.topicId] = (byTopic[card.topicId] ?? 0) + 1;
    }
    for (final topic in RecallTopic.values) {
      expect(byTopic[topic], 20,
          reason: '${topic.name} should have exactly 20 cards');
    }
  });

  test('all 8 card types are represented in the launch inventory', () async {
    final cards = await RecallCardCatalogService.instance.all();
    final types = cards.map((c) => c.cardType).toSet();
    expect(types, RecallCardType.values.toSet());
  });

  test('every card has non-empty, complete text for en and en-GB', () async {
    final cards = await RecallCardCatalogService.instance.all();
    for (final card in cards) {
      for (final locale in _launchLocales) {
        final text = card.locales[locale];
        expect(text, isNotNull, reason: '${card.id} missing locale "$locale"');
        expect(text!.frontPrompt.trim(), isNotEmpty,
            reason: '${card.id}/$locale frontPrompt empty');
        expect(text.answer.trim(), isNotEmpty,
            reason: '${card.id}/$locale answer empty');
        expect(text.explanation.trim(), isNotEmpty,
            reason: '${card.id}/$locale explanation empty');
        expect(text.commonMistake.trim(), isNotEmpty,
            reason: '${card.id}/$locale commonMistake empty');
        expect(text.whereUsed, isNotEmpty,
            reason: '${card.id}/$locale whereUsed empty');
      }
    }
  });

  test(
      'frontVisualAssetId and frontVisualAlt are set together, never one without the other',
      () async {
    final cards = await RecallCardCatalogService.instance.all();
    for (final card in cards) {
      for (final locale in _launchLocales) {
        final text = card.locales[locale]!;
        if (card.frontVisualAssetId != null) {
          expect(text.frontVisualAlt, isNotNull,
              reason: '${card.id}/$locale has a visual asset but no alt text');
        } else {
          expect(text.frontVisualAlt, isNull,
              reason: '${card.id}/$locale has alt text but no visual asset');
        }
      }
    }
  });

  test('no two cards share the exact same English front prompt', () async {
    final cards = await RecallCardCatalogService.instance.all();
    final prompts = cards
        .map((c) => c.locales['en']!.frontPrompt.trim().toLowerCase())
        .toList();
    expect(prompts.toSet(), hasLength(prompts.length));
  });

  test(
      'no card exposes raw programming notation (bare ^ or *) in learner-facing text',
      () async {
    final cards = await RecallCardCatalogService.instance.all();
    for (final card in cards) {
      final text = card.locales['en']!;
      for (final value in [
        text.frontPrompt,
        text.answer,
        text.explanation,
        text.commonMistake
      ]) {
        expect(value.contains('^'), isFalse,
            reason: '${card.id} exposes a bare "^" in "$value"');
      }
    }
  });

  test(
      'relatedDiscoveryCardIds only reference cards that exist in the Discovery catalog',
      () async {
    final recallCards = await RecallCardCatalogService.instance.all();
    final discoveryCards = await DiscoveryCardCatalogService.instance.all();
    final discoveryIds = discoveryCards.map((c) => c.id).toSet();
    for (final card in recallCards) {
      for (final id in card.relatedDiscoveryCardIds) {
        expect(discoveryIds.contains(id), isTrue,
            reason: '${card.id} references unknown Discovery Card "$id"');
      }
    }
  });

  test(
      'relatedPracticeTopicIds only reference topics that exist in the practice topic catalog',
      () async {
    final recallCards = await RecallCardCatalogService.instance.all();
    final raw =
        jsonDecode(await rootBundle.loadString(TopicCatalogService.assetPath))
            as Map<String, dynamic>;
    final topicIds = (raw['topics'] as List)
        .map((t) => (t as Map<String, dynamic>)['id'] as String)
        .toSet();
    for (final card in recallCards) {
      for (final id in card.relatedPracticeTopicIds) {
        expect(topicIds.contains(id), isTrue,
            reason: '${card.id} references unknown practice topic "$id"');
      }
    }
  });

  test('bundled catalog JSON round-trips through jsonDecode without error',
      () async {
    final raw = await rootBundle.loadString(RecallCardCatalogService.assetPath);
    expect(() => jsonDecode(raw), returnsNormally);
  });
}
