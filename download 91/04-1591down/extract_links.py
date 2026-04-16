import re
import urllib.request
import urllib.parse
import sys
import os
from concurrent.futures import ThreadPoolExecutor, as_completed

# ========== 配置 ==========
INPUT_FILE = "links.txt"
OUTPUT_FILE = "real_urls.txt"
MAX_WORKERS = 5
TIMEOUT = 20
PROXY_ADDR = "127.0.0.1:7897"  # 本地代理地址

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Referer": "https://191orn.com/"
}

# 尝试使用代理
try:
    PROXY = urllib.request.ProxyHandler({
        "http": PROXY_ADDR,
        "https": PROXY_ADDR
    })
    OPENER = urllib.request.build_opener(PROXY)
    print(f"[INFO] 使用代理: {PROXY_ADDR}")
except Exception:
    OPENER = urllib.request.build_opener()
    print("[INFO] 未使用代理")


def parse_one_url(url):
    """解析单个视频页面，提取 strencode2 加密的 MP4 直链"""
    try:
        req = urllib.request.Request(url, headers=HEADERS)
        with OPENER.open(req, timeout=TIMEOUT) as resp:
            charset = "utf-8"
            ct = resp.headers.get("Content-Type", "")
            if "charset=" in ct:
                charset = ct.split("charset=")[-1].split(";")[0].strip()
            html = resp.read().decode(charset, errors="ignore")

        # 匹配 strencode2(...)
        enc_match = re.search(r'strencode2\(["\']([^"\']+)["\']\)', html)
        if not enc_match:
            return f"[解析失败] {url}（未找到加密串）"

        enc = enc_match.group(1)
        dec = urllib.parse.unquote(enc)

        # 提取 mp4 地址
        mp4_match = re.search(r'src=["\']([^"\']+?\.mp4[^"\']*)["\']', dec)
        if not mp4_match:
            return f"[解析失败] {url}（未找到mp4）"

        return mp4_match.group(1)

    except Exception as e:
        return f"[异常] {url} => {str(e)}"


def main():
    input_file = sys.argv[1] if len(sys.argv) > 1 else INPUT_FILE
    output_file = sys.argv[2] if len(sys.argv) > 2 else OUTPUT_FILE
    workers = int(sys.argv[3]) if len(sys.argv) > 3 else MAX_WORKERS

    if not os.path.exists(input_file):
        print(f"未找到 {input_file}")
        return

    with open(input_file, "r", encoding="utf-8") as f:
        urls = [line.strip() for line in f if line.strip() and not line.startswith("#")]

    if not urls:
        print("链接文件为空")
        return

    total = len(urls)
    print(f"共 {total} 个链接，开始解析...")

    results = [None] * total
    with ThreadPoolExecutor(max_workers=workers) as pool:
        future_map = {pool.submit(parse_one_url, url): i for i, url in enumerate(urls)}
        done = 0
        for future in as_completed(future_map):
            idx = future_map[future]
            results[idx] = future.result()
            done += 1
            ok = not results[idx].startswith("[")
            print(f"  {'OK' if ok else 'FAIL'} [{done}/{total}] {urls[idx][:60]}...")

    with open(output_file, "w", encoding="utf-8") as f:
        f.write("\n".join(results))

    success = sum(1 for r in results if not r.startswith("["))
    print(f"\n完成！成功 {success}/{total}，结果已保存到 {output_file}")


if __name__ == "__main__":
    main()
