# Accessibility Gates A+B: Pixel 6a acceptance (2026-11-22)

| | |
|---|---|
| Branch | `fix/accessibility-release-gate-b` |
| Commit under test | `9ec5da4`; parent `c97b696` (Gate A), which descends from `8778cf4`. The worktree was clean when the APK was built. |
| Scope | Physical-device QA only. No source changed, nothing committed, pushed or merged. |
| Session | Device time 19:56–20:36 GMT, one app installation throughout |

**Recommendation:**
- **Gates A and B: GO.** Every Gate A and Gate B correction works on the device.
  - Android's font size reaches the app.
  - Reading Size never reduces it and never multiplies it.
  - The tested screens stay usable at Android's largest setting.
  - TalkBack really speaks the fixed Abacus Back button as "Back. Button".
- **Public release: NO-GO.**
  - The session found **AF-3**: several app-bar Back buttons, including the one on the Accessibility settings screen, are spoken only as "Button". This is the same class of defect as AF-1, which was release-blocking.
  - Several TalkBack checks could not be driven remotely and still need a person to listen (§5).

## 1. Build, install and device

| | |
|---|---|
| APK | `build/app/outputs/flutter-apk/app-debug.apk`, a fresh debug build (old outputs deleted first) |
| Package | `com.quantumlab.mathtutor.gb`, versionName `1.0.0`, versionCode `1` |
| APK SHA-256 | `0cded031d70141564e310c92fe9dbb3dd53302e2b482a223928a9cc06c87de2e`, identical on the host and as installed |
| Signer | `CN=Android Debug, O=Android, C=US`, cert SHA-256 `e9fbc282…84130763`. Identical to the APK that was already installed (`ee31b20e…`, the reconciled build). |
| Install | `adb install -r` succeeded. `firstInstallTime` is unchanged at 2026-10-11 15:10:27; `lastUpdateTime` is 2026-11-22 19:58:54. The preference file hash was identical before and after the install. |
| Device | Pixel 6a, Android 17 (SDK 37), 1080×2400 px, 420 dpi, TalkBack 17.1 |
| Starting state | Font scale 1.0; no forced display density; no accessibility service enabled; auto-rotate off, rotation 0; animator scale 1.0. The foreground app was another app, idle. |
| App starting state | Reading Size Default (1.0), Reduce Motion off, Quiet Study Mode off, Sound Cues on, Early Maths lane KS1 Maths Foundations, onboarding completed |
| ADB ownership | One ADB server. The only other host clients were the IDE's Dart language server and passive Flutter device daemon. No foreign app came to the foreground during the session; foreground was checked before every tap. |

Android's font size was changed through `settings put system font_scale`, the same setting the system Font size slider writes. On Android 14+ the slider runs from 0.85 to 2.0, so **2.0 is the largest available setting**. The intermediate setting used was 1.3.

## 2. Android text scaling (Phase 2)

### 2.1 Policy measurements

| Android font | Reading Size | Width of "Choose a comfortable reading size" | Result |
|---|---|---|---|
| 1.0 | Small / Default / Large | 519 / 575 / 658 px, ratios 0.903 / 1.000 / 1.144 | PASS: unchanged default behaviour (0.90 / 1.00 / 1.15) |
| 1.3 | Small / Default / Large | 754 / 754 / 754 px | PASS: Small and Default do not reduce; Large does not multiply |
| 2.0 | Small / Default / Large | 906 / 906 / 906 px (wraps to two lines) | PASS: same as above |

Android 14+ non-linear scaling reaches the app:
- The 20 sp "Panda Portions" title grew ×1.23 at Android 1.3.
- The app-bar "Home" title measured 120 / 133 / 147 / 160 / 160 / 160 px at 1.0 / 1.15 / 1.3 / 1.5 / 1.8 / 2.0.

This is the per-font-size behaviour Gate B is designed to preserve.

**Evidence:** `S02`, `S08`–`S11`.

### 2.2 Screens

| Screen | 1.0 | 1.3 | 2.0 | Notes |
|---|---|---|---|---|
| Home | PASS `S01` | PASS `S04` | PASS `S12` | Cards wrap; the page scrolls |
| Topics | PASS | PASS | PASS `S13` | At 2.0 the filter chips run past the edge, but the row scrolls horizontally (scrollbar shown) and "More" is reachable |
| Practice setup | PASS | PASS | PASS | At 1.3 and 2.0, Start Practice is below the fold and reachable by scrolling |
| Practice session (portrait) | PASS `S03` | PASS `S07` | PASS `S14`, `S15` | All 4 options reachable; Check Answer and Next Question pinned and usable; question text fully readable (`Calculate: 331 + 352`); no truncation |
| Practice session (landscape) | — | — | PASS with note `S16`, `S17` | See finding L-1 |
| Accessibility settings | PASS `S02` | PASS | PASS `S11` | Options not clipped; switch rows wrap |
| Early Maths hub | PASS | PASS | PASS `S19` | Every card reachable by scrolling |
| Abacus | PASS | PASS `S06` | PASS `S18` | See finding L-2 |
| Panda Portions | PASS | PASS `S05` | PASS `S20`, `S21` | The Practise Halves activity was also checked at 2.0: plates readable, "Give the piece to Panda" reachable |

**Practice Check and Next** were exercised at 1.3 (portrait) and 2.0 (portrait). In both: option selected → Check Answer → feedback (correct option ticked) → Next Question → question 2. At 1.0 the options and Check Answer were checked for reachability only.

**Layout findings.** None are blocking, and none are regressions from Gates A/B.
- **L-1 (minor, 2.0× landscape only, beyond the 1.6× freeze bar).** In a landscape practice session at Android 2.0:
  - The fixed Exit row, topic chip and pinned Check Answer leave about 270 px for the question and options.
  - Each option scrolls through that strip one at a time, so all are reachable, but the question scrolls out of view while choosing the lower options.
  - Portrait at 2.0 is fine, though the Captain Number card takes about 40% of the height.
- **L-2 (cosmetic).** At 2.0 the Abacus number-board tile breaks its label mid-word as "Hundred / s".
- **L-3 (cosmetic).** At 2.0 the hub lane subtitle breaks at the en dash: "Years 1– / 2".
- **Observation (out of scope).** The practice topic chip shows raw identifiers such as `addition_subtraction` and `fractions_of_amount`.

## 3. Bottom navigation (Phase 3)

| Android font | Labels | Evidence |
|---|---|---|
| 1.0, 1.15, 1.3 | Visible | `S01`, `N01` |
| 1.5, 1.8, 2.0 | **Hidden (icons only)** | `N02`, `S12`, `S13` |

- **When the labels disappear.** They are hidden from Android's 1.5 step upward. That matches the existing `_navLabelHideTextScaleThreshold` (1.3) applied to the effective text scale.
- **Every tab is still reachable.** All five tabs were tapped at 2.0 and reached the right destination: Home, Topics, Practice, Journey, and More, which opens the More sheet with all eight entries visible (`N04`).
- **Names are kept.** The accessibility tree names each tab ("Home, Tab 1 of 5" and so on), and a long press shows the tooltip (`N03`, "More").
- **Without long-press, the destinations are only partly self-explanatory.**
  - Home (house) and More (ellipsis) are conventional.
  - Topics (open book), Practice (calculator) and Journey (flame) are not obvious, especially to young learners.
  - The app bar shows the destination's name once a tab is opened, so the learner can tell where they landed.
- **Classification: acceptable for RC1, with correction recommended post-RC1** (product decision). No information is lost for screen-reader users, and every tab works. However, sighted learners who use large fonts lose the labels exactly when they most need text.
  - Suggested direction (not implemented): keep the labels and let them wrap or shrink within the bar rather than hide them.

## 4. TalkBack verification (Phase 4)

**Method**
- TalkBack 17.1 was enabled for about six minutes.
- TalkBack's own **"Display speech output"** option was turned on, so every utterance appears on screen as a caption. Burst screenshots captured those captions.
- So the quotes below are **TalkBack's actual output text**, not accessibility-tree properties. Audio was not heard by a person.

**Limits of remote driving.** These limits are why some rows are PARTIAL:
- Injected taps *activate* items instead of moving TalkBack focus.
- Injected keyboard shortcuts (Alt+arrows) and hover events were not accepted.
- Focus could therefore be observed only where TalkBack placed it itself: the first item on each newly opened screen, or announcements triggered by an action.

| Check | Result | Actual TalkBack output, with evidence |
|---|---|---|
| **Abacus:** Back has its accessible name and button role | **PASS** | "Back. Button", then "Double-tap to activate" (`T01`, `T02`) |
| Abacus: Back navigation still works | **PASS** | Activating Back opened Visual Maths, announced as "Visual Maths" (`T03`) |
| **Accessibility settings:** Small / Default / Large each have a name | PARTIAL | The tree has three buttons named Small, Default and Large, each flagged selectable. Their spoken names were not captured, because focus could not be moved onto them remotely. |
| Accessibility settings: a changed selection is announced | **PASS** | Activating Large → "selected" (`T06`). Activating Default → "selected" (`T07`). The tree's selected flag moved with each change. |
| Accessibility settings: the selected option is announced when focused | NOT TESTED | Needs a person to swipe to each option |
| **Onboarding accessibility step** | NOT TESTED | Onboarding is completed on this device. Reaching the step would mean signing out or resetting the learner profile, which is forbidden. Covered by the Gate A host tests (`reading_size_semantics_test.dart`). |
| **Early Maths hub:** lane choices have names | PARTIAL | The tree names all three ("Early Maths Play. Typical ages 4–5 · Reception" and so on); spoken names not captured |
| Early Maths hub: selected state announced | PARTIAL | The tree's selected flag moved to KS1 on activation. No caption was observed in about 5 s of capture (`T08`). Unlike Reading Size, no "selected" was spoken, which needs a person to confirm. |
| Early Maths hub: activity cards distinguishable | PASS (tree) | Each card is one named button: "Abacus. An interactive place-value tool…", "Parent-led activities. …" |
| Early Maths hub: navigation understandable | PASS | Opening the hub was announced, and the hub's Back is named "Back" |

**New finding AF-3 (accessibility; release-blocking under the same rule as AF-1).** Several app-bar Back buttons have no accessible name.

- **TalkBack output captured on the device:**
  - Visual Maths: "Button" (`T04`).
  - **Accessibility settings: "Button"** (`T05`).
- **Same empty name in the tree, not heard:** Settings, Math Studio, Interactive Labs, Discovery Library.
- **Correctly named:** Abacus, Early Maths hub, Panda Portions, Interactive Studios.
- This is not a regression from Gates A/B. It is the same root cause as AF-1, an `IconButton` with no tooltip, on other screens.

**Other accessibility observations.** These are not blocking, but should be confirmed with a person listening.
- **Unlabelled switches.** The Reduce Motion, Quiet Study Mode and Sound Cues switches have no name of their own; the label is a separate text node. TalkBack may say only "Off, switch" on the switch itself.
- **Duplicate hub nodes.** Each hub lane option has a duplicate clickable node with no label at the same position. This may add an unnamed stop when swiping.

## 5. Restore and learner-data preservation (Phase 5)

| Setting | Original | Final |
|---|---|---|
| Android font size | 1.0 | 1.0 |
| Display size (forced density) | not set (420 dpi) | not set (420 dpi) |
| Rotation | auto-rotate off, rotation 0 | auto-rotate off, rotation 0. Landscape was used briefly via a user-rotation lock and then unlocked. |
| TalkBack | off | off (no accessibility service enabled) |
| TalkBack "Display speech output" | off | off. It was turned on for this session only; one accidental tap opened the TalkBack Gestures page, which was viewed only. |
| Reading Size | Default (1.0) | Default (1.0) |
| Reduce Motion | off | off |
| Quiet Study Mode | off | off |
| Sound Cues | on | on (not touched) |
| Early Maths lane | KS1 Maths Foundations | KS1 Maths Foundations. It was switched to Early Maths Play to reach Panda Portions, then switched back. |

**App preferences** were compared key by key with a pre-install backup. There were 34 keys before and 36 after:
- **The other 33 keys are unchanged.** This covers all lab progress, Feed the Panda history, Maze Driver bests and first-use flags, the streak scope and onboarding.
- **Incidental additions,** caused by answering one question in each of two practice sessions to test Check and Next:
  - `captain_number_fuel`: absent → 8
  - `captain_number_mission_progress`: 0 → 2
  - a new `continue_learning_checkpoint_v1_device-guest` from the exited session
- Nothing was removed or reset. No application data was cleared, and the app was never uninstalled.
- The foreground app at the end is Math Intelligence. At the start it was another app, which was left untouched.

## 6. Evidence

- **In this repository (not committed):** `docs/qa/evidence/ACCESSIBILITY_GATES_AB_2026-11-22/`, 33 app screenshots.
  - `S*`: scaling screens.
  - `N*`: navigation.
  - `T*`: TalkBack captions.
- **Kept outside Git** (`qa_evidence_private/GATES_AB_PIXEL_2026-11-22/`):
  - all raw screenshots and TalkBack burst frames;
  - uiautomator accessibility dumps;
  - the before and after preference files;
  - the SHA-256 manifest of the committed-candidate screenshots.
- No device serial is recorded in this report or the screenshots.

## 7. Remaining blockers before public release

1. **AF-3:** name the unlabelled app-bar Back buttons (Accessibility settings, Settings, Math Studio, Visual Maths, Interactive Labs, Discovery Library), then re-check with TalkBack.
2. **A human TalkBack pass:**
   - swipe through the Reading Size options in Settings and onboarding (spoken name and "selected");
   - the hub lane options (spoken state change, and the duplicate unlabelled nodes);
   - the Accessibility settings switches.
3. **Still open from earlier gates:**
   - AS-1: English-only strings.
   - FU-1: the Fractions of a Set feedback scroll ignores the in-app Reduce Motion setting.
   - D-1: the hub's vertical jump when the lane changes.
4. **Product decisions:**
   - bottom-navigation labels hidden at large fonts (§3);
   - the 2.0× landscape practice layout (L-1). This is not required by the 1.6× freeze bar.
