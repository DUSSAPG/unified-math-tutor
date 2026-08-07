# Family Maths — Phase 2 Report

Scope: expand the Family Maths activity library from 3 to ~12 flagship
activities, add a small Parent Confidence reassurance copy pool, prepare
(but not build) Manim visual-support metadata, and harden governance around
activity-of-the-day, category filtering, and Studio Connection link
validity. No runtime AI, no new parent dashboard, no Cube Studio
implementation. Not committed — pending review.

## 1. Baseline

Before any change: `flutter analyze` clean, `flutter test` 369/369 passing
(confirmed by rerunning both at the start of this pass, not just recalled
from Phase 1).

## 2. Content audit (Phase 1 of this pass)

Audited the 3 existing activities (Build Twenty, Kitchen Fractions, Shape
Hunt) against the required-field/tone checklist: all 10 structural fields
present, Allie/Captain Math voice split correct, materials are ordinary
household items, no formal-lesson framing, activity can start in under two
minutes. **No rewrite was needed or made** — all three pass as authored in
the Phase 1 build.

## 3. Activities added

9 new activities, bringing the catalog to 12:

| id | title | category | age | studio connection |
|---|---|---|---|---|
| `dice-race` | Dice Race | addition | 5–7 | — |
| `the-shopkeeper` | Shopkeeper | subtraction | 7–9 | — |
| `array-builder` | Array Builder | multiplication | 7–9 | visual-maths |
| `fair-shares` | Fair Shares | division | 7–9 | — |
| `ratio-recipes` | Ratio Recipes | ratio | 9–11 | discovery/cooking-scale-a-recipe |
| `pattern-detective` | Pattern Detective | patterns | 5–8 | — |
| `measure-everything` | Measure Everything | measurement | 7–9 | — |
| `cube-views` | Cube Views | spatialReasoning | 9–11 | spatial-intelligence |
| `make-the-target` | Make the Target | logic | 9–11 | mental-maths |

Every activity is original content, written from the spec's stated focus
areas (subitising, equal sharing, mental rotation, etc.), not copied from
any source book's titles, stories, or wording.

**"Shopkeeper" was renamed to `the-shopkeeper`** as an id — a real bug
caught during authoring: `FamilyActivity.fromJson`'s id pattern
(`^[a-z0-9]+(-[a-z0-9]+)+$`, mirroring Discovery Card) requires at least one
hyphen, and a single-word id fails validation. Caught by running the schema
test immediately after authoring, before moving on — now has a regression
test (`test/family_activity_schema_test.dart`, "every activity id is
kebab-case with at least two segments").

## 4. Category coverage

12 categories now have exactly one authored activity each: numberSense,
addition, subtraction, multiplication, division, fractions, ratio,
geometry, measurement, patterns, logic, spatialReasoning. 4 remain
unauthored architecture placeholders (decimals, percentages, algebra,
mentalMaths) — they still parse via `FamilyMathsCategory.fromId` (schema
test), but **never appear as a filter chip** in the Library screen, because
the chip row is built only from categories actually present in the loaded
catalog (`family_maths_library_screen.dart`'s `presentCategories`) — this
was already true of the Phase 1 implementation and needed no code change,
only a new test locking the behaviour in
(`test/family_maths_layout_test.dart`, "category filter chips never expose
an unauthored (empty) category").

## 5. Localisation coverage

All 9 new activities fully authored (not machine-translated) in the same 5
production locales as Phase 1: en, en-GB, de-CH, fr-CH, it-CH — matching the
Discovery Card precedent's locale set and its `textFor()` region → language
→ English fallback chain. en-GB mirrors en verbatim (established
project-wide precedent — see `buildConfidence*` keys). Reassurance copy (§6)
and category/field-label chrome added to the same 5 ARB files that already
carry Family Maths content (`app_en.arb`, `app_en_GB.arb`, `app_de_CH.arb`,
`app_fr_CH.arb`, `app_it_CH.arb`), regenerated via `flutter gen-l10n`.
`test/math_studio_l10n_completeness_test.dart` (already extended with the
`familyMaths`/`familyActivity`/`allieLabel` prefixes in Phase 1) covers the
new reassurance keys automatically since they share the `familyMaths`
prefix — no test-config change needed this pass.

## 6. Parent Confidence reassurance copy

6 short, restrained reassurance lines (`familyMathsReassurance1`–`6`, e.g.
"You do not need to know the answer immediately.", "Five focused minutes is
enough.") added per the spec's examples. Surfaced in **exactly one place** —
a small italic caption above the category filter row on the Library screen
(`lib/screens/family_maths/family_maths_reassurance.dart`) — rotating
deterministically by day (same day-offset-modulo pattern as
`activityOfTheDay`/`cardOfTheDay`), so it's never the same line twice in a
row and never repeated across screens (the Welcome screen already carries
its own distinct philosophy tagline from Phase 1).

## 7. Manim visual-support preparation (Phase 9)

**Correction made mid-pass**: my first draft invented a self-contained
`manimAssetId`/`staticFallbackAssetId`/`durationSeconds`/`replayAvailable`
shape. Before finalising it, I checked the rest of this branch and found an
**already-established, separate Manim pipeline** — uncommitted but real —
at `assets/manim_static/manifest.json` (keyed by `animationId`, with
`durationMs`/`outputAsset`/`reviewStatus`/etc. living there) plus
`docs/MANIM_PIPELINE_SPEC.md` and `lib/widgets/manim/manim_explanation_card.dart`.
Duplicating those fields per-activity in `family_activities.json` would
create two sources of truth that could drift. **Redesigned** `visual` to a
single reference field, `{ animationId: string }`
(`FamilyActivityVisualMetadata` in `lib/models/family_activity.dart`),
pointing at manifest ids that don't exist yet
(`family_maths_ratio_recipes_intro`, `family_maths_cube_views_intro`) —
future work, not fabricated here. **`assets/manim_static/manifest.json`
itself was not touched** — it belongs to that separate pipeline effort and
extending it is out of scope for this pass. No manifest-loading service
exists anywhere in this app yet (confirmed: Flight Path/Football
Precision/Maze Driver labs all still hardcode their own asset paths,
bypassing the manifest entirely) — wiring one up is future work for whoever
owns the Manim pipeline, not blocked on by Family Maths.

Set on exactly 2 candidates as specified: Ratio Recipes, Cube Views. No
Manim scenes, no SVGs, no player UI were produced — data only.

## 8. Cube Studio pathway (Phase 5)

`cube-views` is Family Maths' first spatial-reasoning activity with a
front/side/top-view and hidden-cubes focus, foreshadowing a future Cube
Studio. Its `studioConnectionRouteSuffix` is `spatial-intelligence` — the
**real, existing** Spatial Intelligence pillar — never a `cube-studio`
route, which does not exist. No learner-facing copy anywhere in the catalog
names "Cube Studio" (verified by
`test/family_activity_schema_test.dart`'s "no live Cube Studio route"
test, which grep-checks the bundled JSON for the literal string). Future
Cube Studio activities remain **documentation only**, per the original
pitch: Copy the Model, Hidden Cubes, Cube Views (deeper), Cube Nets, Fold
the Cube, Painted Cube, Volume Builder, Coordinate Cubes, Soma-style
Challenges — none implemented, no dead/"coming soon" route exposed anywhere
in the app.

## 9. Activity-of-the-day governance

Reviewed `FamilyActivityCatalogService.activityOfTheDay` (unchanged from
Phase 1 — `sortedIds[dayOffset % sortedIds.length]`, mirroring
`DiscoveryCardCatalogService.cardOfTheDay`). Verified it already satisfies
every governance requirement and **documented + tested rather than
rewritten**, per the instruction to prefer that when the existing
implementation already qualifies:
- Never selects a placeholder — `byId` throws `StateError` for anything not
  in the loaded catalog, and the id list is drawn directly from the loaded
  catalog.
- Rotates across the full 12-activity catalog — new test asserts one full
  12-day cycle visits every id exactly once.
- Never repeats on a consecutive day — new test asserts this empirically
  across 60 consecutive days (mathematically guaranteed for any catalog
  size > 1, but verified rather than assumed).
- Deterministic for testing — same `DateTime` in, same activity out
  (existing test, unchanged).
- No internet, no runtime AI — pure bundled-asset arithmetic, no network or
  LLM calls anywhere in the service.

## 10. Files changed

**New**:
- `lib/screens/family_maths/family_maths_reassurance.dart`
- `test/family_maths_layout_test.dart`
- `docs/FAMILY_MATHS_PHASE_2_REPORT.md`

**Modified**:
- `lib/models/family_activity.dart` — `FamilyActivityVisualMetadata`
  (redesigned mid-pass, see §7), `visual` field on `FamilyActivity`
- `assets/config/family_activities.json` — 9 new activities appended
- `assets/config/family_activities.schema.json` — documented `visual` field
- `lib/screens/family_maths/family_maths_library_screen.dart` — reassurance
  caption wired in above the filter row
- `lib/l10n/app_en.arb`, `app_en_GB.arb`, `app_de_CH.arb`, `app_fr_CH.arb`,
  `app_it_CH.arb` — 6 new `familyMathsReassurance*` keys (+ regenerated
  `lib/l10n/app_localizations*.dart` via `flutter gen-l10n`)
- `test/family_activity_schema_test.dart` — count updated to 12, plus new
  studio-connection-validity, no-dead-Cube-Studio-link, and visual-metadata
  governance tests
- `test/family_activity_catalog_service_test.dart` — 2 new
  activity-of-the-day governance tests

**Unchanged** (audited, found already correct): `FamilyActivityCatalogService`,
`FamilyMathsCategory` enum, Family Maths routes in `lib/app/router.dart`,
Parent/Teacher Tools entry button, `CaptainMathCard`'s `message` override,
`ParentGate`, `test/family_maths_widget_test.dart` (still passes unmodified
against the 12-activity catalog).

## 11. Validation results

- `flutter analyze`: clean (full project + targeted file passes both run).
- Targeted Family Maths tests: `family_activity_schema_test.dart` (12/12),
  `family_activity_catalog_service_test.dart` (6/6),
  `family_maths_widget_test.dart` (5/5, unmodified),
  `family_maths_layout_test.dart` (4/4, new — viewport/text-scale/Reduce
  Motion/filter-chip coverage).
- `math_studio_l10n_completeness_test.dart`: 8/8 (covers the new
  reassurance keys automatically via the existing `familyMaths` prefix).
- Full suite: `flutter test --concurrency=1` — 380/380 passing (up from the
  369 baseline; +11 net from this pass's new/expanded tests).

## 12. Deferred work

- **Cube Studio**: architecture-only, documented in §8. No routes, no
  screens, no activities beyond `cube-views`'s spatial-intelligence link.
- **Manim assets**: `animationId` references only (§7). No scenes, no SVGs,
  no manifest entries, no player wiring — and no manifest-loading service
  exists yet for *any* consumer in this app, not just Family Maths.
- **Remaining Family Games Library activities** from the original pitch
  (Estimate the Room, Find Symmetry, Kitchen/Shopkeeper variants beyond
  what's built) were superseded by this session's explicit 9-activity list
  and were not built.
- **Activity counts on filter chips** (Phase 7's "where this fits the
  existing design") — not added. Discovery Library, the closest structural
  precedent, doesn't show counts on its category chips either; adding them
  here would be new UI language rather than reuse.

## 13. Hardware/manual test checklist

Not run on physical hardware this pass (no device available in this
session). For a future manual pass:
- [ ] Small phone (iPhone SE-class, ~320×568) — Library grid + chip row,
      Detail screen, all 3 badges per tile readable without truncation.
- [ ] Large phone (Pixel 6a/iPhone 15 Pro Max-class) — same, landscape too.
- [ ] Small tablet (~600×960) and portrait tablet (~768×1024) — grid column
      count and reassurance caption placement.
- [ ] System text size at Large/XL (matches the 1.3x/1.6x/2.0x automated
      coverage, but worth eyeballing real system font rendering).
- [ ] Reduce Motion on at OS level — Captain Math bounce suppressed, no
      visual glitch on the detail screen.
- [ ] VoiceOver/TalkBack pass over `AllieCard` and Captain Math on one
      detail screen (e.g. `cube-views`, which has both a Studio Connection
      link and a longer prompt).
