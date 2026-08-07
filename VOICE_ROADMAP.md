# Voice Roadmap

Status: planning document only. **No text-to-speech was implemented in
this pass** — no audio code, no TTS engine, no dependency added. This
document exists to prepare the app for future voice integration by
mapping every screen, its recommended narration, and where a real TTS
engine would plug in.

## What already exists (read this before building anything)

Interactive Labs already has a real, working narration *architecture* —
just no voice engine behind it yet:

- **`GuidedNarrationService`** (`lib/services/guided_narration_service.dart`)
  — plays deterministic, authored `NarrationMessage`s (never an LLM,
  never network-backed), with a playback preference chain: pre-generated
  local audio (`NarrationManifestService`) → device/local TTS fallback →
  text-only. Text is always shown regardless of audio availability.
- **`TtsNarrator`** (`lib/services/tts_narrator.dart`) — the exact seam a
  real TTS engine plugs into: `abstract class TtsNarrator { void
  speak(String text, {required double speed, String? localeTag}); void
  stop(); }`. Today only `NoOpTtsNarrator` (a real, reachable no-op, not a
  stub) implements it. **This is the single integration point** — a real
  device-TTS plugin (or a hosted TTS API) becomes a drop-in second
  implementation, swapped in via `GuidedNarrationService.debugSetTtsNarrator`
  (which despite the `debug` name is the actual swap seam, not test-only
  scaffolding) or an equivalent production setter. No call site above
  `GuidedNarrationService` needs to change.
- **`NarrationManifestService`** — loads
  `assets/config/captain_math_narration_manifest.json`, a manifest of
  pre-generated audio files keyed by message id — the path for
  professionally recorded/generated audio to take priority over live TTS
  where it exists.
- **Already wired to this system today**: Flight Path Lab (direct
  `GuidedNarrationService` use — intro/hint/result/completion narration
  per `LabGuidanceLevel`) and, via the lighter `SimpleLabNarrationMixin`,
  Algebra Balance, Data Detective, Fraction Builder, and Number Line
  Explorer.
- **Not yet wired**: Football Precision and Maze Driver — both have
  narratable moments (kick outcomes, maze completion) but no narration
  call sites yet.
- **A separate, unrelated system**: `AudioCueService` (short SFX blips —
  `AudioCue.aircraftTurn`, `.success`, etc.) is not narration/voice and is
  out of scope for this roadmap.

Everything below assumes the same `TtsNarrator` seam is the eventual
integration point app-wide, not a new architecture per screen.

## Legend

- **VOICE_READY** — real, structured content already exists (worked
  explanations, prompts, step-by-step reveals, progress narrative) that a
  TTS engine could read today with no content-authoring work, only wiring.
- **VOICE_OPTIONAL** — narration would be a genuine enhancement (easier
  multitasking, accessibility, warmth) but the screen is already fully
  usable without it; short copy, not the primary content.
- **VOICE_NOT_REQUIRED** — navigation, settings, forms, or legal text.
  Narrating these adds noise, not value, and in some cases (password
  fields, PIN entry) would be a genuine privacy concern.

Recommended narration button label throughout: **"Listen"** with a
speaker icon when idle, **"Stop"** when playing — matching the pattern
`GuidedNarrationControls`/`lab_narration_controls.dart` already
establishes for Interactive Labs, not a new convention per screen.

## Onboarding & Auth

| Screen | Route | Status | Notes |
|---|---|---|---|
| User type | `/onboarding` | VOICE_OPTIONAL | Short prompt text; narrating eases first-run anxiety but isn't essential. |
| Accessibility step | `/onboarding/accessibility` | VOICE_OPTIONAL | Same. |
| Stage selector | `/onboarding/stage` | VOICE_OPTIONAL | Same. |
| Goal selector | `/onboarding/goal` | VOICE_OPTIONAL | Same. |
| Study profile | `/onboarding/profile` | VOICE_OPTIONAL | Same. |
| Family role detail / learner context / goal / preferences | `/onboarding/family/*` | VOICE_OPTIONAL | Same, parent-facing. |
| Sign in / Create account / Forgot password | `/auth/*` | VOICE_NOT_REQUIRED | Forms with credential fields — narrating input fields (especially password) is a privacy/UX antipattern, not a gap. |

## Home Shell

| Screen | Route | Status | Notes |
|---|---|---|---|
| Home | `/home` | VOICE_OPTIONAL | Dashboard/summary tiles; a "welcome back" narration is pleasant, not load-bearing. |
| Topics | `/topics` | VOICE_NOT_REQUIRED | A selection list — narrating a scrollable list of topic names has poor UX (would read out dozens of items). |
| **Practice** | `/practice` | VOICE_READY | Question stem + answer options are exactly what a learner using voice support needs read aloud. **Narration**: the question prompt and each MCQ option, read on question entry. **Button**: "Listen to question." **API point**: `PracticeScreen`'s current question model already exposes prompt/option text; route it through the same `TtsNarrator` seam Interactive Labs uses. |
| **Journey** | `/journey` | VOICE_READY | Progress narrative ("You've mastered X, next focus on Y") is structured, authored-feeling text — a strong narration candidate. **Narration**: the screen's own summary/insight copy, read on demand, not automatically (avoid narrating on every visit). **Button**: "Listen to your summary." **API point**: whatever service currently generates Journey's insight text (ALI-driven recommendation copy) becomes the narration source — same `TtsNarrator` seam. |
| **Formula Library** | `/formulas` | VOICE_READY | Each `FormulaEntry` already has a name + explanation string. **Narration**: formula name + explanation, read per-card on expand. **Button**: "Listen" icon on each formula card, next to the existing diagram toggle. **API point**: `_FormulaCard`'s expanded section (already showing `VisualAssetView` when a diagram exists) is the natural place to add a `Listen` affordance reading `entry.explanation`. |
| Profile | `/profile` | VOICE_NOT_REQUIRED | Navigation list into settings sub-pages. |
| Profile — settings/appearance/accessibility/subscription/curriculum/privacy/terms | `/profile/*` | VOICE_NOT_REQUIRED | Settings toggles and legal text — narrating a Terms of Use page is a checkbox-ticking exercise, not a real accessibility win (screen readers already handle this via standard semantics, which every screen in this app already carries). |
| **Tutor** | `/tutor` | VOICE_READY | Chat-style `TutorMessage` model (role + text) already exists. **Narration**: each assistant message read aloud as it's added, matching how a real conversation would sound. **Button**: a persistent "Voice replies" toggle in the composer area, plus a per-message "Listen again" affordance. **API point**: the `_messages.add(TutorMessage(role: .assistant, ...))` call site in `tutor_screen.dart` is the exact place to also invoke narration — one line, once a real `TtsNarrator` exists. |
| Help | `/help` | VOICE_NOT_REQUIRED | Navigation/FAQ-style list. |
| Help — parent/teacher tools | `/help/parent-teacher-tools` | VOICE_NOT_REQUIRED | PIN entry + navigation list. |
| Help — parent cheat sheet | `/help/parent-teacher-tools/cheat-sheet` | VOICE_OPTIONAL | Reference text a parent might want read while cooking/driving — genuinely useful but not core. |
| Help — Family Maths welcome/library/activity detail | `/help/parent-teacher-tools/family-maths/*` | VOICE_OPTIONAL | Same reasoning as the cheat sheet — parent reference material, read-at-leisure, not interactive content requiring narration to function. |

## Math Studio

| Screen | Route | Status | Notes |
|---|---|---|---|
| Math Studio hub | `/math-studio` | VOICE_OPTIONAL | Pillar picker; short subtitle copy per tile. |
| **Build Confidence** | `/math-studio/build-confidence` | VOICE_READY | Untimed practice with worked explanations — the explanation text is a strong narration candidate, same reasoning as Practice. |
| Mental Maths hub | `/math-studio/mental-maths` | VOICE_OPTIONAL | Category picker. |
| Mental Maths category | `/math-studio/mental-maths/:id` | VOICE_READY | Each challenge already has `workedSteps`/`answerText` (confirmed in `assets/config/mental_maths_challenges.json`) — ready-made step-by-step narration content. **API point**: the existing worked-steps list, read step by step on request. |
| Visual Maths hub | `/math-studio/visual-maths` | VOICE_OPTIONAL | Format picker. |
| Visual Maths — number line/fraction bars/abacus/place value | `/math-studio/visual-maths/*` | VOICE_READY | Each placeholder already cycles authored captions (`abacusCaption1`, etc.) on "Try another example" — captions are already narration-ready text, just need a `Listen` affordance next to the existing caption. |
| **Math Magic** hub | `/math-studio/math-magic` | VOICE_OPTIONAL | Activity picker. |
| Math Magic — Visual Number Tricks | `/math-studio/math-magic/number-tricks` | VOICE_READY | The step-by-step reveal (original → reversed → difference → sum) is built exactly like a narration script already — each `_Step` row is one narratable line. |
| Math Magic — Patterns | `/math-studio/math-magic/patterns` | VOICE_READY | The formula/count line (`_formula`) is a ready narration source. |
| Math Magic — Magic Squares | `/math-studio/math-magic/magic-squares` | VOICE_OPTIONAL | Mostly a tap-to-place interaction; the "Magic!"/"not quite" feedback text could be narrated but isn't essential. |
| Math Magic — Parity | `/math-studio/math-magic/parity` | VOICE_READY | The reveal sentence ("3 + 4 = 7, which is odd... odd + even is always odd") is a complete, ready-made narration line. |
| Spatial Intelligence hub | `/math-studio/spatial-intelligence` | VOICE_OPTIONAL | Activity picker. |
| Spatial Intelligence — Cube Nets | `/math-studio/spatial-intelligence/cube-nets` | VOICE_READY | Each net's `explanation` string is already a complete, ready-made narration line. |
| Spatial Intelligence — Rotations / Transformations | `/math-studio/spatial-intelligence/{rotations,transformations}` | VOICE_OPTIONAL | Mostly direct-manipulation (slider/buttons); the caption text could be narrated but the activity is visual-first by nature. |
| Spatial Intelligence — Spatial Puzzles | `/math-studio/spatial-intelligence/spatial-puzzles` | VOICE_READY | Each puzzle's `explanation` string, same pattern as Cube Nets. |
| Discovery Library | `/math-studio/discovery` | VOICE_OPTIONAL | Card grid; short category copy. |
| **Discovery — card detail** | `/math-studio/discovery/:id` | VOICE_READY | Each Discovery Card already carries real-world narrative text (per-locale) — exactly the kind of content voice narration is built for. |
| **Recall Cards** hub | `/math-studio/recall-cards` | VOICE_OPTIONAL | Navigation/summary. |
| Recall Cards — browse/bookmarks | `/math-studio/recall-cards/{browse,bookmarks}` | VOICE_NOT_REQUIRED | Filterable lists — narrating a scrollable card grid has the same poor-UX problem as Topics. |
| **Recall Cards — card detail** | `/math-studio/recall-cards/card/:id` | VOICE_READY | Front prompt + back answer is literally a flashcard read-aloud model — one of the strongest candidates in the whole app. **Narration**: front prompt on card open, answer on flip. **Button**: "Listen" on both front and back. **API point**: `RecallCard.textFor(locale)`'s `frontPrompt`/`answer` fields are already locale-resolved strings ready to hand to a `TtsNarrator`. |
| Recall Cards — review session | `/math-studio/recall-cards/session` | VOICE_READY | Same content model as card detail, just sequential — same integration point, reused. |
| **Interactive Labs hub** | `/math-studio/interactive-labs` | VOICE_OPTIONAL | Navigation into the 7 labs. |
| Lab — Fraction Builder | `.../fraction-builder` | VOICE_READY | Already wired via `SimpleLabNarrationMixin` — needs only a real `TtsNarrator`, no new content work. |
| Lab — Algebra Balance | `.../algebra-balance` | VOICE_READY | Same — already wired. |
| Lab — Number Line Explorer | `.../number-line-explorer` | VOICE_READY | Same — already wired. |
| **Lab — Flight Path Lab** | `.../flight-path-lab` | VOICE_READY | Already wired via full `GuidedNarrationService` (intro/hint/result/completion, per guidance level) — the most narration-complete screen in the app today. Only missing piece: a real `TtsNarrator` implementation. |
| **Lab — Football Precision** | `.../football-precision` | VOICE_READY, not yet wired | Has clear narratable moments (kick result, target zone, mode intro) but no `GuidedNarrationService`/`SimpleLabNarrationMixin` call sites yet. **API point**: adopt `SimpleLabNarrationMixin` the same way Fraction Builder/Algebra Balance did — the state/result strings already exist in `_stateCopy`/`_KickResult`. |
| Lab — Maze Driver | `.../maze-driver` | VOICE_READY, not yet wired | Same gap as Football Precision — has narratable state but no narration call sites. |
| Lab — Data Detective | `.../data-detective` | VOICE_READY | Already wired via `SimpleLabNarrationMixin`. |

## Other root-navigator screens

| Screen | Route | Status | Notes |
|---|---|---|---|
| Exam Packs | `/packs` | VOICE_NOT_REQUIRED | Purchase/selection list. |
| Explore | `/explore` | VOICE_OPTIONAL | Feature-discovery cards; short copy. |
| Mental Math vault | `/mental-math` | VOICE_OPTIONAL | List of tricks. |
| Mental Math — trick detail | `/mental-math/:id` | VOICE_READY | `MentalMathTrick` already has `explanation`, `workedSteps`, `workedAnswer` — a ready-made script, same shape as Mental Maths category. |
| Daily Teaser | `/daily-teaser` | VOICE_READY | A single authored puzzle prompt + explanation — small but genuinely narratable content. |
| Tricks | `/tricks` | VOICE_OPTIONAL | List/summary screen. |
| Upgrade | `/upgrade` | VOICE_NOT_REQUIRED | Pricing/purchase screen. |
| Release Notes | `/release-notes` | VOICE_NOT_REQUIRED | Changelog text. |

## Family Studio ("Parent Studio")

| Screen | Route | Status | Notes |
|---|---|---|---|
| **Family Studio hub** | `/family-studio` | VOICE_OPTIONAL | Opening promise + Allie message are warm, short copy — narrating on demand is a nice touch, not essential; this is a navigation hub, not content. |
| **Family Studio — today's activity** | `/family-studio/today` | VOICE_READY | Pulls a full `FamilyActivity` (materials, what-your-child-learns, let's-explore, questions-to-ask, misconceptions, try-tomorrow) — the richest parent-facing content model in the app, built for exactly this. **API point**: `FamilyActivity.textFor(locale)`'s fields, read section by section on request. |
| **Family Studio — homework companion** | `/family-studio/homework-companion` | VOICE_READY | Generates a session of concrete steps (`HomeworkSessionItem`s) — narratable in the same way a Recall Card session is. |
| Family Studio — what your child is learning | `/family-studio/learning` | VOICE_OPTIONAL | Summary/progress view; short copy, not a script. |
| Family Studio — conversation starters | `/family-studio/conversation-starters` | VOICE_READY | Purpose-built short prompts meant to be *said out loud* to a child already — the single most natural narration fit of any screen in the app. |
| Family Studio — progress snapshot | `/family-studio/progress` | VOICE_OPTIONAL | Stats/summary view. |
| Family Studio — tutor tools | `/family-studio/tutor-tools` | VOICE_NOT_REQUIRED | Learner picker + assign-practice controls — a form, not content. |

## Priority order, if this is ever built

1. **Wire a real `TtsNarrator`** behind the existing seam — this alone
   turns on narration for every already-wired lab (Flight Path Lab,
   Fraction Builder, Algebra Balance, Number Line Explorer, Data
   Detective) with zero new content work.
2. **Recall Cards** (detail + session) and **Family Studio — Conversation
   Starters** — the two strongest content-model fits outside labs, both
   simple text-in/speech-out with no new UI beyond a `Listen` button.
3. **Football Precision and Maze Driver** — adopt the same
   `SimpleLabNarrationMixin` pattern as their sibling labs, closing the
   only real gap in Interactive Labs' narration coverage.
4. **Tutor** — narrate assistant replies as they're added to `_messages`.
5. Everything else marked VOICE_READY, roughly in the order listed above.

VOICE_OPTIONAL screens are worth revisiting once the above ships and
real usage data shows whether learners/parents actually reach for voice
outside labs and flashcards. VOICE_NOT_REQUIRED screens are not expected
to ever need this — re-litigate only if a specific accessibility need
surfaces that generic screen-reader semantics (already present app-wide)
don't cover.
