Set-StrictMode -Version Latest; $ErrorActionPreference="Stop"
$hg = Join-Path $PSScriptRoot '..\modules\HealthGate.ps1'
if (!(Test-Path $hg)) { throw "HealthGate.ps1 not found at $hg" }
& $hg -OutDir (Join-Path $PSScriptRoot '..\health')
