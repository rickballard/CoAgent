param([string]$Fallback = "CoAgent")
$raw   = $env:COAGENT_SESSION
$first = if ($raw) { ($raw -split '\s+')[0] } else { $Fallback }
$host.UI.RawUI.WindowTitle = "$first - CoAgent Exec"
$esc = [char]27; $bel = [char]7
Write-Host "$esc]0;$first - CoAgent Exec$bel" -NoNewline   # Windows Terminal tab title
