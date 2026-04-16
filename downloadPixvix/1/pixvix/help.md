以下是`help.txt`文件内容的中文翻译：

---

### **用法**：
`gallery-dl.exe [选项] URL [URL...]`

---

### **通用选项**：
- `-h, --help`：打印此帮助信息并退出。
- `--version`：打印程序版本并退出。
- `-f, --filename FORMAT`：下载文件的文件名格式字符串（`/O`表示“原始”文件名）。
- `-d, --destination PATH`：文件下载的目标位置。
- `-D, --directory PATH`：文件下载的确切位置。
- `-X, --extractors PATH`：从指定路径加载外部提取器。
- `-a, --user-agent UA`：设置User-Agent请求头。
- `--clear-cache MODULE`：删除模块的缓存登录会话、Cookie等（使用`ALL`删除所有缓存）。
- `--compat`：恢复旧版“类别”名称。

---

### **更新选项**：
- `-U, --update`：更新到最新版本。
- `--update-to CHANNEL[@TAG]`：切换到不同的发布渠道（`stable`或`dev`）或升级/降级到指定版本。
- `--update-check`：检查是否有新版本可用。

---

### **输入选项**：
- `-i, --input-file FILE`：从文件中下载URL（`-`表示从标准输入读取）。可以指定多个`--input-file`。
- `-I, --input-file-comment FILE`：从文件中下载URL，成功下载后将其注释掉。
- `-x, --input-file-delete FILE`：从文件中下载URL，成功下载后将其删除。
- `--no-input`：不提示输入密码/令牌。

---

### **输出选项**：
- `-q, --quiet`：启用静默模式。
- `-w, --warning`：仅打印警告和错误。
- `-v, --verbose`：打印各种调试信息。
- `-g, --get-urls`：打印URL而不下载。
- `-G, --resolve-urls`：打印URL而不下载；解析中间URL。
- `-j, --dump-json`：打印JSON信息。
- `-J, --resolve-json`：打印JSON信息；解析中间URL。
- `-s, --simulate`：模拟数据提取，不下载任何内容。
- `-E, --extractor-info`：打印提取器的默认设置和信息。
- `-K, --list-keywords`：打印可用关键字及示例值。
- `-e, --error-file FILE`：将返回错误的输入URL添加到文件中。
- `-N, --print [EVENT:]FORMAT`：在指定事件期间将FORMAT写入标准输出，而不是下载文件。
- `--print-to-file [EVENT:]FORMAT FILE`：在指定事件期间将FORMAT追加到文件，而不是下载文件。
- `--list-modules`：打印可用提取器模块列表。
- `--list-extractors [CATEGORIES]`：打印提取器类的描述、类别和示例URL。
- `--write-log FILE`：将日志输出写入文件。
- `--write-unsupported FILE`：将无法处理的URL写入文件。
- `--write-pages`：将下载的中间页面写入当前目录以调试问题。
- `--print-traffic`：显示发送和接收的HTTP流量。
- `--no-colors`：输出中不使用ANSI颜色代码。

---

### **网络选项**：
- `-R, --retries N`：失败的HTTP请求的最大重试次数（默认：4，`-1`表示无限重试）。
- `--http-timeout SECONDS`：HTTP连接超时时间（默认：30.0秒）。
- `--proxy URL`：使用指定的代理。
- `--source-address IP`：绑定客户端IP地址。
- `-4, --force-ipv4`：强制使用IPv4连接。
- `-6, --force-ipv6`：强制使用IPv6连接。
- `--no-check-certificate`：禁用HTTPS证书验证。

---

### **下载选项**：
- `-r, --limit-rate RATE`：设置最大下载速率（例如：500k、2.5M或800k-2M）。
- `--chunk-size SIZE`：设置内存数据块大小（默认：32k）。
- `--sleep SECONDS`：每次下载前等待的秒数（可以是固定值或范围，例如：2.7或2.0-3.5）。
- `--no-part`：不使用`.part`文件。
- `--no-skip`：不跳过下载；覆盖现有文件。
- `--no-mtime`：不根据HTTP响应头中的`Last-Modified`设置文件修改时间。
- `--no-download`：不下载任何文件。

---

### **配置选项**：
- `-o, --option KEY=VALUE`：设置额外选项，例如：`-o browser=firefox`。
- `-c, --config FILE`：加载额外的配置文件。
- `--config-create`：创建基本配置文件。
- `--config-status`：显示配置文件状态。
- `--config-open`：在外部应用中打开配置文件。
- `--config-ignore`：忽略默认配置文件。

---

### **认证选项**：
- `-u, --username USER`：登录用户名。
- `-p, --password PASS`：登录密码。
- `--netrc`：启用`.netrc`认证数据。

---

### **Cookie选项**：
- `-C, --cookies FILE`：从文件加载额外的Cookie。
- `--cookies-export FILE`：将会话Cookie导出到文件。
- `--cookies-from-browser BROWSER[/DOMAIN][+KEYRING][:PROFILE][::CONTAINER]`：从浏览器加载Cookie。

---

### **选择选项**：
- `-A, --abort N[:TARGET]`：在连续跳过N个文件下载后停止当前提取器。
- `--filesize-min SIZE`：不下载小于指定大小的文件。
- `--filesize-max SIZE`：不下载大于指定大小的文件。
- `--download-archive FILE`：记录已成功下载的文件并跳过它们。

---

### **后处理选项**：
- `-P, --postprocessor NAME`：启用指定的后处理器。
- `--write-metadata`：将元数据写入单独的JSON文件。
- `--zip`：将下载的文件存储为ZIP归档文件。
- `--ugoira FMT`：将Pixiv的Ugoira转换为指定格式（如`webm`、`mp4`、`gif`等）。
- `--exec CMD`：为每个下载的文件执行CMD命令。

---

这是完整的中文翻译，方便理解和使用。g