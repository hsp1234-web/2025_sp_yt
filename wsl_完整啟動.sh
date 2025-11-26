#!/bin/bash
# YouTube Downloader - WSL 完整啟動腳本

set -e  # 遇到錯誤立即停止

echo "════════════════════════════════════════════════════════════"
echo "          YouTube Downloader - WSL 啟動流程"
echo "════════════════════════════════════════════════════════════"
echo ""

# 切換到專案目錄
cd /mnt/c/SP_DOC/YouTube_download

# 步驟 1: 檢查 Python
echo "[步驟 1/5] 檢查 Python 環境..."
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 未安裝，正在安裝..."
    sudo apt update
    sudo apt install -y python3 python3-pip python3-venv
fi
python3 --version
echo "✅ Python 已安裝"
echo ""

# 步驟 2: 建立虛擬環境
echo "[步驟 2/5] 準備虛擬環境..."
if [ ! -d ".venv" ]; then
    echo "正在建立虛擬環境..."
    python3 -m venv .venv
    echo "✅ 虛擬環境建立完成"
else
    echo "✅ 虛擬環境已存在"
fi
echo ""

# 步驟 3: 啟動虛擬環境
echo "[步驟 3/5] 啟動虛擬環境..."
source .venv/bin/activate
echo "✅ 虛擬環境已啟動"
echo ""

# 步驟 4: 安裝依賴
echo "[步驟 4/5] 安裝依賴套件..."
echo "這可能需要幾分鐘，請稍候..."

pip install --upgrade pip -q

if [ -f "requirements/core.txt" ]; then
    echo "  - 安裝核心依賴..."
    pip install -q -r requirements/core.txt
fi

if [ -f "requirements/downloader.txt" ]; then
    echo "  - 安裝下載器依賴..."
    pip install -q -r requirements/downloader.txt
fi

if [ -f "requirements/analysis.txt" ]; then
    echo "  - 安裝分析功能依賴..."
    pip install -q -r requirements/analysis.txt
fi

echo "✅ 所有依賴安裝完成"
echo ""

# 步驟 5: 啟動服務
echo "[步驟 5/5] 啟動服務..."
echo ""
echo "════════════════════════════════════════════════════════════"
echo "  服務啟動後請在瀏覽器開啟: http://127.0.0.1:8000"
echo "  按 Ctrl+C 可停止服務"
echo "════════════════════════════════════════════════════════════"
echo ""

# 設定 PYTHONPATH
export PYTHONPATH="$(pwd)/src"

# 啟動服務
python3 src/core/orchestrator_lite.py

echo ""
echo "服務已停止。"
