import 'dart:ui';

/// The 10 categories of Parent Recall Card — deliberately not
/// [RecallTopic] (the student exam-curriculum taxonomy): these are
/// everyday parenting situations, not maths syllabus areas.
enum ParentRecallCardCategory {
  conversationStarters,
  homeworkHints,
  kitchenMaths,
  shoppingMaths,
  realLifeAlgebra,
  geometryAroundTheHouse,
  mentalMathsGames,
  budgeting,
  measurement,
  travelPlanning;

  static ParentRecallCardCategory fromId(String id) {
    for (final value in ParentRecallCardCategory.values) {
      if (value.name == id) return value;
    }
    throw FormatException('Unknown parent recall card category "$id".');
  }
}

/// A card's text in one locale — deliberately just two fields (front/back),
/// not the student Recall Card's 4-stage Recognise/Recall/Explain/Connect
/// model: these are quick, practical parent tips, not exam-recall practice.
class ParentRecallCardLocaleText {
  const ParentRecallCardLocaleText({
    required this.front,
    required this.back,
  });

  /// A short, warm prompt — something to say or try right now.
  final String front;

  /// The practical guidance or example behind the front prompt.
  final String back;

  factory ParentRecallCardLocaleText.fromJson(
    Map<String, dynamic> json,
    String cardId,
    String localeTag,
  ) {
    String field(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException(
          'Parent recall card "$cardId" locale "$localeTag" field "$key" must be a non-empty string.',
        );
      }
      return value;
    }

    return ParentRecallCardLocaleText(
      front: field('front'),
      back: field('back'),
    );
  }
}

/// A single Parent Recall Card: warm, practical, confidence-building
/// guidance for parents, never an exam question. Deliberately a distinct
/// model from [RecallCard] (the student flashcard), not a filtered view
/// over it — different taxonomy, different text shape, different purpose.
class ParentRecallCard {
  const ParentRecallCard({
    required this.id,
    required this.category,
    required this.locales,
  });

  final String id;
  final ParentRecallCardCategory category;
  final Map<String, ParentRecallCardLocaleText> locales;

  static final RegExp _idPattern = RegExp(r'^[a-z0-9]+(-[a-z0-9]+)+$');

  factory ParentRecallCard.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    if (id is! String || !_idPattern.hasMatch(id)) {
      throw FormatException(
          'Parent recall card id must match ^[a-z0-9]+(-[a-z0-9]+)+\$, got "$id".');
    }

    final categoryValue = json['category'];
    if (categoryValue is! String) {
      throw FormatException(
          'Parent recall card "$id" category must be a string.');
    }
    final category = ParentRecallCardCategory.fromId(categoryValue);

    final localesValue = json['locales'];
    if (localesValue is! Map<String, dynamic> || localesValue.isEmpty) {
      throw FormatException(
          'Parent recall card "$id" locales must be a non-empty object.');
    }
    if (!localesValue.containsKey('en')) {
      throw FormatException(
          'Parent recall card "$id" locales must include "en".');
    }
    final locales = <String, ParentRecallCardLocaleText>{};
    for (final entry in localesValue.entries) {
      final value = entry.value;
      if (value is! Map<String, dynamic>) {
        throw FormatException(
            'Parent recall card "$id" locale "${entry.key}" must be an object.');
      }
      locales[entry.key] =
          ParentRecallCardLocaleText.fromJson(value, id, entry.key);
    }

    return ParentRecallCard(id: id, category: category, locales: locales);
  }

  /// Resolves text with a region -> language -> English fallback chain,
  /// mirroring every other locale-keyed content model in this app
  /// (`RecallCard.textFor`, `DiscoveryCard.textFor`, `FamilyActivity.textFor`).
  ParentRecallCardLocaleText textFor(Locale locale) {
    final countryCode = locale.countryCode;
    final languageCode = locale.languageCode;
    final tags = <String>[
      if (countryCode != null && countryCode.isNotEmpty)
        '$languageCode-$countryCode',
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
