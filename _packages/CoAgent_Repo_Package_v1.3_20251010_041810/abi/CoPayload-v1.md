# CoPayload ABI v1 (Draft Standard)
**Purpose:** Decouple planning/models from execution. Payloads must be portable, replayable, and auditable.

## MUST
- Provide `/payload/run.ps1` (entrypoint).
- Include `_copayload.meta.json` (intent, provenance, risk, budget).
- Emit `/_spanky/` with `checksums.json`, `_wrap.manifest.json`, and `out.txt` (status).

## SHOULD
- Provide `_hp.manifest.json` (execution order) when multiple steps exist.
- Include `/summaries/TLDR.md` and `/summaries/SOURCES.md`.

## MAY
- Provide signatures, additional manifests, and visualization graphs.

## Rejection Matrix (examples)
- Missing `run.ps1` → reject.
- No `_copayload.meta.json` → reject.
- No replay bundle → block deploy.