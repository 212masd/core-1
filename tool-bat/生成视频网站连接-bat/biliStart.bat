@echo off
chcp 65001 >nul
echo 正在批量打开B站搜索页，每个间隔3秒...
echo.
start "Doubao" "https://www.doubao.com/chat/"
pause

:: 这里放你的关键词（空格分隔）
for %%k in (
   坦克西
) do (
    echo 正在搜索：%%k
    start "" "https://search.bilibili.com/all?keyword=%%k"
    timeout /t 3 /nobreak >nul
)

echo.
echo 全部打开完毕！
pause
:: 这里放你的关键词（空格分隔）
for %%k in (
    黑神话悟空
    原神4.7
    考研英语
    AI绘画
    计算机二级
) do (
    echo 正在搜索：%%k
    start "" "https://search.bilibili.com/all?keyword=%%k"
    timeout /t 3 /nobreak >nul
)

echo.
echo 全部打开完毕！
pause