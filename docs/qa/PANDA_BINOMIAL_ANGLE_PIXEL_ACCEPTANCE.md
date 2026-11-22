# Panda / Binomial / Angle integration: Pixel 6a acceptance

| Field | Value |
|---|---|
| Date | 2026-11-22, 05:09–05:45 device time |
| Branch | `integration/panda-binomial-angle-v1` |
| Commit | `449435679207e97e2a9f0e6fa81325facb57ce43` (test-only fix on merge `b3ced977`) |
| APK | Debug, clean build from that commit. `com.quantumlab.mathtutor.gb`, versionName 1.0.0, versionCode 1 (`pubspec` 1.0.0+1). 197,931,523 bytes. SHA-256 `741abb065b2ef71839e6adba118f21e0c6095c21ad00bc6da620332f3a052309` |
| Signer | Android Debug, cert SHA-256 `e9fbc282…0763`. Same as the build it replaced |
| Device | Pixel 6a, serial `Pixel 6a`, Android 17 (build CP3A.261005.002.A1) |
| Install | `adb install -r` only. No uninstall, no data clear. `firstInstallTime` 2026-10-11 15:10:27 preserved. Replaced build `7f2a4ade…9d84` (same app code; built before the test-only commit) |
| Method | adb input, uiautomator accessibility tree, and screencap pixel hashes. No `flutter test` or `flutter drive` on the device. No TalkBack listening in this run |

## Result: **GO**

Every mandatory scenario passed with recorded evidence, and no crash, ANR or Flutter error was logged in the captured window. Three minor items are listed under Defects. None of them was introduced by this integration, and none blocks it.

## Scenarios

### Phase 2: Fractions of a Set (no answer shown before it is earned)

| # | Scenario | Result | Evidence |
|---|---|---|---|
| F-1 | Before Confirm, nothing gives the answer away. Trays are empty, the answer stepper starts at 0, and the accessibility labels hold no answer value (item "1/8 of 24") | PASS | `F0_open`, `logs/F0_labels.txt` |
| F-2 | Confirming a wrong prediction (2) moves on to building the groups. It does not judge or reveal anything | PASS | `F1_wrong` |
| F-3 | "These groups are ready" is disabled until every counter is placed | PASS | `F2_notready` (tree: `enabled="false"`) |
| F-4 | Unequal groups (11/7/1/1/1/1/1/1): corrective notice, differing trays outlined and labelled "different" (not colour alone), answer not revealed | PASS | `F3_unequal` |
| F-5 | Taking the wrong number of groups gives "Take 1 tray. You have chosen 2.", with no reveal | PASS | `F6_take2` |
| F-6 | Wrong prediction result. Shown only after the construction: worked steps "24 ÷ 8 = 3, then 1 × 3 = 3", fraction bar, "1/8 of 24 is 3.", a hint, and the stepper locked | PASS | `F7_result` |
| F-7 | Correct prediction ("2/6 of 30", answered 10): "Yes, that's correct." with worked steps | PASS | `F9_correct` |

The host test `fractions_of_a_set_distinction_guard_test` checks that the activities' source files stay separate. It has no device screen. It passed 5/5 on the host at this commit.

### Phase 3: Create the Angle (target-leak regression)

| # | Scenario | Result | Evidence |
|---|---|---|---|
| A-1 | Labels: the pitch, legend and readouts have no square, marker or target-location wording. Legend is "Solid line: baseline · Dashed line: your aim" | PASS | `A0_open`, `logs/A0_labels.txt` |
| A-2 | Pitch pixels are identical across the 30/45/60/90 targets at aims 0° and 29°: one hash per aim | PASS | `logs/V6_portrait.txt` |
| A-3 | Wrong Check (target 60, aim 35): pitch pixels unchanged (`300be8cc…` before and after). Text-only feedback: "Turn the aim line 25° wider to reach 60°" | PASS | `A1_wrong` |
| A-4 | Match (target 45, aim 44): snaps to 45°, amber arc and tick, chip "45 degree target, created", feedback text | PASS | `V6_portrait_matched` |
| A-5 | Leaving and returning starts a fresh visit: target 30, aim 0, "0 of 4 created" | PASS | `A2_reentry` |
| A-6 | Interaction works: arrow keys, target chips, Check | PASS | all of the above |

Note on A-5: the pitch hash right after re-entry (`eb326901…`) differed from the others (`39d4dac5…`). A pixel comparison showed the only differences are in the keyboard-focus ring around the pitch and its rounded corners: 0 differing pixels outside the 30 px corner zones. With the same focus state, every target gives the same hash. Nothing drawn on the pitch depends on the target.

### Phase 4: Responsive and accessibility

| # | Scenario | Result | Evidence |
|---|---|---|---|
| R-1 | Portrait: both activities, no clipped controls, no overflow | PASS | `F7_result`, `V6_portrait_matched` |
| R-2 | Landscape, Create the Angle: invariance holds across targets, match works, controls panel scrolls to Check, feedback card complete | PASS | `L0_angle`, `L1_angle_matched`, `logs/V6_landscape.txt` |
| R-3 | Landscape, Fractions of a Set: trays left, controls right, correct result fits | PASS | `L2_fractions`, `L3_fractions_result` |
| R-4 | Large text (in-app Reading Size "Large", 1.15×): Fractions result and Create the Angle match fit, with invariance holding | PASS | `T2_frac_large_result`, `T3_angle_large_matched`, `logs/V6_large_text.txt` |
| R-5 | System Back from each activity returns to Applied Maths Studio, then Interactive Labs | PASS | session log |
| R-6 | In-app Reduce Motion and Quiet Study Mode both on: Create the Angle invariance and match unchanged. Binomial "Pull cube apart" goes straight to 100%. Panda Garden and Panda Portions open and respond | PASS | `RM_on`, `V6_rm_quiet_matched`, `S1`–`S4` |
| R-7 | Quiet Study Mode (Nyepi) effect | NOT APPLICABLE | It mutes audio cues and guided narration only, and none of the five integration activities uses either (source check). Audio cannot be verified over adb |
| R-8 | Reduce Motion animation timing (220 ms angle snap, 250 ms feedback scroll) | NOT TESTED on device | Too short to measure by screencap. Covered by the host tests |
| R-9 | TalkBack spoken output | NOT TESTED in this run | Human TalkBack H-1…H-7 passed on 2026-11-21 for the same app code (build `7f2a4ade…`); this commit changed only a test. Accessibility labels were checked here through the tree |

### Phase 5: Persistence and recovery

| # | Scenario | Result | Evidence |
|---|---|---|---|
| P-1 | Navigating away and back repeatedly across all five activities: app stays in the foreground, no crash | PASS | session log |
| P-2 | Learner data preserved | PASS | see Data |
| P-3 | Device settings restored | PASS | `before/` and `after/device_settings.txt` are identical |
| P-4 | Logs: no crash, ANR, Flutter error, overflow, routing or null-check error from 05:12:52 onwards (21,877 lines) | PASS, partial window | `logs/logcat_full.txt`, `logs/logcat_issues.txt` (empty) |

## Data preservation

The install changed no preferences: the preference file was byte-identical straight after `install -r`.

After testing, `FlutterSharedPreferences.xml` differs from the snapshot in four entries:

| Key | Before → after | Cause |
|---|---|---|
| `text_scale` | absent → 1.0 | Reading Size set to Large and back to Default. 1.0 is the app's default |
| `quiet_study_mode` | absent → false | Toggled on and off. false is the default |
| `feed_panda_v1_event_count_activityStarted_device-guest` | 20 → 21 | Opening Feed the Hungry Panda during the smoke check. Normal local usage counter |
| `captain_number_mission_date` | 2026-11-21 → 2026-11-22 | Daily mission rollover on the first launch of the day; progress stays 0 |

`reduce_motion` stayed `false`, and all progress, streak, achievement, onboarding and lab keys are unchanged. The engine files (`kernel_blob.bin`, `res_timestamp`, `profileInstalled`) changed because a new APK was installed. Nothing was reverted by hand.

## Defects and observations

1. **Minor, existing since `97d6096`:** Fractions of a Set's 250 ms feedback scroll checks only the system remove-animations setting, not the in-app Reduce Motion setting (`fractions_of_a_set_screen.dart:102`). Same pattern as F-3 in Pitch Coordinates. Not blocking.
2. **Observation, app-wide:** the app replaces the system font scale with its own Reading Size (`lib/main.dart:121`), so Android font size has no effect inside the app. Large text was therefore tested with Reading Size. This is an existing design choice.
3. **Evidence gap:** the device log buffer had already overwritten 05:09–05:12:52 (install, first launch, first Fractions screens) before capture. Those steps have screenshots and accessibility-tree evidence only.

## Final device state

- Candidate `741abb06…` is installed, and the app is open on Home.
- Every system setting matches the snapshot: font 1.0, density 420, animations 1.0, high contrast off, night mode off, TalkBack off, auto-rotate on with rotation 0, app locale default.
- In-app Reduce Motion and Quiet Study Mode are off, Reading Size is Default, and Sound Cues is still on (unchanged).

## Evidence location

Evidence was captured to a temporary session folder and copied on 2026-11-22. Each copy was checked byte-for-byte against its source.

- **In Git:** [`docs/qa/evidence/PANDA_BINOMIAL_ANGLE_2026-11-22/`](evidence/PANDA_BINOMIAL_ANGLE_2026-11-22/). It holds the screenshots, accessibility labels, measurement logs and device snapshots. Files, hashes, capture types and scenarios are listed in `EVIDENCE_MANIFEST.md`.
- **Outside Git:** the full device logcat, the learner-preference snapshots and the raw framebuffers. They contain personal or system-wide data, so they are stored on the QA workstation only. Their location and hashes are in the manifest.

Known follow-ups: [`PANDA_BINOMIAL_ANGLE_FOLLOW_UPS.md`](PANDA_BINOMIAL_ANGLE_FOLLOW_UPS.md).
