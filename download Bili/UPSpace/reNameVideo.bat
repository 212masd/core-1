@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"
cd /d
echo 未找到视频文件
pause
:: 找到第一个视频文件（你可以自己加格式）
for %%f in (*.mp4 *.mkv *.mov *.avi *.flv *.wmv *.rmvb *.mpeg *.mpg) do (
set "first_video=%%~nf"
goto :found
)
echo 未找到视频文件
pause >nul
exit

:found
echo 第一个视频：!first_video!
echo 新建文件夹：!first_video!

if not exist "!first_video!" md "!first_video!"

:: 把所有视频移进去
move *.mp4 "!first_video!\" 2>nul
move *.mkv "!first_video!\" 2>nul
move *.mov "!first_video!\" 2>nul
move *.avi "!first_video!\" 2>nul
move *.flv "!first_video!\" 2>nul
move *.wmv "!first_video!\" 2>nul
move *.rmvb "!first_video!\" 2>nul
move *.mpeg "!first_video!\" 2>nul
move *.mpg "!first_video!\" 2>nul

echo 完成！所有视频已移入文件夹：!first_video!
