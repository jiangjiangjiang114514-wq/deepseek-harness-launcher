# DeepSeek Harness watchdog (open source)
# Stops the hidden server a few seconds after the last GUI connection closes.
$ErrorActionPreference = 'SilentlyContinue'
$log = Join-Path $PSScriptRoot 'watchdog.log'
$zeroCount = 0
$seen = $false

function Write-Log($msg) {
  Add-Content -Path $log -Value ((Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + ' ' + $msg)
}

function Get-Connections {
  $n = 0
  netstat -ano -p tcp | Select-String ':3080' | Select-String 'ESTABLISHED' | ForEach-Object { $n++ }
  return $n
}

function Stop-ServerTree {
  # 1) kill the launcher server window tree by title (if any)
  $svr = Get-Process | Where-Object { $_.MainWindowTitle -eq 'DeepSeek Harness Server' }
  if ($svr) { foreach ($x in $svr) { taskkill /PID $x.Id /T /F 2>$null | Out-Null } }
  # 2) find dsh-related processes, kill their console hosts
  $all = Get-CimInstance Win32_Process
  $targets = @{}
  if ($null -ne $all) {
    foreach ($p in $all) {
      if ($p.CommandLine -and $p.CommandLine -match 'deepseek-ai|dsh') { $targets[[int]$p.ProcessId] = $true }
    }
  }
  netstat -ano -p tcp | Select-String ':3080' | Select-String 'LISTENING' | ForEach-Object {
    $pidStr = ($_.ToString() -split '\s+')[-1]
    if ($pidStr -match '^\d+$' -and $pidStr -ne '0') { $targets[[int]$pidStr] = $true }
  }
  $killIds = @{}
  foreach ($t in $targets.Keys) {
    $cur = $null
    if ($null -ne $all) { $cur = $all | Where-Object { $_.ProcessId -eq $t } | Select-Object -First 1 }
    $hosts = @()
    while ($cur) {
      if ($cur.Name -match 'cmd|conhost|windowsterminal') { $hosts += $cur }
      $par = $cur.ParentProcessId
      if ($par -eq 0) { break }
      $cur = $null
      if ($null -ne $all) { $cur = $all | Where-Object { $_.ProcessId -eq $par } | Select-Object -First 1 }
    }
    if ($hosts.Count -gt 0) { $killIds[[int]$hosts[-1].ProcessId] = $true }
  }
  foreach ($k in $killIds.Keys) { taskkill /PID $k /T /F 2>$null | Out-Null }
  # 3) final fallback: kill the dsh targets directly
  foreach ($t in $targets.Keys) { taskkill /PID $t /T /F 2>$null | Out-Null }
}

Write-Log 'watchdog started'
while ($true) {
  $conns = Get-Connections
  if ($conns -gt 0) {
    if (-not $seen) { $seen = $true; Write-Log 'first connection seen' }
    $zeroCount = 0
  } elseif ($seen) {
    $zeroCount++
    if ($zeroCount -ge 3) {
      Write-Log 'no connections for 6s, stopping server'
      Stop-ServerTree
      Write-Log 'server stopped'
      exit 0
    }
  }
  Start-Sleep -Seconds 2
}
