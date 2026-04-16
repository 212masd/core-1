    from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import subprocess
import threading
import os


class MyHandler(BaseHTTPRequestHandler):
    # 处理跨域预检请求
    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "POST, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")
        self.end_headers()

    def do_POST(self):
        try:
            # 读取请求数据
            content_length = int(self.headers.get("Content-Length", 0))
            post_data = self.rfile.read(content_length).decode("utf-8")
            obj = json.loads(post_data)
            text = obj.get("text", "").strip()

            # 核心修改：先彻底删除/清空 TXT 文件，再写入新内容
            txt_path = "UpUrl.txt"
            if os.path.exists(txt_path):
                # 方法1：彻底删除文件（如果想彻底删除，用这行）
                os.remove(txt_path) 
                # 方法2：清空文件内容（如果想保留文件，只清空内容，用下面这行替代上面的 remove）
                # with open(txt_path, "w", encoding="utf-8") as f: f.write("")

            # 写入新内容（如果文件被删除了，open 会自动新建）
            if text:
                with open(txt_path, "a", encoding="utf-8") as f:
                    f.write(text + "\n----------------\n")

            # 响应前端
            self.send_response(200)
            self.send_header("Access-Control-Allow-Origin", "*")
            self.send_header("Content-Type", "application/json; charset=utf-8")
            self.end_headers()
            self.wfile.write(json.dumps({"status": "ok", "msg": "已清空旧内容，导入新内容成功"}).encode("utf-8"))

            # 后台执行bat（不阻塞服务）
            if text:
                threading.Thread(target=self.run_bat, daemon=True).start()

        except Exception as e:
            # 出错时返回错误
            self.send_response(500)
            self.end_headers()
            print(f"处理请求出错：{e}")

    # 执行批处理文件
    def run_bat(self):
        try:
            # 获取当前脚本目录，确保能找到bat
            bat_path = os.path.join(os.getcwd(), "downvideoUPSpace.bat")
            if not os.path.exists(bat_path):
                print(f"错误：未找到文件 {bat_path}")
                return

            # 隐藏黑窗口运行（可选，不想要可以删掉）
            startupinfo = subprocess.STARTUPINFO()
            startupinfo.dwFlags |= subprocess.STARTF_USESHOWWINDOW

            subprocess.Popen(
                [bat_path],
                shell=True,
                startupinfo=startupinfo,
                cwd=os.getcwd()
            )
            print("✅ 成功执行 downvideoUPSpace.bat")
        except Exception as e:
            print(f"❌ 执行bat失败：{e}")


# 禁用控制台日志输出（更干净）
class QuietHTTPServer(HTTPServer):
    def log_message(self, format, *args):
        pass


if __name__ == "__main__":
    HOST, PORT = "127.0.0.1", 8000
    print(f"✅ 服务已启动：http://{HOST}:{PORT}")
    print(f"✅ 功能：每次接收数据前 先清空/删除 UpUrl.txt 再写入新内容")
    print(f"✅ 等待油猴脚本发送数据...")
    QuietHTTPServer((HOST, PORT), MyHandler).serve_forever()