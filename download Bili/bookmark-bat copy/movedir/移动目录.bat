@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
mode con cols=120 lines=40
color 0F
title 安全移动工具（含文件夹·不移自身）

:: ==============================================
:: 【配置区】
set "SOURCE=."
set "TARGET=D:\下载"
set "DUPLICATE=Skip"
:: ==============================================

echo.
echo ==============================================
echo  源目录: %SOURCE%
echo  目标目录: %TARGET%
echo  重复文件: %DUPLICATE% (Skip=跳过 Overwrite=覆盖)
echo ==============================================
echo.
set "CONFIRM="
set /p "CONFIRM=确认开始移动？[Y/N]："
if /i not "!CONFIRM!"=="Y" (
    echo 已取消。
    pause >nul
    exit /b 0
)
echo.

if not exist "%TARGET%" (
    echo 创建目标目录: %TARGET%
    mkdir "%TARGET%" || (
        echo 错误：无法创建目标目录
        pause >nul
        exit /b 1
    )
    echo.
)

set "COUNT_FILE_OK=0"
set "COUNT_DIR_OK=0"
set "COUNT_SKIP=0"
set "COUNT_ERR=0"
set "THIS_SCRIPT=%~nx0"

echo 开始移动...
echo ==============================================

:: 移动文件
for %%f in ("%SOURCE%\*.*") do (
    set "ITEM=%%~nxf"
    if /i "!ITEM!"=="!THIS_SCRIPT!" (
        echo [自身·跳过] !ITEM!
        set /a COUNT_SKIP+=1
        continue
    )
    if not exist "%%f\" (
        set "DEST=%TARGET%\!ITEM!"
        if exist "!DEST!" (
            echo [已存在·跳过] !ITEM!
            set /a COUNT_SKIP+=1
        ) else (
            move "%%f" "!DEST!" >nul 2>&1
            if errorlevel 1 (
                echo [移动失败] !ITEM!
                set /a COUNT_ERR+=1
            ) else (
                echo [已移动文件] !ITEM!
                set /a COUNT_FILE_OK+=1
            )
        )
    )
)

:: 移动文件夹
for /d %%d in ("%SOURCE%\*") do (
    set "DIR=%%~nxd"
    set "DEST_DIR=%TARGET%\!DIR!"
    if exist "!DEST_DIR!" (
        echo [目录已存在·跳过] !DIR!
        set /a COUNT_SKIP+=1
    ) else (
        move "%%d" "!DEST_DIR!" >nul 2>&1
        if errorlevel 1 (
            echo [目录移动失败] !DIR!
            set /a COUNT_ERR+=1
        ) else (
            echo [已移动目录] !DIR!
            set /a COUNT_DIR_OK+=1
        )
    )
)

echo ==============================================
echo 移动完成
echo 成功移动文件: !COUNT_FILE_OK! 个
echo 成功移动文件夹: !COUNT_DIR_OK! 个
echo 跳过(重复/自身): !COUNT_SKIP! 个
echo 失败(占用/权限): !COUNT_ERR! 个
echo ==============================================
echo 失败常见原因：文件占用、权限不足、目录同名
echo.

pause
exit /b 0