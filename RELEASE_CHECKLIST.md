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

Build the default production release for UK, US, and SG:

```powershell
flutter build web --release --dart-define=ENV=prod
flutter build appbundle --release --dart-define=ENV=prod
```

Build the CH release only after the strict CH content gate passes:

```powershell
flutter build web --release --dart-define=ENV=prod --dart-define=ENABLE_CH_PACKS=true
flutter build appbundle --release --dart-define=ENV=prod --dart-define=ENABLE_CH_PACKS=true
```

Prepare store screenshot export folders:

```powershell
.\scripts\prepare_store_screenshots.ps1
```

## Linguistic approval gate

Three separate decisions apply to UI translations. One never implies another:

| Stage | What it means | Who or what decides | Evidence |
|---|---|---|---|
| Engineering integration | The code, ARB structure, generated localisations and tests are correct, and the branch can merge | Code review and the host test suite | PR, test results, `docs/qa/*` reports |
| Linguistic approval | A named reviewer has approved the exact text of a translation | A native or professional reviewer for that locale | An approval record in `docs/l10n_approvals/records/` |
| Production-release authorisation | A build may ship to the public | The release owner, after the release commands pass with `--env prod` | This checklist |

**How the gate works.** `scripts/l10n_approval_gate.py` runs inside `check_enabled_l10n.py`, and so inside `release_readiness.ps1`. For a production release (`--env prod`, the default) it fails if:

- **a draft remains:** any production-locale ARB (the locales come from `LocaleService.productionLocales`) still has a `PENDING LINGUISTIC REVIEW` marker;
- **an approval is missing or stale:** any key in `docs/l10n_approvals/required_keys.json` lacks a valid approval record for its current text. Removing a marker is never enough; editing an approved text needs a new review;
- **a record is malformed:** any approval record is missing the reviewer, date, locale, ARB file, ARB hash or per-key outcome and text hash;
- **the manifest is missing or malformed:** `required_keys.json` is absent, unreadable, has the wrong schema, lists no locales or names a non-production locale. The gate fails closed; it never treats a missing manifest as "nothing required".

**Environments.** `--env dev` and `--env uat` report the same findings without failing. Ordinary `flutter run` and `flutter build` don't run the gate at all.

**Output.** The report lists locales, keys and record file names only, never translation text or reviewer identities. The record format is in `docs/l10n_approvals/README.md`.

```powershell
py scripts\l10n_approval_gate.py --env prod   # release decision
py scripts\l10n_approval_gate.py --env uat    # report only
py scripts\check_enabled_l10n.py --env prod   # coverage + approval
```

**Limits.**

- **It is manual:** the gate is part of the documented release procedure, not of `flutter build`. There is no CI, so it is enforced only when this checklist is followed.
- **Coverage fails separately:** the coverage half of `check_enabled_l10n.py` (template keys missing in de_CH, fr_CH and it_CH) fails on its own, in every `--env`. On 2026-11-27 that was 272 keys per Swiss locale, which predates AS-1.
- **The gate checks evidence, not quality:** it verifies that records exist, are well formed and match the current text. It cannot verify that a review actually happened. Records must come from the reviewer and must never be fabricated.

**Current state (2026-11-28, Swiss Phase 2).** 754 Swiss translations are pending linguistic review: de_CH 267, fr_CH 256 and it_CH 231 (the 33 AS-1 drafts per locale plus the Phase 2 P0 batch). All of them are listed in `docs/l10n_approvals/required_keys.json`. Zero translations are approved and no approval record exists, so the production approval gate blocks a release. The gate is manual: `flutter build` does not run it, so it applies only when the release commands above are run. The coverage half of `check_enabled_l10n.py` still fails with 199 (de_CH), 200 (fr_CH) and 200 (it_CH) missing template keys. Review packages: `docs/l10n_review/swiss_phase2/`.

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
