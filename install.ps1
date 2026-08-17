# DeepSeek Harness Launcher - installer
# Creates "DeepSeek Harness Launcher" shortcuts in the Start Menu and Desktop.
# Run:  powershell -ExecutionPolicy Bypass -File install.ps1
$ErrorActionPreference = 'Stop'
$here = $PSScriptRoot
if (-not (Test-Path (Join-Path $here 'start.cmd'))) { throw 'start.cmd not found next to this script' }

$ws = New-Object -ComObject WScript.Shell
$name = 'DeepSeek Harness Launcher'
$icon = Join-Path $here 'launcher.ico'

function New-LauncherShortcut([string]$path) {
  $s = $ws.CreateShortcut($path)
  $s.TargetPath = Join-Path $here 'start.cmd'
  $s.WorkingDirectory = $here
  $s.WindowStyle = 7
  if (Test-Path $icon) { $s.IconLocation = $icon + ',0' }
  $s.Description = 'Start DeepSeek Harness and open its app window'
  $s.Save()
}

$startMenu = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs'
New-LauncherShortcut (Join-Path $startMenu ($name + '.lnk'))
$desktop = [Environment]::GetFolderPath('Desktop')
New-LauncherShortcut (Join-Path $desktop ($name + '.lnk'))
Write-Host 'Done. Shortcuts created:'
Write-Host ('  ' + (Join-Path $startMenu ($name + '.lnk')))
Write-Host ('  ' + (Join-Path $desktop ($name + '.lnk')))
Write-Host ''
Write-Host 'Tip: pin it to the taskbar (right-click the shortcut -> Pin to taskbar).'
