/* status-refresh-shim.js — fallback listener for panel refresh */
(() => {
  function tickClock() {
    const el = document.querySelector("#status-clock");
    if (!el) return;
    const p2=(n)=>String(n).padStart(2,"0");
    const d=new Date();
    el.textContent = `${d.getFullYear()}-${p2(d.getMonth()+1)}-${p2(d.getDate())} ${p2(d.getHours())}:${p2(d.getMinutes())}:${p2(d.getSeconds())}`;
  }
  document.addEventListener("coagent:refresh:status", () => {
    try { tickClock(); } catch {}
    try { window.dispatchEvent(new Event("online")); } catch {}
  });
})();
