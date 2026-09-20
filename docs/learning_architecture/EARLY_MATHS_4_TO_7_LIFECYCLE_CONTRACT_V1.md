# Early Maths 4–7 Lifecycle Contract V1

**Status:** design contract, not implemented. No lane picker, activity, route, storage key, manifest entry, asset, string, or test is created or changed by this document. It sits on top of `LEARNING_OBJECTIVE_ITERATION_CONTRACT_V1.md`, `DIAGNOSTIC_EVIDENCE_AND_MASTERY_LEDGER_V1.md`, `PARENT_PARTNERSHIP_CONTRACT_V1.md` and `STUDIO_ACTIVITY_CURRICULUM_LINK_AUDIT_V1.md` (all committed) and does not restate them; where it needs them it points at them by name.

## 0. Evidence classes and what was actually reviewed

Every claim below carries one of four tags. They are never blended.

| Tag | Meaning |
|---|---|
| **[O]** Official curriculum | Read from a GOV.UK Department for Education source during this pass. |
| **[R]** Repository | Read directly from this repository's own source, assets or docs during this pass. |
| **[B]** Bibliographic research signal | A title/author-level signal from a private reference book. `bibliographic_inference_only`, confidence low. Never a description of a book's real content. |
| **[P]** Original proposal | This document's own design decision. Not attributed to any source. |

### 0.1 The four named research references were not available

The product owner named four research-only references: *Matching & Numbers*, *Maths 4-5*, *Gold Stars Maths Ages 6-7*, and *Mastering Numbers*. **None of them could be found on disk.** They were searched for by filename across `D:\AI\Quantumlab` (to depth 7, which includes the whole `research` tree) and, to depth 3, `Downloads`, `Desktop` and `Documents` under the user profile; the `MATH DESIGN REFERENCE\Parents` folder still holds the same 16 files reviewed for `PARENT_PARTNERSHIP_CONTRACT_V1.md` and `Workbooks` the same 48. Consequently:

- **No [B] signal of any kind is drawn from those four titles.** Not even title-level inference. The only thing taken from the brief itself is the age labels the product owner supplied (4–5, 6–7), which are used as the lane boundary requirement, not as evidence about any book.
- Two other early-years-relevant titles do exist at the top of `MATH DESIGN REFERENCE` (*Early Numeracy: Mathematical Activities for 3 to 5 Year Olds*; *Mathematical Learning and Cognition in Early Childhood*). They were **not** named in the brief and were **not** reviewed or used. They are mentioned here only so the owner can decide whether to add them.
- If the four named files are supplied, this contract should be revised by adding [B] rows only. Nothing in it depends on them.
- No PDF, OCR, page image, exercise, or sequence from any book was opened, stored, or paraphrased.

### 0.2 Official curriculum sources [O]

| Source | What was verified | What was not |
|---|---|---|
| *National curriculum in England: mathematics programmes of study* (DfE, GOV.UK; page shows "Updated 28 September 2021") | The **section headings** for Key Stage 1: Year 1 and Year 2 both have *Number – number and place value*, *Number – addition and subtraction*, *Number – multiplication and division*, *Number – fractions*, *Measurement*, *Geometry – properties of shapes*, *Geometry – position and direction*; Year 2 also has *Statistics*. | Individual statutory statements were not re-read line by line; no statement is quoted or relied on below. |
| *EYFS statutory framework for group and school-based providers* (DfE, GOV.UK; page shows "Last updated 1 September 2026"; PDF `EYFS_group_and_school_based_from_September_2026.pdf`) | The document exists, its publisher, and that the effective version is the September 2026 one. | **The wording of the Mathematics Early Learning Goals could not be extracted.** Two automated extraction attempts failed to return readable Mathematics text, and the first attempt's goal wording did not match what is reliably known about the framework, so it was **discarded**. This document therefore states **no** Early Learning Goal wording. The area names "Number" and "Numerical Patterns" are used below only as loose anchors and are flagged *unverified*. Before any learner-facing claim mentions Reception expectations, the statutory PDF must be read by a person. |

[R] `assets/config/curriculum_manifest.json` (read-only) declares stages `early_years` and `KS1` and marks both `hasContent: false`; KS2–KS5 are `true`.

## 1. Product boundary

Two lanes. A lane is a **presentation and suggestion concept only** — it is never stored as a learner label, never gates content, and never appears in the learning-evidence ledger as an ability signal.

| Lane | Working name | Typical ages / school year | Maps to manifest stage |
|---|---|---|---|
| A | **Early Maths Play** | 4–5 / Reception | `early_years` [P] |
| B | **KS1 Maths Foundations** | 5–7 / Years 1–2 | `KS1` [P] |

- **Age is a suggested entry point, never an ability judgement.** Copy never says a child "is" Reception-level or "belongs" in a lane. It says "suggested for many children around 4–5" and nothing stronger. [P]
- **Under-4 independent use is not supported by this contract.** Nothing here designs for children under 4; the manifest's `early_years` stage id must not be read as covering nursery-age children. [P]
- **No new stage ids.** Lane A/B reuse the manifest's existing `early_years` and `KS1` ids. Adding a lane must never add a value to `CurriculumService`, `PackRegistryService.practiceStages`, or the manifest's stage list. [P]

**Repository facts that bound what is possible today [R]:**
- The onboarding stage selector offers only `ks2`–`ks5` (`stage_selector_screen.dart`), and `CurriculumService`'s default is `ks2`. There is **no Reception or KS1 entry point** anywhere in onboarding.
- `PackRegistryService.practiceStages` is `['KS2','KS3','KS4','KS5']`, so the Topic Learning Hub's stage picker cannot select `early_years` or `KS1` at all, and there are no early-years question packs.
- Therefore the Topic Hub is **not** the vehicle for these lanes. They need their own entry, and that entry is planned only (Section 8).

## 2. Entry and choice model [P]

1. **Parent/caregiver may select a suggested lane.** This is a parent-side action in the parent area, using the existing PIN-gated parent surface (repo evidence for that gate: `ParentGate` wraps the Family Maths welcome, library and activity-detail screens). Selecting a lane stores a *preference* (`early_maths_play`, `ks1_maths_foundations`, or `not_sure`) scoped to the learner, not a mastery or placement field.
2. **The child chooses between suitable activities.** Within the suggested lane the child picks which verified activity to open. A lane never auto-starts anything.
3. **"I'm not sure" route.** Shows a small mixed set of *verified* activities from both lanes (at most three, Panda first while it is the only verified child activity). No result screen, no summary, no lane is assigned, and nothing about the choice is recorded as an ability signal. The parent can still pick a lane later.
4. **The parent can change the lane at any time**, in one step, non-destructively. Changing lane never deletes, hides, or re-labels earlier activity evidence (Section 7).
5. **No permanent placement test.** No diagnostic quiz decides a lane, ever. Any optional age the parent enters only orders suggestions.
6. **No "behind" language and no forced promotion.** A child in Lane A is never told to move up; a child in Lane B is never told they "should" revisit Lane A. Cross-lane browsing ("see more activities") is always available and never described as catching up.

## 3. Concept progression

Ten original concept families, shared across both lanes. The families are this document's own grouping [P]; each is anchored to an official heading only where one was verified [O].

Availability vocabulary (used for **coverage of the family in that lane**, not for a single activity):

- **available now** — verified, live, child-facing content covers the family at the lane's level, with stated limits.
- **partial** — some verified, real content exists that covers part of the family, with limits stated. Includes parent-led content that has no child-facing in-app activity.
- **planned only** — in scope for the lane; nothing verified exists.
- **not supported** — deliberately out of scope for this lane in this contract version.

| # | Concept family | Official anchor | Repository evidence [R] | Early Maths Play (4–5) | KS1 Foundations (5–7) |
|---|---|---|---|---|---|
| 1 | Matching, sorting, classifying | None verified in this pass | None found | **planned only** | **planned only** |
| 2 | Comparing quantities | KS1 *Number – number and place value* [O, heading only]; EYFS anchor unverified | None found. (Panda's "Panda has enough" message is a sufficiency check inside one round, not a comparison activity.) | **planned only** | **planned only** |
| 3 | Counting and cardinality | KS1 *Number – number and place value* [O, heading only]; EYFS "Number" unverified | **Feed the Hungry Panda**: feed a target of 1–3 apples from exactly 5, one at a time (tap-then-tap or drag), then answer how many are left (`feed_panda_challenge.dart`). No counting on/back, no subitising, nothing beyond 5. | **partial** — one verified activity, range 1–3 of 5 only | **planned only** — Panda's range is below Year 1 expectations, so it is not evidence of KS1 coverage |
| 4 | Patterns | EYFS "Numerical Patterns" (unverified); no KS1 heading of its own | Family Maths *pattern-detective*, ages 5–8, 5–10 min, parent-led, no in-app link (`family_activities.json`) | **planned only** — catalogue minimum age is 5, so at most the very top of Reception | **partial** — parent-led content only, no child-facing in-app activity |
| 5 | Shape, space and position | KS1 *Geometry – properties of shapes*, *Geometry – position and direction* [O, headings] | Family Maths *shape-hunt* (ages 4–8) and *garden-geometry* (6–10), both parent-led. The in-app Spatial Intelligence activities are built for KS2+ (see the Studio audit) and are not evidence here. | **partial** — parent-led only | **partial** — parent-led only |
| 6 | Number symbols | KS1 *Number – number and place value* [O, heading only] | Panda's instruction text contains numerals (its answer options are integer values) but only incidentally; there is no numeral recognition or formation activity. Number-line screens exist (fixed 0–10 and 0–20 whole-number challenges) but were built and reviewed for older learners. | **planned only** | **planned only** — existing number lines are unreviewed for ages 5–7 and are not part of either lane |
| 7 | Number composition (part-whole, bonds) | KS1 *Number – addition and subtraction* [O, heading only]; EYFS "Number" unverified | Family Maths *build-twenty* (ages 5–8, parent-led; declares a link to the Mental Maths pillar). Nothing child-facing in-app. `number_place_value` has real manifest content only at KS2+. | **planned only** | **partial** — parent-led only |
| 8 | Early addition/subtraction meaning | KS1 *Number – addition and subtraction* [O, heading only] | **Panda**: subtraction as removal within 5 — how many are left after feeding the target. Family Maths *dice-race* (ages 5–7, parent-led addition). | **partial** — Panda only, within 5 | **partial** — *dice-race* (parent-led) plus Panda within 5; the KS1 programme reaches well beyond 5 and nothing in-app does |
| 9 | Tens and ones | KS1 *Number – number and place value* [O, heading only] | **Abacus** (`abacus_screen.dart`): a *non-interactive* preview of 3 fixed examples, each showing a single active bead in one of the ones/tens/hundreds columns. It shows column values, not two-digit numbers, and offers no bead interaction. Place Value Explorer's examples run to thousands and decimals, so it is out of range. | **not supported** — beyond the Reception range this lane targets | **partial** — static preview only, clearly labelled as such |
| 10 | Measurement and time | KS1 *Measurement* [O, heading only] | Family Maths *measure-everything*, ages 7–9, parent-led; no clock or time activity was found in the files reviewed. | **planned only** | **planned only** — the one parent-led activity starts at age 7, the very top of Year 2 |

**Not in these ten families and therefore not supported in this contract version [P]:** KS1 *fractions*, *multiplication and division*, and *statistics*. No repository evidence for early-years versions of these was found, and this contract deliberately does not stretch the ten families to reach them.

**Coverage summary:** *available now* — none of the ten families is fully available in either lane; the single verified child-facing activity (Panda) yields **partial** coverage of two families (3 and 8) in Lane A. Lane B has **partial** coverage of families 4, 5, 7, 8 and 9, and for 4, 5 and 7 that is parent-led content only.

## 4. Activity lifecycle [P]

Every early-lane activity moves through five states. They describe what is *offered*, not what a child *is*. None is a mastery claim, and none is ever shown to a child as a grade.

| State | What it means | What is recorded (local only) | Child-facing wording rule |
|---|---|---|---|
| **Discovery** | First encounter. A short, optional, non-scored look at what the activity is. | `discovered` | Invitation only ("Want to try feeding Panda?"). |
| **Guided play** | Supported first rounds. Mistakes are explored, not counted against the child; support is always available. | `round_started`, `round_completed` | Neutral or specific-strategy language; never "wrong" as a label. |
| **Repeatable variation** | Fresh deterministic rounds that change something meaningful (e.g. the number, the arrangement) while the idea stays the same. | `variation_seen` with the reproducible seed | "Here's a new one." Never "level up." |
| **Ready to try next** | The app *offers* a related next activity because a local, authored rule was satisfied. An invitation the child or parent can decline; declining is not recorded as anything. | `next_offered` | "Ready to try …?" alongside an equally prominent "Not now." Never "mastered," never "completed the level." |
| **Revisit** | Returning to an earlier activity, always available, resurfaced only as an invitation after an authored gap. | `revisited` | No message at all if a revisit never happens. |

Rules for every state:
- **Pause, stop and return later are valid outcomes at any point** and are never logged as a failure.
- **"Ready to try next" is never stored as a mastery status.** It is a one-time offer derived from local counts; it can be recomputed and is not accumulated into a score.
- **Thresholds are authored later, per activity, and are not fixed here.** What this contract fixes is the *shape*: counts of completed rounds and distinct variations, never a speed, never a percentage, never a streak.
- **The six-state mastery vocabulary of the Iteration Contract (no evidence … retained) is not shown to families in either early lane.** Words such as "developing" can read as labels to a parent of a four-year-old, so early-lane surfaces use only the lifecycle words above. Diagnostic-family codes are not used at all in these lanes.

### 4.1 Applying the lifecycle to the two verified activities [R]

**Feed the Hungry Panda** — verified behaviour:
- Rounds are deterministic from a seed (`FeedPandaChallenge.forSeed`); target 1–3, exactly 5 apples, 4 multiple-choice answers drawn from 0–5. "New Round" advances the seed by one (`nextSeed`). The controller records there is "no penalty and no attempt limit," and an over-feed produces a brief, self-clearing acknowledgement rather than a countdown.
- It already emits local, typed events (`activityStarted`, `fruitSelected`, `correctFruitAccepted`, `dropReturned`, `targetReached`, `remainingAnswerCorrect`, `remainingAnswerRetry`, `roundCompleted`, `roundRestarted`), including whether drag or tap was used.
- Lifecycle fit: *discovery* = first `activityStarted`; *guided play* = early rounds; *repeatable variation* = "New Round"; *revisit* = returning later. **"Ready to try next" has no verified target:** there is no later activity in the Early Maths Playground (the hub lists exactly one), so today the honest behaviour is to offer *nothing* rather than invent a successor.
- Honest limits found in the code: Panda's content is Round 1 only; **no narration is implemented** (`feed_panda_voice_cues.dart` defines cue ids only and states the activity is fully playable with voice disabled), so a pre-reader receives a text instruction; and the button labelled "Replay instruction" calls `restartSameChallenge`, i.e. it **restarts the same round rather than replaying audio**. That label overstates what it does and is recorded here as a truthfulness gap, not fixed.

**Abacus** — verified behaviour: three fixed static examples cycled by "Try another example", inside the shared Visual Maths scaffold that already shows a visible "Preview" badge and a "coming in a future release" note. There is no interaction to design a lifecycle around. Only *discovery* exists; *guided play*, *variation*, *ready to try next* and *revisit* are **planned only**.

## 5. Parent–child participation contract

The full parent contract is `PARENT_PARTNERSHIP_CONTRACT_V1.md` and is not repeated. Its rules apply unchanged to both lanes: parent as supportive co-player and observer, never a second examiner; 5–10 minute optional activities; cooperative not competitive; specific, observation-based encouragement; clear stop/pause/return-later guidance; and none of parent-versus-child scoring, ranking, streak pressure, shame or "behind" language, or surveillance-style engagement scoring.

Early-lane deltas [P]:
- **Adult presence is suggested for Early Maths Play, never required or enforced.** This stays consistent with the Parent contract's "no required parent participation."
- **A child who wants to stop is stopped.** Copy for the parent says so plainly.
- **Existing parent-led content [R]:** `family_activities.json` holds 17 parent-led activities, each 5–10 minutes with declared minimum and maximum ages, reached through the PIN-gated Family Maths screens. Five have a minimum age of 6 or under and so fit these lanes at their core (*shape-hunt* 4–8, *build-twenty* 5–8, *dice-race* 5–7, *pattern-detective* 5–8, *garden-geometry* 6–10); several others start at age 7, the top of Year 2, and are treated as boundary cases only. A future Parent Companion Card for these lanes should be sourced from this catalogue rather than duplicate it. **One link is unverified:** *shape-hunt* and *garden-geometry* declare a Studio connection to the Visual Maths hub, whose screens (by file listing) are number line, fraction bars, abacus and place value, and none is a shape activity, so the relevance of that link to the shape concept is not established.

## 6. Truthful UI availability rules

1. **Existing, verified activity → tappable.** Only if it is real, live and interactive.
2. **Partial or unsupported → clearly labelled, never presented as curriculum coverage.** The label states the actual scope, not a year group.
3. **Planned → non-tappable, or absent.** A planned item may be shown only in a parent-facing area as plain text; the child-facing view never shows "coming soon" tiles.
4. **No coverage claims.** No card, badge or summary may say "Reception maths," "Year 1 done," "KS1 covered," or show a percentage or a count of activities or questions.
5. **Copy states scope, not level.** Panda's honest description is "counting out up to 3 apples from 5, and how many are left," not "Reception counting."

| Item | Classification (verified) | Treatment |
|---|---|---|
| Feed the Hungry Panda | available now (narrow scope) | **Tappable**, described by its real scope (rule 5). |
| Abacus | partial (static preview) | **Tappable only as the existing labelled preview**; never in Lane A; in Lane B only as a clearly marked preview. |
| Family Maths parent-led activities | available now, parent-led | **Not a child card.** Surfaced only to the parent (later, via a Parent Companion Card). |
| Number line, place value explorer, fraction bars | exist, built for older learners | **Absent** from both lanes until reviewed for ages 4–7. |
| Spatial Intelligence activities | exist, built for KS2+ | **Absent** from both lanes. |
| Dino Polo | planned only; **no implementation anywhere** (re-confirmed: no matches in `lib` or `assets/config`; the only "dino" substrings are the Italian word *giardino*) | **Absent.** If ever specified ahead of content, a non-tappable placeholder only, never a preview card with working controls. |
| Every concept family marked *planned only* in Section 3 | planned only | **Absent from the child view.** |

## 7. Data and transition principles

### 7.1 Minimal future evidence model [P]

Compatible with the existing `LearnerScopeId` mechanism (`learner_scope_resolver.dart`: device-guest, managed learner, or local account) and with the local, no-PII schema in `DIAGNOSTIC_EVIDENCE_AND_MASTERY_LEDGER_V1.md`. It is deliberately smaller than that ledger.

```jsonc
{
  "schemaVersion": 1,
  "learnerScopeId": "existing LearnerScopeId.value — never a name or email",
  "activityId": "e.g. feed_the_hungry_panda",
  "conceptFamilyId": "one of the ten family ids in Section 3",
  "manifestStage": "early_years | KS1",
  "lifecycleEvent": "discovered | round_started | round_completed | variation_seen | next_offered | revisited",
  "generationSeed": "integer, so the round can be reproduced; null if not generated",
  "interactionMode": "tap | drag | null   // accessibility context only, never a judgement",
  "timestamp": "ISO 8601, local device clock"
}
```

Explicitly **excluded** from this model: any score, accuracy percentage, speed or latency, rank, streak, time-on-app, predicted or algorithmic ability label, risk flag, or comparison to any other learner. The lane preference (Section 2) is stored **separately** as a learner-scoped preference and is never an evidence field.

**Existing-storage gap found [R]:** Feed the Hungry Panda's progress (`feed_the_hungry_panda_progress_service.dart`) keys its data by `LearnerProfilesService.activeLearnerId ?? 'default'`, **not** by `LearnerScopeId`. A guest and a signed-in account with no managed learner therefore both resolve to `'default'` and share one store. This is the same older convention used by other feature progress services and is not unique to Panda, but Panda is the only early-years evidence store, so any early-lane evidence work has to start by resolving it.

### 7.2 Moving between lanes without losing continuity [P]

- Evidence is keyed by **activity and concept family**, never by lane. Switching lane changes only which activities are *suggested first*.
- Nothing is reset, hidden, re-labelled or re-assessed on a lane change.
- **No age band lock.** A child in Lane A may open Lane B activities via "see more activities," and vice versa, at any time.
- Some activities can legitimately sit in both lanes (the parent-led Family Maths catalogue's overlapping age ranges already do); the lifecycle state travels with the activity.
- "Ready to try next" may point across lanes.
- A move to KS2 content is handled by the existing stage model and is out of scope here; early evidence is retained, and is not used to place or label a learner in KS2.
- **Open decision:** the curriculum manifest today models only `topicDrill` and `quickStart` per topic and stage, and lab availability is resolver-owned. Early activities are not pack-based, so where their availability is declared (a manifest extension or a separate governed registry) is undecided. **This contract does not modify the manifest** and does not assume either answer.

## 8. Acceptance criteria and the recommended next slice

### 8.1 Acceptance criteria for any future implementation

**Accessibility and inclusion**
- Every control has a screen-reader label and a target size at least as large as the existing minimum, and larger for these ages. Panda already provides per-fruit, per-answer and Panda-state semantic labels [R].
- Text scaling (Small/Medium/Large), Light/Dark/System theme and contrast behave exactly as elsewhere in the app.
- **No instruction may depend on reading alone before a lane is presented as suitable for pre-readers.** Because narration is not implemented, either narration exists or an adult read-aloud affordance is offered, and the limitation is stated to the parent.

**Reduce Motion**
- Reduce Motion never changes correctness, availability or navigation. Panda already honours the in-app Reduce Motion preference and the system "disable animations" setting [R]; every future early activity must do the same.

**Offline and determinism**
- Fully offline. No network, cloud, or AI call. Any generated round reproducible from a stored seed.

**Layout**
- Portrait and Pixel 6a compact landscape (915×412) both render without overflow and keep every control reachable, verified host-side using the existing test conventions.

**Parent controls**
- The parent can change or clear the lane, pause or stop, and clear the child's early evidence. Lane selection is not reachable by the child.

**Truthfulness**
- Every child-facing item is *verified* and tappable, or absent. No coverage claims (Section 6).

### 8.2 The single recommended next implementation slice

**Move Feed the Hungry Panda's local progress storage onto the existing `LearnerScopeId` scoping, with a read-through for any existing data, and add no UI.**

Why this, and why only this:
- It is the one early-years evidence store in the repository, and it demonstrably shares one scope between a guest and a signed-in account (Section 7.1). Every later element — lifecycle "revisit," lane-change continuity, a Parent Companion Card — depends on early evidence being correctly scoped first.
- It is small and additive: same events, same counters, a different key namespace.
- It touches no navigation, route, asset, manifest, localisation, or visible UI, and is fully host-testable with the pattern already proven for `ContinueLearningService` and `RatioFoundationsProgressService` (scope isolation between guest, managed learner and signed-in account).

Boundaries: Panda only (the other feature progress services keep their older convention and are not changed); no new events; no lane storage; no new activity.

Alternatives considered and **not** chosen:
- A lane picker: needs onboarding or profile changes and has no verified activity beyond Panda to put in it.
- Narration for Panda: needs audio assets and is larger.
- New early activities: content authoring, and nothing yet defines their availability home (Section 7.2).
- Fixing the "Replay instruction" label: a localisation change across many locales for a cosmetic gain.

### 8.3 Corrections and open decisions

- **Correction to `STUDIO_ACTIVITY_CURRICULUM_LINK_AUDIT_V1.md`, row 2 (Panda):** it says the learner "hears/reads a quantity instruction." Repository evidence shows a **text** instruction only; narration is not implemented, and "Replay instruction" restarts the round. Row 2 of the audit has since been corrected to say so, in the same documentation checkpoint.
- **Open decisions for the product owner:** (1) where availability of non-pack early activities is declared; (2) the pre-reader narration policy; (3) whether lane selection lives in onboarding or the parent area of Profile; (4) whether to supply the four named references, or add the two early-years titles already present in the research folder.
