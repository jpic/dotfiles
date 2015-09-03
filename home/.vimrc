" Pathogen load
filetype off

runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()

filetype plugin indent on
syntax on
colorscheme desert

map .s :setlocal spell! spelllang=en_us<cr>
map .sf :setlocal spell! spelllang=fr_fr<cr>
map .se :setlocal spell! spelllang=es_es<cr>

nmap <C-c> :set invpaste<CR>
inoremap <C-c> <ESC>:set invpaste<CR>i
vnoremap <C-c> <ESC>:set invpaste<CR>v

nmap <S-u> :undo<CR>
nmap <C-u> :redo<CR>

set expandtab
set tabstop=4
set shiftwidth=4
set ai                  " Always set auto-indenting on
set history=50          " keep 50 lines of command history
set ruler               " Show the cursor position all the time
set number


let g:pymode_lint_ignore="E501,E128"

map <C-q> :call DWM_Close()<CR>

set foldmethod=marker
