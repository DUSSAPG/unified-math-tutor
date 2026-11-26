# Accessibility Release Closure A

- **Branch:** `fix/accessibility-release-closure-a`, from `de7c6da` (the PR #6 merge on `feature/math-intelligence-v2`).
- **Scope:** four bounded accessibility and interaction defects. All work was on the host only: no Pixel, adb, APK or TalkBack.
- **Status:** application changes committed as `0b19490` (parent `de7c6da`). Verified on the clean committed tree: 3,238 passed, 0 failed, 0 skipped (§3). Pixel verification is pending, and public release remains NO-GO.

## 1. Defects and fixes

| ID | Defect | Where it was found |
|---|---|---|
| SW-1 | The Reduce Motion, Quiet Study Mode and Sound Cues switches had no name of their own. The title and description were separate text nodes, so TalkBack could stop on a bare "Off, switch". | Gates A+B Pixel acceptance (§4, "Unlabelled switches") |
| HL-1 | Each Early Maths lane tile had a duplicate, unlabelled tappable node at the same position, which could add an unnamed stop when swiping. | Gates A+B Pixel acceptance (§4, "Duplicate hub nodes") |
| FU-1 | The Fractions of a Set feedback reveal ignored the app's own Reduce Motion setting and animated its scroll. It respected only Android's "Remove animations". | Fractions of a Set UAT; open since Gate A |
| D-1 | The Early Maths hub vertically centred short content, so the intro and lane tiles jumped (about 100 px on the Pixel) when a lane change altered the content height. | Reconciliation UAT; open since Gate A |

### SW-1: settings switches

- **Change:** `_ToggleCard` in `lib/screens/settings/accessibility_screen.dart` is wrapped in `MergeSemantics`. The onboarding Reduce Motion card in `lib/screens/onboarding/accessibility_step_screen.dart` gets the same wrapper.
  - The onboarding card had the same unnamed switch and writes the same `reduce_motion` preference, so it is fixed in the same way.
- **Result:** each setting is one screen-reader stop. The node carries the name first, then the description, the switch role, the On/Off (toggled) state and the tap action. For example: "Reduce Motion, Minimise animations and transitions, switch, off".
- **Unchanged:**
  - The `Switch` is still the only focusable, tappable control, so touch, keyboard (Tab, then Space or Enter) and screen-reader activation all go through its existing `onChanged`.
  - The preferences written (`reduce_motion`, `quiet_study_mode`, `sound_enabled`), their defaults and the visible layout.
  - Nyepi / Quiet Study Mode behaviour.
- **No new settings and no new strings.** The texts remain the existing English literals (AS-1).

### HL-1: Early Maths lane semantics

- **Change:** in `_LaneTile` (`lib/screens/labs/early_maths_playground_hub_screen.dart`), `MergeSemantics` → `Semantics(button, selected, label: "<title>. <subtitle>")` now wraps the `Material`/`InkWell`, and the visible texts are excluded.
  - Before, the labelled `Semantics` sat inside the `InkWell`, so the `InkWell` contributed a second, unlabelled tappable node.
  - The `InkWell` now supplies the tap and focus to the single merged node.
- **Unchanged:** the spoken label, the `selected` announcement, the tile keys, lane selection and persistence (`EarlyMathsLanePreferenceService`), the closed activity list, curriculum mapping and recommendations.

### FU-1: Reduce Motion in the Fractions of a Set feedback reveal

- **Change:** `_revealFeedback` (`lib/screens/labs/fractions_of_a_set/fractions_of_a_set_screen.dart`) now jumps when `MediaQuery.disableAnimationsOf(context) || LocalPreferencesService.instance.reduceMotion.value`. This is the same combined check the Binomial, Create the Angle, Feed the Panda and Aircraft Landing labs already use.
- **Unchanged:** with both settings off, the 250 ms `easeOutCubic` scroll stays exactly as before. No other animation was touched.

### D-1: hub vertical positioning

- **Change:** the hub body's `Center` is now `Align(alignment: Alignment.topCenter)`.
- **Result:** content is anchored under the app bar and still centred horizontally within `AppResponsive.contentMaxWidth` on wide screens.
- **Unchanged:** the playground introduction still precedes the lane introduction, and all three lane choices and the activity cards remain.

### Changed files

| File | Change (ignoring re-indentation) |
|---|---|
| `lib/screens/settings/accessibility_screen.dart` | `MergeSemantics` around `_ToggleCard` |
| `lib/screens/onboarding/accessibility_step_screen.dart` | `MergeSemantics` around the Reduce Motion card |
| `lib/screens/labs/early_maths_playground_hub_screen.dart` | `Align(topCenter)` instead of `Center`; one merged semantics node per lane tile |
| `lib/screens/labs/fractions_of_a_set/fractions_of_a_set_screen.dart` | app Reduce Motion added to the reveal's jump condition, plus its import |

- **Diff size:** 4 `lib/` files, 43 insertions and 15 deletions ignoring whitespace (171/143 including the re-indentation the wrappers cause).
- **Not touched:** routes, ARB keys, settings, curriculum and question content, TutorBot, Firebase, RevenueCat and Nyepi logic.

## 2. Tests

There are 23 new tests in three files.

| File | Tests | What they check |
|---|---|---|
| `test/accessibility_switch_semantics_test.dart` | 14 | **Both surfaces, every switch:** one stop whose label starts with the name and includes the description; toggled state; focusable, enabled, tap action; no unnamed toggle in the tree. **Per switch:** screen-reader activation flips the spoken state at once and stores the preference (and back again); touch on the switch still toggles; Tab reaches it and Space toggles it. |
| `test/early_maths_hub_lane_semantics_position_test.dart` | 5 | **Lanes:** each is exactly one named, focusable button with the correct selected state; no label-only duplicates; no unnamed tappable node on the hub; selecting each lane through semantics updates the state and the closed activity list. **D-1 (portrait phone, landscape phone, tablet landscape and portrait):** across lane changes the intro and first lane tile do not move; the intro sits 0–24 px under the app bar and before the lane intro; all lanes remain. |
| `test/fractions_of_a_set_reduce_motion_test.dart` | 4 | A whole session on a 360 × 640 screen. After each reveal tap, one frame is pumped and the offset compared with where it settles. **Motion on:** the scroll still animates. **App Reduce Motion, Android "Remove animations", or both:** every reveal jumps and none animates. |

**Negative control.** With the four `lib/` changes temporarily reverted, then restored with an identical diff hash:

| Area | Result without the fix |
|---|---|
| Switches | all 6 semantic tests fail. The 8 touch and keyboard tests pass, as they should: they guard existing behaviour. |
| Lanes | the lane test fails |
| FU-1 | the app-Reduce-Motion test fails; the other three pass, because Android's setting was already respected and motion-on behaviour is unchanged |
| D-1 | the tablet landscape and portrait cases fail |

- **Why D-1 passes on phone sizes without the fix:** the phone cases also pass without the fix. The test font (Ahem) renders text much larger than the device font, so at phone sizes the hub content is taller than the viewport and nothing is centred. Those cases remain as position guards; the tablet cases reproduce the jump.
- **Small tile shift allowed:** lower lane tiles may move by up to 2 px. The selected tile's border is 2 px instead of 1 px, and `Container` adds border width to its padding. This is existing visual behaviour, not the D-1 jump.

## 3. Verification

The full suite ran twice: once on the uncommitted working tree before review, and again on the clean tree after commit `0b19490`. The application source and tests are identical in both runs. The only difference is that the hub file was uncommitted in the first.

### 3.1 Post-commit verification on the clean tree (`0b19490`), the result of record

| Check | Result |
|---|---|
| Worktree | clean (`git status --porcelain` empty) before and after every run |
| `fractions_of_a_set_distinction_guard_test.dart` | **5 of 5 passed.** The working-tree guard ran (it was not skipped) and passed. |
| New tests (3 files) | 23 passed, 0 failed |
| `flutter analyze` | No issues found |
| `git diff --check` | clean |
| Full host suite (258 test files in 6 batches of 50; `practice_screen_continue_learning_resume_test.dart` excluded as in every gate, because of its known pre-existing hang) | **3,238 passed, 0 failed, 0 skipped** (Gate C: 3,215, plus 23 new) |

### 3.2 Pre-commit verification on the uncommitted working tree

| Check | Result |
|---|---|
| `flutter analyze` | No issues found |
| `dart format` (`lib/` and the new tests) | 0 changed |
| New tests (3 files) | 23 passed, 0 failed |
| Focused regressions (37 files) | 1,225 passed, 1 failed. The files are: the new tests, Gate A–C accessibility (AF-1, AF-2, AF-3, FU-2), every `early_maths_*` and `fractions_of_a_set_*` test, the route sweeps, and the theme and navigator-key regressions. |
| Full host suite (same 258 files and exclusion) | 3,237 passed, 1 failed, 0 skipped of 3,238. The one failure is the working-tree guard below. |

**Why the pre-commit runs had one failure.** The failure was expected and depended only on the working tree. It is in `fractions_of_a_set_distinction_guard_test.dart`: "Panda, Create the Angle, Pitch and Binomial files are unchanged in this working tree".
- That test runs `git status --porcelain` on a list of protected lab files that includes `early_maths_playground_hub_screen.dart`. It fails while that file has any uncommitted change.
- The D-1 and lane fixes are in that file by design. The guard checks only working-tree status, not content, so it needed a clean checkout. It passed after the commit (§3.1).
- The guard was not modified or weakened.

## 4. Limitations

- **No device run.** The semantics tree is what TalkBack reads, but no one has listened on the Pixel 6a. The spoken output of the merged switch nodes and lane tiles, and the absence of the extra hub stop, still need a TalkBack check.
- **D-1 phone sizes:** the jump is reproduced on host only at tablet sizes (§2). On a phone it should be confirmed visually.
- **Strings:** the switch names and descriptions are still English-only literals, part of AS-1. Nothing was localised in this sprint.

## 5. Remaining blockers before public release

1. **AS-1, regional localisation:** English-only strings on the Accessibility screen, the onboarding step and the 19 lane strings.
2. **AF-3, physical-device TalkBack confirmation:** "Back" spoken on Visual Maths and Accessibility settings. It is fixed on host (`0efa61a`) but not yet heard.
3. **Human TalkBack traversal:** Reading Size options, hub lanes and settings switches. This would also confirm SW-1 and HL-1 on the device.
4. **Large-font bottom navigation:** labels are hidden above 1.3× by design. A product decision is pending.
5. **L-1:** landscape practice usability at Android 2.0× is still under review.

## 6. Recommendation

- **Host: GO** for SW-1, HL-1, FU-1 and D-1. They are fixed with local wrapper or condition changes only, the behaviour that must stay the same is unchanged, analyze is clean, and the full suite is green on the clean committed tree (3,238 passed, 0 failed, 0 skipped at `0b19490`).
- **Pixel 6a verification: pending.** Neither TalkBack nor a visual check has been done for SW-1, HL-1, FU-1 or D-1.
- **Public release: still NO-GO** until the blockers in §5 are closed.
