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
powershell -NoProfile -Command "Start-Process cmd -ArgumentList '/c','npx --offline @deepseek-ai/dsh web 1>>%~dp0server.log 2>&1 || npx @deepseek-ai/dsh web 1>>%~dp0server.log 2>&1' -WindowStyle Hidden"
echo Starting DeepSeek Harness server (hidden, log: server.log)...

rem --- wait for the server, up to 90 seconds ---
set /a tries=0
:wait
powershell -NoProfile -Command "try { (Invoke-WebRequest -UseBasicParsing -Uri '%URL%' -TimeoutSec 2 | Out-Null); exit 0 } catch { exit 1 }"
if not errorlevel 1 goto open
set /a tries+=1
if %tries% geq 90 goto fail
timeout /t 1 /nobreak >nul
goto wait

:open
rem --- open the app window: installed PWA first, then Edge app mode ---
powershell -NoProfile -Command "$app = Get-StartApps | Where-Object { $_.Name -match 'Harness' -and $_.AppID -like '*!App' } | Select-Object -First 1; if ($app) { Start-Process 'explorer.exe' ('shell:AppsFolder\' + $app.AppID); exit 0 } else { exit 1 }"
if not errorlevel 1 goto watchdog
set "EDGE=%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe"
if not exist "%EDGE%" set "EDGE=%ProgramFiles%\Microsoft\Edge\Application\msedge.exe"
if exist "%EDGE%" (
  start "" "%EDGE%" --app="%URL%" --profile-directory=Default
) else (
  start "" "%URL%"
)
rem --- browser fallback if no window within 5s ---
timeout /t 5 /nobreak >nul
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0check-appwindow.ps1"
if errorlevel 1 start "" "%URL%"

:watchdog
rem --- start the watchdog: closing the window stops the server ---
start "DSH Watchdog" /min powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0watchdog.ps1"
exit /b 0

:fail
echo.
echo Timed out waiting for the server.
echo Look at server.log for error details.
timeout /t 15 /nobreak >nul
exit /b 1
