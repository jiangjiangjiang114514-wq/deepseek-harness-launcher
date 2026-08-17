# Returns 0 if a DeepSeek Harness app window is present, 1 otherwise.
$ErrorActionPreference = 'SilentlyContinue'
$found = $false
$procs = Get-CimInstance Win32_Process -Filter "Name = 'msedge.exe'"
if ($null -ne $procs) {
  foreach ($p in $procs) {
    if ($p.CommandLine -and $p.CommandLine -match '--app=http://127\.0\.0\.1:3080') { $found = $true; break }
  }
}
if (-not $found) {
  $w = Get-Process msedge | Where-Object { $_.MainWindowTitle -eq 'DeepSeek Harness' }
  if ($w) { $found = $true }
}
if ($found) { exit 0 } else { exit 1 }