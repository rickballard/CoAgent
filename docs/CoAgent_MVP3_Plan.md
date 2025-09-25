# CoAgent MVP3 – Product Plan (Working)

**Modes:** Temporary (zero‑footprint) and Permanent (opt‑in identity).  
**Guardrails:** Humangate, safe execution, explicit consent for any outbound data.  
**Pairing:** One ChatGPT session ↔ one PS7 panel (default).

## Temporary (Zero‑Footprint) Mode
- Runs from `CoTemp` under Downloads.
- Auto-uninstalls on exit or after 24h of inactivity.
- Nothing leaves the machine unless the user explicitly authorizes it.
- Anonymous by default.

## Permanent Mode (Optional Login)
- Local install + desktop shortcut (only with consent).
- Optional email-based sign-in to unlock: cross-device settings, update channel, and (opt-in) telemetry for UX improvement.
- MeritRank opt-in to publish ethical-intent attestations.

## Session Registry
- `Downloads/CoTemp/pairs/` contains `pair_<key>.json` entries for active sessions.
- Session key derived from URL (sanitized + underscore collapse).

## First-Run + Training
- Explains repos, CoCivium case-study, sandbox area, and “Idea Card” deliverable.
- Training is deterministic enough to guarantee a flattering, shareable artifact.
- Clear opt-in before anything is written to public repos.

## CoWraps (Autosummarize)
- Rolling snapshots when a session nears capacity.
- Always capture: TODOs, failures, advisories, NOW/NEXT/LATER, safe-resume hints.
- Stored under `CoTemp/session_<key>/cowraps/` and optionally mirrored into the repo.

## UI
- Rainbow header as a state/health meter; subtle motion during “thinking” with timeouts + recovery hints.
- PS7 output condensed: green success summaries; expandable details on demand.
- Ping/Pong pacing to avoid long speculative DO blocks.

## Road to Release
- ✅ MVP3 docs added (this file + first‑run help).
- ☐ Training sandbox in CoCivium + “Idea Card” template.
- ☐ Orchestrator refactor for stable pairing API and registry scan.
- ☐ Telemetry opt‑in + feedback capture module.
- ☐ Packaging and signed builds.
