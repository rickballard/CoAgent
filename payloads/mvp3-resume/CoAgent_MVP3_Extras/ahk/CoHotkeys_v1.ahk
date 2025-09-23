#NoEnv
#Warn
#SingleInstance Force
SendMode Input

; Resolve %USERPROFILE% safely to avoid A_UserProfile warnings
EnvGet, UserProfile, USERPROFILE
ps := UserProfile "\Downloads\CoTemp\PS7-Safe.cmd"
runner := UserProfile "\Downloads\CoTemp\tools\CoPayloadRunner.ps1"

; Ctrl+Alt+P (only when Scroll Lock is ON) -> start PS7 safe shell
#If GetKeyState("ScrollLock","T")
^!p::Run, %ps%
^!r::Run, powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -Command " & '%runner%' -Once "
#If
