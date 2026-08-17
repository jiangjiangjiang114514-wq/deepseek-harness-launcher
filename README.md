# DeepSeek Harness 一键启动器 (dsh-launcher)

为 [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness) 提供**双击即用**的启动体验:
点一下 → 服务器静默启动(无终端窗口)→ 自动打开独立应用窗口;叉掉窗口 → 服务器自动停止。再也不用每次在终端敲 `npx @deepseek-ai/dsh web`。

> ⚠️ 本项目是社区工具,与 DeepSeek 官方无关。

## 特性

- ✅ **一键启动**:双击快捷方式,自动启动服务器 + 打开应用窗口
- ✅ **无终端窗口**:服务器完全隐藏后台运行(日志写入 `server.log`)
- ✅ **自动关闭**:关闭应用窗口后约 6 秒,服务器自动停止,无残留进程
- ✅ **独立窗口**:优先打开已安装的 Edge 应用(PWA),否则以 Edge 应用模式打开,不占浏览器标签页
- ✅ **自动兜底**:应用窗口打不开时自动用浏览器打开,保证"点了一定有反应"
- ✅ **可诊断**:`server.log`(服务器日志)、`watchdog.log`(监视器日志)

## 环境要求

- Windows 10 / 11
- [Node.js](https://nodejs.org) ≥ 18(能运行 `npx @deepseek-ai/dsh web` 即可)
- Microsoft Edge
- 已配置好 DSH 环境(API key 等,即 `npx @deepseek-ai/dsh web` 能正常启动)

## 快速开始

1. 下载本仓库(或 `git clone`)
2. (可选,推荐)全局安装 dsh,启动更快:
   ```
   npm install -g @deepseek-ai/dsh
   ```
   安装后脚本仍可用;未安装时脚本自动走 npx。
3. 运行安装脚本创建快捷方式:
   ```
   powershell -ExecutionPolicy Bypass -File install.ps1
   ```
   会在**开始菜单**和**桌面**创建「DeepSeek Harness Launcher」快捷方式。
4. 双击快捷方式即可使用。建议右键快捷方式 → **固定到任务栏**,以后单击即用。

### 首次使用建议:安装为应用(PWA)

启动一次后,在 Edge 中打开 `http://127.0.0.1:3080`,点地址栏右侧的 **应用图标**(或 ⋯ → 应用 → 将此站点安装为应用),安装后启动器会自动以**独立应用窗口**打开(无地址栏,体验最佳)。

## 使用说明

| 操作 | 效果 |
|---|---|
| 双击「DeepSeek Harness Launcher」 | 服务器没运行则隐藏启动并等待就绪,然后打开应用窗口;已在运行则直接打开窗口 |
| 叉掉应用窗口 | 约 6 秒后服务器自动停止 |
| 运行 `stop.cmd` | 强制停止服务器(备用手段) |
| 查看 `server.log` | 服务器输出(以前终端里显示的内容) |

## 工作原理

1. **start.cmd** 检查端口 3080:未运行则用隐藏窗口启动服务器(`npx @deepseek-ai/dsh web`,日志重定向到 `server.log`),等待就绪
2. 打开应用窗口:优先已安装的 PWA(`shell:AppsFolder`),否则 Edge 应用模式(`--app=`),再否则浏览器
3. **watchdog.ps1**(隐藏进程)监视与服务器的连接:所有窗口关闭后连续 6 秒无连接 → 停止服务器进程树
4. 服务器停止后一切结束,无残留窗口/进程

## 常见问题

**Q: 点快捷方式没反应?**
A: 先看 `server.log` 是否有报错;确认能手动运行 `npx @deepseek-ai/dsh web`。

**Q: 应用窗口白屏?**
A: 服务器还没启动完成,稍等重试;或看 `server.log`。

**Q: 叉掉窗口后服务器没停?**
A: 如果你同时在浏览器标签页里开着 DSH 页面,连接仍在,监视器会等到标签页也关闭才停止。想立刻停用 `stop.cmd`。

**Q: 希望启动更快?**
A: `npm install -g @deepseek-ai/dsh` 后服务器跳过 npx 解析,启动明显变快。

## 文件说明

| 文件 | 作用 |
|---|---|
| `start.cmd` | 主启动器(启动服务器 + 打开窗口 + 拉起监视器) |
| `watchdog.ps1` | 隐藏监视器(窗口全关后自动停服务器) |
| `stop.cmd` / `stop.ps1` | 强制停止(备用) |
| `install.ps1` | 创建开始菜单/桌面快捷方式 |
| `check-appwindow.ps1` / `check-watchdog.ps1` | 自检辅助脚本 |
| `launcher.ico` | 快捷方式图标(基于 DeepSeek 品牌图标,版权归 DeepSeek) |
| `server.log` / `watchdog.log` | 运行时日志(自动生成) |

## 许可证

[MIT](LICENSE)。launcher.ico 中的 DeepSeek 品牌元素版权归 DeepSeek 所有。
