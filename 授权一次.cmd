@echo off
title DeepSeek Harness 重新授权
echo.
echo  正在向服务器验票一次, 以刷新登录 cookie...
echo  稍后会弹出一个 Edge 应用窗口, 那是正常现象.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0open-appwindow.ps1" -Verify
echo.
echo  完成, cookie 已刷新.
echo  请关掉刚弹出的那个 Edge 窗口 - 它只是用来验票的, 用完即可关闭.
echo  平时不用运行本文件; 只有桌面端报 401 / Failed to fetch 时才需要.
timeout /t 10 /nobreak >nul