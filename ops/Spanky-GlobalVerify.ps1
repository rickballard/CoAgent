param(
  [string]$Downloads = (Join-Path $env:USERPROFILE "Downloads")
)
if (-not (Test-Path $Downloads)) { Write-Host "Downloads not found: $Downloads" -ForegroundColor Red; exit 1 }

$BaseRegex = "^(?:\.(\d+[a-z]?)[-_])?Spanky_.*\.zip$"
Add-Type -AssemblyName System.IO.Compression.FileSystem | Out-Null
function Open-Zip([string]$z){ $fs=[IO.File]::OpenRead($z); $zip=[IO.Compression.ZipArchive]::new($fs,[IO.Compression.ZipArchiveMode]::Read,$false); ,$fs,$zip }
function Entries($zip){ foreach($e in $zip.Entries){ ($e.FullName -replace '\\','/').TrimStart('/') } }
function FirstLine($zip,$entry){ $e=$zip.GetEntry($entry); if(-not $e){return $null}; $sr=[IO.StreamReader]::new($e.Open()); try{ $l=$sr.ReadLine(); if($l){$l.Trim()}} finally{$sr.Dispose()} }
function Count-P($present,$pref){ @($present | ?{ $_ -like "$pref*" -and -not $_.EndsWith('/') }).Count }

$zips = Get-ChildItem -LiteralPath $Downloads -File -Force -Filter "*.zip" | ?{ $_.Name -match $BaseRegex } | sort LastWriteTime -desc
if (-not $zips) { Write-Host "No Spanky zips found in $Downloads" -ForegroundColor Yellow; exit 0 }

$Required = @("_spanky/_copayload.meta.json","_spanky/_wrap.manifest.json","_spanky/checksums.json","_spanky/out.txt","transcripts/session.md")
$rows=@()
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
      $rows += [pscustomobject]@{
        FileName=$zf.Name; FullPath=$zf.FullName; Modified=$zf.LastWriteTime
        Verdict=$verdict; OutTxtStatus=$status; Transcripts=$t; Payload=$p; Notes=$n; Summaries=$s
      }
    } finally { $zip.Dispose(); $fs.Dispose() }
  } catch {
    $rows += [pscustomobject]@{ FileName=$zf.Name; FullPath=$zf.FullName; Modified=$zf.LastWriteTime; Verdict="ERROR" }
  }
}
$rows | Sort-Object Modified -Descending | Format-Table -AutoSize FileName,Verdict,Transcripts,Payload,Notes,Summaries,OutTxtStatus,Modified
$ok = $rows | ?{ $_.Verdict -like "OK*" -or $_.Verdict -eq "OK" }
foreach($r in $ok){
  $counts = if ($r.OutTxtStatus) { $r.OutTxtStatus } else { "[STATUS] items=? transcripts=$($r.Transcripts) payload=$($r.Payload) notes=$($r.Notes) summaries=$($r.Summaries)" }
  Write-Host "Spanky ready: $($r.FileName) ($counts)" -ForegroundColor Green
}
