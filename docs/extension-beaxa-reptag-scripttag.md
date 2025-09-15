# CoAgent v1.1 Extension: BeAxa + RepTag + ScripTag

## BeAxa (Monitor Persona)
- Skin for Congruence Guard messages (snarky, watchful).
- No change to rules; presentation layer only.

## RepTag
- Reputation annotations attached to `actor` or `session` (e.g., verified maintainer, prior infra breach).
- Stored in CoCache; surfaced in UI as badges.

## ScripTag
- Script provenance (author, review, hash, approvals) attached to `ExecRequest` and artifacts.
- Enforced by policy: unknown or unapproved ScripTags require HumanGate.
