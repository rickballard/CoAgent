<# 
Removes all *.from.txt sidecars and closes the loop once Grand Migration is complete.
#>
param([string] $Repo = ".")

Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$files = Get-ChildItem -Path $Repo -Filter *.from.txt -Recurse -File
foreach($f in $files){
  Remove-Item $f.FullName -Force
  Write-Host "removed $($f.FullName)"
}
Write-Host "Cleanup complete."
