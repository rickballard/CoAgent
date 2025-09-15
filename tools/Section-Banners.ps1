function Out-ANSI([string]$s){ Write-Host -NoNewline $s }
$esc = [char]27
function Get-Width { try { $Host.UI.RawUI.WindowSize.Width } catch { 80 } }

function Write-Line([string]$Color = "32"){
  $w = (Get-Width); $bar = ('─' * ($w - 1))
  Out-ANSI "$esc[${Color}m$bar$esc[0m`n"
}
function Start-Section([string]$label){
  Write-Line 32; Write-Host " $label" -ForegroundColor Green; Write-Line 32
}
function End-Section([string]$label = "Done"){
  Write-Line 31; Write-Host " $label" -ForegroundColor Red; Write-Line 31
}
function Write-EndOfSet([string]$text = "End of set") {
  $esc = [char]27
  $w   = try { $Host.UI.RawUI.WindowSize.Width } catch { 80 }
  $bar = '─' * ($w - 1)

  # three solid bands so it’s always obvious
  $seg = [int]($bar.Length/3)
  for($i=0; $i -lt $bar.Length; $i++){
    if     ($i -lt $seg)       { $R,$G,$B = 255,0,0 }
    elseif ($i -lt 2*$seg)     { $R,$G,$B = 0,255,0 }
    else                       { $R,$G,$B = 0,0,255 }
    Write-Host -NoNewline ("$esc[38;2;{0};{1};{2}m{3}" -f $R,$G,$B,$bar[$i])
  }
  Write-Host "$esc[0m"
  Write-Host ""
  $pad = [Math]::Max(0, [int](($w - 1 - $text.Length)/2))
  Write-Host (" " * $pad + $text) -ForegroundColor White -BackgroundColor DarkBlue
  Write-Host ""
}

