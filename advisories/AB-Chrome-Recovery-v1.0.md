# Advice Bomb: Chrome Recovery (v1.0)

**Goal:** Fix “pages never finish loading / cache won’t clear” without dragging old corruption back.

## Safe Restore (summary)
- Close Chrome. Restore **only**: `Bookmarks`, `Bookmarks.bak`, `Custom Dictionary.txt`.
- Reinstall extensions clean (no copying `Extensions` folder).
- Never copy: `Preferences`, `Secure Preferences`, `Local State`, `Cookies`, `History*`,
  `Network Persistent State`, `TransportSecurity`, caches, `Service Worker`, `Storage`, `IndexedDB`, `Code Cache`.

## Known Pitfalls
- AV web filters (e.g., Malwarebytes Web Protection) can stall Chromium networking.
- Proxy/WPAD/PAC residues, firewall rules bound to old chrome.exe paths.
- QUIC/GPU driver quirks on some systems.
- Stalled “chrome://net-export” logging dialogs pinning a hung renderer.

## Recovery Playbook (One-pagers)
1. Launch clean temp profile:
   `chrome.exe --user-data-dir=%TEMP%\ChromeTemp --no-first-run --disable-extensions --disable-quic --disable-gpu`
2. If clean profile works → safe-restore **only Bookmarks + dictionary**; reinstall extensions.
3. If clean profile still fails → check proxy/WPAD off, winsock/ip reset, nuke stale firewall rules, consider AV web-filter off.
4. If still bad → full uninstall + reinstall (enterprise MSI), start fresh profile, then safe-restore.

## BPOE Integration
- Provide a **“Chrome Safe Restore”** helper script in `/tools`.
- HealthGate should **report** (not fix): proxy settings, QUIC status, AV hook detected, firewall per-path rules, GPU adapter/driver.
- CoAgent should prefer **deterministic** embedded browser for flows needing guaranteed rendering, and hand off to system browser for regular browsing.
