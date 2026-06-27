#!/bin/sh
# 完全相容 Dash 且徹底解決「not found」路徑問題的終極版本

ICON_MUSIC="applications-multimedia"

# 🎯 核心修正 1：強行把所有可能存放指令的路徑通通灌進去
PATH="/usr/local/bin:/usr/bin:/bin:/usr/games:$HOME/.local/bin"
export PATH

now_play() {
    playerctl metadata --format "{{ title }} \n{{ artist }} - {{ album }}"
}

urls() {
    # 🎯 核心修正 2：如果單純寫 cliphist 找不到，我們就用全路徑去撈
    # 先用標準的 cliphist 配合 sed 抓第一行並解碼
    _url=$(cliphist list 2>/dev/null | sed '1 q' | cliphist decode 2>/dev/null)
    
    # 🎯 核心修正 3：萬一 cliphist 真的在背景鬧脾氣，改用 Wayland 原生的 wl-paste 當無敵後備
    if [ -z "$_url" ]; then
        _url=$(wl-paste -n 2>/dev/null)
    fi
    
    echo "$_url"
}

turls() { urls; }
burls() { urls; }

player() {
    options="Cancel\nPlay-pause\nNext\nPrev\nNow_playing\nOpen_with_mpv_Yt\nYt live\nTwitch live\nOpen_with_mpv_BiliBili\nBLive"
    
    selected=$(printf "$options" | fuzzel --layer=overlay -d -p "playerctl ")
    
    if [ -z "$selected" ] || [ "$selected" = "Cancel" ]; then 
        return
    fi

    # 提取完整網址
    TARGET_URL=$(urls)

    # 安全機制：如果網址是空的，跳出白底 Mako 通知提醒
    case "$selected" in
        Open_with_mpv_Yt|Yt*|Twitch*|*BiliBili|BLive)
            if [ -z "$TARGET_URL" ]; then
                notify-send -i "$ICON_MUSIC" -u critical "剪貼簿是空的！" "請先複製網址後再執行選單。"
                return
            fi
            ;;
    esac

    # 執行多媒體指令
    if [ "$selected" = "Play-pause" ]; then 
        playerctl play-pause    
    elif [ "$selected" = "Next" ]; then 
        playerctl next
    elif [ "$selected" = "Prev" ]; then 
        playerctl previous
    elif [ "$selected" = "Now_playing" ]; then 
        notify-send -i "$ICON_MUSIC" -t 5000 "目前播放項目" "$(now_play)"
    elif [ "$selected" = "Open_with_mpv_Yt" ]; then 
        mpv "$TARGET_URL"
    elif [ "$selected" = "Yt live" ]; then 
        mpv --cache=no "$TARGET_URL"
    elif [ "$selected" = "Twitch live" ]; then 
        streamlink -p mpv -a '--no-cache' "$TARGET_URL" 1080p60
    elif [ "$selected" = "Open_with_mpv_BiliBili" ]; then 
        yt-dlp --cookies-from-browser firefox -o - "$TARGET_URL" | mpv -
    elif [ "$selected" = "BLive" ]; then 
        yt-dlp --cookies-from-browser firefox -o - "$TARGET_URL" | mpv --no-cache -
    fi
}

player
