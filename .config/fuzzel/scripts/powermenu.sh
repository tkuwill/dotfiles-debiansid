#!/bin/sh
# 100% 適用於 Debian Dash 語法，且完全調用系統內建的標準圖示

# --- 系統預設標準圖示名稱與絕對路徑定義 ---
ICON_SHUTDOWN="/usr/share/icons/Adwaita/symbolic/actions/system-shutdown-symbolic.svg"
ICON_REBOOT="/usr/share/icons/Adwaita/symbolic/actions/system-reboot-symbolic.svg"

CMD_SHUTDOWN="/usr/sbin/shutdown"
CMD_REBOOT="/usr/sbin/reboot"
CMD_SYSTEMCTL="/usr/bin/systemctl"

ck() {
    date "+%T"
}

powermenu() {
    options="Cancel\nCancelShutdownOrRestart\nLock\nSuspend\nShutdown\nRestart"
    selected=$(printf "$options" | fuzzel --layer=overlay -d -p "What do you want to do ? ")
    
    if [ "$selected" = "Shutdown" ]; then 
        # 修改點：通知改為提醒用絕對路徑的 shutdown -c 取消
        notify-send -i "$ICON_SHUTDOWN" -u critical -t 0 "Now time is $(ck). ASUS 'll be shutdown in 1 min. Use 'shutdown -c' to cancel."
        # 修改點：改用絕對路徑的 shutdown 指令，+1 代表延遲 1 分鐘
        $CMD_SHUTDOWN +1 "ASUS 將在 1 分鐘後關機"
        
    elif [ "$selected" = "Restart" ]; then 
        # 修改點：通知改為提醒用絕對路徑的 shutdown -c 取消
        notify-send -i "$ICON_REBOOT" -u critical -t 0 "Computer will be rebooted in 1 min. Use 'shutdown -c' to cancel."
        # 修改點：改用絕對路徑的 shutdown -r 指令（-r 代表重啟），+1 代表延遲 1 分鐘
        $CMD_SHUTDOWN -r +1 "ASUS 將在 1 分鐘後重啟"
        
    elif [ "$selected" = "Suspend" ]; then 
        sleep 1s && $CMD_SYSTEMCTL suspend
        
    elif [ "$selected" = "Lock" ]; then
        # 註：如果 swaylock 找不到，也可以考慮視情況補上絕對路徑（如 /usr/bin/swaylock）
        swaylock
        
    elif [ "$selected" = "CancelShutdownOrRestart" ]; then
        # 修改點：發出取消成功的通知，並調用 shutdown -c 清除所有關機或重啟排程
        notify-send -u critical -t 0 "Procedure has been CANCELLED"
        $CMD_SHUTDOWN -c
        
    elif [ "$selected" = "Cancel" ] || [ -z "$selected" ]; then 
        return
    fi
}

# 執行函式
powermenu
