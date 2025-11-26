@echo off
chcp 65001 >nul
title YouTube Downloader - 服務運行中
color 0A

echo ========================================
echo   YouTube Downloader 啟動中...
echo ========================================
echo.

REM 保持 WSL 視窗開啟並運行服務
echo 正在啟動服務（此視窗將保持開啟）...
echo 請勿關閉此視窗！
echo.
echo 啟動後請在瀏覽器開啟: http://127.0.0.1:8000
echo.
echo 按 Ctrl+C 可停止服務
echo ========================================
echo.

REM 使用 wsl 執行並保持視窗開啟
wsl bash -c "cd /mnt/c/SP_DOC/YouTube_download && python3 src/core/orchestrator_lite.py; exec bash"

pause
