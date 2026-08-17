# Force-stop the DeepSeek Harness server (port 3080)
$ErrorActionPreference = 'SilentlyContinue'
$listeners = @()
netstat -ano -p tcp | Select-String ':3080' | Select-String 'LISTENING' | ForEach-Object {
  $pidStr = ($_.ToString() -split '\s+')[-1]
  if ($pidStr -match '^\d+$' -and $pidStr -ne '0') { $listeners += [int]$pidStr }
}
foreach ($p in $listeners) { taskkill /PID $p /T /F 2>$null | Out-Null }
if ($listeners.Count -gt 0) { Write-Host 'Server stopped.' } else { Write-Host 'Nothing is running on port 3080.' }
