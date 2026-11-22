# Accessibility Release Gate B: System Text Scaling (FU-2)

**Status:** Implemented and verified on the host; not committed and not pushed. **Recommendation: GO** for FU-2 (see §11). Sections 1–6 are the Phase 1 investigation, kept as written before any code changed.
**Branch:** `fix/accessibility-release-gate-b`, in worktree `unified_math_tutor_a11y_release_gate_b`, created from Gate A commit `c97b696`. That commit sits on top of the accepted integration merge `8778cf4`.
**Protected checkout:** untouched. `feature/math-intelligence-v2` is at `5f49c50` with 24 uncommitted changes, and its status fingerprint is the same as before.

## 1. Current scaling behaviour

There is a single override point: the `MaterialApp.router` `builder` at `lib/main.dart:114-127`.

```dart
data: mediaQuery.copyWith(textScaler: TextScaler.linear(textScale)),
```

- **Android's font size is discarded.** This includes Android 14+ non-linear scaling, which Flutter receives in `MediaQuery.textScaler`. The app replaces it with a linear Reading Size factor: Small 0.9, Default 1.0 or Large 1.15.
- **The largest effective text is 1.15×,** whatever the device is set to. A learner can never reach the 1.6× that `docs/RC1_FEATURE_FREEZE.md` §6 treats as the overflow bar.
- **The code uses no deprecated `textScaleFactor` API.** All 30 text-scaling call sites in `lib/` use `TextScaler` or `MediaQuery.textScalerOf`.
- **Some widgets deliberately limit scaling locally, and stay that way:**
  - The Discovery and Recall Cards grids clamp to 1.0–1.6.
  - Painters clamp their labels: Binomial to 1.4, Create the Angle to 2.0, and Pitch Coordinates to 0.8 of a grid unit.
  - Shared card headers (`route_link_card`, `in_development_feature_card`) use `noScaling` for badge glyphs.

## 2. Reading Size controls and persistence

| Location | Control |
|---|---|
| `lib/screens/settings/accessibility_screen.dart` (`/profile/accessibility`) | Small, Default, Large; semantics fixed in Gate A |
| `lib/screens/onboarding/accessibility_step_screen.dart` (`/onboarding/accessibility`) | Same three options; fixed in Gate A |
| `lib/services/local_preferences_service.dart` | `textScale` ValueNotifier; key `text_scale` (a double), default 1.0; `setTextScale` |

There are no other writers. `ParentTeacherToolsScreen` has its own 1.0, 1.3 and 1.6 layout tests but no Reading Size control.

## 3. RC1 requirements

- **`RC1_FEATURE_FREEZE.md` §6:** an accessibility regression blocks release, and this includes "overflow at any of the RC1-supported viewport sizes or at 1.6× text scale".
- **`RC1_POLISH_PLAN.md`** marks "No overflow at 1.6× text scale" as done. That was only ever checked through injected `MediaQuery` values, because the real app could never reach 1.6×.

## 4. Existing large-text test coverage

- **Covered at 2.0× by injecting a `MediaQuery`, so the real app shell isn't involved:**
  - Create the Angle, Fractions of a Set, Pitch Coordinates;
  - Panda Garden and Panda Portions, and the Early Maths hub (`textScaleFactorTestValue = 2.0`);
  - Abacus, Discovery and Recall Cards (the RC1 hardening tests), Family Maths, `labs_mobile_layout_test`, and Parent and Teacher Tools (1.3 and 1.6).
- **Real-router sweep:** `polish_audit_overflow_sweep_test.dart` drives 65 routes through the real router, but **only at 1.0×**.

## 5. Probe: real routes with Android system scaling applied

**How the probe ran**
- It was a temporary test, deleted afterwards. It used the overflow sweep's real-router harness with `platformDispatcher.textScaleFactorTestValue` set to 1.3 and 1.6, and **without** the `main.dart` override. That is what the system scale does to each screen once it is honoured.
- It covered the sweep's 65 routes plus the 5 critical lab routes the sweep lacks (Early Maths hub, Panda Portions, Create the Angle, Fractions of a Set, Feed the Panda).
- Each route ran on a Pixel 6a in portrait (412×915) and landscape (844×390): 288 checks in total. In every check the effective scale (1.30 or 1.60) was confirmed to reach the screen.
- The full per-check output is kept outside Git, in the session scratchpad as `gate_b_probe_results.txt`.

**Result:** 249 passed and **39 failed**, 12 at 1.3× and 27 at 1.6×. Every failure is a layout overflow; none is a logic error.

| Surface | 1.3× | 1.6× | Source (where reported) | Critical list? |
|---|---|---|---|---|
| Onboarding: all 8 steps share `OnboardingShell` | portrait, plus 1 in landscape | portrait and landscape | `widgets/onboarding/onboarding_progress_header.dart:51` (step/time row), `screens/onboarding/onboarding_shell.dart:111` (Continue button row) | **Yes** |
| Help (`/help`) | portrait | portrait | Row overflowing on the right (60 px at 1.3×, 145 px at 1.6×) | No |
| Journey (`/journey`) | — | portrait and landscape | `screens/journey/journey_screen.dart:582`, `:637` | No |
| Release Notes | — | portrait and landscape | `screens/settings/release_notes_screen.dart:192`, `:298` | No |
| Family Studio, today | landscape | landscape | bottom overflow (3 px at 1.3×, 124 px at 1.6×) | No |
| Labs: Data Detective, Algebra Balance, Fraction Builder, Number Line Explorer | Data Detective in landscape | landscape | bottom overflow (15–45 px) | No |

**These critical screens passed at 1.3× and 1.6× in both orientations:** Home, Topics, Practice, Accessibility settings, Early Maths hub, Panda Portions, Abacus, Create the Angle, Fractions of a Set and Feed the Panda.

**What the probe does not cover:**
- It checks only the first screen of each route. It does not cover practice-session question and answer layouts, mid-activity states, or dialogs.
- The required checks for "no hidden answer options" and "no truncated mathematical expressions" need extra session-level tests.

## 6. Feasibility

**No architectural refactor is needed.** The policy can be implemented in one place, the `main.dart` builder, by replacing `TextScaler.linear` with a small custom `TextScaler` that combines the system scaler with the Reading Size. Flutter 3.41 supports subclassing `TextScaler`. No call sites need to change.

**The real cost is layout hardening.** Honouring Android's setting exposes the 39 overflows above on real devices. Today they are hidden only because the override caps text at 1.15×. Shipping the policy without fixing them would introduce new visible overflow for learners who use large system fonts. Fixing them means local row and column changes (wrapping, `Flexible`, scrolling) in roughly 8 files beyond the critical list:
- the onboarding header and shell;
- Help, Journey, Release Notes and Family Studio "today";
- the older labs' shared landscape layout.

**Proposed policy (implemented as specified; see §7):**

| Android system scale | Small (0.90) | Default (1.00) | Large (1.15) |
|---|---|---|---|
| At or below default (≤ 1.0) | system × 0.90 | system | system × 1.15 |
| Larger than default (> 1.0) | system (not reduced) | system | max(system, 1.15) |

- It is applied per font size. That keeps Android 14+ non-linear curves intact: the system scaler is consulted for each size rather than collapsed to a single factor.
- At the default system setting, behaviour is identical to today: 0.9, 1.0 and 1.15.
- A larger system setting is never reduced by Small or Default.
- There is no multiplication above the default, so effective scaling equals the system setting, up to Android's 2.0×.

**Decision (product owner):** fix all surfaces in this sprint, using local wrap, `Flexible` and scroll changes only, and add the real-router 1.3×/1.6× sweep and practice-session tests.

## 7. New policy (implemented)

`lib/app/reading_size_text_scaler.dart` adds `ReadingSizeTextScaler`, a `TextScaler` subclass, and `readingSizeAppBuilder`. `lib/main.dart` now uses `builder: readingSizeAppBuilder` in place of the inline `TextScaler.linear(textScale)` override.

For each font size `f`, with `system(f)` the Android-provided scaler:

- If `system(f) > f` (Android larger than default), the result is `max(system(f), f × readingSize)`. Small and Default never reduce it, and Large never multiplies it.
- Otherwise (default or smaller), the result is `system(f) × readingSize`.

| Android system scale | Small (0.90) | Default (1.00) | Large (1.15) |
|---|---|---|---|
| 1.0 (default) | 0.90 | 1.00 | 1.15 (identical to before) |
| 0.85 | 0.765 | 0.85 | 0.9775 |
| 1.1 | 1.1 | 1.1 | 1.15 |
| 1.3 | 1.3 | 1.3 | 1.3 |
| 1.6 | 1.6 | 1.6 | 1.6 |
| 2.0 | 2.0 | 2.0 | 2.0 |

- The Reading Size values (0.9 / 1.0 / 1.15), their controls, and the stored `text_scale` preference are unchanged. No setting was added.
- Android 14+ non-linear scaling is preserved, because the system scaler is consulted for each font size.
- Only `TextScaler` APIs are used. The deprecated `textScaleFactor` getter is overridden only because the `TextScaler` interface requires it.
- Value equality (`==`, `hashCode`) means an unchanged setting does not trigger dependent rebuilds.
- The builder listens to `LocalPreferencesService.textScale`, so a new Reading Size applies immediately, as before.
- The local clamps from §1 (card grids, painter labels, badge glyphs) were left as they are.
- Above 1.3× the existing home shell hides the bottom-navigation labels by design (`_navLabelHideTextScaleThreshold` in `home_shell.dart`) and keeps each name in a Tooltip, for long-press and screen readers. Before Gate B this state was unreachable on a device; it is now what a learner at Android ≥ 1.3× sees.

## 8. Layout hardening (changed files)

Every fix keeps the default (1.0×) appearance. The unchanged 1.0× real-router sweep, `polish_audit_overflow_sweep_test.dart`, still passes.

| File | Change |
|---|---|
| `lib/app/reading_size_text_scaler.dart` (new) | Policy and app builder (§7) |
| `lib/main.dart` | Uses `readingSizeAppBuilder` |
| `lib/widgets/onboarding/onboarding_progress_header.dart` | "Step X of Y" / time-estimate row becomes a full-width `Wrap` (space-between) |
| `lib/screens/onboarding/onboarding_shell.dart` | Continue button: fixed 56 px height becomes a 56 px minimum height; label is `Flexible` and centred, so it wraps |
| `lib/screens/settings/help_screen.dart` | Section-card title is `Expanded`, so it wraps |
| `lib/screens/journey/journey_screen.dart` | Achievement badge strip height grows with the effective text scale; daily-goal progress text is width-limited and wraps |
| `lib/screens/settings/release_notes_screen.dart` | Version + badge wrap, date is `Flexible`; build-info label and value are both `Flexible` |
| `lib/widgets/labs/lab_first_use_overlay.dart` | First-use dialog is `scrollable: true`. This fixes Data Detective, Algebra Balance, Fraction Builder and Number Line Explorer in landscape |
| `lib/screens/family_studio/family_today_activity_screen.dart` | Body scrolls when it does not fit; the button stays pinned to the bottom when it does |

No curriculum or question content, TutorBot, Firebase or RevenueCat code changed. No screen was redesigned, and no text was reduced in size to make it fit.

## 9. Tests

| File | Tests | Covers |
|---|---|---|
| `test/system_text_scaling_sweep_test.dart` (new) | 308 | All 77 routes (the 1.0× sweep's routes plus Early Maths hub, Feed the Panda, Panda Portions, Create the Angle, Fractions of a Set) at Android 1.3× and 1.6×, Pixel 6a portrait (412×915) and landscape (844×390), through the real `MaterialApp.router` and the real builder. Asserts the system scale reaches the screen and that there is no overflow or exception |
| `test/reading_size_text_scaler_test.dart` (new) | 26 | Policy matrix (system 0.85 / 1.0 / 1.1 / 1.3 / 1.6 / 2.0 × each Reading Size); non-linear system curve preserved; equality. Real builder: effective scale for every Reading Size at Android 1.0 / 1.3 / 1.6; a change applies immediately. Accessibility screen at 1.6×: each choice is saved unchanged (0.9 / 1.0 / 1.15), the effective scale stays 1.6, and the Gate A selected-state semantics follow; a saved choice is restored. Gate A Abacus Back keeps its "Back" button name at 1.6×. Bottom navigation Home → Topics → Practice → Home at 1.6× with no overflow |
| `test/practice_session_system_text_scaling_test.dart` (new) | 8 | Active practice session with real pack questions, KS2–KS5, portrait and landscape, at Android 1.6×. Every answer option is present, can be scrolled into view and is hit-testable (tappable); Check Answer and Next Question are reachable and work; no question, option or feedback text exceeds its max lines (truncated) before or after checking |
| `test/support/route_sweep_support.dart` (new) | — | Route catalogue and set-up shared between the 1.0× sweep and the new scaling sweep |
| `test/polish_audit_overflow_sweep_test.dart` | unchanged count | Now imports the shared catalogue; its 1.0× behaviour is unchanged |

**Results (host, Flutter 3.41.2), 2026-11-22**

- `flutter analyze`: **no issues found**. `dart format` was applied to the changed files.
- Focused accessibility set (18 files: the Gate A tests, the existing lab and screen accessibility tests, the 1.0× sweep, the three new Gate B files, `practice_session_landscape_test.dart`): **972 passed, 0 failed, 0 skipped**.
- Full host suite, 254 files in 6 batches of up to 50 (the Windows command line cannot take every path at once): **3,123 passed, 0 failed, 0 skipped**. That is Gate A's 2,781 plus 342 new. As in earlier gates, it excludes `practice_screen_continue_learning_resume_test.dart`, which hangs in this environment for reasons that predate and are unrelated to this gate.
- Before the fixes, the probe failed 39 of 288 checks (§5). The final sweep passes 308 of 308 (77 routes × 4; the probe ran a slightly smaller route set).

## 10. Known limitations

- **No device verification.** This gate was host-only by instruction: no Pixel, ADB or TalkBack. Android's real font-size setting, including the non-linear curve, has not been observed on a device; it was simulated with `textScaleFactorTestValue` and a fake non-linear scaler.
- **The sweep checks each route's first screen.** Practice sessions are covered separately (§9). Other mid-activity states and dialogs (lab interactions after the first step, the More sheet, deeper Topic Hub states) are covered only by their existing tests, many of which inject 2.0× directly.
- **Painter labels stay clamped** (Binomial 1.4, Create the Angle 2.0, Pitch Coordinates 0.8 of a grid unit), as do the card grids (1.0–1.6) and the badge glyphs. These limits are intentional and existed before this gate.
- **Hidden bottom-navigation labels above 1.3×** (§7) are existing behaviour, newly reachable on a device. Names remain available through tooltips and screen readers. Whether to keep this is a product choice for later; it was not changed here.
- Open from earlier gates, unchanged: AS-1 (English-only strings on the Accessibility screen, the onboarding step and the 19 lane strings), FU-1, and D-1 (Hub vertical jump).

## 11. Freeze requirement and recommendation

- **Android system scaling is respected:** yes. The system scaler is passed through, is never reduced by Reading Size, and keeps non-linear curves.
- **The 1.6× requirement (`RC1_FEATURE_FREEZE.md` §6) is demonstrated:** yes, on the host. All 77 routes in both orientations, plus KS2–KS5 practice sessions, run at an effective 1.6× through the real app builder with no overflow, hidden options or truncated text.
- **Critical layouts pass:** yes. Onboarding, Home, Topics, Practice, Accessibility settings, Early Maths hub, Panda Portions, Abacus, Create the Angle and Fractions of a Set all pass.
- **Default appearance is preserved:** yes. The default-system effective scale is identical to before (0.9 / 1.0 / 1.15), and the 1.0× sweep and the full suite are green.

**Recommendation: GO** to commit Gate B and take it forward to device acceptance. Before release, a short Pixel 6a check at Android's largest font size, with TalkBack on, is recommended: onboarding, Home, a practice session and one lab. It requires separate authorisation.
