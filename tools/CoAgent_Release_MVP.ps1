Set-StrictMode -Version Latest; $ErrorActionPreference="Stop"
$def = (gh repo view --json defaultBranchRef --jq .defaultBranchRef.name); if(-not $def){$def='main'}
$onMain = (git rev-parse --abbrev-ref HEAD) -eq $def
$ver="v0.4.0-mvp-public"
$today=(Get-Date -Format "yyyy-MM-dd")
if (!(Test-Path CHANGELOG.md)) { New-Item -ItemType File CHANGELOG.md | Out-Null }
Add-Content -Path CHANGELOG.md -Value "`n## $ver ($today)`n- MVP4 public: Pages + status + guardrails + live mock."
git add CHANGELOG.md ; git commit -m "chore: changelog for $ver" 2>$null
if (-not $onMain) {
  Write-Host "ℹ️ Not on main; merge PRs first, then rerun this script on main." -ForegroundColor Yellow
  exit 0
}
if (-not (git tag -l $ver)) {
  git tag -a $ver -m "$ver"
  git push --follow-tags
  gh release create $ver -t "$ver" -n "Public MVP with live docs and guardrails. See README for Pages link."
  Write-Host "✅ Release created: $ver" -ForegroundColor Green
} else {
  Write-Host "ℹ️ Tag $ver already exists; skipping." -ForegroundColor Yellow
}
