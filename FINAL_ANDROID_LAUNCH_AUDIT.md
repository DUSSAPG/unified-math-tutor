# Final Android Launch Audit

**Audit date:** 2026-06-11  
**Build command:** `flutter build appbundle --release --dart-define=ENV=prod`  
**Overall result:** **BLOCKED**

## PASS / BLOCKER Table

| # | Check | Result | Evidence / required action |
|---|---|---|---|
| 1 | All `daily_brain_teasers.*.json` files are valid JSON | **PASS** | All 10 runtime files decode as valid JSON arrays. |
| 2 | Every translated file has IDs identical to the canonical file | **PASS** | Every translation has the same ordered IDs `t001` through `t300` as the canonical file. |
| 3 | No translated file is missing entries | **PASS** | Every translated file contains exactly 300 entries. |
| 4 | Language registry includes `sv`, `da`, `nb`, `es`, `pt`, `id` | **PASS** | `LocaleService.supported` contains all six base language codes. ARB files and generated localization delegates now exist for `es`, `pt`, and `id`. |
| 5 | Production build removes UAT/admin/debug surfaces | **PASS** | Release notes and its UAT build information are gated by `BuildFlags.enableDevUi`; that flag is false for `ENV=prod`. The admin screen has no registered route. Debug startup logging is guarded by `kDebugMode`. |
| 6 | Android `targetSdk` is 35 or higher | **PASS** | `android/app/build.gradle.kts` sets `targetSdk = 36` and `compileSdk = 36`. |
| 7 | Release signing is configured and does not use debug signing | **BLOCKER** | Gradle now uses `signingConfigs.release`, never the debug key. Submission remains blocked because `android/key.properties` and the private upload keystore are absent. |
| 8 | Production app bundle builds with the required command | **BLOCKER** | Flutter/Dart compilation and bundling complete, then signing stops with the explicit error: `Release signing requires android/key.properties`. No AAB was produced. |
| 9a | Privacy policy documented and publishable | **BLOCKER** | `docs/legal/PRIVACY_POLICY.md` is explicitly a placeholder and has no confirmed live URL or legal approval. It also describes collection/storage behavior that must be reconciled with the app before publication. |
| 9b | Google Play Data Safety documented | **PASS (draft)** | `docs/store_readiness/PRIVACY_NUTRITION.md` documents the current draft disclosures. The final Play Console answers must be checked against the signed production AAB and final privacy policy. |
| 9c | Store listing documented | **BLOCKER** | Short copy exists, but final Play listing copy, contact details, category, content declarations, and publication status are not recorded as complete. |
| 9d | Store screenshots documented and available | **BLOCKER** | Capture requirements and manifests exist. No final screenshot files were found under the documented screenshot output directories. |
| 9e | Demo/review account requirements documented | **PASS** | No account is required for the current local practice flow, so no demo credentials are required. Play review notes must state: launch the app, complete or skip onboarding, and use the app without signing in. Do not claim account-backed features. |

## Changes Made During Audit

- Normalized Danish, Norwegian, and Swedish teaser assets to valid top-level JSON arrays.
- Added schema and canonical-ID coverage for every teaser translation file.
- Added `sv`, `da`, `nb`, `es`, `pt`, and `id` base language codes to the app registry.
- Added and generated localization fallback classes for Spanish, Portuguese, and Indonesian.
- Removed the UAT release-notes surface from production route and profile registration.
- Replaced debug release signing with required upload-key signing and an explicit missing-key error.

## Verification

| Command | Result |
|---|---|
| JSON/parity audit | PASS: all translated files contain the canonical 300 IDs |
| `flutter gen-l10n` | PASS |
| `dart format ...` | PASS |
| `flutter analyze` | PASS, no issues |
| `flutter test` | PASS: 55 tests passed |
| Required production AAB command | BLOCKER at release signing; no AAB output |

## Required Remediation Before Submission

1. Generate the Play upload keystore outside the repository and create
   `android/key.properties` as described in
   `android/RELEASE_SIGNING_GUIDE.md`.
2. Rerun the required AAB command and retain the resulting
   `build/app/outputs/bundle/release/app-release.aab`.
3. Reconcile the privacy policy with actual behavior, complete legal review,
   publish it at a stable public HTTPS URL, and enter that URL in Play Console.
4. Finalize and record the Play Data Safety form from the signed production
   artifact.
5. Finalize the store listing and capture/upload the required production
   screenshots with no UAT, debug, placeholder, or test content.
6. Put the no-account review path above into Play Console App Access/review
   notes and verify that reviewers can reach all submitted functionality.

**Launch decision:** Do not submit to Google Play until every BLOCKER row is
closed and the exact production AAB command succeeds.
