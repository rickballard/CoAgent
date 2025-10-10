# AgentKit / Agent Builder Integration Guide
**Status:** Draft • **Audience:** Engineers

## Purpose
Use vendor canvases for **planning/UX**. Route **all execution** through CoAgent.

## Workflow
1. Author a flow in AgentKit (or similar).
2. Export (TS/Py/JSON). Run `ak-import` to compile into a **CoPayload**:
   - `/payload/run.ps1` stub or generated runner
   - `/_hp.manifest.json` from graph edges
   - `/_copayload.meta.json` with intent, risks, and budget
3. Submit PR with fixtures; CI runs parity evals.
4. (Optional) Use `ak-export` to visualize a CoPayload back in AgentKit.

## Security & Policy
- **No secrets** in vendor contexts.
- Non‑executable nodes marked **PLAN‑ONLY**.
- CoAgent enforces **Replay‑or‑No‑Deploy** and signs artifacts.

## CI Requirements
- Parity eval with golden fixtures.
- Replay Bundle digest attached to PR.
- Boundary policy checks pass.