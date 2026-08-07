# Production Polish Audit

Status: NOT COMMITTED — reviewed on device before commit, per this
session's standing rule.

## Scope

Per the brief: work only within the existing Math Intelligence Flutter
application. No redesign of architecture, onboarding, authentication, the
navigation model, the adaptive engine, the entitlement system, or the
existing Studio framework. No new functionality — production polish only.
Four tasks: fix every RenderFlex overflow, replace every empty state,
audit every navigation path for dead ends, and report the results here.

Every fix below is a minimal, targeted change to the specific widget that
was broken — no screen was rearchitected, no route was added or removed,
no new feature was introduced.

## 1. RenderFlex overflow sweep

### Method

Added `test/polish_audit_overflow_sweep_test.dart`: every static (or
single-catalog-verified-sample-id) route in `router.dart` — 72 routes —
pumped across the audit's 4 named device categories (Mobile/Pixel 6a
412×915, Tablet 768×1024, Web/Desktop 1280×800, Landscape 844×390), 288
combinations total, asserting zero exceptions. A RenderFlex overflow
throws during layout in a Flutter widget test — it does not just paint the
yellow/black stripes and continue — so "no exception" is a direct,
mechanical proxy for "no overflow indicator," not an approximation. This
test now runs as a permanent part of the suite (855 tests total, up from
567), so any future regression on any of these 72 routes/4 device
categories is caught automatically going forward.

First run surfaced 15 failures (13 real render bugs across 5 distinct
screens, plus 2 test-setup gaps of my own — a missing
`TutorCreditService.instance.init()` call in the sweep's own `setUp`,
unrelated to the app itself, confirmed by checking `core/bootstrap.dart`
already calls it correctly at real app startup).

### Fixed

| Screen | Cause | Fix |
|---|---|---|
| Sign In (`/auth/sign-in`) | "Don't have an account? Create one" `Row` overflowed by 97–115px on **every** device category — the row sits inside a `ConstrainedBox(maxWidth: 430)`, so screen width never rescued it | Converted to `Wrap` with a tight `TextButton.styleFrom` (zero min size, shrink-wrap tap target) — the exact pattern already established in `user_type_screen.dart` for the identical prompt |
| Create Account (`/auth/create`) | Same pattern, "Already have an account? Sign in" | Same fix |
| Settings → Terms (`/profile/terms`) | Each policy section's header `Row` (icon + all-caps, letter-spaced title) overflowed by a sub-pixel on the narrowest phone width | Wrapped the title `Text` in `Expanded` + `TextOverflow.ellipsis` |
| Settings → Release Notes (`/release-notes`) | The version-row (`v0.1-alpha` + status badge + date) overflowed by 14px on the narrowest phone width | Wrapped the `date` `Text` in `Flexible` + `TextOverflow.ellipsis`, keeping the existing `Spacer` for right-alignment |
| Visual Maths → Abacus (`/math-studio/visual-maths/abacus`) | The shared `VisualMathsPlaceholderScaffold` (also used by Fraction Bars and Place Value Explorer) never scrolled; on a short landscape viewport (390px tall) the fixed content column overflowed the bottom by 130px | Wrapped the scaffold's content `Column` in a `SingleChildScrollView` — fixes all 3 placeholder screens that share this scaffold, not just Abacus, since none of them scrolled before |

All 5 fixes verified by re-running the full 288-combination sweep: **0
failures** after fixes (`flutter test test/polish_audit_overflow_sweep_test.dart` — 288/288 pass).

## 2. Empty states

### Investigated: the brief's named example

"Recall Cards → Algebra → Meaning currently displays no cards" — confirmed
against the real catalog: `algebra` topic has 0 `meaning`-type cards (it
has `formula`/`misconception`/`strategy`/`symbol`/`visual`/`vocabulary`
cards, just not `meaning`). Auditing all 48 topic×type combinations found
4 that are genuinely empty:  `algebra/meaning`, `algebra/realWorldConnection`,
`ratioAndProportion/vocabulary`, `probability/meaning`.

**Before**: selecting an empty topic+type combination showed a small
static "No cards found" message with no way forward except manually
deselecting each of the two separate filter chip rows.

**Fixed**: `recall_cards_browse_screen.dart` — when the empty state is
reached with an active topic and/or type filter, a "Clear filters" button
now appears beneath the message (reusing the screen's own existing
`_clearFilters()` method and the already-translated
`recallCardsClearFiltersButton` string — no new localisation work needed).
This directly satisfies the brief's own resolution option ("display
available cards from another compatible card type") in one tap, without
inventing new filter-substitution logic.

### Investigated, no fix needed (already safe or already handled)

- **Discovery Library** (`/math-studio/discovery`) — category filter chips
  are only ever generated from categories that actually have ≥3 authored
  cards (`reviewerReadyCategories`), so the filtered-empty state is
  structurally unreachable via the UI. Same protective pattern already
  covers **Formula Library**'s category chips (derived from `all.map((e)
  => e.category).toSet()`) and **Family Maths Library**'s category chips
  (already covered by an existing test, `family_maths_layout_test.dart`,
  asserting unauthored categories never appear as a chip).
- **Formula Library search** (category + free-text search combined) can
  produce zero results, but the search field and the selected category
  chip stay visible above the empty message the whole time — clearing
  either is already a single, obvious tap on already-visible controls, not
  a dead end.
- **Recall Cards Bookmarks** (`/math-studio/recall-cards/bookmarks`) — a
  new user's empty bookmark list already shows a purpose-written,
  actionable message ("No bookmarks yet — tap the bookmark icon on any
  card to save it here"). This is an expected zero-state (an empty inbox),
  not a content gap, and was already well-handled.
- **Mental Maths** — all 10 `MentalMathsCategory` values have authored
  challenges; no empty category exists.

## 3. Navigation dead-end audit

Grepped every `context.push`/`context.go`/`Navigator.push` call site in
`lib/` (~100 sites) and cross-referenced each literal target against
`router.dart`'s actual route tree, building on the app-wide push-site audit
already on file from an earlier sprint (RC2 report §13), which had already
flagged one **confirmed, un-fixed dead link** at the time: `/topics/:id`
has no matching route (`/topics` takes no path parameter and
`TopicsScreen` has no filtering capability), so tapping a "related topic"
chip from an Interactive Lab or a Recall Card went nowhere.

### Fixed

- `lib/widgets/labs/lab_related_links.dart` and
  `lib/widgets/recall/recall_card_body.dart` — both `context.push('/topics/$id')`
  call sites now `context.push('/topics')`, landing on the real Topics
  screen instead of an unmatched route. This is the minimal fix — pointing
  the link at an existing valid destination — rather than building new
  topic-filtering functionality into `TopicsScreen`, which the brief's "no
  new functionality" constraint rules out.

### Also checked, no dead link found

- Every hardcoded Recall Card ID, Discovery Card ID, and practice-topic ID
  referenced from the 7 Interactive Lab screens' `LabRelatedLinks` — all
  resolve to a real catalog entry (cross-checked against
  `recall_cards.json`/`discovery_cards.json` directly).
- `RecallCard.relatedDiscoveryCardIds` / `relatedPracticeTopicIds` (data-driven,
  not hardcoded in Dart) — already covered by existing tests in
  `recall_card_schema_test.dart` that fail the whole suite if any entry
  references an unknown id.
- All ~100 `push()`/`go()` call sites app-wide — none target an
  unregistered route path.
- Bottom sheets and dialogs (`showModalBottomSheet`/`showDialog` call
  sites, 17 files) — all self-contained (return a value to the caller or
  simply dismiss); none navigate onward to a further destination that
  could itself be broken.

## 4. Intentional placeholders (left as-is, correctly labelled)

These are deliberately unfinished features that are already honestly
labelled as such — not polish bugs:

- Visual Maths → Fraction Bars / Abacus / Place Value Explorer all carry a
  visible, permanent "Preview" badge and an italic "coming in a future
  release" note (`visualMathsPreviewBadge` / `visualMathsComingSoonNote`).
- Recall Card detail's "Related Interactive Labs" chips render as
  non-interactive `Chip`s labelled "… · Coming soon" rather than as
  tappable `ActionChip`s — an honest, already-correct treatment of a
  not-yet-built cross-link, left untouched by this pass.
- Release Notes' own "UPCOMING v0.2-alpha" section is itself the app's
  self-documented roadmap; not a bug.

## 5. Explicitly not fixed this pass (documented, deferred)

- **Raw internal ids shown as chip labels**: `LabRelatedLinks` and
  `RecallCardBody`'s `_RelatedLinks` both render `Text(id)` directly for
  Recall Card and Discovery Card cross-links (e.g. a chip literally reads
  "algebra-solve-linear-equation" instead of a human title). This is a
  real, visible rough edge, but fixing it properly requires each widget to
  resolve titles via the async `RecallCardCatalogService`/
  `DiscoveryCardCatalogService` rather than rendering a bare string prop —
  a wider change than a same-pass, low-risk polish fix, and arguably closer
  to new functionality (async title resolution) than the brief's "no new
  functionality" bar comfortably allows. Flagged here as a real follow-up
  candidate, not silently left unnoticed.

## Validation

- `dart format` — applied to all 9 touched files.
- `flutter analyze` (whole project) — **No issues found.**
- `flutter test --concurrency=1` (full suite) — **855/855 pass** (567
  baseline + 288 new from the overflow sweep), 0 regressions.
- New permanent regression coverage:
  `test/polish_audit_overflow_sweep_test.dart` (288 tests, one per
  route×device-category combination).

## Manual verification checklist (reviewer, Pixel 6a)

- [ ] Sign In and Create Account screens — the "don't have an account" /
      "already have an account" prompt row no longer clips or shows a
      yellow/black overflow stripe, portrait and landscape.
- [ ] Settings → Terms of Use — long section headers (e.g. "CHILDREN &
      PARENTAL CONSENT") truncate cleanly instead of overflowing.
- [ ] Settings → Release Notes — the version/badge/date row never clips,
      even at large text scale.
- [ ] Visual Maths → Abacus / Fraction Bars / Place Value Explorer in
      landscape — the whole card now scrolls instead of clipping content
      off the bottom.
- [ ] Recall Cards → Browse → filter to Algebra + Meaning (or any other
      empty combination) — a "Clear filters" button now appears under the
      empty message and successfully returns to the full card list.
- [ ] From an Interactive Lab (e.g. Algebra Balance) or a Recall Card
      detail screen, tap a "related practice topic" chip — it now opens
      the real Topics screen instead of doing nothing.

Not committed — per this task's instruction, awaiting the reviewer's
Pixel 6a pass before any commit.
