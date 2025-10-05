/* panels.js — per-panel refresh/kill controls
   Conventions:
   - Each panel root has: class="panel" data-panel-id="status|ai|browser|terminal|..."
   - Optional: data-title for button tooltip/label
   - Add a child <div class="panel-head"></div> or we create one
   Buttons:
   - ↻ Soft refresh (no cache bust, re-run loaders)
   - ⟲ Hard refresh (cache-bust + SW unregister + local state clear)
   - ✖ Close (remove panel)
*/
(function () {
  const q = (sel, r=document)=>r.querySelector(sel);
  const qa = (sel, r=document)=>Array.from(r.querySelectorAll(sel));
  const nowTag = ()=>Date.now().toString(36);

  // Util: cache-busting URL
  function bust(url) {
    try {
      const u = new URL(url, location.href);
      u.searchParams.set("_cb", nowTag());
      return u.toString();
    } catch { return url + (url.includes("?") ? "&" : "?") + "_cb=" + nowTag(); }
  }

  async function unregisterServiceWorkers() {
    if (!("serviceWorker" in navigator)) return;
    try {
      const regs = await navigator.serviceWorker.getRegistrations();
      await Promise.all(regs.map(r => r.unregister().catch(()=>{})));
    } catch {}
  }

  // Panel-specific soft refresh hooks (no page reload)
  const softRefreshers = {
    status: () => {
      // Ask status.js to re-probe & tick
      document.dispatchEvent(new CustomEvent("coagent:refresh:status"));
    },
    ai: () => {
      // Nothing heavy; clear AI buffer if present
      const buf = q("#ai-buffer"); if (buf) buf.textContent = "";
    },
    browser: (panel) => {
      // If panel contains an iframe, reload it (no cache bust)
      const f = q("iframe", panel); if (f) f.contentWindow?.location?.reload();
    },
    terminal: () => {
      // For an embedded xterm/PS7 host, emit a custom event your terminal code listens to
      document.dispatchEvent(new CustomEvent("coagent:refresh:terminal"));
    }
  };

  // Panel-specific hard refresh hooks
  const hardRefreshers = {
    status: async () => {
      // Clear minimal local caches used by status/logger
      try { localStorage.removeItem("coagent.sandbox.mode"); } catch {}
      document.dispatchEvent(new CustomEvent("coagent:refresh:status"));
    },
    ai: async () => {
      // Nuke any local AI draft if you store it later
      try { localStorage.removeItem("coagent.ai.draft"); } catch {}
      const buf = q("#ai-buffer"); if (buf) buf.textContent = "";
    },
    browser: async (panel) => {
      const f = q("iframe", panel);
      if (f) { f.src = bust(f.src); return; }
      // If it’s just a div, try a location bust of the whole page section
      document.dispatchEvent(new CustomEvent("coagent:refresh:browser"));
    },
    terminal: async () => {
      document.dispatchEvent(new CustomEvent("coagent:hardrefresh:terminal"));
    }
  };

  function decoratePanel(panel) {
    if (!panel || panel.dataset.decorated) return;
    panel.dataset.decorated = "1";
    panel.classList.add("panel");

    let head = q(":scope > .panel-head", panel);
    if (!head) {
      head = document.createElement("div");
      head.className = "panel-head";
      head.innerHTML = `
        <div class="panel-title"></div>
        <div class="panel-actions">
          <button class="panel-btn panel-refresh" title="Refresh (Ctrl+R)">↻</button>
          <button class="panel-btn panel-hard"    title="Hard refresh (Ctrl+Shift+R)">⟲</button>
          <button class="panel-btn panel-close"   title="Close">✖</button>
        </div>`;
      panel.prepend(head);
    }
    const title = q(":scope > .panel-head .panel-title", panel);
    if (title && !title.textContent.trim()) {
      title.textContent = panel.getAttribute("data-title") || panel.getAttribute("data-panel-id") || "Panel";
    }

    const id = panel.dataset.panelId || "unknown";
    const refreshBtn = q(".panel-refresh", head);
    const hardBtn    = q(".panel-hard", head);
    const closeBtn   = q(".panel-close", head);

    refreshBtn?.addEventListener("click", () => {
      (softRefreshers[id] || (()=>{}))(panel);
      // visual ping
      panel.setAttribute("data-ping","1");
      setTimeout(()=>panel.removeAttribute("data-ping"), 250);
      try { window.CoLog?.log("panel_refresh", { id, mode:"soft" }); } catch{}
    });

    hardBtn?.addEventListener("click", async () => {
      await unregisterServiceWorkers();
      (hardRefreshers[id] || (()=>{}))(panel);
      panel.setAttribute("data-ping","1");
      setTimeout(()=>panel.removeAttribute("data-ping"), 250);
      try { window.CoLog?.log("panel_refresh", { id, mode:"hard" }); } catch{}
    });

    closeBtn?.addEventListener("click", () => {
      try { window.CoLog?.log("panel_close", { id }); } catch {}
      panel.remove();
    });

    // Keyboard shortcuts scoped to panel focus
    panel.addEventListener("keydown", (e) => {
      const ctrl = e.ctrlKey || e.metaKey;
      if (ctrl && !e.shiftKey && e.key.toLowerCase()==="r") { e.preventDefault(); refreshBtn?.click(); }
      if (ctrl &&  e.shiftKey && e.key.toLowerCase()==="r") { e.preventDefault(); hardBtn?.click(); }
    });
  }

  // Auto-decorate any .panel on load
  qa(".panel").forEach(decoratePanel);

  // Observe for dynamically added panels (e.g., new browser tabs)
  new MutationObserver(muts => {
    muts.forEach(m => m.addedNodes.forEach(n => {
      if (n.nodeType===1 && n.classList?.contains("panel")) decoratePanel(n);
    }));
  }).observe(document.body, { childList:true, subtree:true });
})();
