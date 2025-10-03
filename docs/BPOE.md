# CoAgent — BPOE (Best Practices of Execution)

## Principles
- File-first, PR-driven changes
- Minimal external dependencies
- Local JSONL instrumentation (no external telemetry)

## Where logs live
- `.coagent/logs/*.jsonl`

## What to track (MVP)
- `status`: ok | fail | redirected
- `duration_ms`: per-operation latency
- `guardrail`: redirect | none
- `op`: which tool or task

## Analyze
Run: `pwsh -File tools\Analyze-BPOE.ps1`
