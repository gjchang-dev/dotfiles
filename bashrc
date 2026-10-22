# 給人看：個人 bash 設定，給 Dev Container 用（Mac 是 zsh，讀的是 zshrc）
# 不取代容器原本的 ~/.bashrc：install.sh 會在它最後加一行 source 這個檔
# 這個檔會進 git，不放任何帳密、token

# 這個檔所在的 dotfiles 目錄（不寫死路徑，掛在哪裡都能用）
DOTFILES="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

HISTSIZE=10000
HISTFILESIZE=20000

# 歷史記錄存到 /commandhistory（devcontainer.json 掛進來的 named volume），Rebuild 後還在
# 沒有掛這個 volume 的環境就沿用預設的 ~/.bash_history
if [ -d /commandhistory ] && [ -w /commandhistory ]; then
    export HISTFILE=/commandhistory/.bash_history
fi
shopt -s histappend
# 每打完一個指令就馬上寫進檔案：practice 同時開好幾個 pane 時，關掉 shell 才不會互相蓋掉
case "$PROMPT_COMMAND" in
    *"history -a"*) ;;
    *) PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}" ;;
esac

# ========== 1. bash、zsh 共用的 alias 與函式（ll、gt、vil、gup、gco…）==========
source "$DOTFILES/shell/common.sh"

# ========== 2. bash 專用 ==========
alias sb='source ~/.bashrc'
alias vb='vim "$DOTFILES/bashrc"'
alias his='history 50'
alias ha='history -a'
alias hn='history -n'

# ========== 3. C/C++ 讀 code（ctags、cscope 由 devcontainer.json 安裝）==========
alias ct='ctags --languages=Asm,C,C++ -R'
alias cs='find . -name "*.c" -o -name "*.h" -o -name "*.cpp" > cscope.files && cscope -Rbq -i cscope.files'

# ========== 4. fzf（沒裝 fzf 就跳過）==========
[ -f "$DOTFILES/fzf/fzf.bash" ] && source "$DOTFILES/fzf/fzf.bash"
