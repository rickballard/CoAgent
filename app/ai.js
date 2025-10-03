/*
  ai.js
  - Disables Enter while "thinking"
  - Mirrors keystrokes into a buffer panel so users can see/type while waiting
  How to wire:
    - Textarea/input with id="ai-input"
    - Button with id="ai-send"
    - Div/span with id="ai-buffer" (read-only mirror)
*/
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

  // mirror as they type (only when thinking)
  input.addEventListener("input", ()=>{
    if (thinking) buffer.textContent = input.value;
  });

  // prevent Enter while thinking
  input.addEventListener("keydown",(e)=>{
    if (thinking && e.key === "Enter" && !e.shiftKey) {
      e.preventDefault();
      return false;
    }
  });

  // simulate an AI call wrapper (replace with your real call)
  async function callAI(prompt){
    // TODO: integrate real provider here
    await new Promise(r=>setTimeout(r, 1500));
    return "OK";
  }

  // click handler to send
  send.addEventListener("click", async ()=>{
    if (thinking) return;
    const prompt = input.value.trim();
    if (!prompt) return;
    setThinking(true);
    buffer.textContent = "";    // clear previous buffer
    try {
      const res = await callAI(prompt);
      // show response to user in your chat area...
    } finally {
      setThinking(false);
      // After thinking, if the user kept typing, leave their text in the input.
      // If you prefer to auto-send buffer, you can check buffer.textContent here.
    }
  });

})();
