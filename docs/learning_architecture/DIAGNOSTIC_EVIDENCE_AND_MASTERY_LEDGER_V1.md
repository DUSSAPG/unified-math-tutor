# Diagnostic Evidence and Mastery Ledger V1

**Status:** design contract, not implemented. No telemetry, storage schema, dashboard, or backend is created by this document — it specifies the shape any future implementation must follow.

This ledger is what `LEARNING_OBJECTIVE_ITERATION_CONTRACT_V1.md`'s "evidence" and "diagnostic interpretation" steps actually populate. Every rung-advancement rule in that document reads from the ledger defined here.

---

## Part D — Diagnostic evidence contract

### Why not three generic error codes

A universal three-code model ("careless / conceptual / other") cannot distinguish a sign error from a scale error, or a mislabelled diagram from a genuinely wrong method — and it invites exactly the kind of numerical-coincidence pattern-matching (e.g. "the wrong answer is congruent to the right one mod 9, so it must be a specific known slip") that is not reliable evidence of *why* a learner made an error. Diagnosis must be tied to an authored, task-family-specific signature, not inferred after the fact from the numbers alone.

### Universal diagnostic families

Every task family's authored plausible-error signatures must be classified under one of these seven families. The families are universal (they apply across all objectives); the specific signatures within a family are authored per task family, not inferred generically.

| Family | Covers |
|---|---|
| **Direction / sign** | Wrong direction of change, wrong sign, inverted comparison (e.g. treating a decrease as an increase) |
| **Magnitude / scale** | Correct structure, wrong order of magnitude (e.g. a misplaced decimal, a scale-factor slip) |
| **Operation / transformation** | Applied the wrong operation or transformation entirely (e.g. multiplied where division was needed) |
| **Relation / equivalence** | Misjudged whether two things are equal, proportional, or related as claimed |
| **Representation / interpretation** | Correct underlying maths, wrong reading or construction of a diagram/model/graph |
| **Completeness / process** | Right approach, incomplete execution (a step skipped or left unfinished) |
| **Strategy / method** | A viable alternative method was chosen but misapplied, or an inefficient method was forced onto a structure it does not suit |

### Authored, per-task-family signatures

Each task family may define a **small, authored** set of plausible-error signatures (typically 2-5), each naming: which family it belongs to, what specific wrong learner action produces it, and what the correct contrasting action is. A signature must be authored by whoever designs the task family — it is never inferred generically from the numeric relationship between the learner's answer and the correct answer (no "mod 9," no "off by a common factor," no other numerical-coincidence heuristic standing in for real diagnosis). If a wrong answer does not match any authored signature for that task family, it is recorded as **unclassified** — an honest gap, not a forced guess.

### Local evidence event schema

One record per attempt. Privacy-preserving and local-only: no name, email address, raw conversation text, or persistent cross-app student identifier is ever included. A profile-scoped local id (already used elsewhere in the app's learner-profile model) is the only identifier.

```jsonc
{
  "schemaVersion": 1,
  "curriculumNodeId": "string — e.g. 'ratio_proportion::KS3'",
  "objectiveId": "string — e.g. 'express_ratio_simplest_form'",
  "taskFamilyId": "string — e.g. 'ratio_simplify_two_term_v1'",
  "iterationRung": "1-8, per LEARNING_OBJECTIVE_ITERATION_CONTRACT_V1.md",
  "layer": "calculate | explain | visualise | applied_lab",
  "evidenceEvent": "attempt_correct | attempt_incorrect | prediction_recorded | prediction_confirmed | prediction_revised",
  "diagnosticFamily": "direction_sign | magnitude_scale | operation_transformation | relation_equivalence | representation_interpretation | completeness_process | strategy_method | unclassified | null",
  "diagnosticSignatureId": "string, references an authored signature for this taskFamilyId, or null",
  "confidence": "0.0-1.0 — how unambiguously the recorded answer matches the named signature, authored per signature, never learner-facing",
  "timestamp": "ISO 8601, local device clock",
  "generationSeed": "integer or string — the exact seed/config used to generate this task instance, or null if not applicable",
  "deterministicNextAction": "advance_rung | repeat_rung | remediate | offer_retention_check | mark_retained",
  "learnerProfileScopeId": "the existing local profile-scope id already used elsewhere in the app — never a name or account identifier"
}
```

**Reproducibility requirement:** whenever a task instance is procedurally generated (any rung above Recognise that varies parameters), the exact `generationSeed` and configuration that produced it must be recorded alongside the evidence. The same seed and configuration must regenerate the identical task instance later — for a learner or parent reviewing "what was I actually asked," for QA reproducing a reported issue, and for fully offline recovery with no server round-trip. A task family whose generation cannot be reproduced from a stored seed does not meet this contract and must not ship.

---

## Part E — Parent and teacher view contracts (design only, not implemented)

Both views read from the same evidence ledger above. Neither view is generated by an LLM at runtime — both are deterministic templates filled from authored interpretation text keyed to diagnostic families and evidence states, exactly as the objective states in `LEARNING_OBJECTIVE_ITERATION_CONTRACT_V1.md` are deterministic, not free text.

### Teacher Matrix

- A curriculum-aligned grid: objectives (or curriculum nodes) as rows, iteration rungs as columns.
- Each cell shows the deterministic evidence status (no evidence / developing / secure / transfer demonstrated / retention due / retained) for a group, plus the underlying evidence count and its confidence — never a single fabricated "class average" number without stating how many learners and how many attempts it is built from.
- A plain, actionable intervention line per objective where evidence supports one (e.g. "3 of 12 learners show a magnitude/scale signature on structural variation — worth a short whole-class recap of that step") — always naming the diagnostic family and the evidence behind it, never a vague "needs more practice."
- **When evidence is insufficient for a group-wide pattern, the matrix says so explicitly** ("insufficient evidence for a class-wide pattern yet") rather than inventing a conclusion from too few data points.

### Parent Insight Card

- Plain English, no raw diagnostic-family codes, no jargon.
- "What's going well" — one or two objectives at Secure/Transfer/Retained, named in plain language.
- "What needs practice" — one or two objectives at Developing or Retention-due, named in plain language, with the *authored* interpretation of the relevant diagnostic family translated into a parent-readable sentence (e.g. a "magnitude/scale" signature becomes "sometimes the size of the answer is off, even when the method is right" — never the internal code name).
- One original, safe, at-home reinforcement suggestion tied to the specific objective (never a generic "practice more maths").
- "What to try next" — the next rung or objective the learner is eligible for, stated plainly.
- No unsupported diagnosis, no clinical or standardised-test language, no comparison to other learners.
- All parent-facing sentences are deterministically selected from an approved template set keyed by (objective, evidence state, diagnostic family) — never generated freeform at runtime.

---

## Part G — Future extension boundary: Companion and Concept Bridges

**Status: planned only. Nothing in this section is implemented.** No pet, reward system, coding interface, new navigation destination, persistence, or animation is created by this document. This section exists so a future companion ecosystem — if ever built — has an honest boundary to build inside, rather than drifting into engagement-driven design by default.

### Principles

- **Captain Math remains the existing educational guide.** This section does not replace, duplicate, or compete with the current mascot system.
- **No scores, lives, streak pressure, leaderboards, punishment, scarcity, compulsive reward loops, or paid progression** — of any kind, ever, in this extension.
- **The companion never determines mastery and never unlocks curriculum content.** Every gate in `LEARNING_OBJECTIVE_ITERATION_CONTRACT_V1.md` is evidence-based; a companion interaction cannot substitute for or bypass that evidence.
- **Every core learning journey must be completable with zero companion interaction** — no animation, coding activity, companion name, account, network connection, or AI call required to learn or to advance.
- **Companion state is local, optional, privacy-preserving, accessible, and profile-scoped** — the same local-only, no-PII posture as the evidence ledger above.
- **Progress only follows recorded deterministic evidence** (from the ledger above) — never guessing, time-on-screen, or repeated tapping.
- **A non-animated, text-equivalent, Reduce-Motion-safe version is required for every companion interaction.**

### Three future bridge types

**1. Mathematical Companion Interaction**
An original visual or 2.5D interaction that reinforces an *already-approved* objective (e.g. number bonds, ratio scaling, coordinate movement, probability) — never a generic virtual-pet feeding/care loop unrelated to the mathematics.

**2. Computational Thinking Bridge**
Optional, age-appropriate block-style sequencing, variables, conditions, loops, or functions, explicitly linked to an existing mathematics objective. Must use deterministic local logic (no network, no LLM) and always offer a plain-English alternative path. **Must never require programming syntax to pass the underlying maths objective** — coding is an optional bridge into the idea, never a gate in front of it.

**3. Advanced Concept Bridge**
A short, honest "where this idea goes next" connection — for example: equal groups → sets/classification; ratio scaling → vectors/scalar multiplication; quadratics → modelling, optimisation, and coordinate geometry. **Purely conceptual signposting.** Must never claim an early learner is "doing" matrices, calculus, engineering, or university content unless a separate, fully approved curriculum node for that content actually exists.

### Required documentation per proposed future bridge

- prerequisite curriculum node;
- learner age/stage suitability;
- exact mathematical purpose (not "engagement" — a stated maths reason);
- optional companion interaction (if any);
- computational-thinking connection, **only if genuinely relevant** (not forced onto every objective);
- future-concept connection (the honest "where this goes" line);
- the evidence event it may produce, using the same schema as Part D above;
- accessibility/static equivalent;
- availability status — **always `planned` in this document; never `available`, never tappable, until original content and the supporting interaction genuinely exist.**

### Three illustrative, non-implemented examples

**Example A — Year 1 number bonds**
- Prerequisite node: early number composition/decomposition to 10.
- Suitability: Early Years/KS1.
- Mathematical purpose: seeing a number bond as two parts of one whole, reversibly.
- Optional companion interaction: an original two-part balancing visual the companion "checks," tied directly to a number-bond objective already in the ladder — not a feeding or care mechanic.
- Computational-thinking connection: none forced — number bonds do not need one.
- Future-concept connection: "this is the same idea as balancing both sides of an equation later on."
- Evidence event: a standard Rung 1-3 attempt event from Part D's schema.
- Accessible/static equivalent: the identical bond task as a plain two-box fill-in, no companion required.
- Status: **planned**.

**Example B — Year 8 Ratio and Proportion**
- Prerequisite node: `ratio_proportion` (see the full blueprint in `YEAR8_RATIO_AND_KS4_QUADRATICS_BLUEPRINTS_V1.md`).
- Suitability: KS3.
- Mathematical purpose: seeing a ratio hold under scaling — the same relationship at a different size.
- Optional companion interaction: none proposed at this stage beyond the Applied Lab already specified in the blueprint document — a ratio objective does not need a *separate* companion mechanic on top of its lab.
- Computational-thinking connection: an optional "describe the scaling rule as a simple sequence of steps" block exercise, genuinely relevant since scaling *is* a repeatable rule.
- Future-concept connection: "ratio scaling → vectors and scalar multiplication" (a plain-English signpost only).
- Evidence event: standard Rung 4-6 attempt/prediction events.
- Accessible/static equivalent: the blueprint's own static image/table equivalent (see that document).
- Status: **planned**.

**Example C — KS4 Quadratic Modelling**
- Prerequisite node: `algebra::KS4` (quadratics as a subtopic; see the blueprint document for its honest current-availability note).
- Suitability: KS4.
- Mathematical purpose: seeing how the coefficients of a quadratic relationship change the shape and key features of its graph/behaviour.
- Optional companion interaction: none proposed — this age band is better served by the Applied Lab itself than by a companion layer.
- Computational-thinking connection: an optional "predict, then check with a simple rule" structure, genuinely relevant to hypothesis-and-test reasoning, kept explicitly optional.
- Future-concept connection: "quadratics → modelling, optimisation, and coordinate geometry" (plain-English signpost only; no claim of calculus or engineering content).
- Evidence event: standard Rung 6/Applied Lab prediction events.
- Accessible/static equivalent: the blueprint's own static graph-reading equivalent.
- Status: **planned**.
