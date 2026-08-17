# Returns 0 if a watchdog is running, 1 otherwise.
$ErrorActionPreference = 'SilentlyContinue'
$found = $false
$procs = Get-CimInstance Win32_Process -Filter "Name = 'powershell.exe'"
if ($null -ne $procs) {
  foreach ($p in $procs) {
    if ($p.CommandLine -and $p.CommandLine -match 'watchdog') { $found = $true; break }
  }
}
if ($found) { exit 0 } else { exit 1 }