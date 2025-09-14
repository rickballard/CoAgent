param(
  [string]$Inbox = "$HOME\Downloads\CoTemp\inbox",
  [string]$ToTag = "prod"
)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\Start-CoInboxWatcher.ps1"
Start-CoInboxWatcher -Inbox $Inbox -ToTag $ToTag
