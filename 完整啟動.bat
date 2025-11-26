@echo off
chcp 65001 >nul
cls
color 0A

echo.
echo ════════════════════════════════════════════════════════════
echo          YouTube Downloader - 完整啟動流程
echo ════════════════════════════════════════════════════════════
echo.

REM 步驟 1: 檢查 Python
echo [步驟 1/5] 檢查 Python 環境...
python --version 2>nul
if %errorlevel% neq 0 (
    echo ❌ 錯誤：未找到 Python
    echo 請先安裝 Python 3.8 或更高版本
    pause
    exit /b 1
)
for /f "tokens=*" %%i in ('python --version') do echo ✅ %%i
echo.

REM 步驟 2: 建立並啟動虛擬環境
echo [步驟 2/5] 準備虛擬環境...
if not exist ".venv" (
    echo 正在建立虛擬環境...
    python -m venv .venv
    if %errorlevel% neq 0 (
        echo ❌ 建立虛擬環境失敗
        pause
        exit /b 1
    )
    echo ✅ 虛擬環境建立完成
) else (
    echo ✅ 虛擬環境已存在
)

echo 啟動虛擬環境...
call .venv\Scripts\activate.bat
echo ✅ 虛擬環境已啟動
echo.

REM 步驟 3: 升級 pip
echo [步驟 3/5] 升級 pip...
python -m pip install --upgrade pip -q
echo ✅ pip 已升級
echo.

REM 步驟 4: 安裝依賴
echo [步驟 4/5] 安裝依賴套件...
echo 這可能需要幾分鐘，請稍候...

if exist "requirements\core.txt" (
    echo   - 安裝核心依賴...
    python -m pip install -q -r requirements\core.txt
    if %errorlevel% neq 0 (
        echo ❌ 核心依賴安裝失敗
        pause
        exit /b 1
    )
)

if exist "requirements\downloader.txt" (
    echo   - 安裝下載器依賴...
    python -m pip install -q -r requirements\downloader.txt
    if %errorlevel% neq 0 (
        echo ❌ 下載器依賴安裝失敗
        pause
        exit /b 1
    )
)

if exist "requirements\analysis.txt" (
    echo   - 安裝分析功能依賴...
    python -m pip install -q -r requirements\analysis.txt
    if %errorlevel% neq 0 (
        echo ❌ 分析功能依賴安裝失敗
        pause
        exit /b 1
    )
)

echo ✅ 所有依賴安裝完成
echo.

REM 步驟 5: 檢查啟動腳本
echo [步驟 5/5] 檢查啟動腳本...
if not exist "src\core\orchestrator_lite.py" (
    echo ❌ 找不到啟動腳本: src\core\orchestrator_lite.py
    echo 請確認專案結構是否完整
    pause
    exit /b 1
)
echo ✅ 啟動腳本存在
echo.

REM 啟動服務
echo ════════════════════════════════════════════════════════════
echo   準備啟動服務...
echo   啟動後請在瀏覽器開啟: http://127.0.0.1:8000
echo   
echo   ⚠️  請保持此視窗開啟！關閉視窗會停止服務。
echo   按 Ctrl+C 可停止服務
echo ════════════════════════════════════════════════════════════
echo.

REM 設定 PYTHONPATH
set PYTHONPATH=%CD%\src

REM 啟動服務
python src\core\orchestrator_lite.py

echo.
echo 服務已停止。
pause
