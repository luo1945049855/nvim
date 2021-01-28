" init.vim for VsCode

"*****************************************************************************
"" Vim-Plug core
"*****************************************************************************

" Required:
call plug#begin(expand('~/.config/nvim/plugged'))

"*****************************************************************************
"" Plug install packages
"*****************************************************************************
Plug 'mg979/vim-visual-multi'
Plug 'Lokaltog/vim-easymotion'

call plug#end()

" 定义快捷键的前缀，即 <Leader>

let mapleader=";"

" >>
" vim 自身（非插件）快捷键
" >>

" 设置快捷键将选中文本块复制至系统剪贴板
vnoremap <Leader>y "+y
" 设置快捷键将系统剪贴板内容粘贴至vim
nmap <Leader>p "+p

" >>
" map VSCode 快捷键
" >>

" Vim-commentary
wxmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine
