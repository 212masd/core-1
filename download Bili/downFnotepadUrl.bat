echo .>downUpUrl.txt
pause
cd UpSpace
move *投稿视频.txt ..
cd ..
type *投稿视频.txt>>downUpUrl.txt
pause
call downvideoUPSpace.bat