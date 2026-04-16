@echo off
chcp 65001 >nul
cd /d "%~dp0"
call "MakerFile.bat"
pause

echo =====================================
echo 开始自动处理所有子文件夹
echo 脚本所在目录：%cd%
echo =====================================

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
