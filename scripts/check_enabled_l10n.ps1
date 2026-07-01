$ErrorActionPreference = 'Stop'

flutter gen-l10n
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

py scripts\check_enabled_l10n.py
exit $LASTEXITCODE

