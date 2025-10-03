param(
  [ValidateSet('All','Docs','UI','Guardrails','Metrics','Sandbox')]
  [string]$Pack = 'All'
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

function Exec($cmd, $err="Command failed"){
  $p = Start-Process pwsh -ArgumentList "-NoLogo -NoProfile -Command $cmd" -NoNewWindow -PassThru -Wait
  if($p.ExitCode -ne 0){ throw "$err : $cmd" }
}

# Ensure git and gh available
if(-not (Get-Command git -ErrorAction SilentlyContinue)){ throw "git not found" }
if(-not (Get-Command gh  -ErrorAction SilentlyContinue)){ throw "gh not found" }

$stamp = Get-Date -Format yyyyMMdd-HHmmss
$branch = "pack/$($Pack.ToLower())-$stamp"

# Detect change set (simple: everything changed)
git status --porcelain
$dirty = $LASTEXITCODE -eq 0 -and ((git status --porcelain) -ne $null) -and ((git status --porcelain) -ne "")

git checkout -B $branch origin/main | Out-Null

# Optionally filter files by pack (no-op for now; keep simple & explicit)
# You can manually curate staged paths before commit if desired.

git add .
if(git diff --cached --quiet){ Write-Host "ℹ️ No changes to commit for $Pack"; exit 0 }

$msg = "pack: apply $Pack"
git commit -m $msg | Out-Null
git push -u origin $branch | Out-Null

$body = "Automated $Pack pack via CoWrap."
$pr = gh pr create --head $branch --base main -t $msg -b $body --draft
Write-Host $pr
Write-Host "✓ Opened draft PR for $Pack → $branch"
