param(
  [int]$DelaySec = 300,    # first recheck after launch (default 5 minutes)
  [int]$RepeatMin = 60     # subsequent periodic checks (default hourly)
)
Set-StrictMode -Version Latest
$ErrorActionPreference = "SilentlyContinue"

Start-Sleep -Seconds $DelaySec

$ct   = Join-Path $env:USERPROFILE "Downloads\CoTemp"
$log  = Join-Path $ct "CoHealth.log"
$psh  = Join-Path $env:ProgramFiles "PowerShell\7\pwsh.exe"
$runner = Join-Path $ct "tools\CoPayloadRunner.ps1"

if (!(Test-Path $ct)) { New-Item -ItemType Directory -Force -Path $ct | Out-Null }

function Write-Health($msg){
  $ts = Get-Date -Format o
  "$ts `t $msg" | Add-Content -Encoding UTF8 $log
}

function Ensure-Runner {
  if (Test-Path $runner) {
    try {
      # if no runner process is executing our ps1, kick a one-shot run
      $busy = Get-Process pwsh -ErrorAction SilentlyContinue | Where-Object {
        ($_.Path -like "*\PowerShell\7\pwsh.exe") -and
        (Get-CimInstance Win32_Process -Filter "ProcessId=$($_.Id)").CommandLine -match "CoPayloadRunner\.ps1"
      }
      if (-not $busy) {
        Write-Health "Runner not detected -> invoking -Once"
        & $runner -Once
      } else {
        Write-Health "Runner detected"
      }
    } catch {
      Write-Health "Runner check error: $($_.Exception.Message)"
    }
  } else {
    Write-Health "Runner missing at $runner"
  }
}

function Ensure-PS7-Responsive {
  try {
    $ps = Get-Process pwsh -ErrorAction SilentlyContinue
    if (-not $ps) {
      Write-Health "No PS7 consoles running (this may be fine)"
      return
    }
    foreach($p in $ps){
      if ($p.Responding -eq $false) {
        Write-Health "Unresponsive PS7 (PID $($p.Id)) -> attempt close"
        try { $p.CloseMainWindow() | Out-Null; Start-Sleep 2; if(!$p.HasExited){ $p.Kill() } } catch {}
      }
    }
  } catch {
    Write-Health "PS7 probe error: $($_.Exception.Message)"
  }
}

Write-Health "=== CoAgent recheck cycle start ==="
Ensure-Runner
Ensure-PS7-Responsive
Write-Health "=== CoAgent recheck cycle end ==="

# schedule next run using Windows Scheduled Tasks (self-rescheduling pattern)
try {
  $task = "CoAgent-Recheck"
  $xml = @"
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.4" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <Triggers>
    <TimeTrigger>
      <StartBoundary>$((Get-Date).AddMinutes($RepeatMin).ToString("s"))</StartBoundary>
      <Enabled>true</Enabled>
    </TimeTrigger>
  </Triggers>
  <Principals>
    <Principal id="Author">
      <RunLevel>LeastPrivilege</RunLevel>
      <LogonType>InteractiveToken</LogonType>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>true</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <IdleSettings>
      <StopOnIdleEnd>false</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT5M</ExecutionTimeLimit>
    <Priority>7</Priority>
  </Settings>
  <Actions Context="Author">
    <Exec>
      <Command>$psh</Command>
      <Arguments>-NoLogo -NoProfile -ExecutionPolicy Bypass -File "$PSCommandPath" -DelaySec 0 -RepeatMin $RepeatMin</Arguments>
      <WorkingDirectory>$ct</WorkingDirectory>
    </Exec>
  </Actions>
</Task>
"@
  $tmp = Join-Path $ct "recheck.xml"
  $xml | Set-Content -Encoding Unicode $tmp
  schtasks /Create /TN $task /XML $tmp /F | Out-Null
  Write-Health "Scheduled next recheck in $RepeatMin min via Task '$task'"
} catch {
  Write-Health "Could not schedule next recheck (likely no admin needed/available): $($_.Exception.Message)"
}
