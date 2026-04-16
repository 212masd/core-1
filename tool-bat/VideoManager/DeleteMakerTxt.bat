@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

:: ====================== 可自定义配置 ======================
set "txt_pattern=*的投稿视频.txt"  :: 要删除的TXT文件格式
:: 视频文件后缀（可添加/删减，用空格分隔）
set "video_exts=.mp4 .flv .mkv .avi .mov .wmv"
:: ==========================================================

echo ====== 【待删除文件预览】 ======
echo 🔍 找到以下待删除的文件：
echo ------------------------------
:: 统计文件总数
set "total_count=0"

:: 第一步：遍历并显示所有符合格式的TXT文件
for %%f in (%txt_pattern%) do (
    echo 📄 TXT文件：%%~f
    set /a total_count+=1
    
    :: 提取TXT文件名（去掉后缀），匹配对应的视频文件
    set "txt_name=%%~nf"
    :: 遍历所有视频后缀，查找同名视频文件
    for %%e in (%video_exts%) do (
        if exist "!txt_name!%%e" (
            echo 🎬 视频文件：!txt_name!%%e
            set /a total_count+=1
        )
    )
    echo ------------------------------
)

:: 无文件时退出
if !total_count! equ 0 (
    echo ❌ 未找到任何待删除的TXT/视频文件
    pause
    exit /b
)

echo ⚠️  共找到 !total_count! 个待删除文件
echo 📌 按【任意键】执行删除，直接关闭窗口则取消操作

echo.
echo ====== 【开始删除】 ======
:: 第二步：删除TXT文件（注释单独成行，避免参数错误）
for %%f in (%txt_pattern%) do (
    echo 🗑️ 删除TXT：%%~f
    :: /f 强制删除 /q 静默删除（不弹确认）
    del /f /q "%%f"
    
    :: 删除对应的视频文件
    set "txt_name=%%~nf"
    for %%e in (%video_exts%) do (
        if exist "!txt_name!%%e" (
            echo 🗑️ 删除视频：!txt_name!%%e
            :: /f 强制删除 /q 静默删除（不弹确认）
            del /f /q "!txt_name!%%e"
        )
    )
)

echo.
echo ✅ 删除完成！
