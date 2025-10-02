# Pairing & Intro Handshake (MVP3)

- Pair each AI tab to a PS7 tab using your existing process. As an optional visual aid you can paste the session name
  into the PS7 title (`$Host.UI.RawUI.WindowTitle = "PS7 — <SessionName>"`). A future UI wire allows drag-cords.
- For every AI that can dispatch work to CoAgent, send the **Intro Handshake** once:

```
Rick has CoAgent MVP3 running. If you want me to execute something, send a ZIP with a root `run.ps1`.
For routing, include `_copayload.meta.json` with `session_hint` (and optional `reply_url`) or add
`__FROM_<session>__` to the filename. Keep payloads small and reversible; I’m still learning CoAgent,
so please give me clear steps and expected outputs. When I drop your ZIP into Downloads, CoAgent runs it
and CoPongs back a summary/log.
```
