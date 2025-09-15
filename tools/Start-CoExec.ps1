param([int]$Port = 7681)
$ErrorActionPreference='Stop'
# fast-path if already up
try {
  $tcp = [Net.Sockets.TcpClient]::new(); $iar = $tcp.BeginConnect('127.0.0.1',$Port,$null,$null)
  if ($iar.AsyncWaitHandle.WaitOne(250) -and $tcp.Connected) { $tcp.Close(); Write-Host "Exec already up on $Port"; exit 0 }
  $tcp.Close()
} catch {}

# (re)start container
docker rm -f coexec 2>$null | Out-Null
docker run -d --name coexec --restart=unless-stopped -p ${Port}:${Port} tsl0922/ttyd:latest powershell | Out-Null
Write-Host "Exec started: http://127.0.0.1:$Port/"
