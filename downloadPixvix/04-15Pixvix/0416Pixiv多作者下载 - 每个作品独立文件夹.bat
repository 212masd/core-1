@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
title Pixiv多作者下载 - 每个作品独立文件夹
@REM notepad links.txt
@REM echo .>>readme.md
@REM pause
set "CONFIG=config.ini"
set "in_authors=0"
set "count=0"

if not exist "%CONFIG%" (
    echo 错误：未找到 config.ini
    pause >nul
    exit /b 1
)


for /f "usebackq tokens=* eol=;" %%a in ("%CONFIG%") do (
    set "line=%%a"
    if /i "!line!"=="[AUTHOR_LIST]" set "in_authors=1"

    if !in_authors! equ 0 (
        for /f "tokens=1,* delims==" %%k in ("%%a") do (
            set "key=%%k"
            set "val=%%l"
            if /i "!key!"=="LIMIT"  set "LIMIT=!val!"
            if /i "!key!"=="SAVE_ROOT" set "SAVE_ROOT=!val!"
            if /i "!key!"=="DL_TOOL" set "DL_TOOL=!val!"
        )
    ) else (
        echo %%a | findstr /i "^https" >nul 2>&1
        if !errorlevel! equ 0 (
            set /a count+=1
            set "author_!count!=%%a"
        )
    )
)

if %count% equ 0 (
    echo 错误：作者列表为空
    pause >nul
    exit /b 1
)
@REM cd gallery-dl
@REM move *.* "%downDir%\"`  >nul 2>&1
echo.
echo ======================================
echo  每个作者下载前 %LIMIT% 个作品
echo  保存目录：%SAVE_ROOT%
echo  共 %count% 个作者
echo ======================================
echo.

set "ok=0"
set "fail=0"

for /l %%i in (1,1,%count%) do (
    set "u=!author_%%i!"
    echo [%%i/%count%] 处理：!u!
    echo.

    "%DL_TOOL%"  --proxy http://127.0.0.1:7897 -i links.txt --range 1-150 --cookies cookies.txt 
    @REM https://www.pixiv.net/users/52647487   
    @REM "%DL_TOOL%"  --proxy http://127.0.0.1:7897 "https://www.pixiv.net/users/52647487" --range 1-500 --cookies cookies.txt
        
     

    if !errorlevel! equ 0 ( set /a ok+=1 ) else ( set /a fail+=1 )
    echo.
)
for /l %%i in (1,1,%count%) do (
    set "u=!author_%%i!"
    echo [%%i/%count%] 处理：!u!
    echo.

    "%DL_TOOL%"  --proxy http://127.0.0.1:7897 -i links.txt --range 1-1500 --cookies cookies.txt 
    @REM https://www.pixiv.net/users/52647487   
    @REM "%DL_TOOL%"  --proxy http://127.0.0.1:7897 "https://www.pixiv.net/users/52647487" --range 1-500 --cookies cookies.txt
        
     

    if !errorlevel! equ 0 ( set /a ok+=1 ) else ( set /a fail+=1 )
    echo.
)


echo ======================================
echo 完成：成功 !ok! 个  失败 !fail! 个
echo 每个作品 = 独立文件夹
echo ======================================
echo.
pause
cd gallery-dl
cd pixiv
call "pixvix重命名main.bat"
pause >nul
exit /b 0