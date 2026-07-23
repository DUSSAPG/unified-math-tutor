/// Shared outcome classification for the four labs whose result is
/// naturally binary-ish (Fraction Builder, Algebra Balance, Number Line
/// Explorer, Data Detective) rather than Flight Path Lab's richer
/// heading/distance combination. One shared enum keeps the classification
/// *mechanism* common across labs — each lab still authors its own message
/// text per outcome, so nothing here becomes "a separate mathematical
/// engine", just a shared shape for a deterministic local classification.
enum SimpleLabOutcome {
  correct,
  closeButWrong,
  wrong,
  repeatedUnchangedAttempt,
  inactivity,
  completion,
}
