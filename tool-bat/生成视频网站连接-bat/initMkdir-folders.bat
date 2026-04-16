@echo off
chcp 65001 >nul
echo 正在根据配置文件创建文件夹...

for /f "delims=" %%a in (config.txt) do (
    mkdir "%%a" 2>nul
)

echo 全部创建完成！
pause