# Feature Discovery QA — Math Intelligence Brand & Roadmap Refinement

## Status

**READY FOR V1 FREEZE**, with the same live-device caveat noted below (no
Android hardware was visible to Flutter in this environment).

## Addendum: Version Footer

Added after the initial pass, at explicit request: a 4-line version footer in
the existing Profile → About section (reachable via **More → Profile** on
phone, or the Profile rail item on tablet/desktop — this reuses the existing
"About" card rather than adding a new screen/route):

```
Math Intelligence
Version 1.0.0
Powered by Adaptive Learning Intelligence
© QuantumLab Intelligence
```

The version number is read live from `PackageInfo.fromPlatform()` (new
`package_info_plus` dependency) rather than hardcoded in an ARB string, so it
can never drift from the shipped build — the stated purpose was accurate
support reporting, and a hardcoded string would defeat that the next time
`pubspec.yaml`'s version bumps. Superseded the old `profileVersion` ARB key
(a single hardcoded "Version 1.0.0 · © 2026 Math Intelligence" line, already
present in 5 locale files, one of which — `de_CH`/`fr_CH` — had been
overridden down to just the bare word "Version" with no number at all) with
two new keys: `profileVersionNumber` (ICU, `{version}` placeholder) and
`profileCopyright`. The tagline line reuses the existing `onboardingTechBadge`
key. "© QuantumLab Intelligence" is kept as a literal, untranslated brand/
copyright line in every locale, consistent with the brand-term convention
described above.

New test: `test/profile_version_footer_widget_test.dart` (uses
`PackageInfo.setMockInitialValues` to verify the real version string renders
correctly for all 4 production locales). Full pipeline re-run after this
change: analyze clean, 66/66 tests pass, release APK rebuilt successfully.

## Scope Covered

1. Brand hierarchy on the welcome/onboarding hero screen — verified, already
   correct (white hero text, "Develop mathematical thinking. Unlock your
   potential." / "Personalised learning. Measurable progress." / "Powered by
   Adaptive Learning Intelligence").
2. New **Explore Math Intelligence** feature-discovery page — built from
   scratch, reachable from **More**.
3. **Learning Analytics** terminology — audited app-wide; no "Parent
   Dashboard"/"Teacher Dashboard" strings remain anywhere.
4. **My Maths Journey** card — wording reviewed against the spec's preferred
   examples and localized (previously hardcoded English), card kept as-is
   otherwise.
5. Product positioning — no "AI that knows everything" language found;
   existing "AI Tutor" feature name (a real, shipped chat-tutor tab) was left
   untouched as it names an existing feature, not new marketing copy.
6. Localisation — hero copy re-reviewed for French/German/Italian/
   Portuguese/Indonesian; new Explore/Journey copy added to the master
   template and to the three real production locales (`de_CH`, `fr_CH`,
   `it_CH`).
7. **Roadmap Philosophy** section added to the Explore page.
8. Full validation pipeline run (clean → pub get → gen-l10n → analyze → test
   → build apk --release).
9. This report.

## Unplanned but necessary: pre-existing localisation corruption fixed

Before starting this task, the working tree already contained substantial
**uncommitted** work from an earlier "Brand and Role Alignment" pass
(`BRAND_AND_ROLE_ALIGNMENT_QA.md`, not part of this task's request). While
adding new keys to those same ARB files, character-encoding corruption
("mojibake" — accented letters replaced by literal `?`) was discovered in
that uncommitted work, affecting **170 strings** across 17 locale files,
including the three real production locales (`de_CH`, `fr_CH`, `it_CH`).
Examples: `verf?gbar` → `verfügbar`, `l?apprenant` → `l'apprenant`,
`?tape` → `étape`, entire corrupted Korean/Arabic strings.

Per explicit user direction, all of this was repaired (not just the new
content added by this task):

- Fixed in full: `app_de_CH`, `app_fr_CH`, `app_it_CH` (production),
  `app_de`, `app_fr`, `app_it`, `app_pt`, `app_da`, `app_da_DK`, `app_nb`,
  `app_nb_NO`, `app_sv`, `app_sv_SE`, `app_es`, `app_ko`, `app_ko_KR`,
  `app_ar`.
- Left untouched per explicit scope: strings that were never translated at
  all (raw English placeholders sitting in non-English files, e.g. several
  keys in `app_pt.arb` and one key — `onboardingGoalTitleParent` — across
  most non-production locales). These are pre-existing translation gaps,
  not corruption, and are documented here as a **known limitation** for a
  future dedicated localisation pass. They only affect UAT-only locales
  (`LocaleService.productionLocales` ships only `en`, `en_GB`, `de_CH`,
  `fr_CH`, `it_CH`).
- Verified: every ARB file parses as valid JSON and contains zero U+FFFD
  replacement characters after the fix.

## Files Changed

New:

- `lib/screens/explore/explore_math_intelligence_screen.dart` — the Feature
  Discovery page.
- `test/explore_feature_discovery_widget_test.dart` — navigation +
  no-overflow regression test (phone **and** tablet viewport, all 4
  production locales).
- `FEATURE_DISCOVERY_QA.md` (this file).

Modified for this task:

- `lib/app/router.dart` — added `/explore` route.
- `lib/screens/home/home_shell.dart` — added the "Explore Math Intelligence"
  entry to the mobile **More** sheet, and a matching entry on the
  `NavigationRail` (tablet/desktop width) via a new `_RailExploreButton`,
  since the rail layout has no "More" sheet at all.
- `lib/screens/journey/journey_screen.dart` — `_MathsJourneyCard` wording
  localized (was hardcoded English literals); "Consistency" relabelled
  "Current streak" to match the spec's preferred terminology.
- `lib/l10n/app_en.arb` (master template) and `lib/l10n/app_{de_CH,fr_CH,
  it_CH}.arb` — ~60 new keys for the Explore page and Journey card.
- `lib/l10n/*.arb` (all 17 other locale files) — mojibake repair only, no
  new content (see above).
- `lib/l10n/app_localizations*.dart` — regenerated via `flutter gen-l10n`.

Left as found (pre-existing uncommitted work from the earlier Brand/Role
session, not part of this task): `lib/app.dart`, `lib/screens/auth/
create_account_screen.dart`, `lib/screens/auth/sign_in_screen.dart`,
`lib/screens/onboarding/user_type_screen.dart`, `lib/screens/settings/
help_screen.dart`, `lib/screens/settings/parent_teacher_tools_screen.dart`,
`lib/screens/settings/profile_screen.dart`, `lib/widgets/onboarding/
onboarding_option_card.dart`, `test/brand_role_alignment_test.dart`,
`docs/branding/BRAND_POSITIONING.md`, `BRAND_AND_ROLE_ALIGNMENT_QA.md`.

## Navigation Changes

- New route: `/explore` → `ExploreMathIntelligenceScreen`, pushed above the
  shell (back button returns to `/home`, matching the `/packs`/`/upgrade`
  pattern).
- Mobile (phone width): **More** sheet → **Explore Math Intelligence** tile
  (compass icon), placed above Formula Library.
- Tablet/desktop width (`NavigationRail`, ≥1024 logical px — this is what
  the real 11.5" test tablet resolves to): added as a trailing rail button,
  since that layout has no "More" sheet at all. **This was a real gap found
  during testing** — without it, Explore would have been completely
  unreachable on tablet.

## Localisation Updates

New keys (Explore page copy, Roadmap Philosophy, localized Journey card):
added to `app_en.arb` (master/fallback) and fully translated into `de_CH`,
`fr_CH`, `it_CH` (the app's actual production-shippable locales per
`LocaleService.productionLocales`). "In Atelier" / "IN ATELIER" is kept as a
literal, untranslated brand term in all locales, consistent with how
"Learning Analytics" and "Powered by Adaptive Learning Intelligence" are
already handled elsewhere in this codebase.

Plus: repair of the 170-string mojibake issue described above.

## Feature Discovery Screenshots

Not captured. No Android device was visible to Flutter in this environment
(`flutter devices` only reports Windows/Chrome/Edge desktop targets), and no
Windows-native GUI automation/screenshot driver is set up for this project.
In place of screenshots, correctness was verified with a widget test
(`test/explore_feature_discovery_widget_test.dart`) that drives the real
app: opens **More** (or taps the rail button at tablet width), navigates to
`/explore`, asserts both sections and all feature titles render, asserts
zero layout exceptions, and navigates back — for all 4 production locales,
at both a phone (390×844) and tablet (1280×800) viewport.

**This test caught two real bugs before they shipped:**

1. A `RenderFlex overflowed by 99 pixels` in French (`DISPONIBLE
   AUJOURD'HUI`) and 28 pixels in German (`Entwicklungsphilosophie`) — two
   `Text` widgets inside `Row`s that weren't wrapped in `Expanded`. Fixed in
   `explore_math_intelligence_screen.dart`.
2. The tablet/rail navigation gap described above.

## Remaining "In Atelier" Items

Exactly as specified, described only on the Explore page, each tagged "In
Atelier" with "This feature is currently in development." — no
navigation, screens, or backing logic were added for any of these:

- Photo Question Upload
- Mark My Paper
- Examiner Intelligence
- Adaptive Study Plans
- Tutor Conversations

## Validation Results

- `flutter clean`: PASS
- `flutter pub get`: PASS
- `flutter gen-l10n`: PASS
- `flutter analyze`: **No issues found**
- `flutter test`: **65/65 passed** (64 pre-existing + 1 new Explore
  navigation/overflow test, itself covering 4 locales × 2 viewports = 8
  sub-scenarios)
- `flutter build apk --release`: PASS — `build/app/outputs/flutter-apk/
  app-release.apk` (83.1 MB)
- `flutter devices`: only Windows/Chrome/Edge desktop targets visible; no
  Pixel 6a or Android tablet connected this session — live on-device
  verification (touch targets, real compositor behaviour, launcher icon)
  is still outstanding and should be done on real hardware before
  submission.

## Known Limitations

- Live Pixel 6a / Android tablet verification blocked (no device visible to
  Flutter this session) — same limitation noted in the earlier
  `BRAND_AND_ROLE_ALIGNMENT_QA.md`.
- Untranslated English placeholder strings in UAT-only locales (`pt`, `id`,
  `da`, `nb`, `sv`, `es`, `ko`, `ar`) were left as-is per explicit scope —
  these locales are not in `LocaleService.productionLocales` and are not
  shippable to real users without `BuildFlags.enableUatLocales`.
- No AI services, multimodal AI, handwriting recognition, photo upload,
  OCR, computer vision, "Mark My Paper", "Examiner Intelligence", or
  adaptive-AI backends were implemented — all such items appear only as
  "In Atelier" descriptions on the Explore page, per the brief.

## Recommendation

**READY FOR V1 FREEZE**, pending a live Pixel 6a / tablet smoke pass when
hardware is available (same outstanding item as the prior QA report).
