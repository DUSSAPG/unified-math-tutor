import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/visual_asset.dart';

/// Loads, validates, and caches the Visual Asset registry — the bundled
/// manifest of every reusable educational diagram/graphic in the app.
/// Mirrors [DiscoveryCardCatalogService]/[FormulaLibraryService]'s
/// fail-fast-on-malformed-data, lazy-load-on-first-use convention: no
/// bootstrap wiring, no eager load — the first screen that actually needs a
/// visual asset triggers the (then-cached) load.
class VisualAssetCatalogService {
  VisualAssetCatalogService({AssetBundle? bundle})
      : _bundle = bundle ?? rootBundle;

  static const assetPath = 'assets/config/visual_assets.json';
  static final VisualAssetCatalogService instance = VisualAssetCatalogService();

  final AssetBundle _bundle;
  List<VisualAsset>? _assets;

  Future<List<VisualAsset>> all() async {
    final cached = _assets;
    if (cached != null) return cached;

    final decoded = jsonDecode(await _bundle.loadString(assetPath));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
          'Visual asset registry root must be an object.');
    }
    if (decoded['version'] is! int) {
      throw const FormatException(
          'Visual asset registry "version" must be an integer.');
    }
    final assetsValue = decoded['assets'];
    if (assetsValue is! List || assetsValue.isEmpty) {
      throw const FormatException(
          'Visual asset registry "assets" must be a non-empty list.');
    }

    final assets = <VisualAsset>[];
    final seenIds = <String>{};
    for (final value in assetsValue) {
      if (value is! Map<String, dynamic>) {
        throw const FormatException('Visual asset entry must be an object.');
      }
      final asset = VisualAsset.fromJson(value);
      if (!seenIds.add(asset.id)) {
        throw FormatException(
            'Visual asset registry contains duplicate id "${asset.id}".');
      }
      assets.add(asset);
    }

    _assets = List.unmodifiable(assets);
    return _assets!;
  }

  /// Returns `null` for an unknown id rather than throwing — a missing
  /// visual asset must never crash the screen that requested it, only fall
  /// back to not showing one (see [VisualAssetView]).
  Future<VisualAsset?> byId(String id) async {
    for (final asset in await all()) {
      if (asset.id == id) return asset;
    }
    return null;
  }

  Future<List<VisualAsset>> byTopic(String topic) async {
    return [
      for (final asset in await all())
        if (asset.topic == topic) asset,
    ];
  }

  Future<List<VisualAsset>> byType(VisualAssetType type) async {
    return [
      for (final asset in await all())
        if (asset.assetType == type) asset,
    ];
  }

  Future<List<VisualAsset>> byCurriculumRef(String ref) async {
    return [
      for (final asset in await all())
        if (asset.curriculumRefs.contains(ref)) asset,
    ];
  }
}
