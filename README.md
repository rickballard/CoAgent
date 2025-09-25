## CoAgent MVP3 Plan

See **docs/CoAgent_MVP3_Plan.md** for the current product plan, install modes (Temporary vs Permanent), zero-footprint behavior, and training flow.
# CoAgent

Vendor-independent **BPOE middleware**: mandatory offloading (CoCache/CoTemp), heartbeat/guard with [OE:<glyph>], and multi-AI adapter.
**Scaffold only** — source-of-truth lives (for now) in:
- **CoCivium** (policies/specs)
- **CoModules** (PS7 tools & utilities)
- **CoCache** (sidecar prototypes)

Migration PRs will lift code/docs here; nothing moved yet.


---

**Consent-first, no-autostart.** See: [AUTOSTART_AND_CONSENT](docs/policy/AUTOSTART_AND_CONSENT.md) • [DEPENDENCIES](docs/DEPENDENCIES.md) • [TERMS (draft)](docs/legal/TERMS_DRAFT.md)

## Productization Manifest: CoAgent Assets & Locations

> Source of truth for where things live today. Keep this section updated as we move content in.

### Repos / Branches
- **Primary**: `rickballard/CoAgent` (branch: `main`) — app(s), policies, CI.
- **Source pools to draw from**: `CoCivium/CoModules`, `CoCivium/CoPolicies` (migration issue tracks provenance).

### Code & Project Tree
- **Launcher (manual-only)**: `src/CoAgent.Launcher/` → outputs to `src/CoAgent.Launcher/bin/Release/net8.0-windows/CoAgent.exe`
- **Tray helper (optional)**: `src/CoTray/` → outputs to `src/CoTray/bin/Release/net8.0-windows/CoTray.exe`
- **Solution**: `CoAgent.sln`
- **CI**: `.github/workflows/ci.yml`
- **Governance**: `.github/ISSUE_TEMPLATE/*`, `.github/PULL_REQUEST_TEMPLATE.md`, `CODEOWNERS`

### Runtime & Session State (Local machine)
- **Consent file** (required for any run): `%USERPROFILE%\.CoAgent\consent.json`
- **Ephemeral status** (tray watches): `%USERPROFILE%\CoTemps\status\`  
  - Signals: `SESSION_OK.txt`, `SESSION_WARN.txt`, `SESSION_FAIL.txt`, `SESSION_DONE.txt`
- **Workspace cache/logs**: `%USERPROFILE%\CoCache\…` (e.g., `CoCache\CoCivium\<topic>\<YYYY>\ <MM>\ <DD>\ *.snapshot.json`)

### PowerShell Tooling (BPOE)
- **Required shell**: PowerShell 7+ (`winget install Microsoft.PowerShell`)
- **BPOE module home (convention)**: `%USERPROFILE%\Documents\WindowsPowerShell\Modules\CoBPOE\`
  - Example job: `CoHeartbeat.ps1` (tray menu: Stop/Resume via Start-Job/Stop-Job)
- **Scripts are **opt-in** only**; nothing runs without explicit user action.

### Dependencies (Declared & Minimal)
- **.NET 8 SDK** (build) / **Desktop Runtime** (run): `winget install Microsoft.DotNet.SDK.8`
- **GitHub CLI** (DevOps): `winget install GitHub.cli`
- **Windows Explorer** (open folders from tray): built-in
- Full list: see [`docs/DEPENDENCIES.md`](docs/DEPENDENCIES.md)

### Policy / Legal / Consent
- **No autostart by default**, consent-first: [`docs/policy/AUTOSTART_AND_CONSENT.md`](docs/policy/AUTOSTART_AND_CONSENT.md)
- **Terms (draft, needs counsel)**: [`docs/legal/TERMS_DRAFT.md`](docs/legal/TERMS_DRAFT.md)
- **Principles**: No corruption • No coercion • No kings. Revocation is first-class.

### CI/CD Notes
- Current workflow: placeholder lint/build on pushes/PRs; target runners: `windows-latest` (for .NET desktop)
- Future: add script lint, schema validation, signing, and release pipelines.

### Packaging / Distribution (TBD)
- Installer & signing: **TBD** (MSIX/winget/GitHub Releases)
- Update channel(s): **TBD**
- Provenance/attestations: **TBD**

### Migration Checklist (Pointers)
- CoAgent-related specs/policies/tools to import:
  - CoPolicies: governance, ethics, consent wording (**preserve history if possible**)
  - CoModules (PS): `CoHeartbeat`, `CoGuard`, `CoWrap`, `CoTemps.Watcher`, `CoCache.Load`
  - Adapter envelope stubs → `src/adapters/*` (interfaces + tests)
- Tracking issue: _“Migration PR Plan: lift from CoCivium/CoModules”_ (see repo issues)

---

