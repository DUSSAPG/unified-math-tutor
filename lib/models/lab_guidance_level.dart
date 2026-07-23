/// Presentation band for Interactive Labs — controls language, terminology
/// depth and how much formal notation is shown, not separate content or a
/// separate engine. A single scenario/challenge set is shared by all three
/// bands; only the surrounding copy and how much is shown changes.
///
/// Never inferred from personal data (age, birth date, etc.) — chosen by the
/// learner, parent or teacher and persisted per learner profile.
enum LabGuidanceLevel {
  explorer('explorer'),
  builder('builder'),
  navigator('navigator');

  const LabGuidanceLevel(this.id);

  final String id;

  /// Builder is the sensible default: plain language plus formal notation,
  /// appropriate for most learners without knowing their age.
  static const LabGuidanceLevel defaultLevel = LabGuidanceLevel.builder;

  static LabGuidanceLevel fromId(String id) {
    for (final value in LabGuidanceLevel.values) {
      if (value.id == id) return value;
    }
    throw FormatException('Unknown lab guidance level "$id".');
  }
}

/// Three pieces of level-appropriate copy for the same concept. Picking the
/// right one is a single switch at the call site — this is not a separate
/// content pipeline, just a small record so every guided-lab string carries
/// its three variants together instead of three parallel lookup tables.
class LevelText {
  const LevelText({required this.explorer, required this.builder, required this.navigator});

  final String explorer;
  final String builder;
  final String navigator;

  String resolve(LabGuidanceLevel level) => switch (level) {
        LabGuidanceLevel.explorer => explorer,
        LabGuidanceLevel.builder => builder,
        LabGuidanceLevel.navigator => navigator,
      };
}
