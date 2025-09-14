param([string]$Seed = $env:COAGENT_SESSION)
function Get-SeedColorHex([string]$s){
  if ([string]::IsNullOrWhiteSpace($s)) { $s = "CoAgent" }
  $hash = 5381
  foreach ($ch in $s.ToCharArray()){ $hash = (($hash -shl 5) + $hash) + [int][char]$ch }
  $r = 64 + (($hash -shr  0) -band 0x7F)
  $g = 64 + (($hash -shr  8) -band 0x7F)
  $b = 64 + (($hash -shr 16) -band 0x7F)
  return "#{0:x2}{1:x2}{2:x2}" -f $r,$g,$b
}
$hex = Get-SeedColorHex $Seed
$esc = [char]27; $bel = [char]7
Write-Host "$esc]12;$hex$bel" -NoNewline
