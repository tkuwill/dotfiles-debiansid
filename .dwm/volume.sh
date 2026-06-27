#!/bin/sh
# Debian Dash (sh) 相容：寫死 Adwaita SVG 圖示路徑的 50 格音量腳本

# 🎯 核心修正：將 Adwaita 圖示絕對路徑寫死
ICON_HIGH="/usr/share/icons/Adwaita/symbolic/status/audio-volume-high-symbolic.svg"
ICON_LOW="/usr/share/icons/Adwaita/symbolic/status/audio-volume-low-symbolic.svg"
ICON_MUTE="/usr/share/icons/Adwaita/symbolic/status/audio-volume-muted-symbolic.svg"

PATH="/usr/local/bin:/usr/bin:/bin"
export PATH

# 擷取音量與靜音狀態
get_audio_info() {
    _info=$(amixer sget Master)
    if [ "$1" = "volume" ]; then
        echo "$_info" | tail -n 1 | awk -F'[][]' '{ print $2 }' | tr -d '%'
    elif [ "$1" = "status" ]; then
        if echo "$_info" | grep -q '\[off\]'; then
            echo "muted"
        else
            echo "on"
        fi
    fi
}

# 50 格音量條繪製邏輯
make_bar() {
    _vol=$1
    _filled=$((_vol / 2))
    _empty=$((50 - _filled))
    _bar=""
    
    _i=0; while [ "$_i" -lt "$_filled" ]; do _bar="${_bar}■"; _i=$((_i + 1)); done
    _j=0; while [ "$_j" -lt "$_empty" ]; do _bar="${_bar}□"; _j=$((_j + 1)); done
    
    echo "$_bar"
}

# 執行音量調整 (每次 2%)
case "$1" in
    up)
        amixer sset Master 2%+ unmute >/dev/null
        ;;
    down)
        amixer sset Master 2%- unmute >/dev/null
        ;;
    toggle)
        amixer sset Master toggle >/dev/null
        ;;
    *)
        echo "使用方法: $0 {up|down|toggle}"
        exit 1
        ;;
esac

CURRENT_VOL=$(get_audio_info volume)
MUTE_STATUS=$(get_audio_info status)

# 🔔 判斷並發送帶有寫死圖示路徑的 Mako 通知
if [ "$MUTE_STATUS" = "muted" ] || [ "$CURRENT_VOL" -eq 0 ]; then
    MUTE_BAR="✕ □□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□"
    notify-send -i "$ICON_MUTE" -c volume -h string:x-canonical-private-synchronous:volume \
        "音量狀態" "【已靜音】 $MUTE_BAR"
else
    BAR_STR=$(make_bar "$CURRENT_VOL")
    
    # 🎯 額外小優化：音量小於 40% 時顯示低音量圖示，大於 40% 顯示高音量圖示
    if [ "$CURRENT_VOL" -le 40 ]; then
        ACTIVE_ICON="$ICON_LOW"
    else
        ACTIVE_ICON="$ICON_HIGH"
    fi
    
    notify-send -i "$ACTIVE_ICON" -c volume -h string:x-canonical-private-synchronous:volume \
        "目前音量: ${CURRENT_VOL}%" "$BAR_STR"
fi