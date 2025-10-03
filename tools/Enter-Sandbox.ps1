Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
# Enter-Sandbox.ps1 — writes a local sandbox config and prints guidance
$root = (Get-Location).Path
$cfgDir = Join-Path $root ".coagent"
$cfg = Join-Path $cfgDir "sandbox.config.json"
New-Item -ItemType Directory -Force $cfgDir | Out-Null

$payload = @{
  net = @{ egress = $false }
  notes = "CoCivium sandbox preset. Tools should avoid outbound network."
  updated = (Get-Date).ToString("s")
}

$payload | ConvertTo-Json -Depth 5 | Set-Content -Encoding UTF8 $cfg
Write-Host "✅ Sandbox ON — wrote $cfg"
Write-Host "   Conventions: respect NO_NETWORK=1 and ./tools/* should short-circuit egress."
$env:NO_NETWORK = "1"
Write-Host "   Session env set: NO_NETWORK=1 (effective for this shell)"
