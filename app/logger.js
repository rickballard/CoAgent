/* logger.js — CoAgent event logger (localStorage ring buffer + export)
   - Stores up to 500 events in localStorage under "coagent.events"
   - Exposes window.CoLog.log(type, data) and window.CoLog.export()
*/
(() => {
  const KEY = "coagent.events";
  const MAX = 500;

  function load() {
    try { return JSON.parse(localStorage.getItem(KEY) || "[]"); }
    catch { return []; }
  }
  function save(arr) {
    try { localStorage.setItem(KEY, JSON.stringify(arr)); } catch {}
  }
  function nowIso() {
    const d=new Date();
    const p=n=>String(n).padStart(2,"0");
    return `${d.getFullYear()}-${p(d.getMonth()+1)}-${p(d.getDate())} `+
           `${p(d.getHours())}:${p(d.getMinutes())}:${p(d.getSeconds())}`;
  }
  function log(type, data) {
    const evs = load();
    evs.push({ t: nowIso(), type, data: data ?? null });
    if (evs.length > MAX) evs.splice(0, evs.length - MAX);
    save(evs);
  }
  function exportLog() {
    const blob = new Blob([ JSON.stringify(load(), null, 2) ], { type: "application/json" });
    const a = document.createElement("a");
    a.href = URL.createObjectURL(blob);
    a.download = `coagent-events-${Date.now()}.json`;
    document.body.appendChild(a);
    a.click();
    setTimeout(()=>{ URL.revokeObjectURL(a.href); a.remove(); }, 100);
  }

  window.CoLog = { log, export: exportLog };

  // stamp page load
  log("page_load", { path: location.pathname, href: location.href });
})();
