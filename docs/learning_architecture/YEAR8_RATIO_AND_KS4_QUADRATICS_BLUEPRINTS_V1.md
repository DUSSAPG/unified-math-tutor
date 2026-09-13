# Year 8 Ratio & Proportion and KS4 Quadratic Equations — Original Blueprints V1

**Status:** design blueprints, not implemented. All task families, scenarios, and lab designs below are original to this document. Nothing here was copied, transcribed, or closely paraphrased from any book in `WORKBOOK_LIBRARY_MAP_V1.md`; those books informed only the abstract patterns named in `LEARNING_OBJECTIVE_ITERATION_CONTRACT_V1.md` (spiral mastery, bar-model-style visual reasoning, grade-banded practice, contextual investigation) — and even those patterns are only `bibliographic_inference_only` / low-confidence hypotheses about the referenced titles (see `WORKBOOK_LIBRARY_MAP_V1.md`'s evidence-level disclaimer), used here purely as design prompts. Every misconception, task family, and lab below was authored for this blueprint, not extracted or adapted from any specific reviewed book. Availability statuses below were checked against the actual current curriculum manifest (`assets/config/curriculum_manifest.json`) as of this sprint, not assumed.

---

## Exemplar 1 — Year 8 Ratio & Proportion

### Curriculum node and learning outcome

- Curriculum node: `ratio_proportion` at stage `KS3` (England Year 8 falls within KS3, Years 7-9).
- Learning outcome: *the learner can represent, simplify, scale, and reason about a ratio relationship — forward and in reverse — and can set up and solve an original contextual proportion problem, explaining why their method is valid.*

### Prerequisite map

| Prerequisite | Node | Why required |
|---|---|---|
| Simplifying fractions | `fractions::KS2` (or equivalent secure KS3 fractions work) | Ratio simplification uses the same "divide both by a common factor" reasoning |
| Multiplication/division fluency | `number_place_value` fluency at KS2/KS3 | Scaling a ratio is repeated multiplication/division |
| Understanding "per" / rate language | Upper-KS2 word-problem reasoning (a general pattern hypothesised, at `bibliographic_inference_only`/low confidence, from the Singapore-family upper-primary titles' branding — not their verified content, and not their specific wording either way) | Needed before rate-style contextual problems (Rung 6) make sense |

A learner without secure evidence on the fraction-simplification prerequisite is remediated there first — Rung 7 (synthesis) explicitly requires this prerequisite to already be Secure, not merely attempted.

### Misconception map (using the seven diagnostic families)

| Diagnostic family | How it shows up in ratio & proportion |
|---|---|
| Direction/sign | Scaling in the wrong direction (dividing when the ratio should be scaled up, or vice versa) |
| Magnitude/scale | Correct relationship, wrong scale factor applied (e.g. doubling one part but tripling the other) |
| Operation/transformation | Adding a constant to both parts instead of multiplying (the single most common ratio misconception) |
| Relation/equivalence | Believing 2:3 and 3:2 are the same relationship, or that equivalent ratios must have the same difference between terms |
| Representation/interpretation | Misreading which quantity a ratio's first/second term refers to in a bar-model or table representation |
| Completeness/process | Simplifying only one term of a ratio, leaving it not fully reduced |
| Strategy/method | Attempting a "find a common denominator" fraction method on a three-term ratio where it does not apply cleanly |

### Iteration rungs — original task families

All task families below are newly authored for this blueprint.

1. **Recognise** — *"Same relationship or different?"*: show several original pairs of ratios/rates (some equivalent, some a near-miss using an additive rather than multiplicative change) and ask the learner to sort them. Tests Relation/equivalence directly.
2. **Guided practice** — *"Scale the model"*: a partially-completed bar model showing one part scaled; the learner completes the other part, with the scale factor visible as a hint they can toggle off.
3. **Fluency variation** — independent two-term ratio simplification and scaling, numbers only varying.
4. **Structural variation** — introduce three-term ratios and part:whole (rather than part:part) framing.
5. **Reverse/missing-value** — given one part and the total, or given the simplified ratio and one original quantity, find the other original quantity.
6. **Contextual application** — an original scenario (e.g. an authored recipe-scaling or paint-mixing scenario, not drawn from any reviewed book) where the learner must recognise a ratio relationship is present at all, then solve it.
7. **Synthesis with prerequisites** — a scenario requiring both fraction simplification and ratio scaling in one authored task (e.g. simplifying a ratio that is first given as a fraction of a mixed-unit quantity).
8. **Spaced retrieval** — a delayed re-check reusing a Rung 4 (structural variation) task family with fresh numbers, at an authored interval (e.g. 5-9 days after Rung 7 mastery — exact interval to be set by whoever authors the production task family, not fixed here).

### Four-layer ladder and dimensionality

| Layer | Applies? | Dimensionality track(s) | Availability status |
|---|---|---|---|
| Calculate | Yes — Rungs 2-5, 8 | Symbolic calculation | **Available** — `ratio_proportion` at KS3 has real, tagged Topic Drill/Quick Start content in the current manifest today |
| Explain | Yes — Rung 6 setup/justification | Verbal/contextual reasoning | **Planned** — no authored "explain your setup" task family exists yet |
| Visualise | Yes — bar-model-style scaling view | Visual/2.5D representation | **Planned** — justified because seeing both parts of a ratio scale together, keeping their relationship visible, is not achievable through a static number alone |
| Applied Lab | Yes — see below | Dynamic applied ("4D") | **Planned** — not built |

**Justification for Visualise:** a static "3:5, scaled by 2 → 6:10" statement does not show *why* the relationship is preserved; a bar model where both parts visibly stretch together while their proportion is held constant makes the invariant visible in a way a number cannot.

**Justification for the Applied Lab (mixing/scale):** scaling a recipe or a paint-mix ratio while a *constraint* is present (e.g. "you only have 500ml of the first ingredient available — how much of everything else do you need, and does anything run out first?") requires the learner to see a live trade-off between scale and constraint that a single static question cannot represent — this is exactly the "rate of change / constraint / scale" justification test from `LEARNING_OBJECTIVE_ITERATION_CONTRACT_V1.md`.

### Applied Lab blueprint — "Mixing & Scale Lab"

- **Exact curriculum objective:** `ratio_proportion::KS3` — scaling a ratio under a real constraint.
- **Learner controls:** the target scale factor (a slider or stepped input), and which ingredient/quantity is treated as the limiting one.
- **What changes / what is invariant:** the absolute quantities of each part change; the *ratio between the parts* is invariant — the lab's whole point is showing that invariance under a changing constraint.
- **Prediction required before running:** the learner must state, before adjusting the scale, whether they expect to run out of the limiting ingredient before or after reaching their target scale.
- **Deterministic offline model:** pure arithmetic (ratio × scale factor, compared against a fixed authored quantity ceiling) — no randomness, no network call, fully reproducible from the authored starting ratio and ceiling.
- **Observable outcome:** the scaled quantities update live; if a quantity exceeds the ceiling, the lab visibly flags which ingredient ran out first.
- **Misconception checks:** an additive-scaling misconception (Operation/transformation family) shows up immediately as parts that no longer share the original ratio — the lab can flag this without telling the learner the answer.
- **Repair action:** on a wrong prediction, the lab shows the invariant ratio recomputed at both the start and current scale side-by-side, prompting a fresh prediction rather than immediately revealing the "fix."
- **Success evidence:** a `prediction_recorded` / `prediction_confirmed` or `prediction_revised` evidence event (schema in `DIAGNOSTIC_EVIDENCE_AND_MASTERY_LEDGER_V1.md`), tagged to Rung 6/Applied Lab.
- **Accessible non-animated equivalent:** a static table showing the same scaled quantities at three or four discrete scale factors, with the same prediction-then-reveal structure delivered as a sequence of questions instead of a live slider.
- **Reduce Motion behaviour:** the slider still functions, but quantity updates apply as an immediate value change with no animated transition; the "ran out" flag appears as a static labelled state, not a motion cue.
- **Deterministic/offline:** yes — no server dependency, no LLM involvement in scoring or feedback.

### Evidence and advancement rules

Per the general rule in `LEARNING_OBJECTIVE_ITERATION_CONTRACT_V1.md`: advancement from Rung 3 requires a deterministic accuracy threshold across a minimum item count (to be authored at production time, not fixed here — e.g. an illustrative "4 of 5 correct across at least two generated instances" is a reasonable starting point for a future author to adjust, not a rule fixed by this document). Rung 6/7 require both correct setup and correct interpretation, not merely a correct final number.

### Retention check

An authored Rung 8 check reusing the structural-variation (three-term ratio) task family, at a calendar delay set by whoever authors the production objective — this document specifies the mechanism, not the exact number of days.

### Accessibility

Every Visualise/Applied Lab representation has a text-equivalent description (for screen readers) stating the same relationship in words; all interactive controls are reachable via the app's existing accessibility/semantics patterns; reading-size, theme, and contrast settings apply exactly as they do elsewhere in the app (no bespoke styling introduced by this blueprint).

---

## Exemplar 2 — KS4 Quadratic Equations

### Curriculum node and learning outcome

- Curriculum node: today, quadratic equations are **not a separately tracked node** — they fall inside the general `algebra::KS4` topic in the current curriculum manifest. Checking the finer per-row tagging: a `quadratics_evaluate` subtopic does exist (real, tagged content for *evaluating* a quadratic expression), but nothing tagged for factorising or solving. This document does not claim a dedicated `quadratics::KS4` node, nor a factorising-specific subtopic, exists — see the honest availability note below.
- Learning outcome: *the learner can factorise an integer-root quadratic, explain what its roots mean in context, read key features from its graph, and (as an optional extension) connect the coefficients of a quadratic to a real applied model.*

### Prerequisite map

| Prerequisite | Node | Why required |
|---|---|---|
| Solving linear equations | `algebra::KS3`/`algebra::KS4` | Isolating a variable is reused inside factorising work |
| Expanding double brackets | `algebra::KS4` | The reverse of factorising |
| Directed-number arithmetic | `number_place_value` fluency | Sign errors are the dominant quadratic misconception |
| Reading a coordinate graph | `geometry_measures::KS3/KS4` (coordinate work) | Needed before the Visualise/Lab layers make sense |

### Misconception map

| Diagnostic family | How it shows up in quadratics |
|---|---|
| Direction/sign | Sign errors when factorising (e.g. choosing (x+3)(x-4) instead of (x-3)(x+4)) |
| Magnitude/scale | Correct factor pair, wrong assignment of which root is which |
| Operation/transformation | Attempting to "solve" by dividing through by x, losing a root |
| Relation/equivalence | Believing a factorised form and its expanded form are only "equivalent when solved," not always identical |
| Representation/interpretation | Misreading the graph's roots, turning point, or axis of symmetry |
| Completeness/process | Finding one root and stopping, forgetting a quadratic can have two |
| Strategy/method | Forcing a factorising method onto a quadratic that does not factorise over integers |

### Iteration rungs — original task families (integer-root factorising progression)

1. **Recognise** — classify expressions as "already factorised," "expanded," or "neither," and identify integer-root candidates from a short original list.
2. **Guided practice** — factorise with the sum/product pair scaffold shown (find two numbers that multiply to *c* and add to *b*), scaffold removable.
3. **Fluency variation** — independent factorising, coefficients varying, always integer roots.
4. **Structural variation** — introduce a non-unit leading coefficient and a difference-of-squares case as distinct structures.
5. **Reverse/missing-value** — given the two roots, construct the original quadratic.
6. **Contextual application** — an original scenario requiring the learner to set up a quadratic from a description (e.g. an area-based scenario) before solving it, then interpret which root is physically meaningful.
7. **Synthesis with prerequisites** — a task requiring both expansion and factorising in one authored problem (verify a claimed factorisation by expanding it first).
8. **Spaced retrieval** — a delayed re-check reusing Rung 4's structural-variation task family.

### Four-layer ladder and dimensionality

| Layer | Applies? | Dimensionality track(s) | Availability status |
|---|---|---|---|
| Calculate | Yes — Rungs 2-5, 8 | Symbolic calculation | **Available at the parent-topic level only.** `algebra` Topic Drill is available at KS4. Checked at the finer `subtopicId` tag: a `quadratics_evaluate` subtopic does exist in the tagged KS4 pack, but it covers *evaluating* a quadratic expression at a given value, not factorising or solving for roots — this blueprint's specific integer-root-factorising objective is **not** separately identifiable in the current tagging and is recorded as **unavailable (not yet a distinct authored objective)**, not assumed available from the parent topic's or the neighbouring subtopic's availability |
| Explain | Yes — Rung 6/7 | Verbal/contextual reasoning | **Planned** |
| Visualise | Yes — graph-reading | Visual/2.5D representation | **Planned** — justified because seeing how roots, the turning point, and the axis of symmetry relate on one graph is not achievable through algebra alone |
| Applied Lab | Optional extension only — see below | Dynamic applied ("4D") | **Planned** — explicitly an extension, not compulsory GCSE content |

### Applied Lab blueprint — "Trajectory/Modelling Lab" (optional extension)

**This lab is an applied extension aligned to quadratic modelling in general — it is not compulsory GCSE quadratics content, and it must never be presented as required to pass the core factorising objective above.** It uses the specific physical model:

```
y(t) = -(g / 2) * t^2 + vy0 * t + h0
```

where `g` is a fixed constant (not learner-adjustable, to keep the model physically honest), `vy0` is the learner-controlled initial vertical velocity, and `h0` is the learner-controlled initial height. This is clearly a *specific applied instance* of a quadratic, not a restatement of the general `ax^2+bx+c` factorising work above — the blueprint deliberately keeps the two visually and conceptually distinct so a learner never mistakes "projectile height over time" for "the standard form taught at Rung 1-8."

- **Exact curriculum objective:** an *extension* objective linked to, but distinct from, the core `algebra::KS4` factorising objective above — connecting coefficients of a quadratic to real key features (maximum height, time to reach it, when it lands).
- **Learner controls:** `vy0` (initial vertical velocity) and `h0` (initial height); `g` fixed.
- **What changes / invariant:** the shape of the curve changes with `vy0`/`h0`; the underlying quadratic *form* (still a quadratic in `t`) is invariant.
- **Prediction required before running:** the learner predicts whether increasing `vy0` will increase the maximum height, the time to landing, both, or neither, before adjusting it.
- **Deterministic offline model:** pure closed-form evaluation of the formula above at each `t`; no randomness, fully reproducible from the two learner-set inputs.
- **Observable outcome:** the curve redraws; the maximum-height point and the landing point (root) are labelled.
- **Misconception checks:** confusing "landing" with "reaching maximum height" (Representation/interpretation family); assuming a linear rather than quadratic relationship between `vy0` and maximum height (Relation/equivalence family).
- **Repair action:** on a wrong prediction, show the two labelled points side-by-side at the old and new settings, prompting the learner to re-state their prediction rather than revealing the rule directly.
- **Success evidence:** a `prediction_recorded`/`prediction_confirmed`/`prediction_revised` event tagged to the extension objective, distinct from the core factorising objective's evidence.
- **Accessible non-animated equivalent:** a static table of `(vy0, h0) -> (max height, landing time)` triples the learner reasons about directly, with the same predict-then-reveal structure.
- **Reduce Motion behaviour:** the curve updates as an immediate redraw with no animated tracing; labelled points appear instantly.
- **Deterministic/offline:** yes.

### Evidence and advancement rules

Same general rule as Exemplar 1: a deterministic accuracy threshold across a minimum item count per rung, authored at production time; Rung 6/7 require correct setup and correct interpretation, not just a correct final factorisation.

### Retention check

An authored Rung 8 check reusing Rung 4's structural-variation task family (non-unit leading coefficient / difference-of-squares), at an authored calendar delay.

### Accessibility

Same posture as Exemplar 1 — text-equivalent descriptions for every graph/lab state, full compatibility with the app's existing reading-size, theme, contrast, and Reduce Motion settings, no bespoke styling.
