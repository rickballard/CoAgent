@echo off
setlocal ENABLEDELAYEDEXPANSION
title CoAgent Launcher

rem ---- Paths ----
set "ROOT=%~dp0.."
set "APP=%ROOT%\app\index.html"
set "ICON=%ROOT%\app\assets\favicon.ico"
set "DESKTOP=%USERPROFILE%\Desktop"
set "SMENU=%APPDATA%\Microsoft\Windows\Start Menu\Programs"

rem ---- Progress shim ----
call :bar "Preparing" 12
call :mkshortcut "CoAgent" "%APP%" "%ICON%"
call :bar "Launching" 8

start "" "%APP%"
exit /b 0

:bar
set "label=%~1"
set "ticks=%~2"
<nul set /p "=%label%: ["
for /l %%i in (1,1,%ticks%) do (
  <nul set /p ="#"
  ping -n 1 -w 150 127.0.0.1 >nul
)
echo ] done
exit /b 0

:mkshortcut
set "NAME=%~1"
set "TARGET=%~2"
set "ICONP=%~3"
for %%D in ("%DESKTOP%" "%SMENU%") do (
  call :_vbs "%%~D\%NAME%.lnk" "%TARGET%" "%ICONP%"
)
exit /b 0

:_vbs
set "LNK=%~1"
set "TGT=%~2"
set "ICO=%~3"
set "TMP=%TEMP%\coagent_shortcut.vbs"
> "%TMP%" echo Set WshShell = WScript.CreateObject("WScript.Shell")
>>"%TMP%" echo Set lnk = WshShell.CreateShortcut("%LNK%")
>>"%TMP%" echo lnk.TargetPath = "%TGT%"
>>"%TMP%" echo lnk.IconLocation = "%ICO%"
>>"%TMP%" echo lnk.Description = "CoAgent"
>>"%TMP%" echo lnk.Save
cscript //nologo "%TMP%" >nul 2>nul
del "%TMP%" >nul 2>nul
exit /b 0
