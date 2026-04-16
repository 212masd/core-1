@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

:: 配置
set "PER_GROUP=30"
set "VIDEO_EXT=*.mp4 *.mkv *.avi *.mov *.flv *.wmv *.webm *.m4v *.ts"
set "FOLDER_PREFIX=group_"

set count=0
set folder_num=1

mkdir "%FOLDER_PREFIX%%folder_num%" 2>nul

for /f "delims=" %%f in ('dir /b /a-d %VIDEO_EXT% 2^>nul') do (
    set /a count+=1
    if !count! gtr %PER_GROUP% (
        set /a folder_num+=1
        set count=1
        mkdir "%FOLDER_PREFIX%!folder_num!" 2>nul
    )
    move "%%f" "%FOLDER_PREFIX%!folder_num!\" >nul 2>&1
)

echo 分组完成！
pause
exit /b