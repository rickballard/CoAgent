# CoAgent — HELP (User Guide, MVP)

## What this is
A minimal public MVP with a live UI mock, status panel, and guardrails smoke tests.

## Quick start
1. Visit: `/` → `index.html`
2. UI Mock: `/ui-mock/quad.html`
3. Status Panel: `/status.html` (reads `status.json`)
4. Smoke locally: `pwsh -File tools\Test-MVP.ps1`

## Guardrails (at-risk user redirect)
- Heuristic scanner: `tools/Scan-AtRisk.ps1`
- CI smoke: `.github/workflows/guardrail-smoke.yml`

## Release
- Tag with `tools/CoAgent_Release_MVP.ps1` (on main, clean tree).
- Creates a GitHub Release with version + notes.

## Support & Security
- See `SUPPORT.md` and `SECURITY.md`.
