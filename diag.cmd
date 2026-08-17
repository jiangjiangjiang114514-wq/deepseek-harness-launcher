@echo off
title DSH Diagnostics
echo ============================================
echo   DeepSeek Harness Diagnostic Tool
echo ============================================
echo.
echo [1/6] dsh command location:
where dsh 2>nul
if exist "%APPDATA%\npm\dsh.cmd" (echo   found: %APPDATA%\npm\dsh.cmd) else (echo   NOT found in %APPDATA%\npm)
echo.
echo [2/6] node version:
node --version 2>nul
echo.
echo [3/6] is something listening on port 3080?
netstat -ano -p tcp | findstr ":3080"
echo.
echo [4/6] server.log tail (last 30 lines):
if exist "%~dp0server.log" (powershell -NoProfile -Command "Get-Content -Path '%~dp0server.log' -Tail 30") else (echo   no server.log in this folder)
echo.
echo [5/6] Microsoft Edge present?
if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" (echo   Edge found (x86)) else if exist "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" (echo   Edge found) else (echo   Edge NOT found)
echo.
echo [6/6] next step: test dsh manually
echo   Press Win+R, type cmd, press Enter, then run:
echo.
echo       dsh web
echo.
echo   Watch what it prints and screenshot it.
echo.
echo ============================================
echo   Please screenshot this whole window,
echo   plus the result of:  dsh web
echo ============================================
pause
