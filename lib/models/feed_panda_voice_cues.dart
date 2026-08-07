/// Stable voice cue ids for Feed the Hungry Panda. No live narration is
/// implemented this sprint — these ids exist purely so a future sprint can
/// wire real audio (via the same local-audio-first,
/// `GuidedNarrationService`-style seam used elsewhere) without renegotiating
/// what each moment is called. The activity is fully playable with voice
/// disabled: nothing in the controller or screens depends on these ids
/// actually producing sound.
///
/// Ids are deliberately snake_case (not the app's usual
/// `labsFooNarrationBar` camelCase messageId convention) because they name
/// *content* cues for a specific young-learner activity, not generic
/// per-lab narration triggers — kept as a small, self-contained set rather
/// than added to `assets/config/captain_math_narration_manifest.json`,
/// which is typed to existing `InteractiveLabId`/`NarrationTrigger` shapes
/// this activity doesn't map onto 1:1 (e.g. there is no single "target
/// count" trigger there). See docs/FEED_THE_HUNGRY_PANDA_BUILD_REPORT.md
/// for the Level 2 plan to wire these for real.
class FeedPandaVoiceCues {
  const FeedPandaVoiceCues._();

  /// "Feed Panda 1 apple."
  static const instruction1 = 'feed_panda_instruction_1';

  /// "Feed Panda 2 apples."
  static const instruction2 = 'feed_panda_instruction_2';

  /// "Feed Panda 3 apples."
  static const instruction3 = 'feed_panda_instruction_3';

  /// Spoken once per accepted apple while feeding towards a target of 1.
  static const count1 = 'feed_panda_count_1';

  /// Spoken once per accepted apple while feeding towards a target of 2.
  static const count2 = 'feed_panda_count_2';

  /// Spoken once per accepted apple while feeding towards a target of 3.
  static const count3 = 'feed_panda_count_3';

  /// "Well done! Panda ate {n} apples."
  static const wellDone = 'feed_panda_well_done';

  /// "Panda has enough. Let's count together." — the gentle
  /// overfeeding-attempt reminder.
  static const hasEnough = 'feed_panda_has_enough';

  /// "How many apples are left?"
  static const howManyLeft = 'feed_panda_how_many_left';

  /// The instruction cue for a given [targetCount] (1-3).
  static String instructionFor(int targetCount) => switch (targetCount) {
        1 => instruction1,
        2 => instruction2,
        _ => instruction3,
      };

  /// The per-accepted-apple counting cue for a given [targetCount] (1-3) —
  /// spoken once per fruit as the count advances towards that target.
  static String countFor(int targetCount) => switch (targetCount) {
        1 => count1,
        2 => count2,
        _ => count3,
      };
}
