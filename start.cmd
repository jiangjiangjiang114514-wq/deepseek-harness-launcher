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
echo 首次启动需要初始化环境,可能需要几分钟,请耐心等待...
echo (进度:server.log 在持续更新就说明在正常工作)

rem --- wait for the server, up to 300 seconds ---
set /a tries=0
:wait
powershell -NoProfile -Command "try { (Invoke-WebRequest -UseBasicParsing -Uri '%URL%' -TimeoutSec 2 | Out-Null); exit 0 } catch { exit 1 }"
if not errorlevel 1 goto open
set /a tries+=1
set /a mod10 = tries %% 10
if %mod10% equ 0 echo 已等待 %tries% 秒,服务器仍在启动(首次使用请耐心等待)...
set /a mod20 = tries %% 20
if %mod20% equ 0 (
  echo.
  echo --- server.log 最近输出 ---
  powershell -NoProfile -Command "Get-Content -Path '%~dp0server.log' -Tail 5 -ErrorAction SilentlyContinue"
  echo --------------------------
)
if %tries% geq 300 goto fail
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
echo Timed out waiting for the server (5 minutes).
echo Please open server.log and check the last lines for errors.
timeout /t 15 /nobreak >nul
exit /b 1