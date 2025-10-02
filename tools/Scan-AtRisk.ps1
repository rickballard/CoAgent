Param([Parameter(Mandatory=$true)][string]$Text)
# super-light heuristic (placeholder)
$hit = $false
$needles = @("kill myself","end it all","i want to die","suicide","i'm worthless","no reason to live","hurt myself")
foreach($n in $needles){ if($Text -match [regex]::Escape($n)){$hit=$true;break} }
if($hit){
  $stamp=(Get-Date).ToString('s')
  New-Item -ItemType Directory -Force .\.coagent\guardrails | Out-Null
  "{""ts"":""$stamp"",""type"":""at-risk-hit"",""note"":""heuristic""}" | Add-Content .\.coagent\guardrails\redirects.jsonl
  Write-Host "TRIGGER: at-risk → advise redirect to LifeOS/CareerOS and halt adversarial stance."
}else{
  Write-Host "OK: no at-risk trigger (heuristic)."
}
