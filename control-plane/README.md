# Control Plane (stub)

Minimal local HTTP/WS server (to be implemented in your preferred stack).

## Endpoints (proposed)
- `POST /events` — append a Gibberlink event (validated).
- `GET  /events/stream` — Server-Sent Events or WS with unified event stream.
- `POST /exec/start` — start a job (validates JobSpec + policy).
- `POST /exec/stdin` — write to a job.
- `POST /exec/stop` — stop a job.
- `GET  /health` — liveness probe.

See `schemas/` for JSON Schemas.
