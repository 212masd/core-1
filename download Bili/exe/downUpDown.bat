@echo off
REM 开启回显（虽然@echo off关闭了命令回显，但我们可以用echo主动输出提示）
chcp 65001 >nul
REM 解决中文乱码问题，确保提示文字正常显示

echo.
echo ===================== 开始执行脚本 =====================
echo.

REM 第一步：进入ups目录
echo [步骤1] 正在进入 ups 目录...
cd ups
echo [步骤1] 当前目录：%cd% （已成功进入ups目录）


REM 第二步：执行DeleteMakerTxt.bat
echo.
echo [步骤2] 正在执行 DeleteMakerTxt.bat...
call "1.bat"
call "MakerFile.bat"
call "DeleteMakerTxt.bat"

echo [步骤2] DeleteMakerTxt.bat 执行完成！


REM 第三步：返回上一级目录
echo.
echo [步骤3] 正在返回上一级目录...
cd ..
echo [步骤3] 当前目录：%cd% （已返回上一级目录）
pause

REM 第四步：执行downvideoUPSpace.bat
echo.
echo [步骤4] 正在执行 downvideoUPSpace.bat...
call "downvideoUPSpace.bat"
echo [步骤4] downvideoUPSpace.bat 执行完成！
pause

REM 第五步：再次进入ups目录
echo.
echo [步骤5] 再次进入 ups 目录...
cd ups
echo [步骤5] 当前目录：%cd% （已再次进入ups目录）
pause

REM 第六步：执行1.bat
echo.
echo [步骤6] 正在执行 1.bat...
call 1.bat
echo [步骤6] 1.bat 执行完成！
pause

echo.
echo ===================== 所有步骤执行完毕 =====================
echo.
pause