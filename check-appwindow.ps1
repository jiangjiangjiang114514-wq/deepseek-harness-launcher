# Returns 0 if a DeepSeek Harness app window is present, 1 otherwise.
# Title-based check only: lingering --app processes without a real window
# are ignored, so the browser fallback is not skipped.
$ErrorActionPreference = 'SilentlyContinue'
$w = Get-Process msedge | Where-Object { $_.MainWindowTitle -eq 'DeepSeek Harness' }
if ($w) { exit 0 } else { exit 1 }
