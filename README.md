# CoAgent — v1 Seed

**CoAgent** is a multi‑AI operator shell and protocol client. It renders split panes (Chat • Exec • Notes), speaks the **Gibberlink** protocol, and enforces **Congruence Guard** policies. This bundle seeds a minimal, repo‑ready structure with docs, config, and runnable stubs.

> Hidden agenda: nudge users toward **Civium congruence** while staying provider‑ and executor‑agnostic.

## What’s here
- `docs/v1_product_plan.md` — scope, milestones, and success metrics.
- `docs/rfc-gibberlink-v0.1.md` — minimal event spec & guardrail hooks.
- `docs/extension-beaxa-reptag-scripttag.md` — optional v1.1 extension plan.
- `config/coagent.example.yaml` — provider/runner/pane config.
- `control-plane/` — tiny HTTP/WS skeleton and JSON Schemas for events & APIs.
- `electron/` — split-pane shell skeleton (Chat, Exec, Notes panes).
- `docker/` — dev docker-compose (ttyd→pwsh/bash/python) and Caddy proxy.
- `SECURITY.md`, `CONTRIBUTING.md`, `ROADMAP.md` — contributor hygiene.
- `LICENSE` — placeholder (choose your license).
- `.gitignore` — sensible defaults.

## Quick start (dev)
```bash
# 1) Start exec backend (ttyd -> pwsh) + proxy (HTTP only for dev)
cd docker
docker compose up -d

# 2) Run the Electron shell (needs Node 20+)
cd ../electron
npm i
npm run start
```

## Status
Seed bundle generated 2025-09-12. Intended as scaffolding; replace stubs with real control-plane and guard checks.
