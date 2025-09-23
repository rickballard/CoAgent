param([string]$SessionUrl)

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
Start-Process -FilePath $pwsh -ArgumentList @('-NoLogo','-NoProfile','-NoExit','-Command', "& { $pwsh -NoLogo -NoProfile -File `"$orch`" -SessionUrl `"$SessionUrl`" }" ) 
