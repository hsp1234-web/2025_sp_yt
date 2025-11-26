@echo off
chcp 65001 >nul
cls
color 0B

echo.
echo ════════════════════════════════════════════════════════════
echo          使用 WSL 啟動 YouTube Downloader
echo ════════════════════════════════════════════════════════════
echo.
echo 正在透過 WSL 啟動服務...
echo 請保持此視窗開啟！
echo.

REM 給予腳本執行權限並執行
wsl bash -c "chmod +x /mnt/c/SP_DOC/YouTube_download/wsl_完整啟動.sh && /mnt/c/SP_DOC/YouTube_download/wsl_完整啟動.sh"

echo.
echo 服務已停止。
pause
