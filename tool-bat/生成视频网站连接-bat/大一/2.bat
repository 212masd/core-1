dir /s  /a  /b Fc*.ts
dir /s  /a  /b Fc*.ts>fc2.txt
pause
mkdir fc2
pause
for /r "%cd%" %f in (Fc*.ts) do (move "%~f" "%cd%\fc2\")
cd fc2
dir
pause

