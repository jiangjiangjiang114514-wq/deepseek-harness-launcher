@echo off
title DeepSeek Harness 重新授权
echo.
echo  正在向服务器验票一次, 以刷新登录 cookie...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0open-appwindow.ps1" -Verify
echo.
echo  完成。cookie 已刷新, 关闭本窗口即可。
echo  平时不需要运行本文件; 只有桌面端报 401 / Failed to fetch 时才需要。
timeout /t 6 /nobreak >nul