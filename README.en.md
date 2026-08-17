# DeepSeek Harness Launcher (dsh-launcher)

One-click launcher for [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness) on Windows:
click once -> the server starts **hidden** (no console window) -> the app window opens automatically;
close the window -> the server stops itself. No more typing `npx @deepseek-ai/dsh web` every time.

> This is a community tool, not affiliated with DeepSeek.

## Features

- One-click start: server + app window
- Server runs fully hidden (logs go to `server.log`)
- Auto stop ~6s after the last window closes (watchdog)
- Opens the installed Edge PWA when available, otherwise Edge app-mode, otherwise the browser
- Fallback chain guarantees the click always does something
- Logs: `server.log` (server), `watchdog.log` (watcher)

## Requirements

- Windows 10/11, Node.js >= 18, Microsoft Edge
- A working DSH setup (`npx @deepseek-ai/dsh web` must start)

## Quick start

```
git clone https://github.com/<you>/deepseek-harness-launcher.git
cd deepseek-harness-launcher
npm install -g @deepseek-ai/dsh        # optional but faster
powershell -ExecutionPolicy Bypass -File install.ps1
```

Then double-click the **DeepSeek Harness Launcher** shortcut (Start Menu / Desktop / pinned to taskbar).

Tip: install the page as an Edge app once (open http://127.0.0.1:3080 -> address-bar app icon -> Install)
for the best standalone-window experience.

## How it works

`start.cmd` checks port 3080; if the server is down it starts `npx @deepseek-ai/dsh web` in a hidden
window (output redirected to `server.log`) and waits until it responds. It then opens the app window
(PWA -> Edge app-mode -> browser). A hidden `watchdog.ps1` watches the TCP connections to port 3080
and kills the server process tree 6 seconds after the last connection closes.

Use `stop.cmd` to force-stop anytime.

## License

MIT. DeepSeek brand elements in launcher.ico belong to DeepSeek.
