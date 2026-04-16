@echo off
chcp 65001 >nul
title yt-dlp 解析 → IDM 下载

set "proxy=socks5://127.0.0.1:7897"
set "savepath=D:\下载"
set "idm=D:\b战\Useful Exe\IDM_NEw2026\IDMan.exe"
set "linkfile=links.txt"

if not exist "%linkfile%" (
    echo 未找到 links.txt
    pause
    exit
)
if not exist "%idm%" (
    echo 未找到 IDM
    pause
    exit
)

echo 开始解析并传送到 IDM...
for /f "delims=" %%a in (%linkfile%) do (
    for /f "delims=" %%b in ('yt-dlp --proxy "%proxy%" --no-check-certificate --extractor-args "generic:impersonate=chrome" --get-urls "%%a" 2^>nul') do (
        "%idm%" /d "%%b" /p "%savepath%" /n /a
        echo 已添加：%%b
    )
)

echo 完成！
pause