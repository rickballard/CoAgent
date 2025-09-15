Set-StrictMode -Version Latest
$repo = "$PSScriptRoot\.."
cd (Join-Path $repo "docker")
docker compose down
