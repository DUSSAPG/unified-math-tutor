import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/sprite_atlas.dart';

/// Loads, validates, and caches one sprite atlas's manifest — part of the
/// (currently dormant) Flutter integration seam for the offline sprite-
/// atlas pipeline (`scripts/asset_pipeline/`,
/// `docs/OFFLINE_SPRITE_ATLAS_PIPELINE.md`).
///
/// Mirrors [VisualAssetCatalogService]'s exact shape: fail-fast on
/// malformed data, lazy-load-and-cache on first use, no bootstrap wiring.
/// Unlike [VisualAssetCatalogService] (one fixed registry for the whole
/// app), the manifest path is a **constructor parameter**, since each
/// atlas (Football Precision, Aircraft Landing, a future Flame game) will
/// have its own — this service is instantiated once per atlas, not used
/// as a single app-wide singleton.
///
/// Not referenced by `main.dart`, `bootstrap.dart`, or any existing
/// screen — a future sprint wires a real instance into whichever lab
/// first adopts atlas-based rendering, with existing procedural rendering
/// staying available as a fallback.
class SpriteAtlasCatalogService {
  SpriteAtlasCatalogService(this.manifestAssetPath, {AssetBundle? bundle})
      : _bundle = bundle ?? rootBundle;

  final String manifestAssetPath;
  final AssetBundle _bundle;

  SpriteAtlas? _atlas;

  Future<SpriteAtlas> load() async {
    final cached = _atlas;
    if (cached != null) return cached;

    final decoded = jsonDecode(await _bundle.loadString(manifestAssetPath));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
          'Sprite atlas manifest root must be an object.');
    }

    final atlas = SpriteAtlas.fromManifestJson(manifestAssetPath, decoded);
    _atlas = atlas;
    return atlas;
  }

  /// Returns `null` for an unknown id rather than throwing — a missing
  /// sprite animation must never crash the screen that requested it, only
  /// fall back to existing procedural rendering.
  Future<SpriteAnimation?> byAssetId(String assetId) async {
    final atlas = await load();
    return atlas.byAssetId(assetId);
  }
}
