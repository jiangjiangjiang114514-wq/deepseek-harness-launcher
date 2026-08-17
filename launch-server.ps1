# Launch the DeepSeek Harness server hidden, logging to server.log.
# Locates dsh / npx by full path so it works even when PATH is stale.
$ErrorActionPreference = 'SilentlyContinue'
$log = Join-Path $PSScriptRoot 'server.log'

$dsh = $null
foreach ($c in @(
  (Join-Path $env:APPDATA 'npm\dsh.cmd'),
  (Join-Path $env:LOCALAPPDATA 'Programs\nodejs\dsh.cmd'),
  (Join-Path $env:ProgramFiles 'nodejs\dsh.cmd')
)) {
  if (Test-Path $c) { $dsh = $c; break }
}

$npx = $null
foreach ($c in @(
  (Join-Path $env:LOCALAPPDATA 'Programs\nodejs\npx.cmd'),
  (Join-Path $env:ProgramFiles 'nodejs\npx.cmd'),
  (Join-Path ([Environment]::GetFolderPath('ProgramFilesX86')) 'nodejs\npx.cmd')
)) {
  if (Test-Path $c) { $npx = $c; break }
}

if ($dsh) {
  $cmd = '"' + $dsh + '" web 1>>"' + $log + '" 2>&1'
  Start-Process cmd -ArgumentList '/c', $cmd -WindowStyle Hidden
} elseif ($npx) {
  $cmd = '"' + $npx + '" --offline @deepseek-ai/dsh web 1>>"' + $log + '" 2>&1 || "' + $npx + '" @deepseek-ai/dsh web 1>>"' + $log + '" 2>&1'
  Start-Process cmd -ArgumentList '/c', $cmd -WindowStyle Hidden
} else {
  # nothing found - record diagnostics and try PATH anyway
  Add-Content -Path $log -Value ('[launch-server] dsh/npx not found by path. Trying PATH. APPDATA=' + $env:APPDATA)
  $cmd = 'npx --offline @deepseek-ai/dsh web 1>>"' + $log + '" 2>&1 || npx @deepseek-ai/dsh web 1>>"' + $log + '" 2>&1'
  Start-Process cmd -ArgumentList '/c', $cmd -WindowStyle Hidden
}