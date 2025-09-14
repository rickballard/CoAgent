function Invoke-WithSpinner {
  param([Parameter(Mandatory)][string]$Text,[Parameter(Mandatory)][scriptblock]$Block)
  $frames = @("|","/","-","\"); $i = 0
  $job = Start-Job $Block
  try {
    while ($job.State -eq 'Running') {
      Write-Host -NoNewline ("`r{0} {1}..." -f $frames[$i % $frames.Count], $Text)
      Start-Sleep -Milliseconds 120; $i++
    }
    Receive-Job $job | Out-Host
    Write-Host ("`r  {0}... done   " -f $Text)
  } finally { Remove-Job $job -Force -ErrorAction SilentlyContinue }
}
