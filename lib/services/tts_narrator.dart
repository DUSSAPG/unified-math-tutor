/// Device/local text-to-speech fallback used when no pre-generated audio
/// exists for a narration message. Kept behind this interface so a real
/// on-device TTS plugin can be dropped in later as a single implementation
/// swap — no call site in [GuidedNarrationService] needs to change.
///
/// No such plugin is wired into this app yet (see the guided-narration
/// implementation notes), so [NoOpTtsNarrator] is the only implementation
/// today: it is a real, fully-reachable no-op, not a placeholder that skips
/// call sites.
abstract class TtsNarrator {
  void speak(String text, {required double speed, String? localeTag});
  void stop();
}

class NoOpTtsNarrator implements TtsNarrator {
  const NoOpTtsNarrator();

  @override
  void speak(String text, {required double speed, String? localeTag}) {}

  @override
  void stop() {}
}
