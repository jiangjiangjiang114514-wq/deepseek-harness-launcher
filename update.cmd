@echo off
chcp 65001 >nul
title DeepSeek Harness 更新器
echo ==============================================
echo   DeepSeek Harness 一键更新器
echo ==============================================
echo.
echo 第 1 步:停止正在运行的服务器...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0stop.ps1"
echo.
echo 第 2 步:更新 dsh 到最新版(需要联网)...
npm install -g @deepseek-ai/dsh@latest
if errorlevel 1 (
  echo.
  echo [失败] 更新失败,请检查网络后重试
) else (
  echo.
  echo [成功] dsh 已更新到最新版!
  echo 现在可以双击「DeepSeek Harness 启动器」使用了
)
echo.
timeout /t 5 /nobreak >nul
