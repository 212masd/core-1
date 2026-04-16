@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

:: ====================== 自定义配置 ======================
set "output_file=视频文件统计.txt"  :: 统计结果保存的文件名
:: 要统计的视频后缀（可添加/删减，用空格分隔）
set "video_exts=.mp4 .flv .mkv .avi .mov .wmv .webm .m4v .rmvb .mpeg"
:: ==========================================================

:: 清空输出文件（避免旧内容干扰）
type nul > "%output_file%"

:: 写入统计标题和时间
echo ====================== 视频文件统计报告 ====================== >> "%output_file%"
echo 统计时间：%date% %time% >> "%output_file%"
echo 统计目录：%cd% >> "%output_file%"
echo ========================================================== >> "%output_file%"
echo. >> "%output_file%"

:: 初始化计数器
set "video_count=0"

echo 正在扫描视频文件...
echo 【视频文件明细】 >> "%output_file%"
echo ---------------------------------------------------------- >> "%output_file%"
echo 文件名                          大小(MB)    修改日期                >> "%output_file%"
echo ---------------------------------------------------------- >> "%output_file%"

:: 遍历所有视频后缀
for %%e in (%video_exts%) do (
    :: 遍历当前目录下对应后缀的视频文件
    for %%f in (*%%e) do (
        :: 统计数量
        set /a video_count+=1
        
        :: 获取文件大小（字节转MB，保留2位小数）
        set "file_size=%%~zf"
        :: 计算 MB = 字节 / 1024 / 1024
        set /a "size_mb=!file_size!/1024/1024"
        set /a "size_kb_remain=(!file_size! - !size_mb!*1024*1024)/1024"
        :: 格式化大小显示（比如 12.34 MB）
        set "size_display=!size_mb!.!size_kb_remain!"
        if !size_kb_remain! lss 10 set "size_display=!size_mb!.0!size_kb_remain!"
        
        :: 获取文件修改日期（格式：YYYY-MM-DD HH:MM）
        set "file_date=%%~tf"
        :: 截取日期和时间（适配系统默认格式）
        set "date_part=!file_date:~0,10!"
        set "time_part=!file_date:~11,5!"
        set "full_date=!date_part! !time_part!"
        
        :: 写入文件（对齐格式，保证易读）
        echo %%~nxf                    !size_display! MB    !full_date! >> "%output_file%"
        
        :: 控制台同步显示
        echo 找到：%%~nxf (大小：!size_display! MB，修改时间：!full_date!)
    )
)

echo. >> "%output_file%"
echo ---------------------------------------------------------- >> "%output_file%"
echo 统计结果：共找到 !video_count! 个视频文件 >> "%output_file%"
echo ========================================================== >> "%output_file%"

echo.
echo ✅ 统计完成！
echo 📄 结果已保存到：%cd%\%output_file%
echo 📊 共统计到 !video_count! 个视频文件
pause