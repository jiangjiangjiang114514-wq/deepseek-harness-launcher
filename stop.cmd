@echo off
setlocal EnableExtensions
title DeepSeek Harness Stopper
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0stop.ps1"
timeout /t 3 /nobreak >nul
