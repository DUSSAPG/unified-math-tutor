import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/narration_audio_manifest_entry.dart';

/// Loads the local, hand-authored narration audio manifest once at startup.
/// Purely local asset metadata — no network access, ever.
class NarrationManifestService {
  NarrationManifestService._();
  static final instance = NarrationManifestService._();

  List<NarrationAudioManifestEntry> _entries = const [];
  bool _loaded = false;

  bool get isLoaded => _loaded;

  Future<void> init() async {
    try {
      final raw =
          await rootBundle.loadString('assets/config/captain_math_narration_manifest.json');
      final decoded = jsonDecode(raw) as List<dynamic>;
      _entries = decoded
          .map((entry) => NarrationAudioManifestEntry.fromJson(entry as Map<String, dynamic>))
          .toList(growable: false);
    } catch (_) {
      // A missing or corrupt manifest is never fatal: every call site falls
      // back to device TTS, then to text-only, exactly as it would for a
      // message that genuinely has no pre-generated audio yet.
      _entries = const [];
    }
    _loaded = true;
  }

  /// Returns the manifest entry for [messageId] in [localeTag] (e.g.
  /// "de-CH"), falling back first to a bare base-language entry ("de") and
  /// then to any other region variant sharing the same base language (e.g.
  /// an entry tagged "de-CH" also serves a request for "de-AT", since this
  /// manifest only ever tags full region variants, never a bare base
  /// language) — or null if no pre-generated audio exists for this message
  /// at all, a normal, expected case the caller must handle gracefully, not
  /// an error condition.
  NarrationAudioManifestEntry? lookup(String messageId, String localeTag) {
    final base = localeTag.split('-').first;
    NarrationAudioManifestEntry? baseLanguageMatch;
    for (final entry in _entries) {
      if (entry.messageId != messageId) continue;
      if (entry.locale == localeTag) return entry;
      if (entry.locale == base) return entry;
      if (baseLanguageMatch == null && entry.locale.split('-').first == base) {
        baseLanguageMatch = entry;
      }
    }
    return baseLanguageMatch;
  }
}
