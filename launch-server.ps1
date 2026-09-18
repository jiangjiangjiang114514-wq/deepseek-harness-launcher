# Launch the DeepSeek Harness server hidden, logging to server.log.
# Locates dsh / npx by full path. Uses a temp .cmd wrapper so that
# paths with spaces and quotes survive Start-Process argument joining.
$ErrorActionPreference = 'SilentlyContinue'
$log = Join-Path $PSScriptRoot 'server.log'
$bat = Join-Path $env:TEMP 'dsh-start-hidden.cmd'

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
  $cmdLine = 'call "' + $dsh + '" web --no-open 1>>"' + $log + '" 2>&1'
} elseif ($npx) {
  $cmdLine = 'call "' + $npx + '" --yes @deepseek-ai/dsh web --no-open 1>>"' + $log + '" 2>&1 || call "' + $npx + '" --yes @deepseek-ai/dsh web --no-open 1>>"' + $log + '" 2>&1'
} else {
  $cmdLine = 'npx --yes @deepseek-ai/dsh web --no-open 1>>"' + $log + '" 2>&1 || npx --yes @deepseek-ai/dsh web --no-open 1>>"' + $log + '" 2>&1'
}

Remove-Item -LiteralPath $log -Force -ErrorAction SilentlyContinue
Add-Content -Path $log -Value ('[launch-server] attempt: dsh=' + $dsh + ' npx=' + $npx) -Encoding Default
Set-Content -Path $bat -Value ('@echo off' + "`r`n" + $cmdLine) -Encoding Default
Start-Process cmd -ArgumentList '/c', $bat -WindowStyle Hidden