(() => {
  const sel = document.querySelector("#sandbox-toggle");
  if (!sel) return;
  const key = "coagent.sandbox.mode";

  const apply = (mode) => {
    try { localStorage.setItem(key, mode); } catch {}
    sel.value = mode;
    const s = document.querySelector("#status,#tstatus");
    if (s) s.textContent = (s.textContent||"").replace(/(Offline|Online)/g,"")
  } 

  // Load config default
  fetch((location.pathname.includes("/training/")?"../":"./") + "config.json")
    .then(r => r.json()).then(cfg => {
      let mode = (new URLSearchParams(location.search).get("sandbox") === "on") ? "online" : null;
      if (!mode) try { mode = localStorage.getItem(key) } catch {}
      if (!mode) mode = (cfg.mode === "online") ? "online" : "offline";
      apply(mode);
    }).catch(()=>apply("offline"));

  sel.addEventListener("change", e => apply(e.target.value));
})();
