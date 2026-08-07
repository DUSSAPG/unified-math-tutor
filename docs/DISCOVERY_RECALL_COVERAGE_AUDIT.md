# Discovery & Recall Coverage Audit

Status: audit + targeted repair sprint, complete. Companion file:
`docs/DISCOVERY_RECALL_CONTENT_MATRIX.csv` (machine-readable, one row per
selectable category/topic/type across both features, reflecting
**post-fix** state — this document also records the pre-fix findings and
the reasoning behind every change).

Repo root confirmed: `D:\AI\Quantumlab\apps\edex\unified_math_tutor`.
Git status inspected read-only before any edit (`git status --short`,
`git branch --show-current`, `git stash list`) — 309 pre-existing changes
(182 modified, 127 untracked) on `release/math-intelligence-rc1-foundation`,
zero stashes. Nothing was reset, cleaned, stashed, or discarded; nothing
was committed. All edits in this sprint are additive on top of that
existing working tree.

## Executive summary

The user's complaint — *"I currently see Sport prominently but expect
wider applied-mathematics coverage"* — has a single, precise root cause:
an **uncommitted, in-progress change** to `discovery_library_screen.dart`
introduced a category-visibility filter that only shows a filter chip for
categories with **≥ 3 cards**. Against the real 24-card catalogue, only
`sports` (12 cards) clears that bar. The other six categories that
already have real, tested, fully-localized cards — `shopping`, `cooking`,
`everydayLife`, `aviation`, `truckingLogistics`, `healthcare` (2 cards
each) — were **silently unreachable** through the category chip row, even
though their content is complete and correct. This is now fixed (see
"Fixes applied," below): the threshold is `> 0` (has any content) instead
of `≥ 3`, so all seven populated categories are selectable, and only the
four genuinely-empty categories stay hidden.

Beyond that one bug, the two content systems audited (Recall Cards,
Discovery Cards) are structurally sound: fail-fast loading, no dead
enum values, no orphaned icon references, strict student/parent
separation, and (for Recall Cards specifically) an already-correct
empty-state pattern with an explanatory message and a "Clear filters"
action — nothing to repair there.

## FIRST — inventory located

| What | Where |
|---|---|
| Student Recall Card registry | `assets/config/recall_cards.json` (120 cards) |
| Student Recall Card model | `lib/models/recall_card.dart` (`RecallTopic`, `RecallCardType`) |
| Student Recall Card service | `lib/services/recall_card_catalog_service.dart` |
| Parent Recall Card registry | `assets/config/parent_recall_cards.json` (20 cards) |
| Parent Recall Card model | `lib/models/parent_recall_card.dart` (`ParentRecallCardCategory`) |
| Parent Recall Card service | `lib/services/parent_recall_card_catalog_service.dart` |
| Discovery Card registry | `assets/config/discovery_cards.json` + `.schema.json` (24 cards) |
| Discovery Card model | `lib/models/discovery_card.dart` (`DiscoveryCategory`, `SportType`) |
| Discovery Card service | `lib/services/discovery_card_catalog_service.dart` |
| Studio Content Registry | `assets/config/studio_content_registry.json` (29 entries) + `lib/models/studio_content_item.dart` + `lib/services/studio_content_registry_service.dart` |
| Math Studio pillar registry | `lib/models/math_studio_pillar.dart` (6 pillars, none in-development) |
| Route tree | `lib/app/router.dart` (`/math-studio/*`, 39 reachable leaf routes) |
| Feature flags / publishing config | `lib/core/config/publishing_config.dart`, `lib/core/config/build_flags.dart`, `lib/core/bootstrap.dart`, `lib/core/market/*` |
| Locale files | `lib/l10n/app_*.arb` (20 locale files; only 5 carry Discovery/Recall UI-chrome keys) |
| Empty-state tests | none exercised the *triggered* (empty-data) rendering path before this sprint — see "Empty-state coverage," below |
| Icon/asset reference validation | no existing test or script anywhere in the repo validated that a JSON-referenced icon/image path resolves to a real file — a genuine, pre-existing gap, now partly closed (Discovery Cards only; see "Fixes applied") |

## Current categories & counts (before any edit)

**Recall Cards (student)** — 120 cards, 0 duplicate ids.
- By topic (6, exactly 20 each): `number`, `ratioAndProportion`, `algebra`,
  `geometryAndMeasures`, `statistics`, `probability`.
- By type (8, uneven): `formula` 42, `strategy` 22, `vocabulary` 12,
  `misconception` 10, `realWorldConnection` 10, `symbol` 9, `visual` 9,
  `meaning` 6.
- 4 of the 48 topic×type cells are genuinely empty:
  `ratioAndProportion`×`vocabulary`, `algebra`×`meaning`,
  `algebra`×`realWorldConnection`, `probability`×`meaning`.

**Recall Cards (parent)** — 20 cards, 0 duplicate ids, 10 categories ×
2 cards each: `conversationStarters`, `homeworkHints`, `kitchenMaths`,
`shoppingMaths`, `realLifeAlgebra`, `geometryAroundTheHouse`,
`mentalMathsGames`, `budgeting`, `measurement`, `travelPlanning`.

**Discovery Cards** — 24 cards, 0 duplicate ids, 11 categories defined:

| Category | Cards | In the user's target list? |
|---|---|---|
| `sports` | 12 (cricket/football/basketball/americanFootball/baseball/tennis × 2) | sport |
| `shopping` | 2 | finance/shopping |
| `cooking` | 2 | cooking |
| `everydayLife` | 2 | everyday life |
| `aviation` | 2 | aviation |
| `truckingLogistics` | 2 | (not on the user's list — additive) |
| `healthcare` | 2 | healthcare |
| `engineeringConstruction` | **0** | engineering (+ architecture, see risk below) |
| `artDesign` | **0** | art/design |
| `businessFinance` | **0** | finance |
| `gaming` | **0** | (not on the user's list) |

**Studio Content Registry** — 29 entries: `interactiveLab` 9,
`mentalMathsCategory` 10, `discoveryCard` 3, `recallCard` 3,
`formulaEntry` 2, `familyActivity` 2, `game`/`teacherActivity` 0 each
(intentionally schema-ready, not populated — matches
`studio_content_item.dart`'s own doc comment). All 29 entries are
`"status": "published"`; none set `reviewRequired`.

**Math Studio pillars** — 6, none hidden or in-development:
`buildConfidence`, `mentalMaths`, `visualMaths`, `mathMagic`,
`spatialIntelligence`, `discoveryLibrary`.

## Audit questions, answered per category

### Recall Cards (student) — 6 topics + 8 types

- **Defined?** Yes, both `RecallTopic` (6) and `RecallCardType` (8) are
  closed enums with every value backed by ≥6 cards.
- **Visible?** Yes — the hub (`recall_cards_hub_screen.dart:157-194`)
  renders one chip per `RecallTopic.values` and one per
  `RecallCardType.values` unconditionally; no threshold, no gate.
- **Hidden by a feature flag?** No — confirmed no feature-flag mechanism
  anywhere in the repo touches Recall Cards (`publishing_config.dart`,
  `build_flags.dart`, `bootstrap.dart`, market files all checked).
- **≥1 valid card?** Yes for every topic and every type individually
  (the 4 empty cells are *combinations*, not empty categories).
- **Approved artwork?** N/A — Recall Cards render a deterministic
  per-`RecallCardType` icon (`recall_illustration.dart`), not bespoke
  artwork; all 8 types have an icon.
- **All enforced locales?** UI chrome (58 keys) ships in the 4 locales
  `test/math_studio_l10n_completeness_test.dart` actually enforces for the
  `recallCards` prefix (`en-GB`, `de-CH`, `fr-CH`, `it-CH`) plus the `en`
  template — 5/5. Card **content** intentionally ships `en`/`en-GB` only
  (documented in the schema as an RC1 scope decision, not a gap).
- **Selectable?** Yes, every topic/type chip is always selectable.
- **Can a filter combination produce "No cards found"?** Yes — the 4
  empty topic×type cells. **This is already handled correctly**: the
  Browse screen (`recall_cards_browse_screen.dart:197-230`) shows
  `l10n.recallCardsNoResults` plus a "Clear filters" button, with an
  explicit code comment documenting this as an accepted, known content
  gap. No fix needed; a regression test was missing and has been added
  (see "Tests added").
- **Student/parent/both?** Student only (separate model, separate
  service, separate JSON file, separate routes).
- **Duplicated elsewhere?** No cross-catalogue id collisions.
- **Dead code?** None — every enum value is exhaustively matched in
  `recall_card_labels.dart` (compiler-enforced).
- **Intentionally deferred?** The 4 empty topic×type cells, yes (by
  content-authoring gap, not architecture).

### Recall Cards (parent) — 10 categories

Same answers as above, structurally: defined, visible (10 chips,
unconditional), no feature flag, every category has exactly 2 cards, all
5 production locales present for content, selectable, no empty-filter
risk (single-select category list, no compound filter), parent-only
(verified disjoint from student `RecallTopic` by
`test/parent_recall_cards_test.dart:73-80`), no duplication, no dead
code, nothing deferred.

**One real gap found, not fixed this sprint (scope: documentation only,
see "Recommended follow-ups")**: `parent_recall_cards_screen.dart` hardcodes
its chrome text (title, category labels, button labels, empty-category
message) directly in Dart rather than through `AppLocalizations` — e.g.
`'Parent Recall Cards'`, `'No cards in this category yet.'`, `'Previous'`/
`'Next card'`. The card **content** is fully localized into 5 locales;
the screen's own **chrome** is English-only regardless of locale. This
is a localization completeness gap, not a visibility/architecture bug,
so it's out of this sprint's repair scope (`must not... author large new
[content]`) but is flagged clearly for a future sprint.

### Discovery Cards — 11 categories

- **Defined?** Yes, all 11 `DiscoveryCategory` values.
- **Visible (before fix)?** Only `sports` (the only category ≥3 cards).
- **Visible (after fix)?** All 7 populated categories — `sports`,
  `shopping`, `cooking`, `everydayLife`, `aviation`, `truckingLogistics`,
  `healthcare`.
- **Hidden by a feature flag?** No — confirmed the same way as Recall
  Cards; the old `≥3` gate was a hand-written threshold in the screen,
  not a flag.
- **≥1 valid card?** True for 7 of 11; false for `engineeringConstruction`,
  `artDesign`, `businessFinance`, `gaming` — these remain correctly
  excluded from the chip row (never presented as a selectable option that
  leads nowhere, per the sprint's guardrail).
- **Approved artwork?** All 24 cards' `illustrationAssetId`s resolve 1:1
  to real files in `assets/discovery_illustrations/` (24 files, 24 ids,
  no orphans either direction) — verified by the research pass and now
  also asserted by a new test (see "Tests added"). The 4 empty categories
  already have icon+color *fallback* entries pre-registered
  (`discovery_illustration.dart`), so future content in those categories
  needs no engine change, only cards + (eventually) real artwork.
- **All enforced locales?** Card content: 5/5 production locales. UI
  chrome (`mathStudioCategory*`/`mathStudioDiscovery*`, 15 keys): present
  in the same 5-locale set the completeness test enforces.
- **Selectable (after fix)?** The 7 populated categories, yes. The 4
  empty ones, deliberately no.
- **Empty-filter risk?** Structurally eliminated for the category filter
  itself post-fix (a chip is only ever offered when it has content). The
  underlying `_EmptyCategoryState` widget/message still exists as a
  defensive fallback (harmless — it simply won't be reachable through
  the chip row anymore under normal use).
- **Student/parent/both?** Discovery Cards are a single shared pool, not
  student/parent-split (unlike Recall Cards) — this is correct/intentional,
  not a gap.
- **Duplicated elsewhere?** No id collisions. `truckingLogistics` has no
  overlap with any other category name.
- **Dead code?** The 4 empty `DiscoveryCategory` values are *not* dead —
  they're intentionally pre-declared per the model's own doc comment
  ("future content batches are additive JSON edits, never a schema
  change"). Genuinely dead: `relatedDisciplineIds` is populated on every
  card but never rendered by any screen (data exists, no consumer —
  flagged for future use, not removed, since removing a populated field
  would be a schema change outside this sprint's scope).
- **Intentionally deferred?** The 4 empty categories, yes — and this is
  precisely what Sprint 2 (Applied Discovery Category Pack) targets.

### Studio Content Registry (29 entries)

- **Defined?** Yes, all entries validate against `StudioContentItem.fromJson`.
- **Visible?** The registry is a queryable index, not itself a rendered
  UI — "visible" doesn't directly apply; what matters is whether its
  `sourceId`s resolve to real, reachable content. They do, for the 29
  registered entries.
- **Coverage gap found (documented, not fixed):** only 3 of the 24
  Discovery Cards are registered here (`shopping-percentage-discount`,
  `cooking-fraction-conversion`, `aviation-speed-distance-time`) — the
  other 21 (all 12 sports cards, the 2nd shopping/cooking/aviation cards,
  both `everydayLife`/`truckingLogistics`/`healthcare` cards) have no
  registry entry. This is a data-completeness gap in an internal
  governance/analytics index, not a user-facing bug (no screen currently
  reads this registry to decide what's visible in Discovery Library) —
  flagged for a future fast-follow rather than bulk-edited in this sprint,
  to keep this sprint's diff focused on the confirmed user-facing bug.
- **False alarm, verified and not changed:** the registry's `difficulty`
  field for `discovery-cooking-fraction-conversion` reads `"core"` while
  the source card's own `difficulty` is `"intermediate"` — this looked
  like a bug at first glance but is **not** one: `StudioContentDifficulty`
  (`foundation, core, higher, advanced, stretch`) is a deliberately
  broader, separate vocabulary from `CardDifficulty`
  (`foundation, intermediate, advanced`), exactly as documented in
  `studio_content_item.dart`'s own doc comment. `"core"` is a valid,
  reasonable normalization of "intermediate" content. No edit made.
- **Category-casing inconsistency found (documented, not fixed):**
  `"Fractions"` (interactiveLab entries) vs `"fractions"` (familyActivity
  entries) are treated as distinct strings by `byCategory()`. Cosmetic;
  doesn't affect any current screen's behavior since nothing filters the
  Math Studio hub by this registry's `category` field yet.

### Math Studio pillars & routes

- All 6 pillars: defined, visible, no feature flag, `isInDevelopment:
  false` for all 6, each pillar leads to real content, none duplicated,
  no dead pillars.
- 39 leaf routes under `/math-studio` are reachable (full inventory in
  the research pass); the only 3 that lead to a genuinely incomplete
  screen (`fraction-bars`, `abacus`, `place-value`, all via
  `VisualMathsPlaceholderScaffold`) already show an honest visible
  "Preview" badge and a "coming in a future release" note — this already
  satisfies the sprint's guardrail (no unexplained blank screen), so no
  fix was needed there.
- No feature flag anywhere gates a pillar or a `/math-studio/*` route —
  confirmed by tracing every flag in `build_flags.dart`,
  `publishing_config.dart`, `bootstrap.dart`, and the market/canton files.

## Fixes applied this sprint

1. **`lib/screens/discovery/discovery_library_screen.dart`** — replaced
   the `reviewerReadyCategories` (`count >= 3`) gate with
   `categoriesWithContent` (`count > 0`). This is the sprint's one
   functional code change: it repairs incorrect visibility (six
   already-complete, already-tested, already-localized categories were
   unreachable) without hiding anything that's genuinely empty, and
   without inventing any new content or artwork. Renamed the variable to
   describe what it actually does, since "reviewer-ready" implied an
   editorial judgment that was never the real rule.

No other code changes were made. Every other finding above is either (a)
already handled correctly by existing code (Recall Cards' empty-state +
Clear Filters pattern, the Visual Maths placeholder badges), (b) a false
alarm on closer inspection (the registry difficulty vocabulary), or (c) a
real but lower-priority gap explicitly deferred to a documented follow-up
rather than expanded into this sprint (parent-screen localization,
Studio Content Registry completeness, category-casing normalization) —
consistent with the sprint's "must not... modify unrelated app
architecture" boundary.

## Guardrail compliance

*"The user must never make a reasonable visible selection and end on an
unexplained blank screen."*

- Discovery Library: after the fix, every visible chip has ≥1 card by
  construction — there is no visible-but-empty chip left to reach a
  blank/unexplained state from. The 4 zero-card categories are excluded
  from the chip row entirely (the guardrail's second option: "avoid
  presenting it as selectable"), rather than shown-and-disabled, since a
  disabled chip for a category with literally zero cards and zero
  artwork would communicate nothing more useful than simply not showing
  it yet.
- Recall Cards Browse: the 4 empty topic×type combinations remain
  reachable (both filters are always selectable, since hiding either one
  would break the general-purpose combinability of the two independent
  filters), but always resolve to an explained state — message text plus
  a one-tap "Clear filters" recovery action, never a bare blank screen.
  This was already correct; verified and now regression-tested.

## Open risk flagged for Sprint 2 (Applied Discovery Category Pack)

Sprint 2's ten target categories — Engineering, Healthcare, Aviation,
**Architecture and Construction**, Finance and Shopping, **Environment
and Climate**, **Computing and Cryptography**, Art/Design and Animation,
Cooking and Measurement, Everyday Life — do not all have a home in the
current `DiscoveryCategory` enum:

| Sprint 2 category | Existing enum value? |
|---|---|
| Engineering | `engineeringConstruction` (0 cards today) |
| Healthcare | `healthcare` (2 cards today) |
| Aviation | `aviation` (2 cards today) |
| Architecture and Construction | **shares `engineeringConstruction`** — no distinct value |
| Finance and Shopping | `businessFinance` (0) / `shopping` (2) — two existing values, not one |
| Environment and Climate | **no existing value at all** |
| Computing and Cryptography | **no existing value at all** (`gaming` exists but is a different concept) |
| Art, Design and Animation | `artDesign` (0 cards today) |
| Cooking and Measurement | `cooking` (2 cards today) |
| Everyday Life | `everydayLife` (2 cards today) |

Sprint 2 will need an explicit decision — before authoring content —
about whether Architecture, Environment, and Computing become new,
additive `DiscoveryCategory` enum values (matching the model's own
stated intent that growth should be "additive JSON edits, never a schema
change" for values that already exist, but a *new* enum value is a small
schema change) or are folded into existing categories. This is flagged
here, not resolved, since resolving it means writing Sprint 2's actual
content architecture — out of scope for an audit sprint.

**Resolved in Sprint 2** (see `docs/APPLIED_DISCOVERY_PACK_BUILD_REPORT.md`):
three new, additive `DiscoveryCategory` values were added —
`architectureConstruction`, `environmentClimate`,
`computingCryptography` — each with its own icon/colour fallback and
5-locale (en/en-GB/de-CH/fr-CH/it-CH) category label, distinct from
`engineeringConstruction` and `gaming` as flagged above. "Finance and
Shopping" was mapped to the existing `shopping` value (not
`businessFinance`, which remains untouched and still empty — it wasn't
one of Sprint 2's 10 target categories under that name).

## Recommended content-production order

Derived directly from the matrix: prioritize categories that already
have a working chip, a working icon fallback, and zero cards, before
categories needing a new taxonomy entry.

1. **Engineering** (`engineeringConstruction`) — enum exists, icon
   fallback exists, zero cards. Fastest path to "Sport is no longer the
   only real option."
2. **Healthcare, Aviation, Cooking, Everyday Life** — already have 2
   cards each; adding one more of each (a Foundation/Intermediate mix)
   both deepens existing categories and keeps them from reading as
   token/placeholder-thin.
3. **Art/Design, Finance** (`artDesign`, `businessFinance`) — enum
   exists, icon fallback exists, zero cards; second wave.
4. **Architecture, Environment, Computing** — blocked on the taxonomy
   decision above; sequence last so the decision doesn't block the four
   categories that need no architecture change at all.

## Recommended follow-ups (not fixed this sprint, by design)

- Add `parent_recall_cards_screen.dart`'s chrome strings to
  `AppLocalizations` (currently hardcoded English).
- Register the 21 un-registered Discovery Cards in
  `studio_content_registry.json` (data completeness, not user-facing).
- Normalize `category` string casing across Studio Content Registry
  entry types (`Fractions` vs `fractions`).
- Consider a small script/test that walks every `svgAssetPath`/icon
  reference across `visual_assets.json`/`formula_catalog.json` and
  asserts the file exists on disk — the same class of check this sprint
  added for Discovery Cards, generalized to the other two registries.

## Tests added

**`test/discovery_library_coverage_test.dart`** (10 tests) — regression-locks
the visibility fix and the illustration asset mapping:
- category counts match this audit's matrix exactly (7 populated
  categories at their audited counts, 4 still-empty categories still at
  zero, 24 cards total) — fails loudly if content changes without the
  docs being updated;
- no duplicate discovery card ids;
- every card's `illustrationAssetId` resolves to a real file under
  `assets/discovery_illustrations/`;
- every file under `assets/discovery_illustrations/` is referenced by
  at least one card (no orphans in either direction);
- the category chip row renders exactly 8 chips ("All" + the 7
  categories with content) — this is the fix's core regression lock;
- the 4 zero-card categories (Engineering & Construction, Art &
  Design, Business & Finance, Gaming) never render as selectable chips;
- every one of the 7 visible category chips is scrollable into view,
  tappable, and shows its grid rather than an empty state;
- dark theme, light theme, and a 320×568 narrow-phone viewport all
  render the now-larger 7-chip row without exceptions or overflow.

**`test/recall_cards_empty_state_test.dart`** (5 tests) — proves the
"never land on an unexplained blank screen" guardrail holds for every
known-empty Recall Cards filter combination:
- all 4 empty topic×type combinations (Ratio & Proportion×Vocabulary,
  Algebra×Meaning, Algebra×Real-World Connection,
  Probability×Meaning) render the explained "No cards found" message
  plus a working "Clear filters" affordance, and clearing filters
  actually leaves the empty state;
- `RecallReviewSessionScreen(cards: [])` completes immediately to the
  session-complete view rather than any blank/broken screen.

Both files use a phone-sized viewport (390×844) rather than
flutter_test's default desktop-sized surface — at desktop width the
Recall Cards filter section's "never truncate, show every option
inline" branch is tall enough on a short surface to push the
empty-state content below the viewport and (correctly) out of
`find`'s default on-screen scope, which is what a phone-sized surface
avoids while also matching real device usage.

Total suite: **1105/1105 passing** (1090 pre-existing + 15 new), after
`dart format .` (0 files changed) and `flutter analyze` (0 issues).

## Sprint 1 return report

**Result: PASS.**

**Current category inventory** (39 rows total — see
`docs/DISCOVERY_RECALL_CONTENT_MATRIX.csv` for the full machine-readable
version):
- Recall Cards (student): 6 topic categories + 8 type categories, all
  visible, 120 cards total.
- Recall Cards (parent): 10 categories, all visible, 20 cards total.
- Discovery Cards: 11 categories, 24 cards total.
- 3 informational rows flagging a Sprint 2 taxonomy gap (see below).

**Visible categories** (selectable in the UI today):
- All 14 Recall Cards student filters (6 topics, 8 types).
- All 10 Recall Cards parent categories.
- 7 Discovery categories: Sport (12), Shopping (2), Cooking (2),
  Everyday Life (2), Aviation (2), Trucking & Logistics (2),
  Healthcare (2) — the last 6 became visible this sprint via the fix
  below; previously only Sport cleared an arbitrary "≥3 cards" gate.

**Hidden valid categories:** none. Every category with ≥1 real card is
now visible — that was the entire point of the fix.

**Hidden empty categories** (correctly excluded — zero cards, so never
offered as a selectable chip): Discovery's Engineering & Construction,
Art & Design, Business & Finance, and Gaming (all 0 cards).

**Dead categories:** none found. No registry entry, filter, or chip
points at content that doesn't exist or a route that doesn't resolve.

**Files changed:**
- `lib/screens/discovery/discovery_library_screen.dart` — category
  visibility gate changed from "≥3 cards" to "≥1 card" (the root-cause
  fix for Sport dominating the Discovery Library).
- `test/discovery_library_coverage_test.dart` — new, 10 tests.
- `test/recall_cards_empty_state_test.dart` — new, 5 tests.
- `docs/DISCOVERY_RECALL_COVERAGE_AUDIT.md` — new (this file).
- `docs/DISCOVERY_RECALL_CONTENT_MATRIX.csv` — new.

`assets/config/studio_content_registry.json` was investigated for a
suspected difficulty-vocabulary mismatch and found, on cross-check
against its other two entries, to be an intentional and correct
normalization — reverted, not changed. See "Audit questions answered"
above.

**Tests added:** 15 (10 discovery, 5 recall cards); full suite now
1105/1105 passing.

**Total test count:** 1105.

**Recommended content-production order** (unchanged from the analysis
above, repeated here for the report): (1) resolve the Sprint 2
taxonomy gap for Architecture and Construction / Environment and
Climate / Computing and Cryptography before authoring their content;
(2) thicken the 6 categories that are PARTIAL today (Shopping,
Cooking, Everyday Life, Aviation, Trucking & Logistics, Healthcare)
per Sprint 2's brief; (3) populate the 4 HIDDEN_EMPTY categories
(Engineering & Construction, Art & Design, Business & Finance) that
already have enum + icon-fallback support and just need cards — Gaming
excepted, no immediate plan; (4) the deferred follow-ups list above
(parent-screen localization, registry completeness, casing
normalization, icon-reference validation generalized to other
registries) — none block Sprint 2 or Sprint 3.

No commit was made, per instruction.
