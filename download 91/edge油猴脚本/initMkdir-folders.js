// ==UserScript==
// @name         041191porn视频批量提取工具箱（悬浮面板版）-完美版
// @author       主角
// @match        *://*.91porn.com/view_video.php*
// @match        *://*.91porn.com/index.php*
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
        width: 420px;
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
            <span>91批量视频解析工具</span>
            <button id="fold_btn" style="background:none; border:none; color:#fff; font-size:16px; cursor:pointer;">−</button>
        </div>
        <div id="panel_body">
            <div style="padding:10px; font-size:12px; color:#aaa;">输入视频链接（一行一个）</div>
            <textarea id="input_links" style="width:calc(100% - 20px); height:120px; margin:0 10px; padding:8px; background:#25252b; border:1px solid #444; color:#fff; border-radius:6px; resize:none;"></textarea>

            <div style="display:flex; gap:10px; padding:10px;">
                <button id="start_parse" style="flex:1; padding:10px; background:#3e63ff; border:none; border-radius:8px; color:#fff; cursor:pointer;">开始91后台解析</button>
                <button id="copy_result" style="flex:1; padding:10px; background:#2dbe61; border:none; border-radius:8px; color:#fff; cursor:pointer;">复制91全部直链</button>
            </div>

            <div style="padding:10px; font-size:12px; color:#aaa;">解析结果</div>
            <textarea id="output_result" readonly style="width:calc(100% - 20px); height:120px; margin:0 10px; padding:8px; background:#25252b; border:1px solid #444; color:#fff; border-radius:6px; resize:none;"></textarea>
        </div>
    `;

    document.body.appendChild(panel);

    // 拖动功能
    const drag = document.getElementById('drag_title');
    let isDrag = false;
    drag.addEventListener('mousedown', () => isDrag = true);
    document.addEventListener('mousemove', (e) => {
        if (!isDrag) return;
        panel.style.left = e.clientX - 150 + 'px';
        panel.style.top = e.clientY - 20 + 'px';
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

    // 后台批量解析（你确认正确的解析逻辑）
    document.getElementById('start_parse').addEventListener('click', async () => {
        const input = document.getElementById('input_links').value.trim();
        if (!input) return alert('请输入91porn链接');

        const urls = input.split('\n').map(i => i.trim()).filter(i => i);
        const output = document.getElementById('output_result');
        output.value = '正在后台解析91...\n';

        let result = [];
        for (const url of urls) {
            try {
                const html = await new Promise((ok, err) => {
                    GM_xmlhttpRequest({
                        method: 'GET',
                        url: url,
                        onload: res => ok(res.responseText),
                        onerror: err
                    });
                });

                // 你确认正确的解析格式
                const enc = html.match(/strencode2\("([^"]+)"\)/)[1];
                const dec = decodeURIComponent(enc);
                const mp4 = dec.match(/src=['"]([^'"]+\.mp4[^'"]*)['"]/)[1];

                result.push(mp4);
            } catch(e) {
                result.push(`[失败] ${url}`);
            }
        }

        output.value = result.join('\n');
    });
})();