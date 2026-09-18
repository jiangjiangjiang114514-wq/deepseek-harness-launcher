@echo off
cd /d "%~dp0"
echo Pushing to GitHub...

git push
if not errorlevel 1 goto ok

echo.
echo [RETRY] Push failed - retrying without the configured git proxy...
git -c http.proxy= -c https.proxy= push
if not errorlevel 1 goto ok

echo.
echo [FAILED] Push failed. Check network / proxy (Clash) and try again.
goto end

:ok
echo.
echo [OK] Pushed successfully!

:end
pause