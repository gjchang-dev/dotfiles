#!/usr/bin/env bash
# 給人看：把 dotfiles 裡的設定接到家目錄。Mac 和 Dev Container 都跑這一支
#   Mac：手動跑一次  bash /Users/gj/git/dotfiles/install.sh
#   容器：devcontainer.json 的 postCreateCommand 每次 Rebuild 自動跑
# 重複跑沒關係：已經接好的會跳過，不會重複加行
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"   # Darwin = Mac，Linux = 容器

# link 來源 目的地：建 symlink；目的地已經有別的檔案就先改名備份，不直接蓋掉
link() {
    local src="$1" dest="$2"
    if [ "$(readlink "$dest" 2>/dev/null)" = "$src" ]; then
        echo "  已接好  $dest"
        return
    fi
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        local bak="$dest.bak.$(date +%Y%m%d-%H%M%S)"
        mv "$dest" "$bak"
        echo "  已備份  $dest -> $bak"
    fi
    mkdir -p "$(dirname "$dest")"
    ln -s "$src" "$dest"
    echo "  新建    $dest -> $src"
}

# append_once 檔案 那一行：檔案裡還沒有這一行才加到最後
append_once() {
    local file="$1" line="$2"
    touch "$file"
    if grep -qxF "$line" "$file"; then
        echo "  已存在  $file 裡的 source"
    else
        printf '\n# dotfiles（由 install.sh 加入）\n%s\n' "$line" >> "$file"
        echo "  已加入  $file 最後一行"
    fi
}

echo "== 共用：vim"
link "$DOTFILES/vimrc" "$HOME/.vimrc"

if [ "$OS" = "Darwin" ]; then
    echo "== Mac：tmux、Ghostty、zsh 載入 fzf"
    link "$DOTFILES/tmux.conf"      "$HOME/.tmux.conf"
    link "$DOTFILES/ghostty/config" "$HOME/.config/ghostty/config"
    append_once "$HOME/.zshrc" "source \"$DOTFILES/fzf/fzf.zsh\""
else
    echo "== 容器：inputrc、bash 載入 bashrc"
    link "$DOTFILES/inputrc" "$HOME/.inputrc"
    # 不取代容器原本的 ~/.bashrc，只在最後接上自己的設定
    append_once "$HOME/.bashrc" "source \"$DOTFILES/bashrc\""
fi

echo "== vim 外掛"
PLUG="$HOME/.vim/autoload/plug.vim"
if [ ! -s "$PLUG" ] && ! curl -fsSLo "$PLUG" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; then
    rm -f "$PLUG"
    echo "  ⚠️ vim-plug 下載失敗（網路不通？），先略過外掛；vim 本身照常能用，之後重跑這支即可"
else
    # -es：不開畫面的批次模式（容器 Rebuild 時沒有終端機也能跑）
    vim -es -u "$HOME/.vimrc" -i NONE -c 'PlugInstall --sync' -c 'qa' || true
    echo "  外掛：$(ls "$HOME/.vim/plugged" 2>/dev/null | tr '\n' ' ')"
fi

echo "== 完成"