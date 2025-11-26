# WSL 啟動指南

## ✅ 好消息

您的 WSL 已經安裝並可以正常運作！我已經為您建立了 WSL 專用的啟動腳本。

## 🚀 啟動方式

### 方法 1：從 PowerShell 啟動（推薦）

在 PowerShell 中執行：
```powershell
wsl bash /mnt/c/SP_DOC/YouTube_download/start_wsl.sh
```

### 方法 2：進入 WSL 後啟動

1. 開啟 WSL：
   ```powershell
   wsl
   ```

2. 切換到專案目錄：
   ```bash
   cd /mnt/c/SP_DOC/YouTube_download
   ```

3. 執行啟動腳本：
   ```bash
   bash start_wsl.sh
   ```

## 📋 腳本功能

`start_wsl.sh` 會自動：
1. 顯示系統資訊（Linux 版本、Python 版本）
2. 安裝 pip（如果尚未安裝）
3. 安裝 uv 套件管理器
4. 建立虛擬環境 `.venv`
5. 安裝所有依賴套件
6. 啟動 Lite Orchestrator

## 🌐 啟動後

服務啟動後，您會看到類似以下的訊息：
```
✅ 資料庫管理器已就緒 (Port: 50001)
✅ API 伺服器已就緒 (Port: 8000)
==================================================
🎉 系統啟動完成！請在瀏覽器中開啟以下網址：
👉 http://127.0.0.1:8000
==================================================
```

在 Windows 瀏覽器中開啟顯示的網址即可使用。

## ⏹️ 停止服務

在終端按 `Ctrl+C` 即可停止服務。
