import 'dart:ui';

import 'discovery_card.dart' show CardDifficulty, CurriculumTag;

export 'discovery_card.dart' show CardDifficulty, CurriculumTag;

/// Recall Card domain taxonomy. Fixed set for RC1 (number, ratio and
/// proportion, algebra, geometry and measures, statistics, probability) —
/// new domains are an additive enum + JSON change, never a schema change.
enum RecallTopic {
  number,
  ratioAndProportion,
  algebra,
  geometryAndMeasures,
  statistics,
  probability;

  static RecallTopic fromId(String id) {
    for (final value in RecallTopic.values) {
      if (value.name == id) return value;
    }
    throw FormatException('Unknown recall topic "$id".');
  }
}

/// What kind of retrieval-practice item this card is. Deliberately not an
/// ordinary question bank — every card is one of these fixed memory shapes.
enum RecallCardType {
  formula,
  meaning,
  symbol,
  vocabulary,
  strategy,
  misconception,
  visual,
  realWorldConnection;

  static RecallCardType fromId(String id) {
    for (final value in RecallCardType.values) {
      if (value.name == id) return value;
    }
    throw FormatException('Unknown recall card type "$id".');
  }
}

/// All learner-facing text for a card in one locale. Every field required and
/// non-empty by the time [RecallCardLocaleText.fromJson] returns — missing
/// fields fail fast at load time, mirroring [DiscoveryCard]'s convention.
class RecallCardLocaleText {
  const RecallCardLocaleText({
    required this.frontPrompt,
    required this.answer,
    required this.explanation,
    required this.commonMistake,
    required this.whereUsed,
    this.frontVisualAlt,
  });

  /// The Recognise/Recall-stage prompt shown before Reveal.
  final String frontPrompt;

  /// The Reveal-stage content: the fact, formula, definition, or symbol.
  final String answer;

  /// Plain-language explanation shown at the Explain stage.
  final String explanation;

  /// A common mistake learners make with this card's concept.
  final String commonMistake;

  /// Where-used list for the Connect stage (real-world/cross-topic uses).
  final List<String> whereUsed;

  /// Screen-reader description of [RecallCard.frontVisualAssetId], required
  /// when that id is set, otherwise must be omitted.
  final String? frontVisualAlt;

  factory RecallCardLocaleText.fromJson(
    Map<String, dynamic> json,
    String cardId,
    String localeTag, {
    required bool requiresVisualAlt,
  }) {
    String field(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException(
          'Recall card "$cardId" locale "$localeTag" field "$key" must be a non-empty string.',
        );
      }
      return value;
    }

    final whereUsedValue = json['whereUsed'];
    if (whereUsedValue is! List ||
        whereUsedValue.isEmpty ||
        whereUsedValue.any((v) => v is! String || v.trim().isEmpty)) {
      throw FormatException(
        'Recall card "$cardId" locale "$localeTag" "whereUsed" must be a non-empty list of non-empty strings.',
      );
    }

    final visualAltValue = json['frontVisualAlt'];
    if (requiresVisualAlt) {
      if (visualAltValue is! String || visualAltValue.trim().isEmpty) {
        throw FormatException(
          'Recall card "$cardId" locale "$localeTag" must set a non-empty "frontVisualAlt" because frontVisualAssetId is set.',
        );
      }
    } else if (visualAltValue != null) {
      throw FormatException(
        'Recall card "$cardId" locale "$localeTag" must not set "frontVisualAlt" without a frontVisualAssetId.',
      );
    }

    return RecallCardLocaleText(
      frontPrompt: field('frontPrompt'),
      answer: field('answer'),
      explanation: field('explanation'),
      commonMistake: field('commonMistake'),
      whereUsed: whereUsedValue.cast<String>(),
      frontVisualAlt: visualAltValue as String?,
    );
  }
}

/// A single Recall Card. Structural/program-readable fields are
/// locale-invariant; all learner-facing prose lives in [locales].
class RecallCard {
  const RecallCard({
    required this.id,
    required this.topicId,
    required this.cardType,
    required this.difficulty,
    required this.curriculumTags,
    required this.relatedDiscoveryCardIds,
    required this.relatedInteractiveLabIds,
    required this.relatedPracticeTopicIds,
    required this.contentVersion,
    required this.spacedReviewEligible,
    required this.locales,
    this.frontVisualAssetId,
  });

  final String id;
  final RecallTopic topicId;
  final RecallCardType cardType;
  final CardDifficulty difficulty;
  final List<CurriculumTag> curriculumTags;

  /// Optional stable key resolved by a Recall illustration widget. Absent for
  /// most cards — only symbols, misconceptions, geometric relationships,
  /// fraction models and memory cues typically need one.
  final String? frontVisualAssetId;

  final List<String> relatedDiscoveryCardIds;
  final List<String> relatedInteractiveLabIds;
  final List<String> relatedPracticeTopicIds;
  final int contentVersion;

  /// Whether this card is eligible to enter the spaced-review rotation.
  /// False for cards that are reference-only (e.g. shown solely via search)
  /// and should never surface in Review Due / Ask Me Tomorrow.
  final bool spacedReviewEligible;

  final Map<String, RecallCardLocaleText> locales;

  static final RegExp _idPattern = RegExp(r'^[a-z0-9]+(-[a-z0-9]+)+$');

  factory RecallCard.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    if (id is! String || !_idPattern.hasMatch(id)) {
      throw FormatException('Recall card id must match ^[a-z0-9]+(-[a-z0-9]+)+\$, got "$id".');
    }

    final topicValue = json['topicId'];
    if (topicValue is! String) {
      throw FormatException('Recall card "$id" topicId must be a string.');
    }
    final topicId = RecallTopic.fromId(topicValue);

    final cardTypeValue = json['cardType'];
    if (cardTypeValue is! String) {
      throw FormatException('Recall card "$id" cardType must be a string.');
    }
    final cardType = RecallCardType.fromId(cardTypeValue);

    final difficultyValue = json['difficulty'];
    if (difficultyValue is! String) {
      throw FormatException('Recall card "$id" difficulty must be a string.');
    }
    final difficulty = CardDifficulty.fromId(difficultyValue);

    final tagsValue = json['curriculumTags'];
    if (tagsValue != null && tagsValue is! List) {
      throw FormatException('Recall card "$id" curriculumTags must be a list.');
    }
    final curriculumTags = (tagsValue as List<dynamic>? ?? const [])
        .map((tag) => CurriculumTag.fromId(tag as String))
        .toList();

    final frontVisualAssetId = json['frontVisualAssetId'];
    if (frontVisualAssetId != null &&
        (frontVisualAssetId is! String || frontVisualAssetId.trim().isEmpty)) {
      throw FormatException(
        'Recall card "$id" frontVisualAssetId must be a non-empty string if present.',
      );
    }

    List<String> stringList(String key, {bool allowEmpty = true}) {
      final value = json[key];
      if (value is! List || value.any((v) => v is! String || v.trim().isEmpty)) {
        throw FormatException('Recall card "$id" "$key" must be a list of non-empty strings.');
      }
      if (!allowEmpty && value.isEmpty) {
        throw FormatException('Recall card "$id" "$key" must be a non-empty list.');
      }
      return value.cast<String>();
    }

    final contentVersion = json['contentVersion'];
    if (contentVersion is! int || contentVersion < 1) {
      throw FormatException('Recall card "$id" contentVersion must be an integer >= 1.');
    }

    final spacedReviewEligibleValue = json['spacedReviewEligible'];
    if (spacedReviewEligibleValue is! bool) {
      throw FormatException('Recall card "$id" spacedReviewEligible must be a boolean.');
    }

    final localesValue = json['locales'];
    if (localesValue is! Map<String, dynamic> || localesValue.isEmpty) {
      throw FormatException('Recall card "$id" locales must be a non-empty object.');
    }
    if (!localesValue.containsKey('en')) {
      throw FormatException('Recall card "$id" locales must include "en".');
    }
    final locales = <String, RecallCardLocaleText>{};
    for (final entry in localesValue.entries) {
      final value = entry.value;
      if (value is! Map<String, dynamic>) {
        throw FormatException('Recall card "$id" locale "${entry.key}" must be an object.');
      }
      locales[entry.key] = RecallCardLocaleText.fromJson(
        value,
        id,
        entry.key,
        requiresVisualAlt: frontVisualAssetId != null,
      );
    }

    return RecallCard(
      id: id,
      topicId: topicId,
      cardType: cardType,
      difficulty: difficulty,
      curriculumTags: curriculumTags,
      frontVisualAssetId: frontVisualAssetId as String?,
      relatedDiscoveryCardIds: stringList('relatedDiscoveryCardIds'),
      relatedInteractiveLabIds: stringList('relatedInteractiveLabIds'),
      relatedPracticeTopicIds: stringList('relatedPracticeTopicIds'),
      contentVersion: contentVersion,
      spacedReviewEligible: spacedReviewEligibleValue,
      locales: locales,
    );
  }

  /// Resolves text with a region -> language -> English fallback chain,
  /// mirroring [DiscoveryCard.textFor].
  RecallCardLocaleText textFor(Locale locale) {
    final countryCode = locale.countryCode;
    final languageCode = locale.languageCode;
    final tags = <String>[
      if (countryCode != null && countryCode.isNotEmpty) '$languageCode-$countryCode',
      languageCode,
      if (languageCode != 'en') 'en',
    ];
    for (final tag in tags) {
      final match = locales[tag];
      if (match != null) return match;
    }
    return locales['en']!;
  }
}
