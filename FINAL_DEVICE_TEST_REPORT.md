# Final Device Test Report — Pixel 6a

**Device:** Google Pixel 6a, Android 16 (API 36), physical hardware connected via `adb`
**Build:** Debug, launched via `flutter run -d <device> --hot`, log continuously monitored for the
entire session
**Date:** 2026-07-01

## Summary

The app was driven interactively on the physical device (screenshots + `adb input tap`/`swipe`) while
tailing the `flutter run` log for `EXCEPTION CAUGHT` / `RangeError` / `FlutterError` / `Assertion`
markers. **Zero exceptions were logged during the entire session.** All layouts observed rendered
without overflow.

## What Was Exercised

| Area | Observation |
|---|---|
| Welcome screen | New headline, Student/Parent-or-Teacher cards, language selector, "Already have an account? Sign In" row, "Guest Mode" link — all rendered with no `RenderFlex` overflow (this row was specifically re-tested after an overflow was caught and fixed earlier in the sprint via a widget test) |
| Student onboarding | Step 1 "Welcome" → Step 2 "Choose your level" (KS2–KS5) → Step 3 "What's the goal?" showing the four new goal options (Build confidence / Improve school maths / Prepare for exams / Challenge myself) with correct icons; "Start Learning" button correctly disabled until a goal is chosen |
| Practice → Exam Simulator | Selecting KS4 surfaced the new "SELECT EXAM" row: GCSE Foundation and GCSE Higher enabled, Oxford Track and Swiss Gymnasium shown locked (lock icon, amber) exactly as designed; mode subtitle correctly read "Select an exam to begin" until a valid exam was chosen |
| Topics screen | Rapid, repeated taps across all four filter chips (the exact stress pattern that previously reproduced a `RangeError` in an earlier QA round) — no crash, no stale data |
| Formula Library | Opened from the new Home card; category chips (Algebra, Pythagoras, Circle, Trigonometry, …) filtered correctly; Trigonometry showed SOHCAHTOA / Sine Rule / Cosine Rule matching the JSON catalog; expanding a card and navigating back worked cleanly |
| Mental Math trick detail (regression) | Confirmed unrelated pre-existing screens still navigate correctly after the router changes |

## Overflow / Layout Issues Found and Fixed This Sprint

- **Fixed:** `Row` containing "Already have an account? Sign In" overflowed by 83px on narrow/long
  locale strings (caught by `flutter test`, not manually — see below). Fixed by switching to a
  `Wrap` and tightening the `TextButton`'s tap-target padding. Re-verified with no overflow on both
  the automated test and the physical device.

## Automated Coverage Backing the Manual Pass

Because the device's screen locks after a very short timeout (requiring repeated owner unlocks),
manual device coverage was supplemented — not replaced — by the full widget test suite, which
exercises every supported locale against the onboarding flow and all six bottom-nav tabs
(`navigation_localization_widget_test.dart`, 27 locale variants) plus a dedicated overflow check
(`widget_test.dart`, `home_features_widget_test.dart`). All 62 tests passed after the fixes above.

## Verified Configuration (duplicate-install check)

- `android/app/src/main/AndroidManifest.xml`: exactly one `<activity>` with a `LAUNCHER` intent-filter,
  `android:label="Math Intelligence"`.
- `android/app/build.gradle.kts`: single `applicationId` = single `namespace` =
  `com.quantumlab.mathtutor.gb`, no product flavors currently defined — no duplicate-install risk in
  the current build.

## Recommendation

**Device behavior is stable and ready for Google Play Internal Testing.**
