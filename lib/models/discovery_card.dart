import 'dart:ui';

/// Discovery Library category taxonomy. RC1 ships dedicated cards for a
/// subset of these (see discovery_cards.json); the remaining values exist so
/// future content batches are additive JSON edits, never a schema change.
enum DiscoveryCategory {
  everydayLife,
  shopping,
  cooking,
  sports,
  aviation,
  truckingLogistics,
  healthcare,
  engineeringConstruction,
  artDesign,
  gaming,
  businessFinance,
  // Added for the Applied Discovery Category Pack (Sprint 2). Distinct
  // from engineeringConstruction (structural/mechanical engineering) —
  // see docs/DISCOVERY_RECALL_COVERAGE_AUDIT.md's "Open risk flagged
  // for Sprint 2" section for why these three needed new values rather
  // than folding into an existing category.
  architectureConstruction,
  environmentClimate,
  computingCryptography;

  static DiscoveryCategory fromId(String id) {
    for (final value in DiscoveryCategory.values) {
      if (value.name == id) return value;
    }
    throw FormatException('Unknown discovery category "$id".');
  }
}

enum SportType {
  cricket,
  football,
  basketball,
  americanFootball,
  baseball,
  tennis;

  static SportType fromId(String id) {
    for (final value in SportType.values) {
      if (value.name == id) return value;
    }
    throw FormatException('Unknown sport type "$id".');
  }
}

enum CardDifficulty {
  foundation,
  intermediate,
  advanced;

  static CardDifficulty fromId(String id) {
    for (final value in CardDifficulty.values) {
      if (value.name == id) return value;
    }
    throw FormatException('Unknown card difficulty "$id".');
  }
}

enum CurriculumTag {
  gcseFoundation,
  gcseHigher,
  igcse;

  static CurriculumTag fromId(String id) {
    for (final value in CurriculumTag.values) {
      if (value.name == id) return value;
    }
    throw FormatException('Unknown curriculum tag "$id".');
  }
}

/// All learner-facing text for a card in one locale. Every field is required
/// and non-empty by the time [DiscoveryCard.fromJson] returns successfully —
/// missing/blank fields fail fast at load time rather than at render time.
class DiscoveryCardLocaleText {
  const DiscoveryCardLocaleText({
    required this.title,
    required this.scenario,
    required this.challengeQuestion,
    required this.thinkPrompt,
    required this.workedSteps,
    required this.explanation,
    required this.whereYoullUseThis,
    required this.followUpQuestion,
    required this.followUpAnswerText,
    required this.illustrationAlt,
  });

  final String title;
  final String scenario;
  final String challengeQuestion;
  final String thinkPrompt;
  final List<String> workedSteps;
  final String explanation;
  final String whereYoullUseThis;
  final String followUpQuestion;
  final String followUpAnswerText;
  final String illustrationAlt;

  factory DiscoveryCardLocaleText.fromJson(
    Map<String, dynamic> json,
    String cardId,
    String localeTag,
  ) {
    String field(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException(
          'Discovery card "$cardId" locale "$localeTag" field "$key" must be a non-empty string.',
        );
      }
      return value;
    }

    final stepsValue = json['workedSteps'];
    if (stepsValue is! List ||
        stepsValue.isEmpty ||
        stepsValue.any((step) => step is! String || step.trim().isEmpty)) {
      throw FormatException(
        'Discovery card "$cardId" locale "$localeTag" "workedSteps" must be a non-empty list of non-empty strings.',
      );
    }

    return DiscoveryCardLocaleText(
      title: field('title'),
      scenario: field('scenario'),
      challengeQuestion: field('challengeQuestion'),
      thinkPrompt: field('thinkPrompt'),
      workedSteps: stepsValue.cast<String>(),
      explanation: field('explanation'),
      whereYoullUseThis: field('whereYoullUseThis'),
      followUpQuestion: field('followUpQuestion'),
      followUpAnswerText: field('followUpAnswerText'),
      illustrationAlt: field('illustrationAlt'),
    );
  }
}

class DiscoveryCardFollowUp {
  const DiscoveryCardFollowUp({required this.answerValue, this.answerUnit});

  final num answerValue;
  final String? answerUnit;

  factory DiscoveryCardFollowUp.fromJson(
    Map<String, dynamic> json,
    String cardId,
  ) {
    final value = json['answerValue'];
    if (value is! num) {
      throw FormatException(
        'Discovery card "$cardId" followUp.answerValue must be a number.',
      );
    }
    final unit = json['answerUnit'];
    if (unit != null && unit is! String) {
      throw FormatException(
        'Discovery card "$cardId" followUp.answerUnit must be a string if present.',
      );
    }
    return DiscoveryCardFollowUp(
        answerValue: value, answerUnit: unit as String?);
  }
}

/// A single Discovery Card. Structural/program-readable fields (category,
/// sport, difficulty, tags, ids, version, follow-up numeric answer) are
/// locale-invariant; all learner-facing prose lives in [locales].
class DiscoveryCard {
  const DiscoveryCard({
    required this.id,
    required this.category,
    required this.sport,
    required this.difficulty,
    required this.curriculumTags,
    required this.illustrationAssetId,
    required this.relatedDisciplineIds,
    required this.contentVersion,
    required this.followUp,
    required this.locales,
  });

  final String id;
  final DiscoveryCategory category;
  final SportType? sport;
  final CardDifficulty difficulty;
  final List<CurriculumTag> curriculumTags;
  final String illustrationAssetId;
  final List<String> relatedDisciplineIds;
  final int contentVersion;
  final DiscoveryCardFollowUp followUp;
  final Map<String, DiscoveryCardLocaleText> locales;

  static final RegExp _idPattern = RegExp(r'^[a-z0-9]+(-[a-z0-9]+)+$');

  factory DiscoveryCard.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    if (id is! String || !_idPattern.hasMatch(id)) {
      throw FormatException(
        'Discovery card id must match ^[a-z0-9]+(-[a-z0-9]+)+\$, got "$id".',
      );
    }

    final categoryValue = json['category'];
    if (categoryValue is! String) {
      throw FormatException('Discovery card "$id" category must be a string.');
    }
    final category = DiscoveryCategory.fromId(categoryValue);

    final sportValue = json['sport'];
    if (category == DiscoveryCategory.sports) {
      if (sportValue is! String) {
        throw FormatException(
          'Discovery card "$id" is category "sports" and must set a "sport".',
        );
      }
    } else if (sportValue != null) {
      throw FormatException(
        'Discovery card "$id" is not category "sports" and must not set a "sport".',
      );
    }
    final sport =
        sportValue == null ? null : SportType.fromId(sportValue as String);

    final difficultyValue = json['difficulty'];
    if (difficultyValue is! String) {
      throw FormatException(
          'Discovery card "$id" difficulty must be a string.');
    }
    final difficulty = CardDifficulty.fromId(difficultyValue);

    final tagsValue = json['curriculumTags'];
    if (tagsValue != null && tagsValue is! List) {
      throw FormatException(
          'Discovery card "$id" curriculumTags must be a list.');
    }
    final curriculumTags = (tagsValue as List<dynamic>? ?? const [])
        .map((tag) => CurriculumTag.fromId(tag as String))
        .toList();

    final illustrationAssetId = json['illustrationAssetId'];
    if (illustrationAssetId is! String || illustrationAssetId.trim().isEmpty) {
      throw FormatException(
        'Discovery card "$id" illustrationAssetId must be a non-empty string.',
      );
    }

    final relatedValue = json['relatedDisciplineIds'];
    if (relatedValue is! List ||
        relatedValue.any((v) => v is! String || v.trim().isEmpty)) {
      throw FormatException(
        'Discovery card "$id" relatedDisciplineIds must be a list of non-empty strings.',
      );
    }

    final contentVersion = json['contentVersion'];
    if (contentVersion is! int || contentVersion < 1) {
      throw FormatException(
        'Discovery card "$id" contentVersion must be an integer >= 1.',
      );
    }

    final followUpValue = json['followUp'];
    if (followUpValue is! Map<String, dynamic>) {
      throw FormatException('Discovery card "$id" followUp must be an object.');
    }
    final followUp = DiscoveryCardFollowUp.fromJson(followUpValue, id);

    final localesValue = json['locales'];
    if (localesValue is! Map<String, dynamic> || localesValue.isEmpty) {
      throw FormatException(
          'Discovery card "$id" locales must be a non-empty object.');
    }
    if (!localesValue.containsKey('en')) {
      throw FormatException('Discovery card "$id" locales must include "en".');
    }
    final locales = <String, DiscoveryCardLocaleText>{};
    for (final entry in localesValue.entries) {
      final value = entry.value;
      if (value is! Map<String, dynamic>) {
        throw FormatException(
          'Discovery card "$id" locale "${entry.key}" must be an object.',
        );
      }
      locales[entry.key] =
          DiscoveryCardLocaleText.fromJson(value, id, entry.key);
    }

    return DiscoveryCard(
      id: id,
      category: category,
      sport: sport,
      difficulty: difficulty,
      curriculumTags: curriculumTags,
      illustrationAssetId: illustrationAssetId,
      relatedDisciplineIds: relatedValue.cast<String>(),
      contentVersion: contentVersion,
      followUp: followUp,
      locales: locales,
    );
  }

  /// Resolves text with a region -> language -> English fallback chain,
  /// mirroring [TopicCatalogService]'s convention.
  DiscoveryCardLocaleText textFor(Locale locale) {
    final countryCode = locale.countryCode;
    final languageCode = locale.languageCode;
    final tags = <String>[
      if (countryCode != null && countryCode.isNotEmpty)
        '$languageCode-$countryCode',
      languageCode,
      // Card content only ships region-qualified translations (de-CH,
      // fr-CH, it-CH), narrower than the app's 20-locale UI-chrome ARB
      // coverage. Before falling all the way to English, try the same
      // language's Swiss-region translation if one exists — a bare `de`,
      // `fr` or `it` learner gets real content in their language instead
      // of silently losing translated text the app already has.
      if (languageCode != 'en') '$languageCode-CH',
      if (languageCode != 'en') 'en',
    ];
    for (final tag in tags) {
      final match = locales[tag];
      if (match != null) return match;
    }
    return locales['en']!;
  }
}
