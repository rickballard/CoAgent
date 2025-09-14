param([Parameter(Mandatory=$true)][string]$ToTag)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$marker = "# >>> CoInboxWatcher (auto)"
# Read the profile as a single string to avoid pipeline binding quirks
$profileText = try { Get-Content -LiteralPath $PROFILE -Raw -ErrorAction Stop } catch { "" }

if ($profileText -notmatch [regex]::Escape($marker)) {
  # Ensure directory exists
  $profDir = Split-Path -Parent $PROFILE
  if ($profDir) { New-Item -ItemType Directory -Force -Path $profDir | Out-Null }

  Add-Content -LiteralPath $PROFILE -Encoding UTF8 @"
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
