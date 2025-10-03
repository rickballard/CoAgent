Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
# Analyze-BPOE.ps1 — quick summary of local JSONL logs under .coagent/logs/*.jsonl
$root = (Get-Location).Path
$logDir = Join-Path $root ".coagent\logs"
if (!(Test-Path $logDir)) { Write-Host "ℹ️ No logs at $logDir"; exit 0 }

$files = Get-ChildItem $logDir -Filter *.jsonl -File -Recurse
if (!$files) { Write-Host "ℹ️ No *.jsonl logs found in $logDir"; exit 0 }

$counts = @{
  total = 0; ok = 0; fail = 0; guardrail = 0; duration_ms = 0
}

foreach($f in $files){
  Get-Content $f | ForEach-Object {
    if([string]::IsNullOrWhiteSpace($_)) { return }
    try {
      $j = $_ | ConvertFrom-Json
      $counts.total++
      if($j.status -eq 'ok'){ $counts.ok++ }
      if($j.status -eq 'fail'){ $counts.fail++ }
      if($j.guardrail -eq 'redirect'){ $counts.guardrail++ }
      if($j.duration_ms){ $counts.duration_ms += [int]$j.duration_ms }
    } catch { }
  }
}

$avg = 0
if($counts.total -gt 0 -and $counts.duration_ms -gt 0){
  $avg = [math]::Round($counts.duration_ms / $counts.total, 1)
}

"---- BPOE Summary ----"
"events: {0}" -f $counts.total
"ok/fail: {0}/{1}" -f $counts.ok, $counts.fail
"guardrail redirects: {0}" -f $counts.guardrail
"avg latency (ms): {0}" -f $avg
"----------------------"
