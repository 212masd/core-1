@echo off
chcp 65001 >nul
@REM title 批量下载 - gallery-dl
@REM gallery-dl --version
@REM set http_proxy=http://127.0.0.1:7897
@REM set https_proxy=http://127.0.0.1:7897
@REM gallery-dl https://nhentai.net/g/404404/   --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36"
@REM @REM gallery-dl -i links.txt -d ./下载 --no-skip -R 10 --limit-rate 5M
@REM pause
@REM gallery-dl oauth:pixiv --proxy 127.0.0.1:7897
@REM pause

@REM gallery-dl -i links.txt -d ./下载 --no-skip -R 10 --limit-rate 5M
@REM pause
@REM -proxy http://127.0.0.1:7897
@REM # 禁用代理并下载单个作品
@REM gallery-dl https://www.pixiv.net/artworks/10000000
gallery-dl --clear-cache pixiv
gallery-dl --proxy http://127.0.0.1:7897 oauth:pixiv
@REM gallery-dl --clear-cache pixiv
@REM gallery-dl oauth:pixiv
gallery-dl https://www.pixiv.net/artworks/143563132 --proxy http://127.0.0.1:7897
@REM gallery-dl --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36" https://nhentai.net/g/404404/