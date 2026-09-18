@echo off
setlocal EnableExtensions
title DeepSeek Harness Launcher
set "URL=http://127.0.0.1:3080"

rem ============================================================
rem  DeepSeek Harness one-click launcher (open source)
rem  - server not running -> start it HIDDEN, wait for it to be
rem    ready, then open the app window
rem  - server running     -> just open the app window
rem  Closing the app window stops the server (watchdog.ps1).
rem ============================================================

rem --- already running? ---
powershell -NoProfile -Command "if (Test-NetConnection -ComputerName 127.0.0.1 -Port 3080 -InformationLevel Quiet -WarningAction SilentlyContinue) { exit 0 } else { exit 1 }"
if not errorlevel 1 goto open

rem --- start the server HIDDEN (no console window), log to server.log ---
rem launch-server.ps1 locates dsh/npx by full path (works without PATH refresh)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0launch-server.ps1"
echo Starting DeepSeek Harness server (hidden, log: server.log)...
echo First launch may take a few minutes to initialize...
echo (Progress: server.log is written if the server is working)

rem --- wait for the server, up to 300 seconds ---
set /a tries=0
:wait
powershell -NoProfile -Command "$ok=$false; try { $r = Invoke-WebRequest -UseBasicParsing -Uri '%URL%' -TimeoutSec 2; $ok=$true } catch { if ($_.Exception.Response) { $ok=$true } else { try { $c = New-Object Net.Sockets.TcpClient; $c.Connect('127.0.0.1',3080); $c.Close(); $ok=$true } catch {} } }; if (-not $ok) { exit 1 }; if (-not (Select-String -LiteralPath '%~dp0server.log' -Pattern 'dsh web:' -Quiet -ErrorAction SilentlyContinue)) { exit 1 }; exit 0"
if not errorlevel 1 goto open
set /a tries+=1
set /a mod10 = tries %% 10
if %mod10% equ 0 echo Waited %tries% seconds, server still starting...
set /a mod20 = tries %% 20
if %mod20% equ 0 (
  echo.
  echo --- recent server.log output ---
  powershell -NoProfile -Command "Get-Content -Path '%~dp0server.log' -Tail 5 -ErrorAction SilentlyContinue"
  echo --------------------------
)
if %tries% geq 300 goto fail
timeout /t 1 /nobreak >nul
goto wait

:open
rem --- open the app window ---
rem open-appwindow.ps1 opens the installed PWA directly (no token exchange).
rem Only if the app window ever reports 401 / Failed to fetch, run ÊÚÈ¨Ò»´Î.cmd.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0open-appwindow.ps1"
goto watchdog
:watchdog
rem --- start the watchdog: closing the window stops the server ---
start "DSH Watchdog" /min powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0watchdog.ps1"
exit /b 0

:fail
echo.
echo Timed out waiting for the server (5 minutes).
echo Please open server.log and check the last lines for errors.
timeout /t 15 /nobreak >nul
exit /b 1