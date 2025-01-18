@echo off
REM 현재 디렉토리를 bat 파일이 위치한 경로로 설정
cd /d "%~dp0"

REM Git 상태 출력
echo Checking Git status...
git status

REM 커밋 메시지 입력
set /p commit_msg=Enter commit message: 

REM 변경 사항 스테이징
echo Staging changes...
git add .

REM 커밋 생성
echo Creating commit...
git commit -m "%commit_msg%"

REM 원격 저장소로 푸시
echo Pushing to GitHub...
git push

REM 완료 메시지 출력
echo Done! Your changes have been pushed to GitHub.
pause