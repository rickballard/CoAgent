(() => {
  const el = {
    bar: document.querySelector("#statusbar"),
    clock: document.querySelector("#status-clock"),
    ver: document.querySelector("#status-version"),
    net: document.querySelector("#status-net")
  };
  if (!el.bar) return;

  // clock
  const fmt2 = (n)=> String(n).padStart(2, "0");
  const tick = () => {
    const d = new Date();
    if (el.clock) el.clock.textContent = `${fmt2(d.getHours())}:${fmt2(d.getMinutes())}:${fmt2(d.getSeconds())}`;
  };
  tick(); setInterval(tick, 1000);

  // version
  fetch("./version.json").then(r=>r.json())
    .then(v => { if (el.ver) el.ver.textContent = v.version || "dev"; })
    .catch(()=>{ if (el.ver) el.ver.textContent = "dev"; });

  // connectivity: offline/online + sandbox reachability
  const setNet = (txt, ok) => {
    if (!el.net) return;
    el.net.textContent = txt;
    el.net.setAttribute("data-ok", ok ? "1" : "0");
  };

  const probe = async () => {
    // quick local online/offline
    if (!navigator.onLine) { setNet("Offline", false); return; }

    // read config + deciding if sandbox is enabled
    const root = location.pathname.includes("/training/") || location.pathname.includes("/policy-demo/")
      ? "../" : "./";
    let cfg = { mode:"offline", sandboxUrl:"" };
    try { cfg = await fetch(root + "config.json").then(r=>r.json()); } catch {}

    // reflect sandbox toggle/localStorage
    let mode = "offline";
    try {
      const m = localStorage.getItem("coagent.sandbox.mode");
      if (m) mode = m;
      else mode = (cfg.mode === "online") ? "online" : "offline";
    } catch {}

    if (mode !== "online") { setNet("Local only", false); return; }
    if (!cfg.sandboxUrl)    { setNet("Online (no endpoint)", true); return; }

    // HEAD/GET with short timeout to sandbox
    const ctl = new AbortController();
    const t = setTimeout(()=>ctl.abort(), 3000);
    try {
      const res = await fetch(cfg.sandboxUrl, { method:"HEAD", mode:"cors", signal:ctl.signal });
      clearTimeout(t);
      setNet(res.ok ? "Online • Sandbox OK" : "Online • Sandbox ?", res.ok);
    } catch {
      clearTimeout(t);
      setNet("Online • Sandbox unreachable", false);
    }
  };

  probe();
  window.addEventListener("online",  ()=>probe());
  window.addEventListener("offline", ()=>probe());
})();
