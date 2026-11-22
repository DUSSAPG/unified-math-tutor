# Reconciled Early Maths hub: Pixel 6a acceptance (2026-11-22)

| | |
|---|---|
| Branch | `integration/math-intelligence-reconciled-v1` |
| Commit under test | `d4e184a` (the worktree was clean when the APK was built) |
| Scope | QA only. No application source changed, nothing committed, pushed, merged or tagged. |
| Session | 10:49–11:14 device time, one app process (pid 27089) throughout |

**Recommendation: GO.** Every mandatory hub, layout and regression scenario passed on the device.
- **One minor layout defect was found (D-1).** It does not come from this merge and does not block, but a small fix is proposed below.
- **Not verified here:** TalkBack spoken output, the "no lane chosen yet" state, and the effect of Quiet Study Mode on sound (see sections 4 and 6).

## 1. Build, install and device

| | |
|---|---|
| APK | `build/app/outputs/flutter-apk/app-debug.apk`, a fresh debug build (old outputs deleted first) |
| Package | `com.quantumlab.mathtutor.gb`, versionName `1.0.0`, versionCode `1` |
| APK SHA-256 | `ee31b20e714f79ce32b6e3bfe1f9ac66058db9de76e696fa517c33a0123b1e8b`, the same on the host and as installed on the device |
| Signer | `CN=Android Debug, O=Android, C=US`, cert SHA-256 `e9fbc282…84130763`. This is identical to the APK that was already installed (SHA-256 `741abb06…3a052309`, the integration build from 05:10). |
| Install | `adb install -r` succeeded. `firstInstallTime` is unchanged at 2026-10-11 15:10:27; `lastUpdateTime` is 2026-11-22 10:49:40. |
| Device | Pixel 6a (bluejay), Android 17 (SDK 37), 1080×2400 px, 420 dpi |
| Device state | System font scale 1.0, no accessibility service enabled, animator scale 1.0, auto-rotate on |

## 2. Early Maths hub routes

The device already held a lane preference, `ks1_maths_foundations`, so the hub opened with KS1 selected.

| ID | Scenario | Result | Evidence |
|---|---|---|---|
| E-1 | **Early Maths Play:** Feed the Panda available | PASS | `H02`, `H03` |
| E-2 | Early Maths Play: Panda Portions available | PASS | `H02`, `H03` |
| E-3 | Early Maths Play: parent-led section kept. "Includes: Shape Hunt" is the age-4 fit. | PASS | `H03` |
| E-4 | Panda Portions card opens Panda Portions; Practise Halves runs | PASS | `H04`, `R01` |
| E-5 | Back returns to the hub; second Back goes to Interactive Labs | PASS | `B01`, `B02` |
| E-6 | **I'm not sure:** only Feed the Panda, under "A gentle first step" | PASS | `H05` |
| E-7 | I'm not sure: no Panda Portions card | PASS | `H05` |
| E-8 | I'm not sure: the first activity is easy to find | PASS, see note | `H05`, `H10` |
| E-9 | **KS1 Foundations:** Abacus plus the parent-led section (Build Twenty, Shape Hunt, Dice Race, Pattern Detective, Garden Geometry) | PASS | `H01`, `H06` |
| E-10 | KS1: no Panda Portions, no Feed the Panda | PASS | `H01`, `H06` |
| E-11 | No planned or unrelated activities in any lane | PASS | all hub captures |
| E-12 | Lane choice persists across leaving and re-entering the hub | PASS | `H05` (re-entry), `C0` |
| E-13 | No lane chosen yet (first-run default) | NOT TESTED | covered by host tests only |

**E-4/E-5 note.** Panda Portions' app-bar Back goes straight to the hub, not to its lesson menu. That is existing behaviour (`popOrGo` to the playground route); the in-screen "Choose lesson" control returns to the menu. The merge did not change it.

**E-8 note: is the first activity easy to find?**
- **Portrait, either Reading Size:** the Feed the Panda card is fully on screen with no scrolling (y 1870–2103 at Default, 2014–2269 at Large). It is the only card, under the heading "A gentle first step", so the first action is obvious.
- **Landscape, either Reading Size:** it needs one vertical scroll. The "A gentle first step" heading peeks in at the bottom edge as a cue (`H09`). This is ordinary scrolling, not a hidden interaction, so it is recorded as an observation, not a defect.

**E-13 note.** The device already stores a lane, and the hub offers no way to clear it. Reaching the never-chosen state would mean clearing app data, which is forbidden. Host tests `early_maths_entry_portrait_test` and `early_maths_lane_model_test` cover it.

## 3. Layout

All four combinations were checked in all three lanes.

| Check | Portrait, Default | Landscape, Default | Portrait, Large (1.15) | Landscape, Large |
|---|---|---|---|---|
| Playground intro before lane intro | PASS `H01` | PASS `H07` | PASS `H12` | PASS `H17` |
| Both intros readable | PASS | PASS | PASS | PASS |
| No overlap or clipping of cards or buttons | PASS | PASS | PASS | PASS (`H21`: the last line is fully visible at scroll end) |
| Lane choices reachable | PASS | PASS (three side by side) | PASS | PASS |
| Feed the Panda findable in "I'm not sure" | PASS, no scroll | PASS, one scroll `H10` | PASS, no scroll `H14` | PASS, one scroll `H19` |
| No horizontal overflow | PASS | PASS | PASS | PASS |
| Bottom navigation not obscured | N/A | N/A | N/A | N/A |

Bottom navigation is not applicable because the hub is a full-screen route without the tab bar. The gesture handle overlaps nothing.

### D-1 (minor): the hub's content jumps vertically when the lane changes

- **Where.** `lib/screens/labs/early_maths_playground_hub_screen.dart:111`. The body is `SafeArea → Center → ConstrainedBox → SingleChildScrollView`.
- **What happens.**
  - When the content is shorter than the screen, which is the "I'm not sure" lane at Default Reading Size in portrait, `Center` centres the whole block vertically.
  - That leaves about 103 px (about 39 dp) of empty space under the app bar: the intro sits at y=402 instead of 300 (`H05`).
  - Switching between a taller lane and "I'm not sure" moves every tile by that amount, under the user's finger. Seen on device: tapping "I'm not sure" at y=1300 moved it to 1282–1521, and tapping KS1 at y=1072 moved it up to 969 (`H05`, `H06`).
- **Impact.** It is disorienting, especially for a parent switching lanes, but nothing is lost or unreachable. At Large Reading Size the content is taller than the screen in every lane, so it doesn't happen (`H14`).
- **Origin.** Not from the reconciliation. Both parents (`922ce3d` and `5f49c50`) have the same `Center → SingleChildScrollView` structure. It became visible once the lane chooser started changing the page height.
- **Smallest correction (not implemented).**
  - At line 111, replace `Center(` with `Align(alignment: Alignment.topCenter,`. Content stays horizontally centred on wide screens and anchors to the top.
  - Add a host widget test that asserts the intro's top edge is the same in all three lanes at 390×844.

## 4. Interaction and accessibility

| ID | Check | Result | Evidence |
|---|---|---|---|
| A-1 | Back on the hub, in Panda Portions, Feed the Panda and the Abacus | PASS | `B01`–`B04` |
| A-2 | Lane tiles have accessible names (title plus age line or description) | PASS | `a11y/H01` |
| A-3 | Selected and unselected state is exposed, with exactly one selected; it moves on tap in every layout | PASS | `a11y/H02`, `H05`, `H06`, `H09`, `H11a` |
| A-4 | Activity cards have accessible names (title plus scope) | PASS | `a11y/H02`, `H06` |
| A-5 | Hub Back button is named "Back" | PASS | `a11y/H01` |
| A-6 | Reduce Motion on: lane switch shows no transition | PASS, limited | `M1` vs `M2` |
| A-7 | Quiet Study Mode on: no unexpected sound | NOT TESTED (inconclusive) | private audio dumps |
| A-8 | TalkBack spoken output | NOT TESTED | none |
| A-9 | All settings restored | PASS | section 6 |

**A-6 is weak evidence.** I took one screenshot immediately after the tap and one a second later. Outside the status bar they are pixel-identical within anti-aliasing (0 pixels differ by more than 16). Screencap resolution is about 0.3 s, so this is not proof that no animation ran.

**A-7 was inconclusive.**
- With Quiet Study Mode on, a Feed the Panda round created no audio players for the app (uid 10493) in `dumpsys audio`.
- In a control round with it off, the app also created none. Feed the Panda does not play platform audio on feeding, so this test cannot tell whether Quiet Study Mode works.
- Nothing audible was noticed in either round, but no one was listening for it.

**A-8.** TalkBack was not enabled and no spoken output was heard. Accessible names come from the uiautomator tree only, so this is not a TalkBack acceptance.

## 5. Regression smoke tests

| ID | Activity | Bounded check | Result | Evidence |
|---|---|---|---|---|
| R-1 | Panda Portions | Opens from Early Maths Play; Practise Halves shows both plates with named pieces | PASS | `H04`, `R01` |
| R-2 | Feed the Panda | Opens; select an apple, feed it; moves to "How many apples are left?" | PASS | `R02`, `R03` |
| R-3 | Abacus | Opens from KS1 in Guided mode ("Build 34"); Back returns to the hub | PASS | `R04` |
| R-4 | Create the Angle | Opens from the Applied Maths Studio. Shows "Target angle: 30 degrees" and "Your angle: 0 degrees", with no target leak in the pitch label. Back works. | PASS | `R05` |
| R-5 | Fractions of a Set | Opens from the Applied Maths Studio ("one half of these 12 counters", 2 trays). Back works. | PASS | `R06` |

**Logs.**
- The app process (pid 27089) logged 86 D and 6 I lines and **no W, E or F lines**. There was one process for the whole session, so no crash or restart.
- The 56 "Exception" lines in the device log are all from system services (`FeatureFlagsImplExport` and Binder), not the app.

## 6. Learner data

| Item | Before | After |
|---|---|---|
| After install (before any interaction) | — | `FlutterSharedPreferences.xml` byte-identical to before the install |
| `early_maths_lane_v1_device-guest` | `ks1_maths_foundations` | `ks1_maths_foundations` (changed for testing, then restored) |
| `text_scale` (Reading Size) | 1.0 | 1.0 (set to 1.15 for testing, then restored) |
| `reduce_motion` / `quiet_study_mode` | false / false | false / false (set true for testing, then restored) |
| Feed the Panda event counters | activityStarted 21, correctFruitAccepted 16, fruitSelected 6, targetReached 8 | 24, 19, 9, 11 |
| Every other key | — | unchanged |
| Device rotation | auto-rotate on, rotation 0 | the same (locked to landscape for testing, then restored) |
| Font scale / accessibility services | 1.0 / none | 1.0 / none |

The counter changes are incidental: they come from the three Feed the Panda rounds in R-2, A-7 and its control (+3 each). Panda Portions wrote no new keys. No preference was removed.

## 7. Evidence

| Location | Contents |
|---|---|
| `docs/qa/evidence/MATH_INTELLIGENCE_RECONCILED_2026-11-22/screenshots/` | 40 PNG captures |
| `…/a11y/` | 69 accessibility-tree text dumps (labels, bounds, clickable, selected), UTF-8 |
| `…/EVIDENCE_MANIFEST.sha256` | SHA-256 of all 109 evidence files |
| `qa_evidence_private/RECONCILED_HUB_2026-11-22/` (outside Git) | Full logcat (after install, and at the end), learner preference snapshots (before, after install, after), raw uiautomator XML, `dumpsys audio` snapshots, the previously installed APK, device settings and app uid |

Screenshot IDs used above: `H` = hub layout, `R` = regression, `B` = Back, `S` = settings, `M` = Reduce Motion and Quiet Study Mode, `C` = audio control.

What is missing: TalkBack audio, a recording of motion (only stills), and audio output.

## 8. Accessibility follow-ups

None of these come from the reconciliation, and none blocks it.

- **D-1:** the vertical jump on lane change, described above.
- **AF-1: the Abacus app-bar Back button has no accessible name.** Its `content-desc` is empty, because `lib/screens/visual_maths/abacus_screen.dart:183` has an `IconButton` without a `tooltip`. The hub's Back has had this fixed since the integration line. The fix is `tooltip: MaterialLocalizations.of(context).backButtonTooltip`.
- **AF-2: Reading Size options don't expose which one is selected.** In Profile → Accessibility, Small, Default and Large all report `selected=false`, even with Large active (`a11y/S8`). A screen-reader user cannot hear which size is on.
- **FU-1 and FU-2 are carried over unchanged.** FU-2 also explains why Large is the largest size tested here: the app's maximum is 1.15×, and Android's font size is ignored.
- **TalkBack spoken-output pass on the hub is still owed.** It needs a person listening: the lane tiles with their selected state, and the three activity cards.

## 9. Recommendation

**GO.** Every mandatory hub, layout and regression scenario passed on the Pixel 6a:
- Panda Portions appears only in Early Maths Play and opens correctly.
- "I'm not sure" offers only Feed the Panda, and it is easy to find.
- KS1 shows the abacus and the parent-led section.
- The intro order is right.
- No overflow, clipping or crashes.
- Learner data was preserved.

D-1 is minor and comes from the parent branches. I recommend applying its one-line correction before or alongside promotion, but it is not a blocker. Promotion itself is a separate decision and was not done here.
