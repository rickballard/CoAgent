# CoAgent Session Handover & CoWrap — Advice Bomb

**Why:** Sessions roll frequently (8–16h) for memory hygiene, anomalies, or milestone snapshots. This standard ensures we end, verify, and hand over cleanly.

## 1) Handover Triggers
- Timer-based hygiene (8–16h) • Behavior anomalies • Milestone snapshot • Ownership shift.

## 2) Termination Checklist (CoWrap)
- **Capture**: brief intent, pivots, decisions, assumptions, risks, dependencies.
- **Transcript** → `transcripts/session.md` (clean; no PII; include pivotal quotes if needed).
- **Payload** → `payload/` (md/ps1/json/png/svg/etc).
- **Notes** → `notes/`
  - `INTENTIONS.md` (mark unfinished with `(Unfinished)`), `ASSUMPTIONS.md`, `DECISIONS.md`,
    `DEPENDENCIES.md`, `RISKS.md`, `GLOSSARY.md`, `WEBSITE_MANIFEST.md`, `DEPRECATED.md`.
- **Summaries** → `summaries/` (`TLDR.md`, `ROADMAP_NOTES.md`, `SOURCES.md`).
- **Envelope** → `_spanky/`
  - `_copayload.meta.json`, `_wrap.manifest.json`, `checksums.json`,
  - `out.txt` first line: `[STATUS] items=<sum> transcripts=<#> payload=<#> notes=<#> summaries=<#>`.

## 3) Spanky ZIP Layout
```
Spanky_<ShortName>_<YYYYMMDD_HHMMSS>.zip
  /_spanky/ _copayload.meta.json, _wrap.manifest.json, out.txt, checksums.json
  /transcripts/ session.md
  /payload/    (all deliverables)
  /notes/      BPOE.md, INTENTIONS.md, DEPENDENCIES.md, DECISIONS.md, ASSUMPTIONS.md,
               RISKS.md, GLOSSARY.md, WEBSITE_MANIFEST.md, DEPRECATED.md
  /summaries/  TLDR.md, ROADMAP_NOTES.md, SOURCES.md
```

## 4) Verification Rules (structural)
- Required entries present (see §3).
- `out.txt` counts match actual contents (items = transcripts + payload + notes + summaries).
- No `MISSING_*` stubs unless justified in `INTENTIONS.md (Unfinished)` with next-steps.
- Optional: `checksums.json` matches current bytes.

## 5) Qualitative QA (session-owned)
- **Intent completeness** (scope, audience, interfaces).
- **Traceability** (links/IDs to repos, issues, prior sessions).
- **Coherence** (dedupe contradictions into `DEPRECATED.md` with pointers).
- **Dual-face readiness** (AI facts vs human narrative/visuals).
- **Exit criteria** met; regenerate zip if needed and re-verify.

## 6) Global Sweep (multi-session)
- Run `ops/Spanky-GlobalVerify.ps1` to scan `Downloads` and emit rework CSV + “Spanky ready:” lines.
- Run `ops/Spanky-BuildQAPacks.ps1` to assemble non-destructive QA packs with per-session CoPings.

## 7) Failure Modes & Fixes
- Bad/missing `_spanky/out.txt` → fix counts to reflect actual content.
- Transcript-only drops → declare gaps `(Unfinished)` in `INTENTIONS.md`, add notes/summaries, regen.
- Hidden dot-prefixed zips not found → verifier already includes dot-prefixed patterns (`.51_…`).

## 8) Governance
- Source-of-truth chain: repo → AI-face site → human-face site (document exceptions).
- Each handover: machine-verifiable Spanky zip + human-usable TLDR.
- Never overwrite prior deliverables; version with timestamps.
