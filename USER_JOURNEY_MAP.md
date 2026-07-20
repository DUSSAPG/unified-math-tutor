# Math Intelligence V1 — User Journey Map

Date: 2026-07-20. Documents the **implemented** experience as of this commit — not the intended
design. No application code changes were made while producing this document (its companion,
[UX_ARCHITECTURE_AUDIT.md](UX_ARCHITECTURE_AUDIT.md), lists the P0 fixes applied separately,
*after* this map was drafted from the pre-fix codebase; see the note at the end of each journey
where a P0 fix changes the journey's outcome).

---

## 1. Learner journey

**Goals**: start learning quickly, understand what to do next, feel progress is real and mine.

**Entry points**: cold app launch (always via Splash → onboarding, see §6), "I'm learning" role choice, Guest Mode from the role screen, a deep re-entry via Sign In.

**Decision points**: role choice → curriculum stage → goal → accessibility prefs → optional name/save-progress → land on Home.

**Screens visited (happy path)**: Splash → Role (`/onboarding`) → Stage (`/onboarding/stage`) → Goal (`/onboarding/goal`) → Accessibility (`/onboarding/accessibility`) → Save Progress (`/onboarding/profile`) → Home (`/home`) → Practice Setup → Practice Session → Practice Summary.

**Primary actions**: pick a mode (Quick Start/Topic Drill/Timed Challenge/Exam Simulator), answer questions, check answer, read explanation, finish session.

**Possible exits**: skip the name step entirely and land on Home as an unnamed learner; exit a session mid-way (confirmed via dialog, no silent progress loss); leave the app at any point (see §6, "return after 30 days" — currently forces a full onboarding replay, **P0-1**, fixed this session).

**Recovery paths**: mid-session exit → confirmation dialog → returns to Setup, no crash; empty question pool for Quick Start/other non-topic-drill modes → **fails silently**, no message, user just stuck on Setup not knowing why (friction point, not previously flagged as P0 since it requires an edge-case empty pack, noted here for future attention).

**Success criteria**: reach Home, start and complete at least one practice session, see an accurate summary.

**Navigation paths**: bottom nav (Home/Topics/Practice/Journey + More on phone, full rail on tablet/desktop) — each tab keeps its own back-stack.

**Emotion**: mildly efficient during onboarding (short, skippable, low-friction) → **undermined on Home**, where several cards show numbers that look like personal progress but are actually hard-coded (Continue Learning's 0.35 progress bar, three Topic cards' fixed 0.55/0.28/0.12) — a first-time user with zero history sees the exact same numbers as a returning user, which reads as fake once noticed. Practice itself feels solid — clear question flow, real accuracy at the end, a real confirmation before losing progress.

**Friction**:
- Tapping any Topic card on Home doesn't actually take you to that topic (routes to generic Practice, topic argument silently dropped) — expectation mismatch.
- Scroll position doesn't reset between questions (**P1**, tracked for Prompt 1) — a learner who scrolls down on a long question can find the next, shorter question rendered mid-scroll.
- No way to see *why* a recommendation is what it is, because no recommendation surface exists yet (Prompt 2 scope).
- "View All" under Topics on Home does nothing.

**Improvement suggestions**: wire Continue Learning / Topic cards to real `SessionHistoryService` data or honestly show a zero/empty state; pass the tapped topic through to Practice; fix scroll reset (already scheduled for Prompt 1); remove or wire the dead "View All" action.

**Dead ends found**: none that trap the learner permanently (P0/P1 items above are friction/honesty issues, not traps) — with one exception fixed this session: cold-launch/return-after-gap always replaying onboarding effectively **discards forward progress from the learner's perspective** even though data was safe underneath (P0-1, fixed).

---

## 2. Parent / Supporting-a-learner journey

**Goals**: set up a learner (or several), understand how to help, see progress, keep exam answers protected until appropriate.

**Entry points**: same role screen, "I'm supporting a learner."

**Decision points**: role → stage (for the learner) → goal (support-focused options) → accessibility → save progress (own name, **learner's name — optional**, relationship, parent email) → Home.

**Screens visited (happy path)**: same onboarding chain as Learner, then Home (parent variant: shows a "Learning as {name} · Switch" pill), Profile → Switch Learner sheet, Settings → Enable Parent Tools → Unlock Parent Tools (PIN) → Parent Cheat Sheet (review mistakes, export PDF).

**Primary actions**: add/switch learners, review a learner's session history, export a PDF summary.

**Possible exits**: skip the learner-name field (very plausible, it's explicitly optional and the field is framed as low-friction) → **confirmed dead end before this session's fix**: the only "+ Add Learner" affordance was gated behind an already-non-empty learner list, so a parent who correctly used the optional/skippable field had no way to ever add a learner (**P0-2, fixed this session** — the affordance is now always reachable for parent/teacher roles).

**Recovery paths**: previously none for the above; now recoverable via the always-visible "Add Learner" entry point.

**Success criteria**: at least one learner profile exists and is nameable/switchable; parent can find and review a learner's mistakes; parent can export a PDF.

**Navigation paths**: Home pill → sheet; Profile → "Switch Learner" row → same sheet; Settings → PIN gate → Cheat Sheet (three taps deep from Profile, not discoverable from Practice/Exam directly).

**Emotion**: reassuring in principle (a real PIN gate, a real hide/reveal-by-default answer view, a real PDF export) — but **buried**. Nothing in the exam or practice flow itself hints that this feature exists; a parent has to already know to go Profile → Settings → enable a toggle → unlock a PIN → find the cheat sheet.

**Friction**:
- The feature that most closely matches "Parent Solution Appendix" isn't labeled as such anywhere in the UI — it's called "Parent Cheat Sheet," reachable only via "Parent & Teacher Tools," itself buried in Settings.
- Multi-learner switching only changes the displayed name — Streak, Mascot fuel, and Session History are **not** learner-scoped (global per device), so switching from one child to another doesn't actually show that child's own progress underneath the correct name (**P1**, tracked, not fixed this session — requires a broader per-learner data-scoping change across three services, appropriately scoped to a future prompt rather than a P0 stopgap).
- "Request Data Deletion" on the Privacy screen did nothing when tapped (**P0-6, fixed this session** — now genuinely clears all local app data with a confirmation dialog).

**Improvement suggestions**: surface a "Review with your learner" or "Parent tools" entry point directly from the Exam/Practice summary screens, not only from Settings; rename/re-badge the Cheat Sheet as the Parent Solution Appendix per the roadmap; scope Streak/Fuel/History per learner (Prompt 2/4/5 candidate work).

**Dead ends found**: the learner-add dead end (P0-2, fixed). No other permanent traps found.

---

## 3. Teacher journey

**Goals**: (per the current spec) monitor progress, assign practice, review assignments/mocks, protect active assessments.

**Reality check**: **almost none of this exists.** Teacher shares the exact same single/multi-"learner" model as Parent (`LearnerProfilesService` doesn't distinguish student-of-a-parent from student-of-a-teacher), the same PIN-gated tools screen, and the same Cheat Sheet. There is no class/roster/cohort concept anywhere in the codebase (confirmed by broad grep for "roster," "cohort," "students," "Classroom"). The four teacher-specific onboarding goals (`Monitor class progress`, `Assign practice`, `Prepare for exams`, `Explore the curriculum`) are persisted as a string but nothing downstream reads or branches on them.

**Entry points / screens visited**: identical to the Parent journey above, since the app makes no functional distinction post-onboarding.

**Success criteria**: cannot currently be met beyond "one teacher, one learner profile, same tools a parent gets."

**Emotion**: the role selection itself (being asked "I'm a teacher" and given teacher-specific goal copy) sets an expectation of a genuinely different experience that the rest of the app doesn't deliver — a mild bait-and-switch, though an honest one (the app never claims class management exists elsewhere).

**Improvement suggestions**: this is squarely Prompt 5 scope (Exam Packs/subscriptions/full role integration) — no fix attempted in this session, correctly deferred.

---

## 4. Guest journey

**Goals**: try the app with zero commitment.

**Entry points**: "Guest Mode" button on the role screen, which is available *before* any role/stage/goal/accessibility selection.

**Screens visited**: Role screen → Practice (auto-started, Quick Start mode) directly. No onboarding steps run at all.

**Primary actions**: answer questions in a single quick-start session.

**Possible exits**: close the app (no persisted "guest" flag exists — guest-ness is simply inferred from not being signed in); navigate to Profile, which shows "You're browsing as a guest" with Sign In / Create Account buttons.

**Recovery paths**: fully recoverable — nothing about Guest Mode traps the user; they can navigate anywhere else in the app freely (Guest is not sandboxed to Practice only).

**Success criteria**: complete one practice session without being forced to create an account.

**Emotion**: frictionless and genuinely respects "try before you commit" — no nag screens, no forced sign-up interruptions anywhere in the learning flow itself.

**Friction**: entirely **passive** — nothing ever actively invites a guest to convert. A guest who never opens Profile has no prompt, ever, to create an account. This is a legitimate product trade-off (respects privacy/anonymous-use principles from the Identity contract), not a bug — flagged here as a conversion-funnel observation, not a defect.

---

## 5. Role transitions

**Guest → Learner**: works passively (see §4). No active/guided transition exists.

**Learner → paid Subscriber**: **not implemented.** Two inconsistent, non-functional screens existed (`/upgrade`, honestly labeled "Coming Soon"; `/profile/subscription`, which showed a fake, clickable-looking "Subscribe — £4.99/month" button that did nothing — **P0-5, fixed this session** to stop presenting as a working purchase flow). No entitlement/purchase backend exists anywhere. Full remediation (real subscription tiers, entitlement gating) is Prompt 5 scope.

**Parent adds another learner**: works correctly via `LearnerProfilesService.addLearner`, reachable from the Home pill and Profile's "Switch Learner" row — **provided at least one learner already exists**. Before this session's fix, a parent with zero learners had no way to reach this UI at all (P0-2, fixed — the entry point is now always shown for parent/teacher roles).

**Teacher manages a class**: does not exist (§3). Correctly out of scope for this pass.

---

## 6. Home screen — every state

| State | Behavior |
|---|---|
| **Morning** (05:00–11:59) | `homeGreetingMorningNamed`/`Default` — verified correct via `greeting_service.dart` bucket logic. |
| **Afternoon** (12:00–17:59) | `homeGreetingAfternoonNamed`/`Default` — correct. |
| **Evening** (18:00–22:59) | `homeGreetingEveningNamed`/`Default` — correct. |
| **Night / "Welcome back"** (23:00–04:59) | `homeGreetingNightNamed`/`Default` ("Welcome back[, name]") — correct, and the only state that uses "Welcome back" phrasing; there is no separate "long time no see" detection (confirmed — `StreakService` tracks only consecutive-day count, no last-seen timestamp exists anywhere in the codebase). |
| **Named user** | Shows `preferredDisplayName` (student) or the active learner's name (parent/teacher) — correct, live-updating. |
| **Anonymous/guest user** | Falls back to the un-named greeting variant, never interpolates a blank name — correct. |
| **Multiple learner account, ≥1 learner** | Shows a "Learning as {name} · Switch" pill; switching correctly updates the greeting and the Journey card title immediately. Does **not** re-scope Streak/Fuel/History (P1, tracked, not fixed). |
| **Multiple learner account, 0 learners (parent/teacher who skipped the name step)** | Before this session's fix: no pill, no way to add a learner anywhere in the app (P0-2). After the fix: an "Add Learner" affordance is now shown in this state too. |

**One caveat found and left as-is (P1, not P0)**: because the greeting is computed from `DateTime.now()` at build time and only rebuilds when a listened-to notifier changes, a user sitting on Home across a period boundary (e.g. open from 11:58 to 12:02) will not see the greeting flip from morning to afternoon until something else triggers a rebuild. Minor, correctly deferred to Prompt 1 (which owns broader animation/lifecycle polish).

---

## 7. Workflow reviews

For each workflow: **Expected emotion → Potential friction → Improvement suggestion.**

**Onboarding.** Confident, quick (4 short steps + 1 optional) → Stage/Goal screens don't restore prior choice on Back, forcing needless re-selection (inconsistent with the Accessibility step, which does restore correctly) → restore selections from the persisted service value on screen init.

**Daily study (Home → Practice).** Motivated, quick-start friendly → several Home cards show numbers unconnected to real activity (see §1) → bind to real data or show an honest empty state.

**Build My Practice.** N/A — doesn't exist yet (Prompt 2 scope). Today "Practice Setup" only offers stage + 4 fixed modes + question count; no topic/subskill/difficulty picker.

**Timed Challenge.** Same engine as all other practice modes (`_SessionView`), works mechanically, no timed-specific UI issues found beyond the shared scroll-reset gap (P1).

**Exam (Exam Simulator).** Same engine again; only GCSE Foundation/Higher are unlocked, others correctly show a lock icon and route to `/upgrade`. No post-exam "Review Mistakes" or "Readiness" screen exists for the learner — only accuracy % and Close.

**Worked Solution.** Correctly never shown before submission → but once shown, has no Show/Hide toggle, no scroll-to-solution, and no accessibility labeling → all three are named requirements of Prompt 3's `WorkedSolutionPanel`; correctly deferred, not attempted here.

**Review Mistakes.** Exists only for parent/teacher (Cheat Sheet), invisible to the learner and to anyone who doesn't already know Settings → Parent Tools exists → surface an entry point from the Exam/Practice summary screen (future prompt).

**Parent Solution Appendix.** The Cheat Sheet is functionally this feature already (hide-by-default answers, PIN gate, PDF export) but unlabeled as such and undiscoverable from the exam flow → rename/re-badge in Prompt 4 rather than rebuild.

**PDF Export.** Works, real, produces a genuinely useful topic-drill + session-history summary → scoped narrowly to the Parent Cheat Sheet only; no export exists from Practice Summary, Exam Packs, or Journey → expand scope in Prompt 4/5 per the roadmap, not attempted here.

**Profile.** Calm, clear — Preferred Display Name / Greeting Preview / Switch Learner all work correctly and update live (this session's work) → "Settings" as a concept is split oddly between a 2-row `SettingsScreen` and ~7 top-level Profile rows → consolidate IA in Prompt 1.

**Settings.** Minimal, functional for what it has (2 toggles) → doesn't match user expectation of what "Settings" should contain → rename or restructure in Prompt 1.

**Accessibility.** Text size genuinely works app-wide; Reduce Motion is honestly presented as a toggle but only suppresses confetti → wire Reduce Motion into the broader animation system in Prompt 1 (its stated charter).

**Theme changes.** Honestly self-documented as dark-only for v1 → no friction, since it doesn't pretend to offer a choice it can't deliver → Prompt 1 scope.

**Subscription upgrade.** Before this session: confusing/deceptive (a fake working paywall button) → fixed this session to stop lying; full purchase flow remains Prompt 5 scope.

**Logout.** Clear confirmation dialog, works correctly for what it clears → forces a full onboarding replay afterward with no pre-fill of retained data (role/goal/name/learners all survive in storage but aren't used to skip or pre-fill the next onboarding pass) → resolved as part of P0-1's fix (returning users, including post-sign-out, now skip straight to Home if onboarding was already completed once on this device; role/name/learner data was always safe, it's now also *used* correctly).

**Return after 30 days.** Before this session: full onboarding replay every time, regardless of elapsed time — the single most damaging journey found in this audit, since it silently discarded the "resume anytime" promise → **fixed this session (P0-1)** — a returning user with a completed onboarding record now lands directly on Home.

---

## 8. Version 1 Acceptance Report

Per the stated bar: *"Version 1 is considered complete only if: every journey can be completed; no screen is a dead end; every action has a clear next step; every recommendation explains why it exists; the learner always retains control; the application remains fully usable without AI."*

| Criterion | Status after this session's P0 fixes |
|---|---|
| Every journey can be completed | **Learner**: yes. **Parent**: yes (was blocked by P0-2, now fixed). **Teacher**: only as far as "same as parent" — class management doesn't exist, correctly deferred to a future prompt, not a P0. **Guest**: yes. |
| No screen is a dead end | The two confirmed hard dead ends (P0-2's learner-add gate, and the practical "onboarding-replay" dead end for returning users, P0-1) are fixed. No other permanent traps were found in this pass — the many broken *affordances* found (no-op buttons, discarded topic taps) are friction, not traps, and are tracked as P1/P2 for their correct roadmap slot. |
| Every action has a clear next step | Mostly yes; the exceptions found (empty Quick Start pool failing silently, "View All" no-op, topic-tap discarding its argument) are tracked as P1/P2, not blocking. |
| Every recommendation explains why it exists | N/A today — no recommendation surface exists yet (Prompt 2 territory); nothing to violate yet, nothing compliant to claim either. |
| The learner always retains control | Yes — no forced AI dependency, no forced account creation, all names/notifications optional and skippable. |
| The application remains fully usable without AI | Yes, confirmed — Tutor is fully optional and fully deterministic; no core path depends on it. |

**Overall**: the six P0 issues that would have failed this acceptance bar have been resolved in this session (see [UX_ARCHITECTURE_AUDIT.md](UX_ARCHITECTURE_AUDIT.md) for exact fixes). The P1/P2 backlog is real and non-trivial but does not, on its own, break any of the six acceptance criteria above — it represents polish and completeness gaps appropriately scoped to Prompts 1 through 5, not blockers to starting Prompt 1.
