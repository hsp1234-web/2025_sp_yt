#!/usr/bin/env python3
"""
開發日誌建立工具

自動建立符合規範的開發日誌檔案。

使用方式：
    python scripts/create_log.py "簡短描述"
    python scripts/create_log.py "功能新增" --author "Claude"
"""

import argparse
import os
from datetime import datetime
from pathlib import Path
import re


def sanitize_filename(text: str) -> str:
    """將文字轉換為安全的檔名格式"""
    # 移除或替換不安全的字元
    safe_text = re.sub(r'[<>:"/\\|?*]', '', text)
    # 將空格替換為底線
    safe_text = safe_text.replace(' ', '_')
    # 限制長度
    return safe_text[:50]


def create_log(description: str, author: str = "AI Agent") -> Path:
    """
    建立開發日誌檔案
    
    Args:
        description: 日誌的簡短描述
        author: 作者名稱
        
    Returns:
        建立的日誌檔案路徑
    """
    # 取得目前時間（台北時區 UTC+8）
    now = datetime.now()
    
    # 建立目錄路徑
    year_month = now.strftime("%Y-%m")
    logs_dir = Path(__file__).parent.parent / "docs" / "logs" / year_month
    logs_dir.mkdir(parents=True, exist_ok=True)
    
    # 建立檔名
    date_str = now.strftime("%Y-%m-%d")
    time_str = now.strftime("%H-%M")
    safe_desc = sanitize_filename(description)
    filename = f"{date_str}_{time_str}_{safe_desc}.md"
    
    filepath = logs_dir / filename
    
    # 日誌內容範本
    content = f"""# {description}

- **日期**：{now.strftime("%Y-%m-%d %H:%M")} (CST, UTC+8)
- **作者**：{author}

## 摘要

[請在此填寫本次工作的目標與成果摘要]

## 主要變更

1. [變更項目 1]
2. [變更項目 2]
3. [變更項目 3]

## 詳細說明

[詳細的技術說明或步驟]

## 驗證結果

- [ ] 測試項目 1
- [ ] 測試項目 2

## 注意事項

[任何需要後續處理或注意的事項]

## 相關檔案

- `file1.py`
- `file2.md`
"""
    
    # 寫入檔案
    filepath.write_text(content, encoding="utf-8")
    
    return filepath


def main():
    parser = argparse.ArgumentParser(
        description="建立開發日誌檔案",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
範例：
    python scripts/create_log.py "新增下載功能"
    python scripts/create_log.py "修復轉錄錯誤" --author "Claude"
        """
    )
    parser.add_argument(
        "description",
        help="日誌的簡短描述"
    )
    parser.add_argument(
        "--author", "-a",
        default="AI Agent",
        help="作者名稱（預設：AI Agent）"
    )
    
    args = parser.parse_args()
    
    filepath = create_log(args.description, args.author)
    print(f"✅ 日誌已建立：{filepath}")
    print(f"📝 請編輯此檔案填入詳細內容")


if __name__ == "__main__":
    main()

