
@echo off
chcp 65001 >nul
echo.
echo ==============================
echo      web批量链接生成器
echo ==============================
start notepad


pause
for /f "delims=" %%a in (config-web.txt) do (
    start %%a
    echo start%%a
)
pause