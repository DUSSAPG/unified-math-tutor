import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/discovery_card.dart';

/// Discovery Card content only ships region-qualified translations
/// (en, en-GB, de-CH, fr-CH, it-CH) — narrower than the app's 20-locale UI
/// chrome. `textFor` must try the same-language `-CH` translation before
/// falling all the way to English, so a bare `de`/`fr`/`it` learner (no
/// region code, or a different region) gets the real translation that
/// already exists rather than silently losing it to an English fallback.
void main() {
  DiscoveryCardLocaleText text(String marker) => DiscoveryCardLocaleText(
        title: marker,
        scenario: marker,
        challengeQuestion: marker,
        thinkPrompt: marker,
        workedSteps: [marker],
        explanation: marker,
        whereYoullUseThis: marker,
        followUpQuestion: marker,
        followUpAnswerText: marker,
        illustrationAlt: marker,
      );

  DiscoveryCard cardWithLocales(Map<String, DiscoveryCardLocaleText> locales) => DiscoveryCard(
        id: 'test-card',
        category: DiscoveryCategory.everydayLife,
        sport: null,
        difficulty: CardDifficulty.foundation,
        curriculumTags: const [],
        illustrationAssetId: 'test-card',
        relatedDisciplineIds: const ['everydayLife'],
        contentVersion: 1,
        followUp: const DiscoveryCardFollowUp(answerValue: 1),
        locales: locales,
      );

  test('bare "de" locale resolves to the de-CH translation, not English', () {
    final card = cardWithLocales({
      'en': text('english'),
      'de-CH': text('swiss-german'),
    });

    expect(card.textFor(const Locale('de')).title, 'swiss-german');
  });

  test('bare "fr" locale resolves to the fr-CH translation, not English', () {
    final card = cardWithLocales({
      'en': text('english'),
      'fr-CH': text('swiss-french'),
    });

    expect(card.textFor(const Locale('fr')).title, 'swiss-french');
  });

  test('bare "it" locale resolves to the it-CH translation, not English', () {
    final card = cardWithLocales({
      'en': text('english'),
      'it-CH': text('swiss-italian'),
    });

    expect(card.textFor(const Locale('it')).title, 'swiss-italian');
  });

  test('a different German region (de-DE) still resolves to de-CH before English', () {
    final card = cardWithLocales({
      'en': text('english'),
      'de-CH': text('swiss-german'),
    });

    expect(card.textFor(const Locale('de', 'DE')).title, 'swiss-german');
  });

  test('exact region match still wins over the -CH fallback', () {
    final card = cardWithLocales({
      'en': text('english'),
      'de-CH': text('swiss-german'),
    });

    expect(card.textFor(const Locale('de', 'CH')).title, 'swiss-german');
  });

  test('a language with no translation at all still falls back to English', () {
    final card = cardWithLocales({
      'en': text('english'),
      'de-CH': text('swiss-german'),
    });

    expect(card.textFor(const Locale('ko')).title, 'english');
  });

  test('English locale variants resolve directly, never touching the -CH fallback', () {
    final card = cardWithLocales({
      'en': text('english'),
      'en-GB': text('british'),
    });

    expect(card.textFor(const Locale('en', 'GB')).title, 'british');
    expect(card.textFor(const Locale('en', 'US')).title, 'english');
  });
}
