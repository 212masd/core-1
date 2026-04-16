@echo off
set "proxy=socks5://127.0.0.1:7897"
set "savepath=D:\下载"
set "idm=D:\b战\Useful Exe\IDM_NEw2026\IDMan.exe"

for /f "delims=" %%u in (links.txt) do (
    for /f "delims=" %%i in ('yt-dlp.exe -g  "%%u" 2^>nul') do (
        "%idm%" /d "%%i" /p "%savepath%" /n /a
    )
)