param([switch]$Open)
$ErrorActionPreference='Stop'
$e   = "$HOME\Documents\GitHub\CoAgent\electron"
$npm = Join-Path $env:ProgramFiles 'nodejs\npm.cmd'
Set-Location $e
Remove-Item -Recurse -Force .\dist -ErrorAction SilentlyContinue
& $npm run dist
if ($Open) { Start-Process "$e\dist" }
