@echo off
setlocal
set APP=%~dp0..\app\index.html
start "" "%APP%"
exit /b 0
