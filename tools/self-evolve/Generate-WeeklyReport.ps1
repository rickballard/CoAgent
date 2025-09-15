param([string]$RepoRoot=".",[string]$OutDir="reports/weekly",[int]$SinceDays=7)
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
Push-Location $RepoRoot
try {
  $since = (Get-Date).AddDays(-$SinceDays)
  $commits = & git log --since="$($since.ToString('yyyy-MM-dd HH:mm:ss'))" --pretty=format:"%h|%ad|%s" --date=short
  $diffstats = & git diff --since="$($since.ToString('yyyy-MM-dd HH:mm:ss'))" --stat
  New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
  $stamp = Get-Date -Format "yyyy-MM-dd"
  $path  = Join-Path $OutDir "$stamp.md"
  $latest= Join-Path $OutDir "LATEST.md"
  $text = "# Weekly Report`n`n## Commits`n" + (($commits -split "`n" | ForEach-Object { "- " + $_ }) -join "`n") + "`n`n## Diffstat`n```" + "`n" + ($diffstats | Out-String) + "```"
  Set-Content -Encoding UTF8 -Path $path -Value $text
  Set-Content -Encoding UTF8 -Path $latest -Value $text
} finally { Pop-Location }