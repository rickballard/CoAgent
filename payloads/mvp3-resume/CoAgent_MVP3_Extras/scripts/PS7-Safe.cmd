@echo off
setlocal
REM Launch a clean, resilient PowerShell 7 panel
set "PSH=%ProgramFiles%\PowerShell\7\pwsh.exe"
if not exist "%PSH%" (
  echo PowerShell 7 not found at "%PSH%".
  echo Please install PS7, then try again.
  pause
  exit /b 1
)
REM Start inside CoTemp so payloads/logs are nearby
set "CT=%USERPROFILE%\Downloads\CoTemp"
if not exist "%CT%" mkdir "%CT%"
start "" "%PSH%" -NoLogo -NoProfile -ExecutionPolicy Bypass -WorkingDirectory "%CT%"
