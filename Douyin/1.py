from http.server import HTTPServer, BaseHTTPRequestHandler
import json

class Handler(BaseHTTPRequestHandler):
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

        length = int(self.headers.get("Content-Length", 0))
        raw = self.rfile.read(length).decode("utf-8")

        try:
            data = json.loads(raw)
            content = data.get("text", "")
        except:
            content = ""

        if content:
            with open("urls.txt", "a", encoding="utf-8") as f:
                f.write(content + "\n----------------------------------------\n")
            print("已写入内容")

if __name__ == "__main__":
    print("Python 服务已启动：127.0.0.1:8000")
    HTTPServer(("127.0.0.1", 8000), Handler).serve_forever()