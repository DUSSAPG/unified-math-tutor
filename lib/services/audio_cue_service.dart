import 'local_preferences_service.dart';

/// Every meaningful Interactive Labs action that may have a short, optional
/// local sound cue. No background music, no scores, no loops — a cue plays
/// once per action and only ever adds a decorative confirmation on top of
/// the visual/semantic feedback that already carries the information.
enum AudioCue {
  labOpen,
  objectSelect,
  aircraftTurn,
  testLaunch,
  nearMiss,
  success,
  retry,
  reveal,
  nextMission,
  captainMathPrompt,
}

/// Shared local audio-cue contract for Interactive Labs.
///
/// No sound assets exist yet (no ComfyUI/audio pipeline has produced any —
/// that work is intentionally out of scope for this pass). [play] is
/// therefore a real, fully-wired no-op today: every call site in the Labs
/// already calls it at the right moment, gated by the same rules real
/// playback must respect, so dropping in actual asset files later is a
/// one-line change inside this class, not a call-site hunt.
///
/// Rules (checked here so call sites never have to): sound is optional and
/// never carries required information; Quiet Study Mode and the global
/// sound switch are both respected; drag-style repeated cues (e.g.
/// [AudioCue.aircraftTurn]) are throttled so a continuous drag can't fire a
/// cue every frame.
class AudioCueService {
  AudioCueService._();
  static final instance = AudioCueService._();

  DateTime? _lastThrottledPlayAt;
  static const _throttleWindow = Duration(milliseconds: 250);

  bool get _cuesAllowed =>
      LocalPreferencesService.instance.soundEnabled.value &&
      !LocalPreferencesService.instance.quietStudyMode.value;

  /// Plays [cue] if sound is currently allowed. [throttle] should be true
  /// for cues that can fire in rapid succession from continuous gestures
  /// (e.g. dragging the aircraft) so they don't spam.
  void play(AudioCue cue, {bool throttle = false}) {
    if (!_cuesAllowed) return;
    if (throttle) {
      final now = DateTime.now();
      if (_lastThrottledPlayAt != null &&
          now.difference(_lastThrottledPlayAt!) < _throttleWindow) {
        return;
      }
      _lastThrottledPlayAt = now;
    }
    _playAsset(cue);
  }

  /// Real playback hook. Intentionally empty until approved local audio
  /// assets (short WAV/browser-compatible files) exist and are declared in
  /// pubspec.yaml — filling this in is the only change needed to make every
  /// call site above produce sound.
  void _playAsset(AudioCue cue) {
    // No-op: no audio assets exist yet.
  }
}
