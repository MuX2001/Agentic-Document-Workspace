param([Parameter(Mandatory)][string]$Brief)
$ErrorActionPreference = 'Stop'
$briefPath = (Resolve-Path -LiteralPath $Brief).Path
$task = Get-Content -Raw -Encoding UTF8 -LiteralPath $briefPath
$OutputEncoding = [Text.UTF8Encoding]::new($false)
Push-Location -LiteralPath $PSScriptRoot
try {
    "绘图任务来自 $briefPath 。相对素材路径以该文件所在目录为准。`n$task" | codex.cmd exec --sandbox workspace-write --skip-git-repo-check -
    $result = $LASTEXITCODE
} finally {
    Pop-Location
}
exit $result
