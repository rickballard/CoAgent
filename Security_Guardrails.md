# Security & Guardrails
```json
{
  "maxUnzippedMB": 200,
  "maxFiles": 1500,
  "defaultTimeoutSec": 180,
  "concurrency": 1,
  "requireMeta": false,
  "scopes": {"fsWrite":true,"process":true,"net":false,"registry":false}
}
```
Consent prompts on first use of restricted scopes; all runs are appended to `audit/Audit.jsonl`.
