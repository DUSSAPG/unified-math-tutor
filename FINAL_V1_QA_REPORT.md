# Final V1 QA Report — Sterling Math

**Sprint:** Final V1 UX, Onboarding & Accessibility Polish
**Scope:** Sections 1–15 of the sprint brief
**Date:** 2026-07-01

## Summary

This sprint rebranded the app's user-facing copy to "Sterling Math," rebuilt the welcome/onboarding
experience with distinct Student and Parent-or-Teacher paths, simplified accessibility controls,
fixed three functionally broken practice modes (Topic Drill, Timed Challenge, Exam Simulator), added
a new offline Formula Library, and closed out one pre-existing analyzer error. All work was validated
with `flutter analyze`, `flutter test` (62/62 passing), a full `flutter clean && flutter pub get &&
flutter build apk --debug`, and a live interactive session on a physically connected Pixel 6a with a
continuously monitored `flutter run` log (zero exceptions observed).

No application architecture was redesigned; all changes are additive or corrective within the
existing GoRouter / ValueNotifier+SharedPreferences service patterns already used throughout the
codebase.

## Files Changed

**New files**
- `lib/services/onboarding_profile_service.dart` — persists user type, goal, parent email
- `lib/screens/onboarding/welcome_step_screen.dart` — Student-only onboarding Step 1
- `lib/services/formula_library_service.dart` — Formula Library JSON loader/search
- `lib/screens/formulas/formula_library_screen.dart` — Formula Library UI
- `assets/config/formula_catalog.json` — 30 formulas across 11 categories
- `test/formula_library_service_test.dart`

**Modified — app logic**
- `lib/main.dart`, `lib/app/router.dart`
- `lib/screens/onboarding/user_type_screen.dart`, `stage_selector_screen.dart`,
  `goal_selector_screen.dart`, `study_profile_screen.dart`
- `lib/screens/settings/accessibility_screen.dart`, `appearance_screen.dart`, `profile_screen.dart`,
  `terms_screen.dart`, `release_notes_screen.dart`
- `lib/screens/practice/practice_screen.dart` (Topic Drill, Timed Challenge, Exam Simulator)
- `lib/screens/home/home_shell.dart` (Formula Library entry card)
- `lib/services/parent_report_service.dart`, `lib/services/pack_registry_service.dart` (analyzer fix)
- `android/app/src/main/AndroidManifest.xml` (launcher label)

**Modified — localization**
- `lib/l10n/app_en.arb` (template — new/changed keys), plus `app_de_CH.arb`, `app_fr_CH.arb`,
  `app_it_CH.arb`, `app_ko_KR.arb` (translated onboarding copy kept in sync)

**Modified — docs/tests**
- `docs/legal/PRIVACY_POLICY.md`, `TERMS_OF_USE.md`, `docs/store_readiness/APP_STORE_COPY.md`,
  `FLAVOR_PLAN.md`, `SCREENSHOT_CHECKLIST.md`, `PACKAGE_ID_PLAN.md` (brand string swap)
- `test/widget_test.dart`, `test/profile_sign_out_widget_test.dart` (updated to match new copy)

## Validation Performed

| Step | Result |
|---|---|
| `flutter clean` | Pass |
| `flutter pub get` | Pass (19 packages have newer versions available — pre-existing, unrelated to this sprint) |
| `flutter analyze` | **0 issues** |
| `flutter test` | **62/62 passing** |
| `flutter build apk --debug` | Built successfully |
| Live Pixel 6a session (`flutter run`, log monitored) | **0 exceptions** across Welcome screen, Student onboarding, rapid Topics-filter stress test, Timed Challenge, Exam Simulator picker, Formula Library |

## Screens Tested (live, on-device)

Welcome/user-type screen, Student onboarding (Welcome → Level → Goal), Practice setup (Exam
Simulator exam picker, KS4 tier gating), Formula Library (category filter + expand), Home (new
Formula Library card), Topics (rapid filter-chip stress test), Mental Math trick detail (regression
check). Remaining screens (Profile, Help, Tutor, Parent flow's email/PIN step) were validated via the
widget test suite's locale-navigation coverage rather than manual device taps, per the device's short
screen-timeout making an exhaustive manual pass slow.

## Remaining Issues / Known Gaps

These are intentional scope boundaries per the sprint brief, not oversights:

1. **Sign In / Create Account are still stub screens** (`Scaffold(body: Center(child: Text('Sign In')))`).
   The Welcome screen now links to them, but building real authentication was out of scope
   ("do not introduce major new features").
2. **Oxford Track and Swiss Gymnasium exam packs are locked/future** in the new Exam Simulator picker
   — by design ("Future exam packs may remain locked").
3. **Teacher Dashboard remains a placeholder** — only the "I'm a Parent or Teacher" onboarding
   label and existing Parent Tools screen exist; a dedicated teacher UI was explicitly marked
   acceptable to defer.
4. **Formula Library is English-only for v1** — by design.
5. **High Contrast was removed, not implemented** — per instruction ("remove unless a genuine
   accessibility palette has been implemented").
6. **Per-market `applicationId` flavors (gb/ch/kr) remain a documented plan**, not yet wired into
   `build.gradle.kts` — this is pre-existing and intentional; implementing it now would itself
   create the duplicate-install risk the sprint asked to avoid, since today's single build only has
   one `applicationId`.
7. A few non-shipping internal docs (`lib/app.dart`'s unused `MathTutorAppShell` class,
   `assets/splash/README.md`, `design_reference/*.md`) still say "MathTutor" — dead code / internal
   design docs, not user-facing, left untouched to limit scope.

None of the above block internal testing.

## Recommendation

**Ready for Google Play Internal Testing.**
