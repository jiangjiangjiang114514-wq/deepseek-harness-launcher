# 打开 DeepSeek Harness 应用窗口(桌面端)。
#
# 默认行为: 直接打开已安装的 PWA, 不做任何"验票"(token)动作。
# 可选参数 -Verify: 从 server.log 读带 token 的地址并访问一次,
# 用于 cookie 过期后重新授权(双击同目录的 授权一次.cmd 即可)。
param([switch]$Verify)

$ErrorActionPreference = 'SilentlyContinue'
$plain = 'http://127.0.0.1:3080'
$url = $plain

if ($Verify) {
  $log = Join-Path $PSScriptRoot 'server.log'
  if (Test-Path -LiteralPath $log) {
    $m = Get-Content -LiteralPath $log | Select-String -Pattern 'dsh web:\s*(https?://\S+)' | Select-Object -Last 1
    if ($m) { $url = $m.Matches[$m.Matches.Count - 1].Groups[1].Value }
  }
}

$edge = $null
foreach ($p in @(
  (Join-Path ${env:ProgramFiles(x86)} 'Microsoft\Edge\Application\msedge.exe'),
  (Join-Path $env:ProgramFiles 'Microsoft\Edge\Application\msedge.exe')
)) { if ($p -and (Test-Path -LiteralPath $p)) { $edge = $p; break } }

# 默认: 打开已安装的 PWA
if (-not $Verify) {
  $app = Get-StartApps | Where-Object { $_.Name -match 'Harness' -and $_.AppID -like '*!App' } | Select-Object -First 1
  if ($app) { Start-Process 'explorer.exe' ('shell:AppsFolder\' + $app.AppID); exit 0 }
}

# -Verify 模式, 或 PWA 不可用时的退路: Edge 应用模式打开 URL
if ($edge) {
  Start-Process -FilePath $edge -ArgumentList ('--app=' + $url), '--profile-directory=Default'
  exit 0
}
Start-Process $url
exit 0
