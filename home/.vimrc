syntax on

nmap <C-u> :redo<CR>

set incsearch
set ignorecase
set smartcase
set expandtab
set tabstop=4
set shiftwidth=4
set ai                  " Always set auto-indenting on
set history=5000
set ruler               " Show the cursor position all the time
set number
" disable mouse once and for all
set mouse=

let g:pymode_lint_ignore="E501,E128"

set foldmethod=marker

if exists(':tnoremap')
    tnoremap <Esc> <C-\><C-n>
endif

autocmd BufWritePre * :%s/\s\+$//e

set nocompatible
filetype plugin indent on
syntax enable

hi Comment	cterm=bold		ctermfg=199
" hi Normal   ctermfg=white   ctermbg=none
" hi String   ctermfg=white   ctermbg=white
hi StatusLine     cterm=bold ctermfg=white ctermbg=198
hi StatusLineNC   cterm=bold ctermfg=white ctermbg=056
hi PreProc ctermfg=183
set cursorline
hi CursorLineNr   ctermfg=white ctermbg=056
hi LineNr         ctermfg=198
hi Statement      ctermfg=226
hi Identifier     cterm=bold ctermfg=159
hi Constant       ctermfg=183 guifg=#ffa0a0

autocmd BufRead,BufNewFile * syn match parens /[\$%^(){}\[\]]/ | hi parens ctermfg=201
autocmd BufRead,BufNewFile * syn match dots /[.:+*-/\\]/ | hi dots ctermfg=196 cterm=bold
autocmd BufRead,BufNewFile * syn match pydoc /""".*"""/ | hi pydoc ctermfg=199 cterm=bold
autocmd BufRead,BufNewFile * syn match pydoc2 /'''.*'''/ | hi pydoc2 ctermfg=199 cterm=bold
