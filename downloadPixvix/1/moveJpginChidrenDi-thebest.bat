@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

set "OUT_DIR=.\所有含JPG的文件夹"
if not exist "%OUT_DIR%" md "%OUT_DIR%"

del "%temp%\mp4_dirs.tmp" 2>nul

echo.
echo ==============================================
echo 正在深度搜索：所有 *内部包含 JPG* 的文件夹 （包含子文件夹）        
echo ==============================================
echo.

for /r /d %%d in (*) do (
    dir "%%d\*.png" >nul 2>&1 && (
        echo %%d >> "%temp%\mp4_dirs.tmp"
    )
)

echo 以下文件夹将被移动：
echo ==============================================
type "%temp%\mp4_dirs.tmp"
echo ==============================================
echo.

set "c="
set /p "c=确认移动？请输入 Y 并回车："
if /i not "%c%"=="Y" (
    echo 已取消，未修改任何文件。
    pause >nul
    exit /b
)

echo.
echo 开始移动...
echo ==============================================

for /f "usebackq delims=" %%d in ("%temp%\mp4_dirs.tmp") do (
    move "%%d" "%OUT_DIR%\"
    echo 已移动：%%d
)

echo.
echo 全部完成！
pause >nul