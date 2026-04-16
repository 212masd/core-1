# -*- coding: utf-8 -*-
import urllib.parse

def main():
    # 读取关键词
    try:
        with open("config.txt", "r", encoding="utf-8") as f:
            lines = [line.strip() for line in f if line.strip()]
    except:
        print("未找到 config.txt 文件")
        return

    # 生成链接
    results = []
    for kw in lines:
        enc_kw = urllib.parse.quote(kw)
        url = f"https://91porn.com/search_result.php?search_id={enc_kw}&page=1"
        results.append(f"{kw}\n{url}\n")

    # 保存文件
    with open("bilibili_search_links.txt", "w", encoding="utf-8") as f:
        f.write("\n".join(results))

    print(f"生成完成！共 {len(results)} 个 B 站搜索链接")
    print("已保存到 bilibili_search_links.txt")

if __name__ == "__main__":
    main()