const { contextBridge } = require("electron");
contextBridge.exposeInMainWorld("CoAgentPaneSrc", {
  chat: process.env.COAGENT_CHAT_URL || null,
  ops:  process.env.COAGENT_OPS_URL  || null,
  exec: process.env.COAGENT_EXEC_URL || null
});
