@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
title 批量无水印下载工具 - 基于yt-dlp（原生批量）
mode con cols=100 lines=30
cd /d "%~dp0"

:: ==============================================
:: 环境初始化与依赖检查（避免运行报错）
:: ==============================================

yt-dlp.exe   --batch-file  "urls.txt" -N 16 --proxy http://127.0.0.1:7897  -P "D:\91"--no-write-description ^
--ignore-errors ^
--no-overwrites ^
--retries 20 ^



:: ==============================================
:: 用户交互：选择下载模式（可选，增强灵活性）
:: ==============================================
echo.
echo ==============================================
echo          🔗 批量无水印下载工具（yt-dlp原生批量）
echo ==============================================
echo 支持平台：抖音、B站、YouTube、小红书等千余种平台
echo urls.txt 格式：每行1个链接，#开头为注释（将被跳过）
echo 下载路径：%~dp0download
echo 日志路径：%~dp0logs
echo ==============================================
echo 下载模式选择：
echo 1. 默认模式（无水印、原格式、嵌入元数据）
echo 2. 仅下载MP4格式（1080P上限，兼容所有设备）
echo 3. 自定义模式（手动输入yt-dlp参数，适合进阶用户）
echo ==============================================

set "mode="
set /p "mode=请输入模式编号（1/2/3，直接回车默认选1）："
if not defined mode set "mode=1"  :: 默认模式1

:: ==============================================
:: 构建yt-dlp下载参数（核心逻辑）
:: ==============================================
set "commonParams=^
    -a urls.txt ^                  :: 核心：读取urls.txt中的链接列表
    
"
mkdir Video91
:: 根据模式添加额外参数
if !mode! equ 1 (
    set "finalParams=!commonParams!"
) else if !mode! equ 2 (
    yt-dlp.exe   --batch-file "urls.txt" 
) 