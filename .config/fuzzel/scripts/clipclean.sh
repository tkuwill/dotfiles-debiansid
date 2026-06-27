#!/bin/sh
# Description: 專屬 Debian 的 Fuzzel / cliphist 剪貼簿清空腳本

PATH="/usr/local/bin:/usr/bin:/bin"
export PATH

# 1. 🎯 徹底清空 cliphist 的歷史紀錄資料庫
cliphist wipe

# 2. 🧹 同步刷洗目前 Wayland 系統活動中的剪貼簿內容（文字與圖片全部清空）
wl-copy --clear
wl-copy --primary --clear

# 3. 🔔 發送 Mako 俐落通知（可選，讓您在電視大螢幕上能明確確認已清空）
# 這裡沿用 -c volume，這樣它就會乖乖套用您調校好的 815px 置中面板，格式非常整齊
notify-send -c volume -h string:x-canonical-private-synchronous:clip-clear \
    "剪貼簿管理" "歷史紀錄與目前快取已全數清空"