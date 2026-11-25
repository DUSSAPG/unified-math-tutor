# Accessibility Release Gate A

**Date:** 2026-11-22
**Recommendation: GO** to merge into `feature/math-intelligence-v2`, once the remaining prerequisite in section 6 is met. These fixes clear the two confirmed public-release blockers, AF-1 and AF-2. They do **not** make the app ready for public release; see section 5.

## 1. Baseline and scope

| | |
|---|---|
| Baseline | `8778cf49e2b71a6307a40885762e66fc27f2d1b6`, the merge of PR #5 into `feature/math-intelligence-v2` on GitHub. Verified by fetching before the worktree was created. |
| Branch | `fix/accessibility-release-gate-a`, local only, in its own worktree `unified_math_tutor_a11y_release_gate_a` |
| In scope | **AF-1:** the Abacus Back button has no accessible name. **AF-2:** the Reading Size options don't expose their selected state. |
| Out of scope | FU-2, the text-scaling policy (no scale values changed); FU-1; D-1; the lane strings |
| Not done | No Pixel, ADB or APK work; no push, merge or deployment. The protected `feature/math-intelligence-v2` checkout (`5f49c50`, 24 uncommitted changes) was not touched, and its status fingerprint is the same before and after. |

## 2. Source changes

Three screen files changed (108 lines added, 58 removed), and two test files were added. The only other files are this report and one new row in the §8 changelog of `docs/RC1_FEATURE_FREEZE.md`.

### AF-1: `lib/screens/visual_maths/abacus_screen.dart` (2 lines added)

The AppBar's `IconButton` now has:

- `tooltip: MaterialLocalizations.of(context).backButtonTooltip`. This is the same convention the other lab screens use, such as Early Maths Playground, Panda Portions and Create the Angle. It gives the button a localised spoken name, "Back" in English and "Zurück" in German, and shows the usual tooltip on long-press.
- `key: const Key('abacusBackButton')`, for tests.

Navigation is unchanged: `popOrGo(context, '/math-studio/visual-maths')`.

### AF-2: both Reading Size pickers

The same defect existed in two places, so both are fixed in the same way:

- **Settings:** `lib/screens/settings/accessibility_screen.dart`, reached via Profile → Accessibility. This is where the defect was found.
- **Onboarding:** `lib/screens/onboarding/accessibility_step_screen.dart`, step 3 of onboarding. It has an identical `_SizeOption` and an identical defect. It was found during this sprint.

In each `_SizeOption`, the plain `GestureDetector` over a `Container` was replaced with:

- `MergeSemantics` wrapping `Semantics(button: true, inMutuallyExclusiveGroup: true, selected: selected)`. Each option becomes one screen-reader node with its name, its button role, its selected or unselected state within a single-choice group, and a tap action.
- `Material(type: transparency)`, then `InkWell`, then `Ink(decoration)`. The option can now be focused by keyboard and activated with Enter or Space. It shows the standard focus highlight and ripple, and its border and fill look the same as before.
- `ExcludeSemantics` around the "Aa" preview. It used to be read aloud as part of every option's name ("Aa, Small"); it is visual only.
- Test keys `readingSizeOption-<label>` and `onboardingReadingSizeOption-<label>`.

These stayed exactly the same:

- The scale values, `[0.9, 1.0, 1.15]`.
- `_textScaleIndex`, `_selectTextSize` and `LocalPreferencesService.setTextScale`.
- The stored preference key, `text_scale`, a double.
- The labels, the layout and the selected-state colours.

`lib/services/` has no changes, so no learner preference contract changed.

### How the screen-reader output changed

These semantics trees were captured on the host with a temporary probe test, run against the baseline sources and then against the fixed ones. The probe was deleted afterwards.

| Control | Baseline (`8778cf4`) | Fixed |
|---|---|---|
| Abacus Back | 0 buttons named "Back" | 1 button, tooltip "Back" |
| Reading Size: Small | label "Aa\|Small"; not a button; no selected state; not focusable | label "Small"; button; in a single-choice group; selected = false; focusable |
| Reading Size: Default (stored 1.0) | label "Aa\|Default"; no selected state | label "Default"; button; selected = **true** |
| Reading Size: Large | label "Aa\|Large"; no selected state | label "Large"; button; selected = false |

The probe covered the Settings screen. The onboarding step had an identical `_SizeOption` at baseline and is covered by the new tests below.

## 3. Test evidence

All runs used Flutter 3.41.2 on the Windows host.

| Check | Result |
|---|---|
| `flutter analyze` (final sources) | **No issues found** |
| New AF-1 test: `test/abacus_back_a11y_test.dart` | **4/4 passed** |
| New AF-2 test: `test/reading_size_semantics_test.dart` | **16/16 passed** (8 per picker) |
| Existing accessibility and related regressions (12 files, listed below) | **599/599 passed** |
| Full suite (final sources) | **2,781 passed, 0 failed, 0 skipped**, in 251 files |

**AF-1 tests**
- The Back button has the tooltip "Back" and is a focusable, enabled button with a tap action.
- Exactly one button node carries the name, and the icon adds no second label, so it is announced once.
- The name follows the app locale: German gives the German Material back tooltip.
- Activating it through the screen reader pops back to Visual Maths.
- When the Abacus is opened directly by URL, Back still goes to Visual Maths.

**AF-2 tests** (each one runs on both pickers)
- **Opening state:** a stored 0.9, 1.0 or 1.15 opens with Small, Default or Large selected; nothing stored opens with Default selected.
- **Every option, every time:** each is a named, focusable button in a single-choice group that exposes a selected state, and exactly one is selected.
- **Spoken names:** "Aa" is not part of any spoken name.
- **Touch:** selected state updates on the very next frame, and the saved `text_scale` and `LocalPreferencesService.textScale` both update.
- **Screen reader:** activating each option selects it and saves the value.
- **Keyboard:** Tab reaches Small, Default and Large in order; Enter and Space select.

**The new tests catch the original bugs.** Run against the baseline screen files, all 12 of the original new tests fail. Some fail partly because the test keys don't exist at baseline. The semantics probe in section 2 is the direct before-and-after evidence.

**Existing regression files:**
- `abacus_interaction_widget_test.dart`, `abacus_interactive_layout_test.dart`, `abacus_rod_geometry_test.dart`, `abacus_state_test.dart`
- `early_maths_playground_back_a11y_test.dart`, `fractions_of_a_set_accessibility_test.dart`, `panda_portions_a11y_flow_test.dart`, `pitch_coordinates_accessibility_test.dart`
- `parent_teacher_tools_screen_test.dart` (Theme and Reading Size coverage)
- `polish_audit_overflow_sweep_test.dart` (includes `/profile/accessibility`)
- `route_navigator_key_regression_test.dart` (includes `/profile/accessibility` and onboarding routes)
- `theme_representative_screens_test.dart` (includes Accessibility)

**How the full suite was run**
- Every `test/**/*_test.dart` file was included except `test/practice_screen_continue_learning_resume_test.dart`. That file is the only exclusion; it is documented as hanging in this environment, a known issue before this sprint.
- `test/support/` has no test files.
- Batches of 50 files used `--reporter json`, because a single 251-path command line is too long for Windows. All 6 batches reported success, and results were aggregated per file.
- The total is the accepted reconciliation baseline (2,761) plus the 20 new tests.

**Housekeeping:** `flutter test`, `analyze` and `pub get` rewrite 7 generated desktop plugin registrants and `untranslated_messages.txt` with line-ending changes only. These were restored with `git checkout --` and are not part of the change.

## 4. Freeze compliance

The RC1 freeze document, §1, freezes "Accessibility architecture" but allows targeted bug fixes under §5. These changes meet three of the four §5 conditions:

1. They are minimal and targeted: no redesign, no new capability, no scale change.
2. Regression tests are added.
3. Scope does not expand.

The fourth condition is also met: a 2026-11-22 correction entry has been added to the §8 changelog in `docs/RC1_FEATURE_FREEZE.md`, in the same commit as these fixes.

## 5. Remaining accessibility issues

| ID | Issue | Status |
|---|---|---|
| AF-1 | Abacus Back has no accessible name | **Fixed on this branch** (host-verified) |
| AF-2 | Reading Size options expose no selected state | **Fixed on this branch**, both pickers (host-verified) |
| TalkBack | No spoken-output check on a device for these fixes, or for the reconciled hub | **Open; still blocks public release.** Host semantics trees aren't a substitute for listening on a device. |
| FU-2 | Reading Size replaces the system font size and stops at 1.15× | **Open; still blocks public release.** Needs a product decision; deliberately not addressed here. |
| Lane l10n | 19 lane strings are English-only, and the completeness test doesn't check them | **Open; blocks release** in non-English locales |
| AS-1 (new note) | The Accessibility screen and onboarding step use hard-coded English strings ("Reading Size", "Small", "Default", "Large", "Reduce Motion" and others), so screen readers speak them in English in every locale | Existing before this sprint. Recommend localising them alongside the lane strings. |
| FU-1 | Fractions of a Set feedback scroll ignores the in-app Reduce Motion setting | Open; does not block |
| D-1 | Early Maths hub content jumps vertically when switching lanes | Open; does not block |
| — | `practice_screen_continue_learning_resume_test.dart` hangs on the host | Existing before this sprint; fix it or formally waive it |

## 6. Recommendation

**GO** to merge `fix/accessibility-release-gate-a` into `feature/math-intelligence-v2`. The freeze changelog entry is included in this commit. One prerequisite remains:

1. **A short Pixel check with TalkBack on**, when a device session is authorised:
   - On the Abacus, Back is announced as "Back, button".
   - Under Profile → Accessibility and on onboarding step 3, each Reading Size option is announced with its name and its selected or not-selected state, and the state changes immediately when a different size is chosen.

The change is committed locally on `fix/accessibility-release-gate-a`. It has not been pushed.

**Public release remains NO-GO.** TalkBack verification, the FU-2 decision, release localisation and the `main` branch history question are still open.
