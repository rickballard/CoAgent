#Requires AutoHotkey v2.0
#Warn  ; show warnings for bad patterns

; --- Hotkeys ---
; Ctrl+Alt+P = launch the safe PS7 wrapper
; (Only while Scroll Lock is ON, to avoid accidental triggers)
#HotIf GetKeyState("ScrollLock","T")
^!p::Run(EnvGet("USERPROFILE") "\Downloads\CoTemp\PS7-Safe.cmd")
#HotIf

; Ctrl+Alt+R = restart CoPayloadRunner once (helpful after sleep/crash)
^!r::Run(Format('{}\Downloads\CoTemp\tools\CoPayloadRunner.ps1 -Once', EnvGet("USERPROFILE")), , "RunAs")
