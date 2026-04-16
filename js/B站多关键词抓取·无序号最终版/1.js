
// ==UserScript==
// @name         B站多关键词抓取·无序号最终版
// @version      9.0
// @match        *://*/*
// @grant        GM_xmlhttpRequest
// @grant        GM_setClipboard
// @grant        GM_setValue
// @grant        GM_getValue
// @connect      search.bilibili.com
// @connect      bilibili.com
// @run-at       document-end
// ==/UserScript==

(function() {
    'use strict';

    const container = document.createElement('div');
    container.style.cssText = `
        position: fixed;
        top: 120px;
        right: 120px;
        z-index: 99999;
        width: 280px;
        user-select: none;
    `;

    const dragBar = document.createElement('div');
    dragBar.innerHTML = "B站链接抓取 <span style='float:right;cursor:pointer'>−</span>";
    dragBar.style.cssText = `
        background: #fb7299;
        color: #fff;
        padding: 8px 12px;
        font-size: 14px;
        font-weight: bold;
        border-radius: 8px 8px 0 0;
        cursor: move;
    `;

    const panel = document.createElement('div');
    panel.style.cssText = `
        background: #fff;
        padding: 12px;
        border-radius: 0 0 8px 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.2);
    `;

    const taskList = document.createElement('div');
    const tasks = [];

    function createTask(i) {
        const wrap = document.createElement('div');
        wrap.style.marginBottom = "8px";

        const kw = document.createElement('input');
        kw.placeholder = `关键词 ${i+1}`;
        kw.value = GM_getValue(`kw_${i}`, "");
        kw.style.cssText = "width: 60%; padding: 4px; margin-right: 4px; box-sizing: border-box;";

        const page = document.createElement('input');
        page.type = "number";
        page.min = 1;
        page.value = GM_getValue(`page_${i}`, 1);
        page.style.cssText = "width: 35%; padding: 4px; box-sizing: border-box;";

        kw.oninput = () => GM_setValue(`kw_${i}`, kw.value.trim());
        page.oninput = () => GM_setValue(`page_${i}`, page.value);

        wrap.appendChild(kw);
        wrap.appendChild(page);
        taskList.appendChild(wrap);
        return { kw, page };
    }

    tasks.push(createTask(0));
    tasks.push(createTask(1));
    tasks.push(createTask(2));

    const startBtn = document.createElement('button');
    startBtn.textContent = "开始抓取";
    startBtn.style.cssText = "width:100%; padding:8px; background:#fb7299; color:#fff; border:none; border-radius:4px; cursor:pointer; margin-top:4px;";

    const copyBtn = document.createElement('button');
    copyBtn.textContent = "复制全部";
    copyBtn.style.cssText = "width:100%; padding:8px; background:#00a1d2; color:#fff; border:none; border-radius:4px; cursor:pointer; margin-top:6px;";

    panel.appendChild(taskList);
    panel.appendChild(startBtn);
    panel.appendChild(copyBtn);
    container.appendChild(dragBar);
    container.appendChild(panel);
    document.body.appendChild(container);

    const resultBox = document.createElement('div');
    resultBox.style.cssText = `
        position: fixed;
        right: 20px;
        top: 330px;
        width: 280px;
        max-height: 420px;
        overflow-y: auto;
        background: #fff;
        padding: 12px;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.2);
        font-size: 12px;
        line-height: 1.5;
        white-space: pre-wrap;
        z-index: 99999;
    `;
    resultBox.textContent = "抓取结果将显示在这里";
    document.body.appendChild(resultBox);

    makeDraggable(container, dragBar);

    const foldBtn = dragBar.querySelector('span');
    foldBtn.onclick = () => {
        if (panel.style.display === 'none') {
            panel.style.display = 'block';
            resultBox.style.display = 'block';
            foldBtn.textContent = '−';
        } else {
            panel.style.display = 'none';
            resultBox.style.display = 'none';
            foldBtn.textContent = '+';
        }
    };

    let allLinks = [];

    startBtn.onclick = async function() {
        startBtn.disabled = true;
        startBtn.textContent = "抓取中...";
        allLinks = [];
        resultBox.textContent = "";

        for (const t of tasks) {
            const kw = t.kw.value.trim();
            const pageCount = parseInt(t.page.value) || 1;
            if (!kw) continue;

            resultBox.textContent += `===== ${kw} / ${pageCount}页 =====\n`;
            resultBox.scrollTop = resultBox.scrollHeight;

            for (let p = 1; p <= pageCount; p++) {
                resultBox.textContent += `抓取第 ${p} 页...\n`;
                resultBox.scrollTop = resultBox.scrollHeight;

                const html = await get(`https://search.bilibili.com/all?keyword=${encodeURIComponent(kw)}&page=${p}`);

                const bvMatches = html.match(/BV[a-zA-Z0-9]{10}/g) || [];
                const links = [...new Set(bvMatches)].map(bv => `https://www.bilibili.com/video/${bv}`);

                allLinks.push(...links);
                await sleep(600);
            }
        }

        const unique = [...new Set(allLinks)];
        resultBox.textContent += "\n===== 抓取完成 =====\n";
        resultBox.textContent += `去重后总数：${unique.length}\n\n`;

        unique.forEach((link) => {
            resultBox.textContent += `${link}\n`;
        });

        startBtn.disabled = false;
        startBtn.textContent = "开始抓取";
    };

    copyBtn.onclick = () => {
        GM_setClipboard([...new Set(allLinks)].join("\n"));
        alert("已复制全部链接");
    };

    function get(url) {
        return new Promise(resolve => {
            GM_xmlhttpRequest({
                method: "GET",
                url: url,
                headers: {
                    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36",
                    "Referer": "https://www.bilibili.com/",
                    "Origin": "https://www.bilibili.com"
                },
                timeout: 10000,
                onload: res => resolve(res.responseText),
                onerror: () => resolve(""),
                ontimeout: () => resolve("")
            });
        });
    }

    function sleep(ms) {
        return new Promise(r => setTimeout(r, ms));
    }

    function makeDraggable(el, handle) {
        let pos = { x: 0, y: 0, mx: 0, my: 0 };
        handle.onmousedown = e => {
            e.preventDefault();
            pos.mx = e.clientX;
            pos.my = e.clientY;
            document.onmousemove = move;
            document.onmouseup = up;
        };
        function move(e) {
            pos.x = pos.mx - e.clientX;
            pos.y = pos.my - e.clientY;
            pos.mx = e.clientX;
            pos.my = e.clientY;
            el.style.top = el.offsetTop - pos.y + "px";
            el.style.left = el.offsetLeft - pos.x + "px";
        }
        function up() {
            document.onmousemove = null;
            document.onmouseup = null;
        }
    }

})();