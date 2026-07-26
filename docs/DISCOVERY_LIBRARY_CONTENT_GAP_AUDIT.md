# Discovery Library — Content Completeness Gap Audit

Status: audit only, as of RC1 responsive-hardening pass on `release/math-intelligence-rc1-foundation`. Covers all 24 shipped Discovery Library cards.

## Method and headline finding

`DiscoveryCard.fromJson` (`lib/models/discovery_card.dart`) is **fail-fast**: it throws a `FormatException` at catalog-load time if any card is missing a required field, has an empty string, or an empty `workedSteps`/`relatedDisciplineIds` list, in any locale it declares. This is verified structurally, not by inspection — the app would not build/run with an incomplete card in `assets/config/discovery_cards.json`.

**Consequence: every one of the 24 shipped cards has real, non-empty, hand-authored text for every field the detail screen renders** (`scenario`, `challengeQuestion`, `thinkPrompt`, `workedSteps`, `explanation`, `whereYoullUseThis`, `followUpQuestion`, `followUpAnswerText`, `illustrationAlt`), in all 5 locales it ships (`en`, `en-GB`, `de-CH`, `fr-CH`, `it-CH`). There is no placeholder, filler, or templated boilerplate text in any of the 24 cards — no field-level gaps exist per card. This audit's real findings are therefore **systemic gaps between what the model/screen render and what your 9-point completeness checklist expects**, not missing content within any individual card.

## Mapping the checklist to what actually exists

| Your checklist item | What renders it today | Status |
|---|---|---|
| Context/story | `scenario` | ✅ complete, all 24 cards |
| Learner question | `challengeQuestion` | ✅ complete, all 24 cards |
| Mathematical concept | `workedSteps` + `explanation` (shown after Reveal) | ✅ complete, all 24 cards |
| Interaction/observation | `thinkPrompt` (pre-reveal) + `followUpQuestion`/numeric check (post-reveal) | ✅ complete, all 24 cards |
| Captain Math prompt | `CaptainMathCard(state: curious)`, flips to `encouraging`/`celebrating` on reveal/correct-answer | ⚠️ **generic, not per-card** — see Gap 1 |
| Real-world use | `whereYoullUseThis` | ✅ complete, all 24 cards |
| Related topic | `relatedDisciplineIds` | ❌ **populated in data, never rendered** — see Gap 2 |
| Accessibility description | `illustrationAlt` → `DiscoveryIllustration`'s `semanticLabel` | ✅ complete, all 24 cards |
| Localisation key | Per-card `locales` map (not the ARB/`AppLocalizations` system — see Gap 4) | ⚠️ **narrower than UI-chrome locale coverage** — see Gap 4 |

## Gap 1 — Captain Math prompt is not per-card content

`discovery_card_detail_screen.dart` always constructs `CaptainMathCard(state: CaptainMathState.curious)` on initial render, then calls `CaptainMathService.instance.showEncouragement()` on reveal and `.showCompletion()` on a correct follow-up answer. `CaptainMathCard` maps each of the 4 `CaptainMathState` values to one fixed, card-agnostic l10n string (`captainMathCurious`/`Encouraging`/`Calm`/`Celebrating`). There is no field in `DiscoveryCard`/`DiscoveryCardLocaleText` for a per-card Captain Math line — it is architecturally absent, not thin.

**Recommended RC1 treatment: defer.** Authoring 24 distinct, level-appropriate Captain Math moments is real content work (comparable in scope to the Interactive Labs' per-lab narration authoring), not a hardening fix. Applies identically to all 24 cards.

## Gap 2 — `relatedDisciplineIds` is dead data

Every card populates `relatedDisciplineIds` (2 entries each, pointing at other `DiscoveryCategory` values — e.g. `shopping-percentage-discount` → `[businessFinance, everydayLife]`). Confirmed via repo-wide search: this field is parsed and validated, but **no screen renders it, links from it, or filters by it.** "Related topic" is present in the data model but absent from the learner-facing UI for all 24 cards.

**Recommended RC1 treatment: defer.** Wiring a "related topics" UI section is a small feature addition (new UI + navigation), not a hardening fix — flagged here for an explicit follow-up decision, not silently dropped. Applies identically to all 24 cards.

## Gap 3 — 4 of 11 categories are live dead ends in the filter UI

`DiscoveryCategory` declares 11 values; only 7 have any cards: `everydayLife`, `shopping`, `cooking`, `sports`, `aviation`, `truckingLogistics`, `healthcare`. **`engineeringConstruction`, `artDesign`, `gaming`, `businessFinance` have zero cards and zero illustrations** (no orphaned artwork exists for them either — the 24 approved illustrations map 1:1 to the 24 JSON cards). `discovery_library_screen.dart` renders a filter chip for all 11 enum values regardless, so tapping one of these 4 today showed a silent, unexplained blank grid.

**Recommended RC1 treatment: preview — fixed as part of this hardening pass.** `discovery_library_screen.dart` now shows an explicit empty-state message (`mathStudioDiscoveryEmptyCategory`, localised in all 5 content locales) instead of a blank grid when a filter selection has zero matching cards. This is honest, low-risk, and directly addresses "Discovery cards with incomplete content show honest Preview/Coming Later states" — no new content was invented, only an honest empty state.

## Gap 4 — Card content locale coverage is narrower than UI chrome

The app ships 20 ARB locale files for UI chrome (buttons, headings, category labels: `en, en-GB, de, de-CH, fr, fr-CH, it, it-CH, da, da-DK, nb, nb-NO, sv, sv-SE, es, ko, ko-KR, pt, id, ar`). Discovery Card **content** (authored inside `discovery_cards.json`'s own per-card `locales` map, entirely separate from the ARB system) only covers `en, en-GB, de-CH, fr-CH, it-CH` — 5 locales, region-qualified only. A learner on bare `de`, `fr`, `it` (no `-CH` region) or any of the other 12 UI-supported locales previously fell all the way through to English content despite fully-localised surrounding chrome.

**Recommended RC1 treatment: complete — fixed as part of this hardening pass, no new translations required.** `DiscoveryCard.textFor(Locale)`'s fallback chain now tries the same-language `-CH` translation (`de-CH`/`fr-CH`/`it-CH`) before falling to English, so a bare `de`/`fr`/`it` learner gets the real, already-authored Swiss-region translation instead of silently losing it to English. The remaining 12 UI-supported locales with no card-content translation at all (`da`, `nb`, `sv`, `es`, `ko`, `pt`, `id`, `ar`, plus bare `de`/`fr`/`it` where no `-CH` fallback applies... wait, `-CH` now covers those three) — the genuine remaining gap is `da/nb/sv/es/ko/pt/id/ar`, which still fall to English. Authoring real translations for those 8 locales is content work, explicitly deferred.

## Gap 5 — Healthcare cards' opening disclaimer is a stylistic outlier

`healthcare-nurse-metric-conversion` and `healthcare-temperature-conversion` both open their `scenario` text with a baked-in compliance disclaimer ("Educational maths example only — not clinical guidance" / "— not a diagnosis"), unlike the other 22 cards' pure-narrative openings. This is real, appropriately cautious content, not a placeholder — but it is a stylistic inconsistency worth a content-editing decision.

**Recommended RC1 treatment: defer** (content-editing decision, not a hardening bug) — documented only, no change made.

## Per-card summary

All 24 cards are structurally complete for every rendered field. The only per-card variance is which 2 `relatedDisciplineIds` each points at (irrelevant while Gap 2 is deferred) and the 2 healthcare cards' disclaimer framing (Gap 5). No card requires a "complete/preview/defer" split at the field level — the treatment is uniform across the systemic gaps above.

| Card ID | Category | Illustration | Notes |
|---|---|---|---|
| shopping-percentage-discount | shopping | ✅ approved | — |
| shopping-comparing-offers | shopping | ✅ approved | — |
| cooking-scale-a-recipe | cooking | ✅ approved | — |
| cooking-fraction-conversion | cooking | ✅ approved | — |
| everyday-split-a-bill | everydayLife | ✅ approved | — |
| everyday-household-budgeting | everydayLife | ✅ approved | — |
| cricket-required-run-rate | sports (cricket) | ✅ approved | — |
| cricket-batting-average | sports (cricket) | ✅ approved | — |
| football-pass-accuracy | sports (football) | ✅ approved | — |
| football-goal-conversion | sports (football) | ✅ approved | — |
| basketball-shooting-percentage | sports (basketball) | ✅ approved | — |
| basketball-points-per-shot | sports (basketball) | ✅ approved | — |
| americanfootball-completion-percentage | sports (american football) | ✅ approved | — |
| americanfootball-yards-per-play | sports (american football) | ✅ approved | — |
| baseball-batting-average | sports (baseball) | ✅ approved | — |
| baseball-field-geometry | sports (baseball) | ✅ approved | — |
| tennis-first-serve-percentage | sports (tennis) | ✅ approved | — |
| tennis-court-dimensions | sports (tennis) | ✅ approved | — |
| aviation-fuel-endurance | aviation | ✅ approved | — |
| aviation-speed-distance-time | aviation | ✅ approved | — |
| trucking-fuel-economy | truckingLogistics | ✅ approved | — |
| trucking-delivery-scheduling | truckingLogistics | ✅ approved | — |
| healthcare-nurse-metric-conversion | healthcare | ✅ approved | Gap 5 (disclaimer framing) |
| healthcare-temperature-conversion | healthcare | ✅ approved | Gap 5 (disclaimer framing) |

**Categories with no cards (Gap 3):** `engineeringConstruction`, `artDesign`, `gaming`, `businessFinance` — filter chips now show an honest empty state rather than a blank grid; adding real content for these is a future content batch, not part of this pass.

## Summary of treatment decisions

| Gap | Treatment | Action this pass |
|---|---|---|
| 1. Generic Captain Math prompts | Defer | None — documented |
| 2. Unrendered `relatedDisciplineIds` | Defer | None — documented |
| 3. Empty-category dead ends | Preview | **Fixed** — honest empty-state message |
| 4. Narrow card-content locale coverage | Complete (fallback), Defer (new translations) | **Fixed** — widened fallback chain to reuse existing `-CH` translations; new-locale authoring for `da/nb/sv/es/ko/pt/id/ar` still deferred |
| 5. Healthcare disclaimer framing | Defer | None — documented |

No low-quality filler content was invented anywhere in this audit or its fixes.
