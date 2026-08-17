@echo off
title DeepSeek Harness Updater
echo ==============================================
echo   DeepSeek Harness Updater
echo ==============================================
echo.
echo Step 1/2: stopping the server if it is running...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0stop.ps1"
echo.
echo Step 2/2: updating dsh to the latest version...
npm install -g @deepseek-ai/dsh@latest
if errorlevel 1 (
  echo.
  echo [FAILED] Update failed. Check your network and try again.
) else (
  echo.
  echo [OK] dsh updated to the latest version.
)
echo.
pause
