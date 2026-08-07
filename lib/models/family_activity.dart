import 'dart:ui';

/// Family Maths topic taxonomy (see docs — Parent Companion). RC1 ships
/// dedicated activities for a subset of these; the remaining values exist so
/// future content batches are additive JSON edits, never a schema change.
enum FamilyMathsCategory {
  numberSense,
  addition,
  subtraction,
  multiplication,
  division,
  fractions,
  decimals,
  ratio,
  percentages,
  geometry,
  measurement,
  algebra,
  patterns,
  logic,
  mentalMaths,
  spatialReasoning;

  static FamilyMathsCategory fromId(String id) {
    for (final value in FamilyMathsCategory.values) {
      if (value.name == id) return value;
    }
    throw FormatException('Unknown Family Maths category "$id".');
  }
}

/// All parent/child-facing text for an activity in one locale. Every field
/// is required and non-empty by the time [FamilyActivityLocaleText.fromJson]
/// returns successfully — missing/blank fields fail fast at load time rather
/// than at render time, mirroring [DiscoveryCardLocaleText].
class FamilyActivityLocaleText {
  const FamilyActivityLocaleText({
    required this.title,
    required this.materialsNeeded,
    required this.whatYourChildLearns,
    required this.letsExplore,
    required this.questionsToAsk,
    required this.commonMisconceptions,
    required this.tryTomorrow,
    required this.captainMathPrompt,
    required this.alliePrompt,
    this.studioConnectionNote,
  });

  final String title;
  final List<String> materialsNeeded;
  final String whatYourChildLearns;
  final String letsExplore;
  final List<String> questionsToAsk;
  final String commonMisconceptions;
  final String tryTomorrow;

  /// Captain Math speaks to the child — a short, concrete invitation.
  final String captainMathPrompt;

  /// Allie speaks to the parent — reassurance and light guidance, never an
  /// instruction to "teach". Static authored copy, never conversational.
  final String alliePrompt;

  /// Required only when the activity sets a `studioConnection`.
  final String? studioConnectionNote;

  factory FamilyActivityLocaleText.fromJson(
    Map<String, dynamic> json,
    String activityId,
    String localeTag, {
    required bool requireStudioConnectionNote,
  }) {
    String field(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException(
          'Family activity "$activityId" locale "$localeTag" field "$key" must be a non-empty string.',
        );
      }
      return value;
    }

    List<String> stringList(String key, {int minLength = 1}) {
      final value = json[key];
      if (value is! List ||
          value.length < minLength ||
          value.any((item) => item is! String || item.trim().isEmpty)) {
        throw FormatException(
          'Family activity "$activityId" locale "$localeTag" "$key" must be a list of at least $minLength non-empty strings.',
        );
      }
      return value.cast<String>();
    }

    final studioConnectionNote = json['studioConnectionNote'];
    if (requireStudioConnectionNote) {
      if (studioConnectionNote is! String ||
          studioConnectionNote.trim().isEmpty) {
        throw FormatException(
          'Family activity "$activityId" locale "$localeTag" must set a non-empty "studioConnectionNote" (activity has a studioConnection).',
        );
      }
    } else if (studioConnectionNote != null) {
      throw FormatException(
        'Family activity "$activityId" locale "$localeTag" must not set "studioConnectionNote" (activity has no studioConnection).',
      );
    }

    return FamilyActivityLocaleText(
      title: field('title'),
      materialsNeeded: stringList('materialsNeeded'),
      whatYourChildLearns: field('whatYourChildLearns'),
      letsExplore: field('letsExplore'),
      questionsToAsk: stringList('questionsToAsk'),
      commonMisconceptions: field('commonMisconceptions'),
      tryTomorrow: field('tryTomorrow'),
      captainMathPrompt: field('captainMathPrompt'),
      alliePrompt: field('alliePrompt'),
      studioConnectionNote: studioConnectionNote as String?,
    );
  }
}

/// Optional reference into the Manim animation manifest at
/// `assets/manim_static/manifest.json` (a separate, already-established
/// pipeline — see docs/MANIM_PIPELINE_SPEC.md), keyed by that manifest's own
/// `animationId`. Deliberately just a reference, not a duplicate of the
/// manifest's `durationMs`/`outputAsset`/`reviewStatus` fields: those live
/// in exactly one place so they can't drift out of sync. No manifest-loading
/// service exists yet anywhere in this app (every current Manim usage —
/// Flight Path/Football Precision/Maze Driver labs — still hardcodes its own
/// asset path), so this field is inert data ahead of that resolver, same
/// pattern as the Football Lab's Allie summary contract.
class FamilyActivityVisualMetadata {
  const FamilyActivityVisualMetadata({required this.animationId});

  final String animationId;

  factory FamilyActivityVisualMetadata.fromJson(
    Map<String, dynamic> json,
    String activityId,
  ) {
    final animationId = json['animationId'];
    if (animationId is! String || animationId.trim().isEmpty) {
      throw FormatException(
        'Family activity "$activityId" visual.animationId must be a non-empty string.',
      );
    }
    return FamilyActivityVisualMetadata(animationId: animationId);
  }
}

/// A single Family Maths activity. Structural/program-readable fields
/// (category, age range, time range, studio-connection route, ids, version)
/// are locale-invariant; all parent/child-facing prose lives in [locales].
class FamilyActivity {
  const FamilyActivity({
    required this.id,
    required this.category,
    required this.minAgeYears,
    required this.maxAgeYears,
    required this.minMinutes,
    required this.maxMinutes,
    required this.contentVersion,
    required this.locales,
    this.studioConnectionRouteSuffix,
    this.visual,
  });

  final String id;
  final FamilyMathsCategory category;
  final int minAgeYears;
  final int maxAgeYears;
  final int minMinutes;
  final int maxMinutes;
  final int contentVersion;
  final Map<String, FamilyActivityLocaleText> locales;

  /// Relative to `/math-studio/`, e.g. `discovery/kitchen-fractions`. Null
  /// means this activity has no optional Studio connection.
  final String? studioConnectionRouteSuffix;

  /// Null for every activity until a future visual-support pass. See
  /// [FamilyActivityVisualMetadata].
  final FamilyActivityVisualMetadata? visual;

  static final RegExp _idPattern = RegExp(r'^[a-z0-9]+(-[a-z0-9]+)+$');

  factory FamilyActivity.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    if (id is! String || !_idPattern.hasMatch(id)) {
      throw FormatException(
        'Family activity id must match ^[a-z0-9]+(-[a-z0-9]+)+\$, got "$id".',
      );
    }

    final categoryValue = json['category'];
    if (categoryValue is! String) {
      throw FormatException('Family activity "$id" category must be a string.');
    }
    final category = FamilyMathsCategory.fromId(categoryValue);

    int intField(String key, {int min = 0}) {
      final value = json[key];
      if (value is! int || value < min) {
        throw FormatException(
          'Family activity "$id" "$key" must be an integer >= $min.',
        );
      }
      return value;
    }

    final minAgeYears = intField('minAgeYears', min: 3);
    final maxAgeYears = intField('maxAgeYears', min: 3);
    if (maxAgeYears < minAgeYears) {
      throw FormatException(
        'Family activity "$id" maxAgeYears must be >= minAgeYears.',
      );
    }

    final minMinutes = intField('minMinutes', min: 5);
    final maxMinutes = intField('maxMinutes', min: 5);
    if (maxMinutes < minMinutes) {
      throw FormatException(
        'Family activity "$id" maxMinutes must be >= minMinutes.',
      );
    }
    if (minMinutes < 5 || maxMinutes > 10) {
      throw FormatException(
        'Family activity "$id" time range must stay within 5-10 minutes, got $minMinutes-$maxMinutes.',
      );
    }

    final contentVersion = intField('contentVersion', min: 1);

    final studioConnectionRouteSuffix = json['studioConnectionRouteSuffix'];
    if (studioConnectionRouteSuffix != null &&
        (studioConnectionRouteSuffix is! String ||
            studioConnectionRouteSuffix.trim().isEmpty)) {
      throw FormatException(
        'Family activity "$id" studioConnectionRouteSuffix must be a non-empty string if present.',
      );
    }

    final visualValue = json['visual'];
    FamilyActivityVisualMetadata? visual;
    if (visualValue != null) {
      if (visualValue is! Map<String, dynamic>) {
        throw FormatException(
            'Family activity "$id" visual must be an object if present.');
      }
      visual = FamilyActivityVisualMetadata.fromJson(visualValue, id);
    }

    final localesValue = json['locales'];
    if (localesValue is! Map<String, dynamic> || localesValue.isEmpty) {
      throw FormatException(
          'Family activity "$id" locales must be a non-empty object.');
    }
    if (!localesValue.containsKey('en')) {
      throw FormatException('Family activity "$id" locales must include "en".');
    }
    final locales = <String, FamilyActivityLocaleText>{};
    for (final entry in localesValue.entries) {
      final value = entry.value;
      if (value is! Map<String, dynamic>) {
        throw FormatException(
          'Family activity "$id" locale "${entry.key}" must be an object.',
        );
      }
      locales[entry.key] = FamilyActivityLocaleText.fromJson(
        value,
        id,
        entry.key,
        requireStudioConnectionNote: studioConnectionRouteSuffix != null,
      );
    }

    return FamilyActivity(
      id: id,
      category: category,
      minAgeYears: minAgeYears,
      maxAgeYears: maxAgeYears,
      minMinutes: minMinutes,
      maxMinutes: maxMinutes,
      contentVersion: contentVersion,
      locales: locales,
      studioConnectionRouteSuffix: studioConnectionRouteSuffix as String?,
      visual: visual,
    );
  }

  /// Resolves text with a region -> language -> English fallback chain,
  /// mirroring [DiscoveryCard.textFor].
  FamilyActivityLocaleText textFor(Locale locale) {
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
