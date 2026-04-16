@echo off
chcp 65001 >nul
title 整理视频文件
call "CountFileNumber.bat"
pause
move /y *.mp4 "D:\B站视频" >nul 2>&1
move /y *.mp4  D:\B站视频 >nul 2>&1

pause
:: 1. 设置文件夹名称变量（你可以随便改后面的文字）
set "video_folder=1012"
echo 已创建文件夹：%video_folder%
:: 2. 创建以变量命名的文件夹
if not exist "%video_folder%" (
    mkdir "%video_folder%"
    echo 已创建文件夹：%video_folder%
)
pause

:: 3. 移动当前目录下所有常见视频文件到该文件夹
move /y *.mp4 "1012" >nul 2>&1
move /y *.avi "%video_folder%" >nul 2>&1
move /y *.mov "%video_folder%" >nul 2>&1
move /y *.mkv "%video_folder%" >nul 2>&1
move /y *.flv "%video_folder%" >nul 2>&1
move /y *.wmv "%video_folder%" >nul 2>&1
move /y *.rmvb "%video_folder%" >nul 2>&1
move /y *.mpeg "%video_folder%" >nul 2>&1
move /y *.mpg "%video_folder%" >nul 2>&1

echo.
echo 整理完成！所有视频已移动到：%video_folder%
cd 1012
pause
call "CountFileNumber.bat"
pause
call "./main.bat"
pause
call "Filere.bat"

echo.
pause
exit