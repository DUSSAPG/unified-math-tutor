param(
    [string]$InputCsv = "audit_report.csv",
    [string]$OutputDir = "."
)

$ErrorActionPreference = "Stop"
$scriptPath = Join-Path $PSScriptRoot "export_remediation_plan.py"

py $scriptPath --input $InputCsv --output-dir $OutputDir
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}
