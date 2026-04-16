@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

rem 当前目录为脚本所在目录
cd /d "%~dp0"

rem 支持的的视频后缀列表，可根据需要扩展
set "video_exts=mp4 mkv flv avi mov wmv webm"

echo 正在根据创建日期对当前目录下的视频文件分类...

for %%e in (%video_exts%) do (
    for /f "usebackq delims=" %%f in (`dir /b /a-d "*.%%e" 2^>nul`) do (
        if exist "%%f" (
            for /f "usebackq delims=" %%d in (`powershell -NoProfile -Command "Get-Item -LiteralPath '%%~f' | Select-Object -ExpandProperty CreationTime | ForEach-Object { $_.ToString('yyyy-MM-dd') }"`) do (
                set "targetDir=%%d"
            )

            if not defined targetDir set "targetDir=unknown"
            if not exist "!targetDir!" mkdir "!targetDir!"

            echo 移动: "%%f" -> "!targetDir!\"
            move /y "%%f" "!targetDir!\" >nul
            set "targetDir="
        )
    )
)

echo.
echo 分类完成。
pause
exit /b