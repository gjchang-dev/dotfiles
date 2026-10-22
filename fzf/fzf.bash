# 給人看：容器的 bash 載入 fzf（由 dotfiles/bashrc source）
command -v fzf >/dev/null 2>&1 || return 0

source "$(dirname "${BASH_SOURCE[0]}")/fzf.sh"

# Ctrl+r 搜歷史、Ctrl+t 找檔案、Alt+c 跳資料夾
# fzf 0.48 以後用 fzf --bash；Ubuntu 24.04 的 apt 版是 0.44，改讀套件附的檔案
if fzf --bash >/dev/null 2>&1; then
    eval "$(fzf --bash)"
elif [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
    source /usr/share/doc/fzf/examples/key-bindings.bash
fi