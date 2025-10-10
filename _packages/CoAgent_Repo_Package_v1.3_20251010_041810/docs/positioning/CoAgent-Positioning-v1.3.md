# STD‑001 — CoAgent Positioning: AI Vendor Strategy, AgentKit Integration & Product Guidance
**Version 1.3 — 2025-10-10**

> **Thesis:** We buy cognition; we own execution, evidence, and governance. CoAgent is the vendor‑neutral control plane. AI vendors are partners when they fit this contract.

## Executive Summary (v1.3)
AgentKit / Agent Builder and “apps in ChatGPT” increase **prototyping & distribution** power but do **not** replace the control plane. We will **embrace** those surfaces for UX/workflow iteration while **enforcing** execution under CoAgent with **Replay‑or‑No‑Deploy**, **Model‑Agnostic CoPayload ABI v1**, and **Human‑in‑the‑Loop** gates.

### Urgent Imperatives (P0, 90‑day)
- **Boundary Enforcement:** No secrets or production side‑effects inside vendor canvases. All runs hand off to CoAgent.
- **ABI Freeze:** Freeze **CoPayload ABI v1**. CI blocks merges that violate it.
- **A↔B Model‑Swap Drill:** Prove portability across 3 pipelines; publish diffs & remediation.
- **Replay Coverage ≥ 99%:** Every production run emits a signed replay bundle.

### Priority Matrix
| Priority | Initiative | Deliverable | Due | Owner |
|---|---|---|---|---|
| P0 | CoPayload ABI v1 Freeze | `abi/CoPayload-v1.md` + schema + CI check | +14d | Productization |
| P0 | AgentKit Bridge (Importer) MVP | `coagent-bridge-agentkit/ak-import` | +21d | Integrations |
| P0 | Replay Coverage 99% | CI gate + dashboard | +60d | Platform Eng |
| P0 | Model Swap Drill A↔B | `evals/swap-drill/` report + scorecard | +45d | Evals |
| P1 | CoAgent ChatGPT App (alpha) | Intent capture → CoAgent → signed bundle link | +45d | Integrations |
| P1 | Boundary Policy YAML | `policy/coagent-boundary.yaml` (CI-enforced) | +30d | Security |
| P2 | Vendor One‑Pager | `docs/positioning/vendor-one-pager.md` | +10d | BizDev |

### 30/60/90 Milestones
- **0–30:** ABI in main; boundary CI on; AK‑import MVP demo; swap fixtures ready.
- **31–60:** A→B on 3 pipelines; replay coverage ≥95%; CoAgent ChatGPT App (alpha); cost telemetry in reviews.
- **61–90:** A↔B↔A complete; coverage ≥99%; partner pilot with vendor one‑pager; importer supports capability mapping.

## Integration Contract (Recap)
**Input:** CoPayload (`/payload/run.ps1`, optional `_hp.manifest.json`, `_copayload.meta.json`).  
**Output:** Replay Bundle (`/_spanky/checksums.json`, `_wrap.manifest.json`, signatures, `out.txt`, plus `/payload/`, `/transcripts/`, `/summaries/`).  
**LLM role:** plan/transform only; **no direct side‑effects**.  
**CoAgent role:** validate → execute → capture → sign → publish → gate.

## Governance & Risk Controls
- Two‑key approvals; policy drift monitors; key rotation drills; per‑run budget caps; congruence gates (MeritRank).

## KPIs
Swap Time p95 ≤60m • Replay Coverage ≥99% • Secret Exposure 0 • Policy Drift MTTR ≤48h • Guardrail triggers <1% runs.

## FAQ (Blunt)
**Why not just live in ChatGPT?** It’s not an OS. We need audit/exit/controls.  
**Isn’t this slower?** We trade milliseconds for survivability.  
**What if vendor X blocks a use‑case?** We route around it (swap is first‑class).  
**Do vendors hate this?** Good ones don’t—governance grows the market.