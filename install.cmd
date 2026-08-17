@echo off
title DeepSeek Harness Installer
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1"
if errorlevel 1 (
  echo.
  echo [FAILED] Installation error. Please screenshot the messages above.
)
pause
