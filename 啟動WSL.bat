@echo off
chcp 65001 >nul
echo ========================================
echo   啟動 WSL 環境
echo ========================================
echo.
echo 正在進入 WSL 並啟動服務...
echo.

wsl bash -c "cd /mnt/c/SP_DOC/YouTube_download && bash start_wsl.sh"

pause
