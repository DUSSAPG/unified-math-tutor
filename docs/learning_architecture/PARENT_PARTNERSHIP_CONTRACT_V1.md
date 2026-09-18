# Parent Partnership Contract V1

**Status:** design contract, not implemented. No parent account, Parent Companion Card UI, ledger view, storage schema, or notification is created by this document — it specifies the shape any future implementation must follow, the same way `LEARNING_OBJECTIVE_ITERATION_CONTRACT_V1.md` and `DIAGNOSTIC_EVIDENCE_AND_MASTERY_LEDGER_V1.md` specify the learning and evidence layers this one sits on top of.

## ⚠ Evidence-level disclaimer (read before the rest of this document)

This document was researched against the private reference library at `D:\AI\Quantumlab\research\MATH DESIGN REFERENCE\Parents` (16 files — full list in the "Sources reviewed" section below) using the **same copyright-safe methodology** already established in `WORKBOOK_LIBRARY_MAP_V1.md`: **no PDF's content was opened**. No page was read, no text extracted, no OCR run. Every claim attributed to this folder below is **`evidenceLevel: bibliographic_inference_only`, `confidence: low`** — a title/author/series-level signal, never a verified description of a specific book's actual content, method, or evidence base.

Two further rules this document holds itself to:

- **Source-supported vs. original** is marked explicitly on every principle below. "Source-supported (bibliographic)" means the *general pattern* (e.g. "short, frequent sessions") is consistent with what several titles' names/framing suggest, not that this app's specific wording, activities, or design were copied or paraphrased from any of them — none were. "Original proposal" means the idea is this document's own, not attributed to any source.
- **Older or broad "brain training" claims are treated as unverified.** Several reference titles are decades old (e.g. mid-20th-century parent-math-game traditions) and predate rigorous replication standards in education research. Nothing in this document cites such a title as evidence that an activity "trains the brain," "boosts IQ," or produces any specific cognitive outcome — only that a *format* (short/cooperative/game-like) is a long-standing, widely-published convention, which is a much weaker and more defensible claim.

Nothing here is learner-facing source material; no book text, activity, question, diagram, or layout is reproduced anywhere below.

---

## 1. Parent role: supportive co-player, observer, conversation partner — never a second examiner

The parent's role in any at-home activity this app ever surfaces is defined narrowly and consistently:

- **Co-player**: doing the activity *alongside* the child, not administering it to them.
- **Observer**: noticing strategy, effort, and engagement — not scoring correctness.
- **Conversation partner**: asking the one original prompt the Parent Companion Card supplies (see Section 7), and following the child's own reasoning rather than steering to a "correct" answer.
- **Never a second examiner**: the parent is never asked to grade, time, correct, or re-test what the app itself already assessed. If a parent wants to see how their child is actually doing, that belongs in the (separate, opt-in) Parent Mastery Ledger — never folded into the at-home activity itself (see Section 8).

*Source-supported (bibliographic):* the "parent as natural teacher/co-player, not examiner" framing is consistent with the title-level signal of Geraldine Taylor's *Be Your Child's Natural Teacher* and the general "for the both of you" framing of Benjamin & Shermer's *Teach Your Child Math*. *Original proposal:* the explicit prohibition on the parent acting as "a second examiner" and the routing of any assessment role to a strictly separate, opt-in ledger are this app's own design decisions.

## 2. Child agency: choice, pause, skip, and stop are valid outcomes

- The child chooses whether to start an at-home activity at all. Nothing in the app implies a consequence (lost streak, missed content, a "behind" label) for not starting one.
- The child may pause or skip an activity mid-way. A skip is recorded, if at all, only as "not completed this time" — never as a wrong answer, never as negative evidence in the learning ledger defined in `DIAGNOSTIC_EVIDENCE_AND_MASTERY_LEDGER_V1.md`.
- The child may stop the activity entirely and say so; the app and the parent-facing copy both treat "we stopped" as a complete, valid outcome, not an interrupted one requiring resumption pressure.
- *Original proposal.*

## 3. A 5-10 minute optional at-home activity format

Every at-home activity this contract governs is designed to fit inside 5-10 minutes, including the conversation prompt. It is always optional — never a required extension of a lesson, never gating access to in-app content.

*Source-supported (bibliographic):* this exact time window is a widely-published convention in this reference set by title alone — Deborah Diffily's *Fun-filled 5- to 10-minute math activities for young learners*, Betsy Franco's *5-minute math problem of the day for young learners*, and Peggy Kaye's *Games for learning: ten minutes a day* all name this window explicitly in their titles, independent of any of their actual content being read. That a short, bounded format is a long-established convention for parent-child maths activities is the only claim drawn from them; the activities themselves are original to this app.

## 4. Cooperative, non-competitive design

None of the following are ever part of an at-home activity or its surrounding UI:

- parent-versus-child scoring or a head-to-head "who got it right" framing;
- ranking against siblings, classmates, or any other learner;
- streak pressure (a missed day is never flagged as broken, lost, or reset in a way visible to the child);
- shame, "behind," "falling behind," "catching up," or any comparison-to-a-norm language, to the child or in parent-facing copy;
- a timer presented as a competitive pressure (a *supportive* 5-10 minute guideline is fine; a visible countdown implying failure on expiry is not).

*Source-supported (bibliographic):* Benjamin & Shermer's *Teach Your Child Math: Making Math Fun for the Both of You* and Michele Williams' *Math Can Be Fun: A Parent's Guide to Engaging Kids in Math* both signal, by title, a shared-enjoyment framing rather than a testing one. *Original proposal:* the explicit, exhaustive list of banned competitive/shame mechanics above is this document's own — no source title was read closely enough to attribute it to any of them specifically.

## 5. Specific encouragement, never generic performance labels

Any encouragement text this app or a Parent Companion Card ever supplies is:

- tied to an **observed strategy or effort** ("you tried counting in groups of ten — that's exactly the kind of shortcut mathematicians use"), never a **generic performance label** ("great job!", "you're so smart", "100%!");
- authored per activity/objective, from the same deterministic-template posture `DIAGNOSTIC_EVIDENCE_AND_MASTERY_LEDGER_V1.md`'s Parent Insight Card already commits to — never freeform or LLM-generated at runtime;
- never comparative ("better than last time," "faster than usual") and never tied to a numeric score.

*Original proposal* — no source title's actual encouragement language was read; this is this document's own rule, motivated by widely-known (and, unlike "brain training," genuinely well-replicated) findings that process/strategy praise outperforms trait praise — cited here as general, independently-established knowledge, not attributed to any file in the Parents folder.

## 6. Parent privacy/access principles (future parent account + learner ledger)

These principles bind any future parent account and Parent Mastery Ledger implementation, consistent with the local-only, no-PII posture already established in `DIAGNOSTIC_EVIDENCE_AND_MASTERY_LEDGER_V1.md`:

- A parent never needs an account to use an at-home activity with their child — the Parent Companion Card (Section 7) is reachable without signing in, matching this app's existing guest-first posture.
- Any future signed-in parent view reads the *same* local, profile-scoped evidence ledger already defined for the learner — it does not introduce a second, parallel data store.
- No data about a specific child ever leaves the device for this feature. No analytics, no cloud sync, no third-party SDK is introduced by this contract (see `DIAGNOSTIC_EVIDENCE_AND_MASTERY_LEDGER_V1.md`'s existing no-PII schema).
- A parent can see only their own managed learner(s)' evidence (the existing `LearnerScopeId` isolation already proven in the codebase's profile-scoped services) — never another family's, never an aggregate across unrelated children.
- A parent can request their child's local evidence be cleared, mirroring the app's existing local-reset conventions — this contract adds no new retention obligation beyond what already exists for learner data.

*Original proposal* — privacy architecture is not something any reference book could speak to; this section is entirely this document's own, built on the app's already-existing local-first data posture.

## 7. The Parent Companion Card contract

**Name-collision note:** this "Parent Companion Card" is unrelated to the child-facing "Mathematical Companion Interaction" defined in `DIAGNOSTIC_EVIDENCE_AND_MASTERY_LEDGER_V1.md`'s Part G (a possible future 2.5D companion visual tied to an objective). The word "Companion" is used in both for the same everyday sense — "something that accompanies" — but they are two independent, non-overlapping concepts: one is a parent-facing information card, the other is a possible future child-facing interaction. Neither depends on the other, and neither implements the other.

A Parent Companion Card is a single, truthful, single-activity artifact. Every field is mandatory; a card missing any of them is not a valid Parent Companion Card:

| Field | Contract |
|---|---|
| **Curriculum objective** | The exact `curriculumNodeId`/`objectiveId` this card is tied to (same identifiers as `LEARNING_OBJECTIVE_ITERATION_CONTRACT_V1.md`) — never a vague topic name. |
| **Child-facing activity status** | The child's own deterministic evidence state for that objective, in the same six-value vocabulary already defined (no evidence / developing / secure on current rung / transfer demonstrated / retention due / retained) — translated to plain language, never a raw code, never a fabricated summary. |
| **One original conversation prompt** | A single, open-ended question a parent can ask, authored per objective, inviting the child to explain their thinking — never a re-test of the app's own assessment. |
| **One optional original real-world activity** | A single, short (fits the 5-10 minute window), original, at-home activity connecting the objective to everyday life — never a copy or close paraphrase of any reference book's activity. |
| **What to notice** | Plain guidance on what strategy or reasoning to look and listen for — framed for observation, not correction. |
| **When to stop** | An explicit, honest cue for a good stopping point (e.g. "once your child has explained their thinking once, that's enough for today") — reinforcing Section 2's agency principle, not a target to push past. |
| **Availability state** | One of `available` / `planned` / `unavailable`, exactly mirroring the curriculum manifest's own honesty contract (`GLOBAL_CURRICULUM_ENGINE_R0.md` / `assets/config/curriculum_manifest.json`) — a card is never shown as available for an objective that is not genuinely available to the child. |

A Parent Companion Card is generated **deterministically** from the same authored-template posture as the Parent Insight Card in `DIAGNOSTIC_EVIDENCE_AND_MASTERY_LEDGER_V1.md` — never freeform, never LLM-generated at runtime, and never invented for an objective that has no genuine underlying content (see Section 11 — no card exists ahead of real, approved content).

## 8. Parent Companion Card vs. Parent Mastery Ledger — explicitly distinguished

| | Parent Companion Card | Parent Mastery Ledger |
|---|---|---|
| **Scope** | One activity, one objective, right now | Accumulated evidence across many objectives/sessions over time |
| **Purpose** | Give the parent something to *do together* with their child today | Give the parent an honest, evidence-backed *picture* of progress so far |
| **Relationship to Part E's "Parent Insight Card"** | A different artifact — shorter, activity-scoped, forward-looking ("here's today's prompt") | The Ledger *is* the natural evolution of `DIAGNOSTIC_EVIDENCE_AND_MASTERY_LEDGER_V1.md`'s existing "Parent Insight Card" contract (same deterministic-template rules, same six-state vocabulary, same no-comparison/no-jargon rules) — this document does not redefine it, only names the relationship |
| **Requires an account?** | No — reachable without signing in (Section 6) | Yes, in practice — a persistent cross-session view is the reason a parent would sign in at all |
| **Contains assessment language?** | No — deliberately avoids status framing beyond the one plain-language line in Section 7 | Yes — this is exactly where the fuller Secure/Developing/Retained picture belongs |
| **Can exist without the other?** | Yes — a family that never signs in still gets truthful Companion Cards | Yes — the Ledger can exist even for a session with no Companion Card shown that day |

The key discipline this section enforces: **assessment-flavoured content lives in the Ledger, never in the Companion Card.** A Companion Card that starts accumulating history, scores, or comparisons has stopped being a Companion Card and has become (a duplicate, worse version of) the Ledger.

## 9. Age adaptation

**Early Years / KS1 / KS2:**
- The conversation prompt and real-world activity lean concrete and playful — objects to count, group, share, or compare physically, matching the Concrete-Pictorial-Abstract progression already referenced in this app's curriculum design work.
- Parent role leans more toward co-player than observer (a 5-year-old rarely "explains their strategy" unprompted — the parent's job is to play alongside and narrate what they notice, not extract an explanation).
- Session length is at the short end of the 5-10 minute window.

**KS3-KS5:**
- The conversation prompt leans toward reasoning and justification ("why does that method work," "what would happen if...") rather than concrete manipulation.
- Parent role leans more toward observer/conversation partner — a teenager is more likely to explain their own thinking if simply asked and listened to, without a parent needing to structure a game.
- The real-world activity may connect to genuinely applied contexts (the same kind of applied framing already used in `YEAR8_RATIO_AND_KS4_QUADRATICS_BLUEPRINTS_V1.md`'s contextual-application rung) rather than manipulatives.
- Teen agency (Section 2) is held to *more* strictly at this band, not less — an unprompted "not tonight" from a KS4/KS5 learner is a complete, valid outcome, and the parent-facing copy says so explicitly rather than implying persistence is expected.

*Source-supported (bibliographic):* the age-graded nature of this reference set itself (books explicitly targeting "ages 3+," "young learners," "kindergarten to third grade" vs. more general/older-reader titles like *The Magic of Math*) supports treating early and later bands differently in general framing. *Original proposal:* the specific KS3-KS5 conversation-first, manipulative-light approach above is this document's own — none of the reference titles are secondary-school-specific by their titles.

## 10. Accessibility, offline-first, and Reduce Motion

- Every Parent Companion Card is fully usable as **plain text** — no image, diagram, or animation is required to read the objective, prompt, activity, or stopping cue. This matches the existing accessible/static-equivalent requirement already established for every Visualise/Applied Lab layer and every Companion/Concept Bridge in the other three contract documents.
- The card works **fully offline** — no network call, no LLM call, nothing server-rendered. It is generated from the same local, deterministic, template-driven mechanism as the rest of this app's content.
- **Reduce Motion never affects correctness, availability, or navigation** for a Parent Companion Card — the same rule already stated for every other interactive surface in this document set. A Companion Card has no animation to begin with; this is stated for completeness and consistency, not because a specific animated element exists.
- Text scaling (Small/Medium/Large), Light/Dark/System theme, and screen-reader labelling apply to the Parent Companion Card exactly as they do to every other screen in this app — no bespoke styling or exemption is introduced by this contract.

## 11. Not in v1

The following are explicitly out of scope for this contract and for any near-term implementation built from it:

- **No predictive child labels** — no "at risk," "gifted," "behind," "advanced," or any forward-looking categorisation of a child, ever, from this feature.
- **No automated risk scoring** — no algorithmic flag suggesting a learning difficulty, disengagement, or any clinical-adjacent conclusion. Any such observation belongs, if anywhere, with a qualified professional working from real evidence — never an automated inference from app usage.
- **No surveillance-style engagement tracking** — no time-on-screen-as-virtue metric, no "your child hasn't practised in 3 days" pressure notification, no keystroke/attempt-latency profiling beyond the already-defined, purpose-built evidence schema in `DIAGNOSTIC_EVIDENCE_AND_MASTERY_LEDGER_V1.md`.
- **No required parent participation** — every core learning journey (per `DIAGNOSTIC_EVIDENCE_AND_MASTERY_LEDGER_V1.md`'s Part G principle, extended here to the whole Parent Partnership surface) remains fully completable by the child alone. A Parent Companion Card is always an invitation, never a gate.

---

## Sources reviewed (bibliographic inventory, `D:\AI\Quantumlab\research\MATH DESIGN REFERENCE\Parents`)

All 16 files, `evidenceLevel: bibliographic_inference_only`, `confidence: low`, `provenance: research_only`, filename/title-level signal only — no content opened:

1. *5-minute math problem of the day for young learners* (Betsy Franco)
2. *50+ Super-Fun Math Activities* (Carolyn Ford Brunetto)
3. *Be your child's natural teacher, for parents of primary school children* (Geraldine Taylor)
4. *Beginner Abacus Math* (Tong Dazai)
5. *Computer Fun Math* (Lisa Trumbauer)
6. *Cool Structures: Creative Activities that Make Math & Science Fun for Kids* (Anders Hanson, Elissa Mann)
7. *Fun-filled 5- to 10-minute math activities for young learners* (Deborah Diffily)
8. *Games* (Action Math series) (Ivan Bulloch, Wendy Clemson, David Clemson)
9. *Games for learning: ten minutes a day to help your child do well in school — from kindergarten to third grade* (Peggy Kaye)
10. *Mastering electronics math* (R. Jesse Phagan) — **not a parent-child resource by title; adult/vocational technical reference, excluded from the principles above**
11. *Math Can Be Fun: A Parent's Guide to Engaging Kids in Math* (Michele Williams)
12. *Math together ages 3+* (Nick Sharratt)
13. *Sticker Math Fun* (Fiona Watt, Rachel Wells)
14. *Teach Your Child Math: Making Math Fun for the Both of You* (.djvu edition) (Arthur Benjamin, Michael Shermer)
15. *Teach your child math: making math fun for the both of you* (.pdf edition, same title as #14)
16. *The Magic of Math: Solving for x and Figuring Out Why* (Arthur Benjamin) — general popular-maths title, not specifically parent-child by title; used only as a weak signal that "making maths enjoyable" is a broader, well-published theme, not attributed for any specific principle above.
