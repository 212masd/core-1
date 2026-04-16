@REM ren cdG.bat cdFVideo.bat
@REM pause
set "workDir=G:\b站总结\game"
cd /d "%workDir%"
cd ..
dir /b /ad /s>"gameD.txt"
dir /b /a /s>"game.txt"
type game.txt
pause
notepad game.txt


