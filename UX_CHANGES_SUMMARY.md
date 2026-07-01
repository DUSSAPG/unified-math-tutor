# UX Changes Summary — Sterling Math V1 Polish

## 1. Rebrand (display copy only)

Renamed the app's user-facing name from "MathTutor" / "Unified Math Tutor" to **Sterling Math**
across: launcher label, `MaterialApp` title, Profile screen, Sign-out dialog, Terms of Use, Release
Notes, the Parent Cheat Sheet PDF header, and legal/store-readiness docs. `applicationId`, `namespace`,
and internal Dart package/class names (`unified_math_tutor`, `UnifiedMathTutorApp`) were deliberately
**left unchanged** — renaming those would make Google Play treat it as a new app, breaking upgrades
for anyone on the existing internal-testing track.

## 2. Welcome Screen

New headline: *"Helping every learner build confidence in mathematics."* Student and Parent-or-Teacher
choice cards now carry the sprint's exact copy. Added two new actions that didn't exist before:
**Sign In** (links to the existing `/auth/sign-in` route) and **Guest Mode** ("Try a limited practice
session" → jumps straight into a Quick Start practice session, bypassing onboarding entirely).

## 3. Student Onboarding

Previously, selecting "Student" or "Parent/Guardian" led through an identical 3-step flow
(stage → goal → profile-with-email), and none of the selections were ever persisted. Now:

- **Students** get a distinct flow: new Step 1 "Welcome" screen → Step 2 "Choose your level"
  (unchanged KS2–KS5 picker) → Step 3 goal picker, now offering **Build confidence / Improve school
  maths / Prepare for exams / Challenge myself** (replacing the old School Support / Exam Ready /
  Oxford Track set). The final step's button reads "Start Learning" and goes straight home.
- The chosen level is now actually saved via `CurriculumService.select(...)` (previously it was
  captured in local widget state and silently discarded).
- The chosen goal is persisted via the new `OnboardingProfileService` for future recommendations.

## 4. Parent / Teacher Onboarding

Per the brief, this flow was **kept exactly as it exists today** — same stage → goal → profile-with-
email steps, same PIN/rewards/progress-report infrastructure — only the entry label changed from
"I'm a parent/guardian" to **"I'm a Parent or Teacher"**, with an updated subtitle. The study-profile
screen now also persists the selected level and the optional parent email (both were previously
collected but discarded).

## 5. Dark Theme Only

Confirmed the app already ships dark-only (no `darkTheme`/`themeMode` ever existed in `main.dart`).
The Appearance screen's Light/System swatches — which never did anything — were removed and replaced
with a single non-interactive "Dark" card and the sprint's exact copy: *"Sterling Math currently uses
our optimized Dark Theme to improve focus and readability. Future themes may be introduced in later
releases."*

## 6. Accessibility Simplification

"Text Size" → **"Reading Size"** (Small / Default / Large — unchanged options, functional text
scaling already wired to a global `MediaQuery` wrapper). **High Contrast was removed** — it was a
non-functional toggle with no real implementation behind it, so it no longer appears at all (per the
"no placeholder controls" instruction). Reduce Motion is unchanged.

## 7. Practice Mode Fixes

- **Topic Drill** previously ignored the chosen topic entirely and loaded generic stage questions.
  It now filters the pack's questions by the selected topic before starting a session, and shows a
  clear message if a topic/stage combination has no matching questions yet.
- **Timed Challenge** now correctly pauses its countdown when the app is backgrounded
  (`WidgetsBindingObserver`) and resumes from where it left off on return, instead of continuing to
  tick down (or losing state) while the app wasn't visible.
- **Exam Simulator** previously let you start a "mock test" without specifying which exam it was
  modeled on. It now requires selecting one of GCSE Foundation, GCSE Higher, Oxford Track, or Swiss
  Gymnasium before "Start Practice" enables; Oxford Track and Swiss Gymnasium are shown locked
  (tapping routes to the upgrade screen) since there's no real content behind them yet.

## 8. Formula Library (new)

A free, offline, searchable reference of 30 formulas across 11 categories (Area, Volume, Fractions,
Percentages, Algebra, Pythagoras, Circle, Trigonometry, Coordinate Geometry, Probability, Statistics).
Reachable from a new card on the Home screen. English-only for v1, JSON-backed, no AI/Tutor
dependency. See `FORMULA_LIBRARY_PLAN.md` for the content/architecture details.

## What Was Deliberately Not Touched

No bottom-navigation restructuring, no new authentication backend, no per-market `applicationId`
flavors, no Teacher-specific dashboard beyond the label rename — all per the brief's instruction to
avoid redesigning architecture or adding major new features.
