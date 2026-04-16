@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion
title 按UP主分类视频文件
cls

echo ==============================
echo 正在按UP主分类视频文件...
echo ==============================
echo.

:: 遍历所有常见视频格式
for %%f in (*.mp4 *.flv *.mkv *.avi *.mov *.wmv *.webm) do (
    :: 提取第二个[]内的UP主名称
    set "fn=%%~nf"
    for /f "tokens=2 delims=[]" %%a in ("!fn!") do (
        set "up_name=%%a"
    )
    
    :: 跳过无UP主名称的文件
    if "!up_name!"=="" (
        echo ⚠️  跳过：%%~nxf（未识别UP主）
        goto next_file
    )
    
    :: 创建UP主文件夹（不存在则创建）
    if not exist "!up_name!" (
        md "!up_name!"
        echo 📁 创建文件夹：!up_name!
    )
    
    :: 移动视频到对应文件夹
    move /y "%%~f" "!up_name!\" >nul
    echo 📥 移动：%%~nxf → !up_name!
    
    :next_file
    set "up_name="
)

echo.
echo ==============================
echo ✅ 分类完成！
echo 📌 所有视频已按UP主归类到对应文件夹
echo ==============================
pause