// ==UserScript==
// @name         视频批量提取工具箱（悬浮面板版）
// @author       主角
// @match        *://*/*
// @grant        GM_xmlhttpRequest
// @grant        GM_setClipboard
// @grant        unsafeWindow
// ==/UserScript==

(function() {
    'use strict';

    // 创建可拖动、可折叠悬浮面板
    const panel = document.createElement('div');
    panel.style.cssText = `
        position: fixed;
        top: 50px;
        left: 50px;
        width: 280px;
        background: #1b1b1f;
        color: #eee;
        border-radius: 12px;
        box-shadow: 0 0 25px rgba(0,0,0,0.7);
        z-index: 999999;
        font-family: system-ui, sans-serif;
        overflow: hidden;
        resize: both;
    `;

    panel.innerHTML = `
        <div id="drag_title" style="padding:12px; background:#2c2c3e; cursor:move; display:flex; justify-content:space-between; align-items:center;">
            <span>🎬 视频直链提取工具</span>
            <button id="fold_btn" style="background:none; border:none; color:#fff; font-size:16px; cursor:pointer;">−</button>
        </div>
        <div id="panel_body">
            <div style="padding:10px; font-size:12px; color:#aaa;">输入视频链接（一行一个）</div>
            <textarea id="input_links" style="width:calc(100% - 20px); height:120px; margin:0 10px; padding:8px; background:#25252b; border:1px solid #444; color:#fff; border-radius:6px; resize:none;"></textarea>

            <div style="display:flex; gap:10px; padding:10px;">
                <button id="start_parse" style="flex:1; padding:10px; background:#3e63ff; border:none; border-radius:8px; color:#fff; cursor:pointer;">开始解析</button>
                <button id="copy_result" style="flex:1; padding:10px; background:#2dbe61; border:none; border-radius:8px; color:#fff; cursor:pointer;">复制全部直链</button>
            </div>

            <div style="padding:10px; font-size:12px; color:#aaa;">解析结果</div>
            <textarea id="output_result" readonly style="width:calc(100% - 20px); height:120px; margin:0 10px; padding:8px; background:#25252b; border:1px solid #444; color:#fff; border-radius:6px; resize:none;"></textarea>
        </div>
    `;


    document.body.appendChild(panel);

    // 拖动功能
    const drag = document.getElementById('drag_title');
    let isDrag = false;
    let offsetX = 0, offsetY = 0;
    
    drag.addEventListener('mousedown', (e) => {
        isDrag = true;
        offsetX = e.clientX - panel.offsetLeft;
        offsetY = e.clientY - panel.offsetTop;
    });
    
    document.addEventListener('mousemove', (e) => {
        if (!isDrag) return;
        panel.style.left = (e.clientX - offsetX) + 'px';
        panel.style.top = (e.clientY - offsetY) + 'px';
    });
    
    document.addEventListener('mouseup', () => isDrag = false);

    // 折叠功能
    const fold = document.getElementById('fold_btn');
    const body = document.getElementById('panel_body');
    fold.addEventListener('click', () => {
        if (body.style.display === 'none') {
            body.style.display = 'block';
            fold.textContent = '−';
        } else {
            body.style.display = 'none';
            fold.textContent = '+';
        }
    });

    // 复制结果
    document.getElementById('copy_result').addEventListener('click', () => {
        const out = document.getElementById('output_result');
        GM_setClipboard(out.value);
        alert('已复制所有直链');
    });

    // 触发下载
    function triggerDownload(url) {
        const a = document.createElement('a');
        a.href = url;
        a.setAttribute('download', '');
        a.style.display = 'none';
        document.body.appendChild(a);
        a.click();
        setTimeout(() => a.remove(), 100);
    }

    // 解析视频直链
    async function extractVideoLink(url) {
        return new Promise((resolve, reject) => {
            GM_xmlhttpRequest({
                method: 'GET',
                url: url,
                onload: res => {
                    try {
                        const html = res.responseText;
                        
                        // 尝试匹配 strencode2 加密格式
                        const encMatch = html.match(/strencode2\s*\(\s*["']([^"']+)["']\s*\)/);
                        if (encMatch) {
                            const dec = decodeURIComponent(encMatch[1]);
                            const mp4Match = dec.match(/src\s*=\s*['"]([^'"]+\.mp4[^'"]*)['"]/);
                            if (mp4Match) {
                                resolve(mp4Match[1]);
                                return;
                            }
                        }
                        
                        // 尝试直接匹配 mp4 链接
                        const directMatch = html.match(/https?:\/\/[^"'\s]+\.mp4[^"'\s]*/);
                        if (directMatch) {
                            resolve(directMatch[0]);
                            return;
                        }
                        
                        reject('未找到视频直链');
                    } catch (e) {
                        reject(e.message);
                    }
                },
                onerror: err => reject('请求失败')
            });
        });
    }

    // 批量解析
    document.getElementById('start_parse').addEventListener('click', async () => {
        const input = document.getElementById('input_links').value.trim();
        if (!input) return alert('请输入链接');

        const urls = input.split('\n').map(i => i.trim()).filter(i => i);
        const output = document.getElementById('output_result');
        output.value = '正在解析...\n';

        const results = [];
        for (let i = 0; i < urls.length; i++) {
            const url = urls[i];
            output.value = `正在解析 (${i + 1}/${urls.length})...\n`;
            try {
                const link = await extractVideoLink(url);
                results.push(link);
                triggerDownload(link);
            } catch (e) {
                results.push(`[失败] ${url}: ${e}`);
            }
        }

        output.value = results.join('\n');
        output.value += `\n\n共解析 ${urls.length} 个，成功 ${results.filter(r => !r.startsWith('[失败]')).length} 个`;
    });
})();
