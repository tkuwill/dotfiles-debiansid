#!/bin/sh
# Description: A script to choose screenshot type and edit with swappy.
# 🎯 專屬 Debian (Dash 相容) Fuzzel + Swappy 互動式截圖後製選單

PATH="/usr/local/bin:/usr/bin:/bin"
export PATH

ICON_PATH="/usr/share/icons/Adwaita/symbolic/legacy/applets-screenshooter-symbolic.svg"

# 🗓️ 用標準 printf 替代 echo -e，完美相容 Dash 選單
options="Cancel\nFull-screenshot\nSelect a region for screenshot"
selected=$(printf "%b" "$options" | fuzzel --layer=overlay -d -p "Take a screenshot then edit it ! ")

case "$selected" in
    "Full-screenshot")
        # 📷 全螢幕截圖並直接餵給 swappy
        if grim - | swappy -f -; then
            notify-send -i "$ICON_PATH" -h string:x-canonical-private-synchronous:screenshot \
                "Screenshot" "Saved to ~/Pic./Editedshots/."
        fi
        ;;
    "Select a region for screenshot")
        # ✂️ 區域截圖並直接餵給 swappy
        if grim -g "$(slurp -d)" - | swappy -f -; then
            notify-send -i "$ICON_PATH" -h string:x-canonical-private-synchronous:screenshot \
                "Screenshot" "Saved to ~/Pic./Editedshots/."
        fi
        ;;
    "Cancel"|*)
        # 🚪 選擇取消或直接按下 Esc 則優雅退出
        exit 0
        ;;
esac