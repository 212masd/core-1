@echo off
chcp 65001 >nul
title B站链接工具 - 自动初始化
echo.
echo ==============================================
echo          正在自动生成 B站搜索链接工具
echo ==============================================
echo.

:: 1. 生成关键词配置文件
echo .> gen_bili_links.py
echo .> run.bat
echo 正在创建 config.txt ...
(
echo 花枝鼠露肚皮睡觉
echo 花枝鼠4K亚克力笼
echo 花枝鼠可爱瞬间
echo 花枝鼠饲养教程
echo 花枝鼠训练
echo 花枝鼠互动
echo 花枝鼠睡姿大赏
echo 花枝鼠飞象耳
echo 花枝鼠奶咖色
echo 花枝鼠浅灰色
echo 花枝鼠治愈日常
echo 花枝鼠慵懒时刻
echo 花枝鼠萌宠短视频
echo 花枝鼠vlog
echo 花枝鼠安静睡觉
echo 花枝鼠四脚朝天
echo 花枝鼠小肚皮
echo 花枝鼠软萌
echo 花枝鼠憨态可掬
echo 花枝鼠治愈系
) > config.txt

:: 2. 生成 Python 核心脚本
echo 正在创建 gen_bili_links.py ...
(
echo # -*- coding: utf-8 -*-
echo import urllib.parse
echo.
echo def main^():
echo     try^:
echo         with open^("config.txt", "r", encoding="utf-8"^) as f^:
echo             lines = [line.strip^(^) for line in f if line.strip^(^)]
echo     except^:
echo         print^("未找到 config.txt"^)
echo         return
echo.
echo     results = []
echo     for kw in lines^:
echo         enc = urllib.parse.quote^(kw^)
echo         url = f"https://search.bilibili.com/all?keyword={enc}"
echo         results.append^(f"{kw}\n{url}\n"^)
echo.
echo     with open^("bilibili_links.txt", "w", encoding="utf-8"^) as f^:
echo         f.write^("\n\n".join^(results^)^)
echo.
echo     print^(f"生成完成！共 {len(results)} 个链接"^)
echo     print^("已保存至 bilibili_links.txt"^)
echo.
echo if __name__ == "__main__":
echo     main^(^)
) > gen_bili_links.py

:: 3. 生成一键运行批处理
echo 正在创建 run.bat ...
(
echo @echo off
echo chcp 65001 ^>nul
echo echo.
echo echo ==============================
echo echo      B站批量链接生成器
echo echo ==============================
echo echo.
echo py gen_bili_links.py
echo echo.
echo pause
) > run.bat

echo.
echo ==============================================
echo          初始化完成！双击 run.bat 使用
echo ==============================================
echo.
pause