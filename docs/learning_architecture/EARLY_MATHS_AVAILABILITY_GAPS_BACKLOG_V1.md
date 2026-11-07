# Early Maths Availability Gaps — Backlog V1

**Status:** implementation record plus research/design backlog. The Early Maths lane-selection experience, per-learner local preference, and parent-led entry are implemented. The remaining items below are gaps only; they are not scheduled or promised. This document makes no claim that Early Maths or KS1 curriculum stages are available. It records what was **verified in this repository** and complements — rather than restates — `EARLY_MATHS_4_TO_7_LIFECYCLE_CONTRACT_V1.md`.

Evidence tag used throughout: **[R]** = read directly from this repository's source or assets during this pass. No book-derived, bibliographic or official-curriculum material was used, and none is asserted here.

## 1. Verified availability today

| Item | What actually exists **[R]** | Status |
|---|---|---|
| **Lane-selection experience** | The Early Maths hub offers *Early Maths Play*, *KS1 Maths Foundations*, and *I'm not sure*. The selection is a per-learner local preference, not placement, ability evidence, or a curriculum stage. | Implemented; does not change `CurriculumService`, practice stages, or manifest |
| **Feed the Hungry Panda** | A playable in-app Early Maths Play activity. Scope: feed 1–3 apples from 5, then answer how many are left. Offered for *Early Maths Play* and *I'm not sure* (`EarlyMathsLaneContent.childActivities`). | Available now — **narrow scope only** |
| **Visual Abacus** | A genuinely interactive visual place-value tool: learners tap or drag beads on Hundreds, Tens, and Ones rods; the Number Board mirrors the same state and supports bounded ±1/±10 changes. Guided examples practise building 34, breaking 47 into 40 and 7, and exchanging ten ones for one ten (29 + 1 = 30). Reaching a target shows a calm completion message; exchange changes have a written explanation. It is local and unscored. Offered from *KS1 Maths Foundations*. `VisualMathsToolMeta` marks it interactive, so the Visual Maths hub uses its *Interactive* label. | Implemented interactive learning tool; **not** a scored assessment, soroban course, or claim of full KS1 coverage |
| **Parent-led Family Maths** | Existing catalogue activities fitting the selected lane by declared age are reachable through a parent-PIN route. They remain parent-led; no child-facing in-app version is claimed. | Implemented parent-led entry |
| **Other early-maths activities** | The closed child-activity list contains only Panda and the Abacus. No other activity is surfaced as a tappable card. | Unavailable; not presented as active lessons or fabricated placeholders |
| **Curriculum stages** | `assets/config/curriculum_manifest.json` declares `early_years` and `KS1` with `hasContent: false`. | No manifest content — unchanged |

## 2. Recall Cards: "No cards found" is a content gap, not a layout fault

**[R]** `assets/config/recall_cards.json` holds 120 cards over 6 topics (Number, Ratio & Proportion, Algebra, Geometry & Measures, Statistics, Probability) and 8 card types. Filtering by topic **and** card type can therefore land on a combination with no authored card. Of the 48 topic × type combinations, **4 are empty**:

- Ratio & Proportion × Vocabulary
- Algebra × Meaning
- Algebra × Real-world connection
- Probability × Meaning

The screen already handles this correctly (a "No cards found" message plus a one-tap *Clear filters*), and the layout repair deliberately leaves it alone. It must not be "fixed" by inventing cards.

**[R]** The catalogue has **no early-maths topic**, and every card is curriculum-tagged `gcseFoundation`, `gcseHigher` or `igcse` — none is tagged for early years or Key Stage 1. There is therefore no Recall Card coverage for Early Maths, and none is claimed.

## 3. Backlog (unavailable, not promised)

| # | Gap | Notes |
|---|---|---|
| G1 | More than one genuine Early Maths Play activity | Today Panda is the only one; the lane has no second activity to offer. Needs a product decision and content review first. |
| G2 | Any Early Maths / KS1 Recall Cards | Requires a new topic value and authored, reviewed cards; the schema already allows additive topics. |
| G3 | Empty topic × type combinations (4, listed in §2) | Authoring decision, per combination; may reasonably stay empty. |
| G4 | `early_years` / `KS1` manifest content | Both stages remain `hasContent: false`. No lane or activity above changes that. |

## 4. Rules that hold until a backlog item is separately approved

1. An unavailable item is never presented as an active lesson or a working route. Do not invent a placeholder to fill a gap; if an unavailable state is shown in future, label it plainly.
2. Availability copy states real scope, not level, assessment, or curriculum coverage.
3. The Abacus is labelled as an interactive visual learning tool. Its guided completion and live place-value state are practice feedback, not a score or curriculum-stage completion.
4. No item above is evidence of full KS1 or Reception coverage; the manifest remains unchanged.
