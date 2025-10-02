Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

$owner='rickballard'; $repo='CoAgent'
$base="https://$owner.github.io/$repo"
$urls = @("$base/","$base/index.html","$base/ui-mock/quad.html","$base/status.html")

$ok=@(); $fail=@()
foreach($u in $urls){
  try{
    $r = Invoke-WebRequest -Uri $u -UseBasicParsing -TimeoutSec 30
    if($r.StatusCode -ne 200){ throw "HTTP $($r.StatusCode)" }
    $ok += $u
  } catch {
    $fail += "$u → $($_.Exception.Message)"
  }
}

# status.json (optional)
$stat="$base/status.json"
$statOk=$false; $statMsg=""
try{
  $r = Invoke-WebRequest -Uri $stat -UseBasicParsing -TimeoutSec 30
  if($r.StatusCode -eq 200 -and $r.Content.Trim().StartsWith('{')){ $statOk=$true }
}catch{ $statMsg = $_.Exception.Message }

# Trigger guardrail smoke CI if present
$wfName='guardrail-smoke'
$wfFile='guardrail-smoke.yml'
$wfId = (gh workflow list --json name,id | ConvertFrom-Json | ? { $_.name -eq $wfName } | Select-Object -First 1 -ExpandProperty id)
if($wfId){ gh workflow run $wfFile | Out-Null }

"---- MVP Smoke Summary ----"
"Pages OK: {0}/{1}" -f $ok.Count, $urls.Count
$ok | % { "  ✓ $_" }
if($fail.Count){ "Pages FAIL:"; $fail | % { "  ✗ $_" } }
"status.json: " + ($(if($statOk){"✓ present"}else{"(optional) missing"+$(if($statMsg){" – $statMsg"}else{""})}))
if($wfId){ "Guardrail CI: triggered ($wfFile)" } else { "Guardrail CI: (workflow not found)" }
"---------------------------"
