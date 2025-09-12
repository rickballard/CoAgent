const { app, BrowserWindow, BrowserView } = require('electron');

function create() {
  const win = new BrowserWindow({ width: 1400, height: 900 });
  const chat = new BrowserView();
  const exec = new BrowserView();
  const ops  = new BrowserView();

  win.setBrowserView(chat); win.addBrowserView(exec); win.addBrowserView(ops);

  const layout = () => {
    const [w,h] = win.getSize();
    const chatW = Math.floor(w*0.58);
    const opsH  = Math.floor(h*0.28);
    chat.setBounds({ x:0, y:0, width:chatW, height:h-opsH });
    exec.setBounds({ x:chatW, y:0, width:w-chatW, height:h-opsH });
    ops.setBounds({ x:0, y:h-opsH, width:w, height:opsH });
  };
  layout(); win.on('resize', layout);

  chat.webContents.loadURL(process.env.COAGENT_CHAT_URL || "https://chat.openai.com/");
  exec.webContents.loadURL(process.env.COAGENT_EXEC_URL || "http://localhost:7681");
  ops.webContents.loadURL(process.env.COAGENT_OPS_URL  || "data:text/html,<h3>Ops/Tutor</h3><p>Notes and training live here.</p>");
}
app.whenReady().then(create);
