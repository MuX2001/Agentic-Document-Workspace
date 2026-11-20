[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$workspace = Split-Path -Parent $PSScriptRoot
$runtime = Join-Path $workspace '.venv/Scripts/python.exe'
if (-not (Test-Path -LiteralPath $runtime)) {
    & python -m venv (Join-Path $workspace '.venv')
    if ($LASTEXITCODE -ne 0) { throw 'Could not create the Python environment.' }
}
& $runtime (Join-Path $PSScriptRoot 'install-slides-deps.py')
if ($LASTEXITCODE -ne 0) { throw 'Could not install the slide dependencies.' }
& $runtime (Join-Path $PSScriptRoot 'prepare-typst-packages.py')
if ($LASTEXITCODE -ne 0) { throw 'Could not download Touying.' }
& $runtime (Join-Path $PSScriptRoot 'slides.py') doctor
if ($LASTEXITCODE -ne 0) { throw 'Slide toolchain validation failed.' }
