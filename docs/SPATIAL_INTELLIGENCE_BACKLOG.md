# Spatial Intelligence — Remaining Backlog

Status: reference document, not a build plan. Records what was deliberately
left out of the RC1-minimum content ship (see `docs/RC1_FEATURE_FREEZE.md`
§8, 2026-08-02) so it isn't lost or silently re-discovered later. None of
this is scheduled — it requires its own future decision, same as the
original "in development" state did.

## What shipped (the RC1 minimum)

4 real, self-contained interactive activities, reachable from the Spatial
Intelligence hub (`/math-studio/spatial-intelligence`):

- **Cube Nets** (`/math-studio/spatial-intelligence/cube-nets`) — 4
  hand-picked nets (2 valid, 2 invalid), "does this fold into a cube?"
  with feedback and an explanation.
- **Rotations** (`/math-studio/spatial-intelligence/rotations`) — a
  single L-shaped tile, rotated about a fixed centre via a continuous
  slider or 90°/180°/270° preset buttons.
- **Transformations** (`/math-studio/spatial-intelligence/transformations`)
  — the same shape, with a picker across the 4 classic transformations
  (translate, reflect, rotate, enlarge), each with its own simple
  parameter control, always shown against the original outline.
- **Spatial Puzzles** (`/math-studio/spatial-intelligence/spatial-puzzles`)
  — 5 fixed multiple-choice puzzles (cube counting, mirror-image
  identification, and 3D-shape face/edge/vertex facts), untimed and
  unscored.

Every activity uses 2D `CustomPaint` diagrams, not a 3D rendering engine —
matching `RC1_FEATURE_FREEZE.md` §4's existing "Full 3D graphics engine"
deferral, which this sprint does not revisit.

## Explicitly deferred

- **More cube nets** — only 4 of the 11 mathematically valid hexomino
  cube nets are covered; a fuller set (and covering non-cube solids, e.g.
  a net for a triangular prism or square pyramid) is future content
  authoring, not an architecture gap.
- **A real fold animation** — Cube Nets currently shows the flat net and,
  on a correct/incorrect answer, only text feedback; an actual animated
  2D→3D fold (or an isometric "this is what it becomes" reveal) would be
  a meaningfully bigger, higher-risk animation effort, not a "simple
  interactive demonstration."
  Note: an animated fold that is *directly manipulable* (the user drags to
  fold the net) would cross into the kind of dedicated interactive lab
  Interactive Labs already hosts — if that's ever wanted, it likely
  belongs there as a new Interactive Lab, not as more Spatial Intelligence
  hub content, per `RC1_FEATURE_FREEZE.md` §3's existing Interactive
  Labs/pillar split.
- **More shapes for Rotations/Transformations** — currently one shared
  L-shaped tile (`spatial_shapes.dart`'s `kLShape`); adding more shape
  choices (triangle, arrow, irregular pentagon) for variety is additive
  content work using the same `SpatialShapePainter`/transform-helper
  architecture already built.
- **Combined transformations** — the Transformations activity applies one
  transformation at a time from the original; chaining two transformations
  together (e.g. "rotate then reflect") is a real, separate teaching
  point not covered here.
- **More puzzle variety and a larger puzzle bank** — 5 puzzles is a
  starting set, not exhaustive; more nets-vs-cubes matching, more
  isometric cube-counting arrangements, and puzzles pulled from the
  existing Recall Cards/Discovery Card content (cross-linking, matching
  how other Interactive Labs already link out via `LabRelatedLinks`) are
  all natural next steps.
- **Progress tracking / analytics** — none of the 4 new activities record
  attempts, completions, or any per-learner progress state (unlike
  Interactive Labs, which use `InteractiveLabsProgressService`). They are
  presentation-only "simple interactive demonstrations," matching the
  brief's own framing; wiring them into a progress system is a distinct,
  larger decision (which service should own it, whether it affects ALI
  recommendations, etc.) that shouldn't be made implicitly by adding a
  side-effect to a UI-polish-scoped sprint.
- **Localisation beyond the 5 production locales** — the 5 new ARB keys
  (`mathStudioSpatialCubeNetsLabel`/`...Subtitle`,
  `mathStudioSpatialRotationsSubtitle`,
  `mathStudioSpatialTransformationsSubtitle`,
  `mathStudioSpatialPuzzlesSubtitle`) were added to `en`, `en-GB`,
  `de-CH`, `fr-CH` and `it-CH` — the locales
  `test/math_studio_l10n_completeness_test.dart` actually enforces for
  `mathStudio*` keys — but not to the other 15 locale files this app
  ships (da, de, es, fr, id, it, ko, nb, pt, sv and their regional
  variants). All in-activity content strings (net explanations, puzzle
  prompts/explanations, transformation labels) are currently
  English-only, hardcoded in the 4 screen files rather than routed
  through `AppLocalizations` at all — full localisation of this new
  in-activity content across every supported locale is real remaining
  work, not done in this pass.
