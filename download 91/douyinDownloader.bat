echo off
echo 开始下载抖音视频
echo 请稍后...
echo /p "请输入抖音视频链接："
echo 开始下载91视频
echo 请稍后...
yt-dlp --no-check-certificate -a links.txt  -N 16 --paths "D:\下载"
echo -----------------------
echo.
echo [成功] 所有下载任务已完成。
echo 视频已保存到目录: %DOWNLOAD_PATH%
 
:end
echo.
pause
