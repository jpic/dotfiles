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

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
" call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
call vundle#begin('~/.config/vundle')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'

Plugin 'tomasr/molokai'

Plugin 'davidhalter/jedi-vim'

Plugin 'chase/vim-ansible-yaml'
            \ , {'autoload': {'filetypes': ['yaml', 'ansible']} }

Plugin 'chrisbra/sudoedit.vim', {
            \ 'autoload': {'commands': ['SudoWrite', 'SudoRead']} }

Plugin 'vim-scripts/LargeFile'

Plugin 'bling/vim-airline'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"
"
syntax enable
colorscheme molokai
