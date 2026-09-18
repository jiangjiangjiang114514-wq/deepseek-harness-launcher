@echo off
setlocal EnableExtensions
title DeepSeek Harness Launcher
set "URL=http://127.0.0.1:3080"
set "PS=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"

rem ============================================================
rem  DeepSeek Harness one-click launcher
rem  - server not running: start it HIDDEN, wait until ready,
rem    then open the app window
rem  - server running: open the app window
rem  Closing the app window stops the server (watchdog.ps1).
rem ============================================================

rem --- already running? ---
"%PS%" -NoProfile -Command "if (Test-NetConnection -ComputerName 127.0.0.1 -Port 3080 -InformationLevel Quiet -WarningAction SilentlyContinue) { exit 0 } else { exit 1 }"
if not errorlevel 1 goto open

rem --- start the server HIDDEN, logging to server.log ---
"%PS%" -NoProfile -ExecutionPolicy Bypass -File "%~dp0launch-server.ps1"
echo Starting DeepSeek Harness server (hidden, log: server.log)...

rem --- wait for the server, up to 300 seconds ---
set /a tries=0
:wait
"%PS%" -NoProfile -Command "$ok=$false; try { $r = Invoke-WebRequest -UseBasicParsing -Uri '%URL%' -TimeoutSec 2; $ok=$true } catch { if ($_.Exception.Response) { $ok=$true } else { try { $c = New-Object Net.Sockets.TcpClient; $c.Connect('127.0.0.1',3080); $c.Close(); $ok=$true } catch {} } }; if (-not $ok) { exit 1 }; if (-not (Select-String -LiteralPath '%~dp0server.log' -Pattern 'dsh web:' -Quiet -ErrorAction SilentlyContinue)) { exit 1 }; exit 0"
if not errorlevel 1 goto open
set /a tries+=1
if %tries% geq 300 goto fail
timeout /t 1 /nobreak >nul
goto wait

:open
rem --- open the app window ---
"%PS%" -NoProfile -ExecutionPolicy Bypass -File "%~dp0open-appwindow.ps1"
goto watchdog

:watchdog
rem --- start the watchdog: closing the window stops the server ---
start "DSH Watchdog" /min "%PS%" -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0watchdog.ps1"
exit /b 0

:fail
echo.
echo Timed out waiting for the server (5 minutes).
echo Please open server.log and check the last lines for errors.
timeout /t 15 /nobreak >nul
exit /b 1
