@echo off
setlocal enabledelayedexpansion

set "rar=D:\电脑软件\rar减压软件\winrar\WinRAR.exe"

if not exist "%rar%" (
    echo 未找到 WinRAR
    
    exit /b
)

for /d %%a in (*) do (
    echo 正在打包: %%a
    "%rar%" a -m0 -r -ep1 "%%a.rar" "%%a\"
    
    echo 删除原文件夹: %%a
    rd /s /q "%%a"
)

echo.
echo 全部完成！
