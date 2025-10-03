(() => {
  const sel = document.querySelector("#sandbox-toggle");
  if (!sel) return;
  const key = "coagent.sandbox.mode";

  function setStatusSuffix(mode) {
    const s = document.querySelector("#status") || document.querySelector("#tstatus");
    if (!s) return;
    const base = s.textContent.replace(/\s•\s(Sandbox:\s(Online|Offline))$/,'');
    s.textContent = `${base} • Sandbox: ${mode === "online" ? "Online" : "Offline"}`;
  }

  function apply(mode) {
    try { localStorage.setItem(key, mode); } catch {}
    sel.value = mode;
    setStatusSuffix(mode);
    try { window.CoLog?.log("sandbox_mode", { mode }); } catch {}
  }

  const isTraining = location.pathname.includes("/training/");
  const cfgUrl = (isTraining ? "../" : "./") + "config.json";

  fetch(cfgUrl).then(r=>r.json()).catch(()=>({mode:"offline"})).then(cfg=>{
    let mode = (new URLSearchParams(location.search).get("sandbox")==="on") ? "online" : null;
    if (!mode) try { mode = localStorage.getItem(key) } catch {}
    if (!mode) mode = (cfg.mode === "online") ? "online" : "offline";
    apply(mode);
    sel.addEventListener("change", e => apply(e.target.value));
  });
})();
