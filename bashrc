# 給人看：個人 bash 設定，給 Dev Container 用（Mac 是 zsh，不讀這個檔）
# 不取代容器原本的 ~/.bashrc：postCreateCommand 會在它最後加一行 source 這個檔
# 這個檔會進 git，不放任何帳密、token

# 這個檔所在的 dotfiles 目錄（不寫死路徑，掛在哪裡都能用）
DOTFILES="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

export EDITOR=vim
export VISUAL=vim
HISTSIZE=10000
HISTFILESIZE=20000

# ========== 1. 一般 ==========
alias sb='source ~/.bashrc'
alias vb='vim "$DOTFILES/bashrc"'
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias v='vim'
alias vi='vim'
alias his='history 50'
alias ha='history -a'
alias hn='history -n'
alias cls='clear'
alias dn='dirname'
alias bn='basename'

# 記住目前路徑，之後在別的 pane 跳回來（舊名 go 會蓋掉 Go 語言的指令，改名 cdr）
alias rcd='pwd > ~/.saved_path'
alias cdr='cd "$(cat ~/.saved_path)"'

# ========== 2. 找檔案、搜尋 ==========
ft()  { find . -name "$1"; }
gt()  { grep -rn  --exclude=*.tags --exclude=*.html --exclude=*.map --exclude=*.patch --exclude=*.csv --exclude=*js --exclude=tags --exclude=*.out --exclude=*.xml --exclude=*.3 --exclude=*.tex "$1" .; }
gtw() { grep -rnw --exclude=*.tags --exclude=*.html --exclude=*.map --exclude=*.csv --exclude=*js --exclude=tags --exclude=*.out --exclude=*.files --exclude=*.yang "$1" .; }
cdf()  { cd "$(dirname "$(ft "$1")")"; }
cddn() { cd "$(dirname "$1")"; }
vif()  { vim $(ft "$1"); }

# vil 檔案:行號 → 直接開到那一行（gcc、grep -n 的輸出可以直接貼）
vil() {
    if [ -z "$1" ]; then
        echo "Usage: vil file:line"
        return 1
    fi
    local file line
    file=$(echo "$1" | cut -d: -f1)
    line=$(echo "$1" | cut -d: -f2)
    if [ "$file" = "$line" ]; then
        vim "$file"
    else
        vim +"$line" "$file"
    fi
}

# ========== 3. Git ==========
alias g='git'
alias gs='git status'
alias gd='git diff'
alias gdc='git diff --cached'
alias gl='git log'
alias ga='git add'
alias gc='git checkout'
alias gcl='git clone'
alias gdu='git diff --name-only --diff-filter=U'
alias grc='git rebase --continue'
alias gss='git submodule status'
alias gssy='git submodule sync'
alias gsu='git submodule update --init --recursive'

# gup：看目前分支落後 origin/master 幾個 commit，問要不要 rebase
#   用法：gup [remote] [主分支]，預設 origin master
gup() {
    local remote="${1:-origin}"
    local main_branch="${2:-master}"
    local current_branch behind ahead

    current_branch=$(git branch --show-current 2>/dev/null)
    if [ -z "$current_branch" ]; then
        echo "❌ 錯誤：目前不在任何 Git 分支或目錄中。"
        return 1
    fi

    if [ "$current_branch" = "$main_branch" ]; then
        echo "⚠️ 你目前就在 ${main_branch} 上，直接執行 git pull 即可。"
        git pull "$remote" "$main_branch"
        return 0
    fi

    echo "🔍 正在檢查 ${remote}/${main_branch} 最新狀態..."
    git fetch "$remote" "$main_branch" --quiet

    behind=$(git rev-list --count HEAD.."${remote}/${main_branch}")
    ahead=$(git rev-list --count "${remote}/${main_branch}"..HEAD)

    if [ "$behind" -eq 0 ]; then
        echo "✅ [STATUS] 你的分支 (${current_branch}) 已經是最新狀態！(Base on ${remote}/${main_branch})"
        [ "$ahead" -gt 0 ] && echo "   (領先 ${ahead} 個 commit，可以直接 Push / 送 PR)"
        return 0
    fi

    echo "------------------------------------------------"
    echo "⚠️  [WARNING] 遠端 ${remote}/${main_branch} 有新的提交！"
    echo "   當前分支 (${current_branch})：落後 ${behind} 個 commit | 超前 ${ahead} 個 commit"
    echo "------------------------------------------------"

    read -p "❓ 是否要對齊最新的 ${main_branch} 並自動 Rebase？ [y/N] " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🚀 開始執行 Rebase..."
        git fetch "$remote" "${main_branch}:${main_branch}" --quiet 2>/dev/null
        if git rebase "${remote}/${main_branch}"; then
            echo "🎉 Rebase 成功！目前分支與 local/remote ${main_branch} 皆已對齊最新。"
        else
            echo "💥 Rebase 遇到 Conflict！請解決衝突後執行 'git rebase --continue'。"
        fi
    else
        echo "⏭️  已取消 Rebase 操作。"
    fi
}

# gco：用 fzf 挑分支（local + remote）切過去
gco() {
    local branch
    branch=$(git branch --all | grep -v 'HEAD ->' | fzf +m | sed -E 's|remotes/origin/||' | sed 's/^[* ]*//')
    if [ -n "$branch" ]; then
        git checkout "$branch"
    fi
}

# ========== 4. C/C++ 讀 code（ctags、cscope 由 devcontainer.json 安裝）==========
alias ct='ctags --languages=Asm,C,C++ -R'
alias cs='find . -name "*.c" -o -name "*.h" -o -name "*.cpp" > cscope.files && cscope -Rbq -i cscope.files'

# ========== 5. fzf（第 9 步建的檔；還沒有就跳過）==========
[ -f "$DOTFILES/fzf/fzf.bash" ] && source "$DOTFILES/fzf/fzf.bash"