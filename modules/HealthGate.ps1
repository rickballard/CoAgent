# requires -Version 7
[CmdletBinding()]
param(
  [switch]$Json,
  [string]$OutDir = (Join-Path $PSScriptRoot '..\health'),
  [int]$IdleMemWarnPct = 80
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$null = New-Item -ItemType Directory -Force $OutDir

function Get-ActiveAV {
  try {
    $def = Get-Service WinDefend -ErrorAction Stop
    $mp  = Get-Command Get-MpComputerStatus -ErrorAction Stop
    $s   = Get-MpComputerStatus
    if ($s.AMServiceEnabled) { return 'Microsoft Defender' }
  } catch {}
  try {
    $mb = Get-Service MBAMService -ErrorAction Stop
    if ($mb.Status -ne $null) { return 'Malwarebytes' }
  } catch {}
  return 'Unknown/None Detected'
}

function Get-NicSummary {
  $a = Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} |
       Select-Object Name, LinkSpeed
  $e = Get-NetAdapterStatistics | Select-Object Name, ReceivedErrors, OutboundErrors, ReceivedDiscarded, SentDiscarded
  @{ Adapters = $a; Errors = $e }
}

function Get-StorageSummary {
  $p = Get-PhysicalDisk | Select FriendlyName, MediaType, Size, HealthStatus, OperationalStatus
  $v = Get-PSDrive -PSProvider FileSystem | Select Name,
      @{n='UsedGB';e={[math]::Round($_.Used/1GB,1)}},
      @{n='FreeGB';e={[math]::Round($_.Free/1GB,1)}}
  $trim = (fsutil behavior query DisableDeleteNotify) 2>$null
  @{ Physical = $p; Volumes = $v; TrimRaw = $trim }
}

function Get-ReliabilitySummary {
  try {
    $rel = Get-CimInstance -Namespace root\cimv2 -ClassName Win32_ReliabilityRecords -ErrorAction Stop |
      Where-Object { $_.TimeGenerated -gt (Get-Date).AddDays(-7) }
    $top = $rel | Group-Object -Property SourceName | Sort-Object Count -Descending | Select-Object -First 10
    return $top | Select Name,Count
  } catch { return @() }
}

# CPU/Power
$scheme = (powercfg /GetActiveScheme) -join ' '
$cpuMax = (Get-Counter '\Processor Information(_Total)\% of Maximum Frequency').CounterSamples.CookedValue
$mem   = Get-CimInstance Win32_OperatingSystem | Select-Object TotalVisibleMemorySize, FreePhysicalMemory
$memPctUsed = [math]::Round((($mem.TotalVisibleMemorySize - $mem.FreePhysicalMemory)/$mem.TotalVisibleMemorySize)*100,1)

# Storage/Network/AV
$stor = Get-StorageSummary
$nic  = Get-NicSummary
$av   = Get-ActiveAV

# Basic verdicts
$issues = @()
if ($cpuMax -lt 95) { $issues += "CPU MaxFrequency reported ${cpuMax:n1}% (<95%). Check power plan / thermals." }
$lowFree = $stor.Volumes | Where-Object { $_.FreeGB -lt  (($_.UsedGB+$_.FreeGB)*0.20) } |
           ForEach-Object { "$($_.Name): low free space ($($_.FreeGB) GB)" }
$issues += $lowFree
if ($memPctUsed -gt 80) { $issues += "Memory high at idle: ${memPctUsed}% used." }

# Report
$report = [ordered]@{
  Timestamp = (Get-Date).ToString('s')
  PowerPlan = $scheme
  CpuMaxFrequencyPct = [math]::Round($cpuMax,1)
  MemoryUsedPct = $memPctUsed
  ActiveAV = $av
  Storage = $stor
  Network = $nic
  ReliabilityTop = Get-ReliabilitySummary
  Issues = $issues
  Verdict = if ($issues.Count -eq 0) { 'PASS' } else { 'WARN' }
}

$md = @()
$md += "# HealthGate Report"
$md += "*Time:* $(Get-Date)"
$md += "*Verdict:* **$($report.Verdict)**"
$md += ""
$md += "## Power/CPU"
$md += "- Plan: `$($report.PowerPlan)`"
$md += "- Max Frequency: $($report.CpuMaxFrequencyPct)%"
$md += "- Memory used: $($report.MemoryUsedPct)%"
$md += ""
$md += "## Storage"
$report.Storage.Physical | ForEach-Object { $md += "- $($_.FriendlyName): $($_.MediaType) $([math]::Round($_.Size/1GB))GB, $($_.HealthStatus)/$($_.OperationalStatus)" }
$md += "Volumes:"
$report.Storage.Volumes | ForEach-Object { $md += "  - $($_.Name): Used $($_.UsedGB) GB, Free $($_.FreeGB) GB" }
$md += ""
$md += "## Network"
$report.Network.Adapters | ForEach-Object { $md += "- $($_.Name): $($_.LinkSpeed)" }
$md += "Errors:"
$report.Network.Errors | ForEach-Object { $md += "- $($_.Name): RXErr=$($_.ReceivedErrors) TXErr=$($_.OutboundErrors) RXDrop=$($_.ReceivedDiscarded) TXDrop=$($_.SentDiscarded)" }
$md += ""
$md += "## Active AV"
$md += "- $($report.ActiveAV)"
$md += ""
$md += "## Reliability (7d Top offenders)"
$report.ReliabilityTop | ForEach-Object { $md += "- $($_.Name): $($_.Count)" }
$md += ""
$md += "## Issues"
if ($report.Issues.Count) { $report.Issues | ForEach-Object { $md += "- $_" } } else { $md += "- None" }

$mdPath = Join-Path $OutDir "HealthGateReport.md"
$jsPath = Join-Path $OutDir "HealthGateReport.json"
$md -join "`r`n" | Set-Content $mdPath -Encoding UTF8
$report | ConvertTo-Json -Depth 6 | Set-Content $jsPath -Encoding UTF8

if ($Json) { $report | ConvertTo-Json -Depth 6 } else { Write-Host "Report written:`n$mdPath`n$jsPath"; if ($report.Verdict -ne 'PASS') { exit 2 } }
