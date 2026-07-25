# Math Intelligence RC1 — Feature Freeze

Status: **In effect** as of this checkpoint on `release/math-intelligence-rc1-foundation`.

This document is the source of truth for what is frozen, what is final for RC1, what is explicitly deferred, and how bug fixes are allowed to proceed during the polish phase. It exists so that RC1 polish work does not quietly turn back into feature development.

## 1. Frozen architecture

The following systems are architecturally frozen for RC1. They may receive targeted bug fixes (see §5) but must not be redesigned, replaced, or restructured during RC1 polish:

- Onboarding and authentication
- Persistent application navigation (the bottom-nav shell and its branches)
- Learner identity and profiles
- Question scheduler
- Anti-repetition behaviour
- ALI deterministic recommendations
- Allie learner-progress architecture
- Captain Math guided activity architecture
- Question sessions and exam simulation
- Entitlement and monetisation architecture
- Math Studio routing foundation (the `/math-studio/*` route tree itself — individual screens within it may still gain content, per §3)
- Accessibility architecture
- Localisation architecture

No new major product area may be added on top of this list without an explicit post-RC1 decision.

## 2. Final Math Studio top-level pillars

The learner-facing Math Studio hub presents exactly six pillars, in this order:

1. **Build Confidence** — gentle, untimed practice with worked explanations.
2. **Mental Maths** — daily number strategies and timed/pattern practice across 10 categories, no pressure.
3. **Visual Maths** — visual models and manipulatives (Number Line, Fraction Bars, Abacus, Place Value Explorer).
4. **Math & Magic** — recreational puzzles, number tricks and mathematical curiosities. **In development** for RC1; ships with an honest "in development" state, no placeholder content.
5. **Spatial Intelligence** — shape, space and movement (cube activities, rotations, transformations, spatial puzzles). **In development** for RC1 for that dedicated content, but offers a real, working entry point into Interactive Labs (Flight Path Lab in particular touches spatial/bearing reasoning today).
6. **Discovery Library** — real-world maths, one contextual card at a time, across 24 illustrated cards spanning shopping, cooking, sport, aviation, trucking, and healthcare.

## 3. Recall Cards and Interactive Labs as reusable formats

Recall Cards and Interactive Labs are fully-built features (routes, services, progress tracking, content, tests, accessibility, localisation, analytics hooks) that are **no longer top-level Math Studio pillars**. They continue to exist, unchanged, at their existing routes:

- Recall Cards: `/math-studio/recall-cards` (hub, browse, bookmarks, detail, review session)
- Interactive Labs: `/math-studio/interactive-labs` (hub + Fraction Builder, Algebra Balance, Number Line Explorer, Flight Path Lab, Data Detective)

They are now reachable as embedded "featured format" entry cards within the pillars where they make sense:

- **Mental Maths** → Recall Cards entry card.
- **Visual Maths** → Recall Cards and Interactive Labs entry cards.
- **Spatial Intelligence** → Interactive Labs entry card.
- **Discovery Library** → Interactive Labs entry card ("Related labs").

Nothing about either feature's routes, services, progress persistence, content, tests, accessibility semantics, localisation strings, analytics hooks, or existing deep links changed. Every cross-link that hardcodes `/math-studio/recall-cards/...` or `/math-studio/interactive-labs/...` (lab back buttons, related-links chips, Discovery Library detail cross-links, PDF export filenames) continues to resolve exactly as before.

## 4. Explicitly deferred (post-RC1)

The following are out of scope for RC1 and require an explicit post-RC1 decision before any implementation work begins:

- Unreal runtime integration
- Blender runtime integration
- VR/AR
- Multiplayer
- Unrestricted child-to-AI conversation
- Live collaborative classrooms
- Full 3D graphics engine
- Advanced quantum-computing curriculum
- Large-scale new question generation
- Broad social features

## 5. Bug-fix exception process

RC1 polish is not a feature freeze on *fixing things* — it is a freeze on *adding things* and *redesigning things*. A change to frozen architecture (§1) is permitted during RC1 polish only if all of the following hold:

1. It is a targeted, minimal fix — not a redesign, refactor, or architecture change.
2. It is accompanied by a regression test that would have caught the bug.
3. It does not expand the scope of the system it touches (no new user-facing capability).
4. It is logged in a changelog entry at the bottom of this document (date, one-line description, files touched).

Anything that doesn't meet all four criteria is post-RC1 work, regardless of how small it looks.

## 6. Definition of an RC1 release-blocking issue

An issue blocks RC1 release if it is any of:

- A crash or unhandled exception reachable from normal learner use.
- Data loss (progress, profile, entitlement, or session state).
- Incorrect scoring, progress persistence, or scheduler/anti-repetition behaviour.
- An accessibility regression (missing semantics, insufficient tap targets, colour-only signalling, overflow at any of the RC1-supported viewport sizes or at 1.6× text scale).
- A broken or dead-ended deep link.
- Localisation showing a raw ARB key, or an untranslated string in a locale where a translation is expected and gated by `test/math_studio_l10n_completeness_test.dart`.
- A navigation dead end (a screen with no way back).

Anything else is a polish-backlog item — see `docs/RC1_POLISH_PLAN.md`.

## 7. Rule: feature additions stop here

As of this checkpoint, no new learner-facing feature, pillar, or major product area may be added to `unified_math_tutor` without an explicit post-RC1 decision. This includes expanding Math & Magic or Spatial Intelligence beyond their "in development" state with real content — that is planned, tracked work, not something to slip in opportunistically during polish.

## 8. Changelog

| Date | Change | Files |
|---|---|---|
| 2026-07-25 | Initial freeze established; Math Studio hub restructured to the six pillars above; Recall Cards/Interactive Labs demoted to embedded formats within Mental Maths, Visual Maths, Spatial Intelligence and Discovery Library; Math & Magic and Spatial Intelligence added as new, honest "in development" pillars. | New: `lib/models/math_studio_pillar.dart`, `lib/widgets/shared/route_link_card.dart`, `lib/widgets/shared/in_development_feature_card.dart`, `lib/screens/math_magic/math_magic_screen.dart`, `lib/screens/spatial_intelligence/spatial_intelligence_screen.dart`, `test/math_studio_pillar_reachability_widget_test.dart`, `test/math_studio_new_pillars_test.dart`. Changed: `lib/app/router.dart` (2 additive routes), `lib/screens/math_studio/math_studio_hub_screen.dart` (registry-driven rebuild), `lib/screens/labs/interactive_labs_hub_screen.dart` (extracted to shared `RouteLinkCard`, no behaviour change), `lib/screens/mental_maths/mental_maths_hub_screen.dart`, `lib/screens/visual_maths/visual_maths_hub_screen.dart`, `lib/screens/discovery/discovery_library_screen.dart` (entry cards added), `lib/l10n/app_en.arb`/`app_en_GB.arb`/`app_de_CH.arb`/`app_fr_CH.arb`/`app_it_CH.arb` (new keys), `test/math_studio_navigation_widget_test.dart` (rewritten), `test/math_studio_l10n_completeness_test.dart` (2 cognate exemptions added). No changes to `/math-studio/recall-cards*` or `/math-studio/interactive-labs*` routes, or to `lab_scaffold.dart`, `lab_related_links.dart`, `recall_card_body.dart`, or export services. |
