
@echo off
chcp 65001 >nul
echo.
echo ==============================
echo      web批量链接生成器
echo ==============================

for /f "delims=" %%a in (config-web.txt) do (
    start %%a
    echo start%%a
)
pause
py gen_bili_links.py

for /f "delims=" %%a in (config-web.txt) do (
    start %%a
    mkdir "%%a" 2>nul
    echo mkdir
)

echo.
pause