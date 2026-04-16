from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import subprocess  # 原生自带，不用装
import threading   # 也是原生


class MyHandler(BaseHTTPRequestHandler):
    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")
        self.end_headers()

    def do_POST(self):
        self.send_response(200)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.end_headers()

        # 读取油猴发来的内容
        length = int(self.headers.get("Content-Length", 0))
        data = self.rfile.read(length).decode("utf-8")
        obj = json.loads(data)
        text = obj.get("text", "")

        if text:
            # 清空 data.txt
         with open("UpUrl.txt", "w", encoding="utf-8") as f:
               f.write("")  # 写入空内容 = 清空

            # 1. 写入 txt
        with open("UpUrl.txt", "a", encoding="utf-8") as f:
                f.write(text + "\n----------------\n")

            # 2. 调用 bat（用线程不卡服务）
        threading.Thread(target=self.run_bat, daemon=True).start()

    # 原生调用 bat
    def run_bat(self):
        try:
            # 这里写你的 bat 名字
            subprocess.Popen("downvideoUPSpace.bat", shell=True)
            print("已执行 bat")
        except Exception as e:
            print("执行失败:", e)


if __name__ == "__main__":
    print("服务启动：127.0.0.1:8000")
    HTTPServer(("127.0.0.1", 8000), MyHandler).serve_forever()