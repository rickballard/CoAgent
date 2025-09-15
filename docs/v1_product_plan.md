# CoAgent v1 Product Plan

**Vision:** A provider‑agnostic, executor‑agnostic operator shell that coordinates multiple AIs and secure execution via **Gibberlink** (protocol) + **Congruence Guard** (policy). CoAgent doubles as onboarding into Civium (congruence mindset) and a practical multi‑AI workbench.

## 1. Scope (v1)
- **Shell (Electron/Tauri)** with 3 panes: Chat, Exec, Notes (Ops/Tutor).
- **Control Plane (local)**: HTTP + WebSocket, JSON events (Gibberlink v0.1), in‑process policy checks.
- **Runners:** Docker runner (images: pwsh, bash, python). JobSpec with TTL, resource caps, mounts.
- **Providers:** OpenAI, Anthropic, Ollama (switchable per session). Multi‑AI fan‑out with synthesis.
- **Guardrails:** Congruence Guard (RBAC, TTL/budget caps, HumanGate toggle, content filters via CoCleanse).
- **CoCache linkage:** append‑only NDJSON event log + artifact export (zip) per session.
- **Heartbeat:** periodic `Heartbeat` events; local aggregator and feed view in Notes pane.
- **Distribution:** one‑click binaries; web demo (mock panes); hero assets; badges.
- **Funding:** donation sliderule (Thanks→Donate→Patron) with transparent routing.
- **Feedback:** in‑app feedback events (`FeedbackNote`), opt‑in telemetry (anonymous).

## 2. Out of scope (defer to v2+)
- K8s/SSH/WinRM runners, ledger notarization, CRDT sync, marketplace UI, advanced orchestration (arbiter/roundtable policies), enterprise SSO/RBAC.

## 3. Milestones
- **M0 — Skeleton**: repo structure, configs, docs, stub control‑plane, Electron panes.
- **M1 — Single AI + single runner**: dispatch prompt, run code, capture artifacts, Congruence Guard minimal.
- **M2 — Multi‑AI concurrency**: router fan‑out/fan‑in, budgets/timeouts, synthesis.
- **M3 — Distribution & feedback**: installers, donation slider, feedback pane, heartbeat feed.
- **M4 — CoCache & Civium linkage**: congruence tags, export scrolls, badges.

## 4. Success metrics
- TTFX (time‑to‑first‑exec) < 5 min on fresh machine.
- ≥3 providers used in week 1; ≥2 runners exercised per user.
- Crash‑free sessions P95 ≥ 99%.
- ≥20% users enable donation slider; ≥30% submit feedback once.
- ≥50% of sessions export artifacts to CoCache.

## 5. Risks & mitigations
- **Auth/endpoint exposure** → ship Caddy + OAuth2 Proxy recipes; default localhost bindings.
- **DOM fragility with terminals** → prefer PTY sidecar API over DOM injection.
- **“Preachy” tone** → persona skins; default Game Master, optional Neutral/Archivist.

## 6. Team roles (suggested)
- Protocol/Control‑plane, Runner engineering, Shell/UX, Docs/Academy, Growth/Distribution.
