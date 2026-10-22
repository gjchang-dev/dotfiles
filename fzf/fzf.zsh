# 給人看：Mac 的 zsh 載入 fzf（由 ~/.zshrc source）
(( $+commands[fzf] )) || return 0

source "${0:A:h}/fzf.sh"

# Ctrl+r 搜歷史、Ctrl+t 找檔案、Alt+c 跳資料夾（需要 fzf 0.48 以上，brew 版是 0.74）
source <(fzf --zsh)