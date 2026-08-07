# Applied Discovery Category Pack — Build Report (Sprint 2)

Status: **PASS**. Do not commit (per instruction) — all changes remain
in the working tree alongside the rest of the pre-existing uncommitted
work.

## Dependency on Sprint 1

This sprint used the approved findings from
`docs/DISCOVERY_RECALL_COVERAGE_AUDIT.md` and
`docs/DISCOVERY_RECALL_CONTENT_MATRIX.csv` as its starting point:
category visibility was already fixed, all 24 pre-existing cards were
confirmed READY, and the taxonomy gap for 3 of the 10 target categories
was already identified there rather than discovered mid-sprint.

## What was built

### 1. Taxonomy fix (the Sprint 1 blocker)

`DiscoveryCategory` (`lib/models/discovery_card.dart`) gained 3 new,
additive enum values: `architectureConstruction`, `environmentClimate`,
`computingCryptography` — distinct from the existing
`engineeringConstruction` and `gaming`, per the audit's explicit
recommendation. Each got:
- a category label in `discovery_category_labels.dart`, backed by new
  ARB keys (`mathStudioCategoryArchitectureConstruction`,
  `mathStudioCategoryEnvironmentClimate`,
  `mathStudioCategoryComputingCryptography`) added to the 5 enforced
  locale ARB files (`app_en.arb`, `app_en_GB.arb`, `app_de_CH.arb`,
  `app_fr_CH.arb`, `app_it_CH.arb`) and regenerated via
  `flutter gen-l10n`. The other 15 ARB files were left untouched — this
  mirrors the project's established convention (confirmed by
  inspection: existing category keys like
  `mathStudioCategoryHealthcare` are likewise only present in these
  same 5 files) where `flutter gen-l10n`'s template-fallback behaviour
  covers the rest, listed in `untranslated_messages.txt` rather than
  requiring translation before this content can ship.
- an icon + colour fallback entry in `DiscoveryIllustration`
  (`lib/widgets/discovery/discovery_illustration.dart`):
  `architectureConstruction` → `Icons.architecture_outlined` /
  `#B08968`; `environmentClimate` → `Icons.eco_outlined` / `#43A047`;
  `computingCryptography` → `Icons.computer_outlined` / `#546E7A`.

"Finance and Shopping" (one of Sprint 2's 10 named categories) was
mapped to the existing `shopping` enum value, matching Sprint 1's own
matrix recommendation for that category — `businessFinance` remains a
separate, still-empty, still-deferred value untouched by this sprint.

### 2. 30 new Discovery Cards

Three cards per category — one Foundation, one Intermediate, and one
Advanced card explicitly framed around a real-world job/career
connection (e.g. a structural engineer's safety factor, a paramedic
crew's average response time, a pilot's fuel reserve, an architect's
roof pitch, a retail buyer's profit margin, a climate scientist's
temperature trend, a cryptographer's Caesar cipher, an animator's frame
count, a head chef's food cost, an electrician's job quote) — across
the 10 target categories:

| Category | Enum value | Cards before | Cards after |
|---|---|---|---|
| Engineering | `engineeringConstruction` | 0 | 3 |
| Healthcare | `healthcare` | 2 | 5 |
| Aviation | `aviation` | 2 | 5 |
| Architecture and Construction | `architectureConstruction` (new) | 0 | 3 |
| Finance and Shopping | `shopping` | 2 | 5 |
| Environment and Climate | `environmentClimate` (new) | 0 | 3 |
| Computing and Cryptography | `computingCryptography` (new) | 0 | 3 |
| Art/Design and Animation | `artDesign` | 0 | 3 |
| Cooking and Measurement | `cooking` | 2 | 5 |
| Everyday Life | `everydayLife` | 2 | 5 |

Catalog total: **24 → 54 cards**. Trucking & Logistics and the
already-deferred Gaming/Business & Finance categories were untouched —
not in Sprint 2's scope.

Every card follows the existing 14-field schema exactly
(`id`, `category`, `sport: null`, `difficulty`, `curriculumTags`,
`illustrationAssetId`, `relatedDisciplineIds` [2 cross-linked
categories, matching the existing convention], `contentVersion: 1`,
`followUp` [locale-neutral numeric answer + unit, matching the
existing single-object-not-per-locale convention], and `locales`).
Every scenario's numbers were hand-verified arithmetically before
being written (e.g. brick count, gradient percentage, safety factor,
dosage, drip rate, mean response time, boarding time, baggage
overage %, fuel reserve, floor area, scale conversion, roof pitch via
`arctan`, unit pricing, loyalty-point value, profit margin, recycling
rate, carbon footprint, mean temperature rise, download time, binary
conversion, Caesar-cipher modular arithmetic, poster scaling, paint
ratio, animation frame count, oven-temperature conversion, recipe
ratio scaling, food cost %, fuel cost, break-even minutes, and job
quote) — both the main challenge's worked answer and the separate
follow-up question's answer.

**Confirmation: no copyrighted question was copied.** Every scenario,
number, and worked solution was originated for this pack; none were
sourced from an external question bank, textbook, or past paper.

### 3. Localisation (5 enforced locales)

Every one of the 30 cards has full `en`, `en-GB`, `de-CH`, `fr-CH`, and
`it-CH` text. `en-GB` mirrors `en` verbatim, matching the existing
`shopping-percentage-discount` card's own precedent (British English
content needs no separate translation from `en`). `de-CH`/`fr-CH`/
`it-CH` are genuine, independently-authored translations — not
machine-templated substitutions — using CHF in place of £ (numbers
unchanged) and following the catalog's established **ASCII-safe**
convention for this content type (confirmed by inspection of existing
cards: `de-CH` uses `ae`/`oe`/`ue` instead of umlauts, `fr-CH`/`it-CH`
drop accents — e.g. "coute" not "coûte", "Schaetze" not "Schätze" —
even though the surrounding ARB files elsewhere use full accented
text). This was deliberately matched rather than "corrected", to stay
consistent with the rest of `discovery_cards.json` and avoid
reintroducing the encoding risk noted in earlier sessions
(`feedback_comfyui_text_free_illustrations`-adjacent memory:
mojibake corruption was previously fixed in this project's ARB
pipeline).

### 4. Art / icon governance

**No new image generation.** No ComfyUI, no new PNGs. Every pack
card's `illustrationAssetId` is a fresh, descriptive id that
deliberately does **not** match any of the 24 pre-existing approved
illustration ids — confirmed by an explicit test
(`no pack card illustrationAssetId collides with a pre-existing
approved id`). This means every pack card renders through
`DiscoveryIllustration`'s existing, already-governed icon-placeholder
fallback (a coloured rounded tile + Material icon) rather than
borrowing an unrelated category's photo — exactly the "existing/
governed icon placeholders" instruction.

## Fix required in Sprint 1's own tests

Adding real content to `engineeringConstruction` and `artDesign`
(previously zero-card, "hidden empty" categories used as regression
fixtures in Sprint 1's tests) meant two existing tests needed
deliberate updates, not silent breakage:

- `test/discovery_library_coverage_test.dart` — category counts,
  chip-count (8 → 13), and the visible/hidden category lists were
  updated to the new totals. The illustration-file test was also
  **rescoped**: it previously asserted every card resolves to a real
  PNG, which was only true because, coincidentally, all 24 RC1 cards
  happened to have approved art. That assertion would have wrongly
  forced this sprint to either fake illustration ids or generate new
  art. It now correctly asserts the real invariant — every *approved*
  PNG is referenced by ≥1 card, and the file count stays locked at 24 —
  plus a new widget test proving a card with no production art renders
  the icon fallback cleanly (no broken-image glyph).
- `test/discovery_card_schema_test.dart` — card-count assertion
  (24 → 54) and the "deferred categories" test's category list (which
  named `engineeringConstruction`/`artDesign` as having "no RC1 card" —
  no longer true) were updated; a new test locks that the 3 new enum
  values parse correctly.
- `test/rc1_responsive_hardening_test.dart` — an even older E3 test
  asserted `engineeringConstruction`'s chip doesn't render, citing a
  pre-Sprint-1 gap-audit doc. Its premise is now false; it was switched
  to `gaming` (still genuinely empty) to preserve the test's actual
  intent (a zero-card category's chip must never render) rather than
  leaving it passing for the wrong reason.
- `test/math_studio_pillar_reachability_widget_test.dart` — an
  unrelated navigation test's `scrollUntilVisible` call landed its
  target a few pixels below the fold once the Discovery grid grew from
  24 to 54 cards (a real flake this sprint's content volume triggered,
  not a functional break); a follow-up `ensureVisible()` call was added
  to settle the scroll position before tapping.

## Tests added

**`test/applied_discovery_pack_test.dart`** (16 tests):
- exactly 30 new cards registered across the 10 target categories;
- each target category has exactly one foundation/intermediate/advanced
  pack card, correctly categorised;
- every pack card has all 5 enforced locales with every field non-empty
  (including each worked step);
- every pack card has a numeric `followUp.answerValue` and exactly 2
  valid `relatedDisciplineIds` cross-links;
- no pack card's `illustrationAssetId` collides with a pre-existing
  approved id;
- the 3 new category labels are non-empty in all 5 enforced locales;
- a detail-screen smoke test per category (10 tests) — one
  representative pack card each — renders without exception and
  reaches "Worked solution" after tapping Reveal.

**`test/discovery_card_schema_test.dart`** (+1 test): the 3 new
category ids parse via `DiscoveryCategory.fromId` without error.

Both `test/discovery_card_schema_test.dart`'s existing "CH locale
titles do not silently leak the English string" and "every card has
real, non-empty text for all 5 production locales" tests now also run
over all 30 new cards unmodified — an independent cross-check of the
translation work above, and both pass.

Total suite: **1122/1122 passing** (1105 after Sprint 1 + 17 new),
after `dart format .` (2 cosmetic reformats, 0 content changes) and
`flutter analyze` (0 issues).

## Guardrail compliance

- No large new card collection beyond the specified 30 — no filler
  cards, no categories outside the 10 named.
- No new icon/image generation; no ComfyUI dependency added.
- No unrelated app architecture changed — the only non-content changes
  are the 3 additive enum values, their label/icon/colour wiring, and
  the ARB entries required to display them, all directly required by
  the brief.
- No category was exposed without usable content — every new/thickened
  category has 3–5 real cards before its chip became selectable.
- Never left a category selectable-but-broken: the chip visibility
  rule from Sprint 1 (`> 0` cards) continues to gate exactly which
  chips render, unchanged.

## Return report

- **PASS/FAIL:** PASS.
- **Files changed:** `lib/models/discovery_card.dart`,
  `lib/screens/discovery/discovery_category_labels.dart`,
  `lib/widgets/discovery/discovery_illustration.dart`,
  `lib/l10n/app_en.arb`, `app_en_GB.arb`, `app_de_CH.arb`,
  `app_fr_CH.arb`, `app_it_CH.arb` (+ their regenerated
  `app_localizations*.dart` outputs),
  `assets/config/discovery_cards.json` (24 → 54 cards),
  `test/discovery_library_coverage_test.dart`,
  `test/discovery_card_schema_test.dart`,
  `test/rc1_responsive_hardening_test.dart`,
  `test/math_studio_pillar_reachability_widget_test.dart` (updated),
  `test/applied_discovery_pack_test.dart` (new),
  `docs/APPLIED_DISCOVERY_PACK_BUILD_REPORT.md` (new),
  `docs/DISCOVERY_RECALL_COVERAGE_AUDIT.md` (resolution note appended).
- **Tests added:** 17 (16 new file + 1 in the existing schema test).
- **Total test count:** 1122/1122 passing.
- **Confirmation:** no copyrighted question was copied — all 30
  scenarios were originated for this pack.
- **No commit made**, per instruction.

Sprint 3 (Entrance Exam Foundation) is next, per the stated sequencing.
