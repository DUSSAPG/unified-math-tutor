param(
    [switch]$ExportOnly
)

$ErrorActionPreference = "Stop"

if ($ExportOnly) {
    py scripts\translate_ch_packs.py export --output reports\ch_translation_template.csv
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    py scripts\split_ch_translation_template.py
    exit $LASTEXITCODE
}

.\scripts\apply_ch_translations.ps1
exit $LASTEXITCODE
