
@echo Off
cd /d "%~dp0"

For /F %%a in (urls.txt) Do (BBDown.exe  "%%a" --show-all --add-dfn-subfix --use-aria2c --aria2c-args "-x16 -s16 -j4" -q"1080p 高清" -F "[<publishDate>][<ownerName>]<videoTitle>_<dfn>" ^
    -M "[<publishDate>][<ownerName>]<videoTitle>/[P<pageNumberWithZero>]<pageTitle>_<dfn>" --work-dir ./111Video )
pause
cd ./111Video

call "MakerFile.bat"
cd ..
    echo ===================== 开始执行脚本 =====================
echo.

REM 第一步：进入ups目录
echo [步骤1] 正在进入 ups 目录...
cd ups
echo [步骤1] 当前目录：%cd% （已成功进入ups目录）


REM 第二步：执行DeleteMakerTxt.bat
echo.
echo [步骤2] 正在执行 DeleteMakerTxt.bat...

call "DeleteMakerTxt.bat"
echo [步骤2] DeleteMakerTxt.bat 执行完成！


REM 第三步：返回上一级目录
echo.
echo [步骤3] 正在返回上一级目录...
cd ..
echo [步骤3] 当前目录：%cd% （已返回上一级目录）
    
         
pause
exit
@REM pause

For /F %%a in (urls.txt) Do (BBDown.exe  "%%a" --show-all --add-dfn-subfix  -F "[<publishDate>][<ownerName>]<videoTitle>_<dfn>" ^
    -M "[<publishDate>][<ownerName>]<videoTitle>/[P<pageNumberWithZero>]<pageTitle>_<dfn>" --work-dir ./111Video )
pause
exit
@REM pause


For /F %%a in (urls.txt) Do (BBDown.exe  "%%a" --show-all --add-dfn-subfix --use-aria2c --aria2c-args "-x16 -s16 -j4" -q"1080p 高清" -F "[<publishDate>][<ownerName>]<videoTitle>_<dfn>" ^
    -M "[<publishDate>][<ownerName>]<videoTitle>/[P<pageNumberWithZero>]<pageTitle>_<dfn>" --work-dir ./111Video )
pause
exit
@REM pause


