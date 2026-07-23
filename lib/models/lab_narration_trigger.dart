/// The moments every Interactive Lab's guided narration must support. One
/// shared enum, not a separate trigger scheme per lab — each lab supplies
/// its own authored text for these same moments (see
/// `lib/models/narration_message.dart`).
enum LabNarrationTrigger {
  introduction,
  firstStepInstruction,
  hint,
  misconceptionCorrection,
  nearSuccess,
  resultExplanation,
  completion,
  realWorldConnection,
}
