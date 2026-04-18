
@echo off
setlocal 

rem --- 当前脚本目录 ---
set "scriptDir=%~dp0"1
set "exeDir=%scriptDir%exe"
set "workDir=d:\b战\BBDown_1.6.3_1080p\core\download Bili\UPSpace"
set "urlFile=%workDir%\urls.txt"
set "workDir=d:\b战\BBDown_1.6.3_1080p\core\download Bili\UPSpace"
set "workVideoDir=d:\下载\D盘bili视频"
set "first_video=1"
:: 【万能日期】不管系统格式是 什么，自动输出：2025-04-13_15-30-45

cd %workDir%
if not exist "%urlFile%" (
    echo 错误: 无法找到 URL 文件: "%urlFile%"
    pause
    exit /b 1
)

pushd "%exeDir%" || (
    echo 错误: 无法进入程序目录: "%exeDir%"
    pause
    exit /b 1
)



"C:\Program Files (x86)\Notepad++\notepad++.exe" "%urlFile%"


for /f "usebackq delims=" %%u in ("%urlFile%") do (
    if not "%%u"=="" (
        
        :: 每个视频都获取【当前最新时间】
        for /f "skip=1 tokens=1 delims=." %%a in ('wmic os get LocalDateTime /value 2^>nul') do set "dt=%%a"
        set "dt=!dt:~-14!"
        set "now=!dt:~0,4!-!dt:~4,2!-!dt:~6,2!_!dt:~8,2!-!dt:~10,2!-!dt:~12,2!"
        echo "now"
        
        
        :: 下载命令（每个视频都用新时间）
        BBDown.exe "%%u" --show-all --add-dfn-subfix --use-aria2c -p 1 --aria2c-args "-x16 -s16 -j4" -q"1080p 高清"^
        -F "[!now!][<publishDate>][<ownerName>]<videoTitle>_<dfn>"^
        -M "[!now!][<publishDate>][<ownerName>]<videoTitle>/[P<pageNumberWithZero>]<pageTitle>_<dfn>"^
        --work-dir "%workVideoDir%"
    )
)

cd "%workVideoDir%"
dir /b /a /s
echo "%workVideoDir%"


:: 3. 运行里面的子脚本
call "D:\下载\D盘bili视频\reNameVideo.bat"
echo 分类视频到文件夹中




start cmd
@REM pause
exit /b