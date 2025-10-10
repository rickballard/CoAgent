# Threat Model — CoAgent × LLM/AgentKit Boundary
**Scope:** Vendor canvases (ChatGPT apps/AgentKit), CoAgent runners, CI/CD, secrets, artifacts.

## Key Risks → Controls
- **Secret exposure in vendor context** → Boundary rule: no secrets; capability mediation; CI linter.
- **Policy drift / silent TOS change** → Drift monitor; emergency freeze; app fails closed.
- **Vendor lock‑in pressure** → Quarterly A↔B swap drills; ABI v1; importer/exporter canonical.
- **Unaudited side‑effects** → Replay‑or‑No‑Deploy; signatures; human approvals.
- **Cost runaway** → Per‑run budgets; caps; surfaced cost in reviews.