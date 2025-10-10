# PS7-compatible: logs parent of Calculator launches to Desktop\CalcSpawner.log
[CmdletBinding()] param()
Register-CimIndicationEvent -Query "SELECT * FROM Win32_ProcessStartTrace WHERE ProcessName='CalculatorApp.exe'" `
  -SourceIdentifier CalcWatch -Action {
    param($s,$e)
    $ppid = $e.SourceEventArgs.NewEvent.ParentProcessID
    $p = Get-CimInstance Win32_Process -Filter "ProcessId=$ppid"
    $line = "{0}  Calculator by: {1} (PPID {2})" -f (Get-Date -Format HH:mm:ss), $p.Name, $ppid
    $log  = Join-Path $env:USERPROFILE 'Desktop\CalcSpawner.log'
    $line | Out-File $log -Append -Encoding utf8
  } | Out-Null
Write-Host "Hotkey storm watch started. Stop with: Unregister-Event -SourceIdentifier CalcWatch"
