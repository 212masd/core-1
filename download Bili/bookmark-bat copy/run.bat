.
@echo off
chcp 65001 >nul
echo.
echo ==============================
echo      B站批量链接生成器
echo ==============================
echo.

py gen_bili_links.py

for /f "delims=" %%a in (config.txt) do (
    mkdir "%%a" 2>nul
    echo mkdir
)

echo.
pause