@echo off
chcp 65001 >nul
echo 正在根据配置文件创建文件夹...
set "CONFIG_DIR=movedir"            :: 要创建的子文件夹名
set "TARGET_FILE=config.txt"
cd movedir
move "!TARGET_FILE!" "!CONFIG_DIR!" >nul 2>&1
for /f "delims=" %%a in (config.txt) do (
    mkdir "%%a" 2>nul
)

echo 全部创建完成！
pause