@echo off
chcp 65001
setlocal enabledelayedexpansion

echo 正在按前缀数字分组...
echo.

for %%f in (*.jpg *.jpeg *.png *.webp *.bmp *.gif) do (
    set "file=%%~nf"
    set "ext=%%~xf"
    set "full=%%f"

    for /f "delims=_p tokens=1" %%a in ("!file!") do (
        set "folder=%%a"

        if not exist "!folder!" md "!folder!"
        move "!full!" "!folder!\" >nul 2>&1

        echo 已移动 → !folder!: !full!
    )
)

echo.
echo 分组完成！
