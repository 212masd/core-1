@echo off
chcp 65001 >nul
cd /d "%~dp0"
call "MakerFile.bat"
pause

echo =====================================
echo 开始自动处理所有子文件夹
echo 脚本所在目录：%cd%
echo =====================================
: 新增功能：删除小于12KB的文件夹
echo =====================================
echo 🗑️  开始清理：删除容量低于12KB的文件夹
echo =====================================
echo.

:: 遍历所有文件夹，计算大小并删除小于12KB的文件夹
for /d %%i in (*) do (
    echo 🔍 检查文件夹：%%i
    :: 计算文件夹总大小（字节）
    set "folder_size=0"
    for /f "delims=" %%a in ('dir /s /b /a-d "%%i" 2^>nul') do (
        set /a folder_size+=%%~za
    )
    :: 12KB = 12 * 1024 = 12288 字节
    if !folder_size! lss 12288 (
        echo ⚠️  文件夹大小：!folder_size! 字节（低于12KB，将删除）
        rd /s /q "%%i" 2>nul
        if errorlevel 1 (
            echo ❌  删除失败：文件夹被占用或无权限
        ) else (
            echo ✅  已删除文件夹：%%i
        )
    ) else (
        echo ✅  文件夹大小：!folder_size! 字节（大于等于12KB，保留）
    )
    echo.
)

:: 全部完成
echo =====================================
echo 🎉 全部任务执行完毕！
echo 📊 已完成：视频处理 + 文件移动 + 小体积文件夹清理
echo =====================================
pause >nul
endlocal
exit /b

exit
pause
:: 遍历当前目录下 所有 文件夹
for /d %%d in (*) do (

echo.
echo =====================================
echo 正在处理文件夹：%%d
echo =====================================
:: 处理开始提示
echo =====================================
echo 📂 开始自动处理所有子文件夹
echo 📍 脚本所在目录：%cd%
echo =====================================
echo.


:: 1. 把当前目录里的 子脚本.bat 复制到这个文件夹里
copy "reNameVideo.bat" "%%d\" /y >nul

:: 2. 进入这个文件夹
pushd "%%d"

:: 3. 运行里面的子脚本
call "reNameVideo.bat"
echo 分类视频到文件夹中

:: 4. 退回上一级目录
popd

)
echo.
echo ✅ 全部完成！
echo 开始移动
call "Filere.bat"

:
