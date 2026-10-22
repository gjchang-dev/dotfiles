# 給人看：Mac zsh 的個人設定。install.sh 會在 ~/.zshrc 最後加一行 source 這個檔
# ~/.zshrc 本身不進 git（裡面有 practice function 這類只屬於這台 Mac 的設定）
# 這個檔會進 git，不放任何帳密、token

# 這個檔所在的 dotfiles 目錄（:A 解開 symlink、:h 取資料夾）
DOTFILES="${0:A:h}"

# ========== 1. bash、zsh 共用的 alias 與函式（ll、gt、vil、gup、gco…）==========
source "$DOTFILES/shell/common.sh"

# ========== 2. zsh 專用 ==========
alias sb='source ~/.zshrc'
alias vb='vim "$DOTFILES/zshrc"'
# zsh 的 history 50 是「從第 50 筆開始列」，要最近 50 筆得寫 -50
alias his='history -50'

# ========== 3. tmux（只開在 Mac 上）==========
alias tml='tmux ls'
# tma [session]：接回 tmux session；不給名稱就用 fzf 挑
# 已經在 tmux 裡面時改用 switch-client 切過去，避免 tmux 裡面再套一層 tmux
tma() {
    local s="$1"
    if [ -z "$s" ]; then
        s=$(tmux ls -F '#S' 2>/dev/null | fzf --prompt='tmux session > ') || return
    fi
    if [ -n "$TMUX" ]; then
        tmux switch-client -t "$s"
    else
        tmux attach -t "$s"
    fi
}

# ========== 4. fzf ==========
source "$DOTFILES/fzf/fzf.zsh"
