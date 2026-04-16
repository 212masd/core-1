@echo off
chcp 65001 >nul
title 整理视频文件


:: 1. 设置文件夹名称变量（你可以随便改后面的文字）
set "video_folder=作者maker"
echo 已创建文件夹：%video_folder%
:: 2. 创建以变量命名的文件夹
if not exist "%video_folder%" (
    mkdir "%video_folder%"
    echo 已创建文件夹：%video_folder%
)

:: 3. 移动当前目录下所有常见视频文件到该文件夹
move /y *.txt "%video_folder%" >nul 2>&1


echo.
echo 整理完成！所有视频已移动到：%video_folder%
echo.
pause
exit