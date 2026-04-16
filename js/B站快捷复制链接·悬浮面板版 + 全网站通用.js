// ==UserScript==
// @name         B站快捷复制链接·悬浮面板版 + 全网站通用
// @version      2.0
// @description  按b键B站视频链接，按c键全网站通用链接，悬浮面板管理
// @author       You
// @match        *://*.bilibili.com/*
// @match        *://*/*
// @grant        GM_setClipboard
// @grant        GM_setValue
// @grant        GM_getValue
// @run-at       document-end
// ==/UserScript==

(function() {
    'use strict';

    let mouseX = 0;
    let mouseY = 0;
    let isProcessing = false;

    const BV_REG = /(?:video\/|bvid=)(BV[a-zA-Z0-9]+)/i;

    let linkList = JSON.parse(GM_getValue('link_list', '[]')) || [];

    // ========== 面板结构 ==========
    const container = document.createElement('div');
    container.style.cssText = `
        position: fixed;
        z-index: 999999;
        width: 280px;
        user-select: none;
        background: #fff;
        border-radius: 10px;
        box-shadow: 0 4px 16px rgba(0,0,0,0.2);
        overflow: hidden;
        font-size: 12px;
    `;

    const savedTop = GM_getValue('panel_top', '120px');
    const savedLeft = GM_getValue('panel_left', '20px');
    container.style.top = savedTop;
    container.style.left = savedLeft;

    const dragBar = document.createElement('div');
    dragBar.style.cssText = `
        background: #fb7299;
        color: #fff;
        padding: 8px 12px;
        font-weight: bold;
        cursor: move;
        display: flex;
        justify-content: space-between;
        align-items: center;
    `;
    dragBar.innerHTML = `<span>快捷链接收集</span><span id="foldBtn" style="cursor:pointer">−</span>`;
    const foldBtn = dragBar.querySelector('#foldBtn');

    const content = document.createElement('div');
    content.style.padding = '10px';

    const listWrap = document.createElement('div');
    listWrap.style.maxHeight = '300px';
    listWrap.style.overflowY = 'auto';
    listWrap.style.marginBottom = '8px';
    listWrap.style.lineHeight = '1.4';

    const btnGroup = document.createElement('div');
    btnGroup.style.display = 'flex';
    btnGroup.style.gap = '4px';

    const clearBtn = document.createElement('button');
    clearBtn.textContent = '清空列表';
    clearBtn.style.cssText = 'flex:1; padding:6px; background:#666; color:#fff; border:none; border-radius:4px; cursor:pointer; font-size:12px;';

    const copyAllBtn = document.createElement('button');
    copyAllBtn.textContent = '复制全部';
    copyAllBtn.style.cssText = 'flex:1; padding:6px; background:#00a1d2; color:#fff; border:none; border-radius:4px; cursor:pointer; font-size:12px;';

    const exportBtn = document.createElement('button');
    exportBtn.textContent = '导出TXT';
    exportBtn.style.cssText = 'flex:1; padding:6px; background:#1e87f0; color:#fff; border:none; border-radius:4px; cursor:pointer; font-size:12px;';

    btnGroup.append(clearBtn, copyAllBtn, exportBtn);
    content.append(listWrap, btnGroup);
    container.append(dragBar, content);
    document.body.appendChild(container);

    const isFolded = GM_getValue('panel_folded', false);
    if (isFolded) {
        content.style.display = 'none';
        foldBtn.textContent = '+';
    }

    foldBtn.onclick = () => {
        if (content.style.display === 'none') {
            content.style.display = 'block';
            foldBtn.textContent = '−';
            GM_setValue('panel_folded', false);
        } else {
            content.style.display = 'none';
            foldBtn.textContent = '+';
            GM_setValue('panel_folded', true);
        }
    };

    makeDraggable(container, dragBar, (top, left) => {
        GM_setValue('panel_top', top + 'px');
        GM_setValue('panel_left', left + 'px');
    });

    function renderList() {
        listWrap.innerHTML = '';
        const unique = [...new Set(linkList)];
        unique.forEach(link => {
            const item = document.createElement('div');
            item.style.padding = '4px 0';
            item.style.borderBottom = '1px solid #eee';
            item.textContent = link;
            listWrap.appendChild(item);
        });
    }
    renderList();

    clearBtn.onclick = () => {
        linkList = [];
        GM_setValue('link_list', '[]');
        renderList();
        showToast('✅ 已清空全部链接');
    };

    copyAllBtn.onclick = () => {
        const txt = [...new Set(linkList)].join('\n');
        GM_setClipboard(txt);
        showToast('✅ 已复制全部');
    };

    exportBtn.onclick = () => {
        const txt = [...new Set(linkList)].join('\n');
        const blob = new Blob([txt], { type: 'text/plain' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = '链接收集_' + Date.now() + '.txt';
        a.click();
        URL.revokeObjectURL(url);
        showToast('📥 已导出TXT');
    };

    document.addEventListener('mousemove', e => {
        mouseX = e.clientX;
        mouseY = e.clientY;
    });

    // ========== 双按键监听 ==========
    document.addEventListener('keydown', e => {
        const tag = e.target.tagName.toLowerCase();
        if (tag === 'input' || tag === 'textarea' || e.target.isContentEditable) return;
        if (isProcessing) return;

        // B 键 = B站专用
        if (e.key === 'b' || e.key === 'B') {
            e.preventDefault();
            findVideoAndCopy();
        }

        // C 键 = 通用链接
        if (e.key === 'Alt' || e.key === 'C') {
            e.preventDefault();
            findGeneralLink();
        }
    });

    // ========== 原有 B站函数（完全没动） ==========
    async function findVideoAndCopy() {
        isProcessing = true;
        let bv = null;
        const url = location.href;
        let m = url.match(BV_REG);
        if (m) bv = m[1];

        if (!bv) {
            const els = document.elementsFromPoint(mouseX, mouseY);
            for (const el of els) {
                const a = el.closest('a[href*="video"]');
                if (a && a.href) {
                    m = a.href.match(BV_REG);
                    if (m) {
                        bv = m[1];
                        break;
                    }
                }
            }
        }

        if (bv) {
            const link = `https://www.bilibili.com/video/${bv}`;
            if (!linkList.includes(link)) {
                linkList.unshift(link);
                GM_setValue('link_list', JSON.stringify(linkList));
                renderList();
            }
            GM_setClipboard(link);
            showToast('✅ B站视频链接已复制');
        } else {
            showToast('❌ 未找到B站视频', true);
        }

        setTimeout(() => { isProcessing = false; }, 300);
    }

    // ========== 新增：全网站通用链接函数 ==========
    async function findGeneralLink() {
        isProcessing = true;
        let finalLink = null;

        const elements = document.elementsFromPoint(mouseX, mouseY);
        for (const el of elements) {
            const a = el.closest('a[href]');
            if (a && a.href) {
                const href = a.href.trim();
                if (href.startsWith('http://') || href.startsWith('https://')) {
                    finalLink = href;
                    break;
                }
            }
        }

        if (!finalLink) {
            finalLink = window.location.href.trim();
        }

        if (!finalLink || !finalLink.startsWith('http')) {
            showToast('❌ 未找到有效链接', true);
            isProcessing = false;
            return;
        }

        if (!linkList.includes(finalLink)) {
            linkList.unshift(finalLink);
            GM_setValue('link_list', JSON.stringify(linkList));
            renderList();
        }

        GM_setClipboard(finalLink);
        showToast('✅ 通用链接已复制');

        setTimeout(() => { isProcessing = false; }, 260);
    }

    // ========== 提示 ==========
    function showToast(text, isErr = false) {
        let toast = document.getElementById('toastBox');
        if (!toast) {
            toast = document.createElement('div');
            toast.id = 'toastBox';
            toast.style.cssText = `
                position: fixed; top: 80px; left: 50%; transform: translateX(-50%);
                background: ${isErr ? '#f25555' : '#222'};
                color: #fff; padding: 10px 16px; border-radius: 6px;
                z-index: 9999999; font-size: 14px; opacity: 0;
                transition: 0.3s;
            `;
            document.body.appendChild(toast);
        }
        toast.textContent = text;
        toast.style.opacity = 1;
        setTimeout(() => toast.style.opacity = 0, 1800);
    }

    // ========== 拖拽 ==========
    function makeDraggable(el, handle, onMove) {
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
            const top = el.offsetTop - pos.y;
            const left = el.offsetLeft - pos.x;
            el.style.top = top + 'px';
            el.style.left = left + 'px';
            onMove?.(top, left);
        }
        function up() {
            document.onmousemove = null;
            document.onmouseup = null;
        }
    }

})();