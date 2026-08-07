# Release RC2 Checklist

Status: release-readiness review. **This is a documentation/audit
deliverable — no code was changed to produce it.**

## How to read this document

Every row is one of:

- **PASS** — verified by an automated check that actually ran in this
  session (a specific test file/count is cited) with no known issue.
- **WARNING** — either a known, already-documented backlog/deferred item
  (cited), or a check this sandboxed environment has no way to perform
  (real device GPU rendering, thumb-sized touch feel, battery/memory
  under sustained real use, real network latency, screen-reader behaviour
  on physical Android/iOS/browser) — genuinely unverified, not assumed
  fine.
- **FAIL** — a known, currently unresolved defect.

This environment has no physical Pixel 6a, Android tablet, or real
browser — every "PASS" below is backed by a widget-test device-size
simulation (`tester.view.physicalSize` set to the real device's logical
resolution) plus `flutter analyze`/`flutter test`, which is this
codebase's own established verification method throughout the whole RC1/
RC2 build (see `RC2_MATH_INTELLIGENCE_REVIEWER_BUILD_REPORT.md`'s 25
sections). It is **not** a substitute for an actual hands-on pass on real
hardware — every WARNING below says so explicitly, and none should be
silently upgraded to PASS without that hands-on pass. Nothing in this
document should be read as claiming physical-device verification that
did not happen.

Target matrix, per the brief: **Pixel 6a** (412×915 logical), **Android
tablet** (768×1024 / 800×1280), **Web/Desktop** (1280×800), **Landscape**
(844×390), **Portrait** (the default orientation for the first three).

## Cross-cutting checks

| Check | Pixel 6a | Tablet | Web | Landscape | Portrait | Evidence / notes |
|---|---|---|---|---|---|---|
| **Rendering (no overflow/exception)** | PASS | PASS | PASS | PASS | PASS | `test/polish_audit_overflow_sweep_test.dart` — 72 routes × these exact 4 device categories (288 combinations), 0 failures after the Production Polish Audit pass (`POLISH_AUDIT.md`) fixed the 5 real overflow bugs it found. Plus `test/lab_controls_responsive_test.dart` (7-viewport matrix incl. both Pixel 6a orientations), `test/math_studio_navigation_widget_test.dart`, `test/spatial_intelligence_activities_test.dart`, `test/math_magic_activities_test.dart`. |
| **Adaptive layouts (side panels collapse correctly)** | PASS | PASS | PASS | PASS | PASS | Interactive Labs' `LabControlBreakpoint`/`LabControlRail` system (RC2 §22) — verified for Football Precision and Flight Path Lab specifically; Recall Cards/Discovery/Family Maths grids use the same `AppResponsive` breakpoint split, covered by their own layout tests. |
| **Touch targets (≥44–48px)** | WARNING | WARNING | N/A | WARNING | WARNING | Spot-checked in code (`LabControlHandle` enforces `minWidth/minHeight: 48`, `RouteLinkCard`/chip rows use standard Material tap targets) but never measured with an actual thumb on a real screen — genuinely unverified. |
| **Contrast (Light/Dark theme)** | WARNING | WARNING | WARNING | WARNING | WARNING | `test/theme_representative_screens_test.dart` verifies both themes render without exception across 12 in-scope screens/light+dark, but does not measure actual contrast ratios. No automated WCAG contrast check exists in this repo. |
| **Animations (Reduce Motion respected)** | PASS | PASS | PASS | PASS | PASS | Every animated widget checked this session (`VisualAssetView`, lab pulse cues, `LabCollapsibleControls`'s `AnimatedSize`) reads `MediaQuery.disableAnimationsOf`/`LocalPreferencesService.reduceMotion` and has an explicit Reduce Motion test case — e.g. `visual_asset_view_widget_test.dart`, `football_precision_widget_test.dart`, `flight_path_lab` tests in `lab_controls_responsive_test.dart`. |
| **Performance (jank, frame drops)** | WARNING | WARNING | WARNING | WARNING | WARNING | Not measurable from widget tests — no real device profiler was run. `theme_representative_screens_test.dart`'s own code comment documents one known interaction risk (Maze Driver's repeating status-clock `Timer` prevents `pumpAndSettle` from ever converging in a test — worked around with bounded pumps, not a proven absence of real jank). |
| **Memory usage** | WARNING | WARNING | WARNING | WARNING | WARNING | Not measurable in this environment at all — no DevTools memory profile was captured. Flagged explicitly rather than silently skipped. |
| **Scrolling** | PASS | PASS | PASS | PASS | PASS | Every content-heavy screen (Recall Cards browse, Discovery Library, Family Maths Library, Formula Library, Math Magic/Spatial Intelligence activity screens) uses `SingleChildScrollView`/`CustomScrollView`, and the overflow sweep above pumps every one of them — a screen that couldn't actually scroll its content to fit would show as an overflow failure there, which none do. |
| **Loading states** | PASS | — | — | — | — | Every catalog-backed screen shows a `CircularProgressIndicator` while its `FutureBuilder` resolves and an explicit error icon on failure (spot-checked: Recall Cards, Discovery, Parent Recall Cards, Family Maths, Formula Library) — consistent, no bare-white-screen loading gap found anywhere audited this session. |

## Feature readiness

### Navigation

**PASS.** RC2 report §13 (independent push-site audit, ~100 call sites)
and the Production Polish Audit (`POLISH_AUDIT.md`) both specifically
targeted navigation dead ends — the one confirmed dead link found
(`/topics/:id`, no matching route) was fixed at both call sites. No
further dead links found. `CONTENT_COMPLETION_AUDIT.md`'s §9 independently
re-confirms every live `push`/`go` call site resolves to a registered
route. The only routes that don't resolve belong to the 8 confirmed-dead,
never-imported, never-routed stub screens documented in that audit's §H1
— unreachable by any user action, not a navigation defect.

### Studio (Math Studio, all 6 pillars)

| Pillar | Status | Notes |
|---|---|---|
| Build Confidence | PASS | Pre-existing, stable, not touched this session. |
| Mental Maths | PASS | Pre-existing, stable. |
| Visual Maths | PASS | Pre-existing, stable. |
| Math & Magic | PASS | RC2 §24 — 4 real activities shipped, replacing the "in development" placeholder, 23 dedicated tests, 2 real overflow bugs found and fixed pre-ship. |
| Spatial Intelligence | PASS | RC2 §23 — 4 real activities shipped, 23 dedicated tests. |
| Discovery Library | PASS | Pre-existing, stable. |

WARNING: in-activity content strings for Math & Magic and Spatial
Intelligence are English-only (not yet routed through
`AppLocalizations`) — already disclosed in
`docs/MATH_MAGIC_BACKLOG.md`/`docs/SPATIAL_INTELLIGENCE_BACKLOG.md`, not
a new finding.

### Parent Mode (Family Studio)

**PASS**, with one WARNING. 11 real sections (10 pre-existing +
Parent Recall Cards, RC2 §25), all PIN/grace-gated consistently via
`ParentGate`, all reachable and tested (`test/family_studio_hub_test.dart`
— 15 tests, one per section plus 2 overflow checks). The Parent PIN
Reminder (RC2 §21) adds a non-blocking, periodic nudge to set a PIN if
none exists, without changing the gate mechanism itself.

WARNING: the PIN-reminder's 7-day cooldown and the grace-access window's
various expiry triggers (sign-out, role change, app backgrounding) are
each unit-tested individually, but the *combination* of all of them over
a real multi-day, multi-session usage pattern has not been (and cannot
be, in this environment) exercised end-to-end on a real device.

### Interactive Labs

**PASS**, with the same touch/performance WARNINGs as the cross-cutting
section above. All 7 labs (Fraction Builder, Algebra Balance, Number
Line Explorer, Flight Path Lab, Football Precision, Maze Driver, Data
Detective) pass their own dedicated test suites plus the shared
`lab_controls_responsive_test.dart` 7-viewport matrix. RC2 §22
specifically re-verified Football Precision's and Flight Path Lab's
adaptive control-panel layout against the brief's exact device list.

WARNING (tracked, not new): Football Precision and Maze Driver are not
yet wired to the Guided Narration system the other 5 labs use — see
`VOICE_ROADMAP.md`'s priority list, item 3. Cosmetic/feature gap, not a
defect.

### Recall Cards

**PASS.** Hub, browse (with the fixed "Clear filters" empty-state
escape from the Polish Audit), bookmarks, detail, and review-session
screens all covered by existing test suites; RC2 §25 additionally
confirms the new Parent Recall Cards system is a fully separate catalog/
model/screen with zero id or taxonomy overlap with the student system
(explicitly tested, not just asserted).

### Journey

**PASS**, pre-existing and not touched this session; included here for
completeness per the brief's explicit check list. No regressions
introduced by anything in this build — confirmed by the full suite
staying green after every one of this session's changes.

## Overall test suite state

- `flutter analyze` (whole project): **No issues found.**
- `flutter test --concurrency=1` (full suite): **924/924 pass**, 0
  regressions, as of the most recent change in this build.
- Nothing in this repository is committed — every change across all 25
  RC2 report sections remains staged for your review on a physical
  device before any commit, per this session's standing instruction.

## What this checklist cannot tell you

Everything marked WARNING above is a real gap in verification, not a
soft "probably fine." Specifically outstanding before this can honestly
be called a verified production Release Candidate:

1. A hands-on pass on an actual Pixel 6a and an actual Android tablet —
   touch-target feel, real animation smoothness, real memory behaviour
   over a longer session, real screen-reader behaviour.
2. A real browser pass for Web — this environment can build for web
   (`flutter build web`, exercised in earlier sections of the RC2
   report) but has never loaded the result in an actual browser.
3. A real contrast-ratio audit of both Light and Dark themes against
   WCAG AA, not just "renders without exception in both."
4. The two items `CONTENT_COMPLETION_AUDIT.md` flagged as worth a
   product decision, not an engineering fix: whether `TutorCreditService`'s
   offline canned-response behaviour is disclosed clearly enough to the
   user, and cleaning up the 8 confirmed-dead stub screens (zero
   user-facing risk either way, but real repository hygiene debt).
