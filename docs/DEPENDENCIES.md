# BPOE Dependencies

| Component | Scope | Why | Install | Required by |
|---|---|---|---|---|
| **.NET 8 Desktop Runtime/SDK** | Runtime/Build | Build & run CoTray (Windows Forms tray helper) | `winget install Microsoft.DotNet.SDK.8` | CoTray |
| **PowerShell 7+** | Runtime | Shell automation (heartbeat/guard/offload) | `winget install Microsoft.PowerShell` | Co* scripts |
| **GitHub CLI (gh)** | Tooling | Repo ops, issues, CI interactions | `winget install GitHub.cli` | DevOps |
| **Windows Explorer** | OS | Open folders from tray | Built-in | CoTray |

> Principle: Dependencies are **declared, minimal, and revocable** (no hidden auto-services).
