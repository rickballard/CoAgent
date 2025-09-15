# RFC: Gibberlink v0.1

**Purpose:** A small, durable event protocol for human/AI/runners to collaborate with auditability and policy enforcement.

## Transport
- JSON/NDJSON over WebSocket (WS) and HTTP POST for non-stream events.
- Events are **append-only**; the event log is the source of truth.

## Envelope
```json
{
  "id": "evt_01H...", "ts": 1736720000000,
  "type": "ExecRequest",
  "topic": "design",
  "actor": {"kind":"human|ai|system", "id":"user:rick"},
  "session": "code", 
  "body": {...},
  "meta": {"reptag": [], "scripttag": [], "congruence": null}
}
```

## Core Events
- `PromptSent` { session, messages[], attachments[] }
- `ToolCall` { session, name, args }
- `ExecRequest` { runnerId, jobSpec }
- `ExecStarted` { jobId, runnerId, image, cmd }
- `ExecOutput` { jobId, stream:"stdout|stderr", chunk }
- `ExecEnded` { jobId, exitCode, usage }
- `ArtifactSaved` { artifactId, uri, sha256, bytes }
- `Heartbeat` { agentId, status, latencyMs, uptimeS, versions }
- `FeedbackNote` { kind:"bug|idea|praise", text }
- `PolicyDenied` { reason, ruleId }
- `Synthesis` { fromSessions[], summary, deltas }

## Policy Hooks (Congruence Guard)
- Pre-dispatch checks: role/RBAC, TTL/budget caps, content filters (CoCleanse), secret scopes.
- Post-run checks: artifact completeness, provenance (image@sha, env lock), congruence scoring.

## JobSpec (runner-agnostic)
```json
{
  "image": "ghcr.io/powershell/powershell:7.4",
  "cmd": ["pwsh","-NoLogo","-NoProfile","-Command","-"],
  "env": {"FOO":"bar"},
  "workdir": "/work",
  "mounts": [{"type":"bind","src":"/host/project","dst":"/work","ro":false}],
  "limits": {"cpu":"1","memory":"1Gi"},
  "ttlSeconds": 1800,
  "secrets": ["GH_TOKEN"]
}
```

## RepTag & ScripTag (optional v1.1 fields)
- `meta.reptag`: evidence-backed reputation markers.
- `meta.scripttag`: provenance tags for scripts/binaries executed.

## Versioning
- `x.y`: bump **y** for new event types; bump **x** for breaking changes.
