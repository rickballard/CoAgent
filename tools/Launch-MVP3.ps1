param([string]$SessionUrl)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ensure no popups for the launched processes
[Environment]::SetEnvironmentVariable('COAGENT_NO_POPUPS','1','Process')

# --- Intro Handshake (terminal banner, no UI popups) ---
try {
  $CoRoot   = Split-Path $PSCommandPath -Parent | Split-Path -Parent
  $handoffs = Get-ChildItem -Path (Join-Path $CoRoot "payloads\mvp3-resume") -Recurse -File -Filter Intro_Handshake_Message.txt -ErrorAction SilentlyContinue |
              Sort-Object LastWriteTime -Descending | Select-Object -First 1
  $msg = if ($handoffs) { Get-Content $handoffs.FullName -Raw } else {
@"
CoAgent MVP3 — First Run
This launcher will:
  • Pair this chat URL with your PS7 panel (no popups)
  • Start the orchestrator (watchers + 5-min recheck)
  • Respect COAGENT_NO_POPUPS=1
"@
  }
  Write-Host ""
  Write-Host ("="*72)
  Write-Host "CoAgent MVP3 — Intro Handshake"
  Write-Host ("-"*72)
  Write-Host ($msg.Trim())
  Write-Host ""
  Write-Host ("URL pairing: {0}" -f $SessionUrl)
  Write-Host ("NoPopups: {0}" -f ($env:COAGENT_NO_POPUPS ?? "0"))
  Write-Host ("="*72)
  Write-Host ""
} catch {
  Write-Warning "Intro Handshake banner failed: $(param([string]$SessionUrl)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ensure no popups for the launched processes
[Environment]::SetEnvironmentVariable('COAGENT_NO_POPUPS','1','Process')

# open the chat URL in browser
Start-Process $SessionUrl

# run the orchestrator in a visible interactive shell (so you can see output)
$orch = Join-Path (Split-Path $PSCommandPath -Parent) 'Start-MVP3-Orchestrator.ps1'
if (-not (Test-Path $orch)) { throw "Orchestrator not found: $orch" }

# Run orchestrator directly in this new pwsh process (blocking) to keep it visible for now
$pwsh = (Get-Command pwsh).Path
$pwsh = (Get-Command pwsh).Path
Start-Process -FilePath $pwsh -ArgumentList @("-NoLogo","-NoProfile","-NoExit","-File", $orch, "-SessionUrl", $SessionUrl) | Out-Null
# Optional: if Windows Terminal exists, add a 2nd tab that tails status.ndjson
$wt = (Get-Command wt -ErrorAction SilentlyContinue).Path
if ($wt) {
  $log = Join-Path $HOME 'Downloads\CoTemp\status\status.ndjson'
  Start-Process $wt -ArgumentList @(
    'new-tab','pwsh','-NoLogo','-NoProfile','-NoExit','-Command', "if (Test-Path `"$log`") { Get-Content `"$log`" -Wait -Tail 200 } else { Write-Host 'No status log yet...' }"
  ) | Out-Null
}
.Exception.Message)"
}
# --- End Intro Handshake ---

# open the chat URL in browser
Start-Process $SessionUrl

# run the orchestrator in a visible interactive shell (so you can see output)
$orch = Join-Path (Split-Path $PSCommandPath -Parent) 'Start-MVP3-Orchestrator.ps1'
if (-not (Test-Path $orch)) { throw "Orchestrator not found: $orch" }

# Run orchestrator directly in this new pwsh process (blocking) to keep it visible for now
$pwsh = (Get-Command pwsh).Path
$pwsh = (Get-Command pwsh).Path
Start-Process -FilePath $pwsh -ArgumentList @("-NoLogo","-NoProfile","-NoExit","-File", $orch, "-SessionUrl", $SessionUrl) | Out-Null
# Optional: if Windows Terminal exists, add a 2nd tab that tails status.ndjson
$wt = (Get-Command wt -ErrorAction SilentlyContinue).Path
if ($wt) {
  $log = Join-Path $HOME 'Downloads\CoTemp\status\status.ndjson'
  Start-Process $wt -ArgumentList @(
    'new-tab','pwsh','-NoLogo','-NoProfile','-NoExit','-Command', "if (Test-Path `"$log`") { Get-Content `"$log`" -Wait -Tail 200 } else { Write-Host 'No status log yet...' }"
  ) | Out-Null
}

