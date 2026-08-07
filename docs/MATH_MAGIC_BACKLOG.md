# Math & Magic — Remaining Backlog

Status: reference document, not a build plan. Records what was deliberately
left out of the RC1-minimum content ship (see `docs/RC1_FEATURE_FREEZE.md`
§8, 2026-08-02) so it isn't lost or silently re-discovered later. None of
this is scheduled — it requires its own future decision, same as the
original "in development" state did.

## What shipped (the RC1 minimum)

4 real, self-contained interactive activities, reachable from the Math &
Magic hub (`/math-studio/math-magic`). Every one is untimed and unscored —
no points, no streaks, no countdown, no leaderboard — matching the
brief's explicit "no scoring, no timed mode, no gamification, focus on
curiosity":

- **Visual Number Tricks** (`/math-studio/math-magic/number-tricks`) —
  the classic "1089 trick" (pick a 3-digit number, reverse it, subtract,
  reverse the difference, add — always 1089), computed live from
  whichever digits the learner picks via 3 steppers, not a canned example.
- **Patterns** (`/math-studio/math-magic/patterns`) — triangular and
  square numbers, grown step by step as a dot diagram with the formula
  shown alongside.
- **Magic Squares** (`/math-studio/math-magic/magic-squares`) — place
  1–9 into a 3×3 grid so every row/column/diagonal sums to 15, tap-to-place
  (no drag gesture required), with a "show me a solution" reveal.
- **Parity** (`/math-studio/math-magic/parity`) — pick two numbers,
  predict odd/even for their sum, then check — a one-off guess-and-reveal,
  not a tracked quiz.

## Explicitly deferred

- **Impossible Shapes** — one of the brief's own named examples,
  deliberately **not** shipped this pass. A correct Penrose
  triangle/impossible-staircase illusion depends on exact vertex geometry
  and paint order that this environment has no way to visually render and
  check before shipping; rather than risk a subtly-wrong or confusing
  "impossible shape," it was swapped for Patterns (also brief-named) and
  left as real, tracked backlog — build it once it can be visually
  reviewed on a real device/browser, not guessed at from code alone.
- **Curious Proofs** — the brief's other named example not covered this
  pass. A "proof" aimed at the app's age range needs careful mathematical
  and pedagogical review to avoid presenting something misleading or
  over-simplified; higher-risk content-authoring work than the other 4,
  better done as its own deliberate pass.
- **More number tricks** — only the 1089 trick is covered; other classic
  tricks (multiply-by-11 patterns, digital-root tricks, the "think of a
  number" family) are natural additions using the same
  `NumberTricksScreen` step-reveal pattern.
- **Larger/different magic squares** — only the one 3×3 (sum-15) square is
  covered; 4×4 magic squares, or a "generate a new random target sum" mode,
  are additive content work on the same interaction model.
- **More pattern types** — only triangular and square numbers are
  covered; other classic visual sequences (Fibonacci spirals, pentagonal
  numbers, staircase/odd-number sums) would extend `PatternsScreen`'s
  existing `_PatternKind` switch.
- **Progress tracking / analytics** — none of the 4 activities record
  attempts or completions (matching Spatial Intelligence's identical
  choice, see `docs/SPATIAL_INTELLIGENCE_BACKLOG.md`) — presentation-only,
  not wired into any tracking service. Wiring this in is a distinct,
  larger decision, not an implicit side effect of a content sprint.
- **Localisation beyond the 5 production locales** — the 8 new ARB keys
  were added to `en`, `en-GB`, `de-CH`, `fr-CH` and `it-CH` (the locales
  `test/math_studio_l10n_completeness_test.dart` enforces for
  `mathStudio*` keys), matching the same scoping decision already made
  for Spatial Intelligence's hub-level strings. All in-activity content
  (trick steps, pattern formulas, magic-square messages, parity
  explanations) is English-only, hardcoded in the 4 screen files rather
  than routed through `AppLocalizations` — full localisation of this new
  in-activity content is real remaining work, not done in this pass.
