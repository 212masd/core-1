from __future__ import annotations 

import json 
import time 
import random 
from dataclasses import dataclass 
from pathlib import Path 
from typing import Optional, Tuple, List 

import keyboard 
import pyautogui 
from loguru import logger

# ======================== 全局常量 ======================== 
CONFIG_PATH = Path("./config.json") 
SEARCH_TERM_PATH = Path("./search_list.txt") 
LOG_PATH = Path("./runtime.log") 

# 安全阈值 
pyautogui.FAILSAFE = True  # 左上角强制终止 
pyautogui.PAUSE = 0.1 

# 行为参数 
CLICK_RETRY = 2 
STEP_INTERVAL = 2.0 
JITTER_MIN = 0.1 
JITTER_MAX = 0.3 
MOVE_DURATION = 0.25 

# ======================== 配置模型 ======================== 
@dataclass 
class ClickPoints: 
    input_box: Optional[Tuple[int, int]] = None 
    search_btn: Optional[Tuple[int, int]] = None 
    download_btn: Optional[Tuple[int, int]] = None 

    def is_valid(self) -> bool: 
        return all([ 
            self.input_box is not None, 
            self.search_btn is not None, 
            self.download_btn is not None 
        ]) 

# ======================== 配置管理 ======================== 
class ConfigManager: 
    @staticmethod 
    def load() -> ClickPoints: 
        if not CONFIG_PATH.exists(): 
            logger.warning("配置文件不存在，将创建空配置") 
            return ClickPoints() 
        try: 
            with open(CONFIG_PATH, "r", encoding="utf-8") as f: 
                data = json.load(f) 
            return ClickPoints( 
                input_box=tuple(data.get("input_box")) if data.get("input_box") else None, 
                search_btn=tuple(data.get("search_btn")) if data.get("search_btn") else None, 
                download_btn=tuple(data.get("download_btn")) if data.get("download_btn") else None, 
            ) 
        except Exception as e: 
            logger.error(f"配置文件损坏: {e}") 
            return ClickPoints() 

    @staticmethod 
    def save(points: ClickPoints): 
        data = { 
            "input_box": list(points.input_box) if points.input_box else None, 
            "search_btn": list(points.search_btn) if points.search_btn else None, 
            "download_btn": list(points.download_btn) if points.download_btn else None, 
        } 
        try: 
            with open(CONFIG_PATH, "w", encoding="utf-8") as f: 
                json.dump(data, f, indent=2, ensure_ascii=False) 
            logger.info("坐标已保存至 config.json") 
        except Exception as e: 
            logger.error(f"保存配置失败: {e}") 

# ======================== 搜索词加载 ======================== 
def load_search_terms() -> List[str]: 
    if not SEARCH_TERM_PATH.exists(): 
        logger.error(f"搜索词文件不存在: {SEARCH_TERM_PATH}") 
        return [] 
    try: 
        with open(SEARCH_TERM_PATH, "r", encoding="utf-8") as f: 
            lines = [line.strip() for line in f if line.strip()] 
        logger.info(f"加载搜索词 {len(lines)} 个") 
        return lines 
    except Exception as e: 
        logger.error(f"读取搜索词失败: {e}") 
        return [] 

# ======================== 鼠标操作封装 ======================== 
def safe_move_click(pos: Tuple[int, int], timeout: float = 5.0) -> bool: 
    start = time.time() 
    while time.time() - start < timeout: 
        try: 
            pyautogui.moveTo(*pos, duration=MOVE_DURATION) 
            pyautogui.click() 
            return True 
        except Exception as e: 
            logger.warning(f"点击失败，重试中: {e}") 
            time.sleep(0.5) 
    logger.error(f"点击超时: {pos}") 
    return False 

def safe_input(text: str, timeout: float = 5.0): 
    start = time.time() 
    while time.time() - start < timeout: 
        try: 
            # 先点击输入框确保激活 
            pyautogui.click() 
            time.sleep(0.1) 
            # 全选并删除现有内容 
            pyautogui.hotkey("ctrl", "a") 
            time.sleep(0.1) 
            pyautogui.press("delete") 
            time.sleep(0.1) 
            # 输入新内容 
            pyautogui.typewrite(text, interval=0.02) 
            return 
        except Exception as e: 
            logger.warning(f"输入失败，重试中: {e}") 
            time.sleep(0.5) 
    logger.error("输入文本超时") 

# ======================== 单次任务 ======================== 
def execute_task(term: str, points: ClickPoints): 
    logger.info(f"开始处理: {term}") 

    # 1. 输入框 
    if not safe_move_click(points.input_box): 
        raise RuntimeError("输入框点击失败") 
    # 增加等待时间，确保输入框完全激活 
    time.sleep(STEP_INTERVAL + random.uniform(JITTER_MIN, JITTER_MAX) + 0.5) 
    safe_input(term) 
    time.sleep(STEP_INTERVAL + random.uniform(JITTER_MIN, JITTER_MAX)) 

    # 2. 搜索按钮 
    if not safe_move_click(points.search_btn): 
        raise RuntimeError("搜索按钮点击失败") 
    time.sleep(STEP_INTERVAL + random.uniform(JITTER_MIN, JITTER_MAX)) 

    # 3. 下载按钮 
    if not safe_move_click(points.download_btn): 
        raise RuntimeError("下载按钮点击失败") 
    time.sleep(STEP_INTERVAL + random.uniform(JITTER_MIN, JITTER_MAX)) 

    logger.success(f"处理完成: {term}") 

# ======================== 坐标捕获 ======================== 
def capture_position(name: str) -> Optional[Tuple[int, int]]: 
    logger.info(f"请移动鼠标到【{name}】，按下对应 F 键捕获") 
    key = None 
    if name == "文本框": 
        key = "F1" 
    elif name == "搜索按钮": 
        key = "F2" 
    elif name == "解析下载按钮": 
        key = "F3" 

    if not key: 
        return None 

    keyboard.wait(key, suppress=True) 
    pos = pyautogui.position() 
    logger.info(f"捕获 {name} 坐标: {pos}") 
    time.sleep(0.3) 
    return pos 

# ======================== 主逻辑 ======================== 
def main(): 
    logger.add(LOG_PATH, encoding="utf-8", rotation="10 MB") 
    logger.info("===== 自动化下载工具启动 =====") 
    logger.info("F1=输入框 F2=搜索 F3=下载 F5=启动 ESC=退出") 

    points = ConfigManager.load() 
    running = False 

    while True: 
        if keyboard.is_pressed("esc"): 
            logger.info("用户退出程序") 
            break 

        if keyboard.is_pressed("F1"): 
            points.input_box = capture_position("文本框") 
            ConfigManager.save(points) 
            time.sleep(0.5) 

        elif keyboard.is_pressed("F2"): 
            points.search_btn = capture_position("搜索按钮") 
            ConfigManager.save(points) 
            time.sleep(0.5) 

        elif keyboard.is_pressed("F3"): 
            points.download_btn = capture_position("解析下载按钮") 
            ConfigManager.save(points) 
            time.sleep(0.5) 

        elif keyboard.is_pressed("F6") and not running: 
            if not points.is_valid(): 
                logger.error("未完成全部坐标配置，请先设置 F1/F2/F3") 
                time.sleep(1) 
                continue 

            terms = load_search_terms() 
            if not terms: 
                logger.error("无有效搜索词") 
                time.sleep(1) 
                continue 

            running = True 
            logger.info("===== 开始批量执行 =====") 

            try: 
                for idx, term in enumerate(terms, 1): 
                    if keyboard.is_pressed("esc"): 
                        logger.warning("用户手动中断任务") 
                        break 

                    logger.info(f"===== 第 {idx}/{len(terms)} 项 =====") 
                    try: 
                        execute_task(term, points) 
                    except Exception as e: 
                        logger.error(f"单任务失败: {e}") 
                        logger.info("跳过当前项，继续下一项") 
                        continue 

            except Exception as e: 
                logger.critical(f"任务异常终止: {e}") 
            finally: 
                running = False 
                logger.info("===== 批量任务结束 =====") 
                time.sleep(1) 

        time.sleep(0.05) 

if __name__ == "__main__": 
    main()