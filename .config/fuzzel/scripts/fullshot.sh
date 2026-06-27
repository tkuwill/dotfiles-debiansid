#!/bin/sh
# Description: a script which can take a screenshot of full screen.
# 🎯 專屬 Debian 全螢幕直接存檔腳本 (標準通知版)

PATH="/usr/local/bin:/usr/bin:/bin"
export PATH

# 🗓️ 定義時間戳記檔名格式與儲存路徑
FILENAME="Screenshot_$(date +%Y%m%d_%H%M%S).png"
TARGET_DIR="/home/will/Pictures/screenshots"
ICON_PATH="/usr/share/icons/Adwaita/symbolic/legacy/applets-screenshooter-symbolic.svg"

# 📁 確保儲存資料夾存在
mkdir -p "$TARGET_DIR"

# 📷 1. 讓 grim 直接擷取全螢幕並拍進指定資料夾
if grim "$TARGET_DIR/$FILENAME"; then
    
    # 🔔 2. 截圖成功後，發送 Mako 標準通知
    # ❌ 沒加 -c volume（使用預設外觀）
    # 🔒 鎖死指定的 Adwaita 符號圖示
    notify-send -i "$ICON_PATH" -h string:x-canonical-private-synchronous:screenshot \
        "Screenshot" "Saved to ~/Pic./screenshots"
fi