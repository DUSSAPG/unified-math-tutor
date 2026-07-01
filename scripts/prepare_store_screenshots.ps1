param(
    [string[]]$Markets = @("UK", "CH", "US", "SG")
)

$ErrorActionPreference = "Stop"
$root = "docs\store_readiness\screenshots"

foreach ($market in $Markets) {
    $target = Join-Path $root $market
    New-Item -ItemType Directory -Force -Path $target | Out-Null
    Write-Host "$market screenshots -> $target"
}

Write-Host "Capture the seven screens listed in docs\store_readiness\SCREENSHOT_MANIFEST.md."
