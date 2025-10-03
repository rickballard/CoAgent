$ver="v0.4.0-mvp-public"
$today=(Get-Date -Format "yyyy-MM-dd")
Add-Content -Path CHANGELOG.md -Value "`n## $ver ($today)`n- MVP4 public: pages, plan, status, guardrails."
git add CHANGELOG.md ; git commit -m "chore: changelog for $ver"
git tag -a $ver -m "$ver"
git push --follow-tags
gh release create $ver -t "$ver" -n "Public MVP with live docs and guardrails. See README for Pages link."
