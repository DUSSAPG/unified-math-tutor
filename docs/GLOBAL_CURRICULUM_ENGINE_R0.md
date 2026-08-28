# Global Curriculum Engine — R0 Architecture Record

**Status:** Recorded architecture contract only. Nothing in this document is
implemented as of D2.1, and nothing in D2.1 implements it.

**Explicitly not done by recording this document:** global curriculum
selection, new onboarding choices, US content, Swiss content, translated
packs, new navigation, calculator emulators, or new assessment flows. This
is a future-architecture record, not a build plan for this sprint.

**Scope after D2.1:** UK/England content closure remains the only active
curriculum-production scope. Everything below describes how the product
would eventually generalise beyond that — it is not a signal that this
generalisation is starting next.

---

## 1. One canonical, curriculum-neutral concept graph

Math Intelligence has exactly one concept graph, independent of any single
country's curriculum. A concept is identified by a stable, hierarchical,
dotted path, e.g.:

```
calculus.differentiation.chain_rule
```

The concept graph is the *only* thing every curriculum in every
jurisdiction maps onto. It is never itself owned by, or shaped around, one
country's syllabus structure — including England's, even though England is
the only jurisdiction with production content today.

## 2. Curriculum eligibility is a specific contract, not a guess

A learner's curriculum eligibility is determined by a curriculum contract
with these components, in order:

```
jurisdiction → framework → state/canton (where applicable)
  → qualification/pathway → exam board/course/tier → locale
```

Every one of these fields is required where it applies. A partial contract
(e.g. jurisdiction alone) is not sufficient to resolve real content.

## 3. Country alone is never a sufficient curriculum selector

This is a hard rule, not a simplification to revisit later:

- `CH` (Switzerland) must not be treated as one generic Swiss syllabus.
  Switzerland has cantonal curricula (`Lehrplan 21` in German-speaking
  cantons, `Plan d'études romand` in French-speaking cantons, and further
  variation in Ticino), and the same country code covers genuinely
  different frameworks depending on canton and language.
- `US` must not be treated as one fixed Algebra 1 → Geometry → Algebra 2
  sequence. US mathematics pathways vary by state standard (many use
  Common Core, some do not) and by district/school pathway choice
  (traditional vs. integrated sequences both exist).
- `UK A-Level` must name a board/specification/version when used for any
  assessment claim — "UK A-Level Maths" alone is not a curriculum mapping;
  "Edexcel A-Level Mathematics (9MA0), first teaching 2017" is.

Country is, at most, the first filter in the jurisdiction → framework
chain above — never the terminal answer.

## 4. Five separate layers

Concepts, curriculum mappings, deterministic question families, and
region-qualified question variants are five distinct layers, each with its
own identity and lifecycle:

```
Concept
  → curriculum mapping
    → deterministic question family
      → qualified question variant
        → answer/rationale/distractor/assessment policy
```

A concept can exist with zero curriculum mappings (recorded, not yet
placed in any syllabus). A curriculum mapping can exist with zero question
families (the objective is known, content isn't authored). A question
family can exist with zero qualified variants for a given locale/board
(the deterministic template exists, a specific region's phrasing/policy
hasn't been produced). Each layer's completeness is tracked independently
— this is what lets D1/D2's kind of coverage-matrix auditing scale beyond
one jurisdiction.

## 5. Shared mastery evidence — canonical concept level only, and only when genuinely equivalent

Practice evidence (attempts, correctness, resumed sessions, mastery
signals) may be aggregated across curricula at the canonical concept level
**only** where the prerequisite structure and skill meaning are genuinely
equivalent — not merely where the concept names look similar. Two
curricula both teaching "the chain rule" only share mastery evidence if a
learner who can do one can, in fact, be assumed to be able to do the
other at the same depth. Where that assumption doesn't hold (see the AP
Calculus AB/BC example below), evidence stays scoped to the qualification
it was earned under until a verified equivalence mapping says otherwise.

## 6. Policy references, not stereotypes

Formula sheets, calculator conditions, terminology, notation, and exam
formats are versioned policy references attached to a specific curriculum
mapping — never hard-coded assumptions baked into product logic based on a
country name. "US students get a calculator" or "UK students show working"
are not switch statements on a country field; they are properties recorded
per curriculum mapping, versioned, and capable of being wrong for a
specific board/tier/year without that being a code change.

## 7. Every curriculum mapping's required fields

A curriculum mapping is not valid, and cannot be used for any
learner-visible routing, unless it records all of:

| Field | Meaning |
|---|---|
| Source authority | Who defines this curriculum (e.g. Edexcel, AQA, a state board, a cantonal education department) |
| Source version | The exact specification/version/first-teaching-year this mapping was read from |
| Objective reference | The exact syllabus objective/code this mapping satisfies |
| Pathway/tier | e.g. Foundation/Higher, AB/BC, Standard/Higher Level |
| Locale | The content language this mapping's questions are authored in |
| Verification status | See §8 |
| Content-completeness status | Whether question families/variants actually exist yet for this mapping, independent of whether the mapping itself is verified |

## 8. Unverified mappings cannot become learner-visible routes

A curriculum mapping's verification status defaults to `research_required`
and stays there until a human with subject-matter authority confirms the
source authority, version, and objective reference are correct. A
`research_required` mapping:

- may exist in the system (recorded, inspectable, audited);
- must never be offered as a selectable learner-facing curriculum route;
- must never be used to justify a content-availability or coverage claim.

This mirrors D2's "a missing mapping is an intentional unavailable
outcome, not a fallback" principle, generalised: an *unverified* mapping is
treated exactly like a missing one for any learner-facing purpose.

## 9. Worked example: the Chain Rule, corrected

- Both **AP Calculus AB** and **AP Calculus BC** cover the Chain Rule — a
  single "AP Calculus" mapping covering both would be wrong, and so would
  treating them as fully separate concepts. The correct model: one
  concept (`calculus.differentiation.chain_rule`), two curriculum mappings
  (AB and BC), sharing that concept — with BC additionally mapping to
  further concepts AB does not cover (e.g. parametric/polar
  differentiation, series). Mastery evidence for the Chain Rule earned
  under AB can inform BC's view of the same concept; mastery evidence for
  BC-only concepts cannot be inferred from AB at all, because AB never
  taught them.
- A **UK mapping** must name the exact qualification specification (e.g.
  "Edexcel A-Level Mathematics 9MA0") — "UK A-Level" alone is not a valid
  mapping per §3.
- A **Swiss mapping** must name canton, framework, pathway, and language
  together (e.g. "Canton Zürich, Lehrplan 21, Gymnasium pathway, German
  instruction") — "Switzerland" alone, or even "German-speaking
  Switzerland" alone, is not a valid mapping per §3.

---

*This document is a recorded contract for future architecture work. It
does not authorise, schedule, or begin any of the excluded work listed at
the top. UK/England content closure remains the only active
curriculum-production scope after D2.1.*
