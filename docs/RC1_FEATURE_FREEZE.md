# Math Intelligence RC1 — Feature Freeze

Status: **In effect** as of this checkpoint on `release/math-intelligence-rc1-foundation`.

This document is the source of truth for what is frozen, what is final for RC1, what is explicitly deferred, and how bug fixes are allowed to proceed during the polish phase. It exists so that RC1 polish work does not quietly turn back into feature development.

## 1. Frozen architecture

The following systems are architecturally frozen for RC1. They may receive targeted bug fixes (see §5) but must not be redesigned, replaced, or restructured during RC1 polish:

- Onboarding and authentication
- Persistent application navigation (the bottom-nav shell and its branches)
- Learner identity and profiles
- Question scheduler
- Anti-repetition behaviour
- ALI deterministic recommendations
- Allie learner-progress architecture
- Captain Math guided activity architecture
- Question sessions and exam simulation
- Entitlement and monetisation architecture
- Math Studio routing foundation (the `/math-studio/*` route tree itself — individual screens within it may still gain content, per §3)
- Accessibility architecture
- Localisation architecture

No new major product area may be added on top of this list without an explicit post-RC1 decision.

## 2. Final Math Studio top-level pillars

The learner-facing Math Studio hub presents exactly six pillars, in this order:

1. **Build Confidence** — gentle, untimed practice with worked explanations.
2. **Mental Maths** — daily number strategies and timed/pattern practice across 10 categories, no pressure.
3. **Visual Maths** — visual models and manipulatives (Number Line, Fraction Bars, Abacus, Place Value Explorer).
4. **Math & Magic** — recreational puzzles, number tricks and mathematical curiosities. As of the 2026-08-02 explicit unfreeze decision (§8 changelog), ships with 4 real interactive activities — Visual Number Tricks, Patterns, Magic Squares, Parity — none scored, timed, or gamified. Further expansion (more tricks, more puzzle variety, additional pattern types) is tracked separately in `docs/MATH_MAGIC_BACKLOG.md`, not "in development" placeholder content.
5. **Spatial Intelligence** — shape, space and movement. As of the 2026-08-02 explicit unfreeze decision (§8 changelog), ships with 4 real interactive activities — Cube Nets, Rotations, Transformations, Spatial Puzzles — plus its existing, unchanged entry point into Interactive Labs. Further expansion beyond this minimum (more nets, more puzzle variety, additional shapes) is tracked separately in `docs/SPATIAL_INTELLIGENCE_BACKLOG.md`, not "in development" placeholder content.
6. **Discovery Library** — real-world maths, one contextual card at a time, across 24 illustrated cards spanning shopping, cooking, sport, aviation, trucking, and healthcare.

## 3. Recall Cards and Interactive Labs as reusable formats

Recall Cards and Interactive Labs are fully-built features (routes, services, progress tracking, content, tests, accessibility, localisation, analytics hooks) that are **no longer top-level Math Studio pillars**. They continue to exist, unchanged, at their existing routes:

- Recall Cards: `/math-studio/recall-cards` (hub, browse, bookmarks, detail, review session)
- Interactive Labs: `/math-studio/interactive-labs` (hub + Fraction Builder, Algebra Balance, Number Line Explorer, Flight Path Lab, Football Precision, Maze Driver, Data Detective, Spatial Cube Lab, Aircraft Landing Lab)

They are now reachable as embedded "featured format" entry cards within the pillars where they make sense:

- **Mental Maths** → Recall Cards entry card.
- **Visual Maths** → Recall Cards and Interactive Labs entry cards.
- **Spatial Intelligence** → Interactive Labs entry card.
- **Discovery Library** → Interactive Labs entry card ("Related labs").

Nothing about either feature's routes, services, progress persistence, content, tests, accessibility semantics, localisation strings, analytics hooks, or existing deep links changed. Every cross-link that hardcodes `/math-studio/recall-cards/...` or `/math-studio/interactive-labs/...` (lab back buttons, related-links chips, Discovery Library detail cross-links, PDF export filenames) continues to resolve exactly as before.

## 4. Explicitly deferred (post-RC1)

The following are out of scope for RC1 and require an explicit post-RC1 decision before any implementation work begins:

- Unreal runtime integration
- Blender runtime integration
- VR/AR
- Multiplayer
- Unrestricted child-to-AI conversation
- Live collaborative classrooms
- Full 3D graphics engine
- Advanced quantum-computing curriculum
- Large-scale new question generation
- Broad social features

## 5. Bug-fix exception process

RC1 polish is not a feature freeze on *fixing things* — it is a freeze on *adding things* and *redesigning things*. A change to frozen architecture (§1) is permitted during RC1 polish only if all of the following hold:

1. It is a targeted, minimal fix — not a redesign, refactor, or architecture change.
2. It is accompanied by a regression test that would have caught the bug.
3. It does not expand the scope of the system it touches (no new user-facing capability).
4. It is logged in a changelog entry at the bottom of this document (date, one-line description, files touched).

Anything that doesn't meet all four criteria is post-RC1 work, regardless of how small it looks.

## 6. Definition of an RC1 release-blocking issue

An issue blocks RC1 release if it is any of:

- A crash or unhandled exception reachable from normal learner use.
- Data loss (progress, profile, entitlement, or session state).
- Incorrect scoring, progress persistence, or scheduler/anti-repetition behaviour.
- An accessibility regression (missing semantics, insufficient tap targets, colour-only signalling, overflow at any of the RC1-supported viewport sizes or at 1.6× text scale).
- A broken or dead-ended deep link.
- Localisation showing a raw ARB key, or an untranslated string in a locale where a translation is expected and gated by `test/math_studio_l10n_completeness_test.dart`.
- A navigation dead end (a screen with no way back).

Anything else is a polish-backlog item — see `docs/RC1_POLISH_PLAN.md`.

## 7. Rule: feature additions stop here

As of this checkpoint, no new learner-facing feature, pillar, or major product area may be added to `unified_math_tutor` without an explicit post-RC1 decision. This includes expanding Math & Magic or Spatial Intelligence beyond their "in development" state with real content — that is planned, tracked work, not something to slip in opportunistically during polish.

**Update, 2026-08-02**: Spatial Intelligence and Math & Magic were both explicitly unfrozen and shipped their RC1-minimum content — see §2 and the §8 changelog entries. These were deliberate, explicit decisions at the time each was made, not exceptions to this rule; the rule itself remains in effect for every other frozen area.

## 8. Changelog

| Date | Change | Files |
|---|---|---|
| 2026-08-07 | Explicit post-RC1 decision: added Early Maths Playground, a new Interactive Lab (`InteractiveLabId.earlyMathsPlayground`) at `/math-studio/interactive-labs/early-maths-playground` — a calm, low-pressure area for younger (pre-KS2) learners, distinct from every other frozen system, following the exact precedent Aircraft Landing Lab and Spatial Cube Lab already set (additive `InteractiveLabId`, additive routes under the existing `interactive-labs` path, one new entry card — never a new Math Studio pillar; the hub stays at its frozen six). First (and so far only) activity: Feed the Hungry Panda, a native-Flutter drag-and-drop one-to-one counting activity (feed Panda 1-3 apples, then answer how many are left) with a deterministic seeded generator, a `ChangeNotifier` round-state controller separated from a governed native-shape Panda/apple visual (explicitly swappable later for an approved Rive/sprite asset without touching the controller), full drag + tap-to-select + keyboard input parity, Reduce Motion support, stable (unwired) voice cue ids, and a local (non-network) progress/event-log seam. No timers, scores, streaks, penalties, or competitive mechanics anywhere in it, per explicit scope direction. See `docs/FEED_THE_HUNGRY_PANDA_BUILD_REPORT.md` for the full architectural writeup. | New: `lib/models/{panda_visual_state,feed_panda_challenge,feed_panda_event,feed_panda_voice_cues}.dart`, `lib/widgets/labs/feed_panda/{feed_panda_round_controller,panda_visual,apple_visual,fruit_tile,fruit_matrix,remaining_answer_choices}.dart`, `lib/services/feed_the_hungry_panda_progress_service.dart`, `lib/screens/labs/early_maths_playground_hub_screen.dart`, `lib/screens/labs/feed_panda/feed_the_hungry_panda_screen.dart`, `docs/FEED_THE_HUNGRY_PANDA_BUILD_REPORT.md`, `test/feed_panda_challenge_test.dart`, `test/feed_panda_round_controller_test.dart`, `test/feed_the_hungry_panda_progress_service_test.dart`, `test/feed_the_hungry_panda_widget_test.dart`. Changed: `lib/models/interactive_lab_id.dart` (additive enum value), `lib/app/router.dart` (2 additive routes), `lib/screens/labs/interactive_labs_hub_screen.dart` (1 new entry card), `lib/l10n/app_en.arb`/`app_en_GB.arb`/`app_de_CH.arb`/`app_fr_CH.arb`/`app_it_CH.arb` (new `feedPanda*`/`feedTheHungryPanda*`/`labsEarlyMathsPlayground*`/`earlyMathsPlaygroundIntro` keys), `test/math_studio_l10n_completeness_test.dart` (3 new prefix exemptions), `assets/config/studio_content_registry.json` (1 new interactiveLab entry, matching the same governance step every prior lab addition took). No changes to any other Interactive Lab, Math Studio pillar, or frozen system (§1). |
| 2026-08-03 | Explicit post-RC1 decision: added Aircraft Landing Lab, a new Interactive Lab (`InteractiveLabId.aircraftLandingLab`) at `/math-studio/interactive-labs/aircraft-landing-lab` — a native-Flutter, mathematically-driven side-profile descent lab (descent angle, altitude/ground-distance, gradient, vectors) with 4 activities (Find the Time, Follow the Descent Line, Land on the Glide Path, Vector Approach). Confirmed with the user beforehand: this is a new, separate lab, not an upgrade of the existing Flight Path Lab (bearings/speed-distance-time, top-down radar view) — the two teach genuinely different mathematics and both remain reachable, unchanged from each other, as the first two labs in a planned aviation-lab collection. Side-profile only this round (no cockpit/pseudo-3D view, no Rive), per explicit scope direction. Every other frozen system (§1) untouched; routing is purely additive under the existing `interactive-labs` route. See `docs/AIRCRAFT_LANDING_LAB_BUILD_REPORT.md` for the full architectural writeup. | New: `lib/models/{flight_approach_model,aircraft_landing_challenge}.dart`, `lib/widgets/labs/flight_approach/{flight_approach_controller,flight_approach_view,flight_approach_controls}.dart`, `lib/services/aircraft_landing_lab_progress_service.dart`, `lib/screens/labs/aircraft_landing_lab_hub_screen.dart`, `lib/screens/labs/aircraft_landing/{aircraft_landing_find_the_time_screen,aircraft_landing_descent_line_screen,aircraft_landing_glide_path_screen,aircraft_landing_vector_approach_screen}.dart`, `docs/AIRCRAFT_LANDING_LAB_BUILD_REPORT.md`, `test/flight_approach_model_test.dart`, `test/aircraft_landing_challenge_test.dart`, `test/aircraft_landing_lab_progress_service_test.dart`, `test/aircraft_landing_lab_widget_test.dart`. Changed: `lib/models/interactive_lab_id.dart` (additive enum value), `lib/app/router.dart` (5 additive routes), `lib/screens/labs/interactive_labs_hub_screen.dart` (1 new entry card), `assets/config/studio_content_registry.json` (1 new interactiveLab entry), `lib/l10n/app_en.arb`/`app_en_GB.arb`/`app_de_CH.arb`/`app_fr_CH.arb`/`app_it_CH.arb` (new `labsAircraftLanding*` keys), `test/labs_mobile_layout_test.dart` (5 screens added to the existing matrix). No changes to `lib/screens/labs/flight_path_lab_screen.dart` or any other frozen system. |
| 2026-08-03 | Explicit post-RC1 decision: added Spatial Cube Lab, a new Interactive Lab (`InteractiveLabId.spatialCubeLab`) at `/math-studio/interactive-labs/spatial-cube-lab` — a native-Flutter, mathematically-projected draggable cube (no 3D engine/`vector_math` dependency, per §4's existing deferral) with 4 activities (Which Face Is Opposite?, Rotate to Match, Hidden Face, Cube Net Explorer). Follows the precedent `docs/SPATIAL_INTELLIGENCE_BACKLOG.md` had already set: a genuinely manipulable cube belongs in Interactive Labs, not the Spatial Intelligence pillar, whose 4 existing activities are untouched. Every other frozen system (§1) untouched; routing is purely additive under the existing `interactive-labs` route. See `docs/SPATIAL_CUBE_LAB_BUILD_REPORT.md` for the full architectural writeup. | New: `lib/models/{spatial_cube_face,spatial_cube_orientation,spatial_cube_net,spatial_cube_challenge}.dart`, `lib/widgets/labs/spatial_cube/{spatial_cube_controller,spatial_cube_widget,spatial_cube_controls}.dart`, `lib/services/spatial_cube_lab_progress_service.dart`, `lib/screens/labs/spatial_cube_lab_hub_screen.dart`, `lib/screens/labs/spatial_cube/{spatial_cube_which_face_opposite_screen,spatial_cube_rotate_to_match_screen,spatial_cube_hidden_face_screen,spatial_cube_net_explorer_screen}.dart`, `docs/SPATIAL_CUBE_LAB_BUILD_REPORT.md`, `test/spatial_cube_orientation_test.dart`, `test/spatial_cube_challenge_test.dart`, `test/spatial_cube_lab_progress_service_test.dart`, `test/spatial_cube_lab_widget_test.dart`. Changed: `lib/models/interactive_lab_id.dart` (additive enum value), `lib/app/router.dart` (5 additive routes), `lib/screens/labs/interactive_labs_hub_screen.dart` (1 new entry card), `assets/config/studio_content_registry.json` (1 new interactiveLab entry), `lib/l10n/app_en.arb`/`app_en_GB.arb`/`app_de_CH.arb`/`app_fr_CH.arb`/`app_it_CH.arb` (new `labsSpatialCube*` keys), `test/labs_mobile_layout_test.dart` (5 screens added to the existing matrix). No changes to `lib/screens/spatial_intelligence/*`, `lib/models/math_studio_pillar.dart`, or any other frozen system. |
| 2026-08-02 | Explicit post-RC1 decision: unfroze Spatial Intelligence and shipped its RC1-minimum real content (Cube Nets, Rotations, Transformations, Spatial Puzzles), replacing the "in development" placeholder. Existing Interactive Labs entry point, routing foundation, and every other frozen system (§1) untouched. Remaining backlog beyond this minimum tracked separately in `docs/SPATIAL_INTELLIGENCE_BACKLOG.md`, per §7 — not silently expanded. | New: `lib/screens/spatial_intelligence/{spatial_activity_scaffold,cube_nets_screen,rotations_screen,transformations_screen,spatial_puzzles_screen,spatial_shapes,spatial_shape_painter}.dart`, `docs/SPATIAL_INTELLIGENCE_BACKLOG.md`. Changed: `lib/screens/spatial_intelligence/spatial_intelligence_screen.dart` (rewritten as a real hub), `lib/models/math_studio_pillar.dart` (`isInDevelopment: false`), `lib/app/router.dart` (4 additive routes), `lib/l10n/app_en.arb`/`app_en_GB.arb`/`app_de_CH.arb`/`app_fr_CH.arb`/`app_it_CH.arb` (5 new keys each), `test/math_studio_new_pillars_test.dart`. |
| 2026-08-02 | Explicit post-RC1 decision: unfroze Math & Magic and shipped its RC1-minimum real content (Visual Number Tricks, Patterns, Magic Squares, Parity), replacing the "in development" placeholder. Every activity is untimed and unscored — no gamification anywhere in this pillar. Routing foundation and every other frozen system (§1) untouched. Remaining backlog (including two brief-named examples, Curious Proofs and Impossible Shapes, deliberately deferred rather than shipped with unverified geometry) tracked separately in `docs/MATH_MAGIC_BACKLOG.md`, per §7. | New: `lib/screens/math_magic/{math_magic_activity_scaffold,number_tricks_screen,patterns_screen,magic_squares_screen,parity_screen}.dart`, `docs/MATH_MAGIC_BACKLOG.md`. Changed: `lib/screens/math_magic/math_magic_screen.dart` (rewritten as a real hub), `lib/models/math_studio_pillar.dart` (`isInDevelopment: false`), `lib/app/router.dart` (4 additive routes), `lib/l10n/app_en.arb`/`app_en_GB.arb`/`app_de_CH.arb`/`app_fr_CH.arb`/`app_it_CH.arb` (8 new keys each), `test/math_studio_new_pillars_test.dart`, `test/math_studio_navigation_widget_test.dart`. |
| 2026-07-25 | Initial freeze established; Math Studio hub restructured to the six pillars above; Recall Cards/Interactive Labs demoted to embedded formats within Mental Maths, Visual Maths, Spatial Intelligence and Discovery Library; Math & Magic and Spatial Intelligence added as new, honest "in development" pillars. | New: `lib/models/math_studio_pillar.dart`, `lib/widgets/shared/route_link_card.dart`, `lib/widgets/shared/in_development_feature_card.dart`, `lib/screens/math_magic/math_magic_screen.dart`, `lib/screens/spatial_intelligence/spatial_intelligence_screen.dart`, `test/math_studio_pillar_reachability_widget_test.dart`, `test/math_studio_new_pillars_test.dart`. Changed: `lib/app/router.dart` (2 additive routes), `lib/screens/math_studio/math_studio_hub_screen.dart` (registry-driven rebuild), `lib/screens/labs/interactive_labs_hub_screen.dart` (extracted to shared `RouteLinkCard`, no behaviour change), `lib/screens/mental_maths/mental_maths_hub_screen.dart`, `lib/screens/visual_maths/visual_maths_hub_screen.dart`, `lib/screens/discovery/discovery_library_screen.dart` (entry cards added), `lib/l10n/app_en.arb`/`app_en_GB.arb`/`app_de_CH.arb`/`app_fr_CH.arb`/`app_it_CH.arb` (new keys), `test/math_studio_navigation_widget_test.dart` (rewritten), `test/math_studio_l10n_completeness_test.dart` (2 cognate exemptions added). No changes to `/math-studio/recall-cards*` or `/math-studio/interactive-labs*` routes, or to `lab_scaffold.dart`, `lab_related_links.dart`, `recall_card_body.dart`, or export services. |
