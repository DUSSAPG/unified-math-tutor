# Studio Activity → Curriculum Link Audit V1

**Status:** read-only research audit. No Flutter code, route, asset, question pack, or curriculum manifest was changed to produce this document — every claim below is either a direct code citation (file + what was read) or an explicit "not independently verified" flag. Nothing here is retroactively authorised as available; the curriculum manifest (`assets/config/curriculum_manifest.json`) remains the only source of truth for what a learner is actually shown, exactly as `LEARNING_OBJECTIVE_ITERATION_CONTRACT_V1.md` already establishes.

## Methodology — this document is evidence-backed differently from the other three

`WORKBOOK_LIBRARY_MAP_V1.md` and `PARENT_PARTNERSHIP_CONTRACT_V1.md` are deliberately `bibliographic_inference_only` (title-level signals about private copyrighted PDFs this app must never extract from). **This document is the opposite**: every row below comes from **actually reading this repository's own Dart source, its own route table, and — where one exists — an activity's own self-declared `LabRelatedLinks.practiceTopicIds` field**, cross-checked against `test/topic_capability_resolver_test.dart`'s existing drift guard (re-run read-only for this audit; still green — 30/30 passing at time of writing). Where a claim below could not be verified this way, it is marked **uncertain**, never asserted.

**Hard rule this audit holds itself to, per the brief:** an activity's *name* is never treated as curriculum evidence. "Spatial Intelligence" does not imply Geometry & Measures; "Data Detective" does not imply Statistics & Probability. Every mapping below is justified by what the code actually does, cited to the exact line/mechanism that shows it.

---

## Full matrix

| # | Activity | Route | What the learner actually does | Verified curriculum concepts | Defensible stage(s) | Evidence source | Availability | Recommended Hub treatment | Card state |
|---|---|---|---|---|---|---|---|---|---|
| 1 | **Abacus** | `/math-studio/visual-maths/abacus` | Views 3 **fixed, static** place-value examples (ones/tens/hundreds bead counts) and taps "Try another example" to cycle them. No drag, build, or bead manipulation of any kind. | Place-value representation (ones/tens/hundreds columns) | Early representation of place value — consistent with early KS1/lower-KS2 teaching; **not** a basis for claiming broad KS2 Number & Place Value coverage (only 3 fixed instances exist, no practice, no generation) | `lib/screens/visual_maths/abacus_screen.dart` (own doc comment: *"Bounded, non-interactive Visual Maths placeholder for the future Animated Abacus"*); `visual_maths_placeholder_scaffold.dart` (shared "Preview" + "coming in a future release" badge, also used by Fraction Bars and Place Value Explorer) | **Partial** — real, shipped, tappable, but a static preview, not interactive practice | If ever surfaced on a Topic Hub, must carry the same visible "Preview"/"coming soon" framing already shown in-app — never presented as equivalent to Topic Drill/Quick Start | Tappable today (already live in Visual Maths), but must stay marked as preview-only wherever referenced |
| 2 | **Feed the Hungry Panda** | `/math-studio/interactive-labs/early-maths-playground/feed-the-hungry-panda` | Hears/reads a quantity instruction, moves that many apples to Panda one at a time, then answers how many are left | Cardinal counting, one-to-one correspondence, "how many are left" (early subtraction-by-removal) | Early Years/KS1 — content matches; no evidence of KS2+ scope | `lib/screens/labs/feed_panda/feed_the_hungry_panda_screen.dart` (doc comment + `FeedPandaRoundController` wiring, real progress recording via `FeedTheHungryPandaProgressService`); `InteractiveLabId.earlyMathsPlayground` is declared **`{}`** (empty) in `topic_capability_resolver.dart`'s `labTopicIds`, confirmed by the re-run drift guard | **Available** (real, live, interactive) but **topic-unlinked** — no curriculum-manifest tie exists | Correctly absent from every Topic Hub today — the current manifest has **zero real content at Early Years or KS1 for any topic** (confirmed: `early_years:false, KS1:false` in the manifest's own stage list), so there is nothing yet to link *to*, not just a missing link | Absent — correct current behaviour, not a bug |
| 3 | **Spatial Intelligence — Cube Nets** | `/math-studio/spatial-intelligence/cube-nets` | Judges whether each of 4 fixed nets (2 valid, 2 invalid) folds into a cube, with feedback and an explanation | Nets of 3D solids | KS2 (core NC content) through the KS2/KS3 boundary | `docs/SPATIAL_INTELLIGENCE_BACKLOG.md`'s own "What shipped" section (already-documented, authoritative) + `lib/screens/spatial_intelligence/cube_nets_screen.dart` | **Available**, real, interactive, but narrow — only 4 of the 11 mathematically valid hexomino cube nets, explicitly documented as deferred | Genuine candidate for `geometry_measures`, but this requires **new** linkage work — the whole Spatial Intelligence pillar has no `InteractiveLabId` entry at all, so it sits structurally outside `TopicCapabilityResolver` today, not just unlinked within it | Absent from every Topic Hub today |
| 4 | **Spatial Intelligence — Rotations** | `/math-studio/spatial-intelligence/rotations` | Rotates a single L-shaped tile about a fixed centre via a continuous slider or 90°/180°/270° preset buttons | Rotation as a named geometric transformation | KS3 (the precise-angle slider framing reads as formalised KS3 transformation work, not informal KS2 awareness) | `docs/SPATIAL_INTELLIGENCE_BACKLOG.md` + `lib/screens/spatial_intelligence/rotations_screen.dart` | **Available**, real, interactive, single shape/scenario only (narrow) | Candidate for `geometry_measures@KS3`; same "new linkage work needed" caveat as Cube Nets | Absent |
| 5 | **Spatial Intelligence — Transformations** | `/math-studio/spatial-intelligence/transformations` | Applies each of the 4 classic transformations (translate, reflect, rotate, enlarge) to one shape, each with its own parameter control, always shown against the original outline | The full 4-transformation set, **including enlargement** | KS3 — enlargement specifically is a KS3-named transformation in England's NC, not a KS2 topic | `docs/SPATIAL_INTELLIGENCE_BACKLOG.md` + `lib/screens/spatial_intelligence/transformations_screen.dart` | **Available**, real, interactive, single shape/scenario (narrow) | The strongest single-stage candidate of the four Spatial Intelligence activities: `geometry_measures@KS3` | Absent |
| 6 | **Spatial Intelligence — Spatial Puzzles** | `/math-studio/spatial-intelligence/spatial-puzzles` | Answers 5 **fixed** multiple-choice puzzles (cube counting, mirror-image identification, 3D-shape face/edge/vertex facts), untimed and unscored | 3D shape properties (face/edge/vertex facts) confirmed for a subset of the 5 items; cube-counting and mirror-image items are general spatial reasoning without one precise NC-strand citation | Face/edge/vertex subset: KS2. Cube-counting/mirror-image subset: **uncertain** — do not claim a single clean stage for the whole activity | `docs/SPATIAL_INTELLIGENCE_BACKLOG.md`'s description (the puzzle screen's own source was not independently re-read line-by-line this pass — flagged, not asserted) | **Available**, real, but only 5 fixed items, no generation (very narrow) | If linked, split the claim: `geometry_measures@KS2` for the face/edge/vertex items only, not the whole activity as one card | Absent |
| 7 | **Football Precision** | `/math-studio/interactive-labs/football-precision` | Chooses a mode (Precision Round / One-Minute Challenge), sets angle and power, takes kicks; score "combines direction error and power error into one route result" | Angle/direction estimation (geometry) confirmed directly in code and via its own `recallCardIds: ['geo-bearings-strategy', ...]`. A statistics_probability link is **plausible but weaker evidence** — the screen cites `'stats-mean-formula'` as a related recall card, but this audit did not independently re-derive a learner-facing mean/average computation the way it did for Data Detective (#8) | Geometry component: KS3 (bearings-adjacent angle work). Statistics component: **uncertain** | `lib/screens/labs/football_precision_lab_screen.dart`'s own `LabRelatedLinks(practiceTopicIds: ['statistics_probability', 'geometry_measures'])` declaration, cross-checked against `topic_capability_resolver.dart`'s `labTopicIds` and the re-run drift guard (still passing) | **Available now** — already correctly governed by `TopicCapabilityResolver`, already shown on Topic Hubs where the linked topics/stages are genuinely real | Keep as-is; if ever revisited, verify the statistics_probability claim more rigorously rather than removing or expanding it on this audit's say-so alone | Already tappable where genuinely available — existing, correct behaviour, not a gap |
| 8 | **Data Detective** | `/math-studio/interactive-labs/data-detective` | Computes and displays mean and median before and after an outlier is introduced/removed from a dataset; the learner predicts the effect | Mean, median, and outlier sensitivity of central-tendency measures — directly confirmed in code (`_meanBefore`, `_meanAfter`, `_medianBefore`, `_medianAfter` fields and their comparison UI) | KS3-KS4 (measures of central tendency, outlier effects) | `lib/screens/labs/data_detective_screen.dart` (direct read) + its own `LabRelatedLinks(practiceTopicIds: ['statistics_probability'])`, cross-checked against the drift guard | **Available now** — already correctly governed | Keep as-is — this is the most strongly evidenced mapping in this entire audit | Already tappable where genuinely available |
| 9 | **Dino Polo** | *(none — no route exists)* | *Nothing — the activity does not exist.* Confirmed by an exhaustive case-insensitive repository search for "dino polo"/"dinopolo": zero matches in any file. | None — no code exists to verify a concept against | None | Absence confirmed by direct repository search, not inference | **Planned only, in name alone** — zero implementation | Must follow a **stricter** placeholder pattern than Abacus/Fraction Bars/Place Value Explorer: those have real (if bounded) content to preview; Dino Polo has nothing to show yet. If ever referenced in any UI, it must be a **non-tappable** label/chip, not a "Preview" card with a working "try another example" button | **Absent today (correct).** If ever added ahead of real content, it must never be tappable and never read as "available" |

### Already-governed Interactive Labs (context, not re-audited from scratch this pass)

These already have a live `InteractiveLabId` entry, a self-declared `LabRelatedLinks.practiceTopicIds`, and are already exercised by `topic_capability_resolver_test.dart`'s drift guard (re-confirmed passing for this audit). Listed for completeness of "every candidate activity found," not because this pass found anything new to change:

| Activity | Declared topic(s) | Evidence |
|---|---|---|
| Fraction Builder | `fractions` | `labTopicIds` + drift guard |
| Algebra Balance | `algebra` | `labTopicIds` + drift guard |
| Number Line Explorer | `number_place_value` | `labTopicIds` + drift guard |
| Flight Path Lab | `geometry_measures` | `labTopicIds` + drift guard |
| Maze Driver | `geometry_measures` | `labTopicIds` + drift guard |
| Aircraft Landing Lab (4 sub-missions) | `trigonometry`, `geometry_measures` | `labTopicIds` + drift guard (union across its 4 sub-mission files) |
| Spatial Cube Lab (4 sub-missions, under Interactive Labs — **not** the same feature as the "Spatial Intelligence" pillar above) | **none** — every sub-mission declares an empty list | `labTopicIds` + drift guard, explicitly confirmed empty |

**Notable gap this row surfaces on its own:** the app has **two separate, differently-routed "spatial cube" style features** — Interactive Labs' own Spatial Cube Lab (`/math-studio/interactive-labs/spatial-cube-lab/*`) and the Spatial Intelligence pillar's Cube Nets (`/math-studio/spatial-intelligence/cube-nets`) — and **both are currently topic-unlinked**. Any future spatial-geometry linkage work should look at both together rather than fixing one and leaving the other's gap undiscovered again.

---

## Mapping candidates — accepted, rejected, or uncertain

**Accepted (already correct, verified, no action needed):**
- Data Detective → `statistics_probability` (strongest evidence in this audit).
- Football Precision → `geometry_measures` (angle/bearings component).
- All 7 already-governed Interactive Labs in the table above.

**Rejected (explicitly not claimed by this audit):**
- Abacus → any specific KS2-wide Number & Place Value coverage claim (the activity is 3 static examples, not practice).
- Spatial Puzzles → a single clean stage for the *whole* activity (only the face/edge/vertex subset is defensible).
- Dino Polo → any curriculum concept at all (nothing exists to evaluate).

**Uncertain (flagged, not asserted either way):**
- Football Precision → `statistics_probability` (plausible via its own recall-card citation, not independently re-derived this pass).
- Spatial Puzzles' cube-counting/mirror-image items → any single NC strand.

**New linkage candidates this audit surfaces (not yet wired, would require real implementation work, not a manifest flip):**
- Spatial Intelligence: Cube Nets → `geometry_measures@KS2`; Rotations → `geometry_measures@KS3`; Transformations → `geometry_measures@KS3` (strongest of the three).
- Feed the Hungry Panda → blocked on the Early Years/KS1 manifest-content gap, not on the activity itself.

---

## Recommended single highest-value next implementation slice

**Wire Spatial Intelligence's Transformations activity into `TopicCapabilityResolver` as a `geometry_measures@KS3` Interactive Lab entry.** Reasoning: it is the most defensibly single-stage-mapped of the three currently-unlinked Spatial Intelligence activities (enlargement is unambiguously KS3), `geometry_measures@KS3` is already a real, available manifest topic-stage (confirmed in the P0 content-integrity sprint), the activity itself is already real and shipped (no new content authoring required, unlike Panda's EY/KS1 manifest gap), and the mechanism to wire it (`InteractiveLabId` enum entry + `LabRelatedLinks.practiceTopicIds` + a `labTopicIds` entry) is an already-proven, low-risk, additive pattern this codebase uses for every other lab — not a new architecture.

---

## Report

**Files created:**
- `docs/learning_architecture/PARENT_PARTNERSHIP_CONTRACT_V1.md`
- `docs/learning_architecture/STUDIO_ACTIVITY_CURRICULUM_LINK_AUDIT_V1.md` (this file)

**Exact evidence reviewed for this file:** `lib/screens/visual_maths/abacus_screen.dart`, `lib/screens/visual_maths/visual_maths_placeholder_scaffold.dart`, `lib/screens/labs/feed_panda/feed_the_hungry_panda_screen.dart`, `lib/screens/labs/early_maths_playground_hub_screen.dart`, `lib/screens/spatial_intelligence/spatial_intelligence_screen.dart`, `docs/SPATIAL_INTELLIGENCE_BACKLOG.md`, `lib/screens/labs/football_precision_lab_screen.dart`, `lib/screens/labs/data_detective_screen.dart`, `lib/models/interactive_lab_id.dart`, `lib/app/router.dart` (route table), `lib/services/topic_capability_resolver.dart` (`labTopicIds`/`labRoutes`), `assets/config/curriculum_manifest.json` (stage `hasContent` flags, read-only), and a repository-wide search confirming Dino Polo does not exist. `test/topic_capability_resolver_test.dart` was re-run read-only (not modified) and still passes 30/30, confirming the drift-guard evidence cited above is current.

**Source-derived principles vs. original proposals:** none — this document is code-derived only; the "bibliographic inference" distinction from the other two documents does not apply here.

**Confirmation:** no production Flutter code, route, asset, question pack, curriculum manifest, dependency, localisation file, test, or build configuration was modified to produce either document. The one test run (`topic_capability_resolver_test.dart`) was read-only verification, not a change.
