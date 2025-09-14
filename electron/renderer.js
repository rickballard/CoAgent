(function(){
  const env = (window.CoAgentPaneSrc||{});
  const byId = id => document.getElementById(id);
  const set = (id, src) => { if (src) byId(id).src = src; };

  // default explanatory content for first run
  const defaultChat = "data:text/html,"+
    encodeURIComponent("<h2>Chat</h2><p>This pane will host your AI chat. For MVP we show a placeholder.</p>");
  const defaultOps = "data:text/html,"+
    encodeURIComponent("<h2>Ops</h2><ul><li>Watcher: logs acks to %USERPROFILE%/Downloads/CoTemp/Logs</li><li>Temp-only profile</li></ul>");

  set("chat", env.chat || defaultChat);
  set("ops",  env.ops  || defaultOps);
  set("exec", env.exec || "http://127.0.0.1:7681");

  // naive KPI: we don’t poke cross-origin; just reflect configured endpoints.
  const k = document.querySelector(".kpi");
  if (k){
    const execOk = !!env.exec;
    const chatOk = true; // always has default
    const opsOk  = true; // always has default
    k.innerHTML = `
      <span><span class="dot ${chatOk?'ok':'bad'}"></span>Chat</span>
      <span class="sep">·</span>
      <span><span class="dot ${opsOk?'ok':'bad'}"></span>Ops</span>
      <span class="sep">·</span>
      <span><span class="dot ${execOk?'ok':'bad'}"></span>Exec</span>
      <span class="sep">·</span>
      <span>BPOE: Temp session</span>
    `;
  }
})();
/* CoAgent: KPI warn toggle when Exec missing */
window.addEventListener('DOMContentLoaded', () => {
  try {
    const execSrc = (window.CoAgentPaneSrc||{}).exec;
    const k = document.querySelector('.kpi');
    if (k) k.classList.toggle('warn', !execSrc);
  } catch {}
});
