# 1. 環境變數優先
# 移除了 MacPorts 的路徑，保留 Linux 標準的 local 二進位檔路徑
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
export LANG="en_US.UTF-8"

# 1.1 載入秘密環境變數 (GitHub Token 等)
if [ -f ~/.secrets ]; then
    source ~/.secrets
fi

# 1.2 將 SSH 金鑰加入代理
# 修正：拿掉 Mac 特有的 --apple-use-keychain，改用標準 Linux 的 ssh-add
if [ -f ~/.ssh/id_ed25519 ]; then
    ssh-add ~/.ssh/id_ed25519 2>/dev/null
fi

# 2. 歷史紀錄 設定 ---
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=99999
setopt HIST_IGNORE_ALL_DUPS  # 不記錄重複指令
setopt share_history         # 不同視窗同步紀錄

# 使用 zshaddhistory 函式來精確過濾不想紀錄的指令
zshaddhistory() {
    # 使用正規表達式匹配你不想紀錄的指令
    if [[ "$1" =~ "^(ls|cd|pwd|exit|la|bye|gitui|musicDownloadTui|tmux| )" ]]; then
        return 1
    fi
    return 0
}

# 3. 初始化補全系統 (放在外掛之前)
zstyle ':completion:*' menu yes select
autoload -Uz compinit && compinit

# 3.1 載入 fzf 的補全功能與按鍵綁定
# 修正：路徑改為 Debian 官方套件的標準路徑
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh

# 4. 外掛載入 (Debian 官方套件路徑)
# 修正：將路徑從 /opt/local/share 改為 Debian 的 /usr/share
[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# 5. 初始化工具
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"  # 整合您之前提到的 starship 提示字元

# 6. Prompt 設定
# 註記：因為啟用了 starship，原本的 vcs_info 與 PROMPT 變數已交由 starship 接管
# 如果未來想換回您原本的簡約風格，只需註解掉上方的 starship 行，並解開下方的註解：
# autoload -Uz vcs_info
# precmd() { vcs_info }
# zstyle ':vcs_info:git:*' formats 'on branch %b %m%u%c'
# setopt promptsubst
# PROMPT='%F{20}%~ %F{13}${vcs_info_msg_0_}%f
# %F{6}%#%f '

# 7. 按鍵綁定
bindkey -e
bindkey "^D" delete-char-or-list
unsetopt IGNORE_EOF

# 8. Alias
# 修正：Mac 的 ls 顏色參數是 -G，Linux (GNU) 的顏色參數是 --color=auto
alias la="ls --color=auto -la"
alias ll="ls --color=auto -l"
# alias grip='python -m grip'
alias vpnLocation="curl ipinfo.io/country"
alias musicDownloadTui="~/ShellScripts/musicDownloadTui.sh"

# 讓 Ctrl-X Ctrl-E 可以編輯長指令
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# Let debian can use shutdown directly in terminal
export PATH=$PATH:/usr/sbin:/sbin
