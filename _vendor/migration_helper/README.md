# CoAgent Migration Helper Pack

Use these scripts to **pull assets from other repos** into CoAgent with **breadcrumbs** so the Grand Migration can safely tidy up later.

## Scripts
- `tools/CoAgent.Assets.Migrate.ps1` — main importer (PS7).
- `tools/CoAgent.Breadcrumbs.Cleanup.ps1` — remove sidecars once consolidated.

## Example
```powershell
$repo = "$HOME\Documents\GitHub\CoAgent"
$sources = @(
  @{ Path="$HOME\Documents\GitHub\CoCivium"; Glob="docs\**\*.md"; Target="docs\_imports\CoCivium" },
  @{ Path="$HOME\Documents\GitHub\CoAgent-prototypes"; Glob="**\*";   Target="_imports\prototypes" }
)
pwsh -File .\tools\CoAgent.Assets.Migrate.ps1 -Repo $repo -Sources $sources -Commit -Push -PR
```

## Breadcrumbs
Per-file sidecar `*.from.txt` + central `docs/migration/ASSET_MANIFEST.ndjson`.
