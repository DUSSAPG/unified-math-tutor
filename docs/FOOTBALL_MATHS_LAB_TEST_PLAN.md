# Football Maths Lab — V1 Test Plan

Companion to `docs/FOOTBALL_MATHS_LAB_SPEC.md`. No tests exist yet — this document specifies what must be written once implementation begins, mirroring the structure and coverage of `test/flight_path_lab_widget_test.dart` and this repo's other RC1 quality-validation suites.

## Test files (proposed)

- `test/football_maths_lab_widget_test.dart` — core interaction, mirrors `flight_path_lab_widget_test.dart`'s shape.
- `test/football_maths_lab_mobile_layout_test.dart` — viewport/text-scale matrix, mirrors `labs_mobile_layout_test.dart`.
- `test/football_maths_lab_accessibility_test.dart` — semantics, alt-input path, Reduce Motion, Quiet Study Mode, mute/haptics-off.

## 1. Core interaction (`football_maths_lab_widget_test.dart`)

Mirrors Flight Path Lab's existing test cases, translated to this lab's model:

- First scenario shows the target zone/goal position in plain language at Explorer band, and in degrees/metres at Builder/Navigator.
- A release vector computed to land inside the target zone radius produces a `success`-kind result banner; `recordCompletion` is called exactly once for that attempt.
- A release vector landing between the success and near-miss thresholds produces a `nearMiss`-kind banner with the "close" copy.
- A release vector landing beyond the near-miss threshold produces a `tryAgain`-kind banner.
- "Try Again" resets aim to the neutral default and clears the result, staying on the same scenario (the target zone doesn't change).
- "Next Challenge" cycles to the next deterministic scenario and clears `_lastTested*` comparison state.
- A repeated, unchanged attempt (identical angle/power to the last Kick) triggers the "nudge to change something" narration path instead of repeating the same result explanation verbatim.
- A Builder/Navigator-band scenario requires a prediction (if this lab adopts Flight Path Lab's predict-before-test pattern) before Kick is enabled; Explorer band does not require one.
- `recordAttempt(InteractiveLabId.footballMathsLab)` fires exactly once per Kick, regardless of drag vs. slider+button input path.
- Deterministic model unit checks (no widget needed): given a fixed `(angle, power)`, the landing point, error, and accuracy are exactly reproducible — same inputs always produce the same outputs (no `Random`, no time-based variance).
- Simple average: after N attempts with known accuracy values, the displayed "average accuracy" matches `mean(accuracies)` to the same rounding the UI uses.

## 2. Gesture and alternative-input coverage

- Dragging from the ball updates the live aim preview (angle/power) without committing a kick until `onPanEnd`.
- Angle clamps at the forward-cone boundary — a drag past the clamp does not exceed it (assert on the exposed angle value, not pixel position).
- Power clamps at `[0, 1]` — dragging beyond `maxDragDistance` holds at maximum power, no error/exception.
- The Angle slider, Power slider, and explicit Kick button alone (zero drag gestures used) can complete a full Aim → Kick → Result → Try Again loop — this is the accessibility-critical path and must be a first-class test, not an afterthought.
- The Explorer-band "Aim at target" shortcut sets angle/power such that the resulting landing point is inside the target zone (or matches Flight Path Lab's equivalent guarantee).
- First-use drag cue: pulsing cue shows until one successful drag interaction, then `hasSeenDragCue` is true and the cue never reappears for that profile (mirror the existing Flight Path Lab drag-cue test coverage if present, or add it if that specific case isn't already covered there).

## 3. Animation and motion behaviour

- **Reduce Motion respected**: with `LocalPreferencesService.instance.reduceMotion` set true (and separately, with `MediaQuery.disableAnimationsOf` true via a wrapping `MediaQuery` override), the flight path renders as an immediate static line/curve — assert the final landing state is present on the very next frame after Kick, with no intermediate "in-flight" animated frames observed via `pump()` stepping.
- **Reduce Motion never hides meaning**: the trajectory line/curve itself is still present and inspectable (e.g. via a `CustomPaint`/painter equality check or a semantics description) under Reduce Motion — only the animated *drawing* of it is removed, not the path itself.
- **Motion tokens**: any `AnimationController` duration used by this lab is asserted to fall within the shared motion-token bands defined by the parallel motion-system work (instant/control/reveal/celebration) — a lint-style test asserting no hardcoded duration outside those constants, if the motion-token system exposes an inspectable constant set.
- **Animation interruption**: triggering a second Kick (via the accessible Kick button, to avoid needing a real drag in a widget test) while a previous flight animation is still in progress does not throw, does not leave two concurrent tickers, and the visible result always reflects the *latest* kick, not a stale one (mirrors `GuidedNarrationService`'s `requestSerial` "stale narration never wins" pattern — this lab should adopt the same idea for stale animations).
- **Rapid repeated taps**: tapping Kick/Reset/Next rapidly in succession (`tester.tap` in a tight loop with minimal `pump` between) does not throw, does not double-record `recordAttempt`/`recordCompletion` for a single logical action, and leaves the UI in a consistent end state.
- **Route exit during animation**: navigating away (back button / route pop) while the flight animation is mid-flight does not throw, and does not leave a running `AnimationController` — covered by the disposal test below rather than a separate scenario.
- **No leaks after disposal**: `tester.pumpWidget(const SizedBox.shrink())` immediately after triggering a Kick (so a controller is mid-animation) followed by `tester.pumpAndSettle()` must not throw a "used after dispose" or a pending-timer error; explicitly assert `LabInactivityTracker`'s internal `Timer` and any new `AnimationController` are both cancelled/disposed (use `tester.binding.debugCheckZone`-style leak assertions already used elsewhere in this repo if such a helper exists, or fall back to "no exception during teardown + no pending timers reported by `flutter_test`'s async guard").
- **No animation-driven golden-test instability**: if any golden-image test is added for this lab, it must pump to a fully-settled frame (`pumpAndSettle` or an explicit frame count) before capturing, and the captured state must be Reduce-Motion-independent (same golden regardless of the reduce-motion flag) — or golden tests should be scoped to static states only (idle/result), never mid-flight frames.

## 4. Sound / haptics / Quiet Study Mode

- With `soundEnabled = false`, no `AudioCueService.play` call reaches `_playAsset` in a way that would matter once assets exist (assert via the existing no-op contract — this lab's cues are gated exactly like Flight Path Lab's, so this is a smoke test confirming the gate is applied, not new gating logic).
- With `quietStudyMode = true`, cues are suppressed the same way; Captain Math's message is still present in the widget tree (required instructional state is never hidden by Quiet Study Mode).
- With haptics disabled (once the parallel Sound/Haptics Foundation service exists), a Kick action does not throw and does not attempt a platform haptic call — assert via whatever fake/mock the new central feedback service exposes for tests.
- No sound cue fires during a scenario flagged as a test/assessment context, if this lab is ever surfaced inside a timed/scored flow (not planned for V1, but the assertion should exist if the shared feedback-service contract from the interaction-polish pass enforces "no sound during tests" globally — verify this lab doesn't opt out of that global rule).

## 5. Accessibility

- `Semantics(image: true, label: ...)` is present on the pitch/ball canvas with `ExcludeSemantics` on the painted internals (mirrors Flight Path Lab's radar canvas pattern) — assert via `find.bySemanticsLabel` and confirm no stray semantics nodes leak from inside the `CustomPaint`.
- Angle and Power sliders both expose accessible labels reflecting their current value in plain language (not just a raw number) at the Explorer band.
- The result banner is a `liveRegion` (mirrors `LabResultBanner`'s existing `Semantics(liveRegion: true, container: true)`) and receives focus on first appearance after a Kick, exactly like `LabScaffold`'s existing `_resultFocusNode` behaviour — assert focus moves there, not just that the banner renders.
- No information is conveyed by colour alone: assert each `LabResultKind` state also renders a distinct icon (already guaranteed by `LabResultBanner`, but re-assert for this lab's specific outcome mapping).
- 44×44 minimum tap target size on Kick, Reset, Next, and the Explorer-band "Aim at target" button.
- 1.6× text scale: no overflow at any of the 8 required viewport sizes with the Angle/Power slider labels and result banner text at 1.6× scale (mirrors `labs_mobile_layout_test.dart`'s existing `textScale: 1.6` helper).

## 6. Layout / viewport matrix

Same 8 sizes as every other RC1-era test suite in this repo:
320×568, 360×640, 390×844, 412×915, 600×960, 768×1024, 844×390, 1280×800 — assert no `RenderFlex` overflow (`tester.takeException()` is null) at each, both in the narrow (<420px, stacked) and wide (side-by-side) layout branches.

## 7. Localisation

- All `labsFootballMathsLab*` keys resolve to non-empty values in `app_en_GB.arb`, `app_de_CH.arb`, `app_fr_CH.arb`, `app_it_CH.arb` (extend `test/math_studio_l10n_completeness_test.dart`'s existing `labs` prefix coverage — no new prefix needed).
- DE-CH/FR-CH/IT-CH translations differ from the English string where not a genuine cognate (same "leaks English" check already enforced for every other `labs*`/`mathStudio*` key), with the same cognate-exemption mechanism used for legitimate shared vocabulary.
- Screen renders without overflow in at least the 4 gated locales (en, fr-CH, de-CH, it-CH) at the required viewport matrix — mirrors the pattern in `math_studio_navigation_widget_test.dart`.

## 8. Deterministic-model unit tests (no widget tree needed)

A plain Dart test file (e.g. `test/football_maths_lab_model_test.dart`) for the pure functions in §4 of the spec, independent of any widget:
- Angle/power decomposition from a drag vector is correct for known vectors (straight up, 45° left/right, clamped extremes).
- Landing point formula matches hand-computed expected values for a handful of fixed `(angle, power)` pairs.
- Error/accuracy/outcome-classification thresholds produce the expected `LabResultKind` and `FootballOutcome` at boundary values (exactly at the threshold, just inside, just outside) — boundary tests are the highest-value tests for this kind of thresholded classifier.
- Average accuracy over a known sequence of attempts matches a hand-computed mean.

## 9. Full-suite gates (run once implementation lands)

```
flutter analyze
flutter test --reporter compact
flutter build apk --debug
flutter build web
```

No test in this plan should be flaky by construction — every animation-dependent assertion must pump to a deterministic, named frame state (never rely on wall-clock `Future.delayed` timing beyond the fixed, documented durations from the motion-token system), matching this repo's existing convention of deterministic, seed-free widget tests.
