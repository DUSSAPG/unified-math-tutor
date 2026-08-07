# Aircraft Landing Lab — Build Report

Status: implemented, not yet committed. New Interactive Lab
(`InteractiveLabId.aircraftLandingLab`) at
`/math-studio/interactive-labs/aircraft-landing-lab`, per the explicit
post-RC1 decision logged in `docs/RC1_FEATURE_FREEZE.md` §8.

## Why a new lab, not a Flight Path Lab upgrade

The original brief framed this as "upgrade the existing Flight Path Lab."
Flight Path Lab teaches bearings + speed-distance-time via a top-down
radar view (heading/distance to a target); this lab teaches descent
angle/altitude/gradient/vectors via a side-profile view — a different
lesson, not a visual upgrade of the same one. Confirmed with the user
before building: **Flight Path Lab stays completely unchanged**; this
ships as its own `InteractiveLabId`, with both meant to anchor a future
aviation-lab collection (Flight Planning, Wind Correction, Holding
Patterns, cockpit view) rather than one replacing the other.

## Scope for this build

Per explicit user direction, this is a **side-profile-only, lightweight
v1** — no cockpit/pseudo-3D runway view (a validated-later follow-up), no
Rive, no free camera/viewpoint controls (a fixed side-profile *is* the
correct single viewpoint for this content — unlike the Cube Lab, adding
camera controls here would be decoration, not pedagogy). "More alive than
Flight Path Lab" comes from a genuine flight animation along the actual
descent path on "Test Approach" — Flight Path Lab has no animation at all,
its landing point just appears instantly.

## Files changed

**New — model layer:**
- `lib/models/flight_approach_model.dart` — `FlightApproachModel`
  (radians-internal, guarded math), `ApproachStatus`.
- `lib/models/aircraft_landing_challenge.dart` — deterministic
  `forIndex` generators for all 4 activities.

**New — engine widget layer** (mirrors `spatial_cube/`'s shape):
- `lib/widgets/labs/flight_approach/flight_approach_controller.dart` —
  `FlightApproachController` (model + flight-animation progress).
- `lib/widgets/labs/flight_approach/flight_approach_view.dart` —
  `FlightApproachView` + `_FlightApproachPainter`.
- `lib/widgets/labs/flight_approach/flight_approach_controls.dart` —
  `FlightApproachControls` (angle/speed sliders + Test Approach).

**New — persistence:**
- `lib/services/aircraft_landing_lab_progress_service.dart` —
  per-activity companion to `InteractiveLabsProgressService`, structurally
  identical to `SpatialCubeLabProgressService`.

**New — screens:**
- `lib/screens/labs/aircraft_landing_lab_hub_screen.dart` — free-play
  preview (starts already on the correct glide path) + 4 activity links.
- `lib/screens/labs/aircraft_landing/aircraft_landing_find_the_time_screen.dart`
- `lib/screens/labs/aircraft_landing/aircraft_landing_descent_line_screen.dart`
- `lib/screens/labs/aircraft_landing/aircraft_landing_glide_path_screen.dart`
- `lib/screens/labs/aircraft_landing/aircraft_landing_vector_approach_screen.dart`

**Changed (additive only):**
- `lib/models/interactive_lab_id.dart` — `aircraftLandingLab` added.
- `lib/app/router.dart` — `aircraft-landing-lab` route + 4 nested
  children under the existing `interactive-labs` route.
- `lib/screens/labs/interactive_labs_hub_screen.dart` — one new
  `RouteLinkCard`.
- `assets/config/studio_content_registry.json` — one new
  `lab-aircraft-landing` entry (learned this registry exists, and that
  skipping it fails `test/studio_content_registry_test.dart`, during the
  Spatial Cube Lab build).
- `lib/l10n/app_en.arb` + the 4 enforced locales (`app_en_GB.arb`,
  `app_de_CH.arb`, `app_fr_CH.arb`, `app_it_CH.arb`) — ~52 new
  `labsAircraftLanding*` keys.
- `test/labs_mobile_layout_test.dart` — the 5 new screens added to the
  existing viewport/text-scale matrix loop.

**New — tests:**
- `test/flight_approach_model_test.dart` (21 cases)
- `test/aircraft_landing_challenge_test.dart` (15 cases)
- `test/aircraft_landing_lab_progress_service_test.dart` (8 cases)
- `test/aircraft_landing_lab_widget_test.dart` (16 cases)

## The mathematical model

`FlightApproachModel` (`lib/models/flight_approach_model.dart`) — a
straight-line descent from `(groundDistanceM, startingAltitudeM)` toward
the runway threshold at `(0, 0)`.

**Units and sign convention**, documented in the file's doc comments:
- Angles are stored **internally in radians** (`descentAngleRadians`);
  `descentAngleDegrees` is a display-only convenience getter.
- `touchdownErrorM` is **positive** when the aircraft is still airborne
  past the runway threshold (too shallow/overshoot), **negative** when it
  touches down before reaching it (too steep/undershoot).
- `predictedTouchdownDistanceM` is the horizontal distance *covered*
  before reaching ground level — not "distance remaining to the runway."
  This tripped up an early draft of the doc comment (caught and fixed
  before shipping, see the model file's comment history) — worth flagging
  since it's an easy quantity to mislabel when reasoning about the
  painter's coordinate math.
- `touchdownPositionFromRunwayM` is the convenience the painter actually
  uses: `-touchdownErrorM`, in the same "distance remaining to the
  runway" terms as `altitudeAtHorizontalDistanceRemaining`'s input.

Every derived getter guards against non-finite/zero-denominator inputs
(descent angle clamped to a numerically safe 1°-60° range for
calculations, `airspeedMps`/`groundDistanceM`/`startingAltitudeM` treated
as 0 if negative or non-finite) — covered by
`flight_approach_model_test.dart`'s "invalid and non-finite inputs" group.

**No lateral/bearing dimension** exists in this model. A pure side-profile
view is inherently 2D (altitude × ground-distance); "Misaligned" from the
original brief's outcome list is explicitly out of scope this round, not
silently dropped.

## Activities and the shared-engine decision

Three of the four activities (Follow the Descent Line, Land on the Glide
Path, Vector Approach) use the shared `FlightApproachView`/
`FlightApproachController` engine. **Find the Time deliberately does
not** — it teaches `time = distance / speed` before angle enters the
picture at all (matching the original brief's Mode 1 description, which
never mentions altitude), so forcing the full descent-profile visual onto
a pure arithmetic word-problem would be decoration, not pedagogy. It uses
a small custom static diagram instead. This mirrors the same "reuse the
engine where it fits, build bespoke where it doesn't" judgment call the
Spatial Cube Lab's Cube Net Explorer already established with its own
separate painter.

Vector Approach adjusts horizontal/vertical speed **components** directly
via two custom sliders (not the shared angle/speed
`FlightApproachControls`), then derives `angle = atan2(vertical,
horizontal)` and `speed = sqrt(h² + v²)` to feed the same
`FlightApproachModel`/`FlightApproachView` for a consistent visual.

## Rendering / animation approach

- `_FlightApproachPainter` draws: ground-distance/altitude axes, runway,
  a dashed target glide path (the straight line from the start point to
  the runway threshold — by construction, exactly the required glide
  angle's graph), the actual descent path solid up to the current
  animation progress, a right-angle triangle with a descent-angle arc, an
  aircraft glyph rotated to the descent angle, and a touchdown marker.
- The flight animation always spans the full horizontal distance (start
  to the runway's x-position) regardless of when the aircraft actually
  reaches ground level — `altitudeAtHorizontalDistanceRemaining` clamps
  to `[0, startingAltitude]`, so a too-steep approach visibly "lands
  early and rolls" toward the runway, and a too-shallow one visibly
  "flies over" without touching down. No separate branching logic needed
  for the two cases.
- Reduce Motion (checked as `LocalPreferencesService.instance
  .reduceMotion.value || MediaQuery.disableAnimationsOf(context)`,
  matching `FlightPathLabScreen`'s existing convention exactly):
  `testApproach()` sets the animation controller's value straight to 1.0
  instead of animating — the full path/triangle/labels still render at
  their final, correct state, only the flight *motion* is skipped.

## Performance

- `FlightApproachController` is a `ChangeNotifier`; `FlightApproachView`
  rebuilds only itself via `ListenableBuilder`, not the whole screen.
- `_FlightApproachPainter.shouldRepaint` compares every field explicitly.
- Each activity screen disposes its own `FlightApproachController` (which
  disposes its internal `AnimationController`) in `dispose()`.
- Not yet profiled on physical Pixel 6a-class hardware — flagged below.

## Accessibility

- `FlightApproachView`'s `Semantics(image: true)` label is the brief's
  own example format: "Aircraft altitude 300 metres, runway distance 5.7
  kilometres, descent angle 3 degrees, predicted landing 40 metres beyond
  target" — rebuilt from the live model/progress on every listener
  notification.
- Sliders (`Slider` with `key`s for testability) are inherently
  screen-reader- and keyboard-operable; "Test Approach" is a standard
  `FilledButton`.
- Result banners (`LabResultBanner`) never rely on colour alone — icon +
  colour + text for safe/too-steep/too-shallow.

## Hardware review still required

- Physical Pixel 6a check: flight-animation frame pacing, slider drag
  responsiveness.
- Screenshots needed: hub free-play preview, each activity's
  pre-test/post-test states, portrait vs. landscape phone, tablet
  two-column layout, dark and light theme, Reduce Motion's instant-jump
  result.

## Explicitly deferred (future phases, per the user's stated
aviation-collection direction)

- **Cockpit/pseudo-3D runway approach view** — validated-later follow-up
  once the side-profile mechanics are confirmed to teach well.
- **Mode 5 "Approach Controller"** (multi-variable optimisation) from the
  original brief — not built; the four shipped activities cover Modes
  1-4.
- **Lateral/bearing "Misaligned" dimension** — would require either a
  top-down component or a true 3D model; out of scope for a side-profile
  lab.
- **Rive-driven flourishes** (landing gear, flap state, warning lights) —
  explicitly not used this round; everything is `CustomPainter` +
  `AnimationController`, per the brief's constraint.
- Future labs in the collection (Flight Planning, Wind Correction,
  Holding Patterns) are new, separate `InteractiveLabId`s when built, not
  modes bolted onto this one.

## Test results

- `flutter analyze`: clean (no new issues).
- `dart format .`: clean.
- `flutter test --concurrency=1`: full suite green, including the 4 new
  aircraft-landing-specific files (60 new test cases) and the 5 new
  screens added to `labs_mobile_layout_test.dart`'s existing
  viewport/text-scale matrix.
