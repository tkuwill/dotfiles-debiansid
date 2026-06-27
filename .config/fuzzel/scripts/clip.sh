#!/bin/sh
# Description: 專屬 Debian (Dash 相容) 的 Fuzzel 剪貼板歷史選單

PATH="/usr/local/bin:/usr/bin:/bin"
export PATH

# 🎯 完美沿用您最習慣的 50寬/20高 置中層級配置
cliphist list | fuzzel -a center -w 50 -l 20 --layer=overlay -d -p "Clipboard " | cliphist decode | wl-copy
