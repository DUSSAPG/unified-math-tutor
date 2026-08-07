# Feed the Hungry Panda — Build Report

Status: **PASS**. Do not commit (per instruction) — all changes remain in
the working tree alongside the rest of the pre-existing uncommitted work.

## What this sprint proves

The brief was explicit that this is not an art-production sprint — it
exists to prove two things work end to end: the **child interaction**
(drag/tap a fruit one at a time onto Panda, with a fully equivalent
keyboard/tap-only path) and the **deterministic learning model** (a
seeded generator, a separated round-state controller, and a
self-clearing gentle-response model with no punitive states). Both are
real, tested, and wired into the app through the existing Interactive
Labs pathway — not a prototype bolted on separately.

## Repository / governance confirmation

- Repo root confirmed: `D:\AI\Quantumlab\apps\edex\unified_math_tutor`.
- `git status` preserved throughout — no reset/clean/stash. The
  pre-existing large uncommitted tree (in-progress RC2 work) is
  untouched apart from this sprint's own additive files.
- `docs/RC1_FEATURE_FREEZE.md` §8 was audited before writing any code:
  the Math Studio hub is frozen at exactly six pillars, and the
  established pattern for new native-Flutter interactive content is an
  additive `InteractiveLabId` under `/math-studio/interactive-labs/`
  (the same route Aircraft Landing Lab and Spatial Cube Lab used) —
  **not** a new pillar. This sprint followed that precedent exactly and
  logged a new dated changelog entry, matching every prior lab
  addition's governance trail.

## Route and registration (proposed before editing, then built)

- **Early Maths Playground** — `InteractiveLabId.earlyMathsPlayground`,
  hub screen at `/math-studio/interactive-labs/early-maths-playground`,
  one new `RouteLinkCard` in `interactive_labs_hub_screen.dart`.
- **Feed the Hungry Panda** — nested route at
  `/math-studio/interactive-labs/early-maths-playground/feed-the-hungry-panda`,
  reached via a `RouteLinkCard` on the playground hub.
- One new `assets/config/studio_content_registry.json` entry
  (`lab-early-maths-playground`, `contentType: interactiveLab`,
  `sourceId: earlyMathsPlayground`), required by the existing
  `studio_content_registry_test.dart` invariant that every
  `InteractiveLabId` is registered exactly once — the same step every
  prior lab addition took.

## Architecture

Deliberately **not** one `StatefulWidget` holding everything — four
separated layers, per the brief:

1. **Challenge data** (`lib/models/feed_panda_challenge.dart`) —
   `FeedPandaChallenge.forSeed(int seed)`: a pure factory that calls
   `math.Random(seed)` exactly once, producing the target count (1-3),
   a stable set of 5 apple ids in a seed-determined display order, and
   the remaining-quantity multiple-choice options (always including the
   correct answer, seed-ordered). Never called from a widget directly —
   only from the round controller.
2. **Round state** (`lib/widgets/labs/feed_panda/feed_panda_round_controller.dart`)
   — `FeedPandaRoundController extends ChangeNotifier` (Flutter's
   built-in observable; no new state-management package). Owns the
   phase state machine (`instruction → feeding → chewTransition →
   askRemaining → roundComplete`), which fruit are accepted, the
   tap-to-select selection, the gentle-reminder flag, and emits
   `FeedPandaEvent`s via an `onEvent` callback. 100% testable without
   pumping a widget tree (see `test/feed_panda_round_controller_test.dart`,
   17 pure-Dart tests).
3. **Panda visual state** (`lib/models/panda_visual_state.dart`) — a
   5-value enum (`waiting`, `ready`, `chewing`, `happy`,
   `gentleReminder`) that is the *entire* contract between the
   controller and however Panda is drawn. The controller never
   constructs or references a widget.
4. **Presentation widgets** (`lib/widgets/labs/feed_panda/*.dart`,
   `lib/screens/labs/feed_panda/feed_the_hungry_panda_screen.dart`) —
   read the controller's state and the visual-state enum; own no game
   logic themselves.

### Progress-event seam

`lib/services/feed_the_hungry_panda_progress_service.dart` mirrors the
established sibling-service pattern (`SpatialCubeLabProgressService`,
`RecallCardsProgressService`): a learner-profile-namespaced
`SharedPreferences`-backed singleton with a `ValueNotifier<int>
updateSerial`. The round controller has zero persistence knowledge —
the screen wires `FeedPandaRoundController(onEvent:
FeedTheHungryPandaProgressService.instance.recordEvent)`. All 9 named
events from the brief exist as `FeedPandaEventType` values
(`activityStarted`, `fruitSelected`, `correctFruitAccepted`,
`dropReturned`, `targetReached`, `remainingAnswerCorrect`,
`remainingAnswerRetry`, `roundCompleted`, `roundRestarted`), each
carrying the learning-evidence fields the brief asked for (target
amount, accepted count, attempts, `usedDrag` for input-mode tracking,
remaining-answer attempts, completion status). No network calls
anywhere.

## Deterministic challenge rules (Round 1)

- Apples only; always exactly 5 available; target always 1-3.
- Same seed ⇒ identical target, fruit order, and answer-choice order
  (verified: `test/feed_panda_challenge_test.dart`, 11 tests, including
  a 500-seed sweep asserting the round-1 content rules always hold and
  a 30-seed sweep confirming real variation — all 3 targets appear,
  fruit ordering varies).
- "New Round" advances through a governed, predictable seed sequence
  (`FeedPandaRoundController.nextSeed = seed + 1`) rather than a fresh
  random seed each time — reproducible and testable.
- "Replay instruction" (the Replay button) reloads the *same* seed's
  challenge from scratch, clearing in-progress feeding.

## Behaviour compliance

- Every apple has a stable id (`apple-0`..`apple-4`), assigned once per
  challenge and never reused mid-round.
- An accepted apple is removed from `FruitMatrix`'s visible set
  immediately (`acceptedFruitIds` filter) — it structurally cannot be
  re-dragged or re-tapped, proven by
  `test/feed_the_hungry_panda_widget_test.dart`'s "leaves the source
  matrix" test.
- `canAccept()` is the single gate for acceptance: wrong phase, already
  accepted, or target already reached all return `false` — verified at
  both the controller level (duplicate acceptance ignored; overfeeding
  prevented) and the widget level (real drag-and-drop and real
  tap-to-select paths, via `TestGesture`).
- Input lock during the chew transition (`FeedPandaPhase.chewTransition`,
  `inputLocked` getter) — a real, tested state, not just a visual cue.
- A drag dropped outside Panda returns to source (`Draggable`'s own
  default cancel behaviour — no custom "snap back" animation code
  needed) — verified with a genuine `TestGesture` drag ending away from
  the drop target.
- The gentle response ("Panda has enough. Let's count together.") is a
  self-clearing banner (`_gentleReminderActive`, auto-clears after
  ~1.4s) — never a red/error colour, never a buzzer, no lost points, no
  countdown displayed to the learner.

## Responsive design

No fixed coordinates anywhere. `FruitMatrix` and
`RemainingAnswerChoices` both use `LayoutBuilder` to size tiles from
available width (clamped to a comfortable 48-120px tap-target range),
wrapping via `Wrap` rather than assuming a fixed column count. The
whole screen sits in a `SingleChildScrollView` inside a
width-constrained `Center`, so tall content (large text scale, narrow
phones) scrolls instead of overflowing. Tested at 320×568 (compact
phone), 390×844 (Pixel 6a portrait), 768×1024 (tablet), and 1280×800
(wide desktop/web), plus text scales 1.0/1.3/1.6 (S/M/L reading
sizes) — all pass with no overflow exception.

## Accessibility model

- **Drag-and-drop**: real `Draggable`/`DragTarget` (Flutter's built-in
  widgets — first use of them in this codebase, chosen because they
  give correct default "return to source on rejected drop" behaviour
  for free and integrate cleanly with Semantics).
- **Tap-to-select then tap Panda**: a fully equivalent second path
  (`FruitTile.onSelect` / `_PandaSection`'s tap handler) — every widget
  test in this sprint that completes a round does so via the tap path,
  proving dragging is never required.
- **Keyboard activation**: each `FruitTile` is wrapped in
  `FocusableActionDetector` with `Enter`/`Space` bound to the same
  `ActivateIntent` the tap path uses — verified with a real
  `tester.sendKeyEvent(LogicalKeyboardKey.enter)` test that focuses a
  tile, activates it via keyboard, then completes an acceptance by
  tapping Panda.
- **Semantic labels**: fruit tiles expose exactly the brief's example
  format, `"Apple {position} of {total}. Double tap to select."`
  (verified via `find.bySemanticsLabel`); Panda's drop target exposes
  `"Feed Panda. {remaining} more apple(s) needed."` while feeding, and
  a "Panda has enough for this round." label once done.

## Visual replacement seam

`PandaVisualState` (5 values) is the *only* contract between game logic
and Panda's appearance. RC1 ships `PandaVisual`
(`lib/widgets/labs/feed_panda/panda_visual.dart`), a `CustomPainter`
built entirely from native shapes (circles, ovals, paths) — no emoji,
no third-party art. `AppleVisual` is the equivalent placeholder for
fruit. A future governed Rive file or sprite-atlas animation can
replace either widget's body wholesale: nothing outside these two files
needs to change, because the controller and every other widget only
ever pass a `PandaVisualState` enum value in.

## Motion / Reduce Motion

`LocalPreferencesService.instance.reduceMotion.value ||
MediaQuery.disableAnimationsOf(context)` — the app's established dual
check — gates:
- The chew-transition delay: 700ms normally, 50ms under Reduce Motion
  (a state change, not a lengthy animated pause).
- `PandaVisual`'s `AnimatedScale` transition duration: 260ms normally,
  `Duration.zero` under Reduce Motion (an instant state swap, not a
  bounce).
- No animation anywhere loops, bounces, or shakes — the celebratory
  "happy" state is a single restrained scale-up, not a repeating
  effect.

Verified with a dedicated Reduce Motion widget test and confirmed the
production controller correctly reads the live `reduceMotion` value on
every build (not just at construction).

## Voice cue inventory (not wired to audio this sprint)

`lib/models/feed_panda_voice_cues.dart` defines the exact 9 ids named
in the brief as stable constants: `feed_panda_instruction_1/2/3`,
`feed_panda_count_1/2/3`, `feed_panda_well_done`,
`feed_panda_has_enough`, `feed_panda_how_many_left`, plus
`instructionFor(targetCount)`/`countFor(targetCount)` helpers to pick
the right cue for the active target. **No live TTS is implemented** —
the activity works fully with voice disabled, since nothing in the
controller or screens depends on these ids producing sound. They are
deliberately kept as a small, self-contained set rather than added to
`captain_math_narration_manifest.json`, whose `NarrationMessage.labId`
is typed to `InteractiveLabId` and existing `NarrationTrigger` shapes
this activity's per-target-count cues don't map onto 1:1 — a Level 2
sprint should decide whether to widen that seam or keep this one
separate.

## Localisation

All learner-facing strings use `AppLocalizations` with ICU plural
forms where needed (e.g. `"Feed Panda {count, plural, =1{1 apple}
other{{count} apples}}."`), matching the examples in the brief exactly.
Translated into all 5 enforced production locales (en, en-GB, de-CH,
fr-CH, it-CH) — en-GB mirrors en (no UK-specific spelling needed for
these strings), de-CH/fr-CH/it-CH are genuine translations following
the catalog's established ASCII-safe convention. The existing
`test/math_studio_l10n_completeness_test.dart` was extended with 3 new
prefix exemptions (`feedPanda`, `feedTheHungryPanda`,
`earlyMathsPlayground`) so it actively enforces non-English-leaking
translations for every new key, the same governance every other labs
area gets.

## Progress / learning-evidence events

All 9 events from the brief are modelled (`FeedPandaEventType`), each
event capturing seed, target amount, accepted count, attempt count,
input mode (`usedDrag`), remaining-answer attempts, and completion
status where relevant. `FeedTheHungryPandaProgressService` persists
rounds-completed count, last-played seed, per-event-type counts, and a
snapshot of the most recently completed round's learning-evidence
fields — all local, all learner-profile-namespaced, no network calls.

## Tests added (61)

- `test/feed_panda_challenge_test.dart` (11) — determinism for a fixed
  seed, target always 1-3 and exactly 5 unique apples across 500 seeds,
  answer-choice correctness/uniqueness/range, governed-seed variation.
- `test/feed_panda_round_controller_test.dart` (17) — pure-Dart round
  state machine: single/duplicate acceptance, exact-count completion,
  overfeeding prevention, chew-transition input lock, wrong/correct
  remaining answers (including multiple tolerated retries), restart
  reproducing the same challenge, New Round advancing to the exact
  governed next seed, tap-to-select toggling, and event emission for
  every event type including `usedDrag` tracking.
- `test/feed_the_hungry_panda_progress_service_test.dart` (8) — event
  counting, seed persistence, learning-evidence snapshotting on
  completion, per-learner-profile isolation.
- `test/feed_the_hungry_panda_widget_test.dart` (25) — real drag
  acceptance and drop-outside-target via genuine `TestGesture` drags,
  tap-to-select acceptance, duplicate-acceptance structural prevention,
  full round completion, wrong-answer gentle retry, the gentle
  overfeed reminder banner, Reduce Motion, semantic labels (fruit tile
  format and Panda's remaining-count label), real keyboard activation,
  no-overflow across 3 viewport sizes and 3 text scales, light/dark
  theme, and 5 real-router navigation tests (hub entry card → Early
  Maths Playground → Feed the Hungry Panda, direct deep link, back
  navigation, repeat route entry).

Total suite: **1230/1230 passing** (1169 before this sprint + 61 new),
after `dart format .` (cosmetic only) and `flutter analyze` (0 issues).

## Real bug found and fixed during this sprint

The controller starts in `FeedPandaPhase.instruction` and only accepts
fruit once `beginFeeding()` is called — but the screen never called it,
so every acceptance attempt silently failed (`canAccept()` requires
`phase == feeding`). Caught by the widget tests, not assumed away: the
first "tap-to-select then tap Panda" test failed with `0 / 3` instead
of `1 / 3`, traced via debug instrumentation to the missing
`beginFeeding()` call, and fixed in
`feed_the_hungry_panda_screen.dart`'s `initState` (called before the
listener is attached, so the resulting `notifyListeners()` can't
trigger `setState()` before the widget's first build).

## Unresolved risks / deferred to Level 2

- **No live voice** — cue ids exist but produce no sound yet; wiring
  real audio requires either widening `NarrationMessage.labId`/trigger
  shapes or a small parallel manifest, plus actual approved audio
  assets (out of scope this sprint, per explicit instruction).
- **Visual placeholder art** — Panda and the apple are native-shape
  placeholders by design this sprint; a governed Rive/sprite-atlas
  asset is expected later, and the `PandaVisualState`/`AppleVisual`
  seam is built specifically to make that swap non-breaking.
- **One activity only** — Early Maths Playground's hub is built to list
  more than one activity, but only Feed the Hungry Panda exists; the
  hub screen and `InteractiveLabId` registration don't need to change
  to add a second one later.
- **Fruit-type selection UI** — Round 1 uses apples only (per explicit
  scope), so there's no "identify the requested fruit among several
  types" UI yet; the challenge model's `fruitIds` are already
  fruit-agnostic strings, so a future round introducing a second fruit
  type is additive to the generator, not a rewrite.
- **No resume-mid-round** — `lastSeed()` lets a future session start on
  the same seed the learner last played, but an in-progress round
  (partially fed) isn't itself persisted/restored on app restart —
  reasonable for RC1 given the whole activity is deliberately short
  and low-stakes.

## Pixel 6a hardware checklist (still required — not verifiable from this environment)

- [ ] Real-device drag gesture feel (touch-slop, feedback offset under
      finger) on Pixel 6a portrait and the one supported landscape
      orientation.
- [ ] On-device Reduce Motion (Android "Remove animations"
      accessibility setting) actually maps to
      `MediaQuery.disableAnimationsOf` as expected.
- [ ] TalkBack pass over the fruit tiles and Panda drop target's
      semantic labels, confirming the "Double tap to select" / "N more
      apples needed" phrasing reads naturally aloud.
- [ ] Real device text-scale (Android's own accessibility text-size
      slider, not just Flutter's `TextScaler`) at the largest OS
      setting, confirming no clipping in the instruction banner or
      answer-choice buttons.
- [ ] Battery/thermal check during a longer play session (the
      `CustomPainter` Panda repaints only on state change, not every
      frame, but this hasn't been profiled on-device).

## Return

- **PASS/FAIL:** PASS.
- **Files changed:** New: `lib/models/{panda_visual_state,
  feed_panda_challenge, feed_panda_event, feed_panda_voice_cues}.dart`,
  `lib/widgets/labs/feed_panda/{feed_panda_round_controller,
  panda_visual, apple_visual, fruit_tile, fruit_matrix,
  remaining_answer_choices}.dart`,
  `lib/services/feed_the_hungry_panda_progress_service.dart`,
  `lib/screens/labs/early_maths_playground_hub_screen.dart`,
  `lib/screens/labs/feed_panda/feed_the_hungry_panda_screen.dart`,
  `docs/FEED_THE_HUNGRY_PANDA_BUILD_REPORT.md`, 4 new test files.
  Changed: `lib/models/interactive_lab_id.dart` (additive enum value),
  `lib/app/router.dart` (2 additive routes), `lib/screens/labs/
  interactive_labs_hub_screen.dart` (1 new entry card),
  `assets/config/studio_content_registry.json` (1 new entry),
  `lib/l10n/app_en.arb`/`app_en_GB.arb`/`app_de_CH.arb`/`app_fr_CH.arb`/
  `app_it_CH.arb` (new keys), `test/math_studio_l10n_completeness_test.dart`
  (3 new prefix exemptions), `docs/RC1_FEATURE_FREEZE.md` (changelog
  entry).
- **Route and entry point:** `/math-studio/interactive-labs/early-maths-playground`
  (hub) → `/math-studio/interactive-labs/early-maths-playground/feed-the-hungry-panda`
  (activity), reached via a new entry card on the existing Interactive
  Labs hub — no bottom-nav change.
- **Architecture used:** deterministic seeded generator (pure model) →
  `ChangeNotifier` round controller (pure Dart, no widget dependency)
  → `PandaVisualState` enum contract → native-shape presentation
  widgets, with a separate learner-namespaced local progress/event
  service. No Provider/Riverpod/Bloc — Flutter's built-in
  `ChangeNotifier` only.
- **Tests added:** 61 (11 generator, 17 controller, 8 progress
  service, 25 widget/navigation).
- **Total test count:** 1230/1230 passing.
- **Localisation status:** fully localised into all 5 enforced
  locales (en, en-GB, de-CH, fr-CH, it-CH); the l10n completeness test
  now covers these keys too.
- **Reduce Motion behaviour:** chew-transition delay collapses from
  700ms to 50ms (state change, not animation); Panda's scale transition
  collapses to `Duration.zero`; no looping/bouncing/shaking animation
  exists in either mode.
- **Accessibility alternatives:** drag-and-drop, tap-to-select +
  tap-Panda, and keyboard (`Enter`/`Space` via `FocusableActionDetector`)
  are all independently sufficient to complete the activity — verified
  by dedicated tests for each path.
- **Confirmation:** Flame, Rive, and runtime Python were **not** added.
  No new state-management package was added (`ChangeNotifier` is
  built into Flutter). No timers, scores, streaks, penalties, or
  competitive mechanics exist anywhere in this feature.
- **Pixel 6a checks still required:** see the hardware checklist above
  (real-device drag feel, OS-level Reduce Motion mapping, TalkBack
  pass, OS-level text-scale, battery/thermal profiling) — none of
  these are verifiable from this environment.

No commit made, per instruction.
