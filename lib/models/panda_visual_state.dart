/// The Panda's visual contract for Feed the Hungry Panda. This is the
/// entire surface a presentation widget needs to render Panda — nothing in
/// [lib/widgets/labs/feed_panda/feed_panda_round_controller.dart] (or any
/// other controller/model file) knows how Panda is drawn. That
/// deliberately makes the *visual* implementation swappable later (a
/// governed Rive file or a sprite-atlas animation, once one is approved)
/// without touching the controller: a future `PandaVisual` replacement
/// only needs to accept the same [PandaVisualState] enum and render
/// something for each value.
///
/// RC1 ships a lightweight native-Flutter placeholder
/// (`lib/widgets/labs/feed_panda/panda_visual.dart`) built from shapes —
/// no emoji, no third-party art — that satisfies this contract today.
enum PandaVisualState {
  /// Before the round has started feeding (instruction shown, first fruit
  /// not yet accepted).
  waiting,

  /// Feeding is active; Panda has not yet reached the target count.
  ready,

  /// The brief transition right after the target count is reached, before
  /// the "how many are left?" question appears.
  chewing,

  /// The round is complete (remaining-quantity question answered
  /// correctly).
  happy,

  /// A learner tried to feed Panda after the target was already reached —
  /// a soft, non-punitive nudge, never an error/failure state.
  gentleReminder,
}
