(() => {
  const input  = document.querySelector("#ai-input");
  const send   = document.querySelector("#ai-send");
  const buffer = document.querySelector("#ai-buffer");
  if (!input || !send || !buffer) return;

  let thinking = false;
  const setThinking = (v) => {
    thinking = v;
    send.disabled = v;
    input.dataset.thinking = v ? "1" : "0";
    buffer.dataset.active   = v ? "1" : "0";
  };

  input.addEventListener("input", ()=>{ if (thinking) buffer.textContent = input.value; });
  input.addEventListener("keydown",(e)=>{
    if (thinking && e.key === "Enter" && !e.shiftKey) { e.preventDefault(); return false; }
  });

  async function callAI(prompt){
    // TODO wire real provider
    await new Promise(r=>setTimeout(r, 1500));
    return { ok:true, text:"OK" };
  }

  send.addEventListener("click", async ()=>{
    if (thinking) return;
    const prompt = input.value.trim();
    if (!prompt) return;

    try { window.CoLog?.log("ai_request_start", { chars: prompt.length }); } catch {}
    setThinking(true); buffer.textContent = "";

    let ok=false;
    try {
      const res = await callAI(prompt);
      ok = !!res?.ok;
      // TODO: render response
    } finally {
      setThinking(false);
      try { window.CoLog?.log("ai_request_finish", { ok, remainingChars: input.value.length }); } catch {}
    }
  });
})();
