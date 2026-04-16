@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ==============================================
echo  全自动安装 RG 专用 Python 3.11 环境
echo  不修改系统 Python，不冲突 3.9
echo ==============================================
echo.

echo import site >> py311\python311._pth
pause
echo 3. 下载并安装 pip...
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
py311\python.exe get-pip.py
pause
echo 4. 清理代理，避免连接错误...
set HTTP_PROXY=
set HTTPS_PROXY=

echo 5. 安装 RG 所有依赖（清华高速源）...
py311\python.exe -m pip install -r requirements.txt --no-proxy -i https://pypi.tuna.tsinghua.edu.cn/simple

echo 6. 清理临时文件...
del get-pip.py

echo.
echo ==============================================
echo  安装完成！
echo  独立 Python 路径：%~dp0py311\python.exe
echo ==============================================
echo 接下来运行 RG 请用：run_rg.bat
echo.
pause