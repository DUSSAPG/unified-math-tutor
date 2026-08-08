# Light Theme — Final Build Report

**Status: PASS**

Math Intelligence now ships a complete, production-quality Light Theme: a
calm pale blue-grey learning environment with dark navy text — not plain
white — alongside the existing Dark Theme, switchable via Settings ▸
Appearance (System / Dark / Light), fully driven by the pre-existing
`AppTheme`/`AppSemanticColors`/`AppLabColors` token system.

This report covers the full sprint: the FIRST-phase audit, every file
converted, every deliberate exception retained, contrast findings, and the
validation run.

---

## 1. Audit summary

The theme-token system (`lib/shared/theme/app_theme.dart`) was **already
built** before this sprint started — `AppTheme.light()`/`AppTheme.dark()`,
`AppSemanticColors`, `AppLabColors`, the `context.appColors`/
`context.labColors` `BuildContext` extensions, and a full `ThemeData._build()`
covering `ColorScheme`, `AppBarTheme`, `CardThemeData`,
`BottomNavigationBarThemeData`, `NavigationRailThemeData`,
`FilledButtonThemeData`, `ElevatedButtonThemeData`, `TextButtonThemeData`,
`InputDecorationTheme`, `DividerThemeData`, and the full `TextTheme`. The
Light Theme's own palette (pale blue-grey background, soft-blue elevated
surface, blue-lilac card surface, near-black navy primary text, slate
secondary text, a darkened accent blue for sufficient contrast on pale
surfaces) was already defined and already passed the pre-existing contrast
test suite.

What was **not** yet done, and this sprint's actual scope, was the
completion sweep: dozens of screens and shared widgets across the app still
hardcoded the old dark-only literals (`Color(0xFF0B1120)`,
`Color(0xFF132040)`, `Color(0xFF8A9DC0)`, `Colors.white`, etc.) instead of
reading `context.appColors`/`context.labColors` — meaning Light Theme mode
already worked structurally (no crash) but rendered large areas of the app
as dark islands on a pale background, or vice versa. A CustomPainter bug
(`NumberLineWidget`) and a `SpatialShapePainter` grid bug would have made
diagrams genuinely disappear (white gridlines on a near-white canvas). This
sprint found and closed that gap file by file, screen by screen, rather
than a blanket search-and-replace.

## 2. Token inventory

No new tokens were added — the existing set was sufficient for every
screen converted:

| Token | Role |
|---|---|
| `background` | Page/scaffold background |
| `elevatedSurface` | App bars, bottom nav/rail, elevated bottom sheets |
| `cardSurface` | Cards, panels, containers, chip/input fills |
| `primaryText` / `secondaryText` / `tertiaryText` | Text hierarchy (tertiary = de-emphasized/disabled-adjacent) |
| `divider` | Borders, dividers, disabled backgrounds |
| `primaryAction` / `onPrimaryAction` | Buttons (brand blue, identical across themes) |
| `accent` | Icons, links, selected-state text/chips — a separate, lighter/darker blue than `primaryAction` depending on theme |
| `success` / `warning` / `error` | Status colors |
| `AppLabColors` (`pitchSurface`, `mazeRoad`/`mazeWall`/`mazeGrass`, `radarGrid`/`radarTarget`/`radarLanding`, `ballColor`, `robotColor`, `flightPath`, `targetHighlight`) | Interactive Labs' simulated-environment colors, already theme-tuned in both directions |

Two genuine **CustomPainter bugs** were fixed by adding new painter
constructor parameters (the standard pattern this app already uses: the
painter can't call `Theme.of(context)` itself, so the wrapping widget
resolves `context.appColors` once and passes plain `Color`s in):

- `NumberLineWidget` / `_NumberLinePainter` — `lineColor`, `pointColor`,
  `labelColor` were hardcoded dark literals; now theme-resolved. Without
  this, the number line diagram was invisible on a pale Light Theme
  surface.
- `SpatialShapePainter` (Rotations, Transformations) — `gridColor`/
  `axisColor` were `Colors.white.withValues(alpha: 0.08/0.28)`, nearly
  invisible on a pale canvas. Now theme-resolved (`colors.divider`/
  `colors.secondaryText`).
- `_RadarPainter` (Flight Path Lab) — the aircraft's starting-point origin
  marker was a fixed `Colors.white` dot on a radar canvas that paints no
  background fill of its own (it sits directly on the page background) —
  added `originColor`, resolved to `colors.primaryText`.

## 3. Files changed (73 modified + 1 new test file)

### Screens
```
lib/screens/auth/{auth_form_fields,create_account_screen,forgot_password_screen,sign_in_screen}.dart
lib/screens/build_confidence/build_confidence_screen.dart
lib/screens/entrance_exam/entrance_exam_hub_screen.dart
lib/screens/explore/explore_math_intelligence_screen.dart
lib/screens/family_maths/{family_activity_detail_screen,family_maths_library_screen,family_maths_welcome_screen}.dart
lib/screens/formulas/formula_library_screen.dart
lib/screens/home/home_shell.dart
lib/screens/labs/{algebra_balance_screen,data_detective_screen,flight_path_lab_screen,fraction_builder_screen,interactive_labs_hub_screen,number_line_explorer_screen}.dart
lib/screens/math_magic/math_magic_screen.dart
lib/screens/mental_maths/{mental_maths_category_screen,mental_maths_hub_screen}.dart
lib/screens/onboarding/{accessibility_step_screen,goal_selector_screen,onboarding_shell,study_profile_screen,user_type_screen}.dart
lib/screens/onboarding/family/{family_goal_screen,family_preferences_screen,family_role_detail_screen}.dart
lib/screens/packs/exam_packs_screen.dart
lib/screens/practice/practice_screen.dart
lib/screens/recall/{recall_cards_bookmarks_screen,recall_review_session_screen}.dart
lib/screens/settings/{curriculum_settings_screen,help_screen,parent_cheat_sheet_screen,parent_teacher_tools_screen,privacy_data_screen,release_notes_screen,subscription_screen,terms_screen}.dart
lib/screens/spatial_intelligence/{rotations_screen,spatial_intelligence_screen,spatial_shape_painter,transformations_screen}.dart
lib/screens/tutor/tutor_screen.dart
lib/screens/upgrade/upgrade_screen.dart
lib/screens/visual_maths/{abacus_screen,fraction_bars_screen,number_line_screen,place_value_explorer_screen,visual_maths_hub_screen,visual_maths_placeholder_scaffold}.dart
```

### Widgets
```
lib/widgets/discovery/discovery_export_sheet.dart
lib/widgets/graphs/simple_graph_card.dart
lib/widgets/labs/{feed_panda/panda_visual,lab_first_use_overlay,lab_narration_controls}.dart
lib/widgets/manim/manim_explanation_card.dart
lib/widgets/onboarding/{onboarding_option_card,onboarding_progress_header,onboarding_selection_card,who_is_learning_sheet}.dart
lib/widgets/recall/{recall_card_body,recall_card_export_sheet}.dart
lib/widgets/settings/parent_gate.dart
lib/widgets/shared/{empty_state,in_development_feature_card,info_card,skeleton_loader}.dart
lib/widgets/visual_maths/number_line_widget.dart
```

### Tests
```
test/app_theme_contrast_test.dart          (extended — chips/borders/disabled states)
test/theme_representative_screens_test.dart (extended — routes map, reading-size sweep)
test/light_theme_control_states_test.dart   (new — enabled/disabled/focused/selected)
```

## 4. Hardcoded-colour removals — pattern

Every conversion followed one of these established, already-precedented
patterns rather than inventing new ones per file:

- `Color(0xFF0B1120)` (scaffold bg) → `colors.background`
- `Color(0xFF132040)` (card bg) → `colors.cardSurface`
- `Color(0xFF0D1526)` (app bar/nav bg) → `colors.elevatedSurface`
- `Color(0xFF1F3055)` (borders/dividers) → `colors.divider`
- `Color(0xFF8A9DC0)` (secondary text) → `colors.secondaryText`
- `Color(0xFF4A6080)` (de-emphasized/disabled text) → `colors.tertiaryText`
- `Color(0xFF5B8EFF)` (icons/links/selected) → `colors.accent`
- `Color(0xFF3D7EFF)` (buttons) → `colors.primaryAction`
- `Color(0xFF34C759)` / `0xFFFFBD00` / `0xFFE91E63`-family → `colors.success` / `colors.warning` / `colors.error`
- `Colors.white` (plain text on the page/card) → `colors.primaryText`
- Fixed near-black "badge tint" backgrounds paired with a semantic colour
  (e.g. a red exhausted-state pill) → `semanticColor.withValues(alpha:
  0.12)` derived from the same colour, so the tint itself becomes
  theme-adaptive instead of staying a hardcoded dark literal that reads as
  a leftover on a pale surface.

Two real, non-cosmetic bugs were fixed as part of this sweep (not just
recolours):
- `flight_path_lab_screen.dart`'s `_FlightTierPill` rendered its label in
  a fixed `Color(0xFF9FBEFF)` regardless of the `accentColor` its
  background/border were tinted with — inconsistent even before Light
  Theme. Now uses `accentColor` for the text too.
- `entrance_exam_hub_screen.dart`'s "Locked" badge used
  `colors.tertiaryText` as a *solid* pill background with fixed
  `Colors.white` text — on Light Theme's pale `tertiaryText`, white text
  measured well under an acceptable ratio. Changed to `colors.divider`
  background / `colors.secondaryText` text, matching the muted-badge
  convention used everywhere else.
- `practice_screen.dart`'s Start button spinner was fixed `Colors.white`,
  but the button's own background falls back to `colors.divider` while
  loading — invisible on Light Theme. Now uses `colors.tertiaryText`,
  matching the theme's own disabled-button foreground convention.

## 5. Immersive-screen / deliberate exceptions retained

Per the brief's "maintain specialised immersive lab themes where
justified" and "preserve controlled category accents" rules, the following
were explicitly reviewed and **kept fixed**, not converted:

- **Brand/character identity colours**: Allie's orange, Captain Math's
  green badge (`maze_driver_lab_screen.dart`'s `_CaptainMathPanel`),
  Feed the Hungry Panda's white fur, the onboarding/tutor logo gradients,
  every screen's small circular "avatar chip" (Profile, Tutor header) —
  all explicitly commented in-code as fixed brand treatments, consistent
  with a convention already established before this sprint.
- **Category/setting icon badges**: the `iconColor`/`iconBg` gradient
  pairs used by `_SettingCard` (Profile), `RouteLinkCard`,
  `_TopicRowCard`/`_LearningPathCard` (Home), and the pillar-hub
  `RouteLinkCard` entries — small self-contained badges that carry their
  own background fill, so they read correctly regardless of theme and
  exist to visually differentiate categories (blue/purple/cyan/gold/etc.),
  not to signal theme.
- **Cube-face palettes**: `_faceColors`/`_kNeutralCellColors` (Cube Nets,
  Spatial Cube Net Explorer) — a fixed 6-colour categorical palette the
  puzzle depends on for "reason about geometry, not colour-match", plus
  their white/black selection-outline strokes, which are drawn on top of
  the saturated cell fill, not the page background.
- **Physical-environment lab colours**: Football Precision's pitch,
  Maze Driver's road/wall/grass, Flight Path Lab's radar grid/aircraft —
  all sourced from `AppLabColors`, which already has its own tuned Light
  Theme variants (e.g. a daylight grass green for the pitch, a near-black
  charcoal robot instead of a washed-out blue) rather than being
  desaturated to match the page chrome.
- **`ManimExplanationCard`'s inner canvas**: a fixed dark "screening room"
  background behind the static-fallback SVG diagrams, independent of app
  theme — same rationale as a video player's canvas staying dark
  regardless of the surrounding chrome; the SVGs are authored against it.
- **`AppSplashScreen`**: kept fully fixed-dark. Verified by inspecting the
  actual `app_splash_art.png` pixel data — its corners are opaque near-navy
  (`~#01050F`), matching the dark theme's background almost exactly, with
  no transparency. Converting the Scaffold background to a pale Light
  Theme colour while the baked-in art stays dark would create a visible
  seam in `BoxFit.contain`'s letterbox bars on any aspect ratio that
  doesn't exactly match the asset. This is a deliberate, verified
  exception, not an oversight.
- **`AppearanceScreen`'s theme-preview swatches**: the Dark/Light preview
  tiles in the System/Dark/Light selector necessarily show fixed
  representative colours for what each *other* mode looks like — by
  definition these can't read from the currently-active theme.
- **Destructive-action red** (`Color(0xFFFF3B30)`): used consistently for
  "Delete all data", "Sign out", and the Tutor's exhausted-state badge —
  a fixed value distinct from the semantic `error` token, kept as-is for
  consistency across every destructive control in the app (not something
  this sprint introduced).

## 6. Contrast findings

`test/app_theme_contrast_test.dart` (extended this sprint) verifies, for
**both** themes, using a self-contained WCAG 2.1 relative-luminance
calculator:

- Primary/secondary text on background and on card surface
- Primary-action button label contrast
- Success/warning/error on background
- Divider distinguishable from both background and card surface
- Accent (icons/links/selected text) on background
- Selected-chip label (onPrimaryAction on accent fill) legibility
- Light theme background is verified **not** pure white

**One pre-existing finding, not introduced by this sprint**: disabled
button/chip content (`tertiaryText` on `divider`) measures ~2.0:1 (dark) /
~2.3:1 (light) — below the 3:1 AA "large text" bar. WCAG 2.1 SC 1.4.11
explicitly exempts disabled/inactive controls from contrast minimums, so
this is not a violation, but it's flagged here as a candidate for a future
design-system pass rather than silently recoloured mid-sprint (touching
`disabledForegroundColor`/`disabledBackgroundColor` in `AppTheme._build()`
would change the disabled-state appearance of every button in the app,
which is out of this sprint's "convert to tokens" scope). The regression
test now guards the pair at a lower, honest 1.5:1 floor so it can't get
worse unnoticed.

All other checked pairs pass in both themes.

## 7. Screens validated

Every screen in the brief's "REQUIRED SCREENS" list, plus every screen
this sprint's file-by-file sweep actually touched, renders without
exception or overflow in `test/theme_representative_screens_test.dart`
under both `ThemeMode.dark` and `ThemeMode.light` (46 routes × 2 themes):
onboarding (all 4 steps + Sign In), home, topic drill (Topics), timed
challenge (Mental Maths hub), exam simulator (Exam Packs), entrance exam
preparation, tutor, progress (Journey), profile, Math Studio (hub + all 6
pillar hubs), Family Studio, Recall Cards, Discovery Library, Football
Precision, Maze Driver, Flight Path Lab, Aircraft Landing Lab, Spatial Cube
Lab, Algebra Balance, Data Detective, Number Line Explorer, Feed the
Hungry Panda, and the full Settings/Profile sub-page set (Appearance,
Accessibility, Subscription, Curriculum, Privacy, Terms).

A device matrix (Football Precision as the CustomPainter/`AppLabColors`
representative, Practice as the text-density representative) additionally
sweeps ordinary/large text scale × compact-phone/tablet size × both
themes. A dedicated Reduce Motion check confirms it still functions under
Light Theme. A new Reading-size S/M/L sweep (0.9× / 1.0× / 1.15×, the
exact three steps `AccessibilityStepScreen` itself offers) runs Home and
Practice through both themes.

## 8. Unresolved / deferred items

- **`lib/app.dart`** (`MathTutorAppShell`) — confirmed dead code: zero
  references anywhere in `lib/` or `main.dart`, a leftover hardcoded-dark
  `ThemeData` shell from before the current router/`AppShell` structure
  existed. Not converted (would be pointless — it's unreachable) and not
  deleted (out of scope for a theming sprint; flagged here for a future
  cleanup pass rather than silently removed).
- **Disabled-control contrast** (~2.0–2.3:1) — see §6. WCAG-exempt, not
  fixed, explicitly flagged for a future design pass.
- No visual/manual device QA was performed (no physical device or
  simulator was available in this environment) — see §9 for the Pixel 6a
  checklist this leaves outstanding.

## 9. Pixel 6a checklist (still required, hardware not available here)

- [ ] Toggle System/Dark/Light in Settings ▸ Appearance and confirm the
      transition is instant with no flash of unstyled/mismatched content.
- [ ] Visual check of the Continue Learning hero card and What's New card
      on Home in Light Theme (converted from a fixed dark gradient to a
      theme-aware `elevatedSurface → cardSurface` gradient this sprint —
      confirmed structurally via the widget-test suite, not yet eyeballed
      on-device).
- [ ] Visual check of Football Precision, Maze Driver, and Flight Path Lab
      in Light Theme — confirm pitch/maze/radar read as intentional
      "physical environment" colours, not washed out.
- [ ] Visual check of Feed the Hungry Panda in Light Theme (drag-and-drop
      counting activity; confirm the panda's white fur and counting tray
      remain legible against the pale background).
- [ ] Large system text-scale (beyond the 1.15× "L" this sprint tested) on
      a real device's accessibility settings, confirmed against no clipped
      buttons on Tutor, Practice, and the onboarding flow.
- [ ] Confirm Reduce Motion + Light Theme together on a real device (only
      structurally tested here).

## 10. Validation

```
dart format .            → 23 files reformatted (pure formatting, no logic changes), then clean
flutter analyze           → No issues found (full repo)
flutter test --concurrency=1 → 1312 tests passed, 0 failed
```

---

## Return (per the brief's requested format)

**PASS or FAIL:** **PASS**

**Files changed:** 73 modified + 1 new test file (full list in §3)

**Theme tokens added or changed:** None added — the existing
`AppSemanticColors`/`AppLabColors` token set (already complete before this
sprint) was sufficient. Two `CustomPainter`s gained new constructor
parameters to receive theme-resolved colours (`NumberLineWidget`'s
`_NumberLinePainter`: `lineColor`/`pointColor`/`labelColor`;
`SpatialShapePainter`: `gridColor`/`axisColor`; Flight Path Lab's
`_RadarPainter`: `originColor`).

**Screens validated:** See §7 — every REQUIRED SCREENS entry plus the full
sweep, 46 routes × 2 themes structurally tested, zero exceptions/overflow.

**Exceptions retained:** See §5 — brand/character identity colours,
category icon badges, cube-face palettes, physical-environment lab
colours, the Manim card's fixed canvas, the splash screen (verified via
pixel inspection), the Appearance screen's theme-preview swatches, and the
app-wide destructive-action red.

**Tests added:** 3 files — 2 extended (`app_theme_contrast_test.dart`:
+6 test cases per theme covering chips/borders/disabled states;
`theme_representative_screens_test.dart`: routes map expanded from 15 to
46, plus a new 12-case Reading-size S/M/L sweep), 1 new
(`light_theme_control_states_test.dart`: 6 structural checks × 2 themes
for enabled/disabled/focused/selected controls).

**Total test count:** 1312 (full suite, all passing)

**Pixel 6a checks still required:** See §9 — 6 manual on-device checks,
none of which surfaced as structural failures in the automated suite, but
none of which were visually confirmed on real hardware in this
environment.

Dark Theme is unchanged (a byte-for-byte port of the pre-sprint values, per
`AppTheme.dark()`'s own doc comment). Reduce Motion is unaffected. No
theme toggle does nothing — System/Dark/Light all resolve to a real,
distinct `ThemeData`.

**Not committed**, per the brief.
