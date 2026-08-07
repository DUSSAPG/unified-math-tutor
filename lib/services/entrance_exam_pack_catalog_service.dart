import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/entrance_exam_pack.dart';

/// Loads and validates the Entrance Exam Pack registry. Mirrors
/// [DiscoveryCardCatalogService]'s fail-fast-on-malformed-data convention:
/// any structural problem in the bundled JSON throws at load time rather
/// than surfacing as a broken pack mid-session.
class EntranceExamPackCatalogService {
  EntranceExamPackCatalogService({AssetBundle? bundle})
      : _bundle = bundle ?? rootBundle;

  static const assetPath = 'assets/config/entrance_exam_packs.json';
  static final EntranceExamPackCatalogService instance =
      EntranceExamPackCatalogService();

  final AssetBundle _bundle;
  List<EntranceExamPack>? _packs;

  Future<List<EntranceExamPack>> all() async {
    final cached = _packs;
    if (cached != null) return cached;

    final decoded = jsonDecode(await _bundle.loadString(assetPath));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
          'Entrance exam pack registry root must be an object.');
    }
    if (decoded['version'] is! int) {
      throw const FormatException(
          'Entrance exam pack registry "version" must be an integer.');
    }
    final packsValue = decoded['packs'];
    if (packsValue is! List || packsValue.isEmpty) {
      throw const FormatException(
          'Entrance exam pack registry "packs" must be a non-empty list.');
    }

    final packs = <EntranceExamPack>[];
    final seenIds = <String>{};
    for (final value in packsValue) {
      if (value is! Map<String, dynamic>) {
        throw const FormatException(
            'Entrance exam pack entry must be an object.');
      }
      final pack = EntranceExamPack.fromJson(value);
      if (!seenIds.add(pack.packId)) {
        throw FormatException(
            'Entrance exam pack registry contains duplicate id "${pack.packId}".');
      }
      packs.add(pack);
    }

    _packs = List.unmodifiable(packs);
    return _packs!;
  }

  Future<EntranceExamPack> byId(String packId) async {
    for (final pack in await all()) {
      if (pack.packId == packId) return pack;
    }
    throw StateError('No entrance exam pack registered with id "$packId".');
  }
}
