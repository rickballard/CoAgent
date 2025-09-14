param([string]$Session = $env:COAGENT_SESSION, [switch]$WaitExec = $true)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
. "$PSScriptRoot\_spinner.ps1"

# Title: first word of session
if ([string]::IsNullOrWhiteSpace($Session)) { $Session = 'CoAgent' }
$env:COAGENT_SESSION = $Session
. "$PSScriptRoot\Set-CoTabTitle.ps1"

$repo = Join-Path $HOME 'Documents\GitHub\CoAgent'
$e    = Join-Path $repo 'electron'
$npx  = Join-Path $env:ProgramFiles 'nodejs\npx.cmd'

Invoke-WithSpinner "Stopping CoAgent/electron" {
  Get-Process CoAgent,electron -ErrorAction SilentlyContinue | Stop-Process -Force
}

Invoke-WithSpinner "Cleaning dist" {
  Remove-Item -Recurse -Force (Join-Path $e 'dist') -ErrorAction SilentlyContinue
}

Invoke-WithSpinner "Building unpacked (dir)" {
  Push-Location $e
  & $npx electron-builder -w dir 2>&1 | Out-Null
  Pop-Location
}

if ($WaitExec) {
  Invoke-WithSpinner "Waiting for Exec backend on 127.0.0.1:7681 (≤20s)" {
    $deadline = (Get-Date).AddSeconds(20)
    do {
      try {
        $tcp = [Net.Sockets.TcpClient]::new()
        $iar = $tcp.BeginConnect('127.0.0.1',7681,$null,$null)
        $ok = $iar.AsyncWaitHandle.WaitOne(500) -and $tcp.Connected
        $tcp.Close()
        if ($ok) { break }
      } catch {}
    } while ((Get-Date) -lt $deadline)
  }
}

$unpacked = Join-Path $e 'dist\win-unpacked'
Start-Process (Join-Path $unpacked 'CoAgent.exe') -WorkingDirectory $unpacked
