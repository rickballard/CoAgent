# CoAgent — TRAINING (Guided walkthrough)

## Goal
Practice the full flow as a brand-new user and verify your environment.

### Part 1: Orientation (5 min)
- Open `/` → click UI Mock → browse quadrants (Model, Guardrails, Status, Logs).
- Open `/status.html` → confirm it loads `status.json`.

### Part 2: Smoke test (2 min)
```pwsh
pwsh -File tools\Test-MVP.ps1
```

Expected: 4/4 pages OK, `status.json: ✓ present`, CI guardrail smoke triggered.

### Part 3: Sandbox mode (2 min)
```pwsh
pwsh -File tools\Enter-Sandbox.ps1
pwsh -File tools\Test-MVP.ps1   # should still pass; no outbound required
```

### Part 4: Status refresh (1 min)
```pwsh
pwsh -File tools\Write-Status.ps1
```

### Part 5: BPOE metrics (2 min)
```pwsh
pwsh -File tools\Analyze-BPOE.ps1
```
