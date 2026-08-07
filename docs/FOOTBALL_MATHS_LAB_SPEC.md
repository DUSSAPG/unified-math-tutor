# Football Maths Lab — V1 Specification

Status: **Spec only — no production code changes.** Companion to `docs/FOOTBALL_MATHS_LAB_TEST_PLAN.md`.

## 1. Design intent

An original Interactive Lab, not a copy of Synthesis or any other product. The learner drags from a football to aim and set power, releases to kick, and watches a deterministic flight to a landing point relative to a goal and marked target zones — the same "predict → try → test → notice → explain → try again" guided loop every other Interactive Lab already uses, applied to direction, angle, distance and simple averages instead of bearings/speed/time.

It is architecturally a **sixth Interactive Lab**, not a new top-level pillar or a Discovery Library card. It sits at `/math-studio/interactive-labs/football-maths-lab`, reachable from the existing Interactive Labs hub exactly like Fraction Builder, Algebra Balance, Number Line Explorer, Flight Path Lab and Data Detective are today.

## 2. What this reuses vs. what is new

This lab is designed to be the **least novel possible implementation** that still teaches new maths — maximum reuse of Flight Path Lab's proven architecture, matching content instead of new plumbing.

**Reused as-is, zero changes:**
- `LabScaffold` (Mission → Try → Predict → Test → Notice → Explain → Try another shell, Help sheet, Reset button, first-use walkthrough, `GuidedNarrationBanner`, "Where you'll use this", `LabRelatedLinks`).
- `InteractiveLabsProgressService` — `attemptsFor`/`recordAttempt`, `completedFor`/`recordCompletion`, `recordLinkedRecallUse`/`recordLinkedDiscoveryUse`/`recordLinkedPracticeUse`, `guidanceLevel()`, `hasSeenFirstUse`/`markFirstUseSeen`, `hasSeenDragCue`/`markDragCueSeen`, narration mute/text-only/speed prefs. **No new service, no new SharedPreferences schema** — `InteractiveLabId.footballMathsLab` is just a new enum value plugged into every existing generic method.
- `LabGuidanceLevel` (explorer/builder/navigator) and `LevelText` for level-appropriate copy.
- `GuidedNarrationService` + `NarrationMessage` + `LabNarrationTrigger` — same deterministic, offline, pre-authored narration contract, same no-op-until-assets-exist audio hook.
- `CaptainMathService` (`showDiscoveryIntro`/`showEncouragement`/`showCompletion`) — `LabScaffold` already fires the intro; the lab calls encouragement/completion exactly where Flight Path Lab does.
- `LabResultBanner` / `LabResultKind` (success/nearMiss/tryAgain, three states, never colour-only).
- `LabInactivityTracker` (25s idle → gentle Captain Math nudge).
- `LabRelatedLinks` — real cross-links exist today: Discovery Library already has `football-pass-accuracy` and `football-goal-conversion` cards (soccer, not American football) with approved text-free illustrations.
- `AudioCueService` — reuse `objectSelect`, `testLaunch`-equivalent, `success`, `nearMiss`, `retry`, `nextMission`, `captainMathPrompt` outright; two new enum values proposed (§11).
- Mobile layout contract from `flight_path_lab_screen.dart`: `LayoutBuilder` narrow-breakpoint (<420px) stacking, canvas sizing clamped to a range instead of fixed, control size clamped `(availableWidth * k).clamp(min, max)`.
- `CustomPainter`-drawn vector graphics instead of raster assets — Flight Path Lab draws its own aircraft and radar as vectors; Football Maths Lab draws its own ball, goal, pitch markings and target zones the same way. This sidesteps the generated-artwork approval question for V1 entirely (§17).

**New for this lab:**
- `InteractiveLabId.footballMathsLab` enum value + route entry (additive, per the enum's own doc comment: "New labs are an additive enum + route change, never a schema change").
- The deterministic kick/trajectory model (§4) — new maths, new formulas, same *shape* of determinism as Flight Path Lab's bearing/distance model.
- The drag-to-aim gesture (§5) — conceptually like Flight Path Lab's draggable aircraft, but drag *distance* also encodes power, which Flight Path Lab's heading-only drag doesn't need.
- New l10n key namespace `labsFootballMathsLab*` (§10).
- Optional two new `AudioCue` enum values (§11) — additive to the existing enum, not a new service.

## 3. Core interaction loop

1. **Aim (drag).** Learner presses on the ball and drags. A preview line/arc shows current direction and power live as the drag continues.
2. **Kick (release).** Releasing the finger commits the current drag vector, plays the kick animation, and runs the deterministic trajectory.
3. **Flight.** The ball follows the precomputed path from kick point to landing point. The path is drawn/interpolated over a bounded duration (§6) — never an open-ended or blocking sequence.
4. **Result.** Ball settles at its landing point. `LabResultBanner` shows Notice ("You kicked 2m wide of the target") + Explain ("Aim 5° further left next time"). Captain Math reacts (encouragement or completion).
5. **Replay.** "Try Again" resets aim to a neutral default and clears the result, staying on the same target scenario (mirrors Flight Path Lab's `_reset`, which deliberately does *not* clear the "last tested" comparison, so a repeated identical attempt is its own detected case). "Next Challenge" advances to the next deterministic scenario.

Every stage has a non-drag path (§8) — the loop must be completable without ever performing a drag gesture.

## 4. Deterministic mathematical model (V1)

No physics engine, no integrator, no randomness. Every landing point is a closed-form function of the release vector, computed once at kick time — exactly like Flight Path Lab computes a landing point as one `_bearingToOffset` call, not a frame-by-frame simulation.

**Coordinate system.** A fixed pitch-relative coordinate grid, origin at the ball's kick spot, `+y` = "toward the goal," `+x` = "toward the goal's right post" (from the kicker's perspective). Units are metres, matching real-world scale so the numbers stay meaningful (a typical shot distance range: 6–30 m, matching a penalty-to-edge-of-box range).

**Reading the release vector.** At release, the raw drag vector `(dx, dy)` from the ball's centre to the release point is converted to:
- **Angle** `θ = atan2(dx, -dy)` in degrees, `0°` = straight at the goal centre, positive = right, negative = left. Snapped to the nearest 2° (mirrors Flight Path Lab's 5° heading snap; finer here because the target zones are narrower than a whole compass octant).
- **Power** `p = clamp(dragDistance / maxDragDistance, 0, 1)`, mapped linearly to a fixed **kick speed** range `[minSpeed, maxSpeed]` m/s (e.g. `8–24 m/s`), so `speed = minSpeed + p * (maxSpeed - minSpeed)`.

**Distance and landing point.** A fixed, scenario-independent **flight duration** `t` (analogous to Flight Path Lab's fixed 2-hour flight time) converts speed directly into distance: `distance = speed * t`. The landing point is then:
```
landingX = distance * sin(θ)
landingY = distance * cos(θ)
```
identical in form to Flight Path Lab's `_bearingToOffset`. No wind term in V1 (Flight Path Lab's wind offset is reserved for its one advanced-band scenario only — Football Maths Lab has no wind in V1; see §Later levels).

**Target zones.** Each scenario defines a goal rectangle (fixed width/position, e.g. a standard 7.32 m goal centred on `x=0` at `y = targetDistance`) and one or more circular **target zones** inside/around it (e.g. "top-left corner," "keeper's reach," "just wide" as an intentional near-miss zone). A scenario is `{targetZoneCenter: (x, y), targetZoneRadius, targetDistance, level}` — the same flat, fixed, non-procedural scenario-list pattern as Flight Path Lab's `_scenarios` const list.

**Error metric.** `error = distance((landingX, landingY), targetZoneCenter)`. This single number drives outcome classification (§7 in Flight Path Lab's pattern, reused verbatim in shape): a low threshold → success, a mid threshold → near-miss, otherwise try-again — plus the same finer breakdown Flight Path Lab uses (`angleCorrect && distanceCorrect`, `angleCorrect only`, `distanceCorrect only`, neither) to pick the most useful narration line, not to change the banner.

**Accuracy and average.** Per attempt, `accuracy = clamp(1 - error / errorAtWhichAccuracyIsZero, 0, 1)` (a simple, transparent linear falloff — no scoring curve to explain). **Simple average over multiple shots**: `averageAccuracy = mean(accuracy for each attempt this session)`, shown after ≥2 attempts as `"Your average accuracy so far: 72%"` — direct, curriculum-relevant use of mean, computed from a plain running list, not a weighted/statistical model.

**V1 mathematics covered:** direction/angle (θ), distance (`speed * t`), relative power (`p`, a proportion/percentage), coordinate position (`(landingX, landingY)`), attempt count, accuracy (a percentage), simple average (mean of accuracy across attempts).

## 5. Gesture model

- **Primary (drag):** `onPanStart` on the ball registers the drag origin (ball centre). `onPanUpdate` computes the live `(θ, p)` preview from the current drag vector and redraws the aim line + power indicator, throttled exactly like Flight Path Lab's `AudioCue.aircraftTurn` throttle (250 ms) for any accompanying cue. `onPanEnd` commits the release vector, triggers the kick.
- Angle clamped to a forward cone (e.g. `-80°` to `+80°`) — a learner cannot "kick backward"; the drag simply clamps at the cone edge, same idea as Flight Path Lab's `vector.distance < 4` dead-zone-near-pivot guard.
- Power clamped to `[0, 1]` via `dragDistance / maxDragDistance`; dragging further than `maxDragDistance` just holds at maximum power (no error state, no penalty).
- **Direct-manipulation cue tracking:** reuses `hasSeenDragCue`/`markDragCueSeen` verbatim — first-use pulsing cue on the ball, dismissed forever after one successful drag, per profile.
- **Non-drag alternative (§8):** an "Aim" stepper/slider pair plus an explicit "Kick" button — the same drag-vs-slider-vs-button redundancy Flight Path Lab already offers (drag the aircraft, tap the radar, or read/adjust via the heading control), so no interaction is drag-only.

## 6. Animation states

| State | What happens | Bounded duration (motion-token band) |
|---|---|---|
| Idle/Aim | Static ball + goal + target zones; live aim line follows drag in real time (not a timed animation, tracks the finger 1:1) | n/a — direct manipulation |
| Kick | Ball departs kick spot, quick "impact" visual (scale/squash pulse on the ball) | Instant feedback band (~100–150 ms) |
| Flight | Ball travels the precomputed path from kick point to landing point, arc drawn progressively | Content reveal band (~250–400 ms) |
| Result settle | Ball comes to rest at landing point; result banner appears | Control transition band (~180–250 ms) |
| Success celebration | Optional small celebratory flourish only on true success (not near-miss) | Celebration band, capped ≤700 ms |
| Reset/Next | Ball and aim line return to neutral | Control transition band (~180–250 ms) |

Every duration in this table must come from the shared motion-token system introduced in the parallel RC1 interaction-polish pass, not a hand-rolled constant local to this lab — this lab should be one of that system's first real consumers, alongside a Flight Path Lab retrofit.

Nothing in this loop blocks answering: the flight animation plays while the result is already computed (deterministic, instant), so Reduce Motion (§8b) can skip straight to the settled state without changing any outcome.

## 7. Success and near-success classification

Reuses `LabResultKind` (`success`/`nearMiss`/`tryAgain`) unchanged — no new result-kind enum. Thresholds authored per scenario (not hardcoded globally) since target-zone radius varies by scenario, mirroring Flight Path Lab's fixed `error < 15` / `error < 60` bands but expressed relative to each scenario's `targetZoneRadius`:
- **Success:** `error <= targetZoneRadius`
- **Near-miss:** `targetZoneRadius < error <= targetZoneRadius * 3`
- **Try again:** `error > targetZoneRadius * 3`

A finer, narration-only breakdown (angle-correct/distance-correct combinations) mirrors `FlightOutcome` exactly in shape — propose a new `FootballOutcome` enum with the same 9-case shape (`correctAngleAndDistance, correctAngleTooFar, correctAngleTooShort, wrongAngleCorrectDistance, wrongAngleAndDistance, nearMiss, repeatedUnchangedAttempt, inactivity, completion`), purely local classification, no new mathematical engine.

## 8. Accessibility

**(a) Alternative to drag gestures.** A learner must be able to complete the entire loop — aim, kick, read result, retry — without ever performing a drag:
- An **Angle** control: a labelled `Slider` (or stepper for finer/more accessible control) spanning the same clamped forward cone, with the current value announced in plain language at the Explorer band ("aiming slightly right") and in degrees at Builder/Navigator, mirroring Flight Path Lab's dual plain-word/three-figure-bearing label.
- A **Power** control: a labelled `Slider` from 0–100%, mirroring the existing Speed slider's shape (`min`/`max`/`divisions`/live label).
- An explicit **Kick** button, always present and always the same action drag-release triggers — never drag-only.
- An **"Aim at target"** shortcut button at the Explorer band, mirroring Flight Path Lab's `_setHeadingFromTarget` "tap target hint" button.
- The pitch/ball visualization itself is `Semantics(image: true, label: ...)` with `ExcludeSemantics` on the painted canvas (exact Flight Path Lab pattern), so screen readers get one clear description instead of fighting the custom paint internals.

**(b) Reduce Motion.** Under `reduceMotion` (persisted preference) or `MediaQuery.disableAnimationsOf`, using the shared motion-token gate:
- Decorative movement removed: no squash/impact pulse, no celebration flourish.
- The flight path is **not skipped** — it carries mathematical meaning (the shape of the trajectory *is* the lesson). Under Reduce Motion it is drawn **instantly** as a static completed line/curve (an immediate state change, not an animated draw), exactly the "use fades or immediate state changes... never hide mathematical meaning" rule.
- Result banner and Captain Math state change appear immediately, no transition.

**(c) Standard a11y bar (same as every other lab):** 44×44 minimum tap targets on Kick/Reset/Next, live-region result banner, no colour-only signalling (icons already differentiate success/near-miss/try-again per `LabResultBanner`), focus moves to the result banner on first appearance post-action (`LabScaffold` already does this generically), 1.6× text scale support, all 8 required viewport sizes.

## 9. Quiet Study Mode behaviour

Identical gating to every existing audio cue: `AudioCueService._cuesAllowed` already checks `soundEnabled && !quietStudyMode` — Football Maths Lab's cues (kick, success, near-miss) inherit this for free by using the same service. Captain Math remains visible (required instructional state) but not visually "loud" — matches the existing Quiet Study Mode contract ("gates Captain Math's visual prominence and all optional audio cues; never gates required information").

## 10. Localisation

New key namespace `labsFootballMathsLab*`, following the exact existing convention (`labsFlightPathLab*`): title, mission, concept, where-used, help (what-to-do/what-to-notice/what-it-means), first-use steps (3), angle/power labels and helpers, prediction prompt + 3 choice options, target explanation, result distance/spot-on/close/try-again strings, and narration text for introduction/hint-inactivity/hint-repeated/result-{9 outcomes}/completion — each ×3 guidance levels, exactly mirroring Flight Path Lab's key count and structure. Added to the same 5 ARB files carrying Math Studio content today (`app_en.arb`, `app_en_GB.arb`, `app_de_CH.arb`, `app_fr_CH.arb`, `app_it_CH.arb`), matching the precedent set when Math & Magic/Spatial Intelligence keys were added. Real (non-machine) DE-CH/FR-CH/IT-CH translations required, checked against `test/math_studio_l10n_completeness_test.dart`'s existing `labs` prefix (already in `_prefixes`, no test-config change needed).

## 11. Child-safety boundaries

- No open text input anywhere in this lab. No chat. No unrestricted AI.
- Every Captain Math line is pre-authored `LevelText`, chosen deterministically by outcome + guidance level — never generated at runtime, never network-backed, identical contract to every existing lab.
- The optional **Allie post-activity connection** (§13) is a **read-only summary of the learner's own on-device progress counters**, not a conversation. It collects nothing beyond what `InteractiveLabsProgressService` already stores (attempts, completions) plus this lab's own local session accuracy average — no new personal data, no inference, no external transmission (there is no analytics/telemetry SDK in this app at all — see §12).
- Because Allie has **zero existing implementation** anywhere in the codebase (confirmed: no service, widget, or screen), per the parallel interaction-polish pass's Section C rule, the Allie entry point in this lab must ship as an **explicitly labelled "Preview" / disabled control** in V1 — never a working conversational surface. See §13's exact contract.

## 12. Telemetry events

This app has no external analytics/telemetry SDK anywhere (confirmed by codebase search) — all "telemetry" is on-device, profile-scoped progress counters via `*_progress_service.dart` files, consistent with the frozen entitlement/privacy posture. Football Maths Lab needs **zero new persistence infrastructure**:
- `InteractiveLabsProgressService.recordAttempt(InteractiveLabId.footballMathsLab)` — called once per Kick.
- `InteractiveLabsProgressService.recordCompletion(InteractiveLabId.footballMathsLab)` — called once per success-classified result.
- `recordLinkedRecallUse`/`recordLinkedDiscoveryUse`/`recordLinkedPracticeUse` — called from `LabRelatedLinks` exactly as every other lab already does, no lab-specific code needed.
- Existing generic `hasSeenFirstUse`/`markFirstUseSeen` and `hasSeenDragCue`/`markDragCueSeen` — reused as-is.

No new SharedPreferences keys are strictly required for V1. If "simple average over multiple shots" should persist across sessions (rather than reset each time the lab reopens, matching every other lab's session-only, no-mastery-scheduler philosophy), that would need two small optional additions to `InteractiveLabsProgressService` (`_lastAccuracyKey`, `_bestAccuracyKey` per lab) — proposed as an explicit **V1.1 nice-to-have**, not required for the V1 loop, to keep the initial cut minimal.

## 13. Progress storage

No new file. `InteractiveLabId.footballMathsLab` is a new enum member; every existing `InteractiveLabsProgressService` method already keys off `InteractiveLabId`, so attempts/completions/linked-use/guidance-level/first-use/drag-cue tracking all work immediately with zero service changes. Session-only running accuracy list lives in the screen's own `State` (like `_lastTestedHeading`/`_lastTestedSpeed` in Flight Path Lab), not in a service, unless V1.1's persisted-average is adopted.

## 14. Captain Math messages

Same `LevelText`-per-trigger structure as Flight Path Lab, same trigger set (`introduction`, `hint` ×2 variants — inactivity and repeated-unchanged, `resultExplanation` ×9 outcome variants, `completion`). Content authoring (actual copy) is out of scope for this spec — only the key/structure contract is specified here, matching how this document treats Flight Path Lab as the pattern to replicate, not to re-litigate.

## 15. Allie summary contract

A plain data shape only — **not a service, not a network call, not implemented in V1 beyond a disabled/preview UI element**:

```dart
class FootballLabAllieSummary {
  final int attempts;
  final int completions;
  final double? averageAccuracy;   // session-scoped in V1
  final double? bestAccuracy;      // session-scoped in V1
  final List<String> mathSkillTags; // e.g. ['angle', 'distance', 'average']
}
```

V1 UI contract: a single row/card in the lab's "Where you'll use this" / Connect area reading something like *"Ask Allie about your progress"*, rendered with a **"Preview"** badge (reusing the same badge visual language as Math & Magic/Spatial Intelligence's in-development pillars — `InDevelopmentFeatureCard`-style, no `onTap`) rather than a working button, since no Allie surface exists to receive this summary yet. This satisfies "optional Allie post-activity connection" as a structural placeholder without building unrestricted AI or a new backend in this pass.

## 16. Screen sizes

Identical contract to Flight Path Lab: `LayoutBuilder`-driven narrow breakpoint at 420px (stack vertically below it, side-by-side above), canvas sizing clamped to a sensible range rather than fixed, control size `(availableWidth * k).clamp(min, max)`. Tested at the same 8 required viewports already used across this app's other RC1 test suites: 320×568, 360×640, 390×844, 412×915, 600×960, 768×1024, 844×390, 1280×800.

## 17. Asset manifest

**V1 requires zero generated artwork.** The ball, goal, pitch markings, target zones, aim line and power indicator are all drawn with `CustomPainter` (deterministic vector shapes, same technique as Flight Path Lab's `_AircraftPainter`/`_RadarPainter`) — no raster assets, no text-in-image risk, no approval-gate dependency. This is the safest and fastest V1 choice and sidesteps the generated-artwork rules (§E of the parallel interaction-polish brief) entirely for the core interaction.

**Optional, explicitly deferred:** a contextual background illustration (stadium/pitch backdrop) could later go through the same versioned, manifest-driven ComfyUI pipeline used for Discovery Library (`content/pipelines/discovery_illustrations`), under the identical hard rule already established there — text-free, no logos, no watermarks, flat vector/illustration style only, human-approved before wiring. Not needed for V1 and not planned in the phases below.

## Later levels (explicitly out of scope for V1)

Slope, quadratic trajectory modelling (a real projectile arc instead of a straight-line closed-form landing point), probability (shot-success likelihood given aim precision), optimisation (best angle/power for a given constraint), a moving goalkeeper, wind, expected value. None of these are implied or partially built by the V1 model above — V1's trajectory is intentionally a straight top-down line-of-flight (like Flight Path Lab's), not a parabola, specifically so it needs no physics engine and no iterative simulation. A future "quadratic trajectory" level would be a genuinely new visual/mathematical model, not an extension of V1's formulas.
