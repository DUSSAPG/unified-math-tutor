/// Flight Path Lab's local, deterministic outcome classification — the
/// fully worked narration example. Purely a function of the lab's own
/// existing state (heading error, distance error, repeat/inactivity
/// tracking); no new mathematical engine, no procedural generation.
enum FlightOutcome {
  correctHeadingAndDistance,
  correctHeadingTooFar,
  correctHeadingTooShort,
  wrongHeadingCorrectDistance,
  wrongHeadingAndDistance,
  nearMiss,
  repeatedUnchangedAttempt,
  inactivity,
  completion,
}
