@echo off
cd /d "%~dp0"
echo Pushing to GitHub...
git push
if errorlevel 1 (
  echo.
  echo [FAILED] Push failed. Check network / proxy (Clash) and try again.
) else (
  echo.
  echo [OK] Pushed successfully!
)
pause
