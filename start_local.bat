@echo off
chcp 65001 >nul
echo ========================================
echo   YouTube Downloader - 本地啟動腳本
echo ========================================
echo.

REM 檢查 uv 是否已安裝
python -m uv --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [1/4] 正在安裝 uv 套件管理器...
    python -m pip install uv
) else (
    echo [1/4] ✓ uv 已安裝
)

REM 建立虛擬環境
if not exist ".venv" (
    echo [2/4] 正在建立虛擬環境...
    python -m uv venv .venv
) else (
    echo [2/4] ✓ 虛擬環境已存在
)

REM 啟動虛擬環境並安裝依賴
echo [3/4] 正在安裝依賴套件...
call .venv\Scripts\activate.bat
python -m uv pip install -r requirements/core.txt
python -m uv pip install -r requirements/downloader.txt
python -m uv pip install -r requirements/analysis.txt

REM 啟動服務
echo [4/4] 正在啟動服務...
echo.
echo ========================================
python src/core/orchestrator_lite.py
