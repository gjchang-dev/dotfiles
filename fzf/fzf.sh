# 給人看：fzf 共用設定，Mac（zsh）和容器（bash）都會 source
# 只放環境變數，不放按鍵綁定（按鍵綁定的寫法 bash 和 zsh 不一樣，分別放在 fzf.bash / fzf.zsh）

# 每次叫出 fzf 的外觀：只佔畫面下方 40%、選項由上往下排、加外框、筆數顯示在同一行
export FZF_DEFAULT_OPTS='--height=40% --layout=reverse --border --info=inline'