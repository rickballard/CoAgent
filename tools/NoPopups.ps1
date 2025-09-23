# If COAGENT_NO_POPUPS is set, any attempt to show interactive UI should be turned into quiet logging.
if ($env:COAGENT_NO_POPUPS) {
  function Show-TextQuiet([string]$Path,[string]$Msg){
    try { $Msg | Out-File -FilePath $Path -Append -Encoding UTF8 } catch {}
  }
  Set-Alias -Name notepad -Value Out-Null -Scope Global -Force
}
