# Follow-ups from the Panda / Binomial / Angle Pixel acceptance (2026-11-22)

These items were found during acceptance of `integration/panda-binomial-angle-v1` at `4494356`. That acceptance was **GO**; see `PANDA_BINOMIAL_ANGLE_PIXEL_ACCEPTANCE.md`. None of these items came from this integration and none blocks it.

Recorded only. No fix is included or approved here.

## FU-1: Fractions of a Set feedback scroll ignores the in-app Reduce Motion setting

| | |
|---|---|
| Type | Accessibility, minor |
| Since | Fractions of a Set V1, merged into integration as `97d6096` |
| Where | `lib/screens/labs/fractions_of_a_set/fractions_of_a_set_screen.dart:102` |
| Behaviour | The scroll that brings feedback into view jumps only when the Android system remove-animations setting is on (`MediaQuery.disableAnimationsOf`). With the app's own **Reduce Motion** on and the system setting off, it still animates over 250 ms. |
| Expected | Jump when either the in-app setting (`LocalPreferencesService.instance.reduceMotion`) or the system setting is on. Create the Angle already does this (`create_angle_screen.dart:52`). |
| Related | Pitch Coordinates has the same pattern, finding F-3. Its contract V1.3 amendment A-3 already requires the fix there. |
| Evidence | Found by reading the source during acceptance R-6. 250 ms is too short to measure by device screencap. |
| Suggested check | A host widget test: with the in-app Reduce Motion on, the feedback reveal calls `jumpTo`, not `animateTo`. |

## FU-2: The app's Reading Size overrides Android's font size

| | |
|---|---|
| Type | Accessibility, design decision to review |
| Since | App-wide, existing (`lib/main.dart:121`) |
| Behaviour | `MaterialApp.builder` replaces the platform `textScaler` with `TextScaler.linear(textScale)` from the app's Reading Size setting: Small, Default 1.0, or Large 1.15. Android's font-size setting therefore has no effect inside the app. It was set to 2.0 on the device, and the app text stayed at 1.0. |
| Impact | Learners who depend on a large system font get only the app's options, and the largest of those is 1.15×. |
| Evidence | `evidence/PANDA_BINOMIAL_ANGLE_2026-11-22/screenshots/T0_frac_large.png` (system font 2.0, app text unscaled) and `TL_large_setting.png`. |
| Decision needed | Product owner: whether the platform scale should combine with Reading Size, for example by multiplying the two and capping the result, or keep being replaced. Any change needs layout re-verification on every screen. |

## FU-3: Early install and launch logs were not captured

| | |
|---|---|
| Type | QA process |
| What | The device's log buffer holds about 30 minutes. By the time it was captured, it had overwritten 05:09–05:12:52: install, first launch, and the first Fractions of a Set screens. |
| What remains | Screenshots `P1_home`, `F0_open`, `F1_wrong`, `F2_notready`, `F2b_notice`. Accessibility labels `F0_labels.txt`. Install verification (hash, signer, first-install date, unchanged preferences), recorded in the report. |
| Process fix | Save `adb logcat -d` right after install and first launch, then again at intervals during long sessions. Never use `logcat -c`. |
