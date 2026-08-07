# Spatial Cube Lab — Build Report

Status: implemented, not yet committed. New Interactive Lab
(`InteractiveLabId.spatialCubeLab`) at
`/math-studio/interactive-labs/spatial-cube-lab`, per the explicit
post-RC1 decision logged in `docs/RC1_FEATURE_FREEZE.md` §8.

## Why Interactive Labs, not the Spatial Intelligence pillar

`docs/SPATIAL_INTELLIGENCE_BACKLOG.md` (lines 44-49) had already called
this: a genuinely *manipulable* cube (drag to rotate, fold) "would cross
into the kind of dedicated interactive lab Interactive Labs already
hosts... it likely belongs there as a new Interactive Lab, not as more
Spatial Intelligence hub content." This build follows that precedent —
Interactive Labs already has the full guided-lab shell (`LabScaffold`,
Captain Math narration, progress tracking, first-use walkthroughs) that a
stateful, multi-activity cube lab needs, and the Spatial Intelligence
pillar's own 4 activities remain untouched. The pillar's existing generic
"Interactive Labs" entry card already links here — no new cross-link was
needed.

## Files changed

**New — geometry/model layer:**
- `lib/models/spatial_cube_face.dart` — `CubeFace` enum, fixed
  `kOppositeFace` pairing, `CubeFaceContent` (label + colour).
- `lib/models/spatial_cube_orientation.dart` — `CubeOrientation`
  (yaw/pitch logical model), perspective `project()`, `CubeSnapTarget`,
  shared `projectCameraSpacePoint()`, `cubeFaceLocalCorners()`.
- `lib/models/spatial_cube_net.dart` — `CubeNet`/`CubeNetCell`, 4 curated
  nets (2 valid, 2 invalid), flat/folded corner geometry per cell.
- `lib/models/spatial_cube_challenge.dart` — deterministic challenge
  generators for the 3 quiz activities (`forIndex`, no `Random()`).

**New — engine widget layer:**
- `lib/widgets/labs/spatial_cube/spatial_cube_controller.dart` —
  `SpatialCubeController` (drag/inertia/snap/reset/keyboard/auto-demo).
- `lib/widgets/labs/spatial_cube/spatial_cube_widget.dart` — `SpatialCube`
  widget + `_SpatialCubePainter`.
- `lib/widgets/labs/spatial_cube/spatial_cube_controls.dart` —
  `SpatialCubeControls` (snap/reset/demo button rail).

**New — persistence:**
- `lib/services/spatial_cube_lab_progress_service.dart` — per-activity
  companion to `InteractiveLabsProgressService` (completed activities,
  best attempt count, hints used, last activity, How-It-Works-seen).

**New — screens:**
- `lib/screens/labs/spatial_cube_lab_hub_screen.dart` — mini-hub with a
  free-play cube preview + links to the 4 activities.
- `lib/screens/labs/spatial_cube/spatial_cube_which_face_opposite_screen.dart`
- `lib/screens/labs/spatial_cube/spatial_cube_rotate_to_match_screen.dart`
- `lib/screens/labs/spatial_cube/spatial_cube_hidden_face_screen.dart`
- `lib/screens/labs/spatial_cube/spatial_cube_net_explorer_screen.dart`

**Changed (additive only):**
- `lib/models/interactive_lab_id.dart` — `spatialCubeLab` added to the
  enum.
- `lib/app/router.dart` — `spatial-cube-lab` route + 4 nested children
  under the existing `interactive-labs` route. No `parentNavigatorKey`
  needed (`/math-studio` is already outside the bottom-nav shell).
- `lib/screens/labs/interactive_labs_hub_screen.dart` — one new
  `RouteLinkCard`.
- `assets/config/studio_content_registry.json` — one new `interactiveLab`
  entry (`lab-spatial-cube`, `sourceId: spatialCubeLab`), matching the
  shape of the existing `lab-football-precision`/`lab-data-detective`
  entries. Discovered via `test/studio_content_registry_test.dart`'s
  "every `InteractiveLabId` is represented exactly once" completeness
  check — a governance system this build's initial research pass hadn't
  surfaced, caught by running the full suite rather than only the new
  tests.
- `lib/l10n/app_en.arb`, `app_en_GB.arb`, `app_de_CH.arb`, `app_fr_CH.arb`,
  `app_it_CH.arb` — ~54 new `labsSpatialCube*` keys (the 5 locales
  `test/math_studio_l10n_completeness_test.dart` enforces for the `labs`
  prefix). In-activity dynamic quiz content (net explanations, the
  foldability Yes/No prompt) is English-only, matching the existing
  `cube_nets_screen.dart` precedent noted in
  `docs/SPATIAL_INTELLIGENCE_BACKLOG.md`.
- `test/labs_mobile_layout_test.dart` — the 5 new screens added to the
  existing viewport/text-scale matrix loop.

**New — tests:**
- `test/spatial_cube_orientation_test.dart` (19 cases)
- `test/spatial_cube_challenge_test.dart` (18 cases)
- `test/spatial_cube_lab_progress_service_test.dart` (7 cases)
- `test/spatial_cube_lab_widget_test.dart` (22 cases)

## Architectural decisions

**Yaw/pitch Euler model instead of quaternions/`vector_math`.** A repo
audit found zero use of `Matrix4`/`vector_math` anywhere in `lib/` —
every existing "3D-ish" screen (Cube Nets, Rotations, Transformations, the
Flight Path Lab's radar/aircraft painters) hand-rolls `sin`/`cos` trig on
plain coordinates instead, matching `RC1_FEATURE_FREEZE.md` §4's "full 3D
graphics engine" deferral. `CubeOrientation` follows that convention: two
accumulated `double` angles (yaw about the world-vertical axis, pitch
about the world-horizontal axis, composed in a fixed order), no new
dependency added to `pubspec.yaml`. Every required invariant — opposite
faces, four quarter-turns returning to the start, inverse rotations
cancelling, snap targets, constrained camera angles — falls out of plain
arithmetic on those two numbers plus an angular-tolerance comparison
(`isCloseTo`) via the six rotated face normals.

**Perspective projection.** `screenScale = focalLength / (focalLength +
depth)`-shaped: `projectCameraSpacePoint()` computes
`scale = focalLength / (cameraDistance + z)`, clamped defensively against
non-finite/zero depth. The interactive cube uses `cameraDistance: 4`
(tuned to fill its widget); the Cube Net Explorer reuses the *same*
function with a wider `cameraDistance: 11` so a flat, multi-square net and
its eventual small folded cube both fit the same frame — an honest "big
net becomes a small cube" scale relationship rather than an artificial
rescale.

**Cube Net Explorer fold is a corner morph, not a rigid hinge simulation.**
Each cell's 4 corners are linearly interpolated from their flat-net
position to their exact target `CubeFace` position (`cubeFaceLocalCorners`)
as a single `t ∈ [0,1]` progresses. This is deliberately simpler than
simulating per-cell hinge rotations through a fold tree: it's fully
deterministic and correct at both keyframes (t=0 exactly matches the flat
net layout, t=1 exactly matches `CubeOrientation.initial`'s face
geometry — both asserted in `spatial_cube_challenge_test.dart`), at the
cost of not being a strictly rigid paper-fold motion in between. Net
validity is curated (`CubeNet.isValid`, hand-verified per net), matching
`cube_nets_screen.dart`'s existing approach rather than building a general
net-folding validator.

**Net cell colours are neutral until folded.** Flat net cells use a
position-indexed decorative palette (matching `cube_nets_screen.dart`'s
`_faceColors` precedent), cross-fading to the true `CubeFace` colour as
`foldT` progresses — pre-colouring cells by their destination face would
make the "predict which squares end up opposite" exercise trivially
solvable by colour-matching instead of genuine spatial reasoning.

**No Rive/Flame/`vector_math` dependency added.** Everything is
`CustomPainter` + hand-rolled trigonometry + `AnimationController`/`Ticker`,
per the brief's constraint and the existing codebase convention.

## Rendering / performance considerations

- `SpatialCubeController` extends `ChangeNotifier`; the `SpatialCube`
  widget listens and calls `setState` only on orientation change — no
  full-screen rebuild per frame.
- `_SpatialCubePainter`/`_NetFoldPainter` are `@immutable`-shaped with
  explicit field-by-field `shouldRepaint` (never `true`/structural
  inequality).
- Face culling (skip back-facing quads) plus painter's-algorithm
  depth-sort keeps the interactive cube to ≤3 drawn quads per frame at
  any orientation (asserted by
  `spatial_cube_orientation_test.dart`'s "always exactly 3 faces visible"
  case).
- Auto-demo and inertia both stop themselves once their driving
  `AnimationController`/`Ticker` settles (`stopAutoDemo`/`stopInertia`);
  neither lab screen keeps a controller animating once the learner
  navigates away, since the screen's `dispose()` disposes the
  `SpatialCubeController`, which disposes its own controllers/ticker.
- Not yet profiled on physical Pixel 6a-class hardware — flagged below.

## Accessibility

- Reduce Motion (`LocalPreferencesService.instance.reduceMotion` **and**
  `MediaQuery.disableAnimationsOf`, checked together, matching
  `FlightPathLabScreen`'s existing `_motionEnabled` pattern) removes drag
  inertia, makes snap/reset instant, replaces the continuous auto-demo
  spin with a discrete 6-step "next face" control, and replaces the Cube
  Net Explorer's continuous fold with discrete Back/Next-step buttons
  through 5 fixed keyframes.
- The cube's `Semantics(image: true)` label is a plain-language
  orientation description ("Red face at the front. White face at the
  top."), rebuilt only on drag-end/snap/reset/keyboard-nudge, not every
  drag frame.
- Keyboard: arrow keys rotate the focused cube in fixed 11° increments;
  every other control (snap/reset/demo/answer chips/Fold/Unfold) is a
  standard `IconButton`/`OutlinedButton`/`FilledButton`, inherently
  keyboard-operable via Tab+Enter.
- Answer choices are text chips with `Semantics(button: true, label:
  ...)`, never colour-only.
- Touch targets: snap/reset/demo buttons enforce a 48×48 minimum via
  `BoxConstraints`.

## Hardware review still required

- Physical Pixel 6a check: drag responsiveness/frame pacing for the
  cube's continuous rotation and inertia decay.
- Physical device check of the Cube Net Explorer's fold animation at
  default (non-reduced) motion — the corner-morph approach hasn't been
  visually reviewed outside the simulator/desktop test harness.
- Screenshots needed for hardware review: hub free-play preview, each of
  the 4 activity screens in their answered/feedback state, portrait vs.
  landscape phone, tablet two-column-adjacent layout, dark and light
  theme, Reduce Motion's stepped fold sequence.

## Remaining Rubik's Cube backlog (explicitly deferred)

Per the brief, no 2×2/3×3 mechanics are implemented. The data model is
shaped to allow a later phase to add them without restructuring
`CubeOrientation`/`CubeFace`:

- **`RubikCubeMove` (future, undocumented-in-code today, captured here
  as the design note the brief asked for):** `{ face: CubeFace (U/D/L/R/F/B
  equivalent), direction: clockwise | anticlockwise | double }`, a
  `List<RubikCubeMove>` move-sequence type, an `undo()` that pops the
  inverse of the last move (`clockwise`↔`anticlockwise`, `double` is its
  own inverse), and a deterministic scramble generator seeded the same way
  `OppositeFaceChallenge.forIndex` etc. already are (index/seed → fixed
  sequence, no unseeded `Random()`).
- 2×2/3×3 cube mechanics, cuboids, surface-area/volume tasks, coordinate
  transformations, voxel counting, and imported 3D models are all
  out of scope for this build — `CubeOrientation`'s projection and
  `CubeFace`'s fixed opposite-pairing are the reusable primitives a later
  phase would build on, not a full solver.

## Test results

- `flutter analyze`: clean (no new issues).
- `dart format .`: clean.
- `flutter test --concurrency=1`: full suite green, including the 4 new
  spatial-cube-specific files (66 new test cases) and the 5 new screens
  added to `labs_mobile_layout_test.dart`'s existing viewport/text-scale
  matrix.
