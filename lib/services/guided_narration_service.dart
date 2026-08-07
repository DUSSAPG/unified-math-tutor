import 'package:flutter/foundation.dart';

import '../models/narration_audio_manifest_entry.dart';
import '../models/narration_message.dart';
import 'interactive_labs_progress_service.dart';
import 'local_preferences_service.dart';
import 'narration_manifest_service.dart';
import 'tts_narrator.dart';

/// Shared Captain Math Guided Narration service: deterministic, authored
/// text shown on-screen and optionally spoken, entirely offline. Never an
/// LLM, never network-backed — every message it ever plays was constructed
/// by a lab from its own local state via `NarrationMessage`.
///
/// Playback preference (in order): pre-generated local audio (via
/// [NarrationManifestService]) -> device/local TTS fallback -> text-only.
/// Text is always shown regardless of which (or whether any) audio path is
/// available, so audio is never required to read the guidance.
class GuidedNarrationService {
  GuidedNarrationService._();
  static final instance = GuidedNarrationService._();

  TtsNarrator _tts = const NoOpTtsNarrator();

  /// Test/integration seam for swapping in a real TTS implementation later
  /// without touching any call site above this service.
  void debugSetTtsNarrator(TtsNarrator narrator) => _tts = narrator;

  final ValueNotifier<NarrationMessage?> current = ValueNotifier(null);

  NarrationMessage? _lastMessage;
  String? _lastLocaleTag;
  int _requestSerial = 0;

  /// Increments on every [play] call — a simple interruption marker other
  /// code (and tests) can use to confirm a stale request never "wins" after
  /// a newer learner action superseded it.
  int get requestSerial => _requestSerial;

  bool get muted => InteractiveLabsProgressService.instance.narrationMuted();
  Future<void> setMuted(bool value) =>
      InteractiveLabsProgressService.instance.setNarrationMuted(value);

  bool get textOnly =>
      InteractiveLabsProgressService.instance.narrationTextOnly();
  Future<void> setTextOnly(bool value) =>
      InteractiveLabsProgressService.instance.setNarrationTextOnly(value);

  double get speed => InteractiveLabsProgressService.instance.narrationSpeed();
  Future<void> setSpeed(double value) =>
      InteractiveLabsProgressService.instance.setNarrationSpeed(value);

  bool get _audioSuppressed =>
      muted ||
      textOnly ||
      LocalPreferencesService.instance.quietStudyMode.value;

  /// Shows [message] as text immediately — spoken guidance always has
  /// identical visible text — and, unless muted/text-only/Quiet Study Mode,
  /// attempts spoken narration. A new call always interrupts whatever was
  /// playing: only one instruction narrates at a time, and a fresh learner
  /// action always takes priority over a stale one.
  void play(NarrationMessage message, {required String localeTag}) {
    _requestSerial++;
    final requestId = _requestSerial;
    _tts.stop();
    _lastMessage = message;
    _lastLocaleTag = localeTag;
    current.value = message;

    if (_audioSuppressed) return;

    final manifestEntry =
        NarrationManifestService.instance.lookup(message.messageId, localeTag);
    if (manifestEntry != null) {
      _playManifestAudio(manifestEntry, requestId);
      return;
    }
    // No pre-generated audio for this message/locale (a normal, expected
    // case, not an error): fall back to device/local TTS.
    _tts.speak(message.text, speed: speed, localeTag: localeTag);
  }

  void _playManifestAudio(NarrationAudioManifestEntry entry, int requestId) {
    // Real playback hook. Intentionally empty until approved local WAV
    // assets exist (see the manifest's `audioAsset` contract) — every call
    // site above already calls through here at the right moment, so
    // wiring in real playback later is a one-line change, not a call-site
    // hunt (mirrors AudioCueService's existing contract).
  }

  /// Replays the last shown instruction (e.g. a "Replay" control).
  void replayLast() {
    final message = _lastMessage;
    final localeTag = _lastLocaleTag;
    if (message == null || localeTag == null) return;
    play(message, localeTag: localeTag);
  }

  /// Test-only reset — this service is a singleton, so tests that assert on
  /// idle state must not see another test's leftover narration.
  @visibleForTesting
  void debugReset() {
    _tts = const NoOpTtsNarrator();
    current.value = null;
    _lastMessage = null;
    _lastLocaleTag = null;
    _requestSerial = 0;
  }
}
