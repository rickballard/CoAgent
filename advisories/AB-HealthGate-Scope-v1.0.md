# Advice Bomb: HealthGate & Scope Guardrails (v1.0)

**Intent:** Keep CoAgent stable without becoming a PC optimizer.

## Scope Rules
- HealthGate preflight: **yes** (read-only checks).
- Deep “PC health” tuning: **no** (hand off to trusted tools on user consent).
- Always `Test-Path`-guard dot-sources and **never** auto-launch from profiles.

## HealthGate (read-only) Checks
- CPU/Power: active plan allows turbo; MaxFrequency not capped.
- Storage: SSD, ≥20% free, TRIM=on, SMART OK.
- Network: NIC ≥1 Gbps, error counters not rising.
- Memory: warn if >80% at idle.
- AV: detect active product (Defender/MBAM/etc); recommend correct exclusions.
- Input: detect hotkey storms / abnormal event rates.
- Git hygiene: fscache, preloadindex, gc.auto=0; flag huge untracked sets.
- Reliability: recent repeating crashers highlighted (last 7 days).

## Escalation (on fail)
- Offer fixes, but **defer deep diagnostics** to opt-in third-party tools (Sysinternals, HWiNFO, CrystalDiskInfo, vendor NVMe tools).
- Log `HealthGateReport.md` + `.json` with Pass/Fail + reasons; attach to run artifacts.

## HID Hygiene (lesson)
Physical keyboard/mouse faults can mimic software bugs. Include:
- Quick hardware check guidance (clean/replace).
- USB selective-suspend off for active HID (opt-in).

## Roadmap Nudge
- Add `modules/HealthGate.ps1` and call it before any heavy run.
- Ship a “Diagnostic Mode” toggle that (on consent) fetches portable tools and cleans them up after.

