param(
  [string]$Session = $env:COAGENT_SESSION,
  [switch]$WaitExec = $true,
  [switch]$AutoExec = $true
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

# Works when invoked via & path\Pair-CoSession.ps1
$tools = if ($PSScriptRoot) { $PSScriptRoot } else { Join-Path $HOME 'Documents\GitHub\CoAgent\tools' }

. (Join-Path $tools '_spinner.ps1')
. (Join-Path $tools 'Set-CoTabTitle.ps1')
. (Join-Path $tools 'Set-CoCursor.ps1')

if ([string]::IsNullOrWhiteSpace($Session)) { $Session = 'CoAgent' }
$env:COAGENT_SESSION = $Session

$repo   = Join-Path $HOME 'Documents\GitHub\CoAgent'
$e      = Join-Path $repo 'electron'
$npx    = Join-Path $env:ProgramFiles 'nodejs\npx.cmd'
$dist   = Join-Path $e 'dist'
$unpack = Join-Path $e 'dist\win-unpacked'

Invoke-WithSpinner "Stopping CoAgent/electron" {
  Get-Process CoAgent,electron -ErrorAction SilentlyContinue | Stop-Process -Force
}

Invoke-WithSpinner "Cleaning dist" {
  param($distPath) if (Test-Path $distPath) { Remove-Item -Recurse -Force $distPath -ErrorAction SilentlyContinue }
} -ArgumentList @($dist)

Invoke-WithSpinner "Building unpacked (dir)" {
  param($eDir,$npxCmd) Push-Location $eDir; & $npxCmd electron-builder -w dir 2>&1 | Out-Null; Pop-Location
} -ArgumentList @($e,$npx)

if ($AutoExec) {
  Invoke-WithSpinner "Ensuring Exec backend is running" {
    param($toolsDir) & (Join-Path $toolsDir 'Start-CoExec.ps1') | Out-Null
  } -ArgumentList @($tools)
}

if ($WaitExec) {
  Invoke-WithSpinner "Waiting for Exec on 127.0.0.1:7681 (≤20s)" {
    $deadline = (Get-Date).AddSeconds(20)
    do {
      try {
        $tcp = [Net.Sockets.TcpClient]::new()
        $iar = $tcp.BeginConnect('127.0.0.1',7681,$null,$null)
        $ok = $iar.AsyncWaitHandle.WaitOne(500) -and $tcp.Connected
        $tcp.Close(); if ($ok) { break }
      } catch {}
    } while ((Get-Date) -lt $deadline)
  }
}

. (Join-Path $tools 'Section-Banners.ps1')
Start-Section "CoAgent launch"
Start-Process (Join-Path $unpack 'CoAgent.exe') -WorkingDirectory $unpack
End-Section "CoAgent launched"
Write-EndOfSet

