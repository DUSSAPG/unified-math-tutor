# Math Intelligence RC1 — Polish Plan

Companion to `docs/RC1_FEATURE_FREEZE.md`. That document says what's frozen and what's deferred; this document tracks what's left to do *within* the frozen scope before RC1 ships.

## Purpose and scope

In scope: bug fixes, accessibility gaps, localisation gaps, visual polish, performance, and QA passes against the frozen architecture and the six final Math Studio pillars. Out of scope: anything on the deferred list in the freeze doc, and any new pillar content beyond what's already real (adding actual Math & Magic / Spatial Intelligence content is tracked here as a checklist item but is post-RC1 scope until explicitly greenlit).

## Polish checklist

### Navigation & IA
- [x] Math Studio hub restructured to six final pillars in order (Build Confidence, Mental Maths, Visual Maths, Math & Magic, Spatial Intelligence, Discovery Library).
- [x] Recall Cards and Interactive Labs demoted from top-level tiles to embedded entry cards within relevant pillars, routes unchanged.
- [x] Every Studio screen has an obvious back action; no dead ends.
- [x] Learner returning from child content lands back on the correct originating pillar screen (go_router push/pop stack, no `.go()` replacements introduced).
- [ ] Broader IA pass once Math & Magic / Spatial Intelligence gain real content — revisit whether "Featured formats" / "Related labs" section placement still reads well with more content on the page.

### Accessibility
- [x] All interactive targets ≥ 44×44 logical pixels (inherited from the existing `RouteLinkCard`/tile sizing convention).
- [x] Semantics labels present on pillar tiles and entry cards; "in development" cards carry no interactive semantics (no `onTap`, so no false affordance).
- [x] No overflow at 320×568, 360×640, 390×844, 412×915, 600×960, 768×1024, 844×390, 1280×800.
- [x] No overflow at 1.6× text scale.
- [ ] Full manual screen-reader pass (TalkBack/VoiceOver) across the six pillars — automated semantics-tree assertions only cover presence of labels, not the full spoken experience.

### Localisation
- [x] New pillar/section/in-development strings added to `app_en.arb`, `app_en_GB.arb`, `app_de_CH.arb`, `app_fr_CH.arb`, `app_it_CH.arb` — the five locales that already carry Math Studio strings.
- [x] `test/math_studio_l10n_completeness_test.dart` passes (non-empty, non-English-identical translations for DE/FR/IT-CH).
- [ ] Consider whether Math Studio should expand to the other 15 supported locales (ar, da, de, es, fr, id, it, ko, nb, pt, sv and regional variants) — currently out of scope, matches existing convention, but worth a product decision before RC1 ships broadly.

### Visual polish
- [x] Six-pillar hub reads as calm and premium: consistent icon-chip/title/subtitle/chevron tile, consistent in-development badge styling (reuses the existing orange preview-badge language from Visual Maths/Explore).
- [ ] Design review of the two new Lucide icons chosen for Math & Magic and Spatial Intelligence against the existing palette.
- [ ] Confirm illustration/icon slot consistency once Math & Magic / Spatial Intelligence get real content (they currently use icon tiles like every other pillar, no bespoke illustration).

### Performance
- [ ] Cold-start profiling on the restructured hub (registry-driven build should be equivalent cost to the previous hardcoded literals, but not yet profiled).
- [ ] Confirm no additional asset weight from this checkpoint (no new images were added — Math & Magic/Spatial Intelligence are icon + text only).

### Content completeness
- [x] Build Confidence, Mental Maths, Visual Maths, Discovery Library: fully real content, unchanged this checkpoint.
- [ ] Math & Magic: **explicitly incomplete by design for RC1.** Ships with a single honest "in development" note. Needs product/content input before any sub-item list is added (no invented scope shipped).
- [ ] Spatial Intelligence: **explicitly incomplete by design for RC1** for dedicated spatial content (cube activities, rotations, transformations, spatial puzzles — all listed as in-development). Real, working entry point to Interactive Labs (Flight Path Lab) ships now.

### QA device/viewport matrix
Mirrors the automated test suite's coverage — manual spot-check recommended before release on at least one real device per row:
| Viewport | Class |
|---|---|
| 320×568 | Small phone, portrait |
| 360×640 | Standard phone, portrait |
| 390×844 | Modern phone, portrait |
| 412×915 | Large phone, portrait |
| 600×960 | Small tablet, portrait |
| 768×1024 | Tablet, portrait |
| 844×390 | Modern phone, landscape |
| 1280×800 | Tablet/desktop, landscape |

## Exit criteria for RC1

- All items above with a bug/accessibility/localisation/navigation impact are resolved or explicitly triaged as post-RC1 in the freeze doc's changelog.
- `flutter analyze`, `flutter test`, `flutter build apk --debug`, `flutter build web` all green on `release/math-intelligence-rc1-foundation`.
- No open release-blocking issue per the freeze doc's §6 definition.
- Design review sign-off on visual polish items above.

Anything not on this list, or on the freeze doc's deferred list, is out of scope until a post-RC1 decision reopens it.
