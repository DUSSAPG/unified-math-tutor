param(
    [switch]$EnableChPacks
)

$ErrorActionPreference = "Stop"

.\scripts\check_enabled_l10n.ps1
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$packArgs = @("run", "tools\validate_packs.dart")
if ($EnableChPacks) { $packArgs += "--enable-ch-packs" }
dart @packArgs
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$qualityArgs = @("scripts\validate_content_quality.py")
if ($EnableChPacks) { $qualityArgs += "--strict-ch" }
py @qualityArgs
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

py scripts\test_translate_ch_packs.py
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

py tools\test_ch_translation_workflow.py
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

flutter test
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

flutter analyze
exit $LASTEXITCODE
