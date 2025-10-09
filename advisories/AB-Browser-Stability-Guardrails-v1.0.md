# Advice Bomb: Browser Stability Guardrails (v1.0)

**Principle:** CoAgent won’t “tweak the OS,” but it *will* detect risk and offer safe, reversible guidance.

## Detect (read-only)
- Proxy/WPAD/PAC active; QUIC on/off; GPU adapter/driver; per-path firewall rules; AV web filter presence;
  huge service-worker/caches; stuck crashpad/net-export; profile disk free %.
- Emit a short **BrowserHealth.json** in run artifacts.

## Nudge (consent)
- “Start clean in temp profile” button (with flags `--user-data-dir`, `--disable-extensions`, `--disable-quic`, `--disable-gpu`).
- “Safe restore” (Bookmarks + dictionary only).
- “Reset proxy/WPAD” playbook (with admin prompt), winsock/ip reset notes.
- “AV compatibility” note (temporarily disable web filter; add exclusions).
- “Full reinstall” playbook (enterprise MSI, clean profile).

## Don’ts
- Don’t auto-delete profiles, cookies, or history.
- Don’t import unknown extensions.
- Don’t modify system firewall or AV settings without explicit user action.

## Productization
- Ship `tools/Chrome-Safe-Restore.ps1`.
- HealthGate: add Browser section to report.
- Add “Open in minimal browser” fallback for critical flows to avoid session bloat.
