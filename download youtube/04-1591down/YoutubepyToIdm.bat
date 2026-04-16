@REM echo .>>urls.txt
@echo off
chcp 65001 >nul
cd /d "%~dp0"
@REM python extract_links.py urls.txt output.txt 5
@REM python extract_links.py	全部使用默认值
@REM python extract_links.py urls.txt	输入 = urls.txt，输出/线程用默认
@REM python extract_links.py urls.txt result.txt	指定输入+输出
@REM python extract_links.py a.txt b.txt 10	指定输入+输出+10线程
@REM notepad links.txt
@REM pause
@REM python extract_links.py urls.txt output.txt 5
@REM notepad Youtube_links.txt

:: ================== 可配置 ==================
set "IDM_PATH=D:\b战\Useful Exe\IDM_NEw2026\IDMan.exe"
set "SAVE_PATH=D:\下载"
:: ===========================================
yt-dlp --no-check-certificate -a Youtube_links.txt  -N 16  --no-playlist --paths "%SAVE_PATH%"

echo 所有链接已添加到 IDM
pause