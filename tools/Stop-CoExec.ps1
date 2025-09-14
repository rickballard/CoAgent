# Stop and remove the ttyd container neatly
docker rm -f coexec 2>$null | Out-Null
Write-Host "Exec stopped."
