@echo off
REM 关闭命令回显，让执行过程更整洁
REM 执行1.bat，执行完成后再继续后续命令
cd ups
call DeleteMaker.bat
pause
cd ..
pause
call downvideoUPSpace.bat
pause
cd ups
pause

call 1.bat

