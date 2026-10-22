" 給人看：vim 設定，Mac 與容器共用。install.sh 會 symlink 到 ~/.vimrc
" 外掛清單寫在這裡；外掛程式碼裝在 ~/.vim/plugged（不進 git）

" 關掉 Vi 相容模式。用 vim -u 指定這個檔時 vim 不會自動關，<F2>、<C-c> 這類 mapping 會全部失效
" 必須放在最前面：切換這個選項會重設很多其他設定
if &compatible
 set nocompatible
endif

" ========================================
" 1. 外掛（vim-plug）
" ========================================
" plug.vim 由 install.sh 下載；還沒裝時整段跳過，避免一開 vim 就報錯
if filereadable(expand('~/.vim/autoload/plug.vim'))
  call plug#begin('~/.vim/plugged')
  Plug 'junegunn/vim-peekaboo'
  call plug#end()
endif

" ========================================
" 2. 顏色與顯示
" ========================================
set t_Co=256
syntax on
set background=dark
colorscheme evening

" 背景透明、修正選取顏色（必須在 colorscheme 之後）
highlight Normal     ctermbg=none
highlight LineNr     ctermbg=none
highlight SignColumn ctermbg=none
highlight Visual     ctermbg=239 ctermfg=none

if &diff
  highlight DiffAdd    cterm=none ctermfg=112 ctermbg=235
  highlight DiffDelete cterm=none ctermfg=197 ctermbg=235
  highlight DiffChange cterm=none ctermfg=214 ctermbg=235
  highlight DiffText   cterm=bold ctermfg=15  ctermbg=238
endif

" ========================================
" 3. 基礎設定
" ========================================
set number
set norelativenumber
set laststatus=2
set backspace=indent,eol,start

" 剪貼簿：vim 有編進剪貼簿功能才開（Mac 的 brew vim 有；容器的 vim 沒有，改走 OSC 52）
if has('clipboard')
  set clipboard=unnamedplus
endif

" tmux 裡也啟用 bracketed paste，貼上程式碼時不會被自動縮排弄亂
if &term =~ 'screen\|tmux'
  let &t_BE = "\e[?2004h"
  let &t_BD = "\e[?2004l"
  exec "set t_PS=\e[200~"
  exec "set t_PE=\e[201~"
endif

" 重開檔案時跳回上次游標的位置
augroup RestoreCursor
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END

" 縮排
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent
filetype plugin indent on
augroup FileTypeIndent
  autocmd!
  autocmd FileType make setlocal noexpandtab tabstop=8 shiftwidth=8
augroup END

" ========================================
" 4. 快捷鍵（F2 paste、F4 離開、Ctrl+c 註解、Ctrl+l 清高亮）
" ========================================
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
nnoremap <F4> :q<CR>

function! ToggleComment()
  let l:s = {'c': '// ', 'cpp': '// ', 'java': '// ', 'kotlin': '// ',
        \ 'python': '# ', 'sh': '# ', 'zsh': '# ', 'make': '# ', 'cmake': '# ',
        \ 'tmux': '# ', 'conf': '# ', 'ruby': '# ', 'vim': '" '}
  if !has_key(l:s, &filetype) | return | endif
  let l:symbol = l:s[&filetype]
  let l:pat = '^\(\s*\)' . escape(l:symbol, '\.*^$~[]')
  let l:line = getline('.')
  if l:line =~ l:pat
    call setline('.', substitute(l:line, l:pat, '\1', ''))
  else
    call setline('.', substitute(l:line, '^\(\s*\)', '\1' . escape(l:symbol, '\&~'), ''))
  endif
endfunction

nnoremap <silent> <C-c> :call ToggleComment()<CR>
vnoremap <silent> <C-c> :call ToggleComment()<CR>
nnoremap <silent> <C-l> :nohlsearch<CR><C-l>

" ========================================
" 5. 搜尋
" ========================================
set hlsearch
set incsearch
set ignorecase
set smartcase