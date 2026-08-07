/// One row of the pre-generated Captain Math narration audio manifest
/// (`assets/config/captain_math_narration_manifest.json`), matching the
/// local B2/Coqui production workflow's expected fields. Audio for these
/// entries is never generated at runtime — this class only describes
/// metadata about audio that a separate, approved offline pipeline may
/// produce later at the declared [audioAsset] path.
class NarrationAudioManifestEntry {
  const NarrationAudioManifestEntry({
    required this.messageId,
    required this.locale,
    required this.text,
    required this.labId,
    required this.trigger,
    required this.guidanceLevel,
    required this.audioAsset,
    required this.durationMs,
    required this.contentVersion,
  });

  final String messageId;
  final String locale;
  final String text;
  final String labId;
  final String trigger;
  final String guidanceLevel;

  /// Expected path contract: `assets/audio/captain_math/<locale>/<messageId>.wav`
  final String audioAsset;
  final int durationMs;
  final int contentVersion;

  factory NarrationAudioManifestEntry.fromJson(Map<String, dynamic> json) =>
      NarrationAudioManifestEntry(
        messageId: json['messageId'] as String,
        locale: json['locale'] as String,
        text: json['text'] as String,
        labId: json['labId'] as String,
        trigger: json['trigger'] as String,
        guidanceLevel: json['guidanceLevel'] as String,
        audioAsset: json['audioAsset'] as String,
        durationMs: json['durationMs'] as int,
        contentVersion: json['contentVersion'] as int,
      );

  Map<String, dynamic> toJson() => {
        'messageId': messageId,
        'locale': locale,
        'text': text,
        'labId': labId,
        'trigger': trigger,
        'guidanceLevel': guidanceLevel,
        'audioAsset': audioAsset,
        'durationMs': durationMs,
        'contentVersion': contentVersion,
      };
}
