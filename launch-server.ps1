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
  $cmdLine = 'call "' + $dsh + '" web 1>>"' + $log + '" 2>&1'
} elseif ($npx) {
  $cmdLine = 'call "' + $npx + '" --offline @deepseek-ai/dsh web 1>>"' + $log + '" 2>&1 || call "' + $npx + '" @deepseek-ai/dsh web 1>>"' + $log + '" 2>&1'
} else {
  $cmdLine = 'npx --offline @deepseek-ai/dsh web 1>>"' + $log + '" 2>&1 || npx @deepseek-ai/dsh web 1>>"' + $log + '" 2>&1'
}

Add-Content -Path $log -Value ('[launch-server] attempt: dsh=' + $dsh + ' npx=' + $npx)
Set-Content -Path $bat -Value ('@echo off' + "\`r\`n" + $cmdLine) -Encoding ASCII
Start-Process cmd -ArgumentList '/c', $bat -WindowStyle Hidden
