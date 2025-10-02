# CoAgent MVP3 — Product Description

## What it is
CoAgent is a desktop container pairing **AI chat tabs** with **PowerShell 7 tabs**. AI proposes small, reversible tasks as a ZIP with a root `run.ps1`. CoAgent executes under limits/consent and posts **CoPong** cards with logs/artifacts.

## Core
- AI tabs (left), PS7 tabs (right).
- Pairing: 1↔1 by default; optional many(AI)→1(PS7).
- Payloads: ZIP + `run.ps1` (+ `_copayload.meta.json` optional).
- CoPong: exit, log tail, artifact links, optional CivID signature.

## Storage (per user)
```
%USERPROFILE%\CoAgent\
  config\policy.json
  id\civid.json + civid.key
  incoming\
  work\{jobId}\
  audit\Audit.jsonl
```
