# CoAgent — MVP3 Plan (Release Candidate)
**Status:** RC-draft  
**Owner:** CoAgent Orchestrator (Proxy)  
**Date:** 2025-09-30

## 0. Purpose
CoAgent is the user’s **proxy & guardrail orchestrator**. Vendors think; CoAgent takes responsibility (pre-auth, guardrails, undo, publication).

## 1. Identity
- **CoAgent (proxy):** preferences, pre-auth, repo policy, guardrails, undo, session memory, logging.
- **Vendor AIs:** stateless assistants. CoAgent supervises+executes.

## 2. UI (desktop-first)
Panels: **AI** (tabs), **PS7** (tabs), **Browser** (tabs; persistent “Latest Deliverable”), **Status** (signals only).

## 3. GitHub (MVP3)
- Scopes now: epo, workflow, ead:org, gist.
- Guardrails: PR-first on *existing* repos; direct-write only to **CoAgent-initiated** repos.
- Native undo: .coagent/undo/ledger.jsonl + PR template hints.

## 4. Session startup
gh auth status → repo index → shallow code search for plan/docs → write CoCache\session\index.json.

## 5. Deliverables visibility
Browser panel pins latest deliverable; AI can request snapshots.

## 6. Trust posture (transparent)
- Free, vendor-neutral; encourage upgrades when user-beneficial.
- CoCivium alignment: *no corruption, no coercion, no crowns*.
- Consulting firewall: any referral starts **pro bono**.

## 7. MVP3 must ship
- Four-panel spec + mocks.
- GitHub link-up + scope display.
- PR-first guardrails (fallback if protection API fails).
- Status panel shows last undo hint.
- Session index written.
- Draft PR for this plan.

## 8. MVP4 preview
- Up to 3 concurrent AI↔PS7 pairs.
- GitHub App (fine-grained).
- HP sandbox under CoCivium.
