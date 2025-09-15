<#
  CoBreadcrumb: mine recent repo activity & session env into docs/status/bpoe-log.ndjson
  and append a short checklist into docs/index/TODO-INDEX.md
#>
param(
  [string]$Repo = (Join-Path $HOME 'Documents\GitHub\CoAgent'),
  [int]$Hours = 6
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$now = Get-Date
$since = $now.AddHours(-$Hours)
$bpoe = Join-Path $Repo 'docs\status\bpoe-log.ndjson'
$todo = Join-Path $Repo 'docs\index\TODO-INDEX.md'

# gather git deltas since $since
Push-Location $Repo
$log = git log --since="$($since.ToString('o'))" --name-only --pretty=format:"%H%x09%an%x09%ad%x09%s" 2>$null
Pop-Location

# current session hints
$session = $env:COAGENT_SESSION
$tag     = $env:COAGENT_TAG
$learn   = @()

if ($session) { $learn += "session='$session'" }
if ($tag)     { $learn += "tag='$tag'" }

# write ndjson entries
$entry = [ordered]@{
  ts = $now.ToString('o')
  session = $session
  notes = "CoBreadcrumb scan (last ${Hours}h)"
  git = $log -split "`n" | Where-Object { $_ } | Select-Object -First 200
}
$entry | ConvertTo-Json -Compress | Add-Content -Encoding UTF8 $bpoe

# append TODO crumbs
Add-Content -Encoding UTF8 $todo "`n- [ ] Review last ${Hours}h crumbs ($($now.ToString('g')))$([string]::IsNullOrEmpty($session) ? '' : " — $session")"

Write-Host "CoBreadcrumb wrote:" -ForegroundColor Green
Write-Host "  $bpoe" -ForegroundColor Cyan
Write-Host "  $todo" -ForegroundColor Cyan
