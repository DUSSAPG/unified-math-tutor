# Swiss Phase 2: P2 unreferenced-key evidence

**P2 is unchanged in Phase 2.** No key was deleted, no translation was written and the completeness gate was not weakened: all 272 missing keys still count in `scripts/check_enabled_l10n.py`.

## Method

- Baseline `15027ae` with the Phase 2 worktree (`l10n/swiss-phase2-p0`). The ARB changes do not affect references.
- Every identifier was collected from each `.dart` file under `lib/`, excluding the generated `app_localizations*.dart`. A key counts as referenced if its name appears as an identifier.
- The same scan was repeated over `lib/`, `test/`, `integration_test/` and `tool/`.

## Result

- Template keys: 1720.
- Keys not referenced in `lib/`: **59**. The Phase 1 report also found 59.
- Of these, **37 are the P2 backlog** (each has a missing, English-copy or flagged value in at least one Swiss locale). The other 22 are already translated in all three Swiss locales and need no work.
- None of the 37 P2 keys is referenced in `lib/`. One, `recallCardsLabComingSoon`, appears in `test/recall_card_related_links_unresolved_lab_widget_test.dart`, but only in assertions that the string is **not** shown (`findsNothing`). That confirms it is unreachable in the UI.
- Several P2 keys are fixed-example versions of strings whose `…Dynamic` replacements are used in `lib/screens/visual_maths/number_sense_lab_screen.dart`:
  - `numberSenseComparisonCorrectResult` ("Correct: 2/3 < 3/4.") → `…CorrectResultDynamic`
  - `numberSenseComparisonProof` → `…ProofDynamic`
  - `numberSenseHundredthsTargetEquation` → `…TargetEquationDynamic`
- The 15 `numberSenseHelp*` keys, a help-panel copy set, are not referenced anywhere in `lib/`.

## Recommendation (not done in Phase 2)

Remove these keys from `app_en.arb` in a separate engineering change, or keep them and translate them when their screens are wired up. Either way it needs its own review. Phase 2 keeps them as they are, so the 272-key completeness requirement is not reduced.

## The 37 P2 keys

| Key | English | de_CH | fr_CH | it_CH |
|---|---|---|---|---|
| `abacusCaption1` | One bead moved in the ones column represents 1. | flagged | flagged | translated |
| `entranceExamNextQuestionButton` | Next question | flagged | translated | translated |
| `feedTheHungryPandaSubtitle` | Count out apples one at a time to feed Panda | flagged | translated | translated |
| `labsFlightPathLabPrompt` | Target: bearing {bearing}°, {distance} km away. Flight time is fixed at 2 hours … | flagged | flagged | translated |
| `mathStudioInDevelopmentNote` | This area is still being built — check back soon for new content. | flagged | translated | translated |
| `mathStudioMathMagicBody` | Recreational puzzles, number tricks and mathematical curiosities | translated | flagged | flagged |
| `mathStudioSpatialCubeActivitiesLabel` | Cube activities | translated | flagged | flagged |
| `mathStudioThinkLabel` | Think it through | translated | flagged | translated |
| `numberSenseCompareLeftLabel` | Left: {fraction} | missing | missing | missing |
| `numberSenseCompareLeftMarkerExplanation` | 2/3 = 0.666… — two of three equal parts | missing | missing | missing |
| `numberSenseCompareRightLabel` | Right: {fraction} | missing | missing | missing |
| `numberSenseCompareRightMarkerExplanation` | 3/4 = 0.75 — three of four equal parts | missing | missing | missing |
| `numberSenseComparisonCorrectFeedback` | Correct. {proof} | missing | missing | missing |
| `numberSenseComparisonCorrectResult` | Correct: 2/3 < 3/4. | missing | missing | missing |
| `numberSenseComparisonIncorrectFeedback` | Not quite. The correct relation is 2/3 < 3/4. {proof} | missing | missing | missing |
| `numberSenseComparisonIncorrectResult` | Not quite. 2/3 is less than 3/4. | missing | missing | missing |
| `numberSenseComparisonProof` | 2 × 4 = 8; 3 × 3 = 9; since 8 < 9, 2/3 < 3/4. | missing | missing | missing |
| `numberSenseHelpDenominatorDescription` | The denominator is the bottom number. It tells how many equal parts make one who… | missing | missing | missing |
| `numberSenseHelpDenominatorLabel` | Denominator | missing | missing | missing |
| `numberSenseHelpEqualDescription` | The equal-to symbol means both values are the same amount. | missing | missing | missing |
| `numberSenseHelpEqualLabel` | Explain the equal-to symbol | missing | missing | missing |
| `numberSenseHelpEquivalentDescription` | Equivalent fractions name the same amount, even when they use different-sized eq… | missing | missing | missing |
| `numberSenseHelpEquivalentLabel` | Equivalent | missing | missing | missing |
| `numberSenseHelpGreaterThanDescription` | The greater-than symbol means the value on its left is larger than the value on … | missing | missing | missing |
| `numberSenseHelpGreaterThanLabel` | Explain the greater-than symbol | missing | missing | missing |
| `numberSenseHelpLessThanDescription` | The less-than symbol means the value on its left is smaller than the value on it… | missing | missing | missing |
| `numberSenseHelpLessThanLabel` | Explain the less-than symbol | missing | missing | missing |
| `numberSenseHelpNumeratorDescription` | The numerator is the top number. It counts how many equal parts are selected. | missing | missing | missing |
| `numberSenseHelpNumeratorLabel` | Numerator | missing | missing | missing |
| `numberSenseHelpWhatItMeans` | Use this idea to read, describe and compare fractions. | missing | missing | missing |
| `numberSenseHelpWhatToDo` | Read the fraction or symbol, then connect it to the amount shown. | missing | missing | missing |
| `numberSenseHelpWhereUsed` | These words and symbols help explain fractions in maths and everyday sharing. | missing | missing | missing |
| `numberSenseHundredthsTargetEquation` | 1/100 = 0.01 | missing | missing | missing |
| `numberSenseTryAnotherExample` | Try another example | missing | missing | missing |
| `onboardingCreateAccountSub` | Save progress, Maths Journey data and achievements on this device. | translated | flagged | translated |
| `recallCardsLabComingSoon` | Coming soon | flagged | translated | translated |
| `visualMathsFractionBarsSubtitle` | Compare fractions as bars, side by side | flagged | translated | translated |
