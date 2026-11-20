# Pass all arguments directly to the workspace's isolated Python toolchain.
$ErrorActionPreference = 'Stop'
$runtime = Join-Path $PSScriptRoot '.venv/Scripts/python.exe'
if (-not (Test-Path -LiteralPath $runtime)) {
    throw 'Run .\scripts\setup-slides.ps1 first.'
}
& $runtime (Join-Path $PSScriptRoot 'scripts/slides.py') @args
exit $LASTEXITCODE
