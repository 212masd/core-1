
// ==UserScript==
// @name         视频批量后台打开工具（区间选择+链接导出+时长过滤版）
// @namespace    http://tampermonkey.net/
// @version      2.8
// @description  支持选择第X到第Y个视频打开，导出链接，可按秒数过滤超长视频
// @author       You
// @match        *://*/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    // ===================== 核心配置 =====================
    const BTN_STYLE = {
        top: '10px',
        left: '10px',
        bgColor: '#007bff',
        textColor: '#fff'
    };
    const PANEL_WIDTH = '480px';
    const MAX_VIDEO_DISPLAY = 50;
    const TARGET_VIDEO_LINKS = [
        '/view_video.php?viewkey=',
        '.tv/video/',
        '/video/',
        'https://rule34gen.com/video/',
        'view_video.php?own=1&viewkey',
        'https://hanime1.me/watch?v='
    ];

    // ===================== 时长解析工具（把 0:00 / 1:00:00 转成秒） =====================
    function parseDurationToSeconds(durationText) {
        if (!durationText) return 0;
        const parts = durationText.trim().split(':').reverse();
        let seconds = 0;
        if (parts[0]) seconds += parseInt(parts[0]) || 0;
        if (parts[1]) seconds += (parseInt(parts[1]) || 0) * 60;
        if (parts[2]) seconds += (parseInt(parts[2]) || 0) * 3600;
        return seconds;
    }

    // ===================== 创建主按钮 =====================
    const mainBtn = document.createElement('div');
    mainBtn.innerText = '📹 选择视频';
    mainBtn.style.cssText = `
        position: fixed;
        top: ${BTN_STYLE.top};
        left: ${BTN_STYLE.left};
        z-index: 999999;
        padding: 8px 12px;
        background: ${BTN_STYLE.bgColor};
        color: ${BTN_STYLE.textColor};
        border-radius: 6px;
        cursor: pointer;
        font-size: 14px;
        user-select: none;
        box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        transition: background 0.2s;
    `;
    mainBtn.onmouseover = () => mainBtn.style.background = '#0056b3';
    mainBtn.onmouseout = () => mainBtn.style.background = BTN_STYLE.bgColor;
    document.body.appendChild(mainBtn);

    // ===================== 导出TXT =====================
    function exportLinksToTxt(links, fileName = '视频链接列表.txt') {
        const linkText = links.join('\n');
        const blob = new Blob([linkText], { type: 'text/plain; charset=utf-8' });
        const downloadLink = document.createElement('a');
        downloadLink.href = URL.createObjectURL(blob);
        downloadLink.download = fileName;
        downloadLink.click();
        URL.revokeObjectURL(downloadLink.href);
    }

    // ===================== 创建面板（新增时长过滤） =====================
    let panel = null;
    let currentVideoList = [];

    function createVideoPanel(videoList) {
        currentVideoList = videoList;
        if (panel) panel.remove();

        panel = document.createElement('div');
        panel.style.cssText = `
            position: fixed;
            top: 50px;
            left: 10px;
            width: ${PANEL_WIDTH};
            max-height: 600px;
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            z-index: 999998;
            padding: 16px;
            overflow-y: auto;
            display: none;
        `;

        const header = document.createElement('div');
        header.style.cssText = `
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
            padding-bottom: 8px;
            border-bottom: 1px solid #f0f0f0;
            gap: 10px;
        `;
        header.innerHTML = `
            <span style="font-size: 16px; font-weight: 600; color: #333;">可打开的视频 (${videoList.length})</span>

            <div style="display:flex; gap:6px; align-items:center; flex-wrap:wrap;">
                <span style="font-size:12px;">排除大于</span>
                <input type="number" id="maxSec" min="0" value="3600" style="width:70px; padding:4px; font-size:12px; border:1px solid #ddd; border-radius:4px;">
                <span style="font-size:12px;">秒的视频</span>
                <button id="filterByDuration" style="padding:4px 8px; font-size:12px; background:#dc3545; color:#fff; border:none; border-radius:4px; cursor:pointer;">过滤</button>
            </div>

            <div style="display:flex; gap:6px; align-items:center; flex-wrap: wrap;">
                <span style="font-size: 12px;">区间：</span>
                <input type="number" id="startNum" min="1" value="1" style="width:60px; padding:4px; font-size:12px;">
                <span style="font-size:12px;">~</span>
                <input type="number" id="endNum" min="1" value="${Math.min(20, videoList.length)}" style="width:60px; padding:4px; font-size:12px;">
                <button id="openRangeBtn" style="padding:4px 10px; font-size:12px; background:#28a745; color:#fff; border:none; border-radius:4px;">打开区间</button>
                <button id="exportRangeBtn" style="padding:4px 10px; font-size:12px; background:#17a2b8; color:#fff; border:none; border-radius:4px;">导出区间</button>
            </div>

            <div style="display:flex; gap:6px;">
                <button id="selectAllBtn" style="padding:4px 8px; font-size:12px;">全选</button>
                <button id="cancelAllBtn" style="padding:4px 8px; font-size:12px;">取消</button>
                <button id="openSelectedBtn" style="padding:4px 12px; font-size:12px; background:#007bff; color:#fff; border:none; border-radius:4px;">打开选中</button>
                <button id="exportSelectedBtn" style="padding:4px 12px; font-size:12px; background:#ffc107; color:#333; border:none; border-radius:4px;">导出选中</button>
            </div>
        `;
        panel.appendChild(header);

        const listContainer = document.createElement('div');
        listContainer.style.gap = '8px';
        listContainer.style.display = 'flex';
        listContainer.style.flexDirection = 'column';

        // 渲染列表
        function renderList(filteredList) {
            listContainer.innerHTML = '';
            filteredList.slice(0, MAX_VIDEO_DISPLAY).forEach((video, index) => {
                const item = document.createElement('div');
                item.style.cssText = `display:flex; align-items:flex-start; padding:8px; border-radius:4px;`;
                item.onmouseover = () => item.style.background = '#f9fafb';
                item.onmouseout = () => item.style.background = 'transparent';

                const checkbox = document.createElement('input');
                checkbox.type = 'checkbox';
                checkbox.value = video.url;
                checkbox.style.margin = '2px 8px 0 0';

                const info = document.createElement('div');
                info.style.flex = '1';
                info.style.fontSize = '13px';
                const title = (video.title.length > 35 ? video.title.substring(0, 35) + '...' : video.title);
                const durText = video.duration ? `(${video.duration})` : '';
                info.innerHTML = `
                    <div style="font-weight:500;">【${index+1}】${title} ${durText}</div>
                    <div style="font-size:11px; color:#666; word-break:break-all;">${video.url.slice(0,50)}${video.url.length>50?'...':''}</div>
                `;

                item.appendChild(checkbox);
                item.appendChild(info);
                listContainer.appendChild(item);
            });
        }

        renderList(videoList);
        panel.appendChild(listContainer);
        document.body.appendChild(panel);

        // ===================== 时长过滤 =====================
        document.getElementById('filterByDuration').addEventListener('click', () => {
            const maxSec = parseInt(document.getElementById('maxSec').value) || 3600;
            const filtered = currentVideoList.filter(v => {
                const sec = parseDurationToSeconds(v.duration);
                return sec <= maxSec;
            });
            renderList(filtered);
            alert(`过滤完成：保留 ${filtered.length} 个 ≤ ${maxSec} 秒的视频`);
        });

        // ===================== 导出区间 =====================
        document.getElementById('exportRangeBtn').addEventListener('click', () => {
            const start = parseInt(document.getElementById('startNum').value);
            const end = parseInt(document.getElementById('endNum').value);
            const total = currentVideoList.length;
            if (isNaN(start)||isNaN(end)||start<1||end>total||start>end) {
                alert(`范围 1~${total}`);
                return;
            }
            const links = currentVideoList.slice(start-1, end).map(v=>v.url);
            exportLinksToTxt(links, `视频_${start}-${end}.txt`);
        });

        // ===================== 导出选中 =====================
        document.getElementById('exportSelectedBtn').addEventListener('click', () => {
            const checked = listContainer.querySelectorAll('input:checked');
            if (!checked.length) return alert('未选择');
            const links = Array.from(checked).map(c=>c.value);
            const text = links.join('\n');
            navigator.clipboard.writeText(text).then(()=>{}).catch(()=>{});
            exportLinksToTxt(links, `选中_${links.length}个.txt`);
            alert(`已导出 ${links.length} 个链接`);
        });

        // ===================== 打开区间 =====================
        document.getElementById('openRangeBtn').addEventListener('click', () => {
            const start = +document.getElementById('startNum').value;
            const end = +document.getElementById('endNum').value;
            const total = currentVideoList.length;
            if (start<1||end>total||start>end) return alert(`范围 1~${total}`);
            const links = currentVideoList.slice(start-1, end).map(v=>v.url);
            links.forEach(u=>window.open(u, '_blank'));
            alert(`已打开 ${links.length} 个视频`);
            panel.style.display = 'none';
        });

        // 全选
        document.getElementById('selectAllBtn').onclick = () => {
            listContainer.querySelectorAll('input').forEach(c=>c.checked=true);
        };
        // 取消
        document.getElementById('cancelAllBtn').onclick = () => {
            listContainer.querySelectorAll('input').forEach(c=>c.checked=false);
        };
        // 打开选中
        document.getElementById('openSelectedBtn').onclick = () => {
            const arr = Array.from(listContainer.querySelectorAll('input:checked')).map(c=>c.value);
            arr.forEach(u=>window.open(u,'_blank'));
            alert(`打开 ${arr.length} 个`);
            panel.style.display='none';
        };

        return panel;
    }

    // ===================== 提取视频（附带时长） =====================
    function extractVideoInfo() {
        const videoList = [];
        const urlSet = new Set();

        document.querySelectorAll('a').forEach(link => {
            const href = link.href;
            if (!href || !href.startsWith('http') || urlSet.has(href)) return;

            const match = TARGET_VIDEO_LINKS.some(p => href.includes(p));
            if (!match) return;

            // 尝试就近找时长
            let duration = '';
            const maybeTime = link.closest('div,li')?.querySelector('[class*=time],[class*=dur],[class*=length]');
            if (maybeTime) duration = maybeTime.textContent.trim();

            let title = link.textContent.trim() || '视频';
            videoList.push({ title, url: href, duration });
            urlSet.add(href);
        });

        return videoList;
    }

    // ===================== 点击按钮 =====================
    mainBtn.addEventListener('click', () => {
        setTimeout(() => {
            const list = extractVideoInfo();
            if (!list.length) return alert('未找到视频');
            const p = createVideoPanel(list);
            p.style.display = p.style.display === 'none' ? 'block' : 'none';
        }, 500);
    });

})();