@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
mode con cols=120 lines=30

echo.
echo ========================================================
echo             文件夹批量移动工具（预览确认版）
echo          配置文件：move_list.txt    格式：源^|目标
echo ========================================================
echo.

if not exist "move_list.txt" (
    echo 错误：请先创建 move_list.txt
    pause >nul
    exit /b
)

echo 【预览即将移动的项目】
echo ----------------------------------------------------------------------------------------
set count=0

for /f "usebackq delims=| tokens=1,* eol=;" %%s in ("move_list.txt") do (
    set "src=%%s"
    set "dst=%%t"
    set /a count+=1
    echo !count!. 源：!src!
    echo    → 目标：!dst!
    echo.
)

echo ----------------------------------------------------------------------------------------
echo 共 !count! 项
set /p "confirm=确定要移动吗？[Y/N]："

if /i not "!confirm!"=="Y" (
    echo 已取消，未移动任何文件
    pause >nul
    exit /b
)

echo.
echo 开始执行移动...
echo ----------------------------------------------------------------------------------------

for /f "usebackq delims=| tokens=1,* eol=;" %%s in ("move_list.txt") do (
    set "src=%%s"
    set "dst=%%t"

    if exist "!src!" (
        md "!dst!" 2>nul
        move /Y "!src!" "!dst!" >nul 2>&1
        if errorlevel 1 (
            echo 失败：!src!
        ) else (
            echo 成功：!src!
        )
    ) else (
        echo 不存在：!src!
    )
)

echo.
echo 操作完成！
pause >nul


01
011121
0191porn
01download
01Download91Prjojcet
01game
01RG_downloads
01Video
01Video1
01工作区
01视频发来类6
1Video
1合欢宗三师妹
1汉服
1美丽的景象
2恐怖
2打戏
3知识1
4二次元
5动物
5奥特曼
5软件
6atv
6music 你怎么还没有发财！你配！配！
6seedance
6混剪
6游戏
6鬼畜
7ai正常剧情
7ai热水器
7TIKTOK
7TIKTOK_VIdeo视频分类
7TIKTOK_VIdeo视频分类2
7Tiktok真人
7tiktok舞蹈
7TIKTOK衣服
game