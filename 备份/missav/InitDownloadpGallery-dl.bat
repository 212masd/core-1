@REM mkdir MissAVDownloader


@REM git clone https://github.com/pyrolloryp/MissAV_Downloader.git
@REM cd MissAV_Downloader
@REM pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
@REM cd idm
@REM pip config set global.proxy 127.0.0.1:7897
@REM python.exe -m pip install --upgrade pip --proxy 127.0.0.1:7897
@REM pip install selenium --proxy 127.0.0.1:7897
@REM pause
@REM echo "正在安装IDM插件..."
echo  .>download_idm_plugin.py
echo .>config.txt

@REM move D:\b战\Useful Exe\IDM_NEw2026\IDMGCExt.crx idm
@REM pip install uv --proxy 127.0.0.1:7897
@REM uv add selenium

pip install gallery-dl==1.31.6 --proxy 127.0.0.1:7897