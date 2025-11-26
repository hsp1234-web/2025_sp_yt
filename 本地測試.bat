@echo off
chcp 65001 >nul
title YouTube Downloader - 本地測試環境
color 0B

echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║                                                            ║
echo ║        YouTube Downloader - 本地測試啟動器                ║
echo ║                                                            ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

REM 步驟 1: 檢查 Python
echo [步驟 1/5] 檢查 Python 環境...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 錯誤：未找到 Python，請先安裝 Python 3.8+
    pause
    exit /b 1
)
python --version
echo ✅ Python 已安裝
echo.

REM 步驟 2: 安裝/檢查 uv
echo [步驟 2/5] 檢查 uv 套件管理器...
python -m uv --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 正在安裝 uv...
    python -m pip install -q uv
    echo ✅ uv 安裝完成
) else (
    echo ✅ uv 已安裝
)
echo.

REM 步驟 3: 建立虛擬環境
echo [步驟 3/5] 準備虛擬環境...
if not exist ".venv" (
    echo 正在建立虛擬環境...
    python -m uv venv .venv
    echo ✅ 虛擬環境建立完成
) else (
    echo ✅ 虛擬環境已存在
)
echo.

REM 步驟 4: 安裝依賴
echo [步驟 4/5] 安裝依賴套件...
echo 這可能需要幾分鐘，請稍候...
call .venv\Scripts\activate.bat

echo   - 安裝核心依賴...
python -m uv pip install -q -r requirements/core.txt
echo   - 安裝下載器依賴...
python -m uv pip install -q -r requirements/downloader.txt
echo   - 安裝分析功能依賴...
python -m uv pip install -q -r requirements/analysis.txt
echo ✅ 所有依賴安裝完成
echo.

REM 步驟 5: 啟動服務
echo [步驟 5/5] 啟動服務...
echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║  服務啟動中...                                             ║
echo ║  啟動後請在瀏覽器開啟: http://127.0.0.1:8000               ║
echo ║  按 Ctrl+C 可停止服務                                      ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

python src\core\orchestrator_lite.py

echo.
echo 服務已停止。
pause
