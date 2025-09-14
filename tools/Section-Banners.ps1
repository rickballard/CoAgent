# ANSI helpers
function Out-ANSI([string]$s){ Write-Host -NoNewline $s }
$esc = [char]27
function Get-Width { try { $Host.UI.RawUI.WindowSize.Width } catch { 80 } }

function Write-Line([string]$Color = "32"){   # default green
  $w = (Get-Width); $bar = ('─' * ($w - 1))
  Out-ANSI "$esc[${Color}m$bar$esc[0m`n"
}
function Start-Section([string]$label){
  Write-Line 32; Write-Host " $label" -ForegroundColor Green; Write-Line 32
}
function End-Section([string]$label = "Done"){
  Write-Line 31; Write-Host " $label" -ForegroundColor Red; Write-Line 31
}
function Write-EndOfSet([string]$text = "End of set"){
  $w = (Get-Width); $pad = [Math]::Max(0, $w - 1)
  $bar = '─' * $pad
  # Rainbow gradient across the bar
  for($i=0; $i -lt $bar.Length; $i++){
    $h = [int](($i / [double]$bar.Length) * 360)
    # HSV->RGB quick approx
    $c = 1; $x = 1 - [math]::Abs((($h / 60) % 2) - 1); $m = 0
    switch ([int]($h/60)) {
      0 { $r=$c;$g=$x;$b=0 } 1 { $r=$x;$g=$c;$b=0 } 2 { $r=0;$g=$c;$b=$x }
      3 { $r=0;$g=$x;$b=$c } 4 { $r=$x;$g=0;$b=$c } default { $r=$c;$g=0;$b=$x }
    }
    $R=[int](($r+$m)*255); $G=[int](($g+$m)*255); $B=[int](($b+$m)*255)
    Out-ANSI ("$esc[38;2;{0};{1};{2}m{3}" -f $R,$G,$B,$bar[$i])
  }
  # center label with 3 blank lines above/below
  Write-Host "$esc[0m`n`n"
  $center = [Math]::Max(0, ([int]((Get-Width)/2) - [int]($text.Length/2)) - 1)
  Write-Host (" " * $center + $text) -ForegroundColor White -BackgroundColor DarkBlue
  Write-Host "`n`n"
}
Export-ModuleMember -Function *-Section,Write-EndOfSet,Write-Line
