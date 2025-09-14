param([Parameter(Mandatory)][string]$ToTag)
Set-StrictMode -Version Latest
$marker = "# >>> CoInboxWatcher (auto)"

if (-not (Get-Content $PROFILE -ErrorAction SilentlyContinue | Select-String [regex]::Escape($marker))) {
  Add-Content $PROFILE @"
$marker
try {
  . `"$PSScriptRoot\Start-CoInboxWatcher.ps1`"
  Start-CoInboxWatcher -Inbox `"$HOME\Downloads\CoTemp\inbox`" -ToTag '$ToTag'
} catch {}
# <<< CoInboxWatcher (auto)
"@
  "Profile updated: $PROFILE"
} else {
  "Profile already contains watcher block."
}
