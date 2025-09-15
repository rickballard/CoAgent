$ErrorActionPreference='Stop'
$e   = "$HOME\Documents\GitHub\CoAgent\electron"
$npx = Join-Path $env:ProgramFiles 'nodejs\npx.cmd'
Set-Location $e
Remove-Item -Recurse -Force .\dist -ErrorAction SilentlyContinue
& $npx electron-builder -w dir
Compress-Archive -Path ".\dist\win-unpacked\*" -DestinationPath ".\dist\CoAgent-latest-win.zip" -Force
Write-Host "Built: $e\dist\win-unpacked and zipped: CoAgent-latest-win.zip"
