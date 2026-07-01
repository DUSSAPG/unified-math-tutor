param(
    [switch]$Apply,
    [string]$InputDir = "assets/packs/en-GB",
    [string]$BackupDir = "backups/question_patches"
)

$ErrorActionPreference = "Stop"
$scriptPath = Join-Path $PSScriptRoot "patch_question_banks.py"
$arguments = @($scriptPath, "--input-dir", $InputDir, "--backup-dir", $BackupDir)

if ($Apply) {
    $arguments += "--apply"
}

py @arguments
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}
