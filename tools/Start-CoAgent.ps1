Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Bind panes
$env:COAGENT_CHAT_URL = 'data:text/html,<h2>Chat</h2><p>connected</p>'
$env:COAGENT_OPS_URL  = 'data:text/html,<h2>Ops</h2><ul><li>Ready</li></ul>'
$env:COAGENT_EXEC_URL = 'http://127.0.0.1:7681'

# Launch Electron (dev)
Start-Process -FilePath npm -WorkingDirectory (Join-Path $PSScriptRoot '..\electron') -ArgumentList 'start'
