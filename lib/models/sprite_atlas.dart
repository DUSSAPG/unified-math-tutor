/// Runtime types for the offline sprite-atlas pipeline
/// (`scripts/asset_pipeline/`, see `docs/OFFLINE_SPRITE_ATLAS_PIPELINE.md`).
///
/// This file is the **narrow Flutter integration seam** the pipeline
/// brief asked for: every class here is both (a) `const`-constructible,
/// so a pipeline-generated `*_atlas.dart` file can embed a whole atlas as
/// a compile-time constant with zero runtime JSON parsing, and (b)
/// parseable from the pipeline's JSON manifest via `fromJson`/
/// `fromManifestJson`, for the (not-yet-used) case of loading an atlas
/// manifest at runtime instead. `fromJson` mirrors
/// `VisualAsset.fromJson`'s exact fail-fast, required-field-checking
/// style (`lib/models/visual_asset.dart`) rather than inventing a new
/// parsing convention.
///
/// Nothing in this file is referenced from `main.dart`, `bootstrap.dart`,
/// or any existing screen — it is dormant infrastructure a future sprint
/// wires into a real lab.
library;

/// How a [SpriteAnimation] should play back. The string values are the
/// wire format shared with the Python pipeline's `LoopMode` enum
/// (`scripts/asset_pipeline/models.py`) — both sides must agree on them.
enum SpriteLoopMode {
  once('once'),
  loop('loop'),
  pingPong('ping_pong');

  const SpriteLoopMode(this.id);

  final String id;

  static SpriteLoopMode fromId(String id) {
    for (final value in SpriteLoopMode.values) {
      if (value.id == id) return value;
    }
    throw FormatException('Unknown sprite loop mode "$id".');
  }
}

/// One frame's placement within an atlas image, plus enough source
/// provenance (file + hash) to trace it back to the original art.
class SpriteFrameRect {
  const SpriteFrameRect({
    required this.sourceFile,
    required this.sourceHash,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.originalWidth,
    required this.originalHeight,
    required this.trimmedOffsetX,
    required this.trimmedOffsetY,
  });

  final String sourceFile;
  final String sourceHash;
  final int x;
  final int y;
  final int width;
  final int height;
  final int originalWidth;
  final int originalHeight;
  final int trimmedOffsetX;
  final int trimmedOffsetY;

  factory SpriteFrameRect.fromJson(Map<String, dynamic> json) {
    int intField(String key) {
      final value = json[key];
      if (value is! int) {
        throw FormatException('Sprite frame field "$key" must be an int.');
      }
      return value;
    }

    String stringField(String key) {
      final value = json[key];
      if (value is! String || value.isEmpty) {
        throw FormatException(
            'Sprite frame field "$key" must be a non-empty string.');
      }
      return value;
    }

    return SpriteFrameRect(
      sourceFile: stringField('sourceFile'),
      sourceHash: stringField('sourceHash'),
      x: intField('x'),
      y: intField('y'),
      width: intField('width'),
      height: intField('height'),
      originalWidth: intField('originalWidth'),
      originalHeight: intField('originalHeight'),
      trimmedOffsetX: intField('trimmedOffsetX'),
      trimmedOffsetY: intField('trimmedOffsetY'),
    );
  }
}

/// One manifest record: a single sprite or a numbered-sequence animation
/// — both share this shape, a single sprite just has one entry in
/// [frames]. Mirrors the Python pipeline's `AnimationRecord` dataclass
/// field for field.
class SpriteAnimation {
  const SpriteAnimation({
    required this.assetId,
    required this.atlasFile,
    required this.anchorX,
    required this.anchorY,
    required this.frameDurationMs,
    required this.loop,
    required this.reducedMotionFallbackFrame,
    required this.contentVersion,
    required this.verified,
    required this.frames,
  });

  final String assetId;
  final String atlasFile;

  /// Anchor point as a fraction of each frame's *original, untrimmed*
  /// size (default 0.5, 0.5 = centre) — see the anchor convention
  /// documented in `scripts/asset_pipeline/models.py`.
  final double anchorX;
  final double anchorY;

  final int frameDurationMs;
  final SpriteLoopMode loop;
  final int reducedMotionFallbackFrame;
  final int contentVersion;

  /// True once the pipeline's own geometry/schema validation passed for
  /// this atlas at build time — a manifest that made it into
  /// `assets/generated/` should always have this `true`; `false` would
  /// mean a build ran with validation errors and should not have been
  /// published (the CLI's atomic-publish step prevents that in practice).
  final bool verified;

  final List<SpriteFrameRect> frames;

  List<String> get sourceFiles =>
      [for (final frame in frames) frame.sourceFile];
  List<String> get sourceHashes =>
      [for (final frame in frames) frame.sourceHash];

  /// The frame to show under Reduce Motion, index-clamped defensively so
  /// a malformed manifest can never index out of range.
  SpriteFrameRect get reducedMotionFallback =>
      frames[reducedMotionFallbackFrame.clamp(0, frames.length - 1)];

  factory SpriteAnimation.fromJson(Map<String, dynamic> json) {
    final assetId = json['assetId'];
    if (assetId is! String || assetId.isEmpty) {
      throw const FormatException(
          'Sprite animation "assetId" must be a non-empty string.');
    }

    String field(String key) {
      final value = json[key];
      if (value is! String || value.isEmpty) {
        throw FormatException(
            'Sprite animation "$assetId" field "$key" must be a non-empty string.');
      }
      return value;
    }

    int intField(String key) {
      final value = json[key];
      if (value is! int) {
        throw FormatException(
            'Sprite animation "$assetId" field "$key" must be an int.');
      }
      return value;
    }

    final anchor = json['anchor'];
    if (anchor is! Map) {
      throw FormatException(
          'Sprite animation "$assetId" field "anchor" must be an object.');
    }
    final anchorX = anchor['x'];
    final anchorY = anchor['y'];
    if (anchorX is! num || anchorY is! num) {
      throw FormatException(
          'Sprite animation "$assetId" anchor.x/anchor.y must be numbers.');
    }

    final verified = json['verified'];
    if (verified is! bool) {
      throw FormatException(
          'Sprite animation "$assetId" field "verified" must be a bool.');
    }

    final framesValue = json['frames'];
    if (framesValue is! List || framesValue.isEmpty) {
      throw FormatException(
          'Sprite animation "$assetId" field "frames" must be a non-empty list.');
    }
    final frames = [
      for (final frameJson in framesValue)
        SpriteFrameRect.fromJson(frameJson as Map<String, dynamic>),
    ];

    return SpriteAnimation(
      assetId: assetId,
      atlasFile: field('atlasFile'),
      anchorX: anchorX.toDouble(),
      anchorY: anchorY.toDouble(),
      frameDurationMs: intField('frameDurationMs'),
      loop: SpriteLoopMode.fromId(field('loop')),
      reducedMotionFallbackFrame: intField('reducedMotionFallbackFrame'),
      contentVersion: intField('contentVersion'),
      verified: verified,
      frames: frames,
    );
  }
}

/// One built atlas: its image/manifest file paths plus every animation
/// packed into it. Constructed either as a compile-time constant by a
/// pipeline-generated `*_atlas.dart` file, or at runtime via
/// [fromManifestJson] by a future `SpriteAtlasCatalogService`.
class SpriteAtlas {
  const SpriteAtlas({
    required this.atlasId,
    required this.atlasFile,
    required this.manifestFile,
    required this.animations,
  });

  final String atlasId;
  final String atlasFile;
  final String manifestFile;
  final List<SpriteAnimation> animations;

  SpriteAnimation? byAssetId(String assetId) {
    for (final animation in animations) {
      if (animation.assetId == assetId) return animation;
    }
    return null;
  }

  factory SpriteAtlas.fromManifestJson(
    String manifestFile,
    Map<String, dynamic> json,
  ) {
    final atlasId = json['atlasId'];
    if (atlasId is! String || atlasId.isEmpty) {
      throw const FormatException(
          'Sprite atlas manifest "atlasId" must be a non-empty string.');
    }
    final atlasFile = json['atlasFile'];
    if (atlasFile is! String || atlasFile.isEmpty) {
      throw FormatException(
          'Sprite atlas "$atlasId" field "atlasFile" must be a non-empty string.');
    }
    final animationsValue = json['animations'];
    if (animationsValue is! List || animationsValue.isEmpty) {
      throw FormatException(
          'Sprite atlas "$atlasId" field "animations" must be a non-empty list.');
    }

    final seenIds = <String>{};
    final animations = <SpriteAnimation>[];
    for (final animationJson in animationsValue) {
      final animation =
          SpriteAnimation.fromJson(animationJson as Map<String, dynamic>);
      if (!seenIds.add(animation.assetId)) {
        throw FormatException(
            'Sprite atlas "$atlasId" contains duplicate asset id "${animation.assetId}".');
      }
      animations.add(animation);
    }

    return SpriteAtlas(
      atlasId: atlasId,
      atlasFile: atlasFile,
      manifestFile: manifestFile,
      animations: animations,
    );
  }
}
