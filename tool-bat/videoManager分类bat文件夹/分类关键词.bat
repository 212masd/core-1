@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: 定义你要的分类关键词
set "list=坦克 剪" 

:: 循环每个关键词：创建文件夹 + 移动对应视频
for %%i in (%list%) do (
    :: 先创建文件夹
    if not exist "%%i" md "%%i"
    
    :: 移动：*关键词*.mp4  →  关键词文件夹
    move "*%%i*.mp4" "%%i\" >nul 2>nul
    move "*%%i*.mkv" "%%i\" >nul 2>nul
    move "*%%i*.mov" "%%i\" >nul 2>nul
    move "*%%i*.avi" "%%i\" >nul 2>nul
)

echo 分类完成啦！
pause
