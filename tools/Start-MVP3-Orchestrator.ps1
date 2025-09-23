param([string]$SessionUrl)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Info($m){ Write-Host "[MVP3-Orchestrator] $m" }
function Timestamp { (Get-Date).ToString('yyyyMMdd-HHmmss') }

# Load NoPopups guard if present
$np = Join-Path (Split-Path $PSCommandPath -Parent) 'NoPopups.ps1'
if (Test-Path $np) { . $np }

# runtime dirs
$Downloads     = Join-Path $HOME 'Downloads'
$CoTemp        = Join-Path $Downloads 'CoTemp'
$TempDumpRoot  = Join-Path $Downloads 'CoAgent_Temp_Dumps'
$PairsRoot     = Join-Path $CoTemp 'pairs'
$StatusRoot    = Join-Path $CoTemp 'status'
New-Item -ItemType Directory -Force -Path $CoTemp,$TempDumpRoot,$PairsRoot,$StatusRoot | Out-Null

function Remove-CoAgentTemp {
  param([Parameter(Mandatory)][string]$Path)
  if (-not (Test-Path $Path)) { return }
  try {
    Remove-Item -Recurse -Force -LiteralPath $Path -ErrorAction Stop
    Write-Info "Deleted temp: $Path"
  } catch {
    $stamp = $(Timestamp)
    $name  = (Split-Path $Path -Leaf)
    $dest  = Join-Path $TempDumpRoot ("{0}__{1}" -f $name, $stamp)
    Copy-Item -Recurse -Force -LiteralPath $Path -Destination $dest
    Remove-Item -Recurse -Force -LiteralPath $Path -ErrorAction SilentlyContinue
    Write-Info "Temp delete failed; DUMPED to: $dest"
  }
}

# Pairing helpers
function Normalize-SessionId { param([string]$InputId) $raw=$InputId.Trim(); $slug=($raw -replace '[^a-zA-Z0-9\-]+','_'); @{ raw=$raw; slug=$slug } }
function Get-WindowId { if ($env:WT_SESSION) { return $env:WT_SESSION } else { return [Guid]::NewGuid().ToString() } }

function New-CoAgentPair {
  param([Parameter(Mandatory)][string]$SessionId, [string]$WindowId = (Get-WindowId))
  $id = Normalize-SessionId -InputId $SessionId
  $pairFile = Join-Path $PairsRoot ("pair_{0}.json" -f $id.slug)
  @{ session_raw=$id.raw; session_slug=$id.slug; window=$WindowId; created=(Get-Date).ToString('o') } |
    ConvertTo-Json | Out-File -FilePath $pairFile -Encoding UTF8
  Write-Info "Paired session '$($id.raw)' with window '$WindowId' -> $pairFile"
  return $pairFile
}

# schedule a 5-min recheck in background
$RecheckScript = {
  Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
  $Downloads  = Join-Path $HOME 'Downloads'
  $StatusRoot = Join-Path $Downloads 'CoTemp\status'
  New-Item -ItemType Directory -Force -Path $StatusRoot | Out-Null
  $marker = Join-Path $StatusRoot 'bpoe_recheck_ran.txt'
  "Ran at $(Get-Date -Format o)`nPSVersion=$($PSVersionTable.PSVersion)" | Out-File -FilePath $marker -Encoding UTF8
  Write-Host "[MVP3-Recheck] Marker: $marker"
}
Start-Job -ScriptBlock { Start-Sleep -Seconds 300; & pwsh -NoLogo -NoProfile -Command $using:RecheckScript } | Out-Null

# hook CoPayloadRunner if present
$Runner = Join-Path $Downloads 'CoTemp\tools\CoPayloadRunner.ps1'
if (Test-Path $Runner) {
  Write-Info "Launching CoPayloadRunner watcher…"
  Start-Job -Name 'CoPayloadRunner' -ScriptBlock { & pwsh -NoLogo -NoProfile -File $using:Runner } | Out-Null
} else {
  Write-Info "No CoPayloadRunner at $Runner (ok)."
}

# Pair using provided SessionUrl or fallback
if (-not $SessionUrl) { $SessionUrl = 'REPLACE_ME_WITH_URL' }
New-CoAgentPair -SessionId $SessionUrl | Out-Null
Write-Info "Orchestrator running. URL paired."

# Keep process alive in interactive run so you can see logs (this only triggers when run directly)
if ($Host.UI.RawUI.KeyAvailable -or $env:COAGENT_INTERACTIVE -eq '1') {
  Write-Info "Interactive hold enabled. Press Ctrl+C to exit."
  while ($true) { Start-Sleep -Seconds 5 }
}
