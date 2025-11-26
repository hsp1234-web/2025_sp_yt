@echo off
chcp 65001 >nul
cls
color 0B

echo.
echo ════════════════════════════════════════════════════════════
echo          YouTube Downloader - 正確啟動方式
echo ════════════════════════════════════════════════════════════
echo.

REM 步驟 1: 建立虛擬環境
if not exist ".venv" (
    echo [1/4] 建立虛擬環境...
    python -m venv .venv
    if %errorlevel% neq 0 (
        echo ❌ 建立虛擬環境失敗
        pause
        exit /b 1
    )
    echo ✅ 虛擬環境建立完成
) else (
    echo [1/4] ✅ 虛擬環境已存在
)
echo.

REM 步驟 2: 啟動虛擬環境
echo [2/4] 啟動虛擬環境...
call .venv\Scripts\activate.bat
echo ✅ 虛擬環境已啟動
echo.

REM 步驟 3: 安裝依賴
echo [3/4] 安裝依賴套件（這可能需要幾分鐘）...
python -m pip install --upgrade pip -q
python -m pip install -q fastapi uvicorn httpx pydantic python-dotenv yt-dlp google-generativeai
if %errorlevel% neq 0 (
    echo ❌ 依賴安裝失敗
    pause
    exit /b 1
)
echo ✅ 依賴安裝完成
echo.

REM 步驟 4: 啟動服務
echo [4/4] 啟動服務...
echo.
echo ════════════════════════════════════════════════════════════
echo   服務啟動後請在瀏覽器開啟: http://127.0.0.1:8000
echo   按 Ctrl+C 可停止服務
echo ════════════════════════════════════════════════════════════
echo.

python src\core\orchestrator_lite.py

echo.
echo 服務已停止。
pause
