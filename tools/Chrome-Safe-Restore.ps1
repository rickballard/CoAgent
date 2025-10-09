#requires -Version 7
param()
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

$UserData = Join-Path $env:LOCALAPPDATA 'Google\Chrome\User Data'
$Cur      = Join-Path $UserData 'Default'
$Backup   = Get-ChildItem (Split-Path $UserData) -Directory |
  ? { $_.Name -like 'User Data.bak-*' } |
  Sort-Object LastWriteTime -Descending | Select-Object -First 1 -ExpandProperty FullName

if (-not $Backup) { throw "No backup found (User Data.bak-*)" }
$Old = Join-Path $Backup 'Default'
$stamp = Get-Date -Format yyyyMMdd_HHmmss

$keep = @('Bookmarks','Bookmarks.bak','Custom Dictionary.txt')
foreach($f in $keep){
  $src = Join-Path $Old $f
  if (Test-Path $src){
    $dst = Join-Path $Cur $f
    if (Test-Path $dst){ Copy-Item $dst "$dst.$stamp.bak" -Force }
    Copy-Item $src $Cur -Force
    Write-Host "Restored: $f"
  }
}
Write-Host "Done. Reinstall extensions from Web Store for a clean slate."
