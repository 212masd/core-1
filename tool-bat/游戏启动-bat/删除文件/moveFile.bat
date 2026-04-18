@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo 开始遍历删除列表...
echo.
set "File=MoveFile.txt"
set "movedir=D:\CpanToDpan\game"
set  game="D:\CpanToDpan\game"
cd /d "%game%"
dir /b /a /s *.exe "%game%">"%File%"
pause
pause
@REM echo .>%File%
for /f "usebackq delims=" %%f in ("%File%") do (
    set "item=%%f"
    if not "!item!"=="" (
        echo ==============================================
        echo 当前处理：!item!

        if exist "!item!" (
            if exist "!item!\*" (
                echo 类型：文件夹
                 
                echo 结果：已删除文件夹
            ) else (
                echo 类型：文件
                move "!item!" "%movedir%"
                echo 结果：已删除文件
            )
        ) else (
            echo 结果：路径不存在，跳过
        )
    ) else (
        echo 结果：空行，跳过
    )
)

echo.
echo 全部执行完成！
pause