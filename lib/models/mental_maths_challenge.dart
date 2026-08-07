import 'dart:ui';

/// Fixed ordinal order — `.index` (0-9) is used directly for deterministic
/// daily-challenge selection. Never resort to `String.hashCode` for anything
/// determinism-sensitive: it is not guaranteed stable across SDK versions or
/// between CI and device.
///
/// Alternative strategies inspired by different mathematical traditions may
/// later be folded into this bank's content, but no single methodology names
/// or defines this section.
enum MentalMathsCategory {
  numberBonds,
  decomposition,
  compensation,
  estimation,
  multiplicationStrategies,
  divisionStrategies,
  percentages,
  fractions,
  placeValue,
  patternRecognition;

  static MentalMathsCategory fromId(String id) {
    for (final value in MentalMathsCategory.values) {
      if (value.name == id) return value;
    }
    throw FormatException('Unknown mental maths category "$id".');
  }
}

enum MentalMathsTier {
  foundation,
  intermediate,
  advanced;

  static MentalMathsTier fromId(String id) {
    for (final value in MentalMathsTier.values) {
      if (value.name == id) return value;
    }
    throw FormatException('Unknown mental maths tier "$id".');
  }
}

class MentalMathsChallengeLocaleText {
  const MentalMathsChallengeLocaleText({
    required this.prompt,
    required this.workedSteps,
    required this.answerText,
  });

  final String prompt;
  final List<String> workedSteps;
  final String answerText;

  factory MentalMathsChallengeLocaleText.fromJson(
    Map<String, dynamic> json,
    String challengeId,
    String localeTag,
  ) {
    String field(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException(
          'Mental maths challenge "$challengeId" locale "$localeTag" field "$key" must be a non-empty string.',
        );
      }
      return value;
    }

    final stepsValue = json['workedSteps'];
    if (stepsValue is! List ||
        stepsValue.isEmpty ||
        stepsValue.any((step) => step is! String || step.trim().isEmpty)) {
      throw FormatException(
        'Mental maths challenge "$challengeId" locale "$localeTag" "workedSteps" must be a non-empty list of non-empty strings.',
      );
    }

    return MentalMathsChallengeLocaleText(
      prompt: field('prompt'),
      workedSteps: stepsValue.cast<String>(),
      answerText: field('answerText'),
    );
  }
}

/// A single deterministic mental-maths item. Content is authored, not
/// generated at runtime — see [MentalMathsChallengeSelector] for how items
/// are picked deterministically per day/category with repeat protection.
class MentalMathsChallenge {
  const MentalMathsChallenge({
    required this.id,
    required this.category,
    required this.tier,
    required this.answerValue,
    this.answerUnit,
    required this.contentVersion,
    required this.locales,
  });

  final String id;
  final MentalMathsCategory category;
  final MentalMathsTier tier;
  final num answerValue;
  final String? answerUnit;
  final int contentVersion;
  final Map<String, MentalMathsChallengeLocaleText> locales;

  factory MentalMathsChallenge.fromJson(
    Map<String, dynamic> json,
    MentalMathsCategory category,
  ) {
    final id = json['id'];
    if (id is! String || id.trim().isEmpty) {
      throw const FormatException(
          'Mental maths challenge id must be a non-empty string.');
    }

    final tierValue = json['tier'];
    if (tierValue is! String) {
      throw FormatException(
          'Mental maths challenge "$id" tier must be a string.');
    }
    final tier = MentalMathsTier.fromId(tierValue);

    final answerValue = json['answerValue'];
    if (answerValue is! num) {
      throw FormatException(
          'Mental maths challenge "$id" answerValue must be a number.');
    }
    final answerUnit = json['answerUnit'];
    if (answerUnit != null && answerUnit is! String) {
      throw FormatException(
        'Mental maths challenge "$id" answerUnit must be a string if present.',
      );
    }

    final contentVersion = json['contentVersion'];
    if (contentVersion is! int || contentVersion < 1) {
      throw FormatException(
        'Mental maths challenge "$id" contentVersion must be an integer >= 1.',
      );
    }

    final localesValue = json['locales'];
    if (localesValue is! Map<String, dynamic> || localesValue.isEmpty) {
      throw FormatException(
          'Mental maths challenge "$id" locales must be a non-empty object.');
    }
    if (!localesValue.containsKey('en')) {
      throw FormatException(
          'Mental maths challenge "$id" locales must include "en".');
    }
    final locales = <String, MentalMathsChallengeLocaleText>{};
    for (final entry in localesValue.entries) {
      final value = entry.value;
      if (value is! Map<String, dynamic>) {
        throw FormatException(
          'Mental maths challenge "$id" locale "${entry.key}" must be an object.',
        );
      }
      locales[entry.key] =
          MentalMathsChallengeLocaleText.fromJson(value, id, entry.key);
    }

    return MentalMathsChallenge(
      id: id,
      category: category,
      tier: tier,
      answerValue: answerValue,
      answerUnit: answerUnit as String?,
      contentVersion: contentVersion,
      locales: locales,
    );
  }

  MentalMathsChallengeLocaleText textFor(Locale locale) {
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
