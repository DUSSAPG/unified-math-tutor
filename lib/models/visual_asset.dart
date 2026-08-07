/// The kind of educational visual a [VisualAsset] represents. Every category
/// named in the Visual Asset System brief has a value here even though only
/// [staticDiagram] and [formulaCard] ship real content this sprint — adding
/// content for the remaining categories later is then purely an additive
/// JSON/asset edit, never a schema change (matches how
/// `DiscoveryCategory`/`RecallCardType` are already deliberately broader
/// than their first content batch).
enum VisualAssetType {
  staticDiagram,
  formulaCard,
  workedSolutionStep,
  graph,
  geometryConstruction,
  statisticsChart,
  calculatorWalkthrough,
  realWorldIllustration;

  static VisualAssetType fromId(String id) {
    for (final value in VisualAssetType.values) {
      if (value.name == id) return value;
    }
    throw FormatException('Unknown visual asset type "$id".');
  }
}

/// Human review state for a generated/authored asset, mirroring the
/// `pending_review`/`approved` fields already used by the Discovery
/// illustrations ComfyUI pipeline manifest
/// (`content/pipelines/discovery_illustrations/manifest.json`) — kept as a
/// real, checked field here (not just a convention) so a future AI-assisted
/// generation pipeline has a place to flag new assets before they're
/// eligible to ship, without a schema change.
enum VisualAssetReviewStatus {
  approved,
  pendingReview;

  static VisualAssetReviewStatus fromId(String id) {
    for (final value in VisualAssetReviewStatus.values) {
      if (value.name == id) return value;
    }
    throw FormatException('Unknown visual asset review status "$id".');
  }
}

/// Metadata + rendering pointers for one reusable educational visual.
/// Locale-invariant by design (v1: `languageSupport` records which locales
/// the asset's *labels* were checked against, but the art itself is
/// English-labelled only for now — no per-locale asset variants yet, unlike
/// [DiscoveryCard]/[RecallCard]'s locale-keyed text maps).
class VisualAsset {
  const VisualAsset({
    required this.id,
    required this.title,
    required this.topic,
    required this.assetType,
    required this.svgAssetPath,
    required this.accessibilityDescription,
    required this.reviewStatus,
    required this.contentVersion,
    this.subtopic,
    this.examBoards = const [],
    this.difficulty,
    this.curriculumRefs = const [],
    this.keywords = const [],
    this.pngFallbackAssetPath,
    this.source = 'in-house',
    this.license = 'proprietary',
    this.languageSupport = const ['en'],
    this.darkModeReady = false,
  });

  final String id;
  final String title;
  final String topic;
  final String? subtopic;
  final List<String> examBoards;
  final String? difficulty;
  final List<String> curriculumRefs;
  final List<String> keywords;
  final VisualAssetType assetType;

  /// SVG-first per the brief ("SVG first, PNG fallback where required") —
  /// every asset must have one; resolution-independent, so it satisfies the
  /// "scalable graphics" accessibility requirement without extra work.
  final String svgAssetPath;

  /// Only set for assets that genuinely need a raster fallback (none do at
  /// launch — every asset shipped this sprint is a hand-authored SVG).
  final String? pngFallbackAssetPath;

  final String accessibilityDescription;
  final String source;
  final String license;
  final List<String> languageSupport;

  /// Whether the art's own fixed colors already read correctly in both
  /// Dark and Light theme. `false` for every asset shipped this sprint —
  /// these SVGs hardcode the app's pre-Light-Theme dark palette (matching
  /// the pre-existing `assets/manim_static/*.svg` files they sit alongside)
  /// — a known, honest limitation, not a bug: true theme-adaptive SVG
  /// recoloring is future work.
  final bool darkModeReady;

  final int contentVersion;
  final VisualAssetReviewStatus reviewStatus;

  static final RegExp _idPattern = RegExp(r'^[a-z0-9]+(-[a-z0-9]+)+$');

  factory VisualAsset.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    if (id is! String || !_idPattern.hasMatch(id)) {
      throw FormatException(
        'Visual asset id must match ^[a-z0-9]+(-[a-z0-9]+)+\$, got "$id".',
      );
    }

    String field(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException(
            'Visual asset "$id" field "$key" must be a non-empty string.');
      }
      return value;
    }

    List<String> stringList(String key) {
      final value = json[key];
      if (value == null) return const [];
      if (value is! List || value.any((v) => v is! String)) {
        throw FormatException(
            'Visual asset "$id" field "$key" must be a list of strings.');
      }
      return value.cast<String>();
    }

    final assetTypeValue = json['assetType'];
    if (assetTypeValue is! String) {
      throw FormatException('Visual asset "$id" assetType must be a string.');
    }

    final reviewStatusValue = json['reviewStatus'];
    if (reviewStatusValue is! String) {
      throw FormatException(
          'Visual asset "$id" reviewStatus must be a string.');
    }

    final contentVersion = json['contentVersion'];
    if (contentVersion is! int || contentVersion < 1) {
      throw FormatException(
          'Visual asset "$id" contentVersion must be an integer >= 1.');
    }

    final darkModeReadyValue = json['darkModeReady'];
    if (darkModeReadyValue != null && darkModeReadyValue is! bool) {
      throw FormatException(
          'Visual asset "$id" darkModeReady must be a bool if present.');
    }

    return VisualAsset(
      id: id,
      title: field('title'),
      topic: field('topic'),
      subtopic: json['subtopic'] as String?,
      examBoards: stringList('examBoards'),
      difficulty: json['difficulty'] as String?,
      curriculumRefs: stringList('curriculumRefs'),
      keywords: stringList('keywords'),
      assetType: VisualAssetType.fromId(assetTypeValue),
      svgAssetPath: field('svgAssetPath'),
      pngFallbackAssetPath: json['pngFallbackAssetPath'] as String?,
      accessibilityDescription: field('accessibilityDescription'),
      source: (json['source'] as String?) ?? 'in-house',
      license: (json['license'] as String?) ?? 'proprietary',
      languageSupport: json['languageSupport'] == null
          ? const ['en']
          : stringList('languageSupport'),
      darkModeReady: darkModeReadyValue as bool? ?? false,
      contentVersion: contentVersion,
      reviewStatus: VisualAssetReviewStatus.fromId(reviewStatusValue),
    );
  }
}
