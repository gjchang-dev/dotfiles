# 快捷鍵 Quick Start

> 給人看：這份 dotfiles 設定好的快捷鍵與自訂指令速查。最常用的放最上面，細節往下找。
> Mac 鍵盤的 F 鍵預設是媒體鍵，下面寫 `F2`、`F5` 的地方，在 Ghostty 裡要按 `Fn+F2`、`Fn+F5`。

## 最常用的 12 個

| 按鍵 / 指令 | 在哪裡 | 做什麼 |
|---|---|---|
| `practice` | Mac zsh | 開容器、接回 tmux 的 practice session |
| `Ctrl+a` | tmux | Prefix（下面寫 `Prefix X` 就是先按 `Ctrl+a`、放開、再按 `X`） |
| `Prefix \` / `Prefix -` | tmux | 左右 / 上下分割 |
| `Option+←/→` | tmux | 切換 window |
| `Prefix M` | tmux | 浮動視窗開 Mac 的 zsh（push、brew 用），`exit` 關掉 |
| `Ctrl+r` | shell | fzf 搜歷史指令 |
| `Ctrl+t` | shell | fzf 挑檔案插進命令列（`Tab` 多選） |
| `gt 字串` → `vil 檔案:行` | 容器 bash | 搜尋 → 直接開到那一行 |
| `F5` → `]q` / `[q` | vim | 編譯 → 逐筆跳錯誤 |
| `Ctrl+]` / `Ctrl+t` | vim | 跳到定義 / 跳回來 |
| `Ctrl+c` | vim | 註解 / 取消註解（可選取多行） |
| `Cmd+P` | VS Code | 快速開檔 |

---

## tmux（Prefix = `Ctrl+a`）

| 按鍵 | 作用 |
|---|---|
| `Prefix \` | 左右分割（新 pane 留在目前路徑） |
| `Prefix -` | 上下分割 |
| `Prefix c` | 新 window（practice 裡會自動進容器） |
| `Prefix C` | 新 window，**Mac 本機**的 zsh |
| `Prefix M` | 浮動視窗開 Mac 的 zsh，`exit` 或 `Ctrl+d` 關掉 |
| `Option+←` / `Option+→` | 上一個 / 下一個 window |
| `Prefix h/j/k/l` | 切到左 / 下 / 上 / 右的 pane（也可以直接用滑鼠點） |
| `Prefix H/J/K/L` | 調整 pane 大小，按一次 Prefix 後可以連按 |
| `Prefix z` | 目前 pane 放大到全螢幕 / 還原（tmux 內建） |
| `Prefix x` | 關掉目前 pane（tmux 內建，會先問） |
| `Prefix d` | detach，tmux 繼續在背景跑（tmux 內建） |
| `Prefix m` | 滑鼠模式開 / 關（關掉時可用 Ghostty 自己的選取） |
| `Prefix r` | 重新載入 `~/.tmux.conf` |
| `Ctrl+l` 再 `Prefix Ctrl+k` | 清畫面 + 清 scrollback（順序不能反） |

**複製到 Mac 剪貼簿**

| 方式 | 步驟 |
|---|---|
| 滑鼠 | 拖曳選取 → 放開就複製了 → `q` 離開 copy mode |
| 鍵盤 | `Prefix [` → 移動 → `v` 開始選 → `y` 複製（留在原地）→ `q` 離開 |

## Ghostty

| 按鍵 | 作用 |
|---|---|
| `Cmd+T` | 新分頁（Mac 本機 zsh，不在 tmux 裡） |
| `Cmd+Shift+,` | 重新載入 Ghostty 設定 |
| `Option` | 被設成 Alt：`Option+b/f/c/←/→` 都是送給終端機裡的程式 |

## vim

| 按鍵 / 指令 | 作用 |
|---|---|
| `Ctrl+c` | 註解 / 取消註解（c、cpp、sh、python、make、cmake、tmux、vim…） |
| `Ctrl+l` | 清掉搜尋高亮 |
| `F2` | paste 模式開 / 關 |
| `F4` | `:q` |
| `"` | 叫出暫存器側欄（peekaboo），`Esc` 關掉 |
| `yy` | 複製一行到 Mac 剪貼簿（Mac：brew vim 直接寫；容器：走 OSC 52） |
| `"_dd` | 刪一行但不動任何暫存器 / 剪貼簿 |
| `Ctrl+w w` | 在分割視窗之間切換（`Ctrl+w j/k` 往下 / 往上） |
| `r` 再按一個字 | 把游標下的字元換掉 |
| `:s/舊/新/` | 目前這一行取代 |

**編譯、跳錯誤（quickfix）**

| 按鍵 / 指令 | 作用 |
|---|---|
| `F5` | 存檔 → 編譯 → 跳到第一個錯誤。有 `build/CMakeCache.txt` 跑 `cmake --build build`，有 Makefile 跑 `make`，都沒有就編目前這個檔（`hello.c` → `hello`） |
| `]q` / `[q` | 下一個 / 上一個錯誤 |
| `:copen` / `:cclose` | 打開 / 關掉錯誤清單（清單裡按 Enter 跳過去） |
| `:!./hello` | 不離開 vim 直接執行程式 |

**讀 C 的 code（先在專案根目錄跑 `cs` 和 `ct`）**

| 按鍵 | 作用 |
|---|---|
| `Ctrl+]` / `Ctrl+t` | 跳到定義 / 跳回來 |
| `Ctrl+\ c` | **誰呼叫了**游標下的函式（結果進 quickfix，`:copen` 看清單） |
| `Ctrl+\ s` | 所有用到這個名稱的地方 |
| `Ctrl+\ g` | 跳到定義（cscope 版） |
| `Ctrl+\ t` | 搜尋這段文字 |
| `Ctrl+\ f` | 開游標下的檔名 |

## fzf

| 按鍵 | 在哪裡 | 作用 |
|---|---|---|
| `Ctrl+r` | shell | 搜歷史指令，Enter 放到命令列（不會直接執行） |
| `Ctrl+t` | shell | 挑檔案，路徑插在游標位置（例如先打 `vim ` 或 `git add `） |
| `Option+c` | shell | 挑資料夾，直接 cd 過去 |
| `Tab` / `Shift+Tab` | fzf 清單裡 | 勾選 / 取消，可以多選；打字篩選不會取消勾選 |
| `Enter` / `Esc` | fzf 清單裡 | 確定 / 取消 |

## Shell 按鍵（Mac zsh、容器 bash 都通用）

| 按鍵 | 作用 |
|---|---|
| `Option+b` / `Option+f` | 往前 / 往後跳一個字（`Ctrl+←/→` 被 macOS 拿去切桌面） |
| `Ctrl+w` / `Option+d` | 往前 / 往後刪一個字 |
| `Ctrl+a` / `Ctrl+e` | 跳到行首 / 行尾（在 tmux 裡 `Ctrl+a` 是 Prefix，要按兩次 `Ctrl+a`） |
| `Tab` / `Shift+Tab` | 容器 bash：在補全選項間循環 |
| `Ctrl+x Ctrl+r` | 容器 bash：重新讀 `~/.inputrc` |

## 容器 bash 的自訂指令

| 指令 | 作用 |
|---|---|
| `gt 字串` / `gtw 單字` | 用 ripgrep 搜尋，輸出 `檔案:行號:內容` |
| `vil 檔案:行號` | vim 直接開到那一行（gt、gcc 的輸出可以直接貼） |
| `ft 檔名` / `cdf 檔名` / `vif 檔名` | 找檔案 / cd 到它的資料夾 / 用 vim 開 |
| `rcd` → `cdr` | 記住目前路徑 → 在別的 pane 跳回來 |
| `gs` `gd` `gdc` `gl` `ga` `gc` `gcl` | git status / diff / diff --cached / log / add / checkout / clone |
| `gco` | fzf 挑分支切過去 |
| `gup [remote] [主分支]` | 看落後主分支幾個 commit，問要不要 rebase（主分支會自動判斷） |
| `gdu` `grc` `gss` `gssy` `gsu` | 衝突檔案 / rebase --continue / submodule status、sync、update |
| `ct` / `cs` | 產生 ctags / cscope 資料庫 |
| `ll` `la` `l` | ls 系列 |
| `sb` / `vb` | 重新載入 bashrc / 編輯 bashrc |
| `his` `ha` `hn` | 最近 50 筆歷史 / 寫入歷史檔 / 讀入其他 pane 的歷史 |

## VS Code（Mac）

| 按鍵 | 作用 |
|---|---|
| `Cmd+P` / `Cmd+Shift+P` | 快速開檔 / 指令面板 |
| `Cmd+1` | 焦點回編輯區（`Cmd+2`、`Cmd+3` 分割的第 2、3 組） |
| ``Ctrl+` `` | 編輯區 ↔ 終端機 |
| `Cmd+J` / `Cmd+B` | 下方面板 / 側邊欄 開關 |
| `Cmd+0` / `Cmd+Shift+E` | 焦點到側邊欄 / 檔案總管 |
| `Cmd+Shift+F` / `Cmd+Shift+G` | 全域搜尋 / git |
| `Cmd+W` | 關分頁（`Cmd+K W` 關這一組全部，`Cmd+K Cmd+W` 關全部） |
| `Cmd+Shift+T` | 重開剛關掉的分頁 |
| `Ctrl+Tab` | 切換分頁 |
| `Ctrl+-` / `Ctrl+Shift+-` | 游標跳回上一個 / 下一個位置 |
| `F5` | 編輯區：開始除錯；終端機：交給終端機裡的程式（例如 vim） |

## 環境操作

| 要做的事 | 怎麼做 |
|---|---|
| 改了 dotfiles 讓它生效 | bashrc：`sb`；inputrc：`Ctrl+x Ctrl+r`；tmux：`Prefix r`；Ghostty：`Cmd+Shift+,`；vim：重開 |
| Mac 要裝新工具 | 加進 `Brewfile` → `brew bundle --file=~/git/dotfiles/Brewfile` |
| 容器要裝新工具 | 加進 `embedded-practice/.devcontainer/devcontainer.json` 的 apt 清單 → Rebuild（不要手動 apt install） |
| Rebuild 之後 | practice 的 pane 會全部消失，重跑 `practice`；Reopen / 關掉 VS Code 不影響 practice |
| commit / push dotfiles | 在 Mac 上做（GitHub 登入在 Mac），tmux 裡用 `Prefix M` 開浮動視窗最快 |
| 換新電腦 | clone dotfiles 到 `~/git/dotfiles` → `brew bundle` → `bash install.sh` → clone embedded-practice → Reopen in Container |
