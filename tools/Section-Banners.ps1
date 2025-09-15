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
function Write-EndOfSet([string]$text = "End of DO set") {
  $esc = [char]27
  $w   = try { $Host.UI.RawUI.WindowSize.Width } catch { 80 }
  $len = [Math]::Max(1, $w - 1)
  $bar = '─' * $len

  function Write-Rainbow([string]$s) {
    $esc = [char]27
    $L = $s.Length
    for($i=0; $i -lt $L; $i++){
      $h = [int](($i / [double]$L) * 360)
      $c = 1; $x = 1 - [math]::Abs((($h / 60) % 2) - 1)
      switch ([int]($h/60)) {
        0 { $r=$c;$g=$x;$b=0 } 1 { $r=$x;$g=$c;$b=0 } 2 { $r=0;$g=$c;$b=$x }
        3 { $r=0;$g=$x;$b=$c } 4 { $r=$x;$g=0;$b=$c } default { $r=$c;$g=0;$b=$x }
      }
      $R=[int]($r*255); $G=[int]($g*255); $B=[int]($b*255)
      Write-Host -NoNewline ("$esc[38;2;{0};{1};{2}m{3}" -f $R,$G,$B,$s[$i])
    }
    Write-Host "$esc[0m"
  }

  # top rainbow
  Write-Rainbow $bar

  # centered label
  Write-Host ""
  $pad = [Math]::Max(0, [int](($len - $text.Length)/2))
  Write-Host (" " * $pad + $text) -ForegroundColor White
  Write-Host ""

  # bottom rainbow
  Write-Rainbow $bar
}



