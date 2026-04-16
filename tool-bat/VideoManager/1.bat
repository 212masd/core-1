@echo off
chcp 65001 >nul 2>&1  :: 强制使用UTF-8编码，解决中文乱码
set "output=urls.txt"  :: 合并后的文件名

:: 清空目标文件（避免重复追加）
echo. > "%output%"



:: 遍历当前目录所有txt文件并合并
for %%f in (*.txt) do (
    :: 跳过合并后的文件本身，避免循环
    if not "%%f"=="%output%" (
        type "%%f" >> "%output%"
        :: 每个文件后加换行，分隔内容
        echo. >> "%output%"
        
        echo. >> "%output%"
    )
)

move "%output%"

echo 整合完成！合并后的文件：%output%
pause >nul  :: 运行完成后暂停，方便查看结果