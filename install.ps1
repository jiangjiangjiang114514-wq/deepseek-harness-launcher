# ============================================================
#  DeepSeek Harness 一键安装器(傻瓜版)
#  自动完成:装 Node.js(没有的话)-> 装 dsh -> 配 API Key -> 建快捷方式
#  运行:双击 install.cmd 即可
# ============================================================
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function Step([string]$text) { Write-Host ''; Write-Host "===== $text =====" -ForegroundColor Cyan }
function Ok([string]$text)  { Write-Host "  [成功] $text" -ForegroundColor Green }
function Fail([string]$text) { Write-Host "  [失败] $text" -ForegroundColor Red }

Write-Host ''
Write-Host '=============================================='
Write-Host '   DeepSeek Harness 一键安装器'
Write-Host '   全程自动,只需输入一次 API Key'
Write-Host '=============================================='

# ---------- 第 1 步:检查 / 自动安装 Node.js ----------
Step '第 1 步:检查 Node.js'
$node = Get-Command node -ErrorAction SilentlyContinue
if ($node) {
  $nodeVer = (& node --version).Trim()
  Ok "已检测到 Node.js $nodeVer"
} else {
  Fail '未检测到 Node.js,开始自动安装(无需管理员权限)'
  $arch = switch ($env:PROCESSOR_ARCHITECTURE) { 'ARM64' { 'arm64' } 'x86' { 'x86' } default { 'x64' } }
  Write-Host '  正在获取 Node.js 最新 LTS 版本信息...'
  try {
    $json = Invoke-RestMethod -Uri 'https://nodejs.org/dist/index.json' -TimeoutSec 20
    $lts = $json | Where-Object { $_.lts } | Select-Object -First 1
    $ver = $lts.version.TrimStart('v')
    $zipUrl = "https://nodejs.org/dist/v$ver/node-v$ver-win-$arch.zip"
  } catch {
    Fail '获取版本信息失败(可能是网络问题)'
    Write-Host '  请手动安装 Node.js:https://nodejs.org 下载 LTS 版,装完重新双击 install.cmd'
    Read-Host '  按回车退出'
    exit 1
  }
  Write-Host "  正在下载 Node.js v$ver (约 30MB,请稍候)..."
  $zip = Join-Path $env:TEMP "node-$ver.zip"
  try {
    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($zipUrl, $zip)
    $wc.Dispose()
  } catch {
    Fail '下载失败(可能是网络问题)'
    Write-Host '  请手动安装 Node.js:https://nodejs.org 下载 LTS 版,装完重新双击 install.cmd'
    Read-Host '  按回车退出'
    exit 1
  }
  Write-Host '  正在解压安装...'
  $dest = Join-Path $env:LOCALAPPDATA 'Programs\nodejs'
  if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
  New-Item -ItemType Directory -Path $dest -Force | Out-Null
  $extractTo = Join-Path $env:TEMP "node-extract-$ver"
  if (Test-Path $extractTo) { Remove-Item $extractTo -Recurse -Force }
  Expand-Archive -Path $zip -DestinationPath $extractTo -Force
  $src = Join-Path $extractTo "node-v$ver-win-$arch"
  & robocopy $src $dest /E /MOVE | Out-Null
  Remove-Item $extractTo -Recurse -Force -ErrorAction SilentlyContinue
  Remove-Item $zip -Force -ErrorAction SilentlyContinue
  # 加入用户 PATH(免管理员)
  $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
  if ($userPath -notlike "*$dest*") {
    $newPath = if ([string]::IsNullOrEmpty($userPath)) { $dest } else { $userPath + ';' + $dest }
    [Environment]::SetEnvironmentVariable('Path', $newPath, 'User')
  }
  $env:Path = $env:Path + ';' + $dest
  if (Test-Path (Join-Path $dest 'node.exe')) {
    $nodeVer = (& (Join-Path $dest 'node.exe') --version).Trim()
    Ok "Node.js 已自动安装完成 ($nodeVer)"
  } else {
    Fail 'Node.js 安装失败,请手动安装:https://nodejs.org'
    Read-Host '  按回车退出'
    exit 1
  }
}

# ---------- 第 2 步:安装 dsh ----------
Step '第 2 步:安装 dsh'
$hasDsh = Get-Command dsh -ErrorAction SilentlyContinue
if ($hasDsh) {
  Ok '已安装 dsh,跳过'
} else {
  Write-Host '  正在安装 dsh(需要联网,约 1-2 分钟)...'
  npm install -g @deepseek-ai/dsh 2>&1 | Out-Host
  if ($LASTEXITCODE -eq 0 -and (Get-Command dsh -ErrorAction SilentlyContinue)) {
    Ok 'dsh 安装成功'
  } else {
    Fail 'dsh 安装失败,请检查网络后重新运行安装器'
    Read-Host '  按回车退出'
    exit 1
  }
}

# ---------- 第 3 步:配置 API Key ----------
Step '第 3 步:配置 API Key'
$credFile = Join-Path $env:USERPROFILE '.dsh\.credentials.yaml'
$keyConfigured = $false
if (Test-Path $credFile) {
  if ((Get-Content $credFile -Raw) -match 'DEEPSEEK_API_KEY\s*:\s*\S+') { $keyConfigured = $true }
}
if ($keyConfigured) {
  Ok '已配置 API Key,跳过'
} else {
  Write-Host ''
  Write-Host '  需要 DeepSeek API Key 才能使用。获取方法(2分钟):'
  Write-Host '    1. 打开 https://platform.deepseek.com 并登录'
  Write-Host '    2. 左侧菜单 -> API Keys -> 创建新的 Key'
  Write-Host '    3. 复制 Key(sk- 开头,账户需有余额)'
  Write-Host ''
  $sec = Read-Host '  请输入 API Key(输入时不显示,回车确认)' -AsSecureString
  if ($sec.Length -eq 0) {
    Fail '未输入 Key,跳过配置'
    Write-Host '  之后可手动编辑 ~/.dsh/.credentials.yaml 添加 DEEPSEEK_API_KEY: sk-你的密钥'
  } else {
    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec)
    $key = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
    New-Item -ItemType Directory -Path (Split-Path $credFile) -Force | Out-Null
    Set-Content -Path $credFile -Value "DEEPSEEK_API_KEY: $key" -Encoding UTF8
    Ok 'API Key 已保存'
  }
}

# ---------- 第 4 步:创建快捷方式 ----------
Step '第 4 步:创建快捷方式'
$here = $PSScriptRoot
$ws = New-Object -ComObject WScript.Shell
$name = 'DeepSeek Harness 启动器'
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
Ok '已在开始菜单和桌面创建快捷方式'

# ---------- 第 5 步:完成 ----------
Step '安装完成'
Write-Host ''
Write-Host '  使用方法:'
Write-Host '    1. 双击桌面上的「DeepSeek Harness Launcher」'
Write-Host '    2. 服务器自动启动(无窗口)+ 应用窗口自动打开'
Write-Host '    3. 叉掉窗口,服务器自动停止'
Write-Host ''
Write-Host '  建议:右键快捷方式 -> 固定到任务栏,以后单击即用。'
Write-Host ''
Read-Host '按回车退出'