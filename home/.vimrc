filetype plugin indent on
syntax on

nmap <C-c> :set invpaste<CR>
inoremap <C-c> <ESC>:set invpaste<CR>i
vnoremap <C-c> <ESC>:set invpaste<CR>v

nmap <C-u> :redo<CR>

set expandtab
set tabstop=4
set shiftwidth=4
set ai                  " Always set auto-indenting on
set history=150
set ruler               " Show the cursor position all the time
set number

let g:pymode_lint_ignore="E501,E128"

set foldmethod=marker

if exists(':tnoremap')
    tnoremap <Esc> <C-\><C-n>
endif

autocmd BufWritePre * :%s/\s\+$//e
