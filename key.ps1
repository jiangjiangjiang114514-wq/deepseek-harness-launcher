# ============================================
#  DeepSeek Harness API Key switch tool
# ============================================
& chcp 65001 | Out-Null
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$credFile = Join-Path $env:USERPROFILE '.dsh\.credentials.yaml'
Write-Host ''
Write-Host '=============================================='
Write-Host '   DeepSeek Harness API Key 切换'
Write-Host '=============================================='
Write-Host ''

# 显示当前状态(脱敏)
$running = $false
if (Test-Path $credFile) {
  $content = Get-Content $credFile -Raw
  if ($content -match 'DEEPSEEK_API_KEY\s*:\s*(sk-\S+)') {
    $k = $matches[1]
    $masked = if ($k.Length -gt 10) { $k.Substring(0, 6) + '...' + $k.Substring($k.Length - 4) } else { '****' }
    Write-Host ('当前状态:已配置 Key (' + $masked + ')') -ForegroundColor Green
  } else {
    Write-Host '当前状态:未配置 Key' -ForegroundColor Yellow
  }
} else {
  Write-Host '当前状态:未配置 Key' -ForegroundColor Yellow
}
Write-Host ''

if (netstat -ano -p tcp | Select-String ':3080' | Select-String 'LISTENING') {
  $running = $true
  Write-Host '注意:服务器正在运行,切换 Key 后需要重启服务器才能生效。' -ForegroundColor Yellow
  Write-Host '(叉掉应用窗口,或双击 stop.cmd 停止,再双击启动器重启)'
  Write-Host ''
}

$sec = Read-Host '请输入新的 API Key(sk- 开头,输入时不显示,直接回车取消)' -AsSecureString
if ($sec.Length -eq 0) {
  Write-Host ''
  Write-Host '[取消] 未输入,没有做任何修改。' -ForegroundColor Yellow
  Read-Host '按回车退出'
  exit 0
}
$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec)
$key = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)

# 更新 .credentials.yaml(替换或追加 DEEPSEEK_API_KEY 行)
$dir = Split-Path $credFile
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
$lines = @()
if (Test-Path $credFile) { $lines = @(Get-Content $credFile) }
$found = $false
for ($i = 0; $i -lt $lines.Count; $i++) {
  if ($lines[$i] -match '^\s*DEEPSEEK_API_KEY\s*:') {
    $lines[$i] = 'DEEPSEEK_API_KEY: ' + $key
    $found = $true
  }
}
if (-not $found) { $lines += 'DEEPSEEK_API_KEY: ' + $key }
[System.IO.File]::WriteAllText($credFile, ($lines -join [Environment]::NewLine), (New-Object System.Text.UTF8Encoding($false)))
Write-Host ''
Write-Host '[成功] API Key 已更新!' -ForegroundColor Green
if ($running) {
  Write-Host '服务器正在运行,请重启服务器(叉掉窗口 -> 重新双击启动器)后生效。'
} else {
  Write-Host '现在可以双击「DeepSeek Harness 启动器」开始使用。'
}
Write-Host ''
Read-Host '按回车退出'
