import os
from fastapi import APIRouter, Request
from fastapi.responses import HTMLResponse, FileResponse, RedirectResponse
from fastapi.templating import Jinja2Templates
from pathlib import Path

# --- 路徑與樣板設定 ---
SRC_DIR = Path(__file__).resolve().parent.parent.parent
STATIC_DIR = str(SRC_DIR / "static")
templates = Jinja2Templates(directory=STATIC_DIR)
router = APIRouter()

# --- UI 頁面路由 ---

@router.get("/menu", response_class=HTMLResponse)
async def serve_menu(request: Request):
    return templates.TemplateResponse("menu.html", {"request": request})

@router.get("/page6", response_class=HTMLResponse)
async def serve_page6(request: Request):
    return templates.TemplateResponse("page6_keys.html", {"request": request})

@router.get("/report/{file_id}", response_class=HTMLResponse)
async def serve_report_viewer(request: Request, file_id: int):
    """
    提供新的報告檢視器頁面。
    我們將 file_id 傳遞給模板，雖然模板本身不直接使用它，
    但前端的 JavaScript 可以從 URL 中讀取它。
    """
    return templates.TemplateResponse("report_viewer.html", {"request": request, "file_id": file_id})

# --- 音訊報告生成器 (Audio Report Generator) 路由 ---

@router.get("/audio_report/main", response_class=HTMLResponse)
async def serve_audio_report_main(request: Request):
    """提供音訊報告生成器 - 主頁"""
    return templates.TemplateResponse("audio_report_0_main.html", {"request": request})

@router.get("/audio_report/source", response_class=HTMLResponse)
async def serve_audio_report_source(request: Request):
    """提供音訊報告生成器 - 步驟1：來源管理"""
    return templates.TemplateResponse("audio_report_1_source.html", {"request": request})

@router.get("/audio_report/process", response_class=HTMLResponse)
async def serve_audio_report_process(request: Request):
    """提供音訊報告生成器 - 步驟2：分析與處理"""
    return templates.TemplateResponse("audio_report_2_process.html", {"request": request})

@router.get("/audio_report/results", response_class=HTMLResponse)
async def serve_audio_report_results(request: Request):
    """提供音訊報告生成器 - 結果瀏覽"""
    return templates.TemplateResponse("audio_report_3_results.html", {"request": request})

@router.get("/youtube_pro", response_class=HTMLResponse)
async def serve_youtube_pro(request: Request):
    """提供 YouTube Downloader Pro - 整合介面"""
    return templates.TemplateResponse("youtube_pro.html", {"request": request})