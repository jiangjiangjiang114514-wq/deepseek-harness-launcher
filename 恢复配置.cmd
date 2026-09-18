@echo off
title DeepSeek Harness 配置恢复
echo.
echo  正在把 cordis.patch.yml 还原成备份版本...
copy /y "%USERPROFILE%\.dsh\profiles\web\cordis.patch.yml.bak" "%USERPROFILE%\.dsh\profiles\web\cordis.patch.yml"
if errorlevel 1 (
  echo  还原失败: 找不到备份文件.
  pause
  exit /b 1
)
echo  已还原.
echo  现在重新启动服务器...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0launch-server.ps1"
echo  完成. 请双击桌面上的启动器打开应用窗口.
pause