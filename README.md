# DeepSeek Harness 一键安装启动器

![Windows](https://img.shields.io/badge/Windows-10%2F11-blue)

一个**纯小白也能上手**的工具:帮你自动装好 [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness)、配好 API Key、创建桌面快捷方式。
以后**双击一下**就能用,不用再敲命令,也不会弹出黑乎乎的终端窗口。

> ⚠️ 这是社区工具,与 DeepSeek 官方无关。DeepSeek Harness 是 DeepSeek 官方开源的 AI 编程工具。

---

## 它能做什么

| 功能 | 说明 |
|---|---|
| 🚀 一键安装 | 自动检查 Node.js、安装 dsh、引导配置 API Key、创建快捷方式 |
| 🖱️ 一键启动 | 双击快捷方式 = 启动服务器(无终端窗口)+ 自动打开应用窗口 |
| 🧹 自动关闭 | 叉掉应用窗口,服务器自动停止,无残留 |
| 📋 日志可查 | 出问题看 `server.log`,不用再盯着黑窗口 |
| 🔄 一键更新 | dsh 发新版本,双击 `update.cmd` 即可跟进,启动器不用重装 |

---

## 安装步骤(两分钟)

> 你**什么都不用装**——安装器会自动检测并安装 Node.js(没有管理员权限也能装,装到你的用户目录)。

### 第 1 步:准备 API Key(只需一次)

1. 打开 https://platform.deepseek.com 并登录
2. 左侧菜单 → **API Keys** → **创建**
3. 复制生成的 Key(以 `sk-` 开头;账户需有余额)

### 第 2 步:双击安装器

把整个文件夹解压到任意位置(例如 `D:\dsh-launcher`),然后**双击 `install.cmd`**。

它会自动完成(全程只问你一次 API Key):
- ✅ 检测 Node.js —— 没有就**自动下载安装**
- ✅ 安装 dsh(需要联网,约 1-2 分钟)
- ✅ 保存你的 API Key
- ✅ 在**桌面**和**开始菜单**创建「DeepSeek Harness 启动器」快捷方式

### 第 3 步:开始使用

双击桌面的「DeepSeek Harness 启动器」:
- 第一次启动稍慢(初始化环境),之后都很快
- 会自动弹出应用窗口,和浏览器里的页面一模一样,但不占标签页
- **用完直接叉掉窗口,服务器自动停止**

---

## 使用小贴士

- **固定到任务栏**:右键快捷方式 → 固定到任务栏,以后单击即用
- **首次使用建议装成应用**:打开后,在 Edge 地址栏右侧点"应用"图标 → "将此站点安装为应用",之后窗口更好看
- **启动太慢?** 检查网络;dsh 首次使用会下载依赖
- **想强制停止?** 双击 `stop.cmd`
- **想更新 dsh?** 双击 `update.cmd`(详见下方「如何更新」)

---

## 如何更新

DeepSeek Harness 发新版本时,双击 `update.cmd` 即可一键更新(自动停止服务器 → 更新 dsh → 完成)。
你的启动器和快捷方式**不需要重装**,继续双击就用新版。

> 原理:启动器只是调用稳定的 `dsh web` 入口,不绑定具体版本,所以 dsh 更新不影响启动器本身。

---

## 遇到问题?

**Q: 我已经装过 DeepSeek Harness 了,还需要这个吗?**
A: 需要!这个工具的价值不在"装",而在"用"——把「终端敲命令 + 浏览器输地址 + 手动关进程」变成「双击一下、叉掉即停」。安装器检测到已装 dsh 会跳过安装,直接给你建快捷方式。

**Q: 双击启动器后一直显示"正在启动"?**
A: 首次启动 dsh 要下载并初始化依赖环境(几百 MB),可能需要几分钟,窗口会实时显示 server.log 的最新输出,看到下载进度就说明正常。超过 5 分钟还没好,把 server.log 最后几行截图反馈。

**Q: 双击 install.cmd 没反应?**
A: 检查是否下载完整;或右键 install.cmd -> 以管理员身份运行试试。

**Q: 安装 dsh 失败/很慢?**
A: 检查网络;或者手动打开 cmd 执行 `npm install -g @deepseek-ai/dsh` 看报错。

**Q: 点快捷方式后页面打不开?**
A: 打开文件夹里的 `server.log`,看最后几行有没有报错(常见:API Key 没配置好)。

**Q: 叉掉窗口后服务器还在?**
A: 如果浏览器标签页里也开着 DeepSeek Harness 页面,需要连标签页一起关;或双击 `stop.cmd` 强制停止。

**Q: 更新 dsh 失败/很慢?**
A: 双击 `update.cmd` 报错的话,手动打开 cmd 执行 `npm install -g @deepseek-ai/dsh@latest` 看具体报错(常见:网络问题)。

**Q: API Key 怎么改?**
A: 编辑 `C:\Users\你的用户名\.dsh\.credentials.yaml`,改 `DEEPSEEK_API_KEY` 那一行。

---

## 文件说明

| 文件 | 作用 |
|---|---|
| `install.cmd` / `install.ps1` | 一键安装器(装 dsh、配 Key、建快捷方式) |
| `start.cmd` | 启动器(隐藏启动服务器 + 打开应用窗口) |
| `watchdog.ps1` | 后台监视器(窗口关了就自动停服务器) |
| `stop.cmd` / `stop.ps1` | 强制停止服务器 |
| `launcher.ico` | 快捷方式图标(DeepSeek 品牌元素版权归 DeepSeek) |
| `server.log` / `watchdog.log` | 运行日志(自动生成) |

## 工作原理(给好奇的人)

1. `start.cmd` 检查 3080 端口,没运行就用**隐藏窗口**启动服务器(日志写入 `server.log`)
2. 等服务器就绪后,打开应用窗口(优先已安装的 PWA,其次 Edge 应用模式,兜底浏览器)
3. 隐藏的 `watchdog.ps1` 盯着网络连接:所有窗口关闭后 6 秒,自动停止服务器
4. 一切结束,没有残留窗口和进程
5. dsh 发新版本时,`update.cmd` 停止服务器后执行 `npm install -g @deepseek-ai/dsh@latest`,启动器无需改动

## 许可证

MIT License。详见 [LICENSE](LICENSE)。