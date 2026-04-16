@echo off
chcp 65001 > nul
title 项目初始化脚本
echo.
echo 正在初始化项目结构...
echo.

:: 创建文件夹
mkdir src
mkdir dist
mkdir docs
mkdir test
mkdir core
mkdir logs
mkdir temp

:: 创建基础文件
echo.> README.md
echo # 项目初始化完成 > README.md

echo.> .gitignore
echo /temp/ >> .gitignore
echo /logs/ >> .gitignore
echo *.log >> .gitignore
echo *.tmp >> .gitignore

echo.> config.json
echo {} > config.json

echo.> src/main.js
echo // 项目入口 >> src/main.js

echo.> core/tool.bat
echo @echo off >> core/tool.bat

echo.
echo ✅ 项目初始化完成！
echo 已创建：src dist docs test core logs temp
echo 已生成：README.md .gitignore config.json src/main.js
echo.
pause