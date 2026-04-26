@REM echo .>>urls.txt
@echo off
chcp 65001 >nul

@REM python extract_links.py urls.txt output.txt 5
@REM python extract_links.py	全部使用默认值
@REM python extract_links.py urls.txt	输入 = urls.txt，输出/线程用默认
@REM python extract_links.py urls.txt result.txt	指定输入+输出

@REM pause

@REM python extract_links.py urls.txt output.txt 5

:: ================== 可配置 ==================
set "IDM_PATH=D:\b战\Useful Exe\IDM_NEw2026\IDMan.exe"
set "SAVE_PATH=D:\下载"
:: ===========================================

    for /f "delims=" %%a in (output.txt) do (
    if not "%%a"=="" (
        "%IDM_PATH%" /n /d "%%a" /p "%SAVE_PATH%"
    )
)

echo 所有链接已添加到 IDM
pause

