/// Which underlying content system a [StudioContentItem] indexes. One
/// member per content type the Studio Content Registry brief names. [game]
/// and [teacherActivity] intentionally have zero registered entries in
/// `assets/config/studio_content_registry.json` — the brief asks for
/// governance to be *prepared* for these, not for real content to be
/// authored, since neither has any existing feature/screen to index yet.
enum StudioContentType {
  interactiveLab,
  discoveryCard,
  recallCard,
  formulaEntry,
  mentalMathsCategory,
  familyActivity,
  game,
  teacherActivity;

  static StudioContentType fromId(String id) {
    for (final value in StudioContentType.values) {
      if (value.name == id) return value;
    }
    throw FormatException('Unknown studio content type "$id".');
  }
}

/// A normalized difficulty scale at the registry layer. No shared
/// difficulty enum exists anywhere else in the app today — Discovery/Recall
/// use their own `CardDifficulty` (foundation/intermediate/advanced),
/// Mental Maths uses `MentalMathsTier`, Formula entries have none at all —
/// so each [StudioContentItem] carries its own normalized value here
/// alongside [StudioContentItem.sourceId], which points back at the real
/// thing and its own native scheme. Values match the brief exactly.
enum StudioContentDifficulty {
  foundation,
  core,
  higher,
  advanced,
  stretch;

  static StudioContentDifficulty fromId(String id) {
    for (final value in StudioContentDifficulty.values) {
      if (value.name == id) return value;
    }
    throw FormatException('Unknown studio content difficulty "$id".');
  }
}

/// Editorial lifecycle status. The only other "status"-shaped concept
/// anywhere in this app is `VisualAsset.reviewStatus`
/// (approved/pendingReview) — this is the fuller 5-stage lifecycle the
/// Studio Content Registry brief asks for.
enum StudioContentStatus {
  draft,
  review,
  approved,
  published,
  retired;

  static StudioContentStatus fromId(String id) {
    for (final value in StudioContentStatus.values) {
      if (value.name == id) return value;
    }
    throw FormatException('Unknown studio content status "$id".');
  }
}

/// The brief's "Learning Objectives" block — every field optional, since
/// most existing content wasn't authored with these in mind and backfilling
/// them is separate future content-ops work, not this sprint's job.
class StudioLearningObjectives {
  const StudioLearningObjectives({
    this.objective,
    this.expectedOutcome,
    this.skillsReinforced = const [],
    this.realWorldApplication,
    this.suggestedNextContentId,
  });

  final String? objective;
  final String? expectedOutcome;
  final List<String> skillsReinforced;
  final String? realWorldApplication;

  /// The [StudioContentItem.id] of a suggested next activity, if any.
  final String? suggestedNextContentId;

  factory StudioLearningObjectives.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const StudioLearningObjectives();
    final skillsValue = json['skillsReinforced'];
    return StudioLearningObjectives(
      objective: json['objective'] as String?,
      expectedOutcome: json['expectedOutcome'] as String?,
      skillsReinforced:
          skillsValue == null ? const [] : (skillsValue as List).cast<String>(),
      realWorldApplication: json['realWorldApplication'] as String?,
      suggestedNextContentId: json['suggestedNextContentId'] as String?,
    );
  }
}

/// One governed entry in the Studio Content Registry
/// (`assets/config/studio_content_registry.json`) — a lightweight,
/// queryable index over already-existing content, not a duplicate content
/// store. [sourceId] always points back at the underlying system's own id
/// ([InteractiveLabId], [DiscoveryCard.id], [RecallCard.id],
/// [FormulaEntry.id], [MentalMathsCategory], [FamilyActivity.id]) so this
/// registry never becomes a second source of truth for the content itself
/// — only for its governance metadata.
///
/// Mirrors [VisualAsset]'s fail-fast-JSON-manifest, lazy-load-on-first-use
/// convention (see [StudioContentRegistryService]).
class StudioContentItem {
  const StudioContentItem({
    required this.id,
    required this.contentType,
    required this.title,
    required this.status,
    required this.contentVersion,
    this.sourceId,
    this.description,
    this.category,
    this.subCategory,
    this.topic,
    this.difficulty,
    this.examBoards = const [],
    this.curriculumRefs = const [],
    this.estimatedMinutes,
    this.prerequisites = const [],
    this.tags = const [],
    this.author,
    this.reviewedDate,
    this.learningObjectives = const StudioLearningObjectives(),
    this.progressServiceKey,
    this.languageSupport = const ['en'],
    this.curriculumVersion,
    this.curriculumAuthority,
    this.curriculumEffectiveDate,
    this.reviewRequired = false,
    this.reviewReason,
    this.lastVerified,
  });

  final String id;
  final StudioContentType contentType;

  /// The id in the underlying content system this entry indexes. `null`
  /// only for [StudioContentType.game]/[StudioContentType.teacherActivity]
  /// entries, since neither type has any real content yet.
  final String? sourceId;

  final String title;
  final String? description;
  final String? category;
  final String? subCategory;
  final String? topic;
  final StudioContentDifficulty? difficulty;
  final List<String> examBoards;

  /// Free-form, deliberately not a closed enum — "do not hardcode UK
  /// assumptions" per the brief. Same approach as
  /// `VisualAsset.curriculumRefs`.
  final List<String> curriculumRefs;

  final int? estimatedMinutes;

  /// Other [StudioContentItem.id]s a learner should ideally complete first.
  final List<String> prerequisites;

  /// Free-form Discovery-style tags (Engineering, Medicine, Sports, ...) —
  /// the brief's own list is explicitly non-exhaustive ("such as"), so this
  /// is a plain string list rather than a closed enum.
  final List<String> tags;

  final StudioContentStatus status;
  final int contentVersion;
  final String? author;
  final DateTime? reviewedDate;
  final StudioLearningObjectives learningObjectives;

  /// Names the existing progress-tracking service that owns analytics for
  /// this item (e.g. `"interactiveLabs"`, `"recallCards"`, `"mentalMaths"`)
  /// — documents the hook the brief's "Analytics Readiness" section asks
  /// for without building new tracking plumbing on top of the
  /// already-real `InteractiveLabsProgressService`/`RecallCardsProgressService`/
  /// `MentalMathsProgressService`. `null` where no tracking exists yet
  /// (Family Activities, Formula entries).
  final String? progressServiceKey;

  /// Which locales the *underlying* content already supports — metadata
  /// about existing coverage, not a duplicate localized-text store (the
  /// real text lives in each content type's own locale-keyed model).
  final List<String> languageSupport;

  // ── Continuous Curriculum Intelligence ────────────────────────────────
  // Lets a future syllabus-monitoring system ask "which content is
  // affected if this authority's curriculum changes" via
  // [StudioContentRegistryService.byCurriculumAuthority] /
  // [StudioContentRegistryService.needingReview] — no monitoring system
  // exists yet to drive these fields automatically, so they start as
  // static, hand-set values.
  final String? curriculumVersion;
  final String? curriculumAuthority;
  final DateTime? curriculumEffectiveDate;
  final bool reviewRequired;
  final String? reviewReason;
  final DateTime? lastVerified;

  static final RegExp _idPattern = RegExp(r'^[a-z0-9]+(-[a-z0-9]+)+$');

  factory StudioContentItem.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    if (id is! String || !_idPattern.hasMatch(id)) {
      throw FormatException(
        'Studio content item id must match ^[a-z0-9]+(-[a-z0-9]+)+\$, got "$id".',
      );
    }

    String field(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException(
            'Studio content item "$id" field "$key" must be a non-empty string.');
      }
      return value;
    }

    List<String> stringList(String key) {
      final value = json[key];
      if (value == null) return const [];
      if (value is! List || value.any((v) => v is! String)) {
        throw FormatException(
            'Studio content item "$id" field "$key" must be a list of strings.');
      }
      return value.cast<String>();
    }

    final contentTypeValue = json['contentType'];
    if (contentTypeValue is! String) {
      throw FormatException(
          'Studio content item "$id" contentType must be a string.');
    }
    final contentType = StudioContentType.fromId(contentTypeValue);

    final sourceId = json['sourceId'];
    if (sourceId != null && sourceId is! String) {
      throw FormatException(
          'Studio content item "$id" sourceId must be a string if present.');
    }
    if (sourceId == null &&
        contentType != StudioContentType.game &&
        contentType != StudioContentType.teacherActivity) {
      throw FormatException(
        'Studio content item "$id" of type "${contentType.name}" must set sourceId.',
      );
    }

    final statusValue = json['status'];
    if (statusValue is! String) {
      throw FormatException(
          'Studio content item "$id" status must be a string.');
    }

    final contentVersion = json['contentVersion'];
    if (contentVersion is! int || contentVersion < 1) {
      throw FormatException(
          'Studio content item "$id" contentVersion must be an integer >= 1.');
    }

    final difficultyValue = json['difficulty'];
    if (difficultyValue != null && difficultyValue is! String) {
      throw FormatException(
          'Studio content item "$id" difficulty must be a string if present.');
    }

    final estimatedMinutesValue = json['estimatedMinutes'];
    if (estimatedMinutesValue != null && estimatedMinutesValue is! int) {
      throw FormatException(
          'Studio content item "$id" estimatedMinutes must be an integer if present.');
    }

    DateTime? parseDate(String key) {
      final value = json[key];
      if (value == null) return null;
      if (value is! String) {
        throw FormatException(
            'Studio content item "$id" field "$key" must be a date string.');
      }
      return DateTime.parse(value);
    }

    final reviewRequiredValue = json['reviewRequired'];
    if (reviewRequiredValue != null && reviewRequiredValue is! bool) {
      throw FormatException(
          'Studio content item "$id" reviewRequired must be a bool if present.');
    }

    return StudioContentItem(
      id: id,
      contentType: contentType,
      sourceId: sourceId as String?,
      title: field('title'),
      description: json['description'] as String?,
      category: json['category'] as String?,
      subCategory: json['subCategory'] as String?,
      topic: json['topic'] as String?,
      difficulty: difficultyValue == null
          ? null
          : StudioContentDifficulty.fromId(difficultyValue),
      examBoards: stringList('examBoards'),
      curriculumRefs: stringList('curriculumRefs'),
      estimatedMinutes: estimatedMinutesValue as int?,
      prerequisites: stringList('prerequisites'),
      tags: stringList('tags'),
      status: StudioContentStatus.fromId(statusValue),
      contentVersion: contentVersion,
      author: json['author'] as String?,
      reviewedDate: parseDate('reviewedDate'),
      learningObjectives: StudioLearningObjectives.fromJson(
          json['learningObjectives'] as Map<String, dynamic>?),
      progressServiceKey: json['progressServiceKey'] as String?,
      languageSupport: json['languageSupport'] == null
          ? const ['en']
          : stringList('languageSupport'),
      curriculumVersion: json['curriculumVersion'] as String?,
      curriculumAuthority: json['curriculumAuthority'] as String?,
      curriculumEffectiveDate: parseDate('curriculumEffectiveDate'),
      reviewRequired: reviewRequiredValue as bool? ?? false,
      reviewReason: json['reviewReason'] as String?,
      lastVerified: parseDate('lastVerified'),
    );
  }
}
