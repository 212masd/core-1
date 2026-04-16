import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.edge.options import Options

# ===================== 视频链接 =====================
video_urls = [
    "https://missav.ws/ja/gns-091?__cf_chl_rt_tk=zNEwttUSRXDhUY7H2E4X.SD2ebpceyzOnVardkocQ8I-1776091580-1.0.1.1-FnrYnBp_CI9l_DyAJAs6zNVFa5c3A2gC57oUkLYYSds#df1cf8d7-ba7e-4dfe-9201-7b396b63187e_desktop-home-recommended",
]

# ====================================================

# ✅ 修复空白页 + 崩溃的核心配置
edge_options = Options()
edge_options.add_argument("--remote-debugging-port=0")
# 解决白屏
edge_options.add_argument("--no-sandbox")
edge_options.add_argument("--disable-dev-shm-usage")
edge_options.add_argument("--disable-gpu")

# 解决SSL错误
edge_options.add_argument("--ignore-certificate-errors")

# 关闭烦人的日志
edge_options.add_experimental_option('excludeSwitches', ['enable-logging'])

# ✅ 关键：使用你自己的浏览器（带IDM插件），而不是全新干净浏览器！
# 这是你点不到IDM的真正原因！！！
edge_options.add_argument("--user-data-dir=C:\\Users\\马瑞\\AppData\\Local\\Microsoft\\Edge\\User Data")
edge_options.add_argument("--profile-directory=Default")

# 打开浏览器（用修复后的配置）
driver = webdriver.Edge(options=edge_options)
driver.maximize_window()

# 循环
for i, url in enumerate(video_urls, 1):
    print(f"[{i}/{len(video_urls)}] 正在打开: {url}")

    try:
        driver.get(url)
        time.sleep(5)
        print("✅ 页面打开成功")

    except Exception as e:
        print(f"❌ 处理失败: {e}")

    print("-" * 70)
    time.sleep(1)

print("🎉 全部完成！")
driver.quit()