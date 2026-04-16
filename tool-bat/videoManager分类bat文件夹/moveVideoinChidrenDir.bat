@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

set "TARGET_DIR=.\包含MP4的文件夹"
if not exist "%TARGET_DIR%" md "%TARGET_DIR%"

echo ==============================================
echo 正在深度扫描所有含 MP4 的文件夹...
echo 只会扫描当前目录下的一级文件夹
echo ==============================================
echo.

:: 先把要移动的列表存到临时文件
del "%temp%\mp4_list.txt" 2>nul

for /d %%D in (*) do (
    dir /s /b "%%D\*.js" >nul 2>&1 && (
        echo %%D >> "%temp%\mp4_list.txt"
    )
)

:: 显示列表
echo 以下文件夹【包含 MP4】，即将被移动：
echo ==============================================
type "%temp%\mp4_list.txt"
echo ==============================================
echo.

:: 询问确认
set /p "confirm=是否确定移动？(Y/N)："

if /i not "!confirm!"=="Y" (
    echo 已取消，未移动任何文件。
    pause >nul
    exit /b
)

:: 真正开始移动
echo.
echo 开始移动...
for /f "delims=" %%D in (%temp%\mp4_list.txt) do (
    move "%%D" "%TARGET_DIR%\" >nul 2>&1
    echo 已移动：%%D
)

echo.
echo 全部完成！
pause