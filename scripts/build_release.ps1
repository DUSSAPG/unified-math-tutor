<#
.SYNOPSIS
Required entry point for production builds: validates localisation and
linguistic approval, then runs the approved Flutter production build.

.DESCRIPTION
Runs scripts/release_build_gate.py, which checks the repository state, the
production locale configuration, flutter pub get and gen-l10n, the
localisation completeness check, the linguistic approval gate (--env prod)
and the pack validation for the chosen release path. The build starts only
if every check passes. Each run writes a provenance record to
build/release_provenance/.

There is no option to force, skip or bypass a check. Running `flutter build`
directly is still technically possible and is NOT protected by this wrapper;
see RELEASE_CHECKLIST.md.

.EXAMPLE
.\scripts\build_release.ps1 -Environment prod -Target appbundle
.\scripts\build_release.ps1 -Environment prod -Target appbundle -EnableChPacks
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('prod')]
    [string]$Environment,

    [Parameter(Mandatory = $true)]
    [ValidateSet('appbundle', 'web')]
    [string]$Target,

    [switch]$EnableChPacks
)

$ErrorActionPreference = 'Stop'

$python = Get-Command py -ErrorAction SilentlyContinue
if (-not $python) {
    Write-Error 'Python launcher "py" not found; the release gate cannot run.'
    exit 1
}

$gateArgs = @('-B', (Join-Path $PSScriptRoot 'release_build_gate.py'),
    '--env', $Environment, '--target', $Target)
if ($EnableChPacks) { $gateArgs += '--enable-ch-packs' }

Push-Location (Split-Path -Parent $PSScriptRoot)
try {
    & $python.Source @gateArgs
    $code = $LASTEXITCODE
}
finally {
    Pop-Location
}
exit $code
