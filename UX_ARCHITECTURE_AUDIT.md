# Math Intelligence V1 — UX & Architecture Audit

Date: 2026-07-20. Scope: audit only, against the QuantumLab Product Contract (Layer 1 Core Product
priority for V1; Layer 2 ALI = deterministic only; Layer 3 Allie = evidence-based templates only;
Layer 4 Agentic Infrastructure out of scope; no essential learner journey may depend on a generative
AI response). Produced by reading the app's actual source (four parallel read-only research passes),
not by inference from screen names. File:line references are accurate as of this commit.

Companion document: [USER_JOURNEY_MAP.md](USER_JOURNEY_MAP.md).

---

## Global principles — compliance check

| Principle | Status | Evidence |
|---|---|---|
| Core Product fully usable without AI | ✅ Compliant | `Tutor` is the only AI-branded surface. It is a bottom-nav tab, not a gate — Practice, Topics, Journey, Formulas never reference it. `TutorCreditService.respond()` is a local keyword-matcher (`tutor_credit_service.dart:53`, doc comment: *"Returns a local mock response... No network calls."*). Whole-repo grep for `http.`, `HttpClient`, `apiKey`, `openai`, `anthropic` returns zero matches. |
| ALI provides deterministic recommendations only | ✅ Compliant (trivially — no ALI-branded recommendation surface exists yet) | No "recommendation card" of any kind exists on Home or elsewhere (confirmed by grep). Nothing to audit yet; will need re-checking once Prompt 2's sequencer/recommendation UI lands. |
| Allie communicates evidence-based recommendations only | N/A | No feature named "Allie" exists anywhere in the codebase (grepped case-insensitively). This is a roadmap concept, not yet built. |
| Agentic Infrastructure out of scope for V1 | ✅ Compliant | No agent-loop, autonomous scheduling, or multi-step AI orchestration code exists anywhere. |
| No essential learner journey depends on an LLM | ✅ Compliant | Confirmed above — Tutor is fully optional and fully deterministic. |
| **New finding, not in the checklist but contract-adjacent** | ⚠️ Honesty gap (P1) | The Tutor feature is marketed throughout the app as **"AI Tutor"** (`upgrade_screen.dart`, `subscription_screen.dart:78`, `release_notes_screen.dart:71`, Home "What's New" banner `app_en.arb:636`) despite being a hard-coded canned-response matcher. Behavior is contract-compliant; the marketing copy overstates it. |

**Verdict: the global principles are honored in the code that exists today.** The one finding worth carrying forward is a *copy* issue, not an architecture violation — see P1-6 below.

---

## Onboarding audit

**Actual flow implemented**, confirmed via `router.dart:60-79` and every onboarding screen: role → curriculum stage → learning goal → accessibility (text size + reduce motion) → optional "save your progress" (display name, and for parent/teacher also learner name + relationship + parent email) → Home.

Against the 7-step spec you provided:

| Spec step | Implemented? |
|---|---|
| 1. Choose role (Learner / Supporting a learner / Teacher) | ✅ Yes — `user_type_screen.dart` |
| 2. Choose learning goal | ✅ Yes, but **out of order** — implemented as step 2 of the code's own sequence, but the spec lists goal *before* curriculum; the app asks curriculum (stage) before goal. Not a defect, just a note that the two don't match 1:1 in ordering. |
| 3. Choose curriculum/exam target | ✅ Yes — `stage_selector_screen.dart` (runs *before* goal in code, see above) |
| 4. Accessibility & appearance | ✅ Accessibility yes (text size, reduce motion). **Appearance: no** — there is nothing to choose, app is dark-only (see UI audit below), so this step is accessibility-only in practice. |
| 5. Optional notifications | ❌ **Does not exist.** No `/onboarding/notifications` route, no notification permission/preference screen anywhere in the app (confirmed by grep for "notification" — only decorative icons exist, see Profile/Settings audit). |
| 6. Save progress | ✅ Yes — `study_profile_screen.dart`, correctly optional/skippable |
| 7. "What should we call you?" | ✅ Yes, folded into step 6 rather than being its own step — same screen |

**Verified correct:**
- Names remain optional and skippable at every point (`onSkip`/`skipLabel` wired correctly in `study_profile_screen.dart`).
- Greeting updates immediately when `preferredDisplayName` changes — confirmed via `AnimatedBuilder`/`ValueListenableBuilder` wrapping in `home_shell.dart` and `profile_screen.dart`, no stale-read sites found.
- Multiple learner profiles: the data model and switcher UI both work correctly when reachable (see P0-2 below for when it's *not* reachable).
- No cached/incorrect greetings: `greetingFor()` never interpolates an empty name; every consumer is listener-wrapped.

**Verified broken / inconsistent — see numbered findings below**: no persisted "onboarding complete" state (P0-1), a parent/teacher who skips the learner-name field can never add a learner afterward (P0-2), Stage/Goal selection screens don't restore prior choice on Back (P2-1, contrast with the Accessibility step which does restore correctly), and Create-Account's own "Name" field duplicates "What should we call you?" for a user who does both (P2-2, though it's guarded against overwriting).

---

## Home audit

**"What should I do next?" — partially answered.** Home has 22 distinct widgets/cards (full inventory in the journey map). It answers "what can I do" (many entry points to Practice/Topics/Formulas/Journey/Exam Packs) but not "what should I do *next*" in a prioritized sense — there's no single ranked recommendation.

| Spec element | Status |
|---|---|
| Localized greeting | ✅ Works correctly, time-of-day + name aware (this session's work) |
| Today's Goal | ❌ Doesn't exist on Home. A "Daily Goal" card exists but lives on the **Journey** tab, not Home, and its value is **hard-coded** (`journey_screen.dart:513`, `7/15` never changes) — see P0-3. |
| Continue Learning | ⚠️ Exists (`_ContinueLearningCard`) but its topic and progress bar are **hard-coded** (a fixed `Map` lookup + constant `0.35`, `home_shell.dart:995-1071`) — doesn't reflect real activity. |
| Review Due | ❌ Doesn't exist. No spaced-repetition/review-scheduling concept anywhere in the codebase. |
| Exam Countdown | ❌ Doesn't exist. |
| Progress summary | ⚠️ A "Progress" section label links to Journey, but Journey itself has multiple fabricated static numbers (P0-3). |
| Quick Actions | ⚠️ Exists in spirit (Start Practice button, topic cards) but several are non-functional taps (see P1-3). |
| Allie recommendation card | ❌ Doesn't exist — no "Allie" feature exists at all yet (roadmap item, not a defect). |

---

## Practice audit

| Check | Status |
|---|---|
| No repetitive navigation | ✅ Reasonable — Setup → Session → Summary → back to Setup, single loop |
| Scroll resets on new question | ❌ **Confirmed broken.** `_SessionView`'s question `SingleChildScrollView` has no key/controller; Flutter reuses the same `Scrollable` element across questions, so scroll offset carries over (`practice_screen.dart:1036-1194`). This is P1-2 below and is exactly the defect Prompt 1 is scoped to fix — flagging here confirms it's real and present today. |
| Back navigation | ✅ Works — `PopScope` + in-content Exit control both show a confirmation dialog before discarding progress |
| No dead ends | ✅ Confirmed — every screen either has an explicit close/back control or relies on the platform default correctly |
| Learner-controlled practice | ❌ **Doesn't exist yet** — Setup only offers stage + a fixed 4-mode picker + question count. No topic/subskill/difficulty selection (this is Prompt 2's entire charter, correctly not started). |
| Adaptive sequencing hooks | ❌ None found — questions are shuffled from a stage pack, no reason-code/ranking system exists (also Prompt 2 scope). |

---

## Learn audit

There is **no unified "Learn" tab or IA concept** — content is scattered:

| Spec item | Status |
|---|---|
| Formula Library | ✅ Exists, real, its own top-level nav destination — but collapses into the phone "More" sheet (buried one tap deeper than Home/Topics/Practice/Journey on phone width). |
| Worked Examples | ❌ Doesn't exist as a named feature. The nearest equivalent is a plain-text "explanation" shown after checking a practice answer — correctly gated to only appear post-submission, but with no Show/Hide toggle, no scroll-to-solution, no accessibility labeling (Prompt 3 scope). |
| Flashcards | ❌ Doesn't exist (zero matches anywhere). |
| Strategy Guides | ❌ Doesn't exist. |
| Common Mistakes | ❌ Doesn't exist as a working feature — only appears as locked "coming soon" marketing copy on the Explore screen ("Examiner Intelligence"). |

---

## Exam audit

| Spec item | Status |
|---|---|
| Exam Packs | ⚠️ Exists (`/packs`) but is a curriculum-stage picker, not a packs/mocks library — most items route to `/upgrade` (Premium) or are marked "coming soon." Also **doesn't participate in the app's responsive layout system** (P1-4 — no `AppResponsive.contentMaxWidth` cap, unlike every other pushed screen). |
| Previous Results | ⚠️ Exists, but **only for a parent/teacher**, PIN-gated, three taps deep (Profile → Settings → Parent Tools PIN → Cheat Sheet). No learner-facing equivalent. |
| Review Mistakes | ⚠️ Same as above — the Parent Cheat Sheet has a working, well-built per-question reveal/hide UI, but it's unlabeled as an "appendix," not reachable from the exam/practice flow itself, and invisible to the learner. |
| Readiness | ❌ Doesn't exist anywhere. |

**Positive finding worth highlighting**: the Parent Cheat Sheet (`parent_cheat_sheet_screen.dart`) is, functionally, already a correctly-gated seed of the "Parent Solution Appendix" the roadmap calls for in Prompt 4 — answers default to hidden, PDF export is real and working (`parent_report_service.dart`, `package:pdf` + `package:printing`), and it's PIN-protected. Prompt 4 should extend/rename this rather than build a parallel feature.

---

## Progress audit

"Progress" and "Journey" are **the same screen** — there is no separate `/progress` route; the nav tab is uniformly "Journey."

| Spec item | Status |
|---|---|
| Mastery | ❌ No per-topic mastery/proficiency breakdown exists anywhere. |
| Consistency | ⚠️ Streak exists and is *mostly* real (`StreakService`), but the Journey screen's own "This Week" stat and one of its two streak displays are **hard-coded fake values** — see P0-3. |
| Journey | ✅ The `_MathsJourneyCard` itself is real and correctly name-aware (this session's work). |
| Achievements | ⚠️ Three badge chips exist but are **entirely static** — "unlocked," sublabels, and progress are hard-coded, not computed from real session data. |
| Review schedule | ❌ Doesn't exist — no spaced-repetition/due-for-review logic anywhere. |

---

## Profile audit

| Spec item | Status |
|---|---|
| Preferred display name | ✅ Works correctly (this session's work) |
| Greeting preview | ✅ Works correctly, live-updates (this session's work) |
| Accessibility | ✅ Real screen, and — verified this pass — text scale is genuinely applied app-wide via a `TextScaler` override in `main.dart`'s `MaterialApp.builder`. Reduce Motion, however, is only consumed by one thing (confetti) — everything else ignores it, see P1-8. |
| Parent Mode | ⚠️ No screen/toggle literally named "Parent Mode" exists. Role-gated behavior is scattered: a "Switch Learner" row on Profile (parent/teacher only), and a completely separate PIN-gated "Parent & Teacher Tools" flow reached via Settings. These aren't wrong, but they aren't a coherent "mode" either — see P1-9. |
| Teacher Mode | ❌ Same PIN-gated flow as Parent Mode — no teacher-specific content exists (expected, roadmap scope). |
| Learning Passport | ❌ **Does not exist anywhere in the codebase.** This term appears only in recent product requests, with no corresponding screen/service. Needs to be defined (most likely: the existing `OnboardingProfileService` + `LocalPreferencesService` combo, renamed/reframed) before Prompt 6 references it. |
| Export | ⚠️ Only one real export exists (the Parent Cheat Sheet PDF). `privacy_data_screen.dart`'s "Request Data Deletion" button is a **literal no-op** — see P0-6. |
| Privacy | ⚠️ The privacy screen is otherwise honest/informational, but the one actionable control on it does nothing when tapped. |

---

## UI audit

| Spec item | Status |
|---|---|
| Light theme | ❌ Doesn't exist |
| Dark theme | ✅ Exists (the only theme) |
| System theme | ❌ Doesn't exist |

Confirmed with certainty: `main.dart`'s `_buildTheme()` constructs one hard-coded `ThemeData(brightness: Brightness.dark, ...)`; `grep -rn "ThemeMode" lib/` returns **zero hits** anywhere in the app; `appearance_screen.dart`'s own copy self-documents this as an intentional v1 decision ("Math Intelligence currently uses our optimized Dark Theme... Future themes may be introduced in later releases," `appearance_screen.dart:72-75`) with a non-functional single `_ThemeOption`. **This is not a bug — it's Prompt 1's job, correctly untouched so far.**

**Also found**: `lib/app.dart` defines a second, entirely unused, dead `MathTutorAppShell`/`ThemeData` — never imported by `main.dart`. Dead code, not a live risk, but worth removing when Prompt 1 touches theming (P2-3).

**Responsive layout**: phone/tablet-portrait/tablet-landscape adaptation works correctly for every screen that lives inside `AppShell` (all 8 nav branches — they get `NavigationRail` + centered max-width for free). It does **not** work for `ExamPacksScreen`, the one pushed-above-shell screen that skips the shared layout system entirely (P1-4).

---

## Accessibility audit

| Spec item | Status |
|---|---|
| Reduce Motion | ⚠️ Preference is correctly persisted and correctly *settable* from both the new onboarding step and Settings, but only **one** animation in the entire app actually checks it (`reward_confetti.dart:35`). Every other `AnimatedContainer`/transition ignores the flag. |
| Text scaling | ✅ Genuinely applied app-wide via `main.dart`'s `MaterialApp.builder` `TextScaler` override — confirmed, not just stored-and-ignored. |
| Semantic labels | ❌ **Nearly absent.** Only 2 `Semantics(...)` call sites exist in the entire `lib/` tree (splash screen, one graph widget). `semanticLabel` has zero hits anywhere. Icon-only tap targets throughout Home and Practice have no explicit accessible label. |
| Screen reader order | ⚠️ Not independently verifiable without a screen reader pass, but given the near-total absence of `Semantics`, default reading order is whatever widget-tree order produces — untested, likely to have gaps around icon-only controls. |

---

## Mathematics audit

**Contract rule**: never display `^2`, `sqrt()`, `>=`, `<=` to a learner; use `²`, `√`, `≤`, `≥`, `×`, `÷`, fractions, proper units.

- `sqrt(`, `>=`, `<=`: **zero occurrences** anywhere in learner-facing content. Clean.
- `^` used as a raw exponent operator in learner-facing text: **massive volume** — over 15,000 occurrences in `"question"` fields alone across the en-GB question-bank JSONL packs (`assets/packs/en-GB/*.jsonl`), plus thousands more in `"options"` and `"rationale"`. Example: `"question":"Evaluate 5x^2 - 1x + 14 when x = 6."` (`KS4_bank_ok_2000_A.jsonl:5`).
- Bare `*` for multiplication shown to learners: **7,500+ occurrences**, almost all inside answer `"options"` arrays, e.g. `"options":["x^2 -1*x +2", ...]`.
- Bare `/` where a fraction should render: **11,000+ occurrences** in options, e.g. `"options":["(y +11)/(6)", ...]`.
- **The hand-authored content is clean** — `formula_catalog.json`, `daily_brain_teasers.json`, `mental_math_tricks.json` all consistently use proper Unicode glyphs (`×`, `²`, `³`, `½`, `π`) with zero violations. The problem is isolated entirely to the machine-generated/imported question-bank packs that feed Practice and Exam Simulator.
- No shared math-rendering utility is wired to question content. `flutter_math_fork` **is** a dependency and **does** work correctly (used for one graph-caption LaTeX render), so the plumbing risk for Prompt 3 is low — it's an integration task, not a new-capability task.

**This is a real, current, high-volume contract violation** — see P0-4 for the scoped stopgap fix and why full remediation is intentionally left to Prompt 3.

---

## Findings — consolidated, classified

### P0 — blocks further work, fixed in this session before Prompt 1

**P0-1. No persisted "onboarding complete" state — every cold launch and every sign-out replays full onboarding.**
`app_splash_screen.dart`'s `_continue()` unconditionally calls `context.go('/onboarding')`; no `redirect:` logic in `router.dart` checks prior completion; no such flag exists anywhere in `OnboardingProfileService`. Directly violates the V1 acceptance criterion "resume learning at any time." This is the single most consequential gap found across the entire audit — it affects the "return after 30 days" journey, the "sign out" journey, and simple app-restart.

**P0-2. Parent/Teacher who skip the optional learner-name field have no way to ever add a learner.**
`who_is_learning_sheet.dart` (the only "+ Add Learner" affordance) is only reachable when `LearnerProfilesService.profiles` is already non-empty (`home_shell.dart:845`, `profile_screen.dart:531-532`) — precisely the state a user who correctly used the "optional, skippable" field finds themselves in. A legitimate, encouraged path (skip the optional field) leads to a permanent dead end for a core feature (multi-learner support).

**P0-3. Journey/Progress screen displays fabricated static numbers as if they were real.**
`journey_screen.dart`: "This Week" stat hard-coded `1/5` (line 61), one streak display hard-coded `'1'` (line 51, while a *different* card on the same screen correctly reads the live `StreakService`), the "Ten Questions" achievement sublabel hard-coded `'4 / 10'`, and the Daily Goal hard-coded `7/15` (line 513) — none derived from real session/streak data. Showing fake progress numbers is a trust violation, not a cosmetic gap: a user with zero real activity sees the same "4/10 questions" as a user with 500 real sessions.

**P0-4. Question-bank content violates the "never display `^2`" rule at massive scale (15,000+ instances).**
Full remediation (structured worked solutions, proper fraction typesetting, a validated solution-template registry) is explicitly Prompt 3's charter and should not be pulled forward wholesale here. This audit implements a narrow, safe, **display-layer-only** stopgap: a `MathNotationFormatter` that rewrites `digit^digit` exponent patterns to Unicode superscripts and bare `*` to `×` at render time in Practice's question/option/explanation text, without touching the underlying question-bank data. This resolves the two highest-confidence, highest-volume, explicitly-named violations (`^` and `*`) immediately; proper fraction rendering (`/`) is deliberately left to Prompt 3 since blanket-replacing `/` is not safe without more context than a stopgap formatter can reliably apply.

**P0-5. Subscription screen presents a fake, non-functional purchase button.**
`/profile/subscription` shows "Subscribe — £4.99 / month" with `onPressed: () {}` — a literal no-op styled as a live paywall, materially more misleading than the honestly-labeled "Coming Soon" `/upgrade` screen that already exists. A user could reasonably believe they subscribed.

**P0-6. Privacy & Data screen's "Request Data Deletion" button is a no-op.**
A trust/legal-sensitive action does nothing when tapped, with no error and no explanation. Since this is a local-only app with no server/cloud sync (the screen's own copy says so), the correct, fully achievable fix is to make this button actually clear all locally persisted app data, with a confirmation dialog.

### P1 — real UX/architecture issues, fix during Prompt 1 (not blocking, tracked here so they aren't lost)

1. Practice question view doesn't reset scroll position between questions (`practice_screen.dart:1036-1194`) — exactly the defect Prompt 1's requirement #4 is scoped to fix; confirmed present.
2. Home's `_ContinueLearningCard` and three `_TopicRowCard`s show hard-coded fake progress values, and tapping a specific topic card discards which topic was tapped (routes to generic `/practice`, only a `debugPrint`).
3. Home's "Topics" section "View All" action is a literal no-op empty closure.
4. `ExamPacksScreen` doesn't participate in the shared responsive layout system — will stretch edge-to-edge on tablet/desktop unlike every other screen.
5. Two redundant, inconsistent upgrade/subscription screens (`/upgrade` honest placeholder vs. `/profile/subscription`, fixed in P0-5 to stop lying but still architecturally duplicated) — should be consolidated into one screen.
6. "AI Tutor" branding overstates a fully deterministic, local feature — copy-only fix, low effort, worth doing alongside Prompt 1 or 2.
7. Multi-learner switching only re-scopes the greeting name; Streak, Mascot fuel/daily mission, and Session History are global per-device, not per-learner — a parent switching between two children sees mixed data.
8. Reduce Motion preference is only consumed by one animation (confetti) app-wide; everything else ignores it.
9. "Parent Mode"/"Teacher Mode" don't exist as coherent named surfaces — role-gated behavior is split across a Profile row and a separately PIN-gated Settings flow.
10. `Settings` screen (`/profile/settings`) contains only 2 of the ~9 things a user would expect under "Settings" — the rest are top-level Profile rows. Naming/IA inconsistency.
11. Stage/Goal onboarding screens don't restore prior selection on Back (contrast with the Accessibility step, which does).
12. Sign Out doesn't clear role/goal/learner data but does force a full onboarding replay with no pre-fill of the retained data.
13. No "Optional notifications" onboarding step exists, per the current product spec.

### P2 — polish, expected roadmap gaps, hygiene

1. Stage/Goal Back-navigation doesn't restore prior choice (see P1-11 — duplicated here as it's borderline; treat as P1 if touched during Prompt 1, P2 otherwise).
2. `CreateAccountScreen`'s own "Name" field duplicates the onboarding "What should we call you?" question for a user who does both (already guarded against overwriting, just redundant).
3. Dead/orphaned unregistered screens exist in the tree (`GrowthScreen`, `weakness_screen.dart`, `skills_screen.dart`, `admin_console_screen.dart`, `subscription_success_screen.dart`, `welcome_screen.dart`, a **duplicate** `lib/screens/home_shell.dart` sitting alongside the real `lib/screens/home/home_shell.dart`, `student_home_screen.dart`) — none reachable, but real maintenance/confusion risk (the duplicate `home_shell.dart` in particular is a landmine for a future edit going to the wrong file).
4. `lib/app.dart` defines a second, entirely unused `MathTutorAppShell` — dead code.
5. Home's "What's New" card dismissal is in-memory only, doesn't survive app restart.
6. Teacher "manage a class" is entirely unimplemented — expected, correctly out of scope until a future prompt.
7. "Learning Passport" term has no corresponding implementation yet — needs definition before Prompt 6.
8. Learn area (Worked Examples, Flashcards, Strategy Guides, Common Mistakes) doesn't exist — expected, Prompt 3+ scope.
9. Exam readiness/mock-exam library/learner-facing review-mistakes don't exist — expected, Prompt 4/5 scope.

---

## What was fixed in this session

All 6 P0 items above were resolved before any further roadmap work — see git history for this commit. P1 and P2 items are intentionally **not** fixed here; they're tracked for their correct roadmap slot (mostly Prompt 1) so this audit doesn't silently expand into a full implementation pass.
