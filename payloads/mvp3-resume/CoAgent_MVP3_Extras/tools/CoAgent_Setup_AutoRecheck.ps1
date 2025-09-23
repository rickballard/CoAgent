# Creates a per-user logon task that runs the recheck 5 minutes after logon.
param([int]$DelayMin = 5)
$ErrorActionPreference = "Stop"
$ct    = Join-Path $env:USERPROFILE "Downloads\CoTemp"
$rechk = Join-Path $ct "tools\CoAgent_Recheck.ps1"
if (!(Test-Path $rechk)) { throw "Missing $rechk. Copy tools first." }
$pwsh = Join-Path $env:ProgramFiles "PowerShell\7\pwsh.exe"

$task  = "CoAgent-InitialRecheck"
$time  = (Get-Date).AddMinutes($DelayMin).ToString("s")
$xml = @"
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.4" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <Triggers>
    <LogonTrigger>
      <Enabled>true</Enabled>
      <Delay>PT${DelayMin}M</Delay>
    </LogonTrigger>
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
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
  </Settings>
  <Actions Context="Author">
    <Exec>
      <Command>$pwsh</Command>
      <Arguments>-NoLogo -NoProfile -ExecutionPolicy Bypass -File "$rechk"</Arguments>
      <WorkingDirectory>$ct</WorkingDirectory>
    </Exec>
  </Actions>
</Task>
"@
$tmp = Join-Path $ct "initial_recheck.xml"
$xml | Set-Content -Encoding Unicode $tmp
schtasks /Create /TN $task /XML $tmp /F
Write-Host "[OK] Created logon recheck task ($DelayMin min delay)"
