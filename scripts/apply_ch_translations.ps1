param(
    [switch]$UseFilled
)

$ErrorActionPreference = "Stop"

$locales = @("de-CH", "fr-CH", "it-CH")

function Fail-ChPipeline {
    param([string]$Message)
    Write-Host ""
    Write-Host "CH TRANSLATION PIPELINE: FAIL" -ForegroundColor Red
    Write-Host $Message -ForegroundColor Red
    Write-Host ""
    Write-Host "Next actions:"
    Write-Host "  1. Generate review CSVs with: .\scripts\run_ch_autofill.ps1"
    Write-Host "  2. Review the reported filled locale CSV."
    Write-Host "  3. Re-run: .\scripts\apply_ch_translations_filled.ps1"
    exit 1
}

try {
    foreach ($locale in $locales) {
        $suffix = if ($UseFilled) { ".filled" } else { "" }
        $csv = "reports\ch_translation_template.$locale$suffix.csv"
        if (-not (Test-Path -LiteralPath $csv)) {
            Fail-ChPipeline "Missing authoritative review CSV: $csv"
        }

        $rows = @(Import-Csv -LiteralPath $csv -Encoding UTF8)
        if ($rows.Count -eq 0) {
            Fail-ChPipeline "$csv contains no review rows."
        }

        $requiredColumns = @(
            "locale",
            "segment_hash",
            "source_text",
            "translated_text",
            "occurrences",
            "sample_locations"
        )
        $columns = @($rows[0].PSObject.Properties.Name)
        if (Compare-Object -ReferenceObject $requiredColumns -DifferenceObject $columns) {
            Fail-ChPipeline "$csv does not use the required canonical columns."
        }

        $wrongLocales = @($rows | Where-Object { $_.locale -ne $locale })
        if ($wrongLocales.Count -gt 0) {
            Fail-ChPipeline "$csv must contain only $locale rows; found $($wrongLocales.Count) mismatched rows."
        }

        $missing = @($rows | Where-Object { [string]::IsNullOrWhiteSpace($_.translated_text) })
        if ($missing.Count -gt 0) {
            Fail-ChPipeline "$csv has $($missing.Count) rows with missing translated_text."
        }
        Write-Host "[OK] ${csv}: $($rows.Count) reviewed rows"
    }

    foreach ($locale in $locales) {
        $suffix = if ($UseFilled) { ".filled" } else { "" }
        $csv = "reports\ch_translation_template.$locale$suffix.csv"
        py scripts\translate_ch_packs.py apply --locale $locale --translations $csv
        if ($LASTEXITCODE -ne 0) {
            Fail-ChPipeline "Apply failed for $locale."
        }
    }

    dart run tools\validate_packs.dart --enable-ch-packs
    if ($LASTEXITCODE -ne 0) {
        Fail-ChPipeline "CH pack validation failed."
    }
} catch {
    Fail-ChPipeline $_.Exception.Message
}

Write-Host ""
Write-Host "CH TRANSLATION PIPELINE: PASS" -ForegroundColor Green
Write-Host "All three locale CSVs were applied and CH pack validation passed."
Write-Host ""
Write-Host "Next actions:"
Write-Host "  1. Run: py scripts\validate_content_quality.py --strict-ch"
Write-Host "  2. Run: flutter test"
