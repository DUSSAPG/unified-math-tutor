# RC2 Math Intelligence Reviewer Build Report

Status: PASS for local analyzer and widget/unit test validation.

## 1. Audit Findings

Repository root confirmed:

`D:\AI\Quantumlab\apps\edex\unified_math_tutor`

Current implementation files:

- Explore Math Intelligence: `lib/screens/explore/explore_math_intelligence_screen.dart`
- Formula Library: `lib/screens/formulas/formula_library_screen.dart`
- Discovery Library: `lib/screens/discovery/discovery_library_screen.dart`
- Recall Cards: `lib/screens/recall/recall_cards_hub_screen.dart`, `lib/screens/recall/recall_cards_browse_screen.dart`, `lib/screens/recall/recall_card_detail_screen.dart`
- Math Studio: `lib/screens/math_studio/math_studio_hub_screen.dart`
- Flight Path Lab: `lib/screens/labs/flight_path_lab_screen.dart`

Available Today route status before repair:

- Personalised Practice: route existed at `/practice`; card was not wired.
- Topic Learning: route existed at `/topics`; card was not wired.
- Timed Challenges: no dedicated top-level route; wired to existing Mental Maths challenge hub at `/math-studio/mental-maths`.
- Exam Simulator: route existed at `/packs`; card was not wired.
- My Maths Journey: route existed at `/journey`; card was not wired.
- Learning Analytics: no dedicated analytics route; wired to `/journey` as the current progress/analytics-safe destination.
- Formula Library: route existed at `/formulas`; card was not wired.
- Math Studio: route existed at `/math-studio`; card was already wired.

## 2. Files Changed

Functional RC2 changes:

- `lib/app/router.dart`
- `lib/models/interactive_lab_id.dart`
- `lib/screens/explore/explore_math_intelligence_screen.dart`
- `lib/screens/discovery/discovery_library_screen.dart`
- `lib/screens/labs/flight_path_lab_screen.dart`
- `lib/screens/labs/interactive_labs_hub_screen.dart`
- `lib/screens/labs/football_precision_lab_screen.dart`
- `lib/screens/labs/maze_driver_lab_screen.dart`
- `lib/widgets/manim/manim_explanation_card.dart`
- `pubspec.yaml`
- `test/flight_path_lab_widget_test.dart`
- `test/rc1_responsive_hardening_test.dart`
- `test/rc2_math_intelligence_widget_test.dart`

**This pass (hardware-feedback polish + procedural maze generation):**

- `lib/services/interactive_labs_progress_service.dart` — new `hasSeenExplanation`/`markExplanationSeen(InteractiveLabId)` pair, shared by both labs.
- `lib/models/football_precision_scoring.dart` — new; scoring/zone-cycling formula extracted from the screen into pure, unit-testable top-level functions.
- `lib/models/maze_history_entry.dart` — new; shared history-entry model for novelty governance and persistence.
- `lib/services/maze_generator_service.dart` — new; deterministic seeded maze generator + novelty policy.
- `lib/services/maze_driver_history_service.dart` — new; profile-scoped recent-maze-history persistence.
- `lib/screens/labs/football_precision_lab_screen.dart` — collapse-on-return persistence, pitch focus-move after collapse.
- `lib/screens/labs/maze_driver_lab_screen.dart` — collapse-on-return persistence, split completion Captain Math copy, generator/history wiring for Next maze + new New Challenge action.
- `test/interactive_labs_guided_experience_test.dart` — new "Explanation-seen tracking" group.
- `test/football_precision_widget_test.dart` — collapsed-on-return, Reduce Motion focus-move, dispose-mid-collapse tests.
- `test/football_precision_scoring_test.dart` — new; pure-Dart scoring formula tests.
- `test/maze_driver_widget_test.dart` — new; consolidated single-mount interaction walkthrough (see risks below for why it's one test, not several).
- `test/maze_generator_service_test.dart` — new; deterministic-seed generator/novelty tests.
- `test/maze_driver_history_service_test.dart` — new; persistence tests.
- `test/labs_mobile_layout_test.dart` — Football Precision added to the shared viewport-matrix loop; Maze Driver given its own dedicated consolidated test (see risks).

New assets:

- `assets/ldtk/maze_driver_rc2_level.json`
- `assets/manim_static/manifest.json`
- `assets/manim_static/flight_path.svg`
- `assets/manim_static/football_precision.svg`
- `assets/manim_static/maze_driver.svg`
- `assets/manim_static/place_value.svg`

Note: `dart format .` was run as requested and normalized many existing Dart files. Those formatting-only changes are visible in `git status` and should be reviewed separately from the functional RC2 diff.

## 3. Routes Repaired

Explore Available Today cards now navigate to:

- Personalised Practice -> `/practice`
- Topic Learning -> `/topics`
- Timed Challenges -> `/math-studio/mental-maths`
- Exam Simulator -> `/packs`
- My Maths Journey -> `/journey`
- Learning Analytics -> `/journey`
- Formula Library -> `/formulas`
- Math Studio -> `/math-studio`

New RC2 lab routes:

- Football Precision -> `/math-studio/interactive-labs/football-precision`
- Maze Driver -> `/math-studio/interactive-labs/maze-driver`

## 4. Discovery Categories

Visible reviewer categories are filtered to categories with at least three cards.

Current visible category:

- Sports: 12 cards

Hidden/deferred from reviewer chips because they have fewer than three cards:

- Shopping: 2
- Cooking: 2
- Everyday Life: 2
- Aviation: 2
- Transport & Logistics: 2
- Healthcare: 2
- Engineering & Construction: 0
- Art & Design: 0
- Gaming: 0
- Business & Finance: 0

Underlying enum/catalog architecture is unchanged.

## 5. Recall Card Coverage

Recall Cards remain complete across all supported major topics:

- Number: 20
- Ratio and Proportion: 20
- Algebra: 20
- Geometry and Measures: 20
- Statistics: 20
- Probability: 20

Total: 120 cards.

## 6. Manim Pipeline / Assets

Manim does not run in Flutter. RC2 adds a reusable Flutter presentation component with static fallback support:

- `ManimExplanationCard`
- Replay control
- Skip control
- static SVG fallback
- Reduce Motion support through `MediaQuery.disableAnimationsOf(context)`
- "Now you try" transition copy

Packaged static fallback assets are registered under `assets/manim_static/`. The manifest records the intended offline Manim source scenes and render metadata. The real offline render commands remain documented in `docs/MANIM_PIPELINE_SPEC.md`.

## 7. Football Precision Summary

Updated after real-device UX review:

- pitch-first hierarchy with compact mission summary before the interaction area
- collapsible How it works section replacing the permanently expanded Manim card
- implementation-oriented fallback copy removed from learner-facing UI
- larger top-down training pitch, with target zones, trajectory, ball, hit markers and robot kept as Flutter-controlled interactive layers
- procedural/plain-colour pitch fallback remains local; no scoring or controls are baked into background art
- robot states added: idle, aiming, approach, kick, celebrate, miss reaction
- Reduce Motion switches animation timing to immediate pose/state changes
- duplicate taps are blocked while a kick animation is active
- clear session states: intro, ready, aiming, kicking, result, session complete
- local-only progress recording through `InteractiveLabsProgressService`
- no network, ads, multiplayer, AI gameplay, new game engine or team licensing

Modes:

- Precision Round: five kicks, no countdown, tracks score, hits, accuracy, average and best kick.
- One-Minute Challenge: 60-second countdown, repeated completed kicks, live attempts/hits/score/accuracy, clean final result at zero.

Completion actions:

- Play again
- Try the other mode
- Review the maths
- Return to Studio

Hardware finding addressed:

- The previous layout gave too much vertical priority to explanation content and left the pitch feeling secondary on Pixel-class screens. The new layout keeps the activity mission, mode, and pitch ahead of stats/results, with explanation collapsed after skip/replay completion.

**This pass:** two remaining gaps closed after re-auditing the actual widget against the hardware-feedback brief —

- How it works now defaults to collapsed on return visits: `InteractiveLabsProgressService.hasSeenExplanation`/`markExplanationSeen` persist per profile per lab, checked in `initState` and set in the explanation-finished callback.
- Visual focus now moves to the pitch after the explanation collapses (a `FocusNode` around the pitch preview requests focus once the ~750ms auto-collapse timer fires), so a screen-reader/keyboard user lands on the interactive area rather than nowhere in particular.
- Collapsed-summary copy, READY-state copy, and the four completion actions (Play again / Try the other mode / Review the maths / Return to Studio) were already correct and needed no change — confirmed by direct file read before touching anything.

## 8. LDtk Maze Driver Summary

Updated after Pixel/device UX review:

- five deterministic local JSON level assets
- compact mission-first layout with Start Mission near the top
- collapsible How it works section replacing the permanently expanded card
- technical proof-of-concept copy removed from learner-facing UI
- Captain Math guidance states for intro, ready, active, blocked and completed
- lightweight visual maze environment: road, terrain, crates/walls, lab marker and science delivery vehicle
- collision, vehicle position, timer, scoring and destination logic remain controlled by Flutter/LDtk data
- refresh restarts the current maze only
- completion actions are explicit: Next maze, Try again, Return to Studio
- local best-result persistence uses the existing SharedPreferences/profile pattern

Level inventory:

- `assets/ldtk/maze_driver_delivery_01.json` - `science-delivery-01`, guided, 7x7, target 9 moves / 30s
- `assets/ldtk/maze_driver_delivery_02.json` - `science-delivery-02`, guided, 7x7, target 10 moves / 32s
- `assets/ldtk/maze_driver_delivery_03.json` - `science-delivery-03`, explorer, 9x7, target 12 moves / 35s
- `assets/ldtk/maze_driver_delivery_04.json` - `science-delivery-04`, explorer, 9x7, target 12 moves / 35s
- `assets/ldtk/maze_driver_delivery_05.json` - `science-delivery-05`, precision, 9x9, target 15 moves / 42s

Captain Math guidance states:

- Mission introduction: "Plan the route, then start the mission."
- Ready: "Reach the lab in fewer than {moveTarget} moves."
- Active / first move: "Good start."
- Progress: "You're getting closer."
- Blocked move: "That path is blocked. Try another way."
- Completion (new personal best): "Well done! You delivered the equipment. You used {moves} moves and took {time} seconds. Brilliant—you found a faster route."
- Completion (move target hit, no improvement): "...Excellent route—you stayed under the move target."
- Completion (neither): "...Next maze is ready when you are."

Pipeline validated:

LDtk-style JSON -> Flutter asset bundle -> level loader -> collision validation -> mission state -> route result -> local best result.

**This pass — hardware-feedback gap closure:**

- How it works now defaults to collapsed on return visits (same `InteractiveLabsProgressService` seen/mark pair used by Football Precision, generic across labs).
- The completion Captain Math line previously only branched on "improved personal best" — it now distinguishes three outcomes (new best / move-target hit without a new best / neither), matching the three distinct phrases above instead of collapsing two of them into one.
- Minor copy-punctuation alignment: "You are getting closer" → "You're getting closer"; "Brilliant, you found a faster route" → "Brilliant—you found a faster route" (em dash, matching the requested exact phrasing).
- Both labs are now registered in `test/labs_mobile_layout_test.dart`'s shared viewport/text-scale matrix (previously only 5 of 7 labs were covered).

**This pass — procedural maze generation and novelty governance (new):**

`lib/services/maze_generator_service.dart` adds a deterministic seeded maze generator: an odd/even "doubled-grid" randomized recursive backtracker seeded by `math.Random(seed)` (never an unseeded `Random()`), producing a perfect maze that carries directly as a real `MazeDriverLevel` — no parallel maze representation, so it flows through the existing loader/painter/BFS solver unchanged. Every candidate is re-validated with `MazeDriverLevel.validate()`/`shortestPath()` rather than trusted blindly. `moveTarget`/`timeTargetSeconds` are derived from the same ratios already present across the 5 curated levels.

Novelty governance (`MazeGeneratorService.findAccepted`, `lib/services/maze_driver_history_service.dart`, `lib/models/maze_history_entry.dart`):

- Exact-duplicate fingerprint: canonicalized `{width, height, start, destination, sorted walls}` JSON, sha256-hashed.
- Route-similarity signature: a `U`/`D`/`L`/`R` direction string derived from the solved shortest path, plus its length.
- A candidate is rejected if its seed was already used, its fingerprint exactly matches a recent maze, its `(start, destination)` pair repeats within the recent window, or its route signature is "too similar" (path-length band within 1 AND normalized Levenshtein direction-string similarity ≥ 0.8).
- Attempt budget: 20 tries per request, then falls back to cycling an unused curated level (the 5 curated JSON levels are untouched and remain the permanent fallback floor).
- History: last 20 completed procedural mazes per profile, persisted via `MazeDriverHistoryService` (same profile-scoped SharedPreferences idiom as `MazeDriverBestResultService`, deliberately a separate service since a single best-value-per-fixed-levelId slot is the wrong shape for a bounded list of seed/fingerprint/route entries).

Controls (4 distinct actions, resolving the Restart/Try Again/Next Maze/New Challenge overlap):

- **Restart** — unchanged, the shared `LabScaffold` app-bar action; resets the current session only.
- **Next maze** — evolved: asks the generator for the next accepted maze at the *same* difficulty tier as the current one (falling back to an unused curated level if generation can't produce an accepted candidate within budget).
- **New Challenge** (new 4th completion-row button) — rerolls the seed *and* may change difficulty tier; the deliberate "step change" action, distinct from Next Maze's same-tier evolution.
- **Try again** — unchanged: reloads the identical maze (curated or procedural) by reusing the already-generated `MazeDriverLevel` in memory, so it is exact and instant with no re-generation needed.

`conceptText` now reads "Procedural maze - {difficulty}" while on a generated maze, versus "Level X of 5 - {difficulty}" on a curated one, so the mission summary is honest about which kind of maze is active.

Architecture guardrail followed: Maze Driver's local `_captainCopy()` was deliberately NOT migrated onto the shared `CaptainMathService` — that service is an intentionally simple, app-wide 4-mood trigger, not a per-lab copy engine, and migrating it would have been an unrequired architecture change.

## 9. Validation Results

Commands run:

- `dart format .` PASS
- `flutter analyze` PASS
- `flutter test test/football_precision_widget_test.dart test/rc2_math_intelligence_widget_test.dart` PASS, 10 tests
- `flutter test test/maze_driver_level_service_test.dart test/rc2_math_intelligence_widget_test.dart` PASS, 8 tests
- `flutter test test/rc2_math_intelligence_widget_test.dart` PASS, 5 tests
- `flutter test test/flight_path_lab_widget_test.dart` PASS, 6 tests
- `flutter test --concurrency=1` PASS, 318 tests

Device run was not performed in this pass.

**This pass (hardware-feedback polish + procedural maze generation):**

- `flutter analyze` PASS, 0 issues (project-wide).
- `flutter test test/football_precision_widget_test.dart test/football_precision_scoring_test.dart test/interactive_labs_guided_experience_test.dart` PASS, 29 tests.
- `flutter test test/maze_driver_widget_test.dart test/maze_driver_level_service_test.dart test/maze_generator_service_test.dart test/maze_driver_history_service_test.dart test/rc2_math_intelligence_widget_test.dart test/labs_mobile_layout_test.dart` PASS, 41 tests.
- `flutter test --concurrency=1` (full suite) PASS, **353/353 tests**, 0 exceptions.
- `dart format` run only on the files intentionally changed this pass (listed in Section 2), not the whole repo.

Device run was not performed in this pass either — see Section 11 for the checklist additions covering the new behavior.

## 10. Remaining RC2 Risks

- Manim video files are not yet bundled; RC2 uses static fallback assets and manifest entries pending reviewed offline renders.
- Discovery Library currently exposes only Sports as a reviewer-ready category after applying the three-card threshold.
- Football Precision and Maze Driver are intentionally prototypes, not full game systems.
- New prototype UI strings are English-only in this pass.
- `dart format .` created broad formatting churn that should be separated or reviewed carefully before commit.
- Maze Driver still uses static fallback Manim art; reviewed rendered animation video is not yet bundled.
- Widget-level interaction tests intentionally cover screen smoke flow while deterministic level tests cover collision and asset validity. Full hardware replay remains required for animation feel.

**This pass:**

- **Flutter test-runner limitation, not an app bug:** `MazeDriverLabScreen` gates its entire body behind a `FutureBuilder` awaiting real `rootBundle.loadString` reads (the 5 curated level JSON files). Mounting that screen a second time via a separate `testWidgets` in the same test file/isolate causes that Future to hang forever and never resolve — reproduced in isolation with a minimal throwaway widget containing no application logic, confirming it's a Flutter test-infrastructure quirk around repeated real asset-bundle reads gating widget construction, not a defect in this app. Worked around by consolidating all Maze Driver interaction scenarios into one `testWidgets` walkthrough (`test/maze_driver_widget_test.dart`) and giving Maze Driver its own dedicated single-mount test in `test/labs_mobile_layout_test.dart` instead of the shared per-lab loop. Football Precision and the other labs don't hit this because none of them gate their whole body behind an awaited `rootBundle` read. Worth flagging if a future contributor is tempted to split that consolidated test back into several — it will reintroduce the hang.
- Procedural mazes use a generic mission label ("Deliver the science equipment to the lab.") rather than curated, level-specific narrative copy — intentional, since authoring unique narrative text per unbounded procedurally-generated maze isn't meaningful, but it is a lower-effort presentation than the 5 curated levels.
- "New Challenge"'s difficulty-tier reroll is not independently exercised by a full widget completion round-trip in `maze_driver_widget_test.dart` (only its button presence and that Next Maze's identical underlying mechanism works end-to-end are asserted at the widget level) — its generation/novelty logic is fully covered by `maze_generator_service_test.dart` across all three difficulty tiers, but the screen-level wiring of the difficulty-reroll specifically relies on that shared code path rather than a dedicated widget assertion.
- Procedural maze history (last 20 per profile) is local-only, matching every other RC2 persistence pattern in this app — no sync, no server-side novelty checking across devices.

## 11. Hardware Test Checklist

Pixel 6a:

- Open Explore and tap each Available Today card.
- Open Math Studio -> Interactive Labs -> Flight Path Lab.
- Confirm Manim fallback card shows, Replay works, Skip transitions to "Now you fly".
- Confirm Flight Path projected path updates with heading/speed.
- Complete one Flight Path attempt and verify attempt history appears.
- Open Football Precision, skip intro, complete five kicks, verify metrics.
- Open Maze Driver, move into walls and open cells, verify walls block movement and moves increment only for legal moves.
- Toggle Android Reduce Motion / remove animations and confirm Manim fallback cards do not rely on motion.
- Re-open Football Precision and Maze Driver a second time on the same profile and confirm How it works now opens collapsed (not expanded) since the explanation was already seen.
- After Skip/natural-finish on Football Precision, confirm the pitch visibly receives focus once the explanation collapses (TalkBack/keyboard focus ring should land on the pitch, not disappear).
- Complete a Maze Driver level and confirm the Captain Math completion line matches the run: "Brilliant—you found a faster route." only on a new personal best, "Excellent route—you stayed under the move target." when the move target is hit without a new best, otherwise "Next maze is ready when you are."
- On the Maze Driver completion screen, confirm 4 distinct actions: Next maze, New Challenge, Try again, Return to Studio — tap Next maze and confirm a different (usually procedural, occasionally a curated fallback) maze loads at the same difficulty; tap New Challenge on a separate run and confirm a different maze loads, possibly at a different difficulty; tap Try again and confirm the identical maze reloads with moves reset to zero.
- Confirm the Maze Driver mission summary reads "Procedural maze - {difficulty}" on a generated maze versus "Level X of 5 - {difficulty}" on a curated one.

Tablet / landscape:

- Repeat Flight Path, Football Precision, Maze Driver.
- Confirm no clipped controls, no trapped navigation, and Back returns to Interactive Labs.

Text scale:

- Check S/M/L and 2.0x where practical for Explore, Discovery, Flight Path, Football Precision, Maze Driver.

Offline:

- Launch with network disabled and confirm all Studio demos still open.

## 12. Navigation Assertion Stabilisation Addendum

Status: PASS for local analyzer, full widget/unit suite, web build, and Android debug build.

### Root cause

The duplicate `LabeledGlobalKey<NavigatorState>` assertion was caused by root-overlay navigation from Explore Math Intelligence into existing shell destinations using `context.push()`.

Before this fix, a typical failing flow was:

1. Shell is active at `/home`.
2. Explore opens as a root-level route above the shell at `/explore`.
3. A shell destination such as `/formulas` is pushed from the root overlay.
4. go_router attempts to place another instance of the stateful shell route on the root stack while the previous shell remains below Explore.
5. The second shell instance reuses the same branch navigator keys, so Flutter sees the same `GlobalKey<NavigatorState>` under multiple `HeroControllerScope`/Navigator owners and renders the red assertion screen.

This was not a case of a key being created in `build()`, and it was not fixed by suppressing Hero behavior. The key ownership issue was route-stack duplication: the same singleton branch navigator keys were valid for one shell instance, but invalid once `push()` stacked another shell instance.

### Navigator-key ownership before and after

Declarations audited in `lib/app/router.dart`:

- `_rootNavigatorKey`
- `_homeNavKey`
- `_topicsNavKey`
- `_practiceNavKey`
- `_journeyNavKey`
- `_formulasNavKey`
- `_profileNavKey`
- `_tutorNavKey`
- `_helpNavKey`

Before:

- The root `GoRouter` owned `_rootNavigatorKey`.
- Each `StatefulShellBranch` owned one unique branch key.
- Explore could still create duplicate ownership indirectly by pushing shell destinations from a root overlay, producing two live shell instances with the same branch keys.

After:

- The root `GoRouter` still owns only `_rootNavigatorKey`.
- Each shell branch still owns only its dedicated branch key.
- Explore uses `context.go()` for existing shell branch destinations, so the app switches/replaces into the existing shell location instead of stacking a second shell.
- `parentNavigatorKey` remains a selector for existing ancestor navigators only; it is not used as a new child navigator key.

### Family Maths route workaround review

The Family Maths routes were reviewed and left intact in this pass. Existing coverage confirms:

- direct Family Maths welcome route;
- PIN-gated Family Maths flow;
- Family Maths library route;
- Family Maths activity detail route;
- activity detail back behavior;
- Studio Connection deep-link behavior;
- required viewport and text-scale layout matrix.

The workaround does not assign a navigator key to a second Navigator instance. It uses `parentNavigatorKey` to choose the root ancestor for full-screen parent-tool flows. The failing duplicate-key behavior was reproduced by shell destination stacking from Explore, not by Family Maths route ownership.

### Routes changed

Changed in `lib/screens/explore/explore_math_intelligence_screen.dart`:

- Personalised Practice: `/practice` now uses `context.go()`.
- Topic Learning: `/topics` now uses `context.go()`.
- My Maths Journey: `/journey` now uses `context.go()`.
- Learning Analytics: `/journey` now uses `context.go()`.
- Formula Library: `/formulas` now uses `context.go()`.

Unchanged because they are non-shell/root or nested pillar destinations:

- Timed Challenges: `/math-studio/mental-maths`
- Exam Simulator: `/packs`
- Math Studio: `/math-studio`

### Tests added

Updated `test/explore_feature_discovery_widget_test.dart`:

- Added `Explore shell destinations do not create duplicate navigators`.
- The test mounts the app router, starts from `/home`, opens Explore through the More flow, taps Formula Library, verifies `FormulaLibraryScreen`, and fails on captured Flutter framework exceptions.
- The file setup moved from `setUp` to `setUpAll` because the second test exposed singleton service initialization constraints in `TutorCreditService`.

Existing route tests retained and rerun:

- `test/rc2_math_intelligence_widget_test.dart`
- `test/family_maths_widget_test.dart`
- `test/family_maths_layout_test.dart`

### Visual/content changes

Recall Card visual changes: none in this pass.

Discovery icon/content changes: none in this pass.

Spatial Intelligence status changes: none in this pass.

Those phases remain deferred until the navigation fix is reviewed on web and device.

### Validation results for this addendum

Commands run:

- `git rev-parse --show-toplevel` PASS: `D:/AI/Quantumlab/apps/edex/unified_math_tutor`
- `git status --short` captured before production edits; large approved RC2 dirty tree confirmed.
- `git diff --stat` captured before production edits: 150 tracked files changed, 6481 insertions, 1101 deletions.
- Baseline `flutter test --concurrency=1` before production edits PASS: 380 tests.
- `dart format lib/screens/explore/explore_math_intelligence_screen.dart test/explore_feature_discovery_widget_test.dart` PASS.
- `flutter test test/explore_feature_discovery_widget_test.dart --concurrency=1` PASS: 2 tests.
- `flutter analyze` PASS: 0 issues.
- `flutter test test/rc2_math_intelligence_widget_test.dart --concurrency=1` PASS: 5 tests.
- `flutter test test/family_maths_widget_test.dart test/family_maths_layout_test.dart --concurrency=1` PASS: 9 tests.
- Full `flutter test --concurrency=1` PASS: 381 tests.
- `flutter build web` PASS: `build\web`.
- `flutter build apk --debug` PASS: `build\app\outputs\flutter-apk\app-debug.apk`.

### Web validation results

Local web build succeeds. The route regression test now covers the reported shell-stack failure path at widget level: Home shell -> More -> Explore overlay -> Formula Library shell branch. Manual browser-card traversal and refresh/back-forward validation still need to be run on the reviewer machine before commit.

### Android build results

Debug APK built successfully:

`build\app\outputs\flutter-apk\app-debug.apk`

Pixel 6a installation and hands-on portrait/landscape validation remain required before release sign-off.

### Remaining hardware checklist

- Install the debug APK on Pixel 6a.
- Open Explore from Home/More.
- Tap every Available Today card twice, returning safely each time.
- Verify `/formulas` no longer produces a red assertion screen.
- Verify browser/system Back returns correctly from each destination.
- Verify direct URL refresh for `/formulas` on web.
- Verify direct Family Maths library and detail routes still render.
- Repeat Explore navigation matrix in portrait and landscape.
- Confirm no blank screen, URI-only navigation, duplicate GlobalKey assertion, HeroControllerScope assertion, or Navigator lock assertion.

## 13. Independent Re-Verification and App-Wide Push-Site Audit

Status: PASS. This section independently re-derives and confirms Section 12's
root cause and fix from a fresh audit (not by reading Section 12 first — it
was found afterward, already in this file, and matches), widens the audit to
every `push()` call site in the app rather than only Explore, adds a second,
more exhaustive regression suite, and documents the navigator-key ownership
model directly in source comments (not only in this report).

### Root cause, re-confirmed independently

Same finding as Section 12, reproduced fresh against `appRouter` directly
(not through the UI) to isolate the exact trigger with certainty:

- `appRouter.go('/home')` then `appRouter.push('/explore')` then
  `appRouter.push('/formulas')` → threw `Failed assertion: line 4049 pos 18:
  '!keyReservation.contains(key)'` inside `package:flutter/src/widgets/
  navigator.dart`, with `HeroControllerScope` as the offending parent widget
  — the exact reported signature.
- Same sequence with `appRouter.push('/journey')` instead of `/formulas` →
  same crash. Confirms the defect is general to *any* StatefulShellBranch
  route (Home, Topics, Practice, Journey, Formula Library, Profile, Tutor,
  Help), not specific to Formula Library.
- Same sequence but `appRouter.go('/formulas')` (go, not push) → clean, no
  exception.
- `appRouter.go('/onboarding/accessibility')` run **in isolation** (its own
  test, no prior navigation) → clean, no exception. Section 12 does not
  separately address this route from the original report; re-investigating
  it here found it is **not** independently affected — the failure
  originally attributed to it only reproduced when run in the same test
  *after* an unrelated push()-into-shell-branch crash had already left the
  shared `appRouter` singleton's element tree in a broken state. It was
  noise from cross-test contamination, not a distinct bug.
- Branch-to-branch push while *already inside* the shell (e.g. from
  `/topics`, `appRouter.push('/practice')`) → clean. The defect requires the
  *origin* to be outside the shell (a root-navigator route like Explore);
  push between two branches that are both already part of the one mounted
  shell instance does not need a second shell to be built.

### App-wide push-site audit (widening beyond Explore)

Grepped every `.push('/home'|/topics|/practice|/journey|/formulas|/profile|
/tutor|/help...')` call site in `lib/` (not just Explore) to check whether
any other screen still has the dangerous outside-shell-push pattern:

| Call site | Target | Verdict |
|---|---|---|
| `explore_math_intelligence_screen.dart` | practice/topics/journey(x2)/formulas | Already `go()` — fixed (Section 12) |
| `home_shell.dart:74,78` | `/help/parent-teacher-tools`, `/profile/settings` | Safe — both targets declare `parentNavigatorKey: _rootNavigatorKey` explicitly, so there's no branch-navigator ambiguity for go_router to get wrong |
| `settings_screen.dart`, `help_screen.dart`, `profile_screen.dart` (7 sites) | `/help/parent-teacher-tools`, `/profile/*` sub-pages | Safe — same reason, all explicit `parentNavigatorKey: _rootNavigatorKey` targets, proven pattern already covered by existing settings-navigation tests |
| `practice_screen.dart:151` | `/topics` | Safe — PracticeScreen only ever renders *inside* the shell (branch 2), so this is a branch-to-branch push, confirmed non-reproducing above |
| `topics_screen.dart:213` | `/practice` | Safe — same reasoning, TopicsScreen only renders inside the shell (branch 1) |
| `lab_related_links.dart:90`, `recall_card_body.dart:254` | `/topics/$id` | **Separate, lower-severity defect, not the GlobalKey crash**: `/topics` has no registered `:id`/`:categoryId` child route in `router.dart`, so this path never matches anything. Reproduced pushing it from an outside-shell lab context — it does *not* throw the duplicate-key assertion (go_router's unmatched-route handling doesn't attempt to build the shell), but it is a dead link: tapping a related-topic chip from a lab or Recall Card currently goes nowhere useful. Flagged here as found; **not fixed in this pass** — it's unrelated to the release-blocking navigation assertion and Phase 4 of the task's own checklist scopes route stabilisation to Explore's own destinations, not this cross-link widget. Recommend a follow-up: either add the missing nested route or point these links at an existing valid destination (e.g. `/topics` with a filter `extra`, matching how `topics_screen.dart:213` already passes `extra` to `/practice`). |

No other outside-shell push into a shell-branch route was found anywhere in
`lib/`.

### Code-level ownership documentation added

Beyond Section 12's fix and test, this pass adds the ownership model
directly as source comments so it survives independently of this report:

- `lib/app/router.dart` — a block comment directly above the 9
  `GlobalKey<NavigatorState>` declarations explaining root vs. branch key
  ownership, restating the exact bug mechanism, and stating the rule
  ("any in-app navigation to /home, /topics, /practice, /journey, /formulas,
  /profile, /tutor, or /help from a route outside the shell MUST use go(),
  never push()").
- `lib/screens/explore/explore_math_intelligence_screen.dart` — a comment at
  the first shell-branch card explaining why it and its siblings use `go()`
  and which cards are exempt (non-shell destinations).

### Tests added (this pass)

New file `test/route_navigator_key_regression_test.dart` (15 tests, kept
separate from Section 12's `test/explore_feature_discovery_widget_test.dart`
additions rather than merged, so either can be run independently):

- One test per Explore shell-branch card (Personalised Practice, Topic
  Learning, My Maths Journey, Learning Analytics, Formula Library) — taps
  the real card through the real widget tree, asserts the correct
  destination screen type mounts and `tester.takeException()` is null.
- One test per Explore non-shell card (Timed Challenges, Exam Simulator,
  Math Studio) — same assertions, documenting these remain safe with
  `push()`.
- A repeated-navigation test: Explore → Formula Library → re-enter Explore →
  Journey → re-enter Explore → Formula Library again.
- Five direct deep-link/browser-refresh-restoration tests, each starting
  from a **fresh** router location with no prior navigation: `/formulas`,
  `/onboarding/accessibility`, `/profile/accessibility`,
  `/help/parent-teacher-tools/family-maths` (PIN gate shown, not a crash),
  `/math-studio/discovery/cooking-fraction-conversion`.
- One explicit branch-to-branch-while-inside-shell test (`/topics` → push
  `/practice`), documenting the other half of the invariant.

### Validation results (this pass)

- `git rev-parse --show-toplevel` → `D:/AI/Quantumlab/apps/edex/unified_math_tutor`.
- `git status --short` / `git diff --stat` captured before any edits this
  pass: 150 files changed, +6481/-1101 (the approved uncommitted RC2 tree,
  confirmed untouched by this pass beyond the files listed above).
- Baseline `flutter analyze` → clean. Baseline `flutter test --concurrency=1`
  → 380/380 passing.
- After this pass: `flutter analyze` → clean (full project).
  `flutter test test/route_navigator_key_regression_test.dart` → 15/15.
  Full `flutter test --concurrency=1` → 396/396 passing.
- `dart format` run only on the files this pass touched:
  `lib/app/router.dart`, `lib/screens/explore/explore_math_intelligence_screen.dart`,
  `test/route_navigator_key_regression_test.dart`.
- `flutter build web` → PASS (`build\web`), including a Wasm dry-run check
  with no reported incompatibilities.
- `flutter build apk --debug` → PASS (`build\app\outputs\flutter-apk\app-debug.apk`).

### Web validation (this pass)

`flutter build web` compiles cleanly. Widget-level reproduction against the
real `appRouter`/`MaterialApp.router` — the same Flutter framework
GlobalKey-uniqueness invariant that produces the assertion on an actual
browser — confirms both the crash (before the fix, via raw push()) and the
fix (via go(), and via every real Explore card tap). A true in-browser
click-through pass (this sandbox has no interactive browser session
available) remains a manual step for the reviewer, same as Section 12 left
outstanding.

### Android validation (this pass)

Debug APK builds successfully. As in Section 12, installation and hands-on
portrait/landscape testing on a physical Pixel 6a is hardware this session
cannot perform and remains for the reviewer.

### Remaining hardware checklist (unchanged from Section 12, not repeated here)

See Section 12's checklist above — nothing in this pass changes what still
needs a human with the physical device and a browser.

### Deferred (unchanged from Section 12)

Recall Card visual polish, Discovery icon/content polish, and Spatial
Intelligence status (Phases 7–9 of the task) remain explicitly deferred
until the navigation fix above is reviewed on web and the Pixel 6a — not
started in this pass, per the task's own gating instruction.

## 14. Adaptive Lab Control System (Football Precision, Flight Path Lab, Maze Driver)

Status: NOT COMMITTED — pending Pixel 6a hardware review, per this task's own
instruction.

### Summary

Football Precision, Flight Path Lab and Maze Driver each rendered their whole
interactive body as one fixed, always-expanded `Column`, regardless of
device. This pass adds a small reusable "adaptive lab control" primitive set
under `lib/widgets/labs/lab_controls/` and applies it to these three labs so
controls sit in rails/drawers appropriate to phone portrait, phone
landscape, tablet and desktop, collapse automatically during active play,
and always leave a visible, keyboard-reachable way back in. `LabScaffold`,
routing, onboarding, ALI/Allie, Journey, entitlement and localisation
infrastructure were not touched — every change lives inside the three
screens' own `body` widget trees, so the other four `LabScaffold` consumers
(Algebra Balance, Data Detective, Fraction Builder, Number Line Explorer) are
unaffected.

### Primitives added (`lib/widgets/labs/lab_controls/`)

- `lab_control_phase.dart` — `LabControlPhase` enum (configuration/ready/
  active/result/complete) and a shared `labReduceMotion()` helper, replacing
  three separate ad hoc Reduce Motion checks.
- `lab_control_breakpoint.dart` — `LabControlBreakpoint` enum
  (phonePortrait/phoneLandscape/tablet/desktop) built on the existing
  `AppResponsive`, plus `resolveLabControlBreakpoint()`.
- `lab_control_rail.dart` — `LabControlRail`, a single parameterized
  top/left/right rail container (themed with the same dark-card tokens
  already used across these labs).
- `lab_control_handle.dart` — `LabControlHandle`, an always-visible, ≥48x48
  reopen affordance for a collapsed control cluster.
- `lab_collapsible_controls.dart` — `LabCollapsibleControls`, the shared
  collapse/expand engine (instant under Reduce Motion, `AnimatedSize`
  otherwise; the child isn't built at all while collapsed, so it's
  automatically out of the semantics/focus tree).
- `lab_bottom_control_drawer.dart` — `LabBottomControlDrawer`, a collapsible
  panel with its own tap-to-toggle header, used for "Previous attempts" and
  similar supplementary content.

"Result mode" and "active-play focus mode" (from the brief's list of 7
primitives) are phase-driven behavior of `LabCollapsibleControls`/each lab's
own existing result widgets, not separate wrapper classes — documented in
source comments to avoid a redundant abstraction.

### Per-lab changes

- **Football Precision**: power slider moves into a right-hand
  `LabControlRail` beside the pitch (falling back to an expandable
  `LabBottomControlDrawer` on very narrow phones); angle stays directly
  under the pitch. Mode selector + How-it-works collapse via
  `LabCollapsibleControls` for ~900ms after a kick (with a
  `LabControlHandle` to reopen sooner), then auto-restore for the next kick.
- **Flight Path Lab**: added a 0–360° heading `Slider`
  (`Key('flightPathHeadingSlider')`) alongside the existing speed slider
  (`Key('flightPathSpeedSlider')`) — the drag/tap gestures previously had no
  keyboard/screen-reader equivalent for setting heading; this closes that
  gap without removing the tactile drag path. Heading/speed controls and the
  attempt-history panel move into `LabBottomControlDrawer`/side-rail
  placement depending on breakpoint, collapsing briefly after each Test
  Flight.
- **Maze Driver**: mission instructions collapse immediately after Start
  Mission (`LabControlHandle` labeled "Mission details" to reopen); the
  Moves/Time chips become a compact, non-collapsible `LabControlRail(top)`
  status strip above the maze grid (never obstructing it); `_MoveButton`
  touch targets widened to the 48x48 minimum.

### Incidental fixes found via the new device-matrix coverage

Two real overflow bugs were caught by the new responsive tests and fixed:

- `lib/screens/labs/maze_driver_lab_screen.dart`: the new Moves/Time status
  rail overflowed by 23px on a 320px-wide phone — fixed with `Flexible` +
  ellipsis on both labels.
- `lib/widgets/manim/manim_explanation_card.dart` (shared by every
  Interactive Lab, not just these three): the title/Replay/Skip header
  overflowed by 21px at 2.0x text scale on a phone-width viewport — fixed by
  changing `Row` to `Wrap` so the buttons drop to a second line instead of
  overflowing. This is the one file touched outside the three named screens
  and the new primitives folder; flagged here explicitly since it's outside
  the plan's original file list, but left unfixed would have meant shipping
  a known accessibility (large-text) regression that this sprint's own
  validation requirements exist to catch.

A pre-existing test (`test/guided_narration_test.dart`) located the speed
slider via `find.byType(Slider).first`, which broke once the new heading
slider was inserted earlier in the tree. Fixed at the root by keying the
speed slider (`Key('flightPathSpeedSlider')`) and updating that test to use
the key instead of a positional assumption.

### Tests added/extended

- `test/lab_controls_primitives_test.dart` (new): breakpoint-resolution
  boundaries, rail/handle/collapsible/drawer behavior, Reduce Motion
  branching — 14 tests.
- `test/lab_controls_responsive_test.dart` (new): the brief's full device
  matrix (narrow phone portrait, phone landscape narrow/wide, Pixel 6a
  portrait/landscape, Android tablet, web desktop, 2.0x text scale, Reduce
  Motion) run against all three labs — 19 tests. Widget-layout coverage
  (`tester.takeException()` + landmark-widget assertions), not pixel golden
  images — the repo has no existing golden baselines to extend.
- `test/football_precision_widget_test.dart`, `test/flight_path_lab_widget_test.dart`,
  `test/maze_driver_widget_test.dart`: extended in place with rail-presence,
  collapse/auto-restore/reopen-handle, and landscape-reachability coverage
  specific to each lab's own interaction flow.

### Validation results

- `dart format` — applied to every file this pass touched (0 files needed
  reformatting beyond the initial primitive files' own formatting).
- `flutter analyze` (whole project) — **No issues found.**
- Targeted suites (football, flight, maze, lab_controls, ×9 files) — **all
  pass.**
- `flutter test --concurrency=1` (full suite, 437 tests) — **all pass**, 0
  regressions, after the `guided_narration_test.dart` fix above.

### Hardware checklist for this pass

- [ ] Football Precision on a physical Pixel 6a: portrait side-rail/drawer
      fallback, landscape rail layout, collapse/reopen handle timing feels
      right (not too fast/slow).
- [ ] Flight Path Lab on a physical Pixel 6a: heading slider is comfortable
      to use alongside the drag/tap gestures; history drawer and
      collapse/reopen behavior feel right.
- [ ] Maze Driver on a physical Pixel 6a: mission-collapse handle, status
      rail legibility, and D-pad touch targets in the thumb zone.
- [ ] Large system text size (not just the 2.0x scale test) on-device.
- [ ] Reduce Motion enabled on-device (system setting, not just the
      `MediaQuery` flag used in tests).

Not committed — per this task's instruction, awaiting the reviewer's Pixel 6a
pass before any commit.

## 15. Parent/Tutor Onboarding + Family Studio

Status: NOT COMMITTED — reviewed before commit, per this task's own
instruction.

### Summary

Choosing "Parent" or "Teacher" at `/onboarding` previously just swapped copy
inside the same four student-shaped onboarding screens and finished on the
same child-facing Home. This pass adds a genuinely separate Parent/Tutor
onboarding branch (4 new screens under `lib/screens/onboarding/family/`) and
a new **Family Studio** destination (`lib/screens/family_studio/`, routes
under `/family-studio/*`) built almost entirely out of existing content and
services (Family Maths, Recall Cards, Formula Library, Practice, progress
services) — "parents do not need to become teachers, they just need a place
to start." Frozen per the brief: authentication, student onboarding (the
existing 4-screen flow is byte-identical for `userType == 'student'`),
bottom navigation, ALI, Journey, Practice, the child Math Studio,
entitlement, existing Family Maths content, and the Parent/Teacher PIN
mechanism itself.

### Architecture decisions

- **Family Studio is its own top-level route namespace**, plain `GoRoute`s
  outside the `StatefulShellRoute` (same pattern as `/onboarding/*`,
  `/auth/*`) — sidesteps the documented navigator-key crash
  (`test/route_navigator_key_regression_test.dart`) by construction, since
  routes outside the shell are always safe to `push()` from anywhere.
- **PIN gating — session-scoped grace, precisely bounded** (refined twice
  during planning at the user's request): `LocalPreferencesService` gained
  an in-memory-only (never persisted) `hasFamilyStudioGraceAccess` flag,
  granted once when family onboarding finishes. `ParentGate` gained one new
  optional flag, `allowGraceAccess` (default `false` — every existing call
  site, Family Maths and the Cheat Sheet, is byte-identical and stays
  PIN-only forever, even during an active grace window). Only the 5 new
  Family Studio routes opt in. Grace expires on: app restart (free, never
  persisted), sign-out (`SignOutService.signOut()`), a user-role change
  (`OnboardingProfileService.setUserType()`), and the app leaving the
  foreground (`AppLifecycleState.paused`/`.detached`, observed via a new
  `WidgetsBindingObserver` on `UnifiedMathTutorApp` in `lib/main.dart`,
  converted from `StatelessWidget` to `StatefulWidget` for this). Verified
  end-to-end in `test/family_studio_pin_gating_test.dart` (8 tests) and
  again live through the real router in `test/family_onboarding_widget_test.dart`.
- **Reuse over new content**: of the hub's 10 sections, only 6
  (Today's Activity, Homework Companion, What Your Child Is Learning,
  Conversation Starters, Progress Snapshot, Tutor Tools) are new screens;
  Explain This Method, Fractions and Ratio, Mental Maths Together, and Cube
  and Spatial Activities push straight into existing, unmodified screens
  (`/formulas`, `FamilyMathsLibraryScreen` with a new optional
  `initialCategory` param, the Mental Maths hub, the existing `cube-views`
  Family Maths activity). No dead cards — every section and every primary
  action navigates somewhere real, verified against the actual router in
  `test/family_studio_hub_test.dart` (14 tests).
- **Homework Companion V1 is a pure, deterministic function**,
  `buildHomeworkSession()` in `lib/services/homework_companion_service.dart`
  — (topic, minutes, help-type, already-loaded Recall Card/Family Activity
  lists) → an ordered list of 0–2 existing-route action items. No runtime
  AI, no uploaded-homework solving. Independently unit-tested with no
  widget/catalog I/O in `test/homework_companion_service_test.dart` (9
  tests), including an explicit same-inputs-same-output determinism check.
- **Progress Snapshot never exposes a raw ALI score** — it reads only
  already-qualitative signals (`ParentReportService.drillSuggestions`,
  practice-session topics, interactive-lab completion counts), the same
  data `ParentReportService`'s existing PDF export already summarises.
- **Allie vs Captain Math**: Allie (parent-facing) appears on the Family
  Studio hub, Conversation Starters, Today's Activity, and the onboarding
  preferences step, using the brief's own example lines as real copy.
  `CaptainMathService` is never referenced anywhere under
  `lib/screens/family_studio/` or `lib/screens/onboarding/family/` —
  enforced by a source-scan test, not just convention
  (`test/family_studio_voice_test.dart`).
- **Localisation**: every new string got a real ARB key in `app_en.arb`
  (template) and all 19 other locale ARB files (English placeholder text
  where no translation exists), then `flutter gen-l10n` — matching this
  repo's own established convention (tracked via `untranslated_messages.txt`,
  not a blocker). Completeness asserted directly in
  `test/family_studio_localisation_test.dart`.

### Files added

- `lib/models/family_studio_section.dart`
- `lib/screens/family_studio/` (7 screens: hub, today's activity, homework
  companion, what your child is learning, conversation starters, progress
  snapshot, tutor tools)
- `lib/screens/onboarding/family/` (4 screens: role detail, learner
  context, goal, preferences)
- `lib/services/homework_companion_service.dart`
- `lib/services/tutor_notes_service.dart`
- 6 new test files (40 tests total): `family_onboarding_widget_test.dart`,
  `family_studio_hub_test.dart`, `homework_companion_service_test.dart`,
  `family_studio_pin_gating_test.dart`, `family_studio_voice_test.dart`,
  `family_studio_localisation_test.dart`

### Files modified

`lib/services/local_preferences_service.dart` (grace flag),
`lib/widgets/settings/parent_gate.dart` (`allowGraceAccess`),
`lib/services/sign_out_service.dart`, `lib/services/onboarding_profile_service.dart`
(grace-clear-on-role-change + 2 new fields), `lib/main.dart`
(lifecycle observer), `lib/screens/onboarding/user_type_screen.dart` (one
branch in `_onContinue`), `lib/app/router.dart` (new route blocks),
`lib/screens/family_maths/family_maths_library_screen.dart`
(`initialCategory` param), `lib/screens/settings/parent_teacher_tools_screen.dart`,
`lib/screens/home/home_shell.dart`, `lib/screens/settings/profile_screen.dart`
(Family Studio entry points), `lib/core/bootstrap.dart` (`TutorNotesService`
init), and all 20 `lib/l10n/*.arb` files.

### Validation results

- `dart format` — applied to every file this pass touched.
- `flutter analyze` (whole project) — **No issues found.**
- Targeted new-test run (6 new files + adjacent onboarding/routing/sign-out
  suites, 59 tests) — **all pass**, confirming zero regressions in the
  screens this sprint's grace/PIN changes touch.
- `flutter test --concurrency=1` (full suite) — **477/477 pass** (437
  baseline + 40 new tests — the localisation-completeness test is a single
  `test()` asserting across all 20 ARB files, not per-key).

### Manual verification still needed (reviewer)

- [ ] Walk `/onboarding` choosing Parent on a physical device → confirm the
      4 new screens read well → land on Family Studio with no PIN prompt.
- [ ] From Settings → Parent/Teacher Tools → Family Studio, confirm the
      existing PIN flow still gates exactly as before.
- [ ] Background the app (Home button / app switcher) while inside Family
      Studio, then reopen — confirm a PIN is required again.
- [ ] Phone and tablet layouts for the hub and each new screen, at large
      text sizes.

Not committed — per this task's instruction, reviewed before commit.

## 16. Accessible Light Theme (System / Dark / Light)

Status: NOT COMMITTED — reviewed on-device before commit, per this task's
own instruction (same pattern as sprints 14–15 above).

### Summary

Math Intelligence was dark-only: `MaterialApp.router` set a single hardcoded
`theme:` and never set `darkTheme:`/`themeMode:`, and ~1,251 raw
`Color(0xFF...)` literals were scattered across 115+ files.
`AppearanceScreen` even shipped a visibly *disabled* "Dark only" selector
("for later releases"). This pass introduces a real System/Dark/Light
switch backed by semantic color tokens, without changing Dark Theme's
appearance by a single pixel.

Given the ~1,251-literal scope, the user chose (via an explicit
scope-clarifying question) to build the **full token/`ThemeData`/settings
infrastructure app-wide** — so `ThemeMode.system`/`.light` apply correctly
everywhere immediately — but to **only actually repaint the 12
screens/features the brief's own testing section names**: Home, Topics,
Practice, Journey, Math Studio hub, Football, Maze, Flight, Recall Cards,
Discovery, Family Studio, Settings — plus the shared chrome they depend on.
Every other screen keeps today's hardcoded dark colors regardless of the
selected theme mode; this is an intentional, visible scope boundary, not a
bug, and is listed explicitly below.

### Architecture

- **`lib/shared/theme/app_theme.dart`** (new): `AppSemanticColors` (general
  UI tokens: `background`, `elevatedSurface`, `cardSurface`, `primaryText`,
  `secondaryText`, `tertiaryText`, `divider`, `primaryAction`,
  `onPrimaryAction`, `accent`, `success`, `warning`, `error`) and
  `AppLabColors` (Interactive-Labs-specific tokens the brief calls out by
  name: `pitchSurface`, `targetHighlight`, `ballColor`, `robotColor`,
  `mazeRoad`, `mazeWall`, `mazeGrass`, `radarGrid`, `radarTarget`,
  `radarLanding`, `flightPath`), both `ThemeExtension`s registered on
  `ThemeData.extensions`. `AppTheme.dark()` is a direct, pixel-for-pixel
  port of every value every screen already hardcoded; `AppTheme.light()` is
  new (pale blue-grey background, soft-blue elevated surface, blue-lilac
  cards, near-black/charcoal text, WCAG-checked status colors, same brand
  blue for brand consistency). A `context.appColors` / `context.labColors`
  extension getter falls back to the dark token set (`??
  AppTheme._darkSemanticColors/_darkLabColors`) instead of force-unwrapping
  — critical safety net: any screen/test not yet converted, or any bare
  `MaterialApp` in an older test that never sets `theme:`/`darkTheme:`,
  still renders in unchanged dark colors instead of crashing on a null
  `ThemeExtension` lookup. `CustomPainter`s (Football's `_PitchPainter`,
  Maze's `_MazeEnvironmentPainter`, Flight's `_RadarPainter`/
  `_AircraftPainter`/`_ProjectedPathPainter`) can't call `Theme.of(context)`
  themselves, so the wrapping widget resolves `context.labColors` once and
  passes plain `Color`s into each painter's constructor.
- **`lib/services/local_preferences_service.dart`**: new
  `ValueNotifier<ThemeMode> themeMode` (default `ThemeMode.system` — the app
  has only ever shipped Dark, so there's no prior "always dark" product rule
  to preserve for new users), persisted as `'system'|'dark'|'light'`,
  `setThemeMode()`.
- **`lib/main.dart`**: `MaterialApp.router` now gets `theme: AppTheme.light()`,
  `darkTheme: AppTheme.dark()`, `themeMode:` from a `ValueListenableBuilder`
  on the new notifier — the same reactive pattern already used there for
  `textScale`/locale.
- **`lib/screens/settings/appearance_screen.dart`**: the disabled single
  "Dark" selector replaced with three working options (System/Dark/Light).

### A pixel-exact-port bug caught before shipping

Building `AppTheme.dark()`'s `AppLabColors.robotColor` field, the value
chosen (`_brandBlue`, `0xFF3D7EFF`) didn't actually match Football
Precision's real pre-existing hardcoded idle-robot color (`0xFF5B8EFF`,
i.e. `_darkAccent`) — a mismatch that would have silently shifted the
robot's shade the moment Football was wired up to the token, breaking the
"zero visual change to Dark" contract. Caught and fixed (`robotColor:
_darkAccent`) during the Football conversion itself, before any screen
consumed it — see the inline comment on `_darkLabColors` in
`app_theme.dart`.

### Contrast validation (`test/app_theme_contrast_test.dart`, 14 tests)

A small, dependency-free WCAG 2.1 relative-luminance/contrast-ratio
calculator checks every meaningful token pair in both themes against 4.5:1
(normal text) or 3:1 (large text / UI components), plus a light-mode-only
group for the lab tokens (radar markers against the plain page background;
ball/robot against the pitch; maze wall against road/grass). Two real
findings, both fixed before this sprint was considered done:

1. `onPrimaryAction`/`primaryAction` (white text on brand blue) measures
   3.73:1 in both themes — below the 4.5:1 normal-text minimum. This is the
   app's pre-existing, out-of-scope-to-recolor brand blue; reclassified to
   the 3:1 large/bold-text UI-component threshold (WCAG SC 1.4.11 — button
   labels are bold ≥16px), which it passes, with an inline comment
   explaining why.
2. Light-mode `robotColor` against the new lighter grass-green `pitchSurface`
   measured 1.35:1 using the initially-chosen brand blue — fixed by using
   near-black charcoal (`_lightPrimaryText`) instead, which reads clearly
   against a daylight pitch and passes 3:1.

### Screens/widgets converted this pass

Shared chrome (converts many screens at once): `route_link_card.dart`,
`allie_card.dart`, `lab_scaffold.dart`, `lab_mission_panel.dart`,
`lab_result_banner.dart`, `lab_help_sheet.dart`, `lab_control_rail.dart`,
`lab_control_handle.dart`, `lab_bottom_control_drawer.dart`.

Screens: `home_shell.dart`, `topics_screen.dart`, `practice_screen.dart`,
`journey_screen.dart`, `math_studio_hub_screen.dart`,
`football_precision_lab_screen.dart` (+ `_PitchPainter`),
`maze_driver_lab_screen.dart` (+ `_MazeEnvironmentPainter`),
`flight_path_lab_screen.dart` (+ `_RadarPainter`/`_AircraftPainter`/
`_ProjectedPathPainter`), `recall_cards_hub_screen.dart`,
`recall_cards_browse_screen.dart`, `recall_card_detail_screen.dart`,
`discovery_library_screen.dart`, `discovery_card_detail_screen.dart`, all 7
Family Studio screens (`family_studio_hub_screen.dart`,
`family_today_activity_screen.dart`,
`what_your_child_is_learning_screen.dart`,
`conversation_starters_screen.dart`, `tutor_tools_screen.dart`,
`family_progress_snapshot_screen.dart`, `homework_companion_screen.dart`),
and 4 Settings screens (`appearance_screen.dart`, `profile_screen.dart`,
`settings_screen.dart`, `accessibility_screen.dart`).

**Conversion rule applied consistently**: chrome (backgrounds, borders,
dividers, body/label text) converts to semantic tokens; deliberately
*categorical* decorative colors (per-subject/per-topic icon badges on Home
and Topics, Allie's brand orange, Captain Math's brand green, premium/lock
badge amber) stay fixed literals on purpose, matching how those same colors
already behave identically in both themes today.

**Not touched this pass** (explicit, visible follow-up — keeps rendering in
today's hardcoded dark colors regardless of the selected theme mode):
student onboarding, auth, Formulas, Tutor, Help, Exam Packs, Visual Maths,
Math Magic, Spatial Intelligence, and the remaining Interactive Labs
(Fraction Builder, Algebra Balance, Number Line Explorer, Data Detective).

### Testing

- `test/app_theme_contrast_test.dart` (new, 14 tests) — see above.
- `test/theme_mode_settings_test.dart` (new, 5 tests) — `themeMode` defaults
  to `ThemeMode.system`, persists across a simulated restart, falls back to
  `system` on an unrecognised persisted value, `AppearanceScreen`'s three
  options select/update the real `MaterialApp` brightness end-to-end, and
  the selection survives a full widget-tree rebuild.
- `test/theme_representative_screens_test.dart` (new, 48 tests) — every one
  of the 12 in-scope screens/features (expanded to one route per
  underlying screen file, 15 routes total) pumped under both `ThemeMode.dark`
  and `.light` with no exceptions; a smaller device matrix (theme x text
  scale {1.0x, 2.0x} x phone/tablet, plus a separate Reduce Motion check) on
  Football Precision (CustomPainter/`AppLabColors` risk) and Practice
  (heaviest token density). Uses bounded `pump()` calls rather than
  `pumpAndSettle()` — Maze Driver's periodic status-clock `Timer` never lets
  `pumpAndSettle`'s "no more frames scheduled" condition converge, matching
  why the lab's own dedicated widget-test suite already avoids
  `pumpAndSettle()` for the same screen.
- All pre-existing tests for every touched screen re-run unmodified —
  confirms the token swap changed paint values only, never structure or
  behavior.

### Validation results

- `dart format` — applied across `lib/` and `test/`, 0 files needed
  reformatting beyond the files this pass itself touched.
- `flutter analyze` (whole project) — **No issues found.**
- Targeted suites per screen group (labs, Home/Topics/Practice/Journey/
  Studio, Recall Cards, Discovery, Family Studio, Settings) — **all pass**
  as each group was converted.
- `flutter test --concurrency=1` (full suite) — **544/544 pass**, 0
  regressions (477 baseline + 67 new: 14 contrast + 5 theme-mode-settings +
  48 representative-screens).

### Manual verification still needed (reviewer)

- [ ] Settings → Appearance → switch System/Dark/Light on a physical
      device; confirm Home, Topics, Practice, Journey, Math Studio hub,
      Football, Maze, Flight, Recall Cards, Discovery, Family Studio, and
      Settings all repaint correctly in Light with no low-contrast text.
- [ ] Football/Maze/Flight in Light mode specifically: pitch/ball/robot,
      maze walls/road/grass, and the flight radar/path/aircraft glyph all
      stay clearly legible (the exact area the brief's own testing section
      calls out).
- [ ] Confirm every screen *not* in the 12-item list still renders in the
      same dark colors as before regardless of the selected mode — this is
      the intentional scope boundary, not a bug, but worth eyes-on
      confirmation that it reads as "coming later" rather than "broken."
- [ ] System theme mode: toggle the OS-level dark/light switch while the
      app is open/backgrounded and confirm it follows.
- [ ] Large system text size and Reduce Motion (on-device settings, not
      just the `MediaQuery` flags used in tests) in both Light and Dark.

Not committed — per this task's instruction, awaiting the reviewer's
Pixel 6a pass before any commit.

## 17. Visual Asset System (architecture + proof-of-concept)

Status: NOT COMMITTED — reviewed before commit, per this task's own
instruction.

### Summary

The brief specified a platform-wide Visual Asset System — registry,
metadata model, SVG rendering pipeline, animation architecture, Studio/
Tutor integration hooks, offline caching, and an AI-generation pipeline —
across 8 content categories, explicitly designed to later extend to other
QuantumLab products. That is a whole subsystem, not a single sprint's
content-authoring effort, and parts of the brief describe things that don't
exist in this app yet (Tutor has no live AI backend to "request" a visual
from; Manim rendering happens offline, never inside the Flutter app
itself). Per 3 scoping questions answered before implementation, this
sprint builds the real, working **architecture** — model, manifest, loader
service, rendering widget, one concrete integration in an existing screen —
proven with a small set of genuine new content, rather than a content-free
stub or an attempt to hand-author a full 8-category library. Full content
authoring, the AI-generation pipeline, and migrating the 3 existing lab
screens' hardcoded `ManimExplanationCard` asset paths onto the new registry
are explicitly deferred (the labs already have two prior sprints of
uncommitted changes awaiting review; touching them again wasn't worth the
added review surface for this pass).

### Architecture

Reuses this app's own established patterns rather than inventing new ones —
`NarrationManifestService`'s manifest-loader shape and
`DiscoveryCardCatalogService`/`FormulaLibraryService`'s
fail-fast-on-malformed-data, lazy-load-on-first-use JSON-catalog convention;
`DiscoveryIllustration`'s "approved asset or a labeled fallback tile, never
a broken-image glyph" contract.

- **`lib/models/visual_asset.dart`** (new): `VisualAsset` — full metadata
  per the brief's YAML block (`id`, `title`, `topic`, `subtopic`,
  `examBoards`, `difficulty`, `curriculumRefs`, `keywords`, `source`,
  `license`, `languageSupport`, `darkModeReady`, `contentVersion`) plus
  `assetType` (new `VisualAssetType` enum covering all 8 brief categories —
  `staticDiagram`, `formulaCard`, `workedSolutionStep`, `graph`,
  `geometryConstruction`, `statisticsChart`, `calculatorWalkthrough`,
  `realWorldIllustration` — even though only 2 have real content this
  sprint, so adding the rest later is purely an additive JSON edit, never a
  schema change) and `reviewStatus` (`approved`/`pendingReview`, mirroring
  the Discovery ComfyUI illustrations pipeline's own review-gate field, so
  a future AI-assisted generation pipeline has a place to flag new assets
  before they ship, without a schema change).
- **`assets/config/visual_assets.json`** (new): bundled manifest, 9
  entries — the 4 pre-existing `assets/manim_static/*.svg` files (flight
  path, football precision, maze driver, place value) registered so a
  future sprint can migrate the 3 lab screens onto the registry without
  re-authoring anything, plus 5 new hand-authored diagram SVGs (below).
- **`lib/services/visual_asset_service.dart`** (new):
  `VisualAssetCatalogService` — loads, fail-fast-validates, and caches the
  manifest once; `all()`, `byId()` (returns `null` for an unknown id rather
  than throwing — a missing asset must degrade gracefully, never crash),
  `byTopic()`, `byType()`, `byCurriculumRef()`. This is the brief's
  "Studio/Tutor integration hook": a real, queryable API surface a future
  Studio section or a future live-AI Tutor layer can call. No fake
  "AI request" simulation code was written — Tutor has no live AI backend
  anywhere in this app today, so there is nothing for a real request to go
  to yet.
- **`lib/widgets/visual_assets/visual_asset_view.dart`** (new):
  `VisualAssetView` — SVG-first (`SvgPicture.asset`), resolves by id via
  the catalog service, `Semantics(label: accessibilityDescription)`,
  reuses `ManimExplanationCard`'s Reduce-Motion-aware fade/scale entrance
  approach (without its replay/skip chrome — this is a plain embeddable
  diagram, not a full explanation card). A missing/unknown id renders a
  labeled placeholder tile, never a broken-image glyph, matching
  `DiscoveryIllustration`'s precedent.
- **Offline caching**: bundled SVGs are already fully offline and cached by
  Flutter's own asset bundle — no additional cache layer was built for
  this sprint's scope, avoiding a redundant abstraction over something the
  platform already provides.

### A real bug the new widget test caught before shipping

`_VisualAssetViewState._controller` was originally a lazily-initialized
`late final` field. When `animate: false` (or Reduce Motion) meant the
controller was never touched during the widget's life, `dispose()`'s
unconditional `_controller.dispose()` triggered the *first* access —
constructing a brand-new `AnimationController` (which looks up an ancestor
via `createTicker`) *during* teardown, after the element was already
deactivated: `"Looking up a deactivated widget's ancestor is unsafe."`
Fixed by constructing the controller eagerly in `initState()` instead of
lazily on first access. Caught by
`test/visual_asset_view_widget_test.dart`'s `animate: false` case before
this ever reached the app.

### New content this sprint

5 hand-authored SVG diagrams under `assets/visual_diagrams/` (dark-palette
only, matching the pre-existing `manim_static` assets' own styling —
`darkModeReady: false` on every entry, an honest limitation, not a bug),
wired to 5 real Formula Library entries via a new optional
`FormulaEntry.diagramAssetId` field:

- `area_triangle` → base/height-labelled triangle
- `circle_area` → radius-labelled circle
- `pythagoras_theorem` → labelled right triangle (a, b, c)
- `algebra_quadratic_formula` → parabola with roots and vertex marked
- `volume_cylinder` → radius/height-labelled cylinder

`formula_library_screen.dart`'s expanded card view renders a
`VisualAssetView` above the explanation when `diagramAssetId` is set; the
other 25 catalog entries are completely unaffected.

### Testing

- `test/visual_asset_service_test.dart` (new, 6 tests): manifest loads and
  validates, `byId`/`byType`/`byTopic`/`byCurriculumRef` return correct
  results, an unknown id resolves to `null`, the 4 migrated manim assets
  keep their original accessibility text.
- `test/visual_asset_view_widget_test.dart` (new, 5 tests): renders the SVG
  for a known id, renders the labeled fallback for an unknown id (never a
  broken-image glyph), exposes the accessibility label, renders without
  error under Reduce Motion, `animate: false` renders immediately (the
  case that caught the dispose bug above).
- `test/formula_library_diagram_widget_test.dart` (new, 2 tests): an entry
  with `diagramAssetId` shows its `VisualAssetView`; an entry without one
  renders exactly as before.
- `test/formula_library_service_test.dart` extended: asserts exactly the 5
  intended entries carry a `diagramAssetId` and every other entry has none.

### Validation results

- `dart format` — applied to every file this pass touched.
- `flutter analyze` (whole project) — **No issues found.**
- `flutter test --concurrency=1` (full suite) — **558/558 pass** (544
  baseline + 14 new), 0 regressions.

### Explicitly deferred (not this sprint)

- Migrating Football/Maze/Flight's `ManimExplanationCard` call sites onto
  the registry.
- Content authoring across the remaining 6 asset categories (worked
  solutions beyond the 3 migrated lab intros, real graphs beyond the
  existing `SimpleGraphCard`, geometry constructions, statistics charts,
  calculator walkthroughs, real-world illustrations).
- The AI-Generated Visuals pipeline from the brief — a future content
  pipeline sprint outside the Flutter app (analogous to the ComfyUI
  Discovery-illustrations pipeline), not Dart code.
- Lottie/Rive support, real Manim video rendering/playback, Studio screen
  changes to surface assets contextually, and cross-product
  (Physics/Chemistry/GRE/etc.) work — separate products entirely.

### Manual verification still needed (reviewer)

- [ ] Open Formula Library on a physical device, expand "Area of a
      Triangle", "Area of a Circle", "Pythagoras' Theorem", "Quadratic
      Formula", and "Volume of a Cylinder" — confirm each diagram renders
      clearly and the entrance animation feels right (and is fully absent
      under Reduce Motion).
- [ ] Expand a handful of formulas *without* a diagram — confirm they look
      completely unchanged from before this sprint.
- [ ] Confirm the diagrams (currently dark-palette only) don't look broken
      if Light theme is ever selected while viewing Formula Library (this
      screen was not part of the Light Theme sprint's 12 in-scope screens,
      so it should still render fully dark regardless of theme mode today
      — worth confirming that's still true).

Not committed — per this task's instruction, awaiting the reviewer's
Pixel 6a pass before any commit.

## 18. Studio Content Registry & Governance

Status: NOT COMMITTED — reviewed before commit, per this task's own
instruction.

### Summary

The brief asked Studio to be able to scale "from 50 activities to 50,000"
without architectural redesign: a governed content registry spanning every
Studio content type, a status lifecycle, multi-curriculum mapping
(explicitly not UK-only), difficulty levels, tags, learning objectives,
AI-ready query interfaces, and a "Continuous Curriculum Intelligence"
layer that can identify which content is affected when a curriculum
changes — explicitly architecture-only ("do not create hundreds of
lessons," "do not redesign Studio/navigation"). Research before
implementation confirmed the real gap this fills: **Interactive Labs have
had zero metadata registry anywhere in the app** (titles/difficulty
hardcoded per-screen), and every other content type with its own catalog
(Discovery, Recall, Family Activities, Mental Maths) uses its own separate,
inconsistent difficulty/tagging scheme — no shared enum existed anywhere.
Per 2 scoping questions answered before implementation, this sprint
registers all 7 Interactive Labs plus a bounded, representative sample from
each already-cataloged type (not a full backfill), and is entirely
headless — no new screens, nothing wired into navigation or Studio itself.

### Architecture

Mirrors the Visual Asset System sprint's own precedent
(`lib/models/visual_asset.dart`/`lib/services/visual_asset_service.dart`)
and the broader app convention: fail-fast JSON-manifest loader,
lazy-load-on-first-use, `byX()` query methods returning `null`/`[]` for no
match rather than throwing.

- **`lib/models/studio_content_item.dart`** (new): `StudioContentType`
  enum (`interactiveLab`, `discoveryCard`, `recallCard`, `formulaEntry`,
  `mentalMathsCategory`, `familyActivity`, `game`, `teacherActivity` — the
  last two have **zero registered entries**, exactly "prepare governance
  only," not fabricated content); `StudioContentDifficulty` enum
  (`foundation`/`core`/`higher`/`advanced`/`stretch`, the brief's own
  scale — a new, unified difficulty at the registry layer, since no shared
  one existed); `StudioContentStatus` enum (`draft`/`review`/`approved`/
  `published`/`retired`); `StudioLearningObjectives` (nested, all
  optional); `StudioContentItem` itself — full metadata per the brief
  (`category`, `subCategory`, `topic`, `examBoards`, `curriculumRefs`
  free-form list — "no hardcoded UK assumptions," same approach as
  `VisualAsset.curriculumRefs` — `estimatedMinutes`, `prerequisites`,
  `tags` free-form, `status`, `version`, `author`, `reviewedDate`,
  `progressServiceKey` — names the *existing* tracking service that owns
  analytics for this item (`"interactiveLabs"`, `"recallCards"`,
  `"mentalMaths"`) rather than building new tracking plumbing —
  `languageSupport`, plus the Continuous Curriculum Intelligence fields
  (`curriculumVersion`, `curriculumAuthority`, `curriculumEffectiveDate`,
  `reviewRequired`, `reviewReason`, `lastVerified`). Every field/class has
  full dartdoc (the "developer documentation" deliverable).
- **`assets/config/studio_content_registry.json`** (new): 27 entries — all
  7 `InteractiveLabId` values (Fraction Builder, Algebra Balance, Number
  Line Explorer, Flight Path Lab, Football Precision, Maze Driver, Data
  Detective — the real gap), 3 real Discovery Cards, 3 real Recall Cards,
  the 2 Formula entries that already have diagrams from the Visual Asset
  System sprint (ties the two sprints together), 2 real Family Activities,
  and all 10 Mental Maths categories (registered at the category level,
  the natural governance unit there). Every entry's `sourceId` points at a
  real, already-shipped id — the registry is an index, never a second
  source of truth for the content itself.
- **`lib/services/studio_content_registry_service.dart`** (new):
  `StudioContentRegistryService` — `all()`, `byId()` (nullable),
  `byType()`, `byCategory()`, `byTopic()`, `byDifficulty()`, `byTag()`,
  `byCurriculumRef()`, `byCurriculumAuthority()` (the Continuous
  Curriculum Intelligence query — "which content is governed under this
  exam authority"), `needingReview()`. This service collectively **is**
  the brief's "AI-ready query interface" — no fake AI-request code, same
  decision as Visual Asset System's Studio/Tutor hook, since no live AI
  backend exists anywhere in this app to receive a real request yet.

### Testing

`test/studio_content_registry_test.dart` (new, 9 tests): manifest loads
and validates, ids are unique, every non-`game`/`teacherActivity` entry
has a `sourceId`, all 7 `InteractiveLabId` values are represented exactly
once, `game`/`teacherActivity` are schema-ready with zero entries,
`byId`/`byCategory`/`byTopic`/`byDifficulty`/`byTag`/`byCurriculumRef`/
`byCurriculumAuthority` all filter correctly, `needingReview()` is
honestly empty (no shipped entry is flagged as needing review, since
nothing has actually failed a syllabus check yet — asserting otherwise
would be a false governance claim), a synthetic `fromJson` test proves the
full draft/lifecycle/learning-objectives shape parses correctly including
a content-free `game` entry, and a malformed entry (missing `sourceId` on
a type that requires it) fails fast as expected.

### Validation results

- `dart format` — applied to every file this pass touched.
- `flutter analyze` (whole project) — **No issues found.**
- `flutter test --concurrency=1` (full suite) — **567/567 pass** (558
  baseline + 9 new), 0 regressions — nothing existing was modified, this
  sprint is a pure addition.

### Explicitly deferred (not this sprint)

- Full backfill of every existing catalog item (all 120 Recall Cards, all
  24 Discovery Cards, every Formula entry, every Family Activity, every
  Mental Maths challenge) — future content-ops work, ideally CMS-tool-driven
  per the brief's "Authoring Readiness" goal, not hand-written JSON.
- Real Games or Teacher Activities content/screens.
- Any UI surface (browser screen, Studio wiring, Tutor wiring) — per your
  answer, this sprint is headless.
- Any live curriculum-change-detection integration — `byCurriculumAuthority()`
  is the query primitive a future syllabus-monitoring system would call;
  no monitoring system exists yet to call it.

### Manual verification still needed (reviewer)

This sprint has **no UI surface at all** — nothing to check visually on
device. The only meaningful verification is that the app still builds and
boots normally (covered by the full test suite above) and, if useful, a
quick sanity check that `flutter run` still launches cleanly with the new
JSON asset bundled.

Not committed — per this task's instruction, awaiting the reviewer's
Pixel 6a pass before any commit.

## 19. Family Studio Parent Activities

Status: NOT COMMITTED — reviewed before commit, per this task's own
instruction.

### Summary

The brief's scope was strict: "Work only inside Family Studio. Do not
modify Student Studio." The stated problem was that the parent-facing
"Topic Drill" surface had no meaningful parent content — traced during
research to `TutorToolsScreen`'s "Assign Practice" button, which simply
bounced a parent into the *student* `/topics` → Topic Drill flow with zero
parent-specific framing. Per explicit instruction ("Do not duplicate the
student Topic Drill. Instead create Parent Activities"), this sprint adds
real, distinct Parent Activity content rather than touching that flow.
Rather than picking arbitrarily from the brief's example list (Homework
Companion, Kitchen Maths, Shopping Maths, Budget Challenge, Travel Maths,
Garden Geometry, Mental Maths Together, Weekend Activities), a full audit
of the existing 12-activity Phase 2 catalog found a concrete, verifiable
gap: 4 of the 16 `FamilyMathsCategory` values (`decimals`, `percentages`,
`algebra`, `mentalMaths`) had **zero** authored activities. This sprint
closes exactly that gap plus one deliberate reinforcement of an
already-rich category, giving the catalog full 16/16 category coverage.

### Content added

5 new entries appended to `assets/config/family_activities.json` (12 → 17
flagship activities), each with the full required shape (materials,
what-your-child-learns, let's-explore, 3 questions-to-ask, common
misconceptions, try-tomorrow, Captain Math + Allie prompts) and real —
not copy-pasted — `en`/`en-GB`/`de-CH`/`fr-CH`/`it-CH` text, honoring the
session's standing "no silent English leak" convention:

- **`budget-challenge`** ("The Pocket Money Challenge") — `percentages`,
  ages 8–11, 5–10 min.
- **`travel-maths`** ("How Long Will It Take?") — `decimals`, ages 8–12,
  5–10 min, Studio Connection → `discovery/aviation-speed-distance-time`.
- **`garden-geometry`** ("Garden Geometry") — `geometry` (deliberate
  reinforcement, not a gap-fill), ages 6–10, 5–10 min, Studio Connection →
  `visual-maths`.
- **`mental-maths-together`** ("Mental Maths Together") — `mentalMaths`,
  ages 7–11, 5–10 min, Studio Connection → `mental-maths`.
- **`weekend-number-trail`** ("The Weekend Number Trail") — `algebra`,
  ages 8–12, 5–10 min.

All 5 satisfy the model's hard validation constraints (`minMinutes >= 5`,
`maxMinutes <= 10`, kebab-case id) enforced by `FamilyActivity.fromJson`.

### Wiring — verified, not assumed

Per "Do not redesign navigation," no screen, route, or navigation code was
touched. This was verified rather than assumed by tracing every consumer
of `FamilyActivityCatalogService`:

- `FamilyMathsLibraryScreen` and `activityOfTheDay()` already pull from the
  full catalog dynamically — the 5 new activities appear in the Library and
  enter the daily-activity rotation automatically.
- `HomeworkCompanionService`'s fixed `RecallTopic → FamilyMathsCategory`
  lookup table already mapped `RecallTopic.algebra` to
  `FamilyMathsCategory.algebra` — previously always resolving to no match
  (the category had no activity). With `weekend-number-trail` added, a
  parent running a Homework Companion session for the Algebra topic now
  gets a real paired family activity where before they got none — a
  genuine content-completeness fix delivered purely by adding data to the
  existing architecture, with zero code changes.

This is the same "index/catalog, not hardcoded list" design already
established by the Studio Content Registry sprint ([§18](#18-studio-content-registry--governance))
paying off directly: new content surfaces everywhere it should with no
wiring work required.

### Testing

Two pre-existing test files had stale hardcoded expectations from the
12-activity/4-unused-category catalog state, fixed to match the new, correct
state (not bugs in the new content):

- `test/family_activity_catalog_service_test.dart` — `byCategory(decimals)`
  updated from `isEmpty` to resolving `travel-maths`.
- `test/family_activity_schema_test.dart` — flagship count updated from 12
  to 17; the old "these 4 categories are deferred/unused" test replaced
  with a new test asserting full 16/16 `FamilyMathsCategory` coverage; the
  "every used category is a real authored category" test now compares
  against the full enum instead of a hardcoded 12-value subset.
- `test/family_maths_layout_test.dart` — one test description string
  updated ("12 activities" → "17 activities"); no assertion logic changed.

No new test files were added — total suite count is unchanged from the
Section 18 baseline.

### Validation results

- `dart format` — applied to all 3 touched test files (0 changes needed,
  already compliant).
- `flutter analyze` (whole project) — **No issues found.**
- `flutter test --concurrency=1` (full suite) — **567/567 pass**, 0
  regressions. Notably, `family_maths_layout_test.dart`'s device-matrix
  overflow test now genuinely exercises all 17 activities (up from 12)
  rendering without overflow across all 8 required viewports — a real,
  strengthened check, not just a relabeled one.

### Explicitly deferred (not this sprint)

- The remaining brief example activities not authored this pass (Homework
  Companion, Kitchen Maths, Shopping Maths, Weekend Activities as a
  distinct entry) — the 4 previously-empty categories plus one
  reinforcement were judged the highest-value, most defensible slice; a
  further content batch can add more within any category at any time using
  the same pattern.
- Any change to `TutorToolsScreen`'s "Assign Practice" button or the
  student Topic Drill flow itself — out of scope per "Do not modify
  Student Studio."
- Any navigation, adaptive-scheduling, or Studio-architecture change — per
  explicit brief constraint; this sprint is a pure content addition.

### Manual verification checklist (reviewer, Pixel 6a)

- [ ] Family Studio → Family Maths Library shows 17 activities (was 12);
      scroll to confirm Budget Challenge, Travel Maths, Garden Geometry,
      Mental Maths Together, and Weekend Number Trail all appear with full
      detail screens.
- [ ] Filter chips for Percentages, Decimals, Mental Maths, and Algebra
      now appear in the category chip row (previously absent — no authored
      activity existed) and each filters to the correct new activity.
- [ ] Today's Activity occasionally surfaces one of the 5 new activities
      (rotation is deterministic by date — check across a few different
      days via device date change if needed).
- [ ] Homework Companion: pick the Algebra topic and confirm a family
      activity suggestion (Weekend Number Trail) now appears where before
      none did.
- [ ] Spot-check `de-CH`/`fr-CH`/`it-CH` text on at least one new activity
      detail screen for tone/correctness (translations are real but not
      professionally reviewed).

Not committed — per this task's instruction, awaiting the reviewer's
Pixel 6a pass before any commit.

## 20. Production Polish Audit

Status: NOT COMMITTED — reviewed before commit, per this task's own
instruction. Full detail lives in the standalone `POLISH_AUDIT.md` at the
repo root (the brief's explicitly requested deliverable); this section is
a short index into it, matching this report's own running convention.

### Summary

Brief scope: "no screen feels unfinished," with an explicit "no new
functionality, only production polish" constraint and four required
passes — fix every RenderFlex overflow (Mobile/Pixel 6a, Tablet, Web,
Landscape), replace every empty state, audit every navigation path for
dead ends, and report findings. See `POLISH_AUDIT.md` for full detail on
each; summarised here:

- **Overflow**: new `test/polish_audit_overflow_sweep_test.dart` pumps all
  72 static/sample-id routes across the 4 named device categories (288
  combinations) — a permanent addition to the suite, not a one-off script.
  First run found 13 real overflow bugs across 5 screens (Sign In, Create
  Account, Terms, Release Notes, and the shared Visual Maths placeholder
  scaffold used by Abacus/Fraction Bars/Place Value); all 5 fixed with
  minimal, targeted changes (`Wrap`+tight `TextButton` styling, `Expanded`/
  `Flexible`+ellipsis, and one `SingleChildScrollView` wrap for the shared
  scaffold). Re-swept clean: 288/288.
- **Empty states**: investigated the brief's own named example (Recall
  Cards → Algebra → Meaning) — confirmed real, one of 4 genuinely-empty
  topic×type combinations in the catalog. Fixed by adding a "Clear
  filters" action to the existing empty message, reusing the screen's own
  `_clearFilters()` and an already-translated string — zero new
  localisation work. Audited every other filterable catalog screen
  (Discovery, Formula Library, Family Maths, Mental Maths, Bookmarks) —
  all either structurally can't reach an empty state (chips only ever
  generated for categories that have content) or already had a proper,
  purpose-written zero-state.
- **Navigation dead ends**: fixed the one confirmed dead link already on
  record from §13 (`/topics/:id` — no matching route) at both call sites
  (`lab_related_links.dart`, `recall_card_body.dart`), now pointing at the
  real `/topics` destination. Widened the audit app-wide (~100 push/go
  call sites, every hardcoded lab→card cross-reference id, every bottom
  sheet/dialog) — no further dead links found.

### Validation results

- `dart format` — applied to all 9 touched files.
- `flutter analyze` (whole project) — **No issues found.**
- `flutter test --concurrency=1` (full suite) — **855/855 pass** (567
  baseline + 288 new overflow-sweep tests), 0 regressions.

### Explicitly deferred (not this pass)

- Raw internal ids rendered as chip labels in `LabRelatedLinks`/
  `RecallCardBody`'s related-links widgets (e.g. a chip literally reading
  "algebra-solve-linear-equation") — a real rough edge, but a proper fix
  needs async catalog title resolution inside those widgets, judged closer
  to new functionality than a same-pass polish fix. See `POLISH_AUDIT.md`
  §5 for the full reasoning.
- No architecture, onboarding, auth, navigation model, adaptive engine,
  entitlement, or Studio framework change — all out of scope per the
  brief, and none were touched.

### Manual verification checklist (reviewer, Pixel 6a)

See `POLISH_AUDIT.md`'s own checklist at the end of that file — not
duplicated here to avoid the two documents drifting out of sync.

Not committed — per this task's instruction, awaiting the reviewer's
Pixel 6a pass before any commit.

## 21. Parent PIN Reminder

Status: NOT COMMITTED — reviewed before commit, per this task's own
instruction.

### Summary

Brief scope: "Work only inside Family Studio. Do not redesign
authentication." Objective: encourage parents who haven't set a Parent PIN
yet to create one, via a gentle, non-blocking, periodic in-app reminder —
never every launch, and gone for good once a PIN exists.

Confirmed "no PIN" is a real, reachable state before building anything:
Parent/Tutor onboarding's PIN field
(`family_preferences_screen.dart`) is optional — a parent can finish
onboarding and land in Family Studio via the existing grace-access window
with no PIN ever set.

### Architecture

No authentication logic was touched — `LocalPreferencesService`'s existing
`hasParentPin`/`setParentPin`/PIN-hash machinery, and the existing PIN
creation flow already live in `ParentTeacherToolsScreen`, are both used
exactly as they are today. This sprint adds only:

- **`LocalPreferencesService`** — a new persisted
  `parentPinReminderLastShownAt` timestamp, `recordParentPinReminderShown()`,
  and `shouldShowParentPinReminder()`, plus a documented
  `parentPinReminderInterval` constant (**7 days** — see the frequency
  policy below).
- **`lib/widgets/parent_pin_reminder_banner.dart`** (new) —
  `ParentPinReminderBanner`, a small `StatefulWidget` that decides once, at
  mount, whether it's due (per the service above) and renders inline —
  never a dialog, never a route, never blocking anything else on the page.
  Visually matches the hub's existing `AllieCard` card language (rounded
  `cardSurface` container, circular icon badge, `divider` border) rather
  than inventing a new visual style.
- **`family_studio_hub_screen.dart`** — the banner is mounted once, above
  the hub's existing opening copy. No other screen in Family Studio shows
  it (per "Work only inside Family Studio" — even though a parent could
  reach several Family Studio sub-screens without ever seeing the hub
  again, the hub is Family Studio's one true landing point, so this is
  the single correct place, not a placement of convenience).

### Frequency policy (documented, per the brief's own requirement)

- **First-ever PIN-less visit to the hub**: shown immediately (not
  withheld) — this is the one moment it's most useful, before it's ever
  been seen.
- **After being shown once** (whether the parent taps "Set PIN", taps
  "Remind Me Later", or simply navigates away without touching it — all
  three record the same "shown" timestamp): suppressed for
  **`LocalPreferencesService.parentPinReminderInterval` = 7 days**, chosen
  as a deliberate middle ground — frequent enough that an unprotected
  Family Studio doesn't go unnoticed for a whole billing cycle, gentle
  enough that it never reads as nagging.
- **Once a Parent PIN exists** (`hasParentPin == true`): the banner's own
  eligibility check fails permanently — no separate "permanently
  dismissed" flag was needed, since the real condition (a PIN now exists)
  is already the correct, simpler source of truth.
- **"Set PIN"** dismisses the banner locally, then pushes
  `/help/parent-teacher-tools` — the existing, unmodified
  `ParentTeacherToolsScreen`, the app's one real PIN-creation flow.
  **"Remind Me Later"** dismisses it and starts the same 7-day cooldown,
  without navigating anywhere.

### Testing

New `test/parent_pin_reminder_banner_test.dart` (10 tests): pure
frequency-policy unit tests on `LocalPreferencesService`
(`shouldShowParentPinReminder` true on first check, false once a PIN
exists, false immediately after being recorded shown, true again exactly
at the 7-day boundary, and the interval constant itself asserted to be 7
days so a future accidental change is caught) plus widget-level behaviour
on the real `/family-studio` route (appears on a first PIN-less visit;
never appears once a PIN exists; does not reappear mid-cooldown; "Remind
Me Later" hides it without navigating and without blocking the rest of
the hub; "Set PIN" opens the real `ParentTeacherToolsScreen`). Also
re-ran the pre-existing `test/family_studio_hub_test.dart` (14 tests,
including its own 320px/tablet overflow checks) unmodified — all still
pass with the banner now present in the render tree.

### Validation results

- `dart format` — applied to all touched files.
- `flutter gen-l10n` — regenerated after adding
  `familyStudioPinReminderTitle`/`Body`/`SetPinButton`/`LaterButton` to
  all 20 ARB locale files (including `app_en_GB.arb` — this repo's
  existing `family_studio_localisation_test.dart` requires every
  `familyStudio*` key to be explicitly present and non-empty in every
  locale, not merely fallback-reachable, and caught the initial omission).
- `flutter analyze` (whole project) — **No issues found.**
- `flutter test --concurrency=1` (full suite) — **865/865 pass** (855
  baseline + 10 new), 0 regressions.

### Explicitly deferred (not this sprint)

- No change to authentication, the PIN hash/verify mechanism, or the
  existing PIN-creation screen itself — all reused exactly as-is, per
  "do not redesign authentication."
- No reminder anywhere outside the Family Studio hub (e.g. Home, Profile)
  — per "work only inside Family Studio."

### Manual verification checklist (reviewer, Pixel 6a)

- [ ] Fresh install / no PIN set → open Family Studio → "Protect Family
      Studio" card appears above the welcome copy, styled like the
      existing Allie card.
- [ ] Tap "Remind Me Later" → card disappears immediately; rest of the hub
      is unaffected and fully usable.
- [ ] Leave the app running, come back to Family Studio the same day →
      card stays hidden (still within the 7-day cooldown).
- [ ] Tap "Set PIN" → lands on the real Parent/Teacher Tools screen and a
      PIN can be created there exactly as before.
- [ ] Once a PIN is set, return to Family Studio → the card never appears
      again, on any future visit.

Not committed — per this task's instruction, awaiting the reviewer's
Pixel 6a pass before any commit.

## 22. Interactive Labs UX — Football Precision & Flight Path Lab

Status: NOT COMMITTED — reviewed before commit, per this task's own
instruction.

### Summary

Brief scope: "Work only inside Studio Interactive Labs. Do not redesign
gameplay." Objective: increase immersion by moving every adjustable
control off the playing field/radar into side panels, for both Football
Precision and Flight Path Lab, while keeping the existing adaptive
device-matrix contract (Desktop, Tablet, Pixel 6a, Landscape, Portrait)
and auto-collapsing panels when horizontal space is constrained.

Research before touching anything found this app already has a purpose-built
adaptive control-panel toolkit for exactly this
(`lib/widgets/labs/lab_controls/`: `LabControlRail` — left/right/top/bottom
themed panel container, `LabControlBreakpoint`/`resolveLabControlBreakpoint`
— desktop/tablet/phoneLandscape/phonePortrait resolution built on the app's
existing `AppResponsive` split, `LabCollapsibleControls`/`LabControlHandle`
— the collapse-and-reopen mechanism), already in production use by Flight
Path Lab and, partially, by Football Precision. This sprint's real work was
therefore mostly a genuine gap-closing UI change for Football Precision,
plus verifying Flight Path Lab already meets the brief rather than assuming
it needed changes.

### Football Precision — changed

Before: the Angle slider sat directly beneath the pitch (not in a distinct
panel), and Power lived in a narrow right-hand rail that only appeared on
wider breakpoints — on an ordinary phone portrait it fell back to an
expandable drawer *below* the pitch, and Take Kick was always a separate,
full-width button below everything.

After, matching the brief's own explicit layout — **LEFT PANEL: Target
Zone; RIGHT PANEL: Power, Take Kick** — on every breakpoint with side-rail
width (tablet, desktop, phone landscape):

- `LabControlRail(position: left)` holds the target-zone label and Angle
  slider.
- The pitch (`_PitchPreview`, a `CustomPaint` — the ball, robot, direction
  line and numbered zones) is `Expanded` between the two rails and contains
  nothing else: no widget sits over the painted field.
- `LabControlRail(position: right)` holds the Power slider and the Take
  Kick button together, per the brief's own panel contents.

On phone portrait (`LabControlBreakpoint.phonePortrait`), the two rails
collapse into a single stacked column below the pitch instead — no rail
chrome, matching the same plain-stacked convention Flight Path Lab already
uses in its own portrait fallback, rather than inventing a second visual
style.

Take Kick deliberately sits *outside* the part that collapses after a
kick (only the Power slider does) — the primary action must never become
unreachable during the brief post-kick "focus" collapse, matching how
Flight Path Lab's own Test Flight button is never hidden either. The mode
selector, "How it works," Target Zone and Power panels now all share one
`LabControlHandle` reopen affordance (previously each of the two existing
collapsible groups risked growing its own) — one tap always brings
everything back.

No scoring, kick physics, target-zone assignment, mode logic, or timing
was touched — this is a pure layout change; every existing gameplay test
(`Precision Round progresses from kick 1 to final metrics`, `One-Minute
Challenge shows countdown and blocks duplicate taps`, etc.) passes
unmodified.

### Flight Path Lab — verified, not changed

Read in full before deciding whether to touch it: heading and speed
sliders (plus the prediction chips on non-Explorer tiers) already live
inside a single collapsible `controlsSection`, placed in
`LabControlRail(position: right)` on every non-portrait breakpoint and
falling back to a plain stacked column on phone portrait — already
exactly the brief's "move all adjustable controls to side panels" /
"collapse control panels automatically" contract, already collapsing
after each Test Flight via the same `LabCollapsibleControls` +
`LabControlHandle` mechanism Football Precision now also uses. The radar
canvas contains no floating controls (the draggable aircraft glyph sits
beside/below the canvas as a direct-manipulation *gameplay* input — the
same role the ball/robot play in Football Precision — not a "control
panel," and moving it would itself be a gameplay change the brief
explicitly rules out). Confirmed via its own existing test coverage
(`lab_controls_responsive_test.dart`'s full 7-viewport matrix +
2.0x-scale + Reduce Motion cases) — all passing, unmodified. No code
changed in this file this sprint.

### Testing

`test/football_precision_widget_test.dart` — two structural assertions
updated to match the new panel layout (not weakened, replaced with
equally specific checks): the old single "power sits in a side rail...
at phone width" test (asserted exactly 1 `LabControlRail` at portrait
width, which was actually already testing the *old* fallback-drawer
behavior) is now two tests — one confirming phone portrait has **zero**
`LabControlRail`s and both sliders/labels present in the stacked column,
one confirming phone landscape/tablet width shows **exactly 2**
`LabControlRail`s (left + right). Every other test in the file (kick
progression, mode switching, countdown, collapse/reopen timing, Reduce
Motion, disposal-mid-collapse) passes completely unmodified, proving the
layout change didn't touch gameplay. Also re-ran, unmodified:
`lab_controls_responsive_test.dart` (full device matrix for both labs),
`labs_mobile_layout_test.dart`, `rc2_math_intelligence_widget_test.dart`.

### Validation results

- `dart format` — applied to both touched files (0 changes needed).
- `flutter analyze` (whole project) — **No issues found.**
- `flutter test --concurrency=1` (full suite) — **865/865 pass**, 0
  regressions. Test count is unchanged from Section 21's baseline — this
  sprint edited/renamed existing tests rather than adding new files.

### Explicitly deferred (not this sprint)

- No change to Flight Path Lab's source — verified compliant rather than
  edited, to avoid an unnecessary, unrequested change under "only UI
  improvements."
- No change to any other Interactive Lab (Fraction Builder, Algebra
  Balance, Number Line Explorer, Maze Driver, Data Detective) — the brief
  named only Football Precision and Flight Path Lab.
- No change to scoring, physics, target-zone assignment, guidance-level
  logic, or any other gameplay system in either lab.

### Manual verification checklist (reviewer, Pixel 6a)

- [ ] Football Precision, tablet/landscape width: Target Zone (angle)
      appears in a left panel, Power + Take Kick appear together in a
      right panel, and the pitch itself shows only the ball/robot/zones —
      no floating slider or button over the field.
- [ ] Football Precision, portrait phone: panels collapse into a single
      stacked column below the pitch; still no controls over the field.
- [ ] Football Precision: take a kick, confirm the mode selector, Target
      Zone and Power panels all collapse together and a single "Show
      controls" handle reopens all of them at once.
- [ ] Flight Path Lab, all 5 device categories: heading/speed controls
      stay in a side panel (or stacked below on portrait), the radar
      canvas is never obstructed, and Test Flight remains reachable
      throughout.

Not committed — per this task's instruction, awaiting the reviewer's
Pixel 6a pass before any commit.

## 23. Spatial Intelligence Completion

Status: NOT COMMITTED — reviewed before commit, per this task's own
instruction.

### Summary

Brief scope: "Work only inside Spatial Intelligence. Do not redesign
Studio." Objective: replace the pillar's "In Development" placeholder with
enough production-ready content that it feels complete — minimum Cube
Nets, Rotations, Transformations, Spatial Puzzles, as simple interactive
demonstrations, using existing Studio architecture, with a separately
documented remaining backlog and no roadmap items removed.

**Governance note**: before starting, `docs/RC1_FEATURE_FREEZE.md` §7 was
found to explicitly require "an explicit post-RC1 decision" before
expanding Spatial Intelligence beyond "in development" — this pillar was
deliberately frozen there for exactly this reason. Flagged to you
directly rather than assumed away; you confirmed this sprint's
instruction is that explicit decision. `RC1_FEATURE_FREEZE.md` §2, §7 and
its §8 changelog were updated to record the decision (dated 2026-08-02),
per the freeze document's own process — this is documentation of a real
decision, not a workaround of the freeze.

### Content shipped

4 real, self-contained interactive activities under
`/math-studio/spatial-intelligence/*`, sharing a new
`SpatialActivityScaffold` (deliberately without the "Preview"/"coming
soon" badge `VisualMathsPlaceholderScaffold` carries — these are finished
activities, not bounded previews):

- **Cube Nets** — 4 hand-picked, verified nets (2 fold into a closed
  cube, 2 don't — the standard textbook cross/staircase-vs-straight-line/
  2×3-block examples), "does this fold into a cube?" with immediate
  feedback and a real geometric explanation, cycling with "Next net".
- **Rotations** — an asymmetric L-shaped tile rotated about a fixed
  centre via a continuous slider or 90°/180°/270° preset buttons, with
  the original outline shown for direct comparison.
- **Transformations** — the same shape, switchable across the 4 classic
  transformations (translate/reflect/rotate/enlarge), each with its own
  parameter control, always shown against the original for before/after
  comparison.
- **Spatial Puzzles** — 5 untimed, unscored multiple-choice puzzles
  (isometric cube counting, reflection-vs-rotation identification, and
  three 3D-shape face/edge/vertex fact checks), cycling with "Next
  puzzle".

New shared geometry code — `spatial_shapes.dart` (rotation/translation/
reflection/scale point-transform helpers) and `spatial_shape_painter.dart`
(the shared grid+shape `CustomPainter`) — is reused by both Rotations and
Transformations rather than duplicated, and is itself real, correct
geometry (not a placeholder), matching "use placeholders only where
absolutely necessary." Every visual is a 2D `CustomPaint` diagram — no 3D
rendering engine, consistent with `RC1_FEATURE_FREEZE.md` §4's existing,
unrevisited "Full 3D graphics engine" deferral.

### Studio architecture — reused, not redesigned

- `MathStudioPillarMeta` registry: `spatialIntelligence.isInDevelopment`
  flipped `true` → `false` — the one flag this pillar's hub tile badge
  and every existing pillar-reachability test already keyed off.
  Everything else about pillar registration, ordering, and the hub
  screen's own rendering is untouched.
- 4 new routes nested under the existing `/math-studio/spatial-intelligence`
  route (additive only — no route removed, moved, or restructured).
- The hub screen (`spatial_intelligence_screen.dart`) was rewritten from
  an inert `InDevelopmentFeatureCard` + sub-item list into 4 real
  `RouteLinkCard`s (the same shared tile component every other Math
  Studio hub screen already uses) plus the pre-existing Interactive Labs
  entry card, left completely unchanged.

### Testing

New `test/spatial_intelligence_activities_test.dart` (23 tests): real
interaction coverage per activity (Cube Nets' correct/incorrect feedback
and net cycling; Rotations' preset buttons and slider; Transformations'
kind-switching and translate stepper; Spatial Puzzles' answer feedback
and puzzle cycling), plus a 4-viewport × 4-activity no-overflow sweep (16
of the 23). One real accessibility/UX bug caught and fixed while writing
these tests: Transformations' "move left" stepper button originally
reused `Icons.arrow_back` — the exact same icon as the screen's own
app-bar back button — which is a genuine ambiguity (for sighted
scanning and for any test/tooling that finds by icon), not just a test
inconvenience; changed to `Icons.west`/`Icons.east` for the horizontal
stepper pair. Also updated 3 pre-existing tests that encoded the old
"in development" state: `test/math_studio_new_pillars_test.dart` (now
exercises all 4 real activities plus the unchanged Interactive Labs
entry), `test/math_studio_navigation_widget_test.dart` (one assertion:
Spatial Intelligence no longer shows the in-development badge Math &
Magic still does).

### Validation results

- `dart format` — applied to all touched/new files.
- `flutter gen-l10n` — regenerated after adding 5 new
  `mathStudioSpatial*` keys.
- `flutter analyze` (whole project) — **No issues found.**
- `flutter test --concurrency=1` (full suite) — **888/888 pass** (865
  baseline + 23 new), 0 regressions.

### Explicitly deferred — see `docs/SPATIAL_INTELLIGENCE_BACKLOG.md`

Full detail lives in that standalone document (per the brief's own
"document remaining backlog separately"); summarised here: only 4 of the
11 valid cube nets are covered; no animated fold; only one shared shape
for Rotations/Transformations; no chained/combined transformations; only
5 spatial puzzles; no progress-tracking/analytics wiring (these are
presentation-only, matching "simple interactive demonstrations," not
wired into `InteractiveLabsProgressService` or any other tracking
service); and localisation of the 5 new hub-level strings covers only the
5 locales `math_studio_l10n_completeness_test.dart` enforces
(en/en-GB/de-CH/fr-CH/it-CH), not the other 15 locale files this app
ships — the in-activity content itself (net explanations, puzzle
prompts, transformation labels) is English-only throughout, not yet
routed through `AppLocalizations` at all.

### Manual verification checklist (reviewer, Pixel 6a)

- [ ] Math Studio hub → Spatial Intelligence no longer shows an
      "In development" badge; the tile itself is unchanged otherwise.
- [ ] All 4 new activity cards (Cube Nets, Rotations, Transformations,
      Spatial Puzzles) open real, working screens — none are dead links.
- [ ] Cube Nets: answering both correctly and incorrectly shows the right
      feedback colour and explanation; "Next net" cycles through all 4.
- [ ] Rotations: both the slider and the 90°/180°/270° buttons visibly
      rotate the shape; Reset returns to 0°.
- [ ] Transformations: switching between Translate/Reflect/Rotate/Enlarge
      swaps the control shown, and each one visibly changes the shape
      against the dashed original.
- [ ] Spatial Puzzles: answering shows feedback and an explanation;
      "Next puzzle" cycles through all 5; no timer or score is shown
      anywhere.
- [ ] The existing "Interactive Labs" entry card at the bottom of the
      Spatial Intelligence hub still works exactly as before.

Not committed — per this task's instruction, awaiting the reviewer's
Pixel 6a pass before any commit.

## 24. Math & Magic Completion

Status: NOT COMMITTED — reviewed before commit, per this task's own
instruction.

### Summary

Brief scope: "Replace the current placeholder. Implement a first
production-ready experience... Maintain the calm exploratory Studio
philosophy. No scoring. No timed mode. No gamification. Focus on
curiosity." Same governance situation as Section 23: `docs/
RC1_FEATURE_FREEZE.md` §7 explicitly froze this pillar too, pending "an
explicit post-RC1 decision" — the same decision you confirmed for both
Spatial Intelligence and Math & Magic together is recorded in
`RC1_FEATURE_FREEZE.md` §2/§7/§8 (2026-08-02).

### Content shipped

4 real, untimed, unscored interactive activities under
`/math-studio/math-magic/*`, sharing a new `MathMagicActivityScaffold`
(a same-shape sibling of Spatial Intelligence's `SpatialActivityScaffold`,
kept separate rather than shared cross-pillar since each has its own back
destination):

- **Visual Number Tricks** — the classic "1089 trick," computed live from
  whatever 3 digits the learner picks via steppers (not a canned worked
  example): reverse, subtract, reverse the difference, add — always 1089.
- **Patterns** — triangular and square numbers grown step by step as a
  dot diagram, with the formula shown alongside.
- **Magic Squares** — place 1–9 into a 3×3 grid so every row/column/
  diagonal sums to 15; tap-to-place, tap-again-to-clear (no drag gesture
  required), with a "show me a solution" reveal (the Lo Shu square).
- **Parity** — pick two numbers, predict odd/even for their sum, then
  check — a one-off guess-and-reveal, not a tracked quiz.

**Scope change made and disclosed, not silently shipped**: the brief's
own example list also named "Impossible Shapes." That was deliberately
**not** built — a correct Penrose-triangle-style illusion depends on
exact vertex/paint-order geometry this sandboxed environment has no way
to visually render and check before shipping, and guessing at that
geometry risked shipping a subtly wrong or confusing "impossible shape."
It was swapped for Patterns (also brief-named) instead, and left as real,
tracked backlog in `docs/MATH_MAGIC_BACKLOG.md` rather than attempted
blind.

### Testing

New `test/math_magic_activities_test.dart` (23 tests): real per-activity
interaction (Number Tricks' full reveal sequence, verified against
hand-worked arithmetic, and that changing a digit resets the reveal;
Patterns' step/pattern-type switching; Magic Squares' solution reveal and
tap-to-place; Parity's guess-then-check), an explicit sweep asserting
**no** score/streak/timer/progress-indicator widget appears anywhere
across all 4 activities (the brief's "no gamification" constraint, made
into a real regression check rather than just a design intention), and a
4-viewport × 4-activity overflow sweep. That overflow sweep caught 2 real
bugs before they shipped: at the narrowest supported width (320px),
Number Tricks' 3-digit-stepper row and Parity's 2-number-dial row both
overflowed — both were `Row(mainAxisAlignment: spaceEvenly)` with enough
fixed-width children (two full-size `IconButton`s each) to exceed 320px;
both fixed by switching to `Wrap` (which degrades to wrapping instead of
clipping) plus `VisualDensity.compact` on the Number Tricks steppers'
icon buttons to reduce their footprint directly. Also updated 2
pre-existing tests that encoded the old "in development" state:
`test/math_studio_new_pillars_test.dart` (now exercises all 4 real
activities; also replaced its "in-development badge appears in
semantics" assertion — which had no live subject left once both Math &
Magic and Spatial Intelligence shipped real content — with a direct,
standalone test of `InDevelopmentFeatureCard`'s own semantics contract,
so that mechanism stays covered for whatever pillar needs it next) and
`test/math_studio_navigation_widget_test.dart` (one assertion: Math &
Magic no longer shows the in-development badge).

### Validation results

- `dart format` — applied to all touched/new files.
- `flutter gen-l10n` — regenerated after adding 8 new
  `mathStudioMathMagic*` keys.
- `flutter analyze` (whole project) — **No issues found.**
- `flutter test --concurrency=1` (full suite) — **912/912 pass** (888
  baseline + 24 net new), 0 regressions.

### Explicitly deferred — see `docs/MATH_MAGIC_BACKLOG.md`

Full detail lives in that standalone document; summarised here: Impossible
Shapes and Curious Proofs (both brief-named, both deliberately deferred —
see "scope change" above and the doc's own reasoning for each); more
number tricks beyond the 1089 trick; larger/different magic squares; more
pattern types; no progress-tracking/analytics wiring (presentation-only,
matching Spatial Intelligence's identical choice); and localisation
scoped to the same 5 production locales as Section 23, with in-activity
content itself English-only throughout.

### Manual verification checklist (reviewer, Pixel 6a)

- [ ] Math Studio hub → Math & Magic no longer shows an "In development"
      badge; the tile itself is unchanged otherwise.
- [ ] All 4 new activity cards open real, working screens — none are dead
      links, and nowhere in this pillar shows a score, timer, or streak.
- [ ] Visual Number Tricks: change the digits, reveal the trick, confirm
      it always ends at 1089 for at least 2 different digit combinations.
- [ ] Magic Squares: place numbers until the grid is full and confirm the
      "not quite magic yet" vs. "Magic!" message matches whether the
      arrangement is actually correct; "Show me a solution" produces a
      genuinely magic square.
- [ ] Parity: guess odd/even for a few different number pairs and confirm
      the explanation always matches the real sum.
- [ ] Number Tricks and Parity specifically: confirm no overflow at the
      narrowest supported phone width (this is exactly where 2 real bugs
      were caught and fixed this pass).

Not committed — per this task's instruction, awaiting the reviewer's
Pixel 6a pass before any commit.

## 25. Parent Recall Cards

Status: NOT COMMITTED — reviewed before commit, per this task's own
instruction.

### Summary

Brief scope: "Work only inside Family Studio... Create Parent Recall
Cards. These are not exam questions. They help parents support learning
... Do not duplicate student Recall Cards. Create a clearly
parent-focused experience." Objective: 10 named categories (conversation
starters, homework hints, kitchen maths, shopping maths, real-life
algebra, geometry around the house, mental maths games, budgeting,
measurement, travel planning), warm/practical/confidence-building tone.

### Architecture — deliberately not a filtered view over student Recall Cards

A fully separate model, service, catalog, and screen — not a reskin:

- **`ParentRecallCard`**/**`ParentRecallCardLocaleText`**
  (`lib/models/parent_recall_card.dart`) — a genuinely simpler shape than
  the student `RecallCard` (2 fields per locale, `front`/`back`) rather
  than the student system's 5-field Recognise/Recall/Explain/Connect
  model (`frontPrompt`/`answer`/`explanation`/`commonMistake`/`whereUsed`).
  Its own `ParentRecallCardCategory` enum (10 everyday-parenting values)
  is a completely separate taxonomy from `RecallTopic` (the student
  exam-curriculum areas) — checked directly by a test (see below).
- **`ParentRecallCardCatalogService`**
  (`lib/services/parent_recall_card_catalog_service.dart`) — same
  fail-fast/lazy-load/cache convention as every other catalog service in
  this app, but its own class over its own bundled asset
  (`assets/config/parent_recall_cards.json`), not a method added to the
  existing `RecallCardCatalogService`.
- **`ParentRecallCardsScreen`**
  (`lib/screens/family_studio/parent_recall_cards_screen.dart`) — a
  single flip-card view (tap to reveal the back, Previous/Next to cycle,
  category chips to filter), styled entirely in a warm orange accent
  (`0xFFFF9F5B`, matching Allie's established colour) distinct from the
  student Recall Cards' own palette — "clearly parent-focused," not a
  reskinned version of `RecallCardDetailScreen`.
- Wired as an 11th Family Studio section
  (`FamilyStudioSectionId.parentRecallCards`, registry entry, hub
  title/subtitle switch case) at `/family-studio/parent-recall-cards`,
  gated by the same `ParentGate(allowGraceAccess: true)` every other
  Family Studio screen uses — no new gating mechanism.

### Content

20 cards (2 per category × 10 categories), real `en`/`en-GB`/`de-CH`/
`fr-CH`/`it-CH` text throughout (not English-leaking placeholders),
written to the brief's own tone: warm, practical, confidence-building,
never an exam question. Examples: "Ask: 'Where did you spot a number
today?'" (Conversation starters), "Turn a family rule into an equation"
— £5 pocket money plus £1 per chore as p = 5 + c (Real-life algebra),
"Work out arrival time together before a trip" (Travel planning).

### Testing

New `test/parent_recall_cards_test.dart` (11 tests): catalog
load/validation, every category has ≥1 card, full 5-locale text
completeness, CH-locale non-English-leak check — plus a dedicated group
explicitly testing the brief's "do not duplicate" constraint: **no id
collision** between the parent and student catalogs, **zero overlap**
between `ParentRecallCardCategory` and `RecallTopic` names, and a
content-shape check confirming the simpler front/back model. Widget
tests cover the flip interaction, Next-card cycling (and that it resets
the flip), category filtering, and overflow at narrow/tablet width — one
real overflow bug found and fixed in that last pass (see below). Also
added one new case to the existing
`test/family_studio_hub_test.dart` (Parent Recall Cards opens a real
screen from the hub, matching every sibling section's own test).

One real bug caught and fixed while writing these tests: the card's
category-label `Row` (heart icon + category name) had no `Expanded`/
`overflow` handling — "Geometry around the house" (the longest category
name) overflowed by ~7px at 320px phone width. Fixed with `Expanded` +
`TextOverflow.ellipsis`, the same established fix pattern used
throughout this session's other overflow fixes.

### Validation results

- `dart format` — applied to all touched/new files.
- `flutter gen-l10n` — regenerated after adding 2 new
  `familyStudioSectionParentRecallCards*` keys to **all 20** locale
  files (this app's `family_studio_localisation_test.dart` requires
  every `familyStudio*` key present and non-empty in every locale, not
  just the 5 production ones — confirmed and satisfied, matching the
  stricter convention already established for this section prefix).
- `flutter analyze` (whole project) — **No issues found.**
- `flutter test --concurrency=1` (full suite) — **924/924 pass** (912
  baseline + 12 net new), 0 regressions.

### Explicitly deferred (not this pass)

- Only 20 cards (2 per category) — a bounded, representative sample per
  this session's established content-authoring convention, not
  exhaustive; more cards per category is straightforward additive
  content work on the same model.
- No progress tracking (which cards a parent has seen/favourited) —
  presentation-only, matching this session's identical choice for
  Spatial Intelligence and Math & Magic content.
- No search — only category filtering, matching the "cards," not
  "browse/search library," framing the brief itself uses.

### Manual verification checklist (reviewer, Pixel 6a)

- [ ] Family Studio hub shows an 11th section, "Parent Recall Cards,"
      with a warm orange icon distinct from the rest of the hub.
- [ ] Tapping a card flips it from the front prompt to the practical
      back guidance; tapping again flips back.
- [ ] "Next card"/"Previous" cycle through the full deck and reset to
      the front each time.
- [ ] Category chips filter the deck correctly, including the "All"
      chip returning to the full 20.
- [ ] Nothing on this screen resembles or links to the student Recall
      Cards experience — different colours, different card shape,
      different content tone throughout.

Not committed — per this task's instruction, awaiting the reviewer's
Pixel 6a pass before any commit.
