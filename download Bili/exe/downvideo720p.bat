@echo off
setlocal enabledelayedexpansion
chcp 65001
cls

echo ======================================================
echo  最终安全版：下载→临时目录→归类→删除临时文件夹
echo ======================================================
echo.

::==================== 配置 ====================
set "LINK_FILE=output.txt"
set "BASE_DIR=video"
set "TEMP_DIR=!BASE_DIR!\temp_download"
set "QUALITY=1080p 高清"

:: 创建基础目录
mkdir "!TEMP_DIR!" 2>nul

::==================== 下载到临时目录 ====================
echo [1] 下载视频到临时目录：!TEMP_DIR!
echo.

for /F "delims=" %%a in (%LINK_FILE%) do (
    echo 正在下载：%%a
    BBDown.exe "%%a" ^
--show-all ^
--add-dfn-subfix ^
-q "%QUALITY%" ^
-F "[<publishDate>][<ownerName>]<videoTitle>_<dfn>" ^
-M "[<publishDate>][<ownerName>]<videoTitle>/[P<pageNumberWithZero>]<pageTitle>_<dfn>" ^
--work-dir "!TEMP_DIR!"
echo.
)

::==================== 进入临时目录找第一个视频 ====================
cd /d "!TEMP_DIR!"
set "FIRST_VIDEO="

for /r %%f in (*.mp4 *.mkv *.mov *.flv *.ts *.m4s) do (
    if not defined FIRST_VIDEO (
        set "FIRST_VIDEO=%%~nf"
    )
)

if not defined FIRST_VIDEO (
    echo.
    echo 未找到视频文件。
    pause
    exit /b
)

echo [2] 第一个视频：!FIRST_VIDEO!
echo.

::==================== 提取前25个汉字 ====================
echo [3] 提取前25个汉字作为文件夹名
set "str=!FIRST_VIDEO!"
set "folder_name="
set count=0

:extract_loop
if "!str!"=="" goto extract_end
set "char=!str:~0,1!"
set "str=!str:~1!"

for /f "delims=" %%c in ("!char!") do (
    if "%%c" geq "一" if "%%c" leq "龥" (
        set "folder_name=!folder_name!!char!"
        set /a count+=1
        if !count! equ 25 goto extract_end
    )
)
goto extract_loop
:extract_end

if "!folder_name!"=="" set "folder_name=视频整理"

::==================== 加日期前缀 ====================
set "yyyy=%date:~0,4%"
set "mm=%date:~5,2%"
set "dd=%date:~8,2%"
set "today=!yyyy!!mm!!dd!"
set "final_folder=!today!_!folder_name!"
set "final_path=..\!final_folder!"

echo [4] 最终文件夹：!final_folder!
echo.

::==================== 创建目标文件夹 ====================
mkdir "!final_path!" 2>nul

::==================== 移动全部内容（含子文件夹） ====================
echo [5] 移动所有文件到目标文件夹
echo.
robocopy . "!final_path!" /E /MOVE /NFL /NDL /NJH /NJS

::==================== 回到上层并删除空临时目录 ====================
cd ..
rmdir temp_download 2>nul

echo ======================================================
echo 处理完成！
echo 视频已保存到：video\!final_folder!
echo ======================================================
echo.
pause
exit /b