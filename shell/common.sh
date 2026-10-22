# 給人看：bash（容器）和 zsh（Mac）共用的 alias 與函式，由 bashrc、zshrc source
# 這裡只能寫兩邊都支援的語法；只屬於某一邊的放回 bashrc / zshrc
# 這個 repo 是公開的：不放帳密、token

export EDITOR=vim
export VISUAL=vim

# ========== 1. 一般 ==========
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias v='vim'
alias vi='vim'
alias cls='clear'
alias dn='dirname'
alias bn='basename'

# 記住目前路徑，之後在別的 pane 跳回來（舊名 go 會蓋掉 Go 語言的指令，改名 cdr）
alias rcd='pwd > ~/.saved_path'
alias cdr='cd "$(cat ~/.saved_path)"'

# ========== 2. 找檔案、搜尋 ==========
ft()  { find . -name "$1"; }
# gt 搜字串、gtw 只搜完整單字。有 rg 就用 rg（自動跳過 .gitignore、隱藏檔、二進位檔），沒有就退回 grep
if command -v rg >/dev/null 2>&1; then
    gt()  { rg -n  --no-heading --glob '!tags' --glob '!cscope.*' "$1"; }
    gtw() { rg -nw --no-heading --glob '!tags' --glob '!cscope.*' "$1"; }
else
    gt()  { grep -rn  --exclude-dir=.git --exclude=tags --exclude='cscope.*' "$1" .; }
    gtw() { grep -rnw --exclude-dir=.git --exclude=tags --exclude='cscope.*' "$1" .; }
fi
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

# gup：看目前分支落後主分支幾個 commit，問要不要 rebase
#   用法：gup [remote] [主分支]；不給主分支就自動判斷（remote 的 HEAD → main → master）
gup() {
    local remote="${1:-origin}"
    local main_branch="${2:-}"
    local current_branch behind ahead

    # 沒指定主分支就自動判斷：先看 remote 的 HEAD 指向哪裡，沒有的話看 remote 上有沒有 main，再不然用 master
    if [ -z "$main_branch" ]; then
        main_branch=$(git symbolic-ref --quiet --short "refs/remotes/${remote}/HEAD" 2>/dev/null)
        main_branch="${main_branch#"${remote}"/}"
        if [ -z "$main_branch" ]; then
            if git show-ref --verify --quiet "refs/remotes/${remote}/main"; then
                main_branch=main
            else
                main_branch=master
            fi
        fi
    fi

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
    if ! git fetch "$remote" "$main_branch" --quiet; then
        echo "❌ 抓不到 ${remote}/${main_branch}，檢查 remote 名稱和分支名稱（用法：gup [remote] [主分支]）"
        return 1
    fi

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

    printf '❓ 是否要對齊最新的 %s 並自動 Rebase？ [y/N] ' "$main_branch"
    # 讀一個字元：zsh 用 -k 1，bash 用 -n 1（bash 的 read -p 在 zsh 裡是別的意思，不能共用）
    if [ -n "${ZSH_VERSION:-}" ]; then
        read -r -k 1 REPLY
    else
        read -r -n 1 REPLY
    fi
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
