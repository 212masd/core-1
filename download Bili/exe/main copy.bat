@echo off
chcp 65001 >nul 2>&1
title 视频下载脚本选择器 - may.bat
cls

:menu
echo ==============================
echo 请选择要执行的下载功能：
echo 1 - downmaker.bat      （视频制作下载）
echo 2 - downvideo720p.bat  （720P视频下载）
echo 3 - downVideoMove.bat  （视频移动整理）
echo 5 - downVideoName.bat  （视频重命名）
echo 4 - 视频文件统计        （统计名称/大小/日期并导出TXT）
echo 6 - 删除投稿TXT文件     （删除xxx的投稿视频.txt文件）
echo ==============================
set /p "choice=请输入数字1-4："

if "%choice%"=="1" (
    echo 正在执行 downmaker.bat...
    call "downmaker.bat"
) else if "%choice%"=="2" (
    echo 正在执行 downvideo720p.bat...
    call "downvideo720p.bat"
) else if "%choice%"=="3" (
    echo 正在执行 downVideoMove.bat...
    call "downVideoMove.bat"
) else if "%choice%"=="4" (
    echo 统计名称/大小/日期并导出TXT
    call "CountFileNumber.bat"
    call "main.bat"
    
) else if "%choice%"=="5" (
    echo 正在执行 main.bat...
    cd 1012
    pause
    call "main.bat"
    
) else if "%choice%"=="6" (
    echo 正在执行 main.bat...
    cd 1012
    pause
    call "main.bat"
    
) else if "%choice%"=="5" (
    echo 正在执行 main.bat...
    cd 1012
    pause
    call "main.bat"
    
)
  else (
    echo 输入错误！请输入1-4之间的数字。
    pause
    cls
    goto menu
)

echo.
echo 执行完成！按任意键返回菜单，或直接关闭窗口退出。
pause >nul
cls
goto menu