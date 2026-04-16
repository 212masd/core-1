@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

cls
echo ==============================================
echo  视频数量统计 + 文件夹重命名（带备份可撤销）
echo ==============================================
echo.

::======================
:: 1. 导出视频文件名到 txt
::======================
del /q "视频列表.txt" 2>nul
for %%i in (*.mp4 *.mkv *.avi *.mov *.flv *.wmv *.m4v *.webm *.ts *.m2ts *.rmvb *.f4v *.vob *.mts) do (
    echo %%i >> "视频列表.txt"
)

::======================
:: 2. 统计视频数量
::======================
set "count=0"
for %%i in (*.mp4 *.mkv *.avi *.mov *.flv *.wmv *.m4v *.webm *.ts *.m2ts *.rmvb *.f4v *.vob *.mts) do (
    set /a count+=1
)

echo 已统计视频数量：!count!
echo.

::======================
:: 3. 获取当前文件夹名
::======================
for %%a in ("%cd%") do set "old_name=%%~na"

::======================
:: 4. 备份原名（关键！）
::======================
echo !old_name! > "文件夹原名备份.txt"
echo 已备份原文件夹名到：文件夹原名备份.txt
echo.

::======================
:: 5. 去掉旧括号，避免重复
::======================
set "new_name=!old_name!"
:remove_bracket
if "!new_name:~0,1!"=="(" (
    for /f "tokens=1* delims=)" %%a in ("!new_name!") do set "new_name=%%b"
    set "new_name=!new_name:~1!"
    goto remove_bracket
)

::======================
:: 6. 构建新名字
::======================
set "final_name=(!count!)!new_name!"

::======================
:: 7. 重命名文件夹
::======================
cd..
ren "%cd%\!old_name!" "!final_name!"

echo 文件夹已重命名为：!final_name!
echo.
echo 如需撤销，运行“恢复原名.bat”即可。
echo.

::======================
:: 8. 自动生成恢复脚本
::======================
echo @echo off > "恢复原名.bat"
echo chcp 65001 ^>nul >> "恢复原名.bat"
echo set /p old_name^<"文件夹原名备份.txt" >> "恢复原名.bat"
echo for %%%%a in ("%%cd%%") do set "now_name=%%%%~na" >> "恢复原名.bat"
echo cd.. >> "恢复原名.bat"
echo ren "%%cd%%\%%now_name%%" "%%old_name%%" >> "恢复原名.bat"
echo echo 已恢复原文件夹名：%%old_name%% >> "恢复原名.bat"
echo pause ^>nul >> "恢复原名.bat"

pause >nul
exit