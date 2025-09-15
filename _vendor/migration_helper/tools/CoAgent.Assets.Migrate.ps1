<# 
.SYNOPSIS
  Pulls CoAgent-related assets from other repos/folders into the CoAgent repo,
  adds per-file breadcrumbs, writes a manifest, and optionally commits/pushes a PR.

.DESCRIPTION
  - Copies selected files (by glob) from $Sources into $Repo, preserving relative structure.
  - Writes sidecar breadcrumbs (*.from.txt) and a central manifest (ASSET_MANIFEST.ndjson).
  - Can run in -DryRun to preview actions.
  - Optionally creates a git branch, commits, pushes, and opens a PR (gh CLI if available).

.PARAMETER Repo
  Path to the CoAgent repository root (target).

.PARAMETER Sources
  Array of hashtables with keys: Path, Glob, Target (optional subdir under Repo).

.PARAMETER Branch
  Git branch to create for the migration sweep (default: migration/seed-assets-<date>).

.PARAMETER Commit
  Switch: if set, create commit(s).

.PARAMETER Push
  Switch: if set, push branch to origin.

.PARAMETER PR
  Switch: if set, create a pull request (requires gh CLI).

.PARAMETER DryRun
  Switch: if set, do not write or modify files.

.EXAMPLE
  $src = @(
    @{ Path = "$HOME\Documents\GitHub\CoCivium"; Glob = "docs\**\*.md"; Target="docs\_imports\CoCivium" },
    @{ Path = "$HOME\Documents\GitHub\CoAgent-prototypes"; Glob = "electron\**\*"; Target="electron\_imports" }
  )
  .\tools\CoAgent.Assets.Migrate.ps1 -Repo "C:\Users\Chris\Documents\GitHub\CoAgent" -Sources $src -Commit -Push -PR
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)]
  [string] $Repo,

  [Parameter(Mandatory=$true)]
  [array] $Sources,

  [string] $Branch = ("migration/seed-assets-{0}" -f (Get-Date -Format 'yyyyMMdd')),

  [switch] $Commit,
  [switch] $Push,
  [switch] $PR,
  [switch] $DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Log($msg){ "{0} {1}" -f ((Get-Date).ToString('s')), $msg | Write-Host }

function Ensure-Dir($path){
  if (-not (Test-Path $path)) {
    if (-not $DryRun) { New-Item -ItemType Directory -Force -Path $path | Out-Null }
    Write-Log "mkdir  $path"
  }
}

# Validate repo
if (-not (Test-Path (Join-Path $Repo '.git'))) { throw "Repo '$Repo' does not look like a git repo" }

$manifestPath = Join-Path $Repo "docs\migration\ASSET_MANIFEST.ndjson"
$breadcrumbsIndex = Join-Path $Repo "docs\migration\BREADCRUMBS.md"
$now = (Get-Date).ToString('yyyy-MM-ddTHH:mm:ssK')

# Prepare manifest dir
Ensure-Dir (Split-Path $manifestPath -Parent)

$manifestBuffer = New-Object System.Collections.Generic.List[string]

$actions = @()

foreach ($s in $Sources) {
  $srcRoot  = (Resolve-Path $s.Path).Path
  $glob     = $s.Glob
  $target   = if ($s.ContainsKey("Target")) { $s.Target } else { "" }
  $srcPattern = Join-Path $srcRoot $glob

  Write-Log "scan   $srcPattern"
  $files = Get-ChildItem -Path $srcPattern -File -Recurse -ErrorAction SilentlyContinue
  foreach ($f in $files) {
    $rel = $f.FullName.Substring($srcRoot.Length).TrimStart('\','/')
    $destRel = if ($target) { Join-Path $target $rel } else { $rel }
    $dest = Join-Path $Repo $destRel

    $destDir = Split-Path $dest -Parent
    Ensure-Dir $destDir

    $breadcrumbSidecar = "$dest.from.txt"
    $record = [ordered]@{
      ts = $now
      src = $f.FullName
      dest = $dest
      srcRepo = $srcRoot
      destRepo = $Repo
      rel = $rel
      author = "$env:USERNAME@$env:COMPUTERNAME"
      hash = (Get-FileHash -Algorithm SHA256 -Path $f.FullName).Hash
    }

    $actions += [pscustomobject]@{
      Src=$f.FullName; Dest=$dest; Sidecar=$breadcrumbSidecar; Record=$record
    }
  }
}

# Execute copy + breadcrumbs
foreach ($a in $actions) {
  if ($DryRun) {
    Write-Log ("copy   {0} -> {1}" -f $a.Src, $a.Dest)
    continue
  }
  Copy-Item -Path $a.Src -Destination $a.Dest -Force
  $from = @(
    ("ORIGIN:  {0}" -f $a.Record.src),
    ("HASH:    {0}" -f $a.Record.hash),
    ("MOVED:   {0}" -f $a.Record.ts),
    ("BY:      {0}" -f $a.Record.author),
    "NOTE:    Temporary import. Grand Migration may delete after consolidation."
  ) -join [Environment]::NewLine
  Set-Content -Path $a.Sidecar -Value $from -Encoding UTF8
  $manifestBuffer.Add(($a.Record | ConvertTo-Json -Compress))
  Write-Log ("copied {0}" -f $a.Dest)
}

# Write manifest & breadcrumbs index
if (-not $DryRun) {
  if ($manifestBuffer.Count -gt 0) {
    Add-Content -Path $manifestPath -Value ($manifestBuffer -join [Environment]::NewLine) -Encoding UTF8
  }

  $index = @"
# Breadcrumbs & Imported Assets

This file lists imported assets and their temporary sidecar breadcrumbs (`*.from.txt`).  
When **Grand Migration** finalizes, remove sidecars and delete this file.

- Manifest: `docs/migration/ASSET_MANIFEST.ndjson`
- Imported on: $now
- Branch: $Branch

Each `*.from.txt` contains: origin path, file hash, mover identity, and note.
"@
  Set-Content -Path $breadcrumbsIndex -Value $index -Encoding UTF8
}

# Git operations
Set-Location $Repo
$branchExists = (& git rev-parse --verify $Branch 2>$null) -ne $null

if (-not $branchExists) {
  if (-not $DryRun) { git checkout -b $Branch | Out-Null }
  Write-Log "git    checkout -b $Branch"
} else {
  git checkout $Branch | Out-Null
  Write-Log "git    checkout $Branch"
}

if ($Commit) {
  git add .
  git commit -m "migration: import assets with breadcrumbs (auto) [coagent-migrate]" | Out-Null
  Write-Log "git    commit"
}

if ($Push) {
  git push -u origin $Branch | Out-Null
  Write-Log "git    push origin $Branch"
}

if ($PR) {
  try {
    & gh pr create --fill --label migration --label breadcrumbs --title "Migration: import assets with breadcrumbs" --body "This PR imports assets into CoAgent with sidecar breadcrumbs for Grand Migration cleanup." | Out-Null
    Write-Log "gh pr create"
  } catch {
    Write-Log ("WARN   gh CLI not available or PR failed: {0}" -f $_.Exception.Message)
  }
}

Write-Log "Done."
