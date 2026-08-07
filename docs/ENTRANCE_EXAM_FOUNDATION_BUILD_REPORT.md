# Entrance Exam Foundation — Build Report (Sprint 3)

Status: **PASS**. Do not commit (per instruction) — all changes remain
in the working tree alongside the rest of the pre-existing uncommitted
work.

## Scope

Architecture-first, as specified: models, a registry service, one
registered pack (deliberately not fully populated), navigation
integration through the *existing* exam-selection pathway (no new
bottom-nav item), and a real, working method-marking model — not just
documented in the abstract, but built into an actual practice flow.

## What was built

### 1. Models (`lib/models/entrance_exam_pack.dart`)

- **`EntranceExamPack`** — the exact field list from the brief
  (`packId`, `displayName`, `region`, `ageBand`, `targetEntryYear`,
  `paperType`, `difficultyTier`, `durationMinutes`, `calculatorPolicy`,
  `questionCount`, `totalMarks`, `sectionStructure`, `skillsCovered`,
  `methodMarkingSupported`, `sourceStatus`, `version`, `effectiveFrom`,
  `effectiveTo`), plus a required `nonAffiliationDisclaimer` (every
  pack carries its own, not one hardcoded app-wide string) and a
  nested `questions` list. `fromJson` is fail-fast throughout, mirroring
  `DiscoveryCard.fromJson`'s exact style — missing/malformed fields,
  unknown enum ids, invalid dates, a question's `skillId` not in the
  pack's own `skillsCovered`, and duplicate question ids all throw
  immediately rather than loading a broken pack.
- **`EntranceExamQuestion`** (the brief's "extension") — the real
  per-question content: `skillId`, `sectionNumber`, `marks`, and
  5-locale text (`prompt`, `workedMethodSteps`, `correctAnswerText`,
  `methodMarkGuidance`), with the same region→language→English
  fallback chain as `DiscoveryCard.textFor`.
- **`MethodMarkOutcome`** — the 5-tier method-marking model named in
  the brief: `correct` / `methodWithSlip` / `partialReasoning` /
  `unsupported` / `blank`. Its class doc states explicitly: **this app
  makes no handwriting-recognition, OCR, or automatic-grading claim
  anywhere in this feature** — there is no camera input and nothing
  reads a learner's actual written working. The learner compares their
  own paper working to the model's worked steps and self-selects the
  outcome, the way a teacher marks by eye. `marksFraction` is a
  transparent, documented heuristic (1.0 / 0.75 / 0.4 / 0.1 / 0.0) for
  an estimated mark total — explicitly not an official mark scheme.
- **`entranceExamModeAvailable(pack, mode)`** — pure function deriving
  each of the 5 modes' availability from real authored content, never
  a hand-set flag, mirroring `discovery_library_screen.dart`'s
  "a category is selectable iff it has content" convention:
  - `practiceBySkill` / `reviewMethods`: available once the pack has
    ≥1 authored question.
  - `untimedPaper` / `timedMock`: available only once
    `questions.length >= questionCount` **and** `sourceStatus ==
    contentComplete` — full question count alone isn't enough.
  - `scholarshipChallenge`: the above, **and** the pack must be
    `scholarship`-tier — a Foundation-tier pack can never offer it,
    regardless of content volume.

### 2. Services

- **`EntranceExamPackCatalogService`** (`lib/services/entrance_exam_pack_catalog_service.dart`)
  — singleton, `AssetBundle`-injectable, loads/validates
  `assets/config/entrance_exam_packs.json`, duplicate-pack-id
  detection, mirrors `DiscoveryCardCatalogService` exactly.
- **`EntranceExamProgressService`** (`lib/services/entrance_exam_progress_service.dart`)
  — learner-profile-namespaced `SharedPreferences` storage for
  self-assessed `MethodMarkOutcome`s (mirrors
  `RecallCardsProgressService`'s keying convention via
  `LearnerProfilesService`), plus `estimatedMarks(questions)` used by
  the practice session's completion screen.

### 3. The one registered pack

`assets/config/entrance_exam_packs.json` registers **"Independent
School Year 7 Mathematics — Foundation Pack"**: England, age band
10-11 (11+), Year 7 entry, written-method paper, Foundation tier,
45 minutes, no calculator, a declared full paper of **24 questions /
60 marks** across 3 sections (Arithmetic and Number; Reasoning and
Problem Solving; Shape, Space and Data), 6 skills covered
(`numberFluency`, `fractionsAndPercentages`, `ratioAndProportion`,
`algebraicReasoning`, `shapeAndSpace`, `dataAndLogic`),
`methodMarkingSupported: true`, `sourceStatus: contentInProgress`.

**Registered, but deliberately not fully populated**: only **12 of the
24 declared questions** are authored (2 per skill — one straightforward,
one slightly harder), each with full 5-locale text
(en/en-GB/de-CH/fr-CH/it-CH — en-GB mirrors en, de-CH/fr-CH/it-CH are
genuine translations following the catalog's established ASCII-safe
convention, same as Sprint 2). This is exactly the gap
`entranceExamModeAvailable` is built to respect: Practice by Skill and
Review Methods work today; Untimed Paper, Timed Mock, and Scholarship
Challenge stay honestly locked until a future content sprint completes
the paper.

**Confirmation: no copyrighted question was copied.** All 12 questions
(bookshop stock, minibus passengers, class walking to school, book
sale price, pancake-batter ratio, sharing money, a number pattern,
solving a linear equation, a 4-child race-order logic puzzle, a
garden's perimeter, a square's side length from its area, a pets bar
chart) were originated for this pack, with every worked answer
hand-verified arithmetically before being written.

### 4. The non-affiliation disclaimer

Carried as pack data (not hardcoded screen text), shown prominently on
the hub: *"This preparation pack is produced independently by Math
Intelligence. It is not affiliated with, endorsed by, or produced in
partnership with any specific independent school, examination board,
admissions consortium, or 11+ testing organisation (e.g. GL Assessment,
CEM/Durham University). It reflects the general style and difficulty
of commonly-used Year 7 entry mathematics assessments and does not
reproduce any real school's past paper or any copyrighted question —
every question here was originated for this pack."*

### 5. Screens (`lib/screens/entrance_exam/`)

- **`EntranceExamHubScreen`** — the pack card (name, age band,
  duration, calculator policy, section structure, the disclaimer, and
  an explicit "this app never reads or grades your handwriting" note)
  plus all 5 mode tiles. Available modes render as ordinary tappable
  `RouteLinkCard`s; locked modes render a distinct, inert, "Coming
  soon"-badged tile stating *why* (e.g. "Unlocks once the full
  24-question paper is ready — 12 authored so far", or for Scholarship
  Challenge specifically, "This pack is Foundation tier...") — never a
  silently-broken tap target.
- **`EntranceExamSkillListScreen`** — Practice by Skill's entry point;
  lists only skills with ≥1 authored question, each showing its real
  count.
- **`EntranceExamPracticeSessionScreen`** — the method-marking flow
  made real: Think (prompt only) → Reveal worked method → 5 self-mark
  buttons → next question → completion view with an estimated mark
  total (`EntranceExamProgressService.estimatedMarks`) and an explicit
  "this is your own self-marking, not an official mark scheme" note.
- **`EntranceExamReviewScreen`** — Review Methods: every authored
  question, revealable on demand, explicitly **no** self-marking UI —
  distinguishes it from Practice by Skill as pure, ungraded revisiting.

### 6. Navigation — through the existing pathway, no new nav item

`practice_screen.dart`'s `_ExamChoice` enum (the same chip row already
used for GCSE Foundation/Higher/Oxford Track/Swiss Gymnasium) gained
one new value, `entranceExamPrep`, always available (unlike Oxford
Track/Swiss Gymnasium, which stay locked placeholders). Selecting it
doesn't set `_selectedExam` into this screen's generic MCQ session
engine — Entrance Exam Prep has its own paper structure and marking
model that doesn't fit that engine — it instead pushes straight to
`/entrance-exam`, a new top-level route registered the same way
`/packs` and `/explore` already are (pushed above the shell, nested
routes for `skills`, `skills/:skillId`, and `review`). No bottom-nav
item was added or changed.

## Tests added (47)

- **`test/entrance_exam_pack_model_test.dart`** (28) — enum
  round-trips, `MethodMarkOutcome.marksFraction`'s bounded/monotonic
  scale, `fromJson` fail-fast coverage for both
  `EntranceExamQuestionLocaleText` and `EntranceExamPack` (missing
  fields, bad ids, bad dates, unknown enums, cross-reference
  validation, duplicates), `textFor`'s locale-fallback chain, and
  exhaustive `entranceExamModeAvailable` coverage for all 5 modes
  including the scholarship-tier-gate case.
- **`test/entrance_exam_pack_catalog_service_test.dart`** (5) — loads
  and validates the *real* bundled registry (not just synthetic
  fixtures), locks in "12 authored of 24 declared" staying true,
  `byId` not-found behaviour, cross-reference and duplicate-id checks
  against the real data.
- **`test/entrance_exam_screens_test.dart`** (6) — isolated
  screen-content tests: hub renders the pack/disclaimer/all 5 tiles
  and shows exactly 3 locked badges; skill list shows all 6 skills
  with correct counts; the full practice-session flow (Think → Reveal
  → all 5 mark buttons present → mark → next question → completion
  view with an estimated-marks summary) end to end across both
  authored `numberFluency` questions; an empty/unknown skill completes
  immediately rather than showing a blank screen; review screen shows
  all 12 reveal buttons with zero marking UI anywhere.
- **`test/entrance_exam_navigation_test.dart`** (8) — against the
  *real* production `appRouter`: Practice → Exam Simulator → "Entrance
  Exam Prep" chip (confirmed to have no lock icon, unlike Oxford
  Track/Swiss Gymnasium) opens the hub with no exception; every nested
  route resolves both via in-app taps and as a direct deep link
  (`/entrance-exam`, `/entrance-exam/skills`,
  `/entrance-exam/skills/numberFluency`, `/entrance-exam/review`); the
  3 locked modes are confirmed inert (tapping them leaves you on the
  hub, not a broken link).

Total suite: **1169/1169 passing** (1122 after Sprint 2 + 47 new),
after `dart format .` (cosmetic only) and `flutter analyze` (0 issues).

## Guardrail compliance

- No mode was exposed without sufficient content — 3 of 5 modes stay
  honestly locked, each with a stated, data-driven reason.
- No handwriting-recognition/OCR/auto-grading claim anywhere — stated
  explicitly in the model's doc comment and again in-product on the
  hub screen.
- No new bottom-nav item — reached via the existing Exam Simulator
  chip row.
- No unrelated app architecture changed — `practice_screen.dart`'s
  only change is one new enum value and its label/availability/onTap
  wiring; everything else is new, additive files.
- Confirmed no copyrighted question was copied — every question
  originated for this pack, arithmetic hand-verified.

## Return report

- **PASS/FAIL:** PASS.
- **Files changed:** `lib/models/entrance_exam_pack.dart` (new),
  `lib/services/entrance_exam_pack_catalog_service.dart` (new),
  `lib/services/entrance_exam_progress_service.dart` (new),
  `lib/screens/entrance_exam/*.dart` (4 new: hub, skill list, practice
  session, review, + a shared labels helper — 5 files),
  `assets/config/entrance_exam_packs.json` (new),
  `lib/l10n/app_en.arb` + `app_de_CH.arb` + `app_fr_CH.arb` +
  `app_it_CH.arb` (+ regenerated `app_localizations*.dart`),
  `lib/app/router.dart` (new `/entrance-exam` route tree),
  `lib/screens/practice/practice_screen.dart` (one new `_ExamChoice`
  value), 4 new test files.
- **Tests added:** 47.
- **Total test count:** 1169/1169 passing.
- **Confirmation:** no copyrighted question was copied — all 12
  authored questions were originated for this pack.
- **No commit made**, per instruction.

This completes the 3-sprint sequence (Discovery/Recall Coverage Audit
→ Applied Discovery Category Pack → Entrance Exam Foundation).
