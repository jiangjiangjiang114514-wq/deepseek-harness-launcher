# ============================================================
#  DeepSeek Harness 一键安装器
#  作用:检查环境 -> 安装 dsh -> 配置 API Key -> 创建快捷方式
#  运行:双击 install.cmd 即可(或 powershell -ExecutionPolicy Bypass -File install.ps1)
# ============================================================
$ErrorActionPreference = 'Stop'

Write-Host ''
Write-Host '=============================================='
Write-Host '   DeepSeek Harness 一键安装器'
Write-Host '=============================================='
Write-Host ''

# ---------- 第 1 步:检查 Node.js ----------
Write-Host '[1/5] 检查 Node.js ...'
$node = Get-Command node -ErrorAction SilentlyContinue
if (-not $node) {
  Write-Host ''
  Write-Host '  未检测到 Node.js!'
  Write-Host '  请先到 https://nodejs.org 下载 LTS 版本并安装'
  Write-Host '  (下载后一路点"下一步"即可,装完重启终端)'
  Write-Host '  安装完成后,重新双击 install.cmd。'
  Read-Host '  按回车退出'
  exit 1
}
Write-Host ("    已检测到 Node.js " + (& node --version).Trim())
Write-Host ''

# ---------- 第 2 步:检查/安装 dsh ----------
Write-Host '[2/5] 检查 dsh ...'
$hasDsh = Get-Command dsh -ErrorAction SilentlyContinue
if (-not $hasDsh) {
  Write-Host '    未安装 dsh,正在为你安装(需要联网,约 1-2 分钟)...'
  npm install -g @deepseek-ai/dsh
  if ($LASTEXITCODE -ne 0) {
    Write-Host '    安装失败!请检查网络后重新运行本安装器。'
    Read-Host '    按回车退出'
    exit 1
  }
  Write-Host '    安装成功!'
} else {
  Write-Host '    已安装 dsh,跳过。'
}
Write-Host ''

# ---------- 第 3 步:配置 API Key ----------
Write-Host '[3/5] 检查 API Key ...'
$credFile = Join-Path $env:USERPROFILE '.dsh\.credentials.yaml'
$keyConfigured = $false
if (Test-Path $credFile) {
  if ((Get-Content $credFile -Raw) -match 'DEEPSEEK_API_KEY\s*:\s*\S+') { $keyConfigured = $true }
}
if ($keyConfigured) {
  Write-Host '    已配置 API Key,跳过。'
} else {
  Write-Host ''
  Write-Host '    未找到 API Key。'
  Write-Host '    获取方法:'
  Write-Host '      1. 打开 https://platform.deepseek.com 并登录'
  Write-Host '      2. 左侧菜单 -> API Keys -> 创建新的 Key(需要先充值)'
  Write-Host '      3. 复制得到的 Key(以 sk- 开头)'
  Write-Host ''
  $sec = Read-Host '    请输入 API Key(输入时不会显示,回车确认)' -AsSecureString
  if ($sec.Length -eq 0) {
    Write-Host '    未输入,跳过配置。'
    Write-Host '    之后可手动编辑 ~/.dsh/.credentials.yaml 添加:'
    Write-Host '    DEEPSEEK_API_KEY: sk-你的密钥'
  } else {
    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec)
    $key = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
    New-Item -ItemType Directory -Path (Split-Path $credFile) -Force | Out-Null
    Set-Content -Path $credFile -Value "DEEPSEEK_API_KEY: $key" -Encoding UTF8
    Write-Host '    已保存到 ~/.dsh/.credentials.yaml'
  }
}
Write-Host ''

# ---------- 第 4 步:创建快捷方式 ----------
Write-Host '[4/5] 创建快捷方式 ...'
$here = $PSScriptRoot
$ws = New-Object -ComObject WScript.Shell
$name = 'DeepSeek Harness Launcher'
$icon = Join-Path $here 'launcher.ico'
function New-LauncherShortcut([string]$path) {
  $s = $ws.CreateShortcut($path)
  $s.TargetPath = Join-Path $here 'start.cmd'
  $s.WorkingDirectory = $here
  $s.WindowStyle = 7
  if (Test-Path $icon) { $s.IconLocation = $icon + ',0' }
  $s.Description = '一键启动 DeepSeek Harness(服务器+应用窗口)'
  $s.Save()
}
$startMenu = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs'
New-LauncherShortcut (Join-Path $startMenu ($name + '.lnk'))
New-LauncherShortcut (Join-Path ([Environment]::GetFolderPath('Desktop')) ($name + '.lnk'))
Write-Host '    已在开始菜单和桌面创建快捷方式。'
Write-Host ''

# ---------- 第 5 步:完成 ----------
Write-Host '[5/5] 完成!'
Write-Host ''
Write-Host '  使用方法:'
Write-Host '    双击桌面上的「DeepSeek Harness Launcher」'
Write-Host '    -> 服务器自动启动(无窗口)+ 应用窗口自动打开'
Write-Host '    -> 叉掉窗口,服务器自动停止'
Write-Host ''
Write-Host '  建议:右键快捷方式 -> 固定到任务栏,以后单击即用。'
Write-Host ''
Read-Host '按回车退出'
