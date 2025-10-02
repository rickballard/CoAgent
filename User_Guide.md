# CoAgent MVP3 — User Guide

## Quick start
1. One AI tab + one PS7 tab, paired.
2. AI sends ZIP with `run.ps1` → approve.
3. CoPong appears with results + links.

## Packaging
- Root `run.ps1` (UTF‑8).
- Optional `_copayload.meta.json`:
```json
{ "schema":"copayload.meta.v1", "session_hint":"<tab>", "reply_url":"" }
```

## Guardrails
- Limits: size/files/timeout/concurrency.
- Scopes: fsWrite/process allowed; net/registry denied unless you approve.
- Audit: `audit/Audit.jsonl` (local).
