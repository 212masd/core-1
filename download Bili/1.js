// ==UserScript==
// @name         0412B站快捷复制链接·播放页增强版
// @namespace    bili-quick-link-pro
// @version      1.0.0
// @description  支持播放页抓取右侧推荐视频，悬浮面板、历史记录、复制全部、导出TXT
// @author       You
// @match        *://*.bilibili.com/*
// @grant        GM_setClipboard
// @grant        GM_setValue
// @grant        GM_getValue
// @grant        GM_addStyle
// @run-at       document-end
// ==/UserScript==

(function () {
  'use strict';

  // ====================== 配置 ======================
  const CONFIG = {
    hotkey: '\\',
    debounce: 300,
    panel: {
      defaultTop: '120px',
      defaultLeft: '20px',
      width: '280px',
      maxListHeight: '300px'
    }
  };

  // ====================== 状态 ======================
  const state = {
    mouseX: 0,
    mouseY: 0,
    isProcessing: false,
    linkList: [],
  };

  // ====================== 正则 ======================
  const REGEX = {
    bv: /(?:video\/|bvid=)(BV[a-zA-Z0-9]+)/i
  };

  // ====================== 初始化 ======================
  function init() {
    loadHistory();
    createPanel();
    bindMouseEvent();
    bindHotkey();
    renderList();
  }

  // ====================== 读取历史 ======================
  function loadHistory() {
    try {
      state.linkList = JSON.parse(GM_getValue('link_list_v2', '[]')) || [];
    } catch {
      state.linkList = [];
    }
  }

  // ====================== 保存历史 ======================
  function saveHistory() {
    GM_setValue('link_list_v2', JSON.stringify(state.linkList));
  }

  // ====================== 创建面板 ======================
  let panel, listWrap, foldBtn;

  function createPanel() {
    // 主容器
    panel = document.createElement('div');
    panel.className = 'bili-quick-panel';
    panel.style.top = GM_getValue('panel_top', CONFIG.panel.defaultTop);
    panel.style.left = GM_getValue('panel_left', CONFIG.panel.defaultLeft);

    // 拖拽栏
    const dragBar = document.createElement('div');
    dragBar.className = 'bili-quick-dragbar';
    dragBar.innerHTML = `<span>链接收集(增强版)</span><span class="fold-btn">−</span>`;
    foldBtn = dragBar.querySelector('.fold-btn');

    // 内容区
    const content = document.createElement('div');
    content.className = 'bili-quick-content';

    // 列表区
    listWrap = document.createElement('div');
    listWrap.className = 'bili-quick-list';

    // 按钮组
    const btnGroup = document.createElement('div');
    btnGroup.className = 'bili-quick-btns';

    const clearBtn = createBtn('清空列表', () => {
      state.linkList = [];
      saveHistory();
      renderList();
      showToast('✅ 已清空列表');
    });

    const copyAllBtn = createBtn('复制全部', () => {
      const text = [...new Set(state.linkList)].join('\n');
      GM_setClipboard(text);
      showToast('✅ 已复制全部链接');
    });

    const exportBtn = createBtn('导出TXT', () => {
      const text = [...new Set(state.linkList)].join('\n');
      const blob = new Blob([text], { type: 'text/plain' });
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `B站链接_${Date.now()}.txt`;
      a.click();
      URL.revokeObjectURL(url);
      showToast('📥 已导出TXT文件');
    });

    btnGroup.append(clearBtn, copyAllBtn, exportBtn);
    content.append(listWrap, btnGroup);
    panel.append(dragBar, content);
    document.body.append(panel);

    // 折叠
    const folded = GM_getValue('panel_folded', false);
    if (folded) {
      content.style.display = 'none';
      foldBtn.textContent = '+';
    }

    foldBtn.addEventListener('click', () => {
      const isHidden = content.style.display === 'none';
      content.style.display = isHidden ? 'block' : 'none';
      foldBtn.textContent = isHidden ? '−' : '+';
      GM_setValue('panel_folded', !isHidden);
    });

    // 拖拽
    makeDraggable(panel, dragBar, (top, left) => {
      GM_setValue('panel_top', top + 'px');
      GM_setValue('panel_left', left + 'px');
    });

    // 样式
    GM_addStyle(`
      .bili-quick-panel{position:fixed;z-index:99999;width:${CONFIG.panel.width};user-select:none;background:#fff;border-radius:10px;box-shadow:0 4px 16px rgba(0,0,0,.2);overflow:hidden;font-size:12px}
      .bili-quick-dragbar{background:#fb7299;color:#fff;padding:8px 12px;font-weight:700;cursor:move;display:flex;justify-content:space-between;align-items:center}
      .bili-quick-content{padding:10px}
      .bili-quick-list{max-height:${CONFIG.panel.maxListHeight};overflow-y:auto;margin-bottom:8px;line-height:1.4}
      .bili-quick-list>div{padding:4px 0;border-bottom:1px solid #eee}
      .bili-quick-btns{display:flex;gap:4px}
      .bili-quick-btns button{flex:1;padding:6px;background:#666;color:#fff;border:none;border-radius:4px;cursor:pointer;font-size:12px}
      .bili-quick-btns button:nth-child(2){background:#00a1d2}
      .bili-quick-btns button:nth-child(3){background:#1e87f0}
      .bili-quick-toast{position:fixed;top:80px;left:50%;transform:translateX(-50%);background:#222;color:#fff;padding:10px 16px;border-radius:6px;z-index:9999999;font-size:14px;animation:fadeIn .2s}
      .bili-quick-toast.error{background:#d82f2f}
      @keyframes fadeIn{from{opacity:0;transform:translate(-50%,-10px)}to{opacity:1;transform:translate(-50%,0)}}
    `);
  }

  function createBtn(text, onClick) {
    const btn = document.createElement('button');
    btn.textContent = text;
    btn.addEventListener('click', onClick);
    return btn;
  }

  // ====================== 渲染列表 ======================
  function renderList() {
    listWrap.innerHTML = '';
    const unique = [...new Set(state.linkList)];
    unique.forEach(link => {
      const item = document.createElement('div');
      item.textContent = link;
      listWrap.append(item);
    });
  }

  // ====================== 鼠标位置 ======================
  function bindMouseEvent() {
    document.addEventListener('mousemove', e => {
      state.mouseX = e.clientX;
      state.mouseY = e.clientY;
    });
  }

  // ====================== 快捷键 ======================
  function bindHotkey() {
    document.addEventListener('keydown', e => {
      if (e.key !== CONFIG.hotkey) return;
      if (state.isProcessing) return;

      const tag = e.target.tagName.toLowerCase();
      if (['input', 'textarea'].includes(tag) || e.target.isContentEditable) return;

      e.preventDefault();
      handleCopy();
    });
  }

  // ====================== 核心复制逻辑 ======================
  async function handleCopy() {
    state.isProcessing = true;
    let bv = null;

    // 优先取鼠标下的视频（推荐视频）
    const els = document.elementsFromPoint(state.mouseX, state.mouseY);
    for (const el of els) {
      const a = el.closest('a[href*="video"]');
      if (a?.href) {
        const m = a.href.match(REGEX.bv);
        if (m?.[1]) {
          bv = m[1];
          break;
        }
      }
    }

    // 找不到再取当前页面
    if (!bv) {
      const m = location.href.match(REGEX.bv);
      if (m?.[1]) bv = m[1];
    }

    if (bv) {
      const link = `https://www.bilibili.com/video/${bv}`;
      if (!state.linkList.includes(link)) {
        state.linkList.unshift(link);
        saveHistory();
        renderList();
      }
      GM_setClipboard(link);
      showToast(`✅ 已复制：${bv}`);
    } else {
      showToast('❌ 未找到视频', true);
    }

    setTimeout(() => {
      state.isProcessing = false;
    }, CONFIG.debounce);
  }

  // ====================== 提示 ======================
  function showToast(msg, isError = false) {
    const toast = document.createElement('div');
    toast.className = 'bili-quick-toast';
    if (isError) toast.classList.add('error');
    toast.textContent = msg;
    document.body.append(toast);
    setTimeout(() => toast.remove(), 1600);
  }

  // ====================== 拖拽 ======================
  function makeDraggable(el, handle, onMove) {
    let pos = { x: 0, y: 0, mx: 0, my: 0 };
    handle.addEventListener('mousedown', e => {
      e.preventDefault();
      pos.mx = e.clientX;
      pos.my = e.clientY;
      document.addEventListener('mousemove', move);
      document.addEventListener('mouseup', up);
    });

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
      document.removeEventListener('mousemove', move);
      document.removeEventListener('mouseup', up);
    }
  }

  // ====================== 启动 ======================
  init();

})();