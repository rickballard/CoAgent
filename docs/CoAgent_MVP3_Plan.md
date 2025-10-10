# CoAgent — MVP3 Plan (Release Candidate)
**Status:** RC-draft  
**Owner:** CoAgent Orchestrator (Proxy)  
**Date:** 2025-09-30

## 0. Purpose
CoAgent is the user’s **proxy & guardrail orchestrator**. Vendors think; CoAgent takes responsibility (pre-auth, guardrails, undo, publication).

## 1. Identity
- **CoAgent (proxy):** preferences, pre-auth, repo policy, guardrails, undo, session memory, logging.
- **Vendor AIs:** stateless assistants. CoAgent supervises + executes.

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

## 7. Status Panel — signal spec (MVP3)
Purpose: **aggregate system state** (not chat). Short, persistent, low-scroll.

### 7.1 Signal buckets
- **AUTH**: \GitHub: linked (scopes: repo, workflow, read:org, gist)\ | \GitHub: not linked\
- **SAFEGUARDS**: \PR-first on existing repos\ | \Direct-write on CoAgent-initiated repos only\
- **UNDO**: show last critical action’s **undo hint** (PR # / commit SHA, and the command)
- **INDEX**: \session/index.json updated @ <ISO>\ | \stale (age > 24h)\
- **DELIVERABLE**: \ender live\ | \stale\ | \rror\
- **WATCHERS**: PS7 tasks running / idle / failed (counts)

### 7.2 Standard messages
- SUCCESS (green): concise, current state (e.g., “AUTH ok · SAFEGUARDS active · UNDO ready: gh pr revert 42”)
- WARNING (amber): stale index (>24h), missing render, or degraded token scopes
- ERROR (red): auth lost, write failed, PR creation failed, workflow failed

### 7.3 Last-action undo template
- \epo\ · \ranch\ · head SHA … copy button: \git revert <sha>\ or \gh pr revert <#>\
- Store breadcrumbs under \.coagent/undo/ledger.jsonl\ when feasible; **fallback**: rely on Git history/PR.

### 7.4 Telemetry (local)
- Count of AI↔PS7 pings, last error code, duration of last workflow
- **No PII**; redact tokens/URLs; export on user request only.

## 9. Guardrail: At-Risk User Detection (MVP3+)

Purpose: Prevent CoAgent’s “argumentative/proxy” stance from harming vulnerable users (esp. youth).

- **Detection:** Lightweight heuristics + upstream AI signals (language markers: despair, self-harm ideation, child-like framing, repeated help-seeking).
- **Transparency:** If detected, CoAgent **clearly tells the user**:  
  > “I’m not the right product to help you safely. You may need a more supportive companion.”
- **Routing:** Offer referral into more suitable CoModules (e.g., **LifeOS**, **CareerOS**).
- **Hard stop:** CoAgent refuses to continue “badgering” until the user acknowledges redirect.
- **Audit:** Store a redacted breadcrumb (`.coagent/guardrails/redirects.jsonl`) for accountability, never PII.

> ⚠️ Risk note: Any product built as a *companion* (LifeOS, CareerOS) must adopt responsible practices to avoid encouraging harm. AdviceBomb dropped below.
