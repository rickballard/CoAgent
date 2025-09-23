Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Out-Status([string]$level,[string]$msg,[hashtable]$extra){
  $o=[ordered]@{ ts=(Get-Date).ToString("o"); level=$level; msg=$msg }
  if ($extra){ $extra.GetEnumerator() | ForEach-Object { $o[$_.Key]=$_.Value } }
  $o | ConvertTo-Json -Compress
}

$Downloads = Join-Path $HOME "Downloads"
$CoTemp    = Join-Path $Downloads "CoTemp"
$StatusDir = Join-Path $CoTemp "status"
New-Item -ItemType Directory -Force -Path $StatusDir | Out-Null
$log = Join-Path $StatusDir "status.ndjson"

$ok=$true
$items=@()

# PS7 check
$psok = ($PSVersionTable.PSEdition -eq "Core" -and $PSVersionTable.PSVersion -ge [version]"7.0")
$items += Out-Status (($psok)?"info":"error") "PS edition/version" @{ edition=$PSVersionTable.PSEdition; version="$($PSVersionTable.PSVersion)" }
$ok = $ok -and $psok

# PATH sanity (git, pwsh)
foreach($bin in @("git","pwsh")){
  $cmd=(Get-Command $bin -ErrorAction SilentlyContinue)
  $items += Out-Status (($cmd)? "info":"error") "bin present: $bin" @{ path=($cmd.Path ?? "") }
  $ok = $ok -and [bool]$cmd
}

# gh auth (optional)
$gha=$false
if (Get-Command gh -ErrorAction SilentlyContinue) {
  try { $st = gh auth status 2>&1; $gha = ($LASTEXITCODE -eq 0) } catch { $gha=$false }
  $items += Out-Status (($gha)?"info":"warn") "gh auth status" @{ ok=$gha; raw=("$st" -replace "`r","" -replace "`n"," ") }
} else {
  $items += Out-Status "warn" "gh not installed" @{}
}

# Runner alive?
$runner = Join-Path $Downloads "CoTemp\tools\CoPayloadRunner.ps1"
$job = Get-Job -Name "CoPayloadRunner" -ErrorAction SilentlyContinue
$alive = [bool]$job
$items += Out-Status (($alive)?"info":"warn") "CoPayloadRunner job" @{ alive=$alive; runnerPath=$runner }

# Crash sentinel (optional file any of your scripts can drop)
$crash = Test-Path (Join-Path $StatusDir "ps7_crash.flag")
$items += Out-Status (($crash)?"warn":"info") "PS7 crash sentinel" @{ crashFlag=$crash }

# Write NDJSON
$items | ForEach-Object { $_ } | Out-File -FilePath $log -Encoding UTF8
if (-not $ok) {
  # one toast (no notepad)
  try {
    $t = New-BurntToastNotification -Text "CoAgent BPOE recheck: issues found", "See $log" -Silent
  } catch { } # BurntToast not guaranteed; keep silent
  exit 1
} else { exit 0 }
