# UK + CH + US + SG Release Checklist

## Canonical Registries

The shipped runtime registries are:

- `assets/market_registry.json`
- `assets/pack_registry.json`

Do not add registry copies under `lib/`. The app, validators, and tests load the
files under `assets/`.

Market behavior:

- UK uses `en-GB` UI and `assets/packs/en-GB`.
- US and SG use neutral `en` UI and reuse `assets/packs/en-GB`.
- CH exposes `de-CH`, `fr-CH`, and `it-CH` UI.
- CH translated Practice packs remain opt-in through `ENABLE_CH_PACKS=true`.
- Tutor remains on `assets/packs/en-GB/ALL_merged_deduped.jsonl`.

## Release Commands

Validate UI localization coverage and linguistic approval (production by
default; see "Linguistic approval gate" below):

```powershell
.\scripts\check_enabled_l10n.ps1
```

Validate the default UK, US, and SG pack path:

```powershell
dart run tools\validate_packs.dart
```

Validate the optional CH translated pack path:

```powershell
dart run tools\validate_packs.dart --enable-ch-packs
py scripts\validate_content_quality.py --strict-ch
```

Run tests and static analysis:

```powershell
py scripts\test_translate_ch_packs.py
py scripts\test_autofill_ch_translation_csv.py
py scripts\test_split_ch_translation_template.py
py tools\test_ch_translation_workflow.py
py scripts\test_l10n_approval_gate.py
flutter test
flutter analyze
```

Run the combined readiness suite:

```powershell
.\scripts\release_readiness.ps1
.\scripts\release_readiness.ps1 -EnableChPacks
```

### Production build: required entry point

**Build every production release through `scripts/build_release.ps1`.** It is the required production-build entry point. Run the readiness suite above first; the wrapper does not replace it.

Default production release for UK, US, and SG:

```powershell
.\scripts\build_release.ps1 -Environment prod -Target appbundle
.\scripts\build_release.ps1 -Environment prod -Target web
```

CH release (adds the strict CH content gate and `ENABLE_CH_PACKS=true`):

```powershell
.\scripts\build_release.ps1 -Environment prod -Target appbundle -EnableChPacks
.\scripts\build_release.ps1 -Environment prod -Target web -EnableChPacks
```

The wrapper (`scripts/release_build_gate.py`) stops at the first failing step and builds only if every step passes:

1. **Arguments:** `-Environment` accepts only `prod`, and `-Target` only `appbundle` or `web`. Anything else is rejected before any check runs.
2. **Repository:** it must run from this repository with a clean working tree, including no untracked files. The commit SHA is recorded.
3. **Locale configuration:** `LocaleService.productionLocales` must match the locales the completeness check covers (de_CH, fr_CH, it_CH plus English). Every production ARB, the template and `docs/l10n_approvals/required_keys.json` must exist and be valid.
4. **Generated localisations:** it runs `flutter pub get` and `flutter gen-l10n`. The committed generated localisation files must be unchanged afterwards. Only the known side-effect files may change: `untranslated_messages.txt` and the plugin registrants under `linux/`, `macos/` and `windows/`.
5. **Completeness and approval:** `py scripts\check_enabled_l10n.py --env prod`.
6. **Linguistic approval:** `py scripts\l10n_approval_gate.py --env prod`.
7. **Packs:** `dart run tools\validate_packs.dart`, or with `-EnableChPacks` the strict CH gate (`--enable-ch-packs` and `validate_content_quality.py --strict-ch`).
8. **Build:** only then the approved command, `flutter build <target> --release --dart-define=ENV=prod`, plus `--dart-define=ENABLE_CH_PACKS=true` for the CH release.

- **No bypass:** there is no force, skip or bypass option, and none may be added for production.
- **No stale artefact:** the expected artefact (`build/app/outputs/bundle/release/app-release.aab` or `build/web`) is deleted before validation, so a blocked run never leaves a release artefact behind.
- **Provenance:** every run, built or blocked, writes `build/release_provenance/<UTC>_<commit>_<target>_<status>.json`. It records the commit, branch, configuration, build command, toolchain versions, every check with its exit code, the untranslated counts, the approval-gate counts and the artefact SHA-256. It holds no credentials, environment variables or absolute paths. It is evidence of what was checked, not an approval.
- **Exit codes:** 0 built; 1 blocked by a check (no build started); 2 invalid arguments; 3 build failed.
- **After a run:** restore the side-effect files with `git checkout -- linux macos windows untranslated_messages.txt` before the next run, because the next run requires a clean tree.

**Not protected:** running `flutter build` directly is still technically possible, and the wrapper cannot prevent it. Ordinary `flutter build` and `flutter run` never run these checks, and there is no CI. A production build made any other way is not an authorised production build under this checklist, even when it uses the same flags.

Prepare store screenshot export folders:

```powershell
.\scripts\prepare_store_screenshots.ps1
```

## Linguistic approval gate

Four separate decisions apply. None implies another:

| Stage | What it means | Who or what decides | Evidence |
|---|---|---|---|
| Engineering integration | The code, ARB structure, generated localisations and tests are correct, and the branch can merge | Code review and the host test suite | PR, test results, `docs/qa/*` reports |
| Linguistic approval | A named reviewer has approved the exact text of a translation | A native or professional reviewer for that locale | An approval record in `docs/l10n_approvals/records/` |
| Production build authorisation | A production artefact may be built from a specific commit | `scripts/build_release.ps1`, which builds only when every check passes with `--env prod` | The provenance record in `build/release_provenance/` |
| Public release approval | A built artefact may ship to the public (store submission or deployment) | The release owner, after reviewing the provenance record and this checklist | This checklist and the release owner's decision |

A successful wrapper run authorises a build, not a public release. A merged PR approves no translation.

**How the gate works.** `scripts/l10n_approval_gate.py` runs inside `check_enabled_l10n.py`, and so inside `release_readiness.ps1`. The production build wrapper `build_release.ps1` runs `check_enabled_l10n.py` and the gate again before every production build. For a production release (`--env prod`, the default) it fails if:

- **a draft remains:** any production-locale ARB (the locales come from `LocaleService.productionLocales`) still has a `PENDING LINGUISTIC REVIEW` marker;
- **an approval is missing or stale:** any key in `docs/l10n_approvals/required_keys.json` lacks a valid approval record for its current text. Removing a marker is never enough; editing an approved text needs a new review;
- **a record is malformed:** any approval record is missing the reviewer, date, locale, ARB file, ARB hash or per-key outcome and text hash;
- **the manifest is missing or malformed:** `required_keys.json` is absent, unreadable, has the wrong schema, lists no locales or names a non-production locale. The gate fails closed; it never treats a missing manifest as "nothing required".

**Environments.** `--env dev` and `--env uat` report the same findings without failing. The production build wrapper accepts only `prod`. Ordinary `flutter run` and `flutter build` don't run the gate at all.

**Output.** The report lists locales, keys and record file names only, never translation text or reviewer identities. The record format is in `docs/l10n_approvals/README.md`.

```powershell
py scripts\l10n_approval_gate.py --env prod   # release decision
py scripts\l10n_approval_gate.py --env uat    # report only
py scripts\check_enabled_l10n.py --env prod   # coverage + approval
```

**Limits.**

- **The wrapper is enforced by procedure, not by Flutter:** `build_release.ps1` is the required production-build entry point and runs the gate automatically before it builds. `flutter build` itself never runs the gate, and there is no CI, so a direct `flutter build` is not protected.
- **Coverage fails separately:** the coverage half of `check_enabled_l10n.py` (template keys missing in de_CH, fr_CH and it_CH) fails on its own, in every `--env`. On 2026-11-27 that was 272 keys per Swiss locale, which predates AS-1.
- **The gate checks evidence, not quality:** it verifies that records exist, are well formed and match the current text. It cannot verify that a review actually happened. Records must come from the reviewer and must never be fabricated.

**Current state (2026-11-28, Swiss Phase 3).** 1,470 Swiss translations are pending linguistic review: de_CH 530, fr_CH 508 and it_CH 432 (the 33 AS-1 drafts per locale, the Phase 2 P0 batch and the Phase 3 P1 batch). All of them are listed in `docs/l10n_approvals/required_keys.json`. Zero translations are approved and no approval record exists, so the production approval gate blocks a release. The production build wrapper `build_release.ps1` runs the gate before building and therefore currently stops at the completeness and approval step without starting a build. `flutter build` run directly does not run the gate. The coverage half of `check_enabled_l10n.py` still fails with 26 (de_CH), 27 (fr_CH) and 27 (it_CH) missing template keys: the 26 deferred P2 keys, plus `practiceExamSwissGymnasium` in fr_CH and it_CH (decision D-1). Review packages: `docs/l10n_review/swiss_phase2/` (AS-1 and P0) and `docs/l10n_review/swiss_phase3/` (P1 and the current approval templates).

## CH Translation Pipeline

The only authoritative reviewed translation CSVs are:

- `reports/ch_translation_template.de-CH.csv`
- `reports/ch_translation_template.fr-CH.csv`
- `reports/ch_translation_template.it-CH.csv`

Do not apply translations from `reports/reviewed/`, the combined template, or
ad hoc CSV names.

Generate the combined template and create any missing authoritative locale
CSVs. The splitter preserves the canonical columns and row order. It will not
overwrite existing reviewer work:

```powershell
py scripts\translate_ch_packs.py export --output reports\ch_translation_template.csv
py scripts\split_ch_translation_template.py
```

Fill every `translated_text` cell in the three authoritative locale CSVs and
review the translations. To intentionally replace stale locale files from the
combined template, use:

```powershell
py scripts\split_ch_translation_template.py --force
```

Mine reusable templates, create starter phrasebooks if they are missing, and
generate deterministic autofilled CSVs without changing the authoritative
review inputs:

```powershell
.\scripts\run_ch_template_autofill.ps1
```

This writes:

- `reports/templates_<locale>.csv`
- `reports/template_stats_<locale>.json`
- `reports/phrasebook_<locale>.csv`
- `reports/ch_translation_template.<locale>.autofilled.csv`
- `reports/residual_unmatched_<locale>.csv`

Add reviewed templates to the phrasebooks and rerun until the residual CSVs
contain only rows that need individual review.

Apply all three reviewed locale CSVs with the guarded wrapper. It fails before
writing packs if a required file is missing, a file contains the wrong locale,
or any `translated_text` cell is blank. On success it writes the four runtime
JSONLs under each matching `assets/packs/<locale>/` directory and runs the CH
pack validator:

```powershell
.\scripts\apply_ch_translations_filled.ps1
Get-Content translation_report.csv
```

Validate the generated CH JSONLs:

```powershell
dart run tools\validate_packs.dart --enable-ch-packs
py scripts\validate_content_quality.py --strict-ch
```

Run the automated Flutter smoke test for `en-GB`, `de-CH`, `fr-CH`, and
`it-CH`, then launch the CH-enabled app and switch through those locales:

```powershell
flutter test test\widget_test.dart --plain-name "app boots without overflow for production locales"
flutter run -d chrome --dart-define=ENV=prod --dart-define=ENABLE_CH_PACKS=true
```

The CH release must remain blocked while strict validation reports untranslated
English segments.

## Next 5 Milestones

1. **CH content translation pipeline:** complete reviewed CSV coverage, remove
   residual English segments, and promote CH packs only after strict validation.
2. **Nordic rollout plan:** add `sv-SE`, `nb-NO`, and `da-DK` UI ARBs behind UAT
   gates; reuse English packs initially and localize stems through the CSV flow
   later.
3. **Arabic RTL prep:** complete UI-only RTL review, mirrored-layout smoke tests,
   and icon-direction checks while keeping packs English.
4. **Korean:** finish ARB review, run UAT typography checks, and keep Korean
   packs on the English fallback until localized stems are reviewed.
5. **Graphing roadmap integration:** add reviewed `graph_read` content for
   configured graph-required topics, then expand beyond Phase 1 line graphs.
