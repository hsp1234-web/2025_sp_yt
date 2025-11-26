#!/bin/bash
# WSL 環境啟動腳本

echo "========================================="
echo "  YouTube Downloader - WSL 啟動腳本"
echo "========================================="
echo ""

# 顯示系統資訊
echo "[資訊] 系統版本："
uname -a
echo ""

# 顯示 Python 版本
echo "[資訊] Python 版本："
python3 --version
echo ""

# 顯示當前目錄
echo "[資訊] 當前目錄："
pwd
echo ""

# 檢查 pip 是否安裝
if ! command -v pip3 &> /dev/null; then
    echo "[1/5] 正在安裝 pip..."
    sudo apt update
    sudo apt install -y python3-pip
else
    echo "[1/5] ✓ pip 已安裝"
fi

# 安裝 uv
if ! command -v uv &> /dev/null; then
    echo "[2/5] 正在安裝 uv..."
    pip3 install uv
else
    echo "[2/5] ✓ uv 已安裝"
fi

# 建立虛擬環境
if [ ! -d ".venv" ]; then
    echo "[3/5] 正在建立虛擬環境..."
    python3 -m uv venv .venv
else
    echo "[3/5] ✓ 虛擬環境已存在"
fi

# 啟動虛擬環境並安裝依賴
echo "[4/5] 正在安裝依賴套件..."
source .venv/bin/activate
python3 -m uv pip install -r requirements/core.txt
python3 -m uv pip install -r requirements/downloader.txt
python3 -m uv pip install -r requirements/analysis.txt

# 啟動服務
echo "[5/5] 正在啟動服務..."
echo ""
echo "========================================="
python3 src/core/orchestrator_lite.py
