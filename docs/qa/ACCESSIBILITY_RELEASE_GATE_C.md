# Accessibility Release Gate C: App-bar Back Button Semantics (AF-3)

- **Branch:** `fix/accessibility-release-gate-c`, from Gate B `9ec5da4` (Gate A is `c97b696`).
- **Scope:** host-only implementation and verification. No Pixel, adb, APK install or TalkBack work was done in this gate.
- **Status:** not committed; waiting for review of the scope and verification.

## 1. Finding (from the Gates A+B Pixel 6a acceptance)

`docs/qa/ACCESSIBILITY_GATES_AB_PIXEL_ACCEPTANCE.md` (Gate B worktree, §4) recorded **AF-3**: several app-bar Back buttons have no accessible name. It is release-blocking under the same rule as AF-1.

| Screen | Evidence on the device |
|---|---|
| Visual Maths hub | TalkBack spoke "Button" (`T04`) |
| Accessibility settings | TalkBack spoke "Button" (`T05`) |
| Settings | empty name in the accessibility tree |
| Math Studio hub | empty name in the accessibility tree |
| Interactive Labs hub | empty name in the accessibility tree |
| Discovery Library | empty name in the accessibility tree |

**Root cause:** the same as AF-1. Each Back control is an `IconButton(icon: Icon(Icons.arrow_back …), onPressed: …)` with no `tooltip`. Flutter's `IconButton` takes its semantic name from its tooltip, so without one the node is a nameless button.

## 2. Audit

- **No shared app bar.** The app has no shared app-bar or back-button widget. Every screen builds its own `AppBar(leading: IconButton(...))`.
- **Shared scaffolds.** These build the Back button for several screens each: `LabScaffold`, `MathMagicActivityScaffold`, `SpatialActivityScaffold`, `VisualMathsPlaceholderScaffold`, `ParentGate` and `OnboardingProgressHeader`.
- **Scan.** Every `Icons.arrow_back*` in `lib/` inside an `IconButton` was checked for a `tooltip` or an enclosing `Semantics` label.
  - **48 unnamed Back buttons in 48 files**, including the six Pixel screens and the six shared scaffolds.
  - **Already correct, left unchanged:** the AF-1 Abacus button and the Back buttons on the Early Maths hub, Panda Portions, Applied Maths Studio, Binomial Volume, Create the Angle, Feed the Panda, Pitch Coordinates and Ratio Foundations. All of these already use `MaterialLocalizations.of(context).backButtonTooltip`.
- **Decision:** the user chose to fix all 48 and add a guard test, not only the six screens heard on the device.

## 3. Change

Each of the 48 Back buttons gets the single argument that AF-1 already uses:

```dart
leading: IconButton(
  tooltip: MaterialLocalizations.of(context).backButtonTooltip, // added
  icon: Icon(Icons.arrow_back, color: colors.primaryText),       // unchanged
  onPressed: () => popOrGo(context, '/math-studio'),            // unchanged
),
```

- **Name:** localised by Flutter's `GlobalMaterialLocalizations` for every supported locale ("Back", "Zurück", "Retour" and so on). No ARB keys were added and there is no hard-coded English.
- **Role:** `IconButton` exposes one button node whose name is the tooltip. The icon adds no label, so the name is announced once.
- **Unchanged:** navigation callbacks, icons, colours, sizes, keys and layout. Touch and keyboard activation are unchanged too, because the button widget is the same.
- **Side effect:** a long-press on any of these buttons now shows a "Back" tooltip. This is standard Material behaviour, and Abacus and the Early Maths hub already do it.
- **Diff size:** 48 files, 48 insertions, 0 deletions. `dart format` reported 0 changes.

**Changed files (one line each):**

- **`lib/screens/`**
  - `build_confidence/build_confidence_screen.dart`
  - `discovery/discovery_card_detail_screen.dart`, `discovery/discovery_library_screen.dart`
  - `entrance_exam/entrance_exam_hub_screen.dart`, `entrance_exam_review_screen.dart`, `entrance_exam_skill_list_screen.dart`
  - `explore/explore_math_intelligence_screen.dart`
  - `family_maths/family_activity_detail_screen.dart`, `family_maths_library_screen.dart`, `family_maths_welcome_screen.dart`
  - `family_studio/conversation_starters_screen.dart`, `family_progress_snapshot_screen.dart`, `family_studio_hub_screen.dart`, `family_today_activity_screen.dart`, `homework_companion_screen.dart`, `parent_recall_cards_screen.dart`, `tutor_tools_screen.dart`, `what_your_child_is_learning_screen.dart`
  - `labs/aircraft_landing_lab_hub_screen.dart`, `labs/interactive_labs_hub_screen.dart`, `labs/spatial_cube_lab_hub_screen.dart`
  - `math_magic/math_magic_activity_scaffold.dart`, `math_magic/math_magic_screen.dart`
  - `math_studio/math_studio_hub_screen.dart`
  - `mental_maths/mental_maths_category_screen.dart`, `mental_maths_hub_screen.dart`
  - `recall/recall_card_detail_screen.dart`, `recall_cards_bookmarks_screen.dart`, `recall_cards_browse_screen.dart`, `recall_cards_hub_screen.dart`
  - `settings/accessibility_screen.dart`, `appearance_screen.dart`, `curriculum_settings_screen.dart`, `parent_cheat_sheet_screen.dart`, `parent_teacher_tools_screen.dart`, `privacy_data_screen.dart`, `release_notes_screen.dart`, `settings_screen.dart`, `terms_screen.dart`
  - `spatial_intelligence/spatial_activity_scaffold.dart`, `spatial_intelligence_screen.dart`
  - `topics/topic_learning_hub_screen.dart`
  - `visual_maths/number_line_screen.dart`, `visual_maths_hub_screen.dart`, `visual_maths_placeholder_scaffold.dart`
- **`lib/widgets/`**
  - `labs/lab_scaffold.dart`
  - `onboarding/onboarding_progress_header.dart` (`Icons.arrow_back_ios_new`)
  - `settings/parent_gate.dart`

**New test:** `test/app_bar_back_semantics_test.dart`.

## 4. Tests

The new file `test/app_bar_back_semantics_test.dart` has 92 tests, all running on the real `appRouter` and the real `readingSizeAppBuilder`.

| Group | Count | What it checks |
|---|---|---|
| Pixel screens: name and role | 6 | exactly one semantics node is a button named "Back"; it is non-empty and has a tap action; no node carries "Back" or "arrow" as a label, so nothing is duplicated |
| Pixel screens: locale | 6 | under `Locale('de')` the name is Material's German back tooltip (not "Back") and no English "Back" remains |
| Pixel screens: navigation | 6 | activating Back through semantics lands on the same fallback route as before: Accessibility and Settings → `/profile`; Math Studio → `/home`; Visual Maths, Interactive Labs and Discovery → `/math-studio` |
| Pushed navigation | 1 | Math Studio → push Visual Maths → Back pops to Math Studio |
| Route sweep | 72 | for every route in the shared real-router sweep, no rendered Back-arrow `IconButton` lacks a tooltip, and no exception is thrown |
| Source guard | 1 | fails if any Back-arrow `IconButton` in `lib/` has no `tooltip:` and no enclosing `Semantics(` |

**Negative control.** With the 48 `lib/` edits temporarily reverted (and then restored, diff unchanged), the same file gave **22 passed, 70 not passed**:
- all 19 Pixel-screen and pushed-navigation tests;
- 50 sweep routes that render a Back arrow;
- the source guard.

The 22 routes that passed render no Back arrow. The new tests therefore detect AF-3.

**AF-1 and AF-2 regressions** are in the focused set:
- `abacus_back_a11y_test.dart` (AF-1);
- `reading_size_semantics_test.dart` (AF-2);
- Gate B's `reading_size_text_scaler_test.dart` and `system_text_scaling_sweep_test.dart`.

## 5. Verification

| Check | Result |
|---|---|
| `flutter analyze` | No issues found |
| `dart format` on the 48 changed files | 0 changed |
| New AF-3 test file | 92 passed, 0 failed |
| Focused accessibility set (AF-3 file + the 18 Gate B accessibility files) | 1,064 passed, 0 failed, 0 skipped |
| Full host suite (255 test files in 6 batches of 50, `practice_screen_continue_learning_resume_test.dart` excluded as before) | **3,215 passed, 0 failed, 0 skipped** (Gate B: 3,123, plus 92 new) |

## 6. Limitations

- **Not checked on a device.** Nothing was run on the Pixel 6a in this gate. The host tests check the semantics tree that TalkBack reads, but nobody has yet heard "Back, button" on the device. A TalkBack re-check of at least Visual Maths and Accessibility settings is still needed before AF-3 can be closed on the device.
- **Source guard is a heuristic.** It looks for `tooltip:` or `Semantics(` within a few lines of each Back-arrow `IconButton`. A Back control built another way (`BackButton`, `InkWell`, a custom widget) is outside its scope. Flutter's own `BackButton` is already named.
- **Route sweep coverage.** It covers only the routes in the shared sweep catalogue. Screens off that list are covered by the source guard, not by a rendered check.
- **Merge note.** Three of the changed files also have uncommitted edits in the protected `feature/math-intelligence-v2` checkout. The edits are on other lines, so a trivial merge may be needed later.
  - `recall_cards_browse_screen.dart`
  - `visual_maths_placeholder_scaffold.dart`
  - `parent_teacher_tools_screen.dart`
- **Not addressed here (out of AF-3 scope):** the Pixel report's non-blocking observations — unlabelled Reduce Motion, Quiet Study Mode and Sound Cues switches, and duplicate unlabelled hub-lane nodes. Also still open: AS-1, FU-1 and D-1.

## 7. Recommendation

- **Host gate: GO.** AF-3 is fixed for all 48 Back buttons:
  - the name is localised and announced once as a button;
  - navigation is unchanged;
  - AF-1 and AF-2 are intact;
  - analyze is clean and the full suite is green;
  - new tests and a source guard prevent it coming back.
- **Public release: still NO-GO until a TalkBack re-check on the Pixel 6a confirms "Back" is spoken** on the affected screens. That re-check is the only remaining AF-3 step.
