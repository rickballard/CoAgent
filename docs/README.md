# CoAgent MVP3 Extras

This add-on bundle fixes the AutoHotkey warning, gives you a resilient PS7 launcher, 
and adds a lightweight auto-recheck loop (first check 5 minutes after logon, then hourly).

## What’s inside
- `ahk/CoHotkeys_v2.ahk` — AutoHotkey **v2** script using `EnvGet()` (no A_UserProfile warnings)
- `ahk/CoHotkeys_v1.ahk` — AutoHotkey **v1** compatible script using `EnvGet`
- `scripts/PS7-Safe.cmd` — launches a clean, responsive PowerShell 7 window in CoTemp
- `tools/CoAgent_Recheck.ps1` — performs BPOE/runner/PS7 responsiveness checks; self-reschedules hourly
- `tools/CoAgent_Setup_AutoRecheck.ps1` — installs a **logon** task that runs the first recheck ~5 min after sign-in
- `docs/HowTo_Pairing_And_Handshake.md` — quick guide for pairing tabs and the Intro Handshake

## Quick install
1. Copy everything from this zip into `%USERPROFILE%\Downloads\CoTemp` (keeping folders).
2. Double-click `scripts\PS7-Safe.cmd` to confirm PS7 launches cleanly.
3. Run in PS7:
   ```powershell
   & "$env:USERPROFILE\Downloads\CoTemp\tools\CoAgent_Setup_AutoRecheck.ps1" -DelayMin 5
   ```
4. Optionally load AutoHotkey and run the matching script for your version:
   - v2: `ahk/CoHotkeys_v2.ahk`
   - v1: `ahk/CoHotkeys_v1.ahk`

Hotkeys (when **Scroll Lock is ON**):
- **Ctrl+Alt+P** — start the safe PS7 shell
- **Ctrl+Alt+R** — run the payload runner **once** (helpful after sleep/crash)

## About the AHK warning
The prior script referenced `A_UserProfile` in a way that triggered `#Warn`. These scripts now use
`EnvGet("USERPROFILE")` (v2) or `EnvGet, UserProfile, USERPROFILE` (v1) so the warning disappears.
