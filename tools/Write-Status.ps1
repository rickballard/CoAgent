Param(
  [string]$Auth="linked",
  [string]$Safeguards="PR-first",
  [string]$UndoHint="gh pr revert <#>",
  [string]$Deliverable="ok"
)
$stamp=(Get-Date).ToString('s')
$payload = [pscustomobject]@{
  auth=$Auth; safeguards=$Safeguards; undo_hint=$UndoHint;
  index="updated @$stamp"; deliverable=$Deliverable
} | ConvertTo-Json
New-Item -ItemType Directory -Force .\docs | Out-Null
$payload | Set-Content -Encoding UTF8 .\docs\status.json
Write-Host "wrote docs/status.json @ $stamp"
