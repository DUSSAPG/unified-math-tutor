# Learning Objective Iteration Contract V1

**Status:** design contract, not implemented. Defines the canonical shape every future learning objective, task family, and lab must satisfy before any Flutter code, JSON content, or ALI logic is built against it. No production code, navigation, persistence, or curriculum-manifest change is made by this document.

This contract draws design inspiration from the pedagogical *patterns* recorded in `WORKBOOK_LIBRARY_MAP_V1.md` (spiral mastery, bar-model reasoning, grade-banded practice, contextual investigation, explanation-led retrieval) — never from their specific questions, wording, diagrams, or sequencing. Every task family named below is original. Note that every one of those named patterns is itself only a `bibliographic_inference_only` / low-confidence hypothesis about the referenced books (see that document's evidence-level disclaimer) — this document treats them purely as *design prompts*, not as verified facts about any specific book, and every task family, rung, and lab specified below is original design work regardless of that uncertainty.

---

## Part B — The canonical learning-objective chain

Every piece of adaptive practice in Math Intelligence, present or future, is an instance of this chain:

```
curriculum node
  -> learning objective
    -> task family (one original, authored exercise pattern)
      -> iteration rung (1 of 8, see below)
        -> evidence (one recorded attempt/outcome)
          -> diagnostic interpretation (see DIAGNOSTIC_EVIDENCE_AND_MASTERY_LEDGER_V1.md)
            -> next deterministic action (advance / repeat / remediate / retire)
```

- A **curriculum node** is an entry in the curriculum manifest (`assets/config/curriculum_manifest.json` today) — a (topicId, stage) pair or a future finer-grained subtopic node.
- A **learning objective** is one specific, testable outcome within a node (e.g. "express a ratio in simplest form," not "understand ratio").
- A **task family** is one originally-authored exercise pattern for that objective — a template with rules, not a bank of copied questions.
- An **iteration rung** is one of the eight stages below; a task family may be instantiated at several rungs with different parameter rules.
- **Evidence** and **diagnostic interpretation** are defined fully in `DIAGNOSTIC_EVIDENCE_AND_MASTERY_LEDGER_V1.md`; this document only specifies what evidence each rung requires to be satisfied.

No rung, task family, or lab may be built without first naming which curriculum node and learning objective it belongs to. An orphaned task family (no node, no objective) is not permitted.

## The eight-rung Iteration Ladder

**Changing 25 × 6 to 26 × 6 is a fluency variation only. It is never proof of mastery on its own**, and no rung below may be satisfied by parameter variation alone — each rung's "evidence required to advance" column is the actual gate, not the number of items attempted.

| # | Rung | Purpose |
|---|---|---|
| 1 | Recognise | Learner identifies the concept/structure without yet computing an answer |
| 2 | Guided practice | Learner solves with scaffolding (worked first step, hint always available, or a partially-completed model) |
| 3 | Fluency variation | Learner solves independently; only surface numbers/labels change; structure is identical |
| 4 | Structural variation | The mathematical structure changes (e.g. a:b vs a:b:c; part:part vs part:whole) while remaining the same objective |
| 5 | Reverse / missing-value reasoning | The unknown moves — learner is given the outcome and must reconstruct an input, not just apply a forward procedure |
| 6 | Contextual application | The task is embedded in an original real-world or cross-Studio scenario requiring the learner to select and set up the method themselves |
| 7 | Synthesis with prerequisite concepts | The task deliberately combines this objective with an already-mastered prior objective (never a brand-new, un-taught one) |
| 8 | Spaced retrieval / retention check | A later, time-delayed re-check using a fresh instance of an earlier rung's task family, to confirm the objective is retained, not just recently practised |

### Per-rung contract

Every objective's task-family design must specify all six columns below before it can be authored. None may be left implicit.

**Rung 1 — Recognise**
- *Task family:* present several original worked/labelled instances (some correct structure, some a plausible near-miss) and ask the learner to identify or classify, not compute.
- *Allowed parameter variation:* which instances are shown; surface wording; which is the "odd one out" or correct match.
- *Misconceptions tested:* confusing this concept's structure with a visually similar but different one (e.g. confusing a ratio 3:5 with the fraction 3/5).
- *Evidence required to advance:* correct classification across at least two independently-generated instances in one sitting.
- *Remediation if insufficient:* a worked walkthrough of the distinguishing feature, then re-attempt at Rung 1 with new instances — never skip forward.
- *Next after mastery:* Rung 2 of the same task family.

**Rung 2 — Guided practice**
- *Task family:* the real computation, with one scaffold present (a worked first step, a partially filled bar model, or a hint the learner must actively reveal).
- *Allowed parameter variation:* the numbers/labels in the scaffolded template; which scaffold is offered.
- *Misconceptions tested:* correct use of the taught procedure when supported; whether removing support (Rung 3) will expose a gap.
- *Evidence required to advance:* independent correct completion of the *unscaffolded remainder* of at least two guided instances.
- *Remediation if insufficient:* a different scaffold style (worked example vs. partially-completed model) before re-attempting; never more repetitions of the identical scaffold.
- *Next after mastery:* Rung 3.

**Rung 3 — Fluency variation**
- *Task family:* the same structure as Rung 2, fully independent, only surface numbers change.
- *Allowed parameter variation:* numeric values, units, labels — structure fixed.
- *Misconceptions tested:* procedural slips (arithmetic errors, sign errors, wrong operation) once scaffolding is removed.
- *Evidence required to advance:* a deterministic accuracy threshold across a defined minimum number of independently-generated items (the exact threshold and item count are authored per objective, not a universal constant — see the worked exemplars).
- *Remediation if insufficient:* return to Rung 2's scaffold, not a repeat of Rung 3 with more of the same.
- *Next after mastery:* Rung 4.

**Rung 4 — Structural variation**
- *Task family:* the same objective expressed through a genuinely different structure (e.g. three-term ratio after two-term; a different representation of the same relationship).
- *Allowed parameter variation:* structure type, in addition to surface numbers.
- *Misconceptions tested:* over-generalising the two-term/simple-case procedure onto a structure it does not fit unchanged.
- *Evidence required to advance:* correct performance on each distinct structural variant introduced, not just the most recent one.
- *Remediation if insufficient:* an explicit worked contrast between the simple and the new structure, highlighting exactly what differs.
- *Next after mastery:* Rung 5.

**Rung 5 — Reverse / missing-value reasoning**
- *Task family:* the learner is given what was previously the answer and must find what was previously the input.
- *Allowed parameter variation:* which part of the relationship is hidden.
- *Misconceptions tested:* mechanically re-running the forward procedure instead of inverting the relationship; sign/direction errors specific to inversion.
- *Evidence required to advance:* correct performance across at least two different "which part is hidden" configurations.
- *Remediation if insufficient:* an explicit worked "undo" walkthrough showing the inverse operation, not a hint on the forward procedure.
- *Next after mastery:* Rung 6.

**Rung 6 — Contextual application**
- *Task family:* an original scenario (real-world or cross-Studio) that does not name the method — the learner must recognise which objective applies and set it up themselves.
- *Allowed parameter variation:* the scenario/context, while the underlying mathematical structure is drawn from Rungs 3-5's already-mastered variants.
- *Misconceptions tested:* selecting the wrong operation/relationship for the context; correct computation but wrong real-world interpretation of the result.
- *Evidence required to advance:* correct setup **and** correct final interpretation (not just a correct number) across at least two distinct contexts.
- *Remediation if insufficient:* an explicit worked "translate the words into the structure" walkthrough, then a fresh context — never the identical context restated.
- *Next after mastery:* Rung 7.

**Rung 7 — Synthesis with prerequisite concepts**
- *Task family:* combines this objective with a **specific, already-mastered** prior objective from the prerequisite map (never an untaught one).
- *Allowed parameter variation:* which prior objective is combined, and in what order the two are required.
- *Misconceptions tested:* correctly applying each concept alone but failing to sequence or combine them; forgetting one step of a two-part chain.
- *Evidence required to advance:* correct end-to-end performance across at least two distinct prerequisite pairings.
- *Remediation if insufficient:* isolate which of the two concepts failed (using the diagnostic families in `DIAGNOSTIC_EVIDENCE_AND_MASTERY_LEDGER_V1.md`) and remediate that concept specifically, not the combined task.
- *Next after mastery:* Rung 8 (retention check) and simultaneous eligibility for later objectives that list this one as a prerequisite.

**Rung 8 — Spaced retrieval / retention check**
- *Task family:* a fresh instance of a Rung 3-6 task family, deliberately delayed (a real, calendar-based delay — never "the next tap").
- *Allowed parameter variation:* which prior rung's task family is re-checked; the delay interval.
- *Misconceptions tested:* forgetting/decay rather than a new misconception — the diagnostic layer should distinguish "never secure" from "was secure, now decayed."
- *Evidence required to advance (to "retained"):* correct performance on the delayed re-check.
- *Remediation if insufficient:* return to Rung 3 for that objective (not Rung 1) — the learner has prior evidence of having reached fluency once, so guided practice is not needed again, but fluency is.
- *Next after mastery:* the objective is marked **retained**; it becomes eligible as a Rung 7 prerequisite for other objectives with confidence.

## Deterministic evidence status (no percentage claims without a scope)

Every objective's state is always one of exactly these six values — never a free-text or LLM-generated summary:

1. **No evidence** — the learner has never attempted this objective.
2. **Developing** — evidence exists below the advancement threshold for the learner's current rung.
3. **Secure on current rung** — the current rung's advancement threshold has been met; the next rung is now offered.
4. **Transfer demonstrated** — Rung 6 and Rung 7 have both been satisfied.
5. **Retention due** — Rung 7 was mastered, and the authored spaced-retrieval interval for this objective has elapsed without a Rung 8 check yet being attempted.
6. **Retained** — a Rung 8 check has been passed.

**Math Intelligence must never state a curriculum-completion percentage (e.g. "78% of the curriculum complete") unless that percentage has a precise, stated denominator** (an exact, named set of curriculum nodes/objectives) **and** every counted objective has reached at least "Secure on current rung" by the definitions above. A percentage computed against an undefined, changing, or partially-authored denominator must not be shown.

---

## Part C — The four-layer Studio/Workbook ladder

A learning objective's rungs (above) describe *how much practice and what kind of reasoning* is required. This section describes *what form* that practice can take. The two are independent: an objective can sit at Rung 3 fluency and be expressed only through the Calculate layer; a different objective may need all four layers.

| Layer | Purpose | Format |
|---|---|---|
| **1. Calculate** | Procedural/symbolic fluency | Direct computation, numeric or symbolic entry/selection |
| **2. Explain** | Choose, form, and interpret the mathematics in context | Learner selects/constructs the correct method or explains why an approach is (in)correct, in an original scenario |
| **3. Visualise** | Inspect or manipulate a meaningful 2.5D representation | A diagram, bar model, number line, or coordinate view the learner reads or adjusts to see the relationship, not just decoration |
| **4. Applied Lab ("4D")** | Change variables, predict, observe consequence, repair reasoning, reflect | A deterministic, offline interactive model — see the lab contract below |

**"4D" is a specific, narrow meaning here**: dynamic change over an input the learner controls, time where genuinely relevant to the mathematics, constraints, cause-and-effect, a required prediction before running, and feedback against that prediction. **It must never mean decorative animation.** A spinning icon, a celebratory particle effect, or a mascot reaction is not a "4D" layer and must not be described as one.

### When Visualise or Applied Lab is justified

A Visualise or Applied Lab layer for a given objective is only justified when it teaches something a static Calculate/Explain item genuinely cannot — for example: rate of change, a constraint interacting with a variable, scale/proportion made visible, an optimisation trade-off, a spatial relationship, a probabilistic pattern only visible over repeated trials, or an engineering-style trade-off. If an objective's Visualise/Lab justification cannot be stated in one sentence of this form, the layer is not built — the objective stays at Calculate/Explain.

### Dimensionality classification (required for every objective before any Visualise/Lab work is planned)

Classify each objective's eligible layers along four tracks (an objective can be eligible for more than one; "eligible" is not the same as "will be built now" — see availability status in the worked exemplars):

1. **Symbolic calculation** — can this objective be taught/practised through direct computation alone?
2. **Verbal/contextual reasoning** — can it be taught/practised through an original scenario requiring interpretation, without a diagram?
3. **Visual / 2.5D or 3D representation** — does a diagram, model, or spatial view make the *relationship* visible in a way words/numbers alone do not?
4. **Dynamic applied lab ("4D")** — does changing an input over time/iterations, under a constraint, reveal something that a single static image cannot (see the justification test above)?

### Required fields for every approved lab blueprint

No Applied Lab may be specified, let alone built, without all of the following stated explicitly:

- exact curriculum objective it serves (node + objective id, not a topic in general);
- inputs the learner controls;
- what changes and what remains invariant while the learner experiments;
- the prediction the learner must make **before** running the model;
- the deterministic, offline calculation logic behind the model (no network call, no LLM, no randomness that is not seeded and reproducible);
- the observable outcome shown to the learner;
- misconception checks — which specific wrong prediction/action patterns the lab is built to expose;
- the repair action taken when a misconception is detected;
- the success evidence sent to the evidence ledger (see `DIAGNOSTIC_EVIDENCE_AND_MASTERY_LEDGER_V1.md`);
- an accessible, non-animated equivalent that reaches the same objective evidence without requiring the interactive lab;
- Reduce Motion behaviour (the lab's state changes must still be usable and comprehensible with motion reduced — typically by replacing animated transition with an immediate, labelled state change);
- the one-sentence reason it is educationally necessary (the justification test above).

### Technology constraints (binding on any future lab work)

- **Start with native Flutter 2.5D interaction and existing Studio primitives** (the widgets/patterns already used by Interactive Labs and Visual Maths) — no new rendering framework is introduced by default.
- **Manim may be used only for a short, optional, pre-rendered explanatory asset** (matching its existing use elsewhere in the app) — never as the interactive surface itself.
- **GeoGebra is out of scope** for any lab designed under this contract **until** licensing terms, commercial/offline embedding rights, child-data and privacy terms, attribution requirements, and any community-content rights have been separately verified and recorded. No lab blueprint in this document set assumes GeoGebra availability.
- No decorative 3D. A rotating/orbiting visual that does not change what the learner controls or observes is not a lab layer.
