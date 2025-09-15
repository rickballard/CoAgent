param(
  [Parameter(Mandatory)][string]$Inbox,
  [Parameter(Mandatory)][string]$ToTag
)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$Inbox = (Resolve-Path $Inbox).Path
$fsw = New-Object IO.FileSystemWatcher $Inbox, "*.json"
$fsw.IncludeSubdirectories = $false
$fsw.EnableRaisingEvents   = $true
$id = "inbox_$ToTag"

Register-ObjectEvent -InputObject $fsw -EventName Created -SourceIdentifier $id -Action {
  Start-Sleep -Milliseconds 150
  try {
    $raw = Get-Content -LiteralPath $EventArgs.FullPath -Raw -ErrorAction Stop
    $msg = $raw | ConvertFrom-Json
    if ($msg.to -ne $using:ToTag) { return }
    $logDir = Join-Path (Split-Path $using:Inbox -Parent) 'Logs'
    [IO.Directory]::CreateDirectory($logDir) | Out-Null
    $ack = [pscustomobject]@{
      kind='ack'; to=$msg.to; from=$env:COMPUTERNAME
      ts=(Get-Date).ToUniversalTime().ToString('o')
      file=$EventArgs.FullPath; session=$msg.session; topic=$msg.topic
    }
    $ack | ConvertTo-Json -Depth 6 |
      Set-Content -LiteralPath (Join-Path $logDir ("ack_{0:yyyyMMdd_HHmmssfff}.json" -f (Get-Date))) -Encoding utf8
  } catch {}
} | Out-Null

"Watcher '$id' on $Inbox (quiet)."
