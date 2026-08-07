import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/studio_content_item.dart';

/// Loads, validates, and queries the Studio Content Registry — a governed
/// index over every Studio content type (Interactive Labs, Discovery
/// Cards, Recall Cards, Formula entries, Mental Maths categories, Family
/// Activities, and — schema-ready but with zero entries today — Games and
/// Teacher Activities). Mirrors [DiscoveryCardCatalogService]/
/// [VisualAssetCatalogService]'s fail-fast-on-malformed-data,
/// lazy-load-on-first-use convention.
///
/// The bundled manifest (`assets/config/studio_content_registry.json`) is a
/// bounded, representative sample — all 7 Interactive Labs (which have no
/// metadata registry anywhere else in the app) plus a small selection from
/// each already-cataloged content type — not a full backfill of every
/// existing Discovery Card/Recall Card/Family Activity. Registering the
/// full catalogs is separate future content-ops work, ideally driven by
/// internal authoring tooling rather than hand-written JSON, per the
/// brief's "Authoring Readiness" goal.
///
/// Every `byX()` query method here is, collectively, the brief's
/// "AI-ready query interface": a real, queryable API surface a future
/// Studio section or a future live-AI Tutor layer can call directly. No
/// live AI exists anywhere in this app today, so no request-simulation
/// code was written — this is the interface such a layer would use once
/// one exists.
class StudioContentRegistryService {
  StudioContentRegistryService({AssetBundle? bundle})
      : _bundle = bundle ?? rootBundle;

  static const assetPath = 'assets/config/studio_content_registry.json';
  static final StudioContentRegistryService instance =
      StudioContentRegistryService();

  final AssetBundle _bundle;
  List<StudioContentItem>? _items;

  Future<List<StudioContentItem>> all() async {
    final cached = _items;
    if (cached != null) return cached;

    final decoded = jsonDecode(await _bundle.loadString(assetPath));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
          'Studio content registry root must be an object.');
    }
    if (decoded['version'] is! int) {
      throw const FormatException(
          'Studio content registry "version" must be an integer.');
    }
    final itemsValue = decoded['items'];
    if (itemsValue is! List || itemsValue.isEmpty) {
      throw const FormatException(
          'Studio content registry "items" must be a non-empty list.');
    }

    final items = <StudioContentItem>[];
    final seenIds = <String>{};
    for (final value in itemsValue) {
      if (value is! Map<String, dynamic>) {
        throw const FormatException(
            'Studio content registry entry must be an object.');
      }
      final item = StudioContentItem.fromJson(value);
      if (!seenIds.add(item.id)) {
        throw FormatException(
            'Studio content registry contains duplicate id "${item.id}".');
      }
      items.add(item);
    }

    _items = List.unmodifiable(items);
    return _items!;
  }

  /// Returns `null` for an unknown id rather than throwing — a missing
  /// registry entry must never crash the caller, only signal "not
  /// governed yet."
  Future<StudioContentItem?> byId(String id) async {
    for (final item in await all()) {
      if (item.id == id) return item;
    }
    return null;
  }

  Future<List<StudioContentItem>> byType(StudioContentType type) async {
    return [
      for (final item in await all())
        if (item.contentType == type) item,
    ];
  }

  Future<List<StudioContentItem>> byCategory(String category) async {
    return [
      for (final item in await all())
        if (item.category == category) item,
    ];
  }

  Future<List<StudioContentItem>> byTopic(String topic) async {
    return [
      for (final item in await all())
        if (item.topic == topic) item,
    ];
  }

  Future<List<StudioContentItem>> byDifficulty(
      StudioContentDifficulty difficulty) async {
    return [
      for (final item in await all())
        if (item.difficulty == difficulty) item,
    ];
  }

  Future<List<StudioContentItem>> byTag(String tag) async {
    return [
      for (final item in await all())
        if (item.tags.contains(tag)) item,
    ];
  }

  Future<List<StudioContentItem>> byCurriculumRef(String ref) async {
    return [
      for (final item in await all())
        if (item.curriculumRefs.contains(ref)) item,
    ];
  }

  /// The Continuous Curriculum Intelligence query: "which content is
  /// governed under this exam authority" — the starting point a future
  /// syllabus-change-monitoring system would use to find everything a
  /// curriculum update might affect.
  Future<List<StudioContentItem>> byCurriculumAuthority(
      String authority) async {
    return [
      for (final item in await all())
        if (item.curriculumAuthority == authority) item,
    ];
  }

  /// Every item explicitly flagged as needing editorial review right now.
  Future<List<StudioContentItem>> needingReview() async {
    return [
      for (final item in await all())
        if (item.reviewRequired) item,
    ];
  }
}
