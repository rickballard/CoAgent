# Consent, Autostart & User Agency (BPOE Policy)

- **No autostart by default.** CoAgent/CoTray **must never** launch at login unless the user **explicitly opts in**.
- **Explicit, informed consent** is required for any persistent behavior (autostart, background heartbeat, telemetry).
- **Revocation is first-class.** Users can disable/exit at any time without penalty; defaults revert to manual activation.
- **No corruption, no coercion, no kings.** Participation is voluntary; power remains with the user.

## Activation modes
- **Manual**: user launches from Start Menu, tray EXE, or repo script.
- **Ephemeral session**: started by website/deep link or script; exits when session ends.
- **Persistent (opt-in)**: user flips an in-app toggle; creates a visible Startup entry; can be removed by one click.

## Records
- Consent materializes as `~/.CoAgent/consent.json` with explicit flags (e.g., `"autostart": false` by default).
