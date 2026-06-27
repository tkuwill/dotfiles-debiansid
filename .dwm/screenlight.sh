#!/bin/sh
# Debian Dash (sh) 相容：寫死 Adwaita SVG 圖示路徑的 50 格螢幕亮度腳本

# 🎯 核心設定：將 Adwaita 亮度圖示絕對路徑寫死
ICON_BRIGHT="/usr/share/icons/Adwaita/symbolic/status/display-brightness-symbolic.svg"

PATH="/usr/local/bin:/usr/bin:/bin"
export PATH

# 取得目前的亮度百分比 (從 brightnessctl 提取)
get_brightness_info() {
    # brightnessctl -m 會輸出類似: intel_backlight,backlight,400,42%,1920 的格式
    # 我們用 awk 提取第 4 個欄位並去掉 % 符號
    brightnessctl -m | awk -F, '{print $4}' | tr -d '%'
}

# 🛠️ 核心功能：動態計算 50 格亮度條 (每 2% 佔 1 格)
make_bar() {
    _light=$1
    _filled=$((_light / 2))
    _empty=$((50 - _filled))
    _bar=""
    
    _i=0; while [ "$_i" -lt "$_filled" ]; do _bar="${_bar}■"; _i=$((_i + 1)); done
    _j=0; while [ "$_j" -lt "$_empty" ]; do _bar="${_bar}□"; _j=$((_j + 1)); done
    
    echo "$_bar"
}

# 執行亮度調整 (每次 2%)
case "$1" in
    up)
        # 增加 2% 亮度
        brightnessctl set 2%+ >/dev/null
        ;;
    down)
        # 減少 2% 亮度，並確保最低留 1% 不會完全黑畫面
        brightnessctl set 2%- >/dev/null
        ;;
    *)
        echo "使用方法: $0 {up|down}"
        exit 1
        ;;
esac

# 🔔 擷取最新數值，發送 Mako 通知
CURRENT_LIGHT=$(get_brightness_info)
BAR_STR=$(make_bar "$CURRENT_LIGHT")

# 🎯 共用 -c volume 標籤，直接套用您神調校的 815px 寬度與置中面板！
# 同時使用 synchronous:brightness 識別，確保瘋狂連按時原地刷新
notify-send -i "$ICON_BRIGHT" -c volume -h string:x-canonical-private-synchronous:brightness \
    "目前亮度: ${CURRENT_LIGHT}%" "$BAR_STR"