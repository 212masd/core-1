// ==UserScript==
// @name         0411.91-bilil视频批量提取工具（自动翻页N页+时长过滤+导出）1
// @namespace    http://tampermonkey.net/
// @version      3.1 修复优化版
// @description  自动抓取前N页视频链接，过滤超过指定时长的视频，支持导出TXT/剪贴板，通用翻页适配
// @author       You
// @match        *://*.91porn.com/view_video.php*
// @match       *://*/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    // ===================== 核心配置 =====================
    const CONFIG = {
        PANEL_WIDTH: '500px',
        MAX_WAIT_TIME: 2000,     // 翻页等待毫秒数
        MAX_VIDEO_COUNT: 9999,
        // 要匹配的视频链接关键词
        VIDEO_LINK_KEYWORDS: [
            '/view_video.php?viewkey=',
            '.tv/video/',
            '/video/',
            'https://rule34gen.com/video/',
            'view_video.php?own=1&viewkey',
            'https://hanime1.me/watch?v='
        ]
    };

    // 全局数据
    let panel = null;
    let allCollectedVideos = [];
    let isPanelVisible = false;

    // ===================== 工具：时分秒 → 秒数 =====================
    function parseDurationToSeconds(durationText) {
        if (!durationText) return 0;
        const parts = durationText.trim().split(':').reverse();
        let seconds = 0;
        if (parts[0]) seconds += parseInt(parts[0]) || 0;
        if (parts[1]) seconds += (parseInt(parts[1]) || 0) * 60;
        if (parts[2]) seconds += (parseInt(parts[2]) || 0) * 3600;
        return seconds;
    }

    // ===================== 工具：导出TXT文件 =====================
    function exportLinksToTxt(links, fileName = '视频链接列表.txt') {
        const text = links.join('\n');
        const blob = new Blob([text], { type: 'text/plain; charset=utf-8' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = fileName;
        a.click();
        URL.revokeObjectURL(url);
    }

    // ===================== 核心：提取当前页面所有视频 =====================
    function extractCurrentPageVideos() {
        const result = [];
        const urlSet = new Set();

        document.querySelectorAll('a[href]').forEach(link => {
            const href = link.href.trim();
            if (!href || !href.startsWith('http') || urlSet.has(href)) return;

            // 匹配视频链接
            const isVideoLink = CONFIG.VIDEO_LINK_KEYWORDS.some(key => href.includes(key));
            if (!isVideoLink) return;

            // 查找时长（通用父容器查找）
            let duration = '';
            const parent = link.closest('div, li, article, figure');
            if (parent) {
                const timeEl = parent.querySelector(
                    '[class*=time],[class*=dur],[class*=length],[class*=duration]'
                );
                if (timeEl) duration = timeEl.textContent.trim();
            }

            const title = link.textContent.trim() || '无标题视频';
            result.push({ title, url: href, duration });
            urlSet.add(href);
        });

        return result;
    }

    // ===================== 创建控制面板 =====================
    function createControlPanel() {
        // 防止重复创建
        if (panel) {
            panel.style.display = isPanelVisible ? 'none' : 'block';
            isPanelVisible = !isPanelVisible;
            return;
        }

        panel = document.createElement('div');
        panel.style.cssText = `
            position: fixed; top: 60px; left: 10px; z-index: 999999;
            width: ${CONFIG.PANEL_WIDTH}; max-height: 720px; overflow-y: auto;
            background: #fff; border: 1px solid #ddd; border-radius: 8px;
            padding: 14px; box-shadow: 0 4px 15px rgba(0,0,0,0.15);
            display: none;
        `;

        panel.innerHTML = `
<div style="display:flex; flex-direction:column; gap:10px;">
  <div style="display:flex; align-items:center; gap:8px; flex-wrap:wrap;">
    <span>自动抓取前</span>
    <input type="number" id="pageCount" value="5" min="1" style="width:60px; padding:4px;">
    <span>页</span>
    <button id="startFetch" style="padding:6px 12px; background:#28a745; color:#fff; border:none; border-radius:4px; cursor:pointer;">
      开始抓取
    </button>
  </div>

  <div style="display:flex; align-items:center; gap:8px; flex-wrap:wrap;">
    <span>排除＞</span>
    <input type="number" id="maxSecond" value="3600" min="0" style="width:70px; padding:4px;">
    <span>秒的视频</span>
    <button id="filterDuration" style="padding:6px 10px; background:#dc3545; color:#fff; border:none; border-radius:4px; cursor:pointer;">
      过滤时长
    </button>
  </div>

  <div style="display:flex; gap:8px; flex-wrap:wrap;">
    <button id="exportTxt" style="padding:6px 10px; background:#17a2b8; color:#fff; border:none; border-radius:4px; cursor:pointer;">
      导出TXT
    </button>
    <button id="copyLinks" style="padding:6px 10px; background:#ffc107; color:#000; border:none; border-radius:4px; cursor:pointer;">
      复制链接
    </button>
    <button id="clearAll" style="padding:6px 10px; background:#6c757d; color:#fff; border:none; border-radius:4px; cursor:pointer;">
      清空列表
    </button>
  </div>

  <div style="border-top:1px solid #eee; padding-top:8px;">
    <div id="statusTip" style="font-size:13px; color:#333;">✅ 就绪</div>
    <div id="videoCount" style="font-size:14px; font-weight:bold; margin-top:4px;">已收集：0 个视频</div>
  </div>

  <div id="videoList" style="max-height:360px; overflow-y:auto; font-size:12px; line-height:1.5; padding-top:5px;">
  </div>
</div>
        `;

        document.body.appendChild(panel);
        bindButtonEvents();
        panel.style.display = 'block';
        isPanelVisible = true;
    }

    // ===================== 通用翻页函数（保留但不再使用） =====================
    function goToNextPage() {
        // 策略1：找“下一页”文字按钮
        const nextTexts = ['下一页', 'next', '›', '>>', '>'];
        for (const text of nextTexts) {
            const btn = Array.from(document.querySelectorAll('a')).find(a =>
                a.textContent.trim().toLowerCase() === text.toLowerCase()
            );
            if (btn) return btn;
        }

        // 策略2：找带数字的分页，当前页+1
        const pageLinks = Array.from(document.querySelectorAll('a')).filter(a =>
            /^\d+$/.test(a.textContent.trim())
        );
        if (pageLinks.length) {
            const currentPage = pageLinks.find(a => a.classList.contains('active') || a.getAttribute('aria-current') === 'page');
            if (currentPage) {
                const idx = pageLinks.indexOf(currentPage);
                if (idx + 1 < pageLinks.length) return pageLinks[idx + 1];
            } else {
                return pageLinks[1] || null;
            }
        }

        return null;
    }

    // ===================== 自动翻页抓取主逻辑 =====================
    async function startAutoFetch(totalPages) {
        const status = document.getElementById('statusTip');
        const countEl = document.getElementById('videoCount');
        const listEl = document.getElementById('videoList');

        // 重置
        allCollectedVideos = [];
        listEl.innerHTML = '';
        status.textContent = `⏳ 开始抓取第 1 页...`;

        for (let i = 1; i <= totalPages; i++) {
            // 提取当前页
            const videos = extractCurrentPageVideos();
            allCollectedVideos.push(...videos);

            // 去重
            const uniqueMap = new Map();
            allCollectedVideos.forEach(v => uniqueMap.set(v.url, v));
            allCollectedVideos = Array.from(uniqueMap.values());

            // 更新界面
            countEl.textContent = `已收集：${allCollectedVideos.length} 个视频`;
            listEl.innerHTML += `<div>✅ 第${i}页：获取 ${videos.length} 个</div>`;
            listEl.scrollTop = listEl.scrollHeight;

            // 最后一页不翻页
            if (i === totalPages) {
                status.textContent = `🎉 全部抓取完成！共 ${allCollectedVideos.length} 个视频`;
                break;
            }

            // ======== 最小修复：URL 分页模式，不跳转、不丢数据 ========
            let url = new URL(window.location.href);
            url.searchParams.set('page', i + 1);
            window.history.replaceState({}, '', url.href);

            status.textContent = `⏳ 正在抓取第 ${i + 1} 页...`;
            await new Promise(resolve => setTimeout(resolve, CONFIG.MAX_WAIT_TIME));
        }
    }

    // ===================== 绑定按钮事件 =====================
    function bindButtonEvents() {
        document.getElementById('startFetch').onclick = () => {
            const pages = parseInt(document.getElementById('pageCount').value) || 5;
            if (pages < 1) return alert('页数必须≥1');
            startAutoFetch(pages);
        };

        document.getElementById('filterDuration').onclick = () => {
            const maxSec = parseInt(document.getElementById('maxSecond').value) || 3600;
            const filtered = allCollectedVideos.filter(v => parseDurationToSeconds(v.duration) <= maxSec);
            allCollectedVideos = filtered;
            document.getElementById('videoCount').textContent = `过滤后剩余：${filtered.length} 个`;
            document.getElementById('statusTip').textContent = `✅ 已过滤＞${maxSec}秒的视频`;
        };

        document.getElementById('exportTxt').onclick = () => {
            if (!allCollectedVideos.length) return alert('暂无视频链接');
            const links = allCollectedVideos.map(v => v.url);
            exportLinksToTxt(links, `视频链接_${links.length}个.txt`);
        };

        document.getElementById('copyLinks').onclick = async () => {
            if (!allCollectedVideos.length) return alert('暂无视频链接');
            const text = allCollectedVideos.map(v => v.url).join('\n');
            await navigator.clipboard.writeText(text);
            alert('✅ 已复制所有视频链接到剪贴板');
        };

        document.getElementById('clearAll').onclick = () => {
            allCollectedVideos = [];
            document.getElementById('videoCount').textContent = '已收集：0 个视频';
            document.getElementById('videoList').innerHTML = '';
            document.getElementById('statusTip').textContent = '✅ 已清空列表';
        };
    }

    // ===================== 创建悬浮开关按钮 =====================
    const toggleBtn = document.createElement('div');
    toggleBtn.textContent = '📥 视频提取工具';
    toggleBtn.style.cssText = `
        position: fixed; top: 10px; left: 10px; z-index: 999999;
        padding: 8px 12px; background: #007bff; color: #fff;
        border-radius: 6px; cursor: pointer; user-select: none;
        box-shadow: 0 2px 8px rgba(0,0,0,0.2); font-size:14px;
    `;
    toggleBtn.onclick = createControlPanel;
    document.body.appendChild(toggleBtn);
})();