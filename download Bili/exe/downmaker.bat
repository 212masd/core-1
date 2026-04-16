

@echo Off
cd /d "%~dp0"
cd /d

For /F %%a in (urls.txt) Do (BBDown.exe  "%%a" --show-all --add-dfn-subfix --use-aria2c --aria2c-args "-x16 -s16 -j4" -q"1080p 高清" -F "[<publishDate>][<ownerName>]<videoTitle>_<dfn>" ^
    -M "[<publishDate>][<ownerName>]<videoTitle>/[P<pageNumberWithZero>]<pageTitle>_<dfn>" -o D:\B站视频 )
pause
exit
@REM pause