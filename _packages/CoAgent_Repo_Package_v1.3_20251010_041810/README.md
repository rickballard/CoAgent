# CoAgent Positioning & AgentKit Integration — Repo Package
**Version 1.3 — 2025-10-10** • **Owner:** CoAgent Productization

This package is repo‑ready: drop contents at the repo root and open a PR. It includes a positioning **Standard**, CI **boundary gates**, **parity eval** scaffolding, a **vendor one‑pager**, and an **AdviceBomb** replay bundle.

**TL;DR:** Prototype in ChatGPT; **ship in CoAgent**. Freeze **CoPayload ABI v1**, build the AgentKit importer, run **A↔B model‑swap drills**, and enforce **Replay‑or‑No‑Deploy** with boundary policy in CI (P0).

## Quick Install
1. Place all files at repo root.
2. Ensure Python 3.10+ available for CI helper scripts under `scripts/`.
3. Open PR. CI will run:
   - Boundary gate: `.github/workflows/boundary.yml`
   - Replay coverage check: `.github/workflows/replay-coverage.yml`

## Included
- **/docs/positioning/**: Positioning paper v1.3, vendor one-pager, agentkit integration guide
- **/abi/**: CoPayload ABI v1 (draft) + meta JSON schema
- **/policy/**: `coagent-boundary.yaml` + `.boundaryignore`
- **/evals/**: Swap drill fixtures + scorecard template
- **/examples/**: AgentKit example graph and compiled CoPayload stub
- **/.gh/.github/**: Composite action + workflows
- **/scripts/**: Tiny linters to enforce CI gates
- **/AdviceBombs/**: Replayable bundle with checksums and metadata

**License:** CC-BY-SA 4.0 (text), MIT (templates & scripts)