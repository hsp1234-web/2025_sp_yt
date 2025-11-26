import subprocess
import sys
import time
import os
import socket
import logging
import threading
from pathlib import Path

# --- 設定日誌 ---
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[logging.StreamHandler(sys.stdout)]
)
log = logging.getLogger('orchestrator_lite')

# --- 路徑設定 ---
SRC_DIR = Path(__file__).resolve().parent.parent
ROOT_DIR = SRC_DIR.parent
sys.path.insert(0, str(SRC_DIR))

def find_free_port():
    """尋找一個可用的埠號。"""
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind(('', 0))
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        return s.getsockname()[1]

def wait_for_port(port, timeout=30):
    """等待指定埠號開始監聽。"""
    start_time = time.time()
    while time.time() - start_time < timeout:
        try:
            with socket.create_connection(("127.0.0.1", port), timeout=1):
                return True
        except (OSError, ConnectionRefusedError):
            time.sleep(0.5)
    return False

def start_service(name, command, cwd=ROOT_DIR, env=None):
    """啟動一個微服務。"""
    log.info(f"🚀 正在啟動 {name}...")
    if env is None:
        env = os.environ.copy()
    
    # 使用 python -u (unbuffered) 確保日誌即時輸出
    process = subprocess.Popen(
        command,
        cwd=cwd,
        env=env,
        stdout=sys.stdout, # 直接輸出到主控台，方便查看
        stderr=sys.stderr
    )
    return process

def main():
    log.info("=== 🐺 善狼一鍵啟動器 (Lite Mode) 🐺 ===")
    log.info("正在以極速模式啟動核心服務...")

    # 1. 尋找可用埠號
    db_port = find_free_port()
    api_port = find_free_port()

    # 2. 設定環境變數
    env = os.environ.copy()
    env["DB_MANAGER_PORT"] = str(db_port)
    env["API_PORT"] = str(api_port)
    env["PYTHONPATH"] = str(SRC_DIR)

    # 3. 啟動資料庫管理器 (DB Manager)
    db_cmd = [
        sys.executable, "-m", "uvicorn", 
        "src.db.manager:app", 
        "--host", "127.0.0.1", 
        "--port", str(db_port),
        "--log-level", "warning" # 減少日誌雜訊
    ]
    db_process = start_service("資料庫管理器 (DB Manager)", db_cmd, env=env)

    if not wait_for_port(db_port):
        log.error("❌ 資料庫管理器啟動失敗！")
        db_process.terminate()
        sys.exit(1)
    
    log.info(f"✅ 資料庫管理器已就緒 (Port: {db_port})")

    # 4. 啟動主 API 伺服器 (API Server)
    api_cmd = [
        sys.executable, "-m", "uvicorn", 
        "src.api.api_server:app", 
        "--host", "127.0.0.1", 
        "--port", str(api_port),
        "--log-level", "info"
    ]
    api_process = start_service("主 API 伺服器 (API Server)", api_cmd, env=env)

    if not wait_for_port(api_port):
        log.error("❌ API 伺服器啟動失敗！")
        db_process.terminate()
        api_process.terminate()
        sys.exit(1)

    log.info(f"✅ API 伺服器已就緒 (Port: {api_port})")
    
    # 5. 顯示存取資訊
    local_url = f"http://127.0.0.1:{api_port}"
    log.info("="*50)
    log.info(f"🎉 系統啟動完成！請在瀏覽器中開啟以下網址：")
    log.info(f"👉 {local_url}")
    log.info("="*50)

    # 6. 保持運行
    try:
        while True:
            time.sleep(1)
            if db_process.poll() is not None:
                log.error("⚠️ 資料庫管理器意外停止！")
                break
            if api_process.poll() is not None:
                log.error("⚠️ API 伺服器意外停止！")
                break
    except KeyboardInterrupt:
        log.info("正在停止所有服務...")
    finally:
        db_process.terminate()
        api_process.terminate()
        log.info("👋 再見！")

if __name__ == "__main__":
    main()
