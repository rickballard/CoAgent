param(
  [string]$Downloads = (Join-Path $env:USERPROFILE "Downloads")
)
if (-not (Test-Path $Downloads)) { Write-Host "Downloads not found: $Downloads" -ForegroundColor Red; exit 1 }
$stamp = (Get-Date).ToString("yyyyMMdd_HHmmss")
$root  = Join-Path $Downloads ("Spanky_QA_Packs_{0}" -f $stamp)
New-Item -ItemType Directory -Force -Path $root | Out-Null

$BaseRegex = "^(?:\.(\d+[a-z]?)[-_])?Spanky_.*\.zip$"
Add-Type -AssemblyName System.IO.Compression.FileSystem | Out-Null
function Open-Zip([string]$z){ $fs=[IO.File]::OpenRead($z); $zip=[IO.Compression.ZipArchive]::new($fs,[IO.Compression.ZipArchiveMode]::Read,$false); ,$fs,$zip }
function Entries($zip){ foreach($e in $zip.Entries){ ($e.FullName -replace '\\','/').TrimStart('/') } }
function FirstLine($zip,$entry){ $e=$zip.GetEntry($entry); if(-not $e){return $null}; $sr=[IO.StreamReader]::new($e.Open()); try{ $l=$sr.ReadLine(); if($l){$l.Trim()}} finally{$sr.Dispose()} }
function Count-P($present,$pref){ @($present | ?{ $_ -like "$pref*" -and -not $_.EndsWith('/') }).Count }

$Required = @("_spanky/_copayload.meta.json","_spanky/_wrap.manifest.json","_spanky/checksums.json","_spanky/out.txt","transcripts/session.md")
$zips = Get-ChildItem -LiteralPath $Downloads -File -Force -Filter "*.zip" | ?{ $_.Name -match $BaseRegex } | sort LastWriteTime -desc

$bad=@()
foreach($zf in $zips){
  try{
    $fs,$zip = Open-Zip $zf.FullName
    try{
      $present = @(Entries $zip)
      $missing = @(); foreach($r in $Required){ if(-not ($present -contains $r)){ $missing += $r } }
      $t=Count-P $present "transcripts/"; $p=Count-P $present "payload/"; $n=Count-P $present "notes/"; $s=Count-P $present "summaries/"
      $status=FirstLine $zip "_spanky/out.txt"
      $mm=$null
      if($status -and $status -match '\[STATUS\]\s+items=(\d+)\s+transcripts=(\d+)\s+payload=(\d+)\s+notes=(\d+)\s+summaries=(\d+)'){
        $stT=[int]$Matches[2]; $stP=[int]$Matches[3]; $stN=[int]$Matches[4]; $stS=[int]$Matches[5]
        if(($stT -ne ($t+$p+$n+$s)) -or ($stP -ne $p) -or ($stN -ne $n) -or ($stS -ne $s)){ $mm="counts" }
      }
      $verdict = if($missing.Count -eq 0){ if($mm){"OK*"} else {"OK"} } else {"MISSING"}
      if($verdict -ne "OK"){ $bad += [pscustomobject]@{ FileName=$zf.Name; FullPath=$zf.FullName } }
    } finally { $zip.Dispose(); $fs.Dispose() }
  } catch {
    $bad += [pscustomobject]@{ FileName=$zf.Name; FullPath=$zf.FullName }
  }
}

if (-not $bad -or $bad.Count -eq 0) { Write-Host "All Spanky zips appear OK. No QA packs needed." -ForegroundColor Green; exit 0 }

foreach($b in $bad){
  $name = $b.FileName
  $key  = ($name -replace "^(?:\.(\d+[a-z]?)[-_])?Spanky_","") -replace "_\d{8}_\d{6}\.zip$",""
  $key  = ($key -split "_")[0]
  $pack = Join-Path $root ($name -replace "\.zip$","")
  New-Item -ItemType Directory -Force -Path $pack | Out-Null

  Copy-Item -LiteralPath $b.FullPath -Destination (Join-Path $pack $name) -Force

@"
# DO: Self-verify & repair deliverable (READ-ONLY first, then rebuild)
`$SessionKey = '$key'
`$Basic = Join-Path `$env:USERPROFILE 'Downloads\Verify-SpankyDeliverables.ps1'   # optional
`$Deep  = Join-Path `$env:USERPROFILE 'Downloads\Verify-SpankyDeliverables-Plus.ps1' # optional

# Preferred (repo version):
`$RepoOps = 'C:\Users\Chris\Documents\GitHub\CoAgent\ops'
if (Test-Path (Join-Path `$RepoOps 'Spanky-GlobalVerify.ps1')) { & (Join-Path `$RepoOps 'Spanky-GlobalVerify.ps1') }

# If MISSING/ERROR or counts mismatch persists:
#  1) Rebuild your Spanky_$key_<timestamp>.zip with required layout.
#  2) Ensure _spanky/out.txt first line matches actual counts.
#  3) Re-run verify and post the 'Spanky ready: ...' line.
"@ | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $pack 'CoPing.ps1')

@"
# QA PROMPT — $key (Self-Assessment by Session)

## 0) Structure
- Required files present? out.txt counts correct?

## 1) Intent completeness
- Scope, audience, interfaces; mark gaps in INTENTIONS.md (Unfinished).

## 2) Traceability
- Link repos/issues/prior sessions in SOURCES.md.

## 3) Coherence
- Dedupe contradictions into DEPRECATED.md with pointers; keep GLOSSARY terms consistent.

## 4) Dual-face readiness
- AI-face facts & permalinks; human-face narrative/diagrams. Update WEBSITE_MANIFEST.md.

## 5) Exit
- Regenerate zip only when counts correct, no unresolved MISSING_* (or justified), and verifier prints “Spanky ready:”.
"@ | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $pack 'QA_PROMPT.md')
}

Write-Host "QA packs ready: $root" -ForegroundColor Green
