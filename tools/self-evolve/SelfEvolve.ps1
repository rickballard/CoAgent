param([string]$RepoRoot=".",[int]$MaxIssues=5,[int]$MaxFiles=5,[switch]$WhatIf)
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
Push-Location $RepoRoot
try {
  if (-not (Test-Path 'docs/self-evolve')) { New-Item -ItemType Directory -Force -Path 'docs/self-evolve' | Out-Null }
  $note = "docs/self-evolve/STATUS.md"
  if (-not (Test-Path $note)) { Set-Content -Encoding UTF8 -Path $note -Value "# Self‑Evolve Status`n`n- Initialized: $(Get-Date -Format s)`n" }
  if (-not (git diff --quiet)) { git add -A; git commit -m "chore(self-evolve): safe housekeeping" }
} finally { Pop-Location }