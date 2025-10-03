(() => {
  const el = {
    bar:  document.querySelector("#statusbar"),
    clock:document.querySelector("#status-clock"),
    ver:  document.querySelector("#status-version"),
    net:  document.querySelector("#status-net"),
    ex:   document.querySelector("#status-export")
  };
  if (!el.bar) return;

  const p2=(n)=>String(n).padStart(2,"0");
  const tick = () => {
    const d=new Date();
    if (el.clock)
      el.clock.textContent = `${d.getFullYear()}-${p2(d.getMonth()+1)}-${p2(d.getDate())} ${p2(d.getHours())}:${p2(d.getMinutes())}:${p2(d.getSeconds())}`;
  };
  tick(); setInterval(tick, 1000);

  fetch("./version.json").then(r=>r.json())
    .then(v=>{ if(el.ver) el.ver.textContent = v.version || "dev"; })
    .catch(()=>{ if(el.ver) el.ver.textContent = "dev"; });

  let lastNet = null;
  const setNet = (txt, ok) => {
    if (!el.net) return;
    el.net.textContent = txt;
    el.net.setAttribute("data-ok", ok ? "1" : "0");
    if (txt !== lastNet) {
      lastNet = txt;
      try { window.CoLog?.log("connectivity", { state: txt, ok: !!ok }); } catch {}
    }
  };

  const probe = async () => {
    if (!navigator.onLine) { setNet("Offline", false); return; }

    const root = (location.pathname.includes("/training/") || location.pathname.includes("/policy-demo/")) ? "../" : "./";
    let cfg = { mode:"offline", sandboxUrl:"" };
    try { cfg = await fetch(root + "config.json").then(r=>r.json()); } catch {}

    let mode = "offline";
    try {
      const m = localStorage.getItem("coagent.sandbox.mode");
      mode = m ? m : (cfg.mode === "online" ? "online" : "offline");
    } catch {}

    if (mode !== "online") { setNet("Local only", false); return; }
    if (!cfg.sandboxUrl)   { setNet("Online • No endpoint", true); return; }

    const ctl = new AbortController();
    const timer = setTimeout(()=>ctl.abort(), 3000);
    try {
      const res = await fetch(cfg.sandboxUrl, { method:"HEAD", mode:"cors", signal: ctl.signal });
      clearTimeout(timer);
      setNet(res.ok ? "Online • Sandbox OK" : "Online • Sandbox ?", res.ok);
    } catch {
      clearTimeout(timer);
      setNet("Online • Sandbox unreachable", false);
    }
  };

  probe();
  window.addEventListener("online",  probe);
  window.addEventListener("offline", probe);

  // Export link
  if (el.ex) el.ex.addEventListener("click", (e)=>{ e.preventDefault(); try{ window.CoLog?.export(); }catch{} });
})();
