const { app, BrowserWindow, Menu } = require("electron");
const path = require("path");

function buildMenu(){
  const tpl = [
    { label: "File", submenu: [
      { label: "Quit", role: "quit" }
    ]},
    { label: "View", submenu: [
      { label: "Reload", role: "reload" },
      { label: "Toggle DevTools", role: "toggleDevTools" }
    ]},
    { label: "Features (coming soon)", submenu: [
      { label: "Multi-tab Sessions", enabled: false },
      { label: "Backchatter", enabled: false },
      { label: "RepTags / ScripTags", enabled: false },
      { type:"separator" },
      { label: "Thanks Slider", enabled: false }
    ]},
    { label: "Help", submenu: [
      { label: "About CoAgent", click: () => { } },
      { label: "Docs / Roadmap", click: () => { } }
    ]}
  ];
  const menu = Menu.buildFromTemplate(tpl);
  Menu.setApplicationMenu(menu);
}

function createWindow () {
  const win = new BrowserWindow({
    width: 1280, height: 800, backgroundColor: "#0f1115",
    webPreferences: {
      preload: path.join(__dirname, "preload.js"),
      sandbox: true, contextIsolation: true, nodeIntegration: false
    }
  });
  win.loadFile(path.join(__dirname, "index.html"));
}

app.whenReady().then(() => {
  buildMenu();
  createWindow();
  app.on("activate", () => { if (BrowserWindow.getAllWindows().length === 0) createWindow(); });
});
app.on("window-all-closed", () => { if (process.platform !== "darwin") app.quit(); });
