import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/curriculum_manifest.dart';

/// Loads and caches assets/config/curriculum_manifest.json — the canonical,
/// versioned contract [PracticeAvailabilityResolver] and
/// [TopicCapabilityResolver] both read (topic, stage) availability from.
/// Mirrors `PackRegistryService`'s own load-once-cache-forever pattern.
class CurriculumManifestService {
  CurriculumManifestService({AssetBundle? bundle})
      : _bundle = bundle ?? rootBundle;

  static const asset = 'assets/config/curriculum_manifest.json';
  static final instance = CurriculumManifestService();

  final AssetBundle _bundle;
  CurriculumManifest? _manifest;

  Future<CurriculumManifest> load() async {
    final cached = _manifest;
    if (cached != null) return cached;
    final raw = await _bundle.loadString(asset);
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
          'Curriculum manifest root must be an object.');
    }
    final manifest = CurriculumManifest.fromJson(decoded);
    _manifest = manifest;
    return manifest;
  }

  Future<TopicStageRecord?> recordFor(String topicId, String stage) async =>
      (await load()).recordFor(topicId, stage);

  /// Test-only: forces the next [load] to re-read the asset — needed by any
  /// test that runs after another test already populated `instance`'s
  /// cache in the same isolate.
  void resetForTests() => _manifest = null;
}
