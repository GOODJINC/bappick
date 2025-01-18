@echo off
cd /d "%~dp0"
echo Checking Git status...
git status
echo Adding changes...
git add .
set /p COMMIT_MSG="Enter commit message: "
git commit -m "%COMMIT_MSG%"
echo Pushing to remote repository...
git push origin main
pause