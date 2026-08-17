# DeepSeek Harness 一键安装启动器

![Windows](https://img.shields.io/badge/Windows-10%2F11-blue)

一个**纯小白也能上手**的工具:自动装好 [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness)、配好 API Key、创建桌面快捷方式。
以后**双击一下**就能用——不用敲命令、没有黑窗口、关窗口自动停止。

> ⚠️ 这是社区工具,与 DeepSeek 官方无关。DeepSeek Harness 是 DeepSeek 官方开源的 AI 编程工具。

---

## 它能做什么

| 功能 | 说明 |
|---|---|
| 🚀 一键安装 | 自动装 Node.js(没有的话)→ 装 dsh → 引导配 API Key → 建快捷方式 |
| 🖱️ 一键启动 | 双击 = 启动服务器(无窗口后台运行)+ 自动打开应用窗口 |
| 🧹 自动关闭 | 叉掉应用窗口,服务器自动停止,无残留进程 |
| 🔄 一键更新 | dsh 发新版本,双击 update.cmd 跟进,启动器不用重装 |
| 📋 日志可查 | server.log 记录服务器一切输出,出问题一看便知 |
| 🩺 一键诊断 | 出问题先跑 diag.cmd,把输出截图反馈即可定位 |

---

## 安装步骤(约 5 分钟)

> 你**什么都不用装**——安装器会自动检测并安装 Node.js(免管理员,装到你的用户目录)。

### 第 1 步:准备 API Key(只需一次)

1. 打开 https://platform.deepseek.com 并登录
2. 左侧菜单 → **API Keys** → **创建**
3. 复制生成的 Key(以 `sk-` 开头;账户需有余额)

### 第 2 步:双击安装器

把整个文件夹解压到任意位置(例如 `D:\dsh-launcher`),然后**双击 `install.cmd`**。

它会自动完成(全程只问你一次 API Key):
- ✅ 检测 Node.js —— 没有就**自动下载安装**
- ✅ 安装 dsh(需要联网,约 1-2 分钟,网速慢请耐心)
- ✅ 保存你的 API Key
- ✅ 在**桌面**和**开始菜单**创建「DeepSeek Harness 启动器」快捷方式

### 第 3 步:开始使用

双击桌面的「DeepSeek Harness 启动器」:

- **第一次启动会比较慢(1~5 分钟)**:dsh 首次运行要下载并初始化环境依赖(几百 MB),这是正常的。启动窗口会实时显示进度(server.log 的内容),看到下载信息就说明在正常工作。
- 就绪后自动弹出应用窗口(没有的话会打开浏览器页面)
- **用完直接叉掉窗口,服务器自动停止**

---

## 使用小贴士

- **固定到任务栏**:右键快捷方式 → 固定到任务栏,以后单击即用
- **首次使用建议装成应用**:打开后,在 Edge 地址栏右侧点"应用"图标 → "将此站点安装为应用",之后窗口更好看
- **想更新 dsh?** 双击 `update.cmd`
- **想强制停止?** 双击 `stop.cmd`

---

## 如何更新

DeepSeek Harness 发新版本时,双击 `update.cmd` 即可一键更新(自动停止服务器 → 更新 dsh → 完成)。
启动器和快捷方式**不需要重装**。

> 原理:启动器只是调用稳定的 `dsh web` 入口,不绑定具体版本,所以 dsh 更新不影响启动器本身。

---

## 遇到问题?

**Q: 双击 install.cmd 没反应 / 一闪而过?**
A: 确认解压完整;如果窗口一闪而过,右键 install.cmd → 以管理员身份运行试试。

**Q: 双击启动器后窗口一闪而过,什么也没发生?**
A: 打开文件夹里的 `server.log` 看最后几行:
- 有 `dsh web: http://127.0.0.1:3080` → 服务器其实是好的,可能是浏览器没弹出来,手动打开 `http://127.0.0.1:3080` 即可
- 有报错(error/ENOTFOUND 等)→ 网络或配置问题,把内容截图反馈
- 空的 → 启动器没找到 dsh,运行 `diag.cmd` 看第 1 项

**Q: 一直显示"正在启动"?**
A: 首次初始化要下载几百 MB 依赖,1~5 分钟正常;窗口会显示 server.log 实时进度。超过 5 分钟,看 server.log 尾部是否有报错。

**Q: 我想手动测试服务器能不能启动?**
A: 按 Win+R 输入 `cmd` 回车,输入 `dsh web` 回车。看到 `dsh web: http://127.0.0.1:3080` 就是正常(服务器已启动,保持窗口开着)。

**Q: 我已经装过 DeepSeek Harness 了,还需要这个吗?**
A: 需要!这个工具的价值不在"装",而在"用"——把「终端敲命令 + 浏览器输地址 + 手动关进程」变成「双击一下、叉掉即停」。安装器检测到已装 dsh 会跳过安装,直接建快捷方式。

**Q: 服务器能跑,但启动器不弹窗口?**
A: 更新到最新版本(旧版有已知 bug:隐藏启动服务器的命令引号处理错误,会导致服务器根本没启动,表现为 server.log 为空)。

**Q: API Key 怎么改?**
A: 编辑 `C:\Users\你的用户名\.dsh\.credentials.yaml`,改 `DEEPSEEK_API_KEY` 那一行。

**Q: 出问题了,怎么把信息给你?**
A: 双击 `diag.cmd`,把窗口内容截图,连同 `server.log` 最后几行一起发来,基本就能定位。

---

## 文件说明

| 文件 | 作用 |
|---|---|
| `install.cmd` / `install.ps1` | 一键安装器(装 Node.js/dsh、配 Key、建快捷方式) |
| `start.cmd` | 启动器(隐藏启动服务器 + 打开应用窗口) |
| `launch-server.ps1` | 隐藏启动服务器的核心(按完整路径找 dsh/npx,不依赖 PATH) |
| `watchdog.ps1` | 后台监视器(窗口全关后自动停服务器) |
| `stop.cmd` / `stop.ps1` | 强制停止服务器 |
| `update.cmd` | 一键更新 dsh 到最新版 |
| `diag.cmd` | 一键诊断(出问题时先跑它) |
| `check-appwindow.ps1` / `check-watchdog.ps1` | 自检辅助脚本 |
| `launcher.ico` | 快捷方式图标(DeepSeek 品牌元素版权归 DeepSeek) |
| `server.log` / `watchdog.log` | 运行日志(自动生成) |

## 工作原理(给好奇的人)

1. `start.cmd` 检查 3080 端口:未运行 → 调用 `launch-server.ps1` 用**隐藏窗口**启动服务器(输出全部写入 `server.log`)
2. 等服务器就绪后打开应用窗口(优先已安装的 PWA → Edge 应用模式 → 浏览器兜底)
3. 隐藏的 `watchdog.ps1` 监视与服务器的连接:所有窗口关闭后 6 秒,自动停止服务器
4. 一切结束,没有残留窗口和进程
5. dsh 更新时,`update.cmd` 停止服务器后执行 `npm install -g @deepseek-ai/dsh@latest`,启动器无需改动

## 许可证

MIT License。详见 [LICENSE](LICENSE)。
