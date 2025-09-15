param([Parameter(Mandatory)][string]$ToTag)
$jobName = "CoInboxWatch_$ToTag"
$job = Get-Job -Name $jobName -ErrorAction SilentlyContinue
if ($job) {
  Stop-Job $job -Force -ErrorAction SilentlyContinue
  Remove-Job $job -Force -ErrorAction SilentlyContinue
  "Stopped '$jobName'."
} else {
  "'$jobName' not running."
}
