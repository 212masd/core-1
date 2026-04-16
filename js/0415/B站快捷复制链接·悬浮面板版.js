// ==UserScript==
// @name         B站快捷复制链接·悬浮面板版
// @version      1.0
// @description  鼠标指向视频按 \ 键复制链接，悬浮面板展示
// @author       You
// @match        *://*.bilibili.com/*
// @grant        GM_setClipboard
// @grant        GM_setValue
// @grant        GM_getValue
// @run-at       document-end
// ==/UserScript==

(function() {
    'use strict';

    // 快捷键：\  可以自己改，比如 'c'
    const HOTKEY = 'Alt';

    // 记住鼠标位置
    let mouseX = 0;
    let mouseY = 0;
    let isProcessing = false;

    // 视频链接正则
    const BV_REG = /(?:video\/|bvid=)(BV[a-zA-Z0-9]+)/i;

    // 历史链接
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

    // 读取记忆位置
    const savedTop = GM_getValue('panel_top', '120px');
    const savedLeft = GM_getValue('panel_left', '20px');
    container.style.top = savedTop;
    container.style.left = savedLeft;

    // 拖拽条
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

    // 内容区
    const content = document.createElement('div');
    content.style.padding = '10px';

    // 链接列表区域
    const listWrap = document.createElement('div');
    listWrap.style.maxHeight = '300px';
    listWrap.style.overflowY = 'auto';
    listWrap.style.marginBottom = '8px';
    listWrap.style.lineHeight = '1.4';

    // 按钮组
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

    // ========== 记忆折叠状态 ==========
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

    // ========== 拖拽记忆 ==========
    makeDraggable(container, dragBar, (top, left) => {
        GM_setValue('panel_top', top + 'px');
        GM_setValue('panel_left', left + 'px');
    });

    // ========== 渲染列表 ==========
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

    // ========== 按钮功能 ==========
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
        a.download = 'B站链接_' + Date.now() + '.txt';
        a.click();
        URL.revokeObjectURL(url);
        showToast('📥 已导出TXT');
    };

    // ========== 鼠标位置 ==========
    document.addEventListener('mousemove', e => {
        mouseX = e.clientX;
        mouseY = e.clientY;
    });

    // ========== 全局快捷键 ==========
    document.addEventListener('keydown', e => {
        if (e.key !== HOTKEY) return;
        const tag = e.target.tagName.toLowerCase();
        if (tag === 'input' || tag === 'textarea' || e.target.isContentEditable) return;
        if (isProcessing) return;

        e.preventDefault();
        findVideoAndCopy();
    });

    // ========== 找视频链接 ==========
    async function findVideoAndCopy() {
        isProcessing = true;
        let bv = null;

        // 1. 当前页是否是视频页
        const url = location.href;
        let m = url.match(BV_REG);
        if (m) bv = m[1];

        // 2. 鼠标下方找封面
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
            showToast('✅ 已复制：' + link);
        } else {
            showToast('❌ 未找到视频', true);
        }

        setTimeout(() => { isProcessing = false; }, 300);
    }

    // ========== 悬浮提示 ==========
    function showToast(text, isErr = false) {
        let toast = document.getElementById('toastBox');
        if (!toast) {
            toast = document.createElement('div');
            toast.id = 'toastBox';
           toast.style.cssText = `
    position: fixed;
    top: 30px;        /* 距离顶部 30 像素 */
    right: 30px;      /* 距离右侧 30 像素 → 贴右边！ */
    background: ${isErr ? '#d82f2f' : '#222'};
    color: #fff;
    padding: 10px 16px;
    border-radius: 6px;
    z-index: 9999999;
    font-size: 14px;
    opacity: 0;
    transition: all 0.3s;
    max-width: 280px; /* 防止太宽 */
    box-sizing: border-box;
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