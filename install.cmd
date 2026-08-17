@echo off
chcp 65001 >nul
title DeepSeek Harness 安装器
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1"
if errorlevel 1 (
  echo.
  echo [失败] 安装出错,请把上面的提示截图反馈
)
pause
