@echo off
chcp 65001
for %%i in (*.mp4 *.mkv *.avi *.mov *.flv *.wmv *.m4v *.webm) do (
    echo 处理：%%i
    mkdir "%%~ni"
    ffmpeg -i "%%i" -r 1 -threads auto -q:v 8 -an -sn -y "%%~ni\%%~ni_%%04d.jpg"
)
echo 全部完成！
pause