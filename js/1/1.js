// ==UserScript==
// @name         视频批量后台打开工具（区间选择+链接导出版）
// @namespace    http://tampermonkey.net/
// @version      2.7
// @description  支持选择第X到第Y个视频打开，同时可导出选中/区间链接为TXT文档
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
    const PANEL_WIDTH = '450px';
    const MAX_VIDEO_DISPLAY = 50;
    const TARGET_VIDEO_LINKS = [
        '/view_video.php?viewkey=',
        '.tv/video/',
        '/video/',
        'https://rule34gen.com/video/',
        'view_video.php?own=1&viewkey',
        'https://hanime1.me/watch?v='
    ]; // 修复：删除了末尾多余的`

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

    // ===================== 工具函数：导出链接为TXT文档 =====================
    function exportLinksToTxt(links, fileName = '视频链接列表.txt') {
        // 拼接链接（一行一个）
        const linkText = links.join('\n');
        // 创建Blob对象
        const blob = new Blob([linkText], { type: 'text/plain; charset=utf-8' });
        // 创建下载链接
        const downloadLink = document.createElement('a');
        downloadLink.href = URL.createObjectURL(blob);
        downloadLink.download = fileName;
        // 触发下载
        downloadLink.click();
        // 释放URL
        URL.revokeObjectURL(downloadLink.href);
    }

    // ===================== 创建视频选择面板（新增导出按钮） =====================
    let panel = null;
    let currentVideoList = []; // 存储当前页面的视频列表，供导出使用
    function createVideoPanel(videoList) {
        currentVideoList = videoList; // 缓存视频列表
        // 销毁已存在的面板
        if (panel) panel.remove();

        // 创建面板容器
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

        // 面板标题 + 操作按钮（新增导出按钮）
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
            <div style="display:flex; gap:6px; align-items:center; flex-wrap: wrap;">
                <span style="font-size: 12px; color: #666;">区间选择：</span>
                <input type="number" id="startNum" min="1" value="1" style="width:60px; padding:4px; font-size: 12px; border: 1px solid #ddd; border-radius: 4px;">
                <span style="font-size: 12px;">~</span>
                <input type="number" id="endNum" min="1" value="${Math.min(20, videoList.length)}" style="width:60px; padding:4px; font-size: 12px; border: 1px solid #ddd; border-radius: 4px;">
                <button id="openRangeBtn" style="padding:4px 10px; font-size: 12px; background:#28a745; color:#fff; border:none; border-radius:4px; cursor:pointer;">打开区间</button>
                <button id="exportRangeBtn" style="padding:4px 10px; font-size: 12px; background:#17a2b8; color:#fff; border:none; border-radius:4px; cursor:pointer;">导出区间链接</button>
            </div>
            <div style="display:flex; gap:6px;">
                <button id="selectAllBtn" style="padding:4px 8px; font-size: 12px; cursor: pointer;">全选</button>
                <button id="cancelAllBtn" style="padding:4px 8px; font-size: 12px; cursor: pointer;">取消全选</button>
                <button id="openSelectedBtn" style="padding:4px 12px; font-size: 12px; background: #007bff; color: #fff; border: none; border-radius: 4px; cursor: pointer;">打开选中</button>
                <button id="exportSelectedBtn" style="padding:4px 12px; font-size: 12px; background: #ffc107; color: #333; border: none; border-radius: 4px; cursor: pointer;">导出选中链接</button>
            </div>
        `;
        panel.appendChild(header);

        // 视频列表容器
        const listContainer = document.createElement('div');
        listContainer.style.cssText = `
            display: flex;
            flex-direction: column;
            gap: 8px;
        `;

        // 生成视频列表项
        videoList.slice(0, MAX_VIDEO_DISPLAY).forEach((video, index) => {
            const item = document.createElement('div');
            item.style.cssText = `
                display: flex;
                align-items: flex-start;
                padding: 8px;
                border-radius: 4px;
                transition: background 0.1s;
            `;
            item.onmouseover = () => item.style.background = '#f9fafb';
            item.onmouseout = () => item.style.background = 'transparent';

            // 复选框
            const checkbox = document.createElement('input');
            checkbox.type = 'checkbox';
            checkbox.id = `video_${index}`;
            checkbox.value = video.url;
            checkbox.style.marginRight = '8px';
            checkbox.style.marginTop = '2px';
            checkbox.dataset.index = index;

            // 视频信息
            const info = document.createElement('div');
            info.style.cssText = `
                flex: 1;
                font-size: 13px;
                color: #333;
            `;
            const displayTitle = video.title.length > 35
                ? `${video.title.substring(0, 35)}...`
                : video.title;
            info.innerHTML = `
                <div style="font-weight: 500; margin-bottom: 4px; color: #222;">【${index+1}】${displayTitle}</div>
                <div style="font-size: 11px; color: #666; word-break: break-all; opacity: 0.8;">${video.url.substring(0, 50)}${video.url.length > 50 ? '...' : ''}</div>
            `;

            item.appendChild(checkbox);
            item.appendChild(info);
            listContainer.appendChild(item);
        });

        panel.appendChild(listContainer);
        document.body.appendChild(panel);

        // ===================== 新增：导出区间链接 =====================
        document.getElementById('exportRangeBtn').addEventListener('click', () => {
            const start = parseInt(document.getElementById('startNum').value);
            const end = parseInt(document.getElementById('endNum').value);
            const total = videoList.length;

            // 校验输入
            if (isNaN(start) || isNaN(end) || start < 1 || end > total || start > end) {
                alert(`请输入有效范围：1 ~ ${total}`);
                return;
            }

            // 提取区间内的链接
            const rangeLinks = videoList.slice(start - 1, end).map(video => video.url);
            // 导出为TXT
            exportLinksToTxt(rangeLinks, `视频链接_第${start}到${end}个.txt`);
            alert(`已导出第 ${start} ~ ${end} 个视频链接，共 ${rangeLinks.length} 条！`);
        });

        // ===================== 新增：导出选中链接 =====================
       document.getElementById('exportSelectedBtn').addEventListener('click', () => {
    const selectedCheckboxes = listContainer.querySelectorAll('input[type="checkbox"]:checked');
    if (selectedCheckboxes.length === 0) {
        alert('请至少选择一个视频！');
        return;
    }

    // 提取选中的链接
    const selectedLinks = Array.from(selectedCheckboxes).map(cb => cb.value);

    // ========== 新增：复制选中链接到剪贴板 ==========
    // 链接换行分隔（方便粘贴到IDM/迅雷等工具）
    const linksText = selectedLinks.join('\n');
    // 复制到剪贴板
    navigator.clipboard.writeText(linksText)
        .then(() => {
            console.log('选中的链接已复制到剪贴板！');
        })
        .catch(err => {
            console.error('复制剪贴板失败：', err);
            alert('复制到剪贴板失败，请手动导出TXT！');
        });

    // 原有功能：导出为TXT（完全保留，不修改）
    exportLinksToTxt(selectedLinks, `视频链接_选中${selectedLinks.length}个.txt`);
    alert(`已导出 ${selectedLinks.length} 个选中的视频链接！\n✅ 同时已复制链接到剪贴板`);
});

        // ===================== 区间打开视频 =====================
        document.getElementById('openRangeBtn').addEventListener('click', () => {
            const start = parseInt(document.getElementById('startNum').value);
            const end = parseInt(document.getElementById('endNum').value);
            const total = videoList.length;

            if (isNaN(start) || isNaN(end) || start < 1 || end > total || start > end) {
                alert(`请输入有效范围：1 ~ ${total}`);
                return;
            }

            // 选中区间内的复选框
            const allCheckboxes = listContainer.querySelectorAll('input[type="checkbox"]');
            allCheckboxes.forEach((cb, index) => {
                cb.checked = (index + 1 >= start && index + 1 <= end);
            });

            // 后台打开区间内的视频
            const selectedCheckboxes = listContainer.querySelectorAll('input[type="checkbox"]:checked');
            let openCount = 0;
            selectedCheckboxes.forEach(cb => {
                window.open(cb.value, '_blank', 'noopener noreferrer');
                openCount++;
            });

            alert(`已在后台打开第 ${start} ~ ${end} 个视频，共 ${openCount} 个！`);
            panel.style.display = 'none';
        });

        // ===================== 原有功能：全选/取消全选/打开选中 =====================
        // 全选
        document.getElementById('selectAllBtn').addEventListener('click', () => {
            const checkboxes = listContainer.querySelectorAll('input[type="checkbox"]');
            checkboxes.forEach(cb => cb.checked = true);
        });

        // 取消全选
        document.getElementById('cancelAllBtn').addEventListener('click', () => {
            const checkboxes = listContainer.querySelectorAll('input[type="checkbox"]');
            checkboxes.forEach(cb => cb.checked = false);
        });

        // 打开选中
        document.getElementById('openSelectedBtn').addEventListener('click', () => {
            const selectedCheckboxes = listContainer.querySelectorAll('input[type="checkbox"]:checked');
            if (selectedCheckboxes.length === 0) {
                alert('请至少选择一个视频！');
                return;
            }

            // 后台打开选中的视频
            selectedCheckboxes.forEach(cb => {
                window.open(cb.value, '_blank', 'noopener noreferrer');
            });

            alert(`已在后台打开 ${selectedCheckboxes.length} 个选中的视频！`);
            panel.style.display = 'none';
        });

        return panel;
    }

    // ===================== 提取页面视频信息 =====================
    function extractVideoInfo() {
        const videoList = [];
        const urlSet = new Set();
        let videoIndex = 1;

        document.querySelectorAll('a').forEach(link => {
            const href = link.href;
            // 跳过无效链接、非http开头、已重复的链接
            if (!href || !href.startsWith('http') || urlSet.has(href)) return;

            // 检查是否包含目标格式
            const isTargetLink = TARGET_VIDEO_LINKS.some(linkStr => href.includes(linkStr));
            if (!isTargetLink) return;

            // 生成视频名称
            let title = link.textContent?.trim() || '';
            if (!title) {
                const viewkeyMatch = href.match(/viewkey=([^&]+)/);
                if (viewkeyMatch) {
                    title = `viewkey_${viewkeyMatch[1]}`;
                } else {
                    const tvVideoMatch = href.match(/\.tv\/video\/([^?&/]+)/);
                    title = tvVideoMatch ? `tv_video_${tvVideoMatch[1]}` : '';
                }
            }
            title = title || `视频_${videoIndex}`;

            videoList.push({ title, url: href });
            urlSet.add(href);
            videoIndex++;
        });

        return videoList;
    }

    // ===================== 绑定主按钮事件 =====================
    mainBtn.addEventListener('click', () => {
        // 延迟500ms，确保动态加载的视频元素被提取
        setTimeout(() => {
            const videoList = extractVideoInfo();
            if (videoList.length === 0) {
                alert('当前页面未检测到/view_video.php?viewkey=或.tv/video/格式的视频链接！');
                return;
            }

            // 创建并显示面板
            const panel = createVideoPanel(videoList);
            panel.style.display = panel.style.display === 'none' ? 'block' : 'none';
        }, 500);
    });

})();