$ErrorActionPreference = "Stop"

py scripts\mine_translation_templates.py
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

py scripts\seed_ch_phrasebooks.py
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

foreach ($locale in @("de-CH", "fr-CH", "it-CH")) {
    $inputCsv = "reports\ch_translation_template.$locale.csv"
    $phrasebook = "reports\phrasebook_$locale.csv"
    $outputCsv = "reports\ch_translation_template.$locale.autofilled.csv"
    $residualCsv = "reports\residual_unmatched_$locale.csv"

    py scripts\autofill_ch_translation_csv.py `
        --in-csv $inputCsv `
        --phrasebook $phrasebook `
        --out-csv $outputCsv `
        --residual-csv $residualCsv
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}
