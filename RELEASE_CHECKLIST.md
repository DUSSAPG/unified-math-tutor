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

Validate UI localization coverage:

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
