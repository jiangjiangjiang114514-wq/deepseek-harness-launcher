# DeepSeek Harness One-Click Installer & Launcher

A beginner-friendly Windows tool for [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness):
installs dsh, configures your API key, creates shortcuts, starts the server **hidden**
(no console window) and opens the app window with one click. Closing the window stops
the server automatically.

> Community tool, not affiliated with DeepSeek.

## Quick start (Windows 10/11)

1. Get an API key at https://platform.deepseek.com (API Keys -> Create)
2. Unzip this repo, then **double-click \`install.cmd\`** — it auto-installs Node.js if missing (no admin needed), installs dsh, asks for your API key, and creates shortcuts at https://platform.deepseek.com (API Keys -> Create)
3. Unzip this repo, then **double-click `install.cmd`** (checks env, installs dsh,
   asks for your API key, creates Desktop & Start Menu shortcuts)
4. Double-click **DeepSeek Harness Launcher** and enjoy.

Close the app window -> server stops in ~6s. Use `stop.cmd` to force-stop.
Logs: `server.log` (server), `watchdog.log` (watcher).

## License

MIT.