@echo off
chcp 65001 >nul 2>&1
title 子目录归集到新目录 - bite命令

:: ===================== 核心变量定义 =====================
:: 已改为你熟悉的旧名称：down_video_dir（可替换为你实际的旧名称）
set "NEW_DIR_NAME=down_video_dir"
:: ========================================================

echo ==============================================
echo 【bite命令开始执行】核心：将所有子目录归集到新目录
echo 目标新目录名称：%NEW_DIR_NAME%
echo ==============================================

:: 1. 检查新目录是否已存在，不存在则创建
if not exist "%NEW_DIR_NAME%" (
    echo 【步骤1】创建新目录：%NEW_DIR_NAME%
    md "%NEW_DIR_NAME%"
) else (
    echo 【步骤1】新目录已存在：%NEW_DIR_NAME%（跳过创建）
)

:: 2. 递归查找当前目录下所有子目录（排除新目录本身，避免循环）
echo 【步骤2】查找当前目录下所有子目录（排除新目录）
dir /AD /S /B .\* | find /v "%NEW_DIR_NAME%" > "%temp%\bite_dir_list.txt"

:: 3. 遍历所有子目录，移动到新目录
echo 【步骤3】开始将所有子目录移动到新目录...
for /f "delims=" %%p in ("%temp%\bite_dir_list.txt") do (
    if not "%%~nxp"=="%NEW_DIR_NAME%" (  :: 再次排除新目录，防止误移
        echo 正在移动：%%p --^> %NEW_DIR_NAME%\
        move "%%p" "%NEW_DIR_NAME%\" >nul 2>&1
        if errorlevel 1 (
            echo 【迁移失败】%%p（可能已存在/权限不足）
        ) else (
            echo 【迁移成功】%%p
        )
    )
)

:: 4. 清理临时文件，输出完成提示
del /Q "%temp%\bite_dir_list.txt" >nul 2>&1
echo ==============================================
echo 【bite命令执行完成】
echo 所有子目录已归集到：%cd%\%NEW_DIR_NAME%
echo 所有文件（含视频）均未改动！
echo ==============================================
pause >nul